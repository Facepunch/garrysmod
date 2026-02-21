
AddCSLuaFile()

properties.Add( "npc_bigger", {
	MenuLabel = "#biggify",
	Order = 1799,
	MenuIcon = "icon16/magnifier_zoom_in.png",

	Filter = function( self, ent, ply )

		if ( !gamemode.Call( "CanProperty", ply, "npc_bigger", ent ) ) then return false end
		if ( !IsValid( ent ) ) then return false end
		if ( !ent:IsNPC() ) then return false end

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

		ent:SetModelScale( ent:GetModelScale() * 1.25, 1 )

	end

} )

properties.Add( "npc_smaller", {
	MenuLabel = "#smallify",
	Order = 1800,
	MenuIcon = "icon16/magifier_zoom_out.png",

	Filter = function( self, ent, ply )

		if ( !gamemode.Call( "CanProperty", ply, "npc_smaller", ent ) ) then return false end
		if ( !IsValid( ent ) ) then return false end
		if ( !ent:IsNPC() ) then return false end

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

		ent:SetModelScale( ent:GetModelScale() * 0.8, 1 )

	end

} )
