
AddCSLuaFile()

-- The following is for the server's eyes only
local StatueDuplicator
if ( SERVER ) then
	function StatueDuplicator( ply, ent, data )

		if ( !data ) then

			duplicator.ClearEntityModifier( ent, "statue_property" )
			return

		end

		-- We have been pasted from duplicator, restore the necessary variables for the unstatue to work
		if ( ent.StatueInfo == nil ) then

			-- Ew. Have to wait a frame for the constraints to get pasted
			timer.Simple( 0, function()
				if ( !IsValid( ent ) ) then return end

				local bones = ent:GetPhysicsObjectCount()
				if ( bones < 2 ) then return end

				ent:SetNWBool( "IsStatue", true )
				ent.StatueInfo = {}

				local con = constraint.FindConstraints( ent, "Weld" )
				for id, t in pairs( con ) do
					if ( t.Ent1 != t.Ent2 || t.Ent1 != ent || t.Bone1 != 0 ) then continue end

					ent.StatueInfo[ t.Bone2 ] = t.Constraint
				end

				local numC = table.Count( ent.StatueInfo )
				if ( numC < 1 --[[or numC != bones - 1]] ) then duplicator.ClearEntityModifier( ent, "statue_property" ) end
			end )
		end

		duplicator.StoreEntityModifier( ent, "statue_property", data )

	end
	duplicator.RegisterEntityModifier( "statue_property", StatueDuplicator )
end

properties.Add( "statue", {
	MenuLabel = "#makestatue",
	Order = 1501,
	MenuIcon = "icon16/lock.png",

	Filter = function( self, ent, ply )
		if ( !IsValid( ent ) ) then return false end
		if ( ent:GetClass() != "prop_ragdoll" ) then return false end
		if ( ent:GetNWBool( "IsStatue" ) ) then return false end
		if ( !gamemode.Call( "CanProperty", ply, "statue", ent ) ) then return false end
		return true
	end,

	Action = function( self, ent )

		self:MsgStart()
			net.WriteEntity( ent )
		self:MsgEnd()

	end,

	Receive = function( self, length, ply )

		local ent = net.ReadEntity()

		if ( !IsValid( ent ) ) then return end
		if ( !IsValid( ply ) ) then return end
		if ( !properties.CanBeTargeted( ent, ply ) ) then return end
		if ( ent:GetClass() != "prop_ragdoll" ) then return end
		if ( !self:Filter( ent, ply ) ) then return end

		local bones = ent:GetPhysicsObjectCount()
		if ( bones < 2 ) then return end
		if ( ent.StatueInfo ) then return end

		ent.StatueInfo = {}

		undo.Create( "Statue" )

		for bone = 1, bones - 1 do

			local constraint = constraint.Weld( ent, ent, 0, bone, 0 )

			if ( constraint ) then

				ent.StatueInfo[ bone ] = constraint
				ply:AddCleanup( "constraints", constraint )
				undo.AddEntity( constraint )

			end

			local effectdata = EffectData()
			effectdata:SetOrigin( ent:GetPhysicsObjectNum( bone ):GetPos() )
			effectdata:SetScale( 1 )
			effectdata:SetMagnitude( 1 )
			util.Effect( "GlassImpact", effectdata, true, true )

		end

		ent:SetNWBool( "IsStatue", true )

		undo.AddFunction( function()

			if ( IsValid( ent ) ) then
				ent:SetNWBool( "IsStatue", false )
				ent.StatueInfo = nil
				StatueDuplicator( ply, ent, nil )
			end

		end )

		undo.SetPlayer( ply )
		undo.Finish()

		StatueDuplicator( ply, ent, {} )

	end

} )

properties.Add( "statue_stop", {
	MenuLabel = "#unstatue",
	Order = 1501,
	MenuIcon = "icon16/lock_open.png",

	Filter = function( self, ent, ply )
		if ( !IsValid( ent ) ) then return false end
		if ( ent:GetClass() != "prop_ragdoll" ) then return false end
		if ( !ent:GetNWBool( "IsStatue" ) ) then return false end
		if ( !gamemode.Call( "CanProperty", ply, "unstatue", ent ) ) then return false end
		return true
	end,

	Action = function( self, ent )

		self:MsgStart()
			net.WriteEntity( ent )
		self:MsgEnd()

	end,

	Receive = function( self, length, ply )

		local ent = net.ReadEntity()

		if ( !IsValid( ent ) ) then return end
		if ( !IsValid( ply ) ) then return end
		if ( !properties.CanBeTargeted( ent, ply ) ) then return end
		if ( ent:GetClass() != "prop_ragdoll" ) then return end

		local bones = ent:GetPhysicsObjectCount()
		if ( bones < 2 ) then return end
		if ( !ent.StatueInfo ) then return end

		for k, v in pairs( ent.StatueInfo ) do

			if ( IsValid( v ) ) then
				v:Remove()
			end

		end

		ent:SetNWBool( "IsStatue", false )
		ent.StatueInfo = nil

		StatueDuplicator( ply, ent, nil )

	end

} )
