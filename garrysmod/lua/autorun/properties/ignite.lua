
AddCSLuaFile()

local function CanEntityBeSetOnFire( ent )

	if ( ent:GetClass() == "prop_physics" ) then return true end
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

	Receive = function( self, length, player )

		local ent = net.ReadEntity()
		
		if ( !self:Filter( ent, player ) ) then return end

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

	Receive = function( self, length, player )

		local ent = net.ReadEntity()
		
		if ( !self:Filter( ent, player ) ) then return end

		ent:Extinguish()
		
	end	

} )
