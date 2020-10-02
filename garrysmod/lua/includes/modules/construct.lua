
local ents = ents
local SERVER = SERVER
local duplicator = duplicator
local numpad = numpad
local Msg = Msg
local IsValid = IsValid

module( "construct" )

if SERVER then

	function SetPhysProp( Player, Entity, BoneID, Bone, Data )

		if ( !IsValid( Bone ) ) then

			Bone = Entity:GetPhysicsObjectNum( BoneID )
			if ( !IsValid( Bone ) ) then
				Msg( "SetPhysProp: Error applying attributes to invalid physics object!\n" )
				return
			end

		end

		if ( Data.GravityToggle != nil )	then Bone:EnableGravity( Data.GravityToggle ) end
		if ( Data.Material != nil )			then Bone:SetMaterial( Data.Material ) end

		-- todo: Rename/Implement
		--[[
		if ( Data.motionb != nil )	then Bone:EnableMotion( Data.motionb ) end
		if ( Data.mass != nil )			then Bone:SetMass( Data.mass ) end
		if ( Data.dragb != nil )		then Bone:EnableDrag( Data.dragb ) end
		if ( Data.drag != nil )			then Bone:SetDragCoefficient( Data.drag ) end
		if ( Data.buoyancy != nil )		then Bone:SetBuoyancyRatio( Data.buoyancy ) end
		if ( Data.rotdamping != nil )	then Bone:SetDamping( PhysBone:GetSpeedDamping(), Data.rotdamping ) end
		if ( Data.speeddamping != nil )	then Bone:SetDamping( Data.speeddamping, PhysBone:GetRotDamping() ) end
		--]]

		-- HACK HACK
		-- If we don't do this the prop will be motion enabled and will
		-- slide through the world with no gravity.
		if ( !Bone:IsMoveable() ) then

			Bone:EnableMotion( true )
			Bone:EnableMotion( false )

		end

		duplicator.StoreBoneModifier( Entity, BoneID, "physprops", Data )

	end

	duplicator.RegisterBoneModifier( "physprops", SetPhysProp )


	local function MagnetOff( pl, magnet )

		if ( !IsValid( magnet ) ) then return false end
		if ( magnet:GetTable().toggle != 0 ) then return true end

		magnet:Fire( "TurnOff", "" , 0 )

		return true

	end


	local function MagnetOn( pl, magnet )

		if ( !IsValid( magnet ) ) then return false end

		if ( magnet:GetTable().toggle != 0 ) then

			magnet:GetTable().toggle_state = !magnet:GetTable().toggle_state

			if ( magnet:GetTable().toggle_state ) then
				magnet:Fire( "TurnOn", "" , 0 )
			else
				magnet:Fire( "TurnOff", "" , 0 )
			end

			return true

		end

		magnet:Fire( "TurnOn", "" , 0 )

		return true

	end

	numpad.Register( "MagnetOff", MagnetOff )
	numpad.Register( "MagnetOn", MagnetOn )

	function Magnet( pl, pos, angle, model, material, key, maxobjects, strength, nopull, allowrot, alwayson, toggle, Vel, aVel, frozen )

		local magnet = ents.Create( "phys_magnet" )
		magnet:SetPos( pos )
		magnet:SetAngles( angle )
		magnet:SetModel( model )
		magnet:SetMaterial( material )

		local spawnflags = 4
		if ( nopull > 0 ) then spawnflags = spawnflags - 4 end		-- no pull required: remove the suck flag
		if ( allowrot > 0 ) then spawnflags = spawnflags + 8 end

		magnet:SetKeyValue( "maxobjects", maxobjects )
		magnet:SetKeyValue( "forcelimit", strength )
		magnet:SetKeyValue( "spawnflags", spawnflags )
		magnet:SetKeyValue( "overridescript", "surfaceprop,metal")
		magnet:SetKeyValue( "massScale", 0 )

		magnet:Activate()
		magnet:Spawn()

		if ( IsValid( magnet:GetPhysicsObject() ) ) then
			local Phys = magnet:GetPhysicsObject()
			if ( Vel ) then Phys:SetVelocity( Vel ) end
			if ( aVel ) then Phys:AddAngleVelocity( aVel ) end
			Phys:EnableMotion( frozen != true )
		end

		if ( alwayson > 0 ) then
			magnet:Input( "TurnOn", nil, nil, nil )
		else
			magnet:Input( "TurnOff", nil, nil, nil )
		end

		local mtable = {
			Model = model,
			material = material,
			key = key,
			maxobjects = maxobjects,
			strength = strength,
			nopull = nopull,
			allowrot = allowrot,
			alwayson = alwayson,
			toggle = toggle
		}

		magnet:SetTable( mtable )

		numpad.OnDown( pl, key, "MagnetOn", magnet )
		numpad.OnUp( pl, key, "MagnetOff", magnet )

		return magnet

	end

	duplicator.RegisterEntityClass( "phys_magnet", Magnet, "Pos", "Ang", "Model", "material", "key", "maxobjects", "strength", "nopull", "allowrot", "alwayson", "toggle", "Vel", "aVel", "frozen" )

end
