
AddCSLuaFile()

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

		for bone = 1, bones-1 do

			local constraint = constraint.Weld( ent, ent, 0, bone, forcelimit )

			if ( constraint ) then

				ent.StatueInfo[bone] = constraint
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
			end

		end )

		undo.SetPlayer( ply )
		undo.Finish()

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

	end

} )
