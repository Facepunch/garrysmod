
AddCSLuaFile()

if ( SERVER ) then

	CreateConVar( "sensor_debugragdoll", "0", FCVAR_NOTIFY )
	CreateConVar( "sensor_stretchragdoll", "0", FCVAR_NOTIFY )

end

properties.Add( "motioncontrol_ragdoll", {
	MenuLabel = "#control_with_motion_sensor",
	Order = 2500,
	MenuIcon = "icon16/controller.png",

	Filter = function( self, ent, ply )

		if ( CLIENT && !motionsensor ) then return false end
		if ( CLIENT && !motionsensor.IsAvailable() ) then return false end
		if ( !ent:IsRagdoll() ) then return false end
		if ( !gamemode.Call( "CanProperty", ply, "motioncontrol_ragdoll", ent ) ) then return false end

		return true

	end,

	Action = function( self, ent )

		self:MsgStart()
			net.WriteEntity( ent )
		self:MsgEnd()

		--
		-- Start up the kinect controller. This will freeze the game for a second.
		--
		if ( !motionsensor.IsActive() ) then
			motionsensor.Start()
		end

	end,

	Receive = function( self, length, player )

		local ent = net.ReadEntity()
		if ( !self:Filter( ent, player ) ) then return end

		local ragdoll_motion = ents.Create( "ragdoll_motion" )
		ragdoll_motion:SetPos( player:EyePos() + player:EyeAngles():Forward() * 10 )
		ragdoll_motion:SetAngles( Angle( 0, player:EyeAngles().yaw, 0 ) )
		ragdoll_motion:SetRagdoll( ent )
		ragdoll_motion:SetController( player )
		ragdoll_motion:Spawn()

		undo.Create( "MotionController" )
			undo.AddEntity( ragdoll_motion )
			undo.SetPlayer( player )
		undo.Finish()

	end

} )
