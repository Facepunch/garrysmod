
AddCSLuaFile()

local function CanEntityBeSetOnFire( ent )

	-- func_pushable, func_breakable & func_physbox cannot be ignited
	if ( ent:GetClass() == "item_item_crate" ) then return true end
	if ( ent:GetClass() == "simple_physics_prop" ) then return true end
	if ( ent:GetClass():match( "prop_physics*") ) then return true end
	if ( ent:GetClass():match( "prop_ragdoll*") ) then return true end
	if ( ent:IsNPC() ) then return true end

	return false

end

properties.Add( "ignite", {
	MenuLabel = "#ignite",
	Order = 999,
	MenuIcon = "icon16/fire.png",

	Filter = function( self, ent, ply )

		if ( !IsValid( ent ) ) then return false end
		if ( ent:IsPlayer() ) then return false end
		if ( !CanEntityBeSetOnFire( ent ) ) then return false end
		if ( !gamemode.Call( "CanProperty", ply, "ignite", ent ) ) then return false end

		return !ent:IsOnFire()
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

		ent:Ignite( 360 )

	end

} )

properties.Add( "extinguish", {
	MenuLabel = "#extinguish",
	Order = 999,
	MenuIcon = "icon16/water.png",

	Filter = function( self, ent, ply )

		if ( !IsValid( ent ) ) then return false end
		if ( ent:IsPlayer() ) then return false end
		if ( !gamemode.Call( "CanProperty", ply, "extinguish", ent ) ) then return false end

		return ent:IsOnFire()
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

		ent:Extinguish()

	end

} )
