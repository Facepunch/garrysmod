
AddCSLuaFile()

-- The following is for the server's eyes only
local GravityDuplicator
if ( SERVER ) then
	function GravityDuplicator( ply, ent, data )

		if ( !data || !data.enabled ) then

			duplicator.ClearEntityModifier( ent, "gravity_property" )
			return

		end

		-- Simply restore the value whenever we are duplicated
		-- We don't need to reapply EnableGravity because duplicator already does it for us
		ent:SetNWBool( "gravity_disabled", data.enabled )

		duplicator.StoreEntityModifier( ent, "gravity_property", data )

	end
	duplicator.RegisterEntityModifier( "gravity_property", GravityDuplicator )
end

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
		local b = ent:GetNWBool( "gravity_disabled" )

		for i = 0, bones - 1 do

			local phys = ent:GetPhysicsObjectNum( i )
			if ( IsValid( phys ) ) then
				phys:EnableGravity( b )
				phys:Wake()
			end

		end

		ent:SetNWBool( "gravity_disabled", b == false )

		GravityDuplicator( ply, ent, { enabled = ent:GetNWBool( "gravity_disabled" ) } )

	end

} )
