
AddCSLuaFile()

properties.Add( "gravity", {
	MenuLabel = "#gravity",
	Type = "toggle",
	Order = 1001,

	Filter = function( self, ent, ply )

		if ( !IsValid( ent ) ) then return false end
		if ( !gamemode.Call( "CanProperty", ply, "gravity", ent ) ) then return false end

		if ( ent:GetClass() == "prop_physics" ) then return true end
		if ( ent:GetClass() == "prop_ragdoll" ) then return true end

		return false

	end,

	Checked = function( self, ent, ply )

		return ent:GetNWBool( "gravity_disabled" ) == false

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

		local bones = ent:GetPhysicsObjectCount()
		local b = ent:GetNWBool( "gravity_disabled" );

		for i = 0, bones-1 do

			local phys = ent:GetPhysicsObjectNum( i )
			if ( IsValid( phys ) ) then
				phys:EnableGravity( b )
			end

		end

		ent:SetNWBool( "gravity_disabled", b == false )

	end

} )
