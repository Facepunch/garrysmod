
TOOL.Category = "Poser"
TOOL.Name = "#tool.eyeposer.name"

local function ConvertRelativeToEyesAttachment( Entity, Pos )

	if ( Entity:IsNPC() ) then
		return Pos
	end

	-- Convert relative to eye attachment
	local eyeattachment = Entity:LookupAttachment( "eyes" )
	if ( eyeattachment == 0 ) then return end
	local attachment = Entity:GetAttachment( eyeattachment )
	if ( !attachment ) then return end
	
	local LocalPos, LocalAng = WorldToLocal( Pos, Angle( 0, 0, 0 ), attachment.Pos, attachment.Ang )
	
	return LocalPos

end

--[[---------------------------------------------------------
	Selects entity and aims their eyes
-----------------------------------------------------------]]
function TOOL:LeftClick( trace )

	if ( !self.SelectedEntity ) then
	
		if ( !IsValid( trace.Entity ) ) then return end
	
		self.SelectedEntity = trace.Entity
		
		local eyeattachment = self.SelectedEntity:LookupAttachment( "eyes" )
		if ( eyeattachment == 0 ) then return end
		
		self:GetWeapon():SetNetworkedEntity( 0, self.SelectedEntity )

	return true end

	local selectedent = self.SelectedEntity
	self.SelectedEntity = nil
	self:GetWeapon():SetNetworkedEntity( 0, NULL )
	
	if ( !IsValid( selectedent ) ) then return end
	
	local LocalPos = ConvertRelativeToEyesAttachment( selectedent, trace.HitPos )
	if ( !LocalPos ) then return false end
	
	selectedent:SetEyeTarget( LocalPos )
	
	return true

end

--[[---------------------------------------------------------
	Makes the eyes look at the player
-----------------------------------------------------------]]
function TOOL:RightClick( trace )

	self:GetWeapon():SetNetworkedEntity( 0, NULL )
	self.SelectedEntity = nil
	
	if ( !IsValid( trace.Entity ) ) then return end
	if ( CLIENT ) then return true end
	
	local pos = self:GetOwner():EyePos()
	
	local LocalPos = ConvertRelativeToEyesAttachment( trace.Entity, pos )
	if ( !LocalPos ) then return false end
	
	trace.Entity:SetEyeTarget( LocalPos )
	
	return true
	
end

if ( CLIENT ) then

	--[[---------------------------------------------------------
		Draw a box indicating the face we have selected
	-----------------------------------------------------------]]
	function TOOL:DrawHUD()
	
		local selected = self:GetWeapon():GetNetworkedEntity( 0 )
		
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
		local tr = util.GetPlayerTrace( Owner )
		local trace = util.TraceLine( tr )
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

end

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Description = "#tool.eyeposer.desc" } )

end
