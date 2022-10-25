
TOOL.Category = "Poser"
TOOL.Name = "#tool.eyeposer.name"

TOOL.Information = {
	{ name = "left" },
	{ name = "right" },
	{ name = "reload" }
}

if ( CLIENT ) then
	CreateClientConVar( "eye_x", "0", false, false )
	CreateClientConVar( "eye_y", "0", false, false )
	CreateClientConVar( "eye_z", "360", false, false )
	CreateClientConVar( "eye_strabismus" , "false", false, false )
else	
	util.AddNetworkString( "EyeMouseClickSide" )
end

local eye_x = GetConVar( "eye_x" )
local eye_y = GetConVar( "eye_y" )
local eye_z = GetConVar( "eye_z" )
local eye_strabismus = GetConVar( "eye_strabismus" )

local function SetEyeTarget( Player, Entity, Data )

	if ( Data.EyeTarget ) then Entity:SetEyeTarget( Data.EyeTarget ) end

	if ( SERVER ) then
		duplicator.StoreEntityModifier( Entity, "eyetarget", Data )
	end

end
duplicator.RegisterEntityModifier( "eyetarget", SetEyeTarget )

local function ConvertRelativeToEyesAttachment( ent, pos )

	if ( ent:IsNPC() ) then return pos end

	-- Convert relative to eye attachment
	local eyeattachment = ent:LookupAttachment( "eyes" )
	if ( eyeattachment == 0 ) then return end
	local attachment = ent:GetAttachment( eyeattachment )
	if ( !attachment ) then return end

	local LocalPos = WorldToLocal( pos, angle_zero, attachment.Pos, attachment.Ang )

	return LocalPos

end

-- Selects entity and aims their eyes
function TOOL:LeftClick( trace )

	if ( !self.SelectedEntity ) then
		if ( SERVER ) then
			net.Start( "EyeMouseClickSide" )
			net.WriteString( "Left" )
			net.Send( self:GetOwner() )
		end	

		local ent = trace.Entity
		if ( IsValid( ent ) && ent:GetClass() == "prop_effect" ) then ent = ent.AttachedEntity end

		if ( !IsValid( ent ) ) then return end

		self.SelectedEntity = ent

		local eyeattachment = self.SelectedEntity:LookupAttachment( "eyes" )
		if ( eyeattachment == 0 ) then return end

		self:GetWeapon():SetNWEntity( 0, self.SelectedEntity )

		return true

	end

	local selectedent = self.SelectedEntity
	self.SelectedEntity = nil
	self:GetWeapon():SetNWEntity( 0, NULL )

	if ( !IsValid( selectedent ) ) then return end

	local LocalPos = ConvertRelativeToEyesAttachment( selectedent, trace.HitPos )
	if ( !LocalPos ) then return false end

	SetEyeTarget( self:GetOwner(), selectedent, { EyeTarget = LocalPos } )

	return true

end

-- Makes the eyes look as per the position of the dot on the Panel
function TOOL:RightClick( trace )  

	if ( !self.SelectedEntity ) then
		if ( SERVER ) then
			net.Start( "EyeMouseClickSide" )
			net.WriteString( "Right" )
			net.Send( self:GetOwner() )
		end	

		local ent = trace.Entity
		if ( IsValid( ent ) && ent:GetClass() == "prop_effect" ) then ent = ent.AttachedEntity end

		if ( !IsValid( ent ) ) then return end

		self.SelectedEntity = ent

		local eyeattachment = self.SelectedEntity:LookupAttachment( "eyes" )
		if ( eyeattachment == 0 ) then return end

		self:GetWeapon():SetNWEntity( 0, self.SelectedEntity )

		return true

	end

	local selectedent = self.SelectedEntity
	self.SelectedEntity = nil
	self:GetWeapon():SetNWEntity( 0, NULL )

	if ( !IsValid( selectedent ) ) then return end

	local LocalPos = ConvertRelativeToEyesAttachment( selectedent, trace.HitPos )
	if ( !LocalPos ) then return false end

	SetEyeTarget( self:GetOwner(), selectedent, { EyeTarget = LocalPos } )

	return true

end

-- Makes the eyes look at the player
function TOOL:Reload( trace )

	self:GetWeapon():SetNWEntity( 0, NULL )
	self.SelectedEntity = nil

	local ent = trace.Entity
	if ( IsValid( ent ) && ent:GetClass() == "prop_effect" ) then ent = ent.AttachedEntity end

	if ( !IsValid( ent ) ) then return end
	if ( CLIENT ) then return true end

	local pos = self:GetOwner():EyePos()

	local LocalPos = ConvertRelativeToEyesAttachment( ent, pos )
	if ( !LocalPos ) then return false end

	SetEyeTarget( self:GetOwner(), ent, { EyeTarget = LocalPos } )

	return true

end

-- The rest of the code is clientside only, it is not used on server
if ( SERVER ) then return end

local FacePoser = surface.GetTextureID( "gui/faceposer_indicator" )
local EyeMouseClickSide

net.Receive( "EyeMouseClickSide", function( len )
     local message = net.ReadString()
     EyeMouseClickSide = message
end )

-- Draw a box indicating the face we have selected
function TOOL:DrawHUD()

	local selected = self:GetWeapon():GetNWEntity( 0 )

	if ( !IsValid( selected ) ) then return end

	local eyeattachment = selected:LookupAttachment( "eyes" )
	if ( eyeattachment == 0 ) then return end

	local attachment = selected:GetAttachment( eyeattachment )
	local scrpos = attachment.Pos:ToScreen()
	if ( !scrpos.visible ) then return end

	if ( EyeMouseClickSide == "Left" ) then	

		-- Try to get each eye position.. this is a real guess and won't work on non-humans
		local Leye = ( attachment.Pos + attachment.Ang:Right() * 1.5 ):ToScreen()
		local Reye = ( attachment.Pos - attachment.Ang:Right() * 1.5 ):ToScreen()

		-- Get Target
		local Owner = self:GetOwner()
		local trace = Owner:GetEyeTrace()
		local scrhit = trace.HitPos:ToScreen()
		local x = scrhit.x
		local y = scrhit.y

		local LocalPos = ConvertRelativeToEyesAttachment( selected, trace.HitPos )
		selected:SetEyeTarget( LocalPos )

		-- Todo, make look less like ass

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
		surface.DrawLine( Reye.x, Reye.y, x, y )
		surface.DrawLine( Leye.x, Leye.y - 1, x, y - 1 )
		surface.DrawLine( Reye.x, Reye.y - 1, x, y - 1 )

	end

	if ( EyeMouseClickSide == "Right" ) then

		local PanelPos  = Vector(eye_z:GetInt(), eye_x:GetInt(), eye_y:GetInt())		
		selected:SetEyeTarget( PanelPos )
		
		local pos = selected:GetPos()

		-- Work out the side distance to give a rough headsize box..
		local player_eyes = LocalPlayer():EyeAngles()
		local side = ( attachment.Pos + player_eyes:Right() * 20 ):ToScreen()
		local size = math.abs( side.x - scrpos.x )

		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetTexture( FacePoser )
		surface.DrawTexturedRect( scrpos.x - size, scrpos.y - size, size * 2, size * 2 )

	end

end

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Description = "#tool.eyeposer.desc" } )	

	-- Panel for Slider ( limiting edge )
	local PanelSlider = vgui.Create( "DPanel", CPanel )
	PanelSlider:SetPos( 19, 50 )
	PanelSlider:SetSize( 225, 225 )

	-- Slider '3D'
	local Slider = vgui.Create( "DSlider", PanelSlider )
	Slider:SetPos( 7, 7 )
	Slider:SetSize( 211, 211 )
	Slider:SetLockY( nil )	
	-- Draw the 'button' different from the slider
	Slider.Knob.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "Button", panel, w, h ) end

	-- Moving the '3D button' manipulates the eyes of the selected entity
	Slider.TranslateValues = function( Slider, x, y )
		if ( eye_strabismus:GetBool() == false ) then
			RunConsoleCommand( "eye_x", (x-0.5)*720 )
			RunConsoleCommand( "eye_y", (y-0.5)*-720 )					
		else
			RunConsoleCommand( "eye_x", (x-0.5)*6 )
			RunConsoleCommand( "eye_y", (y-0.5)*-6 )
		end

		-- Draw the Line between the '3D button' and the center of the square
		function Slider:Paint( w, h )								
			local Knob_X, Knob_Y = Slider.Knob:GetPos()
			surface.SetDrawColor( 0, 0, 0, 250 )
			surface.DrawLine( Knob_X + 7, Knob_Y + 7, w/2, h/2 )	
			surface.DrawRect( w/2 - 1, h/2-1, 4, 4 )	
		end

		return x, y

	end	
		
	-- When pressing MOUSE_MIDDLE the position of the button returns to the default (center)
	Slider.Knob.OnMousePressed = function( panel, mcode )
		if ( mcode == MOUSE_MIDDLE ) then
			Slider:SetSlideX( "0.5" )
			Slider:SetSlideY( "0.5" )
			RunConsoleCommand( "eye_x", 0.5 )
			RunConsoleCommand( "eye_y", 0.5 )
			return
		end
		Slider:OnMousePressed( mcode )
	end

	-- Slider: Strabismus - eye_z
	local SliderStrabismus = vgui.Create( "DNumSlider", CPanel )
	SliderStrabismus:SetPos( 19, 280 )
	SliderStrabismus:SetSize( 40, 25 )
	SliderStrabismus:SetMinMax( -5, 5 )
	SliderStrabismus:SetDecimals( 0 )
	SliderStrabismus:SetWide( 255 )
	SliderStrabismus:SetConVar( "eye_z" )
	SliderStrabismus:SetDefaultValue( "0" )	
	SliderStrabismus:SetDark( true )
	SliderStrabismus.Slider:SetEnabled( false )
	SliderStrabismus.Label:SetVisible( false ) 

	-- Checkbox:Strabismus
	CheckBoxStrabismus = vgui.Create( "DCheckBoxLabel", SliderStrabismus )
	CheckBoxStrabismus:SetText( "#tool.eyeposer.strabismus" )
	CheckBoxStrabismus:SetConVar( "eye_strabismus" )
	CheckBoxStrabismus:SetValue( false )
	CheckBoxStrabismus:SetDark( true )
	CheckBoxStrabismus:SetWide( 80 )
	CheckBoxStrabismus:Dock( LEFT )
	
	function CheckBoxStrabismus:OnChange( val )
		if ( val ) then
			RunConsoleCommand( "eye_x", 0 )
			RunConsoleCommand( "eye_y", 0 )
			RunConsoleCommand( "eye_z", "2" )
			Slider:SetSlideX( "0.5" )
			Slider:SetSlideY( "0.5" )
			SliderStrabismus.Slider:SetSlideX( "0.7" )
			SliderStrabismus:SetEnabled( true )

		else
			RunConsoleCommand( "eye_x", 0 )
			RunConsoleCommand( "eye_y", 0 )
			RunConsoleCommand( "eye_z", "360" )
			Slider:SetSlideX( "0.5" )
			Slider:SetSlideY( "0.5" )
			SliderStrabismus.Slider:SetSlideX( "360" )
			SliderStrabismus:SetEnabled( false )

		end
	end
	
	-- Slider Size Eyes / r_eyesize
	local Slider_r_eyesize = vgui.Create( "DNumSlider", CPanel )
	Slider_r_eyesize:SetText( "#tool.eyeposer.size_eyes" )
	Slider_r_eyesize:SetConVar( "r_eyesize" )	
	Slider_r_eyesize:SetMinMax( -0.5 , 10 )
	Slider_r_eyesize:SetDefaultValue( "0" )	
	Slider_r_eyesize:SetDecimals( 1 )
	Slider_r_eyesize:SetPos( 19, 315 )
	Slider_r_eyesize:SetSize( 37, 25 )
	Slider_r_eyesize:SetWide( 255 )
	Slider_r_eyesize:SetDark( true )
	
end