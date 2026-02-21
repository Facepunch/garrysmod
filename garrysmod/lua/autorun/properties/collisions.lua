
AddCSLuaFile()

properties.Add( "collision_off", {
	MenuLabel = "#collision_off",
	Order = 1500,
	MenuIcon = "icon16/collision_off.png",

	Filter = function( self, ent, ply )

		if ( !IsValid( ent ) ) then return false end
		if ( ent:IsPlayer() ) then return false end
		if ( !gamemode.Call( "CanProperty", ply, "collision", ent ) ) then return false end
		if ( ent:GetCollisionGroup() == COLLISION_GROUP_WORLD ) then return false end

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

		ent:SetCollisionGroup( COLLISION_GROUP_WORLD )

	end

} )

properties.Add( "collision_on", {
	MenuLabel = "#collision_on",
	Order = 1500,
	MenuIcon = "icon16/collision_on.png",

	Filter = function( self, ent, ply )

		if ( !IsValid( ent ) ) then return false end
		if ( ent:IsPlayer() ) then return false end
		if ( !gamemode.Call( "CanProperty", ply, "collision", ent ) ) then return false end

		return ent:GetCollisionGroup() == COLLISION_GROUP_WORLD

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

		ent:SetCollisionGroup( COLLISION_GROUP_NONE )

	end

} )
