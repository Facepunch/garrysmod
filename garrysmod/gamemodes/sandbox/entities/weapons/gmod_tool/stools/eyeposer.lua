
TOOL.Category = "Poser"
TOOL.Name = "#tool.eyeposer.name"

TOOL.Information = {
	{ name = "left" },
	{ name = "left_use" },
	{ name = "right" },
	{ name = "reload" },
}

TOOL.ClientConVar[ "x" ] = "0"
TOOL.ClientConVar[ "y" ] = "0"
TOOL.ClientConVar[ "strabismus" ] = "0"

local function SetEyeTarget( ply, ent, data )

	if ( data.EyeTarget ) then ent:SetEyeTarget( data.EyeTarget ) end

	if ( SERVER ) then
		if ( data.EyeTarget == vector_origin ) then
			duplicator.ClearEntityModifier( ent, "eyetarget" )
		else
			duplicator.StoreEntityModifier( ent, "eyetarget", data )
		end
	end

end
if ( SERVER ) then
	duplicator.RegisterEntityModifier( "eyetarget", SetEyeTarget )
end

local function ConvertRelativeToEyesAttachment( ent, pos )

	if ( ent:IsNPC() ) then return pos end

	-- Convert relative to eye attachment
	local eyeattachment = ent:LookupAttachment( "eyes" )
	if ( eyeattachment == 0 ) then return end

	local attachment = ent:GetAttachment( eyeattachment )
	if ( !attachment ) then return end

	return WorldToLocal( pos, angle_zero, attachment.Pos, attachment.Ang )

end

function TOOL:CalculateEyeTarget()

	local x = math.Remap( self:GetClientNumber( "x" ), 0, 1, -1, 1 )
	local y = math.Remap( self:GetClientNumber( "y" ), 0, 1, -1, 1 )
	local fwd = Angle( y * 45, x * 45, 0 ):Forward()
	local s = math.Clamp( self:GetClientNumber( "strabismus" ), -1, 1 )
	local distance = 1000

	if ( s < 0 ) then
		s = math.Remap( s, -1, 0, 0, 1 )
		distance = distance * math.pow( 10000, s - 1 )
	elseif ( s > 0 ) then
		distance = distance * -math.pow( 10000, -s )
	end

	-- Gotta do this for NPCs...
	local ent = self:GetSelectedEntity()
	if ( IsValid( ent ) and ent:IsNPC() ) then
		local eyeattachment = ent:LookupAttachment( "eyes" )
		if ( eyeattachment == 0 ) then return fwd * distance end

		local attachment = ent:GetAttachment( eyeattachment )
		if ( !attachment ) then return fwd * distance end

		return LocalToWorld( fwd * distance, angle_zero, attachment.Pos, attachment.Ang )
	end

	return fwd * distance

end

function TOOL:GetSelectedEntity()
	return self:GetWeapon():GetNWEntity( "eyeposer_ent" )
end

function TOOL:SetSelectedEntity( ent )

	if ( !IsValid( ent ) ) then self:SetOperation( 0 ) end

	if ( IsValid( ent ) and ent:GetClass() == "prop_effect" ) then ent = ent.AttachedEntity end
	return self:GetWeapon():SetNWEntity( "eyeposer_ent", ent )
end

-- Selects entity and aims their eyes
function TOOL:LeftClick( trace )

	if ( self:GetOwner():KeyDown( IN_USE ) ) then
		return self:MakeLookAtMe( trace )
	end

	if ( !IsValid( self:GetSelectedEntity() ) or self:GetOperation() != 1 ) then

		self:SetSelectedEntity( trace.Entity )
		if ( !IsValid( self:GetSelectedEntity() ) ) then return false end

		local eyeAtt = self:GetSelectedEntity():LookupAttachment( "eyes" )
		if ( eyeAtt == 0 ) then
			self:SetSelectedEntity( NULL )
			return false
		end

		self:SetOperation( 1 ) -- For UI

		return true

	end

	local selectedEnt = self:GetSelectedEntity()

	self:SetSelectedEntity( NULL )
	self:SetOperation( 0 )

	if ( !IsValid( selectedEnt ) ) then return false end

	local LocalPos = ConvertRelativeToEyesAttachment( selectedEnt, trace.HitPos )
	if ( !LocalPos ) then return false end

	SetEyeTarget( self:GetOwner(), selectedEnt, { EyeTarget = LocalPos } )

	return true

end

-- Select the eyes for posing through UI
function TOOL:RightClick( trace )

	local hadEntity = IsValid( self:GetSelectedEntity() )

	self:SetSelectedEntity( trace.Entity )
	if ( !IsValid( self:GetSelectedEntity() ) ) then return hadEntity end

	local eyeAtt = self:GetSelectedEntity():LookupAttachment( "eyes" )
	if ( eyeAtt == 0 ) then
		self:SetSelectedEntity( NULL )
		return false
	end

	-- TODO: Reset? Save and load these raw values from the entity modifier?
	--RunConsoleCommand( "eyeposer_x", 0.5 )
	--RunConsoleCommand( "eyeposer_y", 0.5 )
	--RunConsoleCommand( "eyeposer_strabismus", 0 )

	self:SetOperation( 2 ) -- For UI

	return true

end

-- Makes the eyes look at the player
function TOOL:MakeLookAtMe( trace )

	self:SetSelectedEntity( NULL )
	self:SetOperation( 0 )

	local ent = trace.Entity
	if ( IsValid( ent ) and ent:GetClass() == "prop_effect" ) then ent = ent.AttachedEntity end
	if ( !IsValid( ent ) ) then return false end

	if ( CLIENT ) then return true end

	local pos = self:GetOwner():EyePos()

	local LocalPos = ConvertRelativeToEyesAttachment( ent, pos )
	if ( !LocalPos ) then return false end

	SetEyeTarget( self:GetOwner(), ent, { EyeTarget = LocalPos } )

	return true

end

-- Reset eye position
function TOOL:Reload( trace )

	self:SetSelectedEntity( NULL )
	self:SetOperation( 0 )

	local ent = trace.Entity
	if ( IsValid( ent ) and ent:GetClass() == "prop_effect" ) then ent = ent.AttachedEntity end
	if ( !IsValid( ent ) ) then return false end

	if ( CLIENT ) then return true end

	SetEyeTarget( self:GetOwner(), ent, { EyeTarget = vector_origin } )

	return true

end

local validEntityLast = false
function TOOL:Think()

	local ent = self:GetSelectedEntity()

	-- If we're on the client just make sure the context menu is up to date
	if ( CLIENT ) then
		if ( IsValid( ent ) == validEntityLast ) then return end

		validEntityLast = IsValid( ent )
		self:RebuildControlPanel( validEntityLast )

		return
	end

	if ( !IsValid( ent ) ) then self:SetOperation( 0 ) return end

	if ( self:GetOperation() != 2 ) then return end

	-- On the server we continually set the eye position
	SetEyeTarget( self:GetOwner(), ent, { EyeTarget = self:CalculateEyeTarget() } )

end

-- The rest of the code is clientside only, it is not used on server
if ( SERVER ) then return end

local SelectionRing = surface.GetTextureID( "gui/faceposer_indicator" )

-- Draw a box indicating the face we have selected
function TOOL:DrawHUD()

	local selected = self:GetSelectedEntity()
	if ( !IsValid( selected ) ) then return end

	local eyeattachment = selected:LookupAttachment( "eyes" )
	if ( eyeattachment == 0 ) then return end

	local attachment = selected:GetAttachment( eyeattachment )
	local scrpos = attachment.Pos:ToScreen()
	if ( !scrpos.visible ) then return end

	if ( self:GetOperation() == 1 ) then

		-- Get Target
		local trace = self:GetOwner():GetEyeTrace()

		-- Clientside preview
		local LocalPos = ConvertRelativeToEyesAttachment( selected, trace.HitPos )
		if ( LocalPos ) then
			selected:SetEyeTarget( LocalPos )
		end

		-- Try to get each eye position.. this is a real guess and won't work on non-humans
		local Leye = ( attachment.Pos + attachment.Ang:Right() * 1.5 ):ToScreen()
		local Reye = ( attachment.Pos - attachment.Ang:Right() * 1.5 ):ToScreen()

		-- TODO: make the line look less like ass
		local scrhit = trace.HitPos:ToScreen()
		local x = scrhit.x
		local y = scrhit.y

		surface.SetDrawColor( 0, 0, 0, 100 )
		surface.DrawLine( Leye.x - 1, Leye.y + 1, x - 1, y + 1 )
		surface.DrawLine( Leye.x - 1, Leye.y - 1, x - 1, y - 1 )
		surface.DrawLine( Leye.x + 1, Leye.y + 1, x + 1, y + 1 )
		surface.DrawLine( Leye.x + 1, Leye.y - 1, x + 1, y - 1 )
		surface.DrawLine( Reye.x - 1, Reye.y + 1, x - 1, y + 1 )
		surface.DrawLine( Reye.x - 1, Reye.y - 1, x - 1, y - 1 )
		surface.DrawLine( Reye.x + 1, Reye.y + 1, x + 1, y + 1 )
		surface.DrawLine( Reye.x + 1, Reye.y - 1, x + 1, y - 1 )

		surface.SetDrawColor( 0, 255, 0, 255 )
		surface.DrawLine( Leye.x, Leye.y, x, y )
		surface.DrawLine( Leye.x, Leye.y - 1, x, y - 1 )
		surface.DrawLine( Reye.x, Reye.y, x, y )
		surface.DrawLine( Reye.x, Reye.y - 1, x, y - 1 )

	end

	if ( self:GetOperation() == 2 ) then

		-- Clientside preview
		--selected:SetEyeTarget( self:CalculateEyeTarget() )

		-- Work out the side distance to give a rough headsize box..
		local player_eyes = LocalPlayer():EyeAngles()
		local side = ( attachment.Pos + player_eyes:Right() * 20 ):ToScreen()
		local size = math.abs( side.x - scrpos.x )

		-- Draw the selection ring
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetTexture( SelectionRing )
		surface.DrawTexturedRect( scrpos.x - size, scrpos.y - size, size * 2, size * 2 )

	end

end

function TOOL.BuildCPanel( CPanel, hasEntity )

	CPanel:Help( "#tool.eyeposer.desc" )

	if ( hasEntity ) then

		-- Panel for Slider ( limiting edge )
		local SliderBackground = vgui.Create( "DPanel", CPanel )
		SliderBackground:Dock( TOP )
		SliderBackground:SetTall( 225 )
		CPanel:AddItem( SliderBackground )

		-- 2 axis slider for the eye position
		local EyeSlider = vgui.Create( "DSlider", SliderBackground )
		EyeSlider:Dock( FILL )
		EyeSlider:SetLockY()
		EyeSlider:SetSlideX( 0.5 )
		EyeSlider:SetSlideY( 0.5 )
		EyeSlider:SetTrapInside( true )
		EyeSlider:SetConVarX( "eyeposer_x" )
		EyeSlider:SetConVarY( "eyeposer_y" )
		-- Draw the 'button' different from the slider
		EyeSlider.Knob.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "Button", panel, w, h ) end

		function EyeSlider:Paint( w, h )
			local knobX, knobY = self.Knob:GetPos()
			local knobW, knobH = self.Knob:GetSize()
			surface.SetDrawColor( 0, 0, 0, 250 )
			surface.DrawLine( knobX + knobW / 2, knobY + knobH / 2, w / 2, h / 2 )
			surface.DrawRect( w / 2 - 2, h / 2 - 2, 5, 5 )
		end

		CPanel:NumSlider( "#tool.eyeposer.strabismus", "eyeposer_strabismus", -1, 1 )

	end

	CPanel:NumSlider( "#tool.eyeposer.size_eyes", "r_eyesize", -0.5, 2 )
	CPanel:ControlHelp( "#tool.eyeposer.size_eyes.help" )

end
