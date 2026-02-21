
AddCSLuaFile()

properties.Add( "persist", {
	MenuLabel = "#makepersistent",
	Order = 400,
	MenuIcon = "icon16/link.png",

	Filter = function( self, ent, ply )

		if ( ent:IsPlayer() ) then return false end
		if ( GetConVarString( "sbox_persist" ):Trim() == "" ) then return false end
		if ( !gamemode.Call( "CanProperty", ply, "persist", ent ) ) then return false end

		return !ent:GetPersistent()

	end,

	Action = function( self, ent )

		self:MsgStart()
			net.WriteEntity( ent )
		self:MsgEnd()

	end,

	Receive = function( self, length, ply )

		local ent = net.ReadEntity()
		if ( !IsValid( ent ) ) then return end
		if ( !properties.CanBeTargeted( ent, ply ) ) then return end
		if ( !self:Filter( ent, ply ) ) then return end

		-- TODO: Start some kind of animation, take 5 seconds to make something persistent

		ent:SetPersistent( true )
		--ent:EnableMotion( false )

	end

} )

properties.Add( "persist_end", {
	MenuLabel = "#stoppersisting",
	Order = 400,
	MenuIcon = "icon16/link_break.png",

	Filter = function( self, ent, ply )

		if ( ent:IsPlayer() ) then return false end
		if ( GetConVarString( "sbox_persist" ):Trim() == "" ) then return false end
		if ( !gamemode.Call( "CanProperty", ply, "persist", ent ) ) then return false end

		return ent:GetPersistent()

	end,

	Action = function( self, ent )

		self:MsgStart()
			net.WriteEntity( ent )
		self:MsgEnd()

	end,

	Receive = function( self, length, ply )

		local ent = net.ReadEntity()
		if ( !IsValid( ent ) ) then return end
		if ( !properties.CanBeTargeted( ent, ply ) ) then return end
		if ( !self:Filter( ent, ply ) ) then return end

		-- TODO: Start some kind of animation, take 5 seconds to make something persistent

		ent:SetPersistent( false )

	end

} )
