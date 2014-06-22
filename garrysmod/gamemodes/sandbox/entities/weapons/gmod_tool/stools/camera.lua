
TOOL.Category = "Render"
TOOL.Name = "#tool.camera.name"

TOOL.ClientConVar[ "locked" ] = "0"
TOOL.ClientConVar[ "key" ] = "37"
TOOL.ClientConVar[ "toggle" ] = "1"

cleanup.Register( "cameras" )

local function MakeCamera( ply, key, locked, toggle, Data )
	
	local ent = ents.Create( "gmod_cameraprop" )

	if ( !IsValid( ent ) ) then return end

	duplicator.DoGeneric( ent, Data )

	if ( key ) then
		for id, camera in pairs( ents.FindByClass( "gmod_cameraprop" ) ) do
			if ( camera.controlkey && camera.controlkey == key ) then
				camera:Remove()
			end
		end

		ent:SetKey( key )
		ent.controlkey = key
	end

	ent:SetPlayer( ply )

	ent.toggle = toggle
	ent.locked = locked

	ent:Spawn()

	ent:SetTracking( NULL, Vector( 0 ) )
	ent:SetLocked( locked )

	if ( toggle == 1 ) then
		numpad.OnDown( ply, key, "Camera_Toggle", ent )
	else
		numpad.OnDown( ply, key, "Camera_On", ent )
		numpad.OnUp( ply, key, "Camera_Off", ent )
	end

	if ( IsValid( ply ) ) then

		undo.Create( "Camera" )
			undo.AddEntity( ent )
			undo.SetPlayer( ply )
		undo.Finish()

		ply:AddCleanup( "cameras", ent )

	end

	return ent

end
duplicator.RegisterEntityClass( "gmod_cameraprop", MakeCamera, "controlkey", "locked", "toggle", "Data" )

function TOOL:LeftClick( trace )

	local key = self:GetClientNumber( "key" )
	if ( key == -1 ) then return false end

	if ( CLIENT ) then return true end

	local ply = self:GetOwner()
	local locked = self:GetClientNumber( "locked" )
	local toggle = self:GetClientNumber( "toggle" )
	local pid = ply:UniqueID()

	local ent = MakeCamera( ply, key, locked, toggle, { Pos = trace.StartPos, Angle = ply:EyeAngles() } )
	
	return true, ent

end

function TOOL:RightClick( trace )

	local _, camera = self:LeftClick( trace, true )
	
	if ( CLIENT ) then return true end

	if ( !IsValid( camera ) ) then return end
	
	if ( trace.Entity:IsWorld() ) then
	
		trace.Entity = self:GetOwner()
		trace.HitPos = self:GetOwner():GetPos()
	
	end

	camera:SetTracking( trace.Entity, trace.Entity:WorldToLocal( trace.HitPos ) )
	
	return true
	
end

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Numpad", { Label = "#tool.camera.key", Command = "camera_key" } )
	CPanel:AddControl( "CheckBox", { Label = "#tool.camera.static", Command = "camera_locked", Help = true } )
	CPanel:AddControl( "CheckBox", { Label = "#tool.toggle", Command = "camera_toggle" } )

end
