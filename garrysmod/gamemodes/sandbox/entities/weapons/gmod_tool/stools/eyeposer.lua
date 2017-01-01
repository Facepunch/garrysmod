
TOOL.Category = "Poser"
TOOL.Name = "#tool.eyeposer.name"

TOOL.Information = {
	{ name = "left" },
	{ name = "right" }
}

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

	local LocalPos, LocalAng = WorldToLocal( pos, Angle( 0, 0, 0 ), attachment.Pos, attachment.Ang )

	return LocalPos

end

-- Selects entity and aims their eyes
function TOOL:LeftClick( trace )

	if ( !self.SelectedEntity ) then
		if ( !IsValid( trace.Entity ) ) then return end

		self.SelectedEntity = trace.Entity

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
function TOOL:RightClick( trace )

	self:GetWeapon():SetNWEntity( 0, NULL )
	self.SelectedEntity = nil

	if ( !IsValid( trace.Entity ) ) then return end
	if ( CLIENT ) then return true end

	local pos = self:GetOwner():EyePos()

	local LocalPos = ConvertRelativeToEyesAttachment( trace.Entity, pos )
	if ( !LocalPos ) then return false end

	SetEyeTarget( self:GetOwner(), trace.Entity, { EyeTarget = LocalPos } )

	return true

end

-- The rest of the code is clientside only, it is not used on server
if ( SERVER ) then return end

-- Draw a box indicating the face we have selected
function TOOL:DrawHUD()

	local selected = self:GetWeapon():GetNWEntity( 0 )

	if ( !IsValid( selected ) ) then return end

	local vEyePos = selected:EyePos()

	local eyeattachment = selected:LookupAttachment( "eyes" )
	if ( eyeattachment == 0 ) then return end

	local attachment = selected:GetAttachment( eyeattachment )
	local scrpos = attachment.Pos:ToScreen()
	if ( !scrpos.visible ) then return end

	-- Try to get each eye position.. this is a real guess and won't work on non-humans
	local Leye = ( attachment.Pos + attachment.Ang:Right() * 1.5 ):ToScreen()
	local Reye = ( attachment.Pos - attachment.Ang:Right() * 1.5 ):ToScreen()

	-- Work out the side distance to give a rough headsize box..
	local player_eyes = LocalPlayer():EyeAngles()
	local side = ( attachment.Pos + player_eyes:Right() * 10 ):ToScreen()
	local size = 4

	local Owner = self:GetOwner()

	-- Get Target
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

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Description = "#tool.eyeposer.desc" } )

end
