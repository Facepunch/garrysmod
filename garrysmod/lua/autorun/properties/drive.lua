
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
		
		return true 

	end,

	Action = function( self, ent )
	
		self:MsgStart()
			net.WriteEntity( ent )
		self:MsgEnd()
		
	end,

	Receive = function( self, length, player )

		local ent = net.ReadEntity()
		if ( !self:Filter( ent, player ) ) then return false end

		local drivemode = "drive_sandbox"

		if ( ent.GetEntityDriveMode ) then
			drivemode = ent:GetEntityDriveMode( player )
		end

		if ( !drivemode ) then  end
		

		drive.PlayerStartDriving( player, ent, drivemode )
		
	end	

} )
