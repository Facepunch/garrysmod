
AddCSLuaFile()

properties.Add( "keepupright", {
	MenuLabel = "Keep Upright",
	Order = 900,
	MenuIcon = "icon16/arrow_up.png",
	
	Filter = function( self, ent, ply ) 

		if ( !IsValid( ent ) ) then return false end
		if ( ent:GetClass() != "prop_physics" ) then return false end
		if ( ent:GetNWBool( "IsUpright" ) ) then return false end
		if ( !gamemode.Call( "CanProperty", ply, "keepupright", ent ) ) then return false end

		return true 
	end,
	
	Action = function( self, ent )

		self:MsgStart()
			net.WriteEntity( ent )
		self:MsgEnd()
		
	end,

	Receive = function( self, length, player )

		local ent = net.ReadEntity()
		
		if ( !IsValid( ent ) ) then return end
		if ( !IsValid( player ) ) then return end
		if ( ent:GetClass() != "prop_physics" ) then return false end
		if ( ent:GetNWBool( "IsUpright" ) ) then return end
		if ( !self:Filter( ent, player ) ) then return end
		
		local Phys = ent:GetPhysicsObjectNum( 0 )
		if ( !IsValid( Phys ) ) then return end
		
		local constraint = constraint.Keepupright( ent, Phys:GetAngles(), 0, 999999 )

		--I feel like this is not stable enough
		--constraint:SetSaveValue( "m_localTestAxis", constraint:GetSaveTable().m_worldGoalAxis ) --ent:GetAngles():Up() )
		--constraint:SetSaveValue( "m_worldGoalAxis", Vector( 0, 0, 1 ) )

		if ( constraint ) then

			player:AddCleanup( "constraints", constraint )
			ent:SetNWBool( "IsUpright", true )
		
		end
		
	end

} )

properties.Add( "keepupright_stop", {
	MenuLabel = "Stop Keep Upright",
	Order = 900,
	MenuIcon = "icon16/arrow_rotate_clockwise.png",
	
	Filter = function( self, ent ) 
		if ( !IsValid( ent ) ) then return false end
		if ( ent:GetClass() != "prop_physics" ) then return false end
		if ( !ent:GetNWBool( "IsUpright" ) ) then return false end
		return true 
	end,

	Action = function( self, ent )

		self:MsgStart()
			net.WriteEntity( ent )
		self:MsgEnd()
		
	end,

	Receive = function( self, length, player )

		local ent = net.ReadEntity()
		
		if ( !IsValid( ent ) ) then return end
		if ( !IsValid( player ) ) then return end
		if ( ent:GetClass() != "prop_physics" ) then return end
		if ( !ent:GetNWBool( "IsUpright" ) ) then return end
		
		constraint.RemoveConstraints( ent, "Keepupright" )
		
		ent:SetNWBool( "IsUpright", false )
		
	end	

} )
