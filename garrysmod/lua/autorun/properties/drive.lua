
AddCSLuaFile()

properties.Add( "drive", {
	MenuLabel = "#drive",
	Order = 1100,
	MenuIcon = "icon16/joystick.png",

	Filter = function( self, ent, ply )

		if ( !IsValid( ent ) || !IsValid( ply ) ) then return false end
		if ( ent:IsPlayer() || IsValid( ply:GetVehicle() ) ) then return false end
		if ( !gamemode.Call( "CanProperty", ply, "drive", ent ) ) then return false end
		if ( !gamemode.Call( "CanDrive", ply, ent ) ) then return false end

		-- We cannot drive these, maybe this should have a custom GetEntityDriveMode?
		if ( ent:GetClass() == "prop_vehicle_jeep" || ent:GetClass() == "prop_vehicle_jeep_old" ) then return false end

		return true

	end,

	Action = function( self, ent )

		self:MsgStart()
			net.WriteEntity( ent )
		self:MsgEnd()

	end,

	Receive = function( self, length, ply )

		local ent = net.ReadEntity()
		if ( !properties.CanBeTargeted( ent, ply ) ) then return end
		if ( !self:Filter( ent, ply ) ) then return end

		local drivemode = "drive_sandbox"

		if ( ent.GetEntityDriveMode ) then
			drivemode = ent:GetEntityDriveMode( ply )
		end

		drive.PlayerStartDriving( ply, ent, drivemode )

	end

} )
