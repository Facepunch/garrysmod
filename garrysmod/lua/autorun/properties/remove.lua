
AddCSLuaFile()

properties.Add( "remove", {
	MenuLabel = "#remove",
	Order = 1000,
	MenuIcon = "icon16/delete.png",

	Filter = function( self, ent, ply )

		if ( !gamemode.Call( "CanProperty", ply, "remover", ent ) ) then return false end
		if ( !IsValid( ent ) ) then return false end
		if ( ent:IsPlayer() ) then return false end

		return true

	end,

	Action = function( self, ent )

		self:MsgStart()
			net.WriteEntity( ent )
		self:MsgEnd()

	end,

	Receive = function( self, length, ply )
		if ( !IsValid( ply ) ) then return end

		local ent = net.ReadEntity()
		if ( !IsValid( ent ) ) then return end

		-- Don't allow removal of players or objects that cannot be physically targeted by properties
		if ( !properties.CanBeTargeted( ent, ply ) ) then return end
		if ( !self:Filter( ent, ply ) ) then return end

		-- Remove all constraints (this stops ropes from hanging around)
		constraint.RemoveAll( ent )

		-- Remove it properly in 1 second
		timer.Simple( 1, function() if ( IsValid( ent ) ) then ent:Remove() end end )

		-- Make it non solid
		ent:SetNotSolid( true )
		ent:SetMoveType( MOVETYPE_NONE )
		ent:SetNoDraw( true )

		-- Send Effect
		local ed = EffectData()
		ed:SetEntity( ent )
		util.Effect( "entity_remove", ed, true, true )

		ply:SendLua( "achievements.Remover()" )

	end

} )
