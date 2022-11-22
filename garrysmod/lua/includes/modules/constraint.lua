
if ( SERVER ) then

	-- If you're a server admin and you want your physics to spazz out less you can
	-- use the convar. The higher you set it the more accurate physics will be.
	-- This is set to 4 by default, since we are a physics mod.

	CreateConVar( "gmod_physiterations", "4", { FCVAR_REPLICATED, FCVAR_ARCHIVE } )

end

module( "constraint", package.seeall )

-- Clients don't need this module.
if ( CLIENT ) then return end

-- I think 128 constraints is around the max that causes the crash
-- So at this number we'll refuse to add more to the system
local MAX_CONSTRAINTS_PER_SYSTEM = 100
local CurrentSystem = nil
local SystemLookup = {}

hook.Add( "EntityRemoved", "Constraint Library - ConstraintRemoved", function( Ent )
	local System = SystemLookup[ Ent ]
	if ( !IsValid( System ) ) then return end

	System.__ConstraintCount = ( System.__ConstraintCount or 0 ) - 1

	if System.__ConstraintCount <= 0 then
		System.__BadConstraintSystem = true
		System:Remove()
	end
end )

local function ConstraintCreated( Constraint )
	assert( IsValid( CurrentSystem ) )
	SystemLookup[ Constraint ] = CurrentSystem
	CurrentSystem.__ConstraintCount = ( CurrentSystem.__ConstraintCount or 0 ) + 1
end


--[[----------------------------------------------------------------------
	CreateConstraintSystem
------------------------------------------------------------------------]]
local function CreateConstraintSystem()

	local iterations = GetConVarNumber( "gmod_physiterations" )

	local System = ents.Create( "phys_constraintsystem" )
	System:SetKeyValue( "additionaliterations", iterations )
	System:Spawn()
	System:Activate()
	System.__ConstraintCount = 0

	return System

end


--[[----------------------------------------------------------------------
	FindOrCreateConstraintSystem

	Takes 2 entities. If the entities don't have a constraint system
	associated with them it creates one and associates it with them.

	It then returns the constraint system
------------------------------------------------------------------------]]
local function FindOrCreateConstraintSystem( Ent1, Ent2 )

	local System = nil

	Ent2 = Ent2 or Ent1

	-- Does Ent1 have a constraint system?
	if ( !Ent1:IsWorld() && IsValid( Ent1.ConstraintSystem ) && !Ent1.ConstraintSystem.__BadConstraintSystem ) then
		System = Ent1.ConstraintSystem
	end

	-- Don't add to this system - we have too many constraints on it already.
	if ( IsValid( System ) && ( System.__ConstraintCount or 0 ) >= MAX_CONSTRAINTS_PER_SYSTEM ) then System = nil end

	-- Does Ent2 have a constraint system?
	if ( !IsValid( System ) && !Ent2:IsWorld() && IsValid( Ent2.ConstraintSystem ) && !Ent2.ConstraintSystem.__BadConstraintSystem ) then
		System = Ent2.ConstraintSystem
	end

	-- Don't add to this system - we have too many constraints on it already.
	if ( IsValid( System ) && ( System.__ConstraintCount or 0 ) >= MAX_CONSTRAINTS_PER_SYSTEM ) then System = nil end

	-- No constraint system yet (Or they're both full) - make a new one
	if ( !IsValid( System ) ) then

		--Msg( "New Constrant System\n" )
		System = CreateConstraintSystem()

	end

	Ent1.ConstraintSystem = System
	Ent2.ConstraintSystem = System

	return System

end


--[[----------------------------------------------------------------------
	onStartConstraint( Ent1, Ent2 )
	Should be called before creating a constraint
------------------------------------------------------------------------]]
local function onStartConstraint( Ent1, Ent2 )

	-- Get constraint system
	CurrentSystem = FindOrCreateConstraintSystem( Ent1, Ent2 )

	-- Any constraints called after this call will use this system
	SetPhysConstraintSystem( CurrentSystem )

end

--[[----------------------------------------------------------------------
	onFinishConstraint( Ent1, Ent2 )
	Should be called before creating a constraint
------------------------------------------------------------------------]]
local function onFinishConstraint( Ent1, Ent2 )

	-- Turn off constraint system override
	CurrentSystem = nil
	SetPhysConstraintSystem( NULL )

end

local function SetPhysicsCollisions( Ent, b )

	if ( !IsValid( Ent ) or !IsValid( Ent:GetPhysicsObject() ) ) then return end

	Ent:GetPhysicsObject():EnableCollisions( b )

end

--[[----------------------------------------------------------------------
	RemoveConstraints( Ent, Type )
	Removes all constraints of type from entity
------------------------------------------------------------------------]]
function RemoveConstraints( Ent, Type )

	if ( !Ent.Constraints ) then return end

	local c = Ent.Constraints
	local i = 0

	for k, v in pairs( c ) do

		if ( !IsValid( v ) ) then

			c[ k ] = nil

		elseif ( v.Type == Type ) then

			-- Make sure physics collisions are on!
			-- If we don't the unconstrained objects will fall through the world forever.
			SetPhysicsCollisions( v.Ent1, true )
			SetPhysicsCollisions( v.Ent2, true )

			c[ k ] = nil
			v:Remove()

			i = i + 1
		end

	end

	if ( table.IsEmpty( c ) ) then
		-- Update the network var and clear the constraints table.
		Ent:IsConstrained()
	end

	local bool = i != 0
	return bool, i

end


--[[----------------------------------------------------------------------
	RemoveAll( Ent )
	Removes all constraints from entity
------------------------------------------------------------------------]]
function RemoveAll( Ent )

	if ( !Ent.Constraints ) then return end

	local c = Ent.Constraints
	local i = 0
	for k, v in pairs( c ) do

		if ( IsValid( v ) ) then

			-- Make sure physics collisions are on!
			-- If we don't the unconstrained objects will fall through the world forever.
			SetPhysicsCollisions( v.Ent1, true )
			SetPhysicsCollisions( v.Ent2, true )

			v:Remove()
			i = i + 1
		end

	end

	-- Update the network var and clear the constraints table.
	Ent:IsConstrained()

	local bool = i != 0
	return bool, i

end

--[[----------------------------------------------------------------------
	Find( Ent1, Ent2, Type, Bone1, Bone2 )
	Returns a constraint of given type between the two entities, if one exists
------------------------------------------------------------------------]]
function Find( Ent1, Ent2, Type, Bone1, Bone2 )

	if ( !Ent1.Constraints ) then return end

	for k, v in pairs( Ent1.Constraints ) do

		if ( IsValid( v ) && v.Type == Type ) then

			if ( v.Ent1 == Ent1 && v.Ent2 == Ent2 && v.Bone1 == Bone1 && v.Bone2 == Bone2 ) then
				return v
			end

			if ( v.Ent2 == Ent1 && v.Ent1 == Ent2 && v.Bone2 == Bone1 && v.Bone1 == Bone2 ) then
				return v
			end

		end

	end

	return nil

end

--[[----------------------------------------------------------------------
	CanConstrain( Ent, Bone )
	Returns false if we shouldn't be constraining this entity
------------------------------------------------------------------------]]
function CanConstrain( Ent, Bone )

	if ( !Ent ) then return false end
	if ( !isnumber( Bone ) ) then return false end
	if ( !Ent:IsWorld() && !Ent:IsValid() ) then return false end
	if ( !IsValid( Ent:GetPhysicsObjectNum( Bone ) ) ) then return false end

	return true

end

--[[----------------------------------------------------------------------
	CalcElasticConsts( ... )
	This attempts to scale the elastic constraints such as the winch
	to keep a stable but responsive constraint..
------------------------------------------------------------------------]]
local function CalcElasticConsts( Phys1, Phys2, Ent1, Ent2, iFixed )

	local minMass = 0

	if ( Ent1:IsWorld() ) then minMass = Phys2:GetMass()
	elseif ( Ent2:IsWorld() ) then minMass = Phys1:GetMass()
	else
		minMass = math.min( Phys1:GetMass(), Phys2:GetMass() )
	end

	-- const, damp
	local const = minMass * 100
	local damp = const * 0.2

	if ( iFixed == 0 ) then

		const = minMass * 50
		damp = const * 0.1

	end

	return const, damp

end


--[[----------------------------------------------------------------------
	CreateKeyframeRope( ... )
	Creates a rope without any constraint
------------------------------------------------------------------------]]
function CreateKeyframeRope( Pos, width, material, Constraint, Ent1, LPos1, Bone1, Ent2, LPos2, Bone2, kv )

	-- No rope if 0 or minus
	if ( width <= 0 ) then return nil end

	-- Clamp the rope to a sensible width
	width = math.Clamp( width, 0.2, 100 )

	local rope = ents.Create( "keyframe_rope" )
	rope:SetPos( Pos )
	rope:SetKeyValue( "Width", width )

	if ( isstring( material ) ) then
		-- Avoid materials with this shader, it either caused crashes or severe graphical glitches
		local mat = Material( material )
		if ( mat && !string.find( mat:GetShader():lower(), "spritecard", nil, true ) && !string.find( mat:GetShader():lower(), "shadow", nil, true ) ) then
			rope:SetKeyValue( "RopeMaterial", material )
		end
	end

	-- Attachment point 1
	rope:SetEntity( "StartEntity", Ent1 )
	rope:SetKeyValue( "StartOffset", tostring( LPos1 ) )
	rope:SetKeyValue( "StartBone", Bone1 )

	-- Attachment point 2
	rope:SetEntity( "EndEntity", Ent2 )
	rope:SetKeyValue( "EndOffset", tostring( LPos2 ) )
	rope:SetKeyValue( "EndBone", Bone2 )

	if ( kv ) then
		for k, v in pairs( kv ) do

			rope:SetKeyValue( k, tostring( v ) )

		end
	end

	rope:Spawn()
	rope:Activate()

	-- Delete the rope if the attachments get killed
	Ent1:DeleteOnRemove( rope )
	Ent2:DeleteOnRemove( rope )
	if ( IsValid( Constraint ) ) then Constraint:DeleteOnRemove( rope ) end

	return rope

end

--[[----------------------------------------------------------------------
	AddConstraintTable( Ent, Constraint, Ent2, Ent3, Ent4 )
	Stores info about the constraints on the entity's table
------------------------------------------------------------------------]]
function AddConstraintTable( Ent, Constraint, Ent2, Ent3, Ent4 )

	if ( !IsValid( Constraint ) ) then return end

	if ( IsValid( Ent ) || ( Ent && Ent:IsWorld() ) ) then

		Ent.Constraints = Ent.Constraints or {}
		table.insert( Ent.Constraints, Constraint )
		Ent:DeleteOnRemove( Constraint )

	end

	if ( Ent2 && Ent2 != Ent ) then
		AddConstraintTable( Ent2, Constraint, Ent3, Ent4 )
	end

end

--[[----------------------------------------------------------------------
	AddConstraintTableNoDelete( Ent, Constraint, Ent2, Ent3, Ent4 )
	Stores info about the constraints on the entity's table
------------------------------------------------------------------------]]
function AddConstraintTableNoDelete( Ent, Constraint, Ent2, Ent3, Ent4 )

	if ( !IsValid( Constraint ) ) then return end

	if ( IsValid( Ent ) || ( Ent && Ent:IsWorld() ) ) then

		Ent.Constraints = Ent.Constraints or {}
		table.insert( Ent.Constraints, Constraint )

	end

	if ( Ent2 && Ent2 != Ent ) then
		AddConstraintTableNoDelete( Ent2, Constraint, Ent3, Ent4 )
	end

end


--[[----------------------------------------------------------------------
	Weld( ... )
	Creates a solid weld constraint
------------------------------------------------------------------------]]
function Weld( Ent1, Ent2, Bone1, Bone2, forcelimit, nocollide, deleteonbreak )

	if ( Ent1 == Ent2 && Bone1 == Bone2 ) then return false end
	if ( !CanConstrain( Ent1, Bone1 ) ) then return false end
	if ( !CanConstrain( Ent2, Bone2 ) ) then return false end

	if ( Find( Ent1, Ent2, "Weld", Bone1, Bone2 ) ) then

		-- A weld already exists between these two physics objects.
		-- There's totally no point in re-creating it. It doesn't make
		-- the weld any stronger - that's just an urban legend.
		return false

	end

	-- Don't weld World to objects, weld objects to World!
	-- Prevents crazy physics on some props
	if ( Ent1:IsWorld() ) then
		Ent1 = Ent2
		Ent2 = game.GetWorld()
	end

	local Phys1 = Ent1:GetPhysicsObjectNum( Bone1 )
	local Phys2 = Ent2:GetPhysicsObjectNum( Bone2 )

	onStartConstraint( Ent1, Ent2 )

		-- Create the constraint
		local Constraint = ents.Create( "phys_constraint" )
		ConstraintCreated( Constraint )
		if ( forcelimit ) then Constraint:SetKeyValue( "forcelimit", forcelimit ) end
		if ( nocollide ) then Constraint:SetKeyValue( "spawnflags", 1 ) end
		Constraint:SetPhysConstraintObjects( Phys2, Phys1 )
		Constraint:Spawn()
		Constraint:Activate()

	onFinishConstraint( Ent1, Ent2 )
	AddConstraintTable( Ent1, Constraint, Ent2 )

	-- Optionally delete Ent1 when the weld is broken
	-- This is to fix bug #310
	if ( deleteonbreak ) then
		Ent2:DeleteOnRemove( Ent1 )
	end

	-- Make a constraints table
	local ctable = {
		Type = "Weld",
		Ent1 = Ent1,
		Ent2 = Ent2,
		Bone1 = Bone1,
		Bone2 = Bone2,
		forcelimit = forcelimit,
		nocollide = nocollide,
		deleteonbreak = deleteonbreak
	}

	Constraint:SetTable( ctable )

	Phys1:Wake()
	Phys2:Wake()

	return Constraint

end
duplicator.RegisterConstraint( "Weld", Weld, "Ent1", "Ent2", "Bone1", "Bone2", "forcelimit", "nocollide", "deleteonbreak" )


--[[----------------------------------------------------------------------
	Rope( ... )
	Creates a rope constraint - with rope!
------------------------------------------------------------------------]]
function Rope( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, length, addlength, forcelimit, width, material, rigid, color )

	if ( !CanConstrain( Ent1, Bone1 ) ) then return false end
	if ( !CanConstrain( Ent2, Bone2 ) ) then return false end

	local Phys1 = Ent1:GetPhysicsObjectNum( Bone1 )
	local Phys2 = Ent2:GetPhysicsObjectNum( Bone2 )
	local WPos1 = Phys1:LocalToWorld( LPos1 )
	local WPos2 = Phys2:LocalToWorld( LPos2 )
	local addlength = math.Clamp( addlength or 0, -56756, 56756 )
	local Constraint = nil

	-- Make Constraint
	if ( Phys1 != Phys2 ) then

		onStartConstraint( Ent1, Ent2 )

			-- Create the constraint
			Constraint = ents.Create( "phys_lengthconstraint" )
			ConstraintCreated( Constraint )
			Constraint:SetPos( WPos1 )
			Constraint:SetKeyValue( "attachpoint", tostring( WPos2 ) )
			Constraint:SetKeyValue( "minlength", "0.0" )
			Constraint:SetKeyValue( "length", length + addlength )
			if ( forcelimit ) then Constraint:SetKeyValue( "forcelimit", forcelimit ) end
			if ( rigid ) then Constraint:SetKeyValue( "spawnflags", 2 ) end
			Constraint:SetPhysConstraintObjects( Phys1, Phys2 )
			Constraint:Spawn()
			Constraint:Activate()

		onFinishConstraint( Ent1, Ent2 )

	end

	-- Make Rope
	local kv = {
		Length = length + addlength,
		Collide = 1
	}
	if ( rigid ) then kv.Type = 2 end

	local rope = CreateKeyframeRope( WPos1, width, material, Constraint, Ent1, LPos1, Bone1, Ent2, LPos2, Bone2, kv )
	if ( IsValid( rope ) && color ) then rope:SetColor( color ) end

	-- What the fuck
	if ( !Constraint ) then Constraint, rope = rope, nil end

	local ctable = {
		Type = "Rope",
		Ent1 = Ent1,
		Ent2 = Ent2,
		Bone1 = Bone1,
		Bone2 = Bone2,
		LPos1 = LPos1,
		LPos2 = LPos2,
		length = length,
		addlength = addlength,
		forcelimit = forcelimit,
		width = width,
		material = material,
		rigid = rigid,
		color = color
	}

	if ( IsValid( Constraint ) ) then
		Constraint:SetTable( ctable )
		AddConstraintTable( Ent1, Constraint, Ent2 )
	end

	return Constraint, rope

end
duplicator.RegisterConstraint( "Rope", Rope, "Ent1", "Ent2", "Bone1", "Bone2", "LPos1", "LPos2", "length", "addlength", "forcelimit", "width", "material", "rigid", "color" )

--[[----------------------------------------------------------------------
	Elastic( ... )
	Creates an elastic constraint
------------------------------------------------------------------------]]
function Elastic( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, constant, damping, rdamping, material, width, stretchonly, color )

	if ( !CanConstrain( Ent1, Bone1 ) ) then return false end
	if ( !CanConstrain( Ent2, Bone2 ) ) then return false end

	local Phys1 = Ent1:GetPhysicsObjectNum( Bone1 )
	local Phys2 = Ent2:GetPhysicsObjectNum( Bone2 )
	local WPos1 = Phys1:LocalToWorld( LPos1 )
	local WPos2 = Phys2:LocalToWorld( LPos2 )

	local Constraint = nil
	local rope = nil

	-- Make Constraint
	if ( Phys1 != Phys2 ) then

		onStartConstraint( Ent1, Ent2 )

			Constraint = ents.Create( "phys_spring" )
			ConstraintCreated( Constraint )
			Constraint:SetPos( WPos1 )
			Constraint:SetKeyValue( "springaxis", tostring( WPos2 ) )
			Constraint:SetKeyValue( "constant", constant )
			Constraint:SetKeyValue( "damping", damping )
			Constraint:SetKeyValue( "relativedamping", rdamping )
			Constraint:SetPhysConstraintObjects( Phys1, Phys2 )
			if ( stretchonly == 1 or stretchonly == true ) then
				Constraint:SetKeyValue( "spawnflags", 1 )
			end

			Constraint:Spawn()
			Constraint:Activate()

		onFinishConstraint( Ent1, Ent2 )
		AddConstraintTable( Ent1, Constraint, Ent2 )

		local ctable = {
			Type = "Elastic",
			Ent1 = Ent1,
			Ent2 = Ent2,
			Bone1 = Bone1,
			Bone2 = Bone2,
			LPos1 = LPos1,
			LPos2 = LPos2,
			constant = constant,
			damping = damping,
			rdamping = rdamping,
			material = material,
			width = width,
			length = ( WPos1 - WPos2 ):Length(),
			stretchonly = stretchonly,
			color = color
		}

		Constraint:SetTable( ctable )

		-- Make Rope
		local kv = {
			Collide = 1,
			Type = 0
		}
		rope = CreateKeyframeRope( WPos1, width, material, Constraint, Ent1, LPos1, Bone1, Ent2, LPos2, Bone2, kv )
		if ( IsValid( rope ) && color ) then rope:SetColor( color ) end

	end

	return Constraint, rope
end
duplicator.RegisterConstraint( "Elastic", Elastic, "Ent1", "Ent2", "Bone1", "Bone2", "LPos1", "LPos2", "constant", "damping", "rdamping", "material", "width", "stretchonly", "color" )


--[[----------------------------------------------------------------------
	Keepupright( ... )
	Creates a KeepUpright constraint
------------------------------------------------------------------------]]
function Keepupright( Ent, Ang, Bone, angularlimit )

	if ( !CanConstrain( Ent, Bone ) ) then return false end
	if ( Ent:GetClass() != "prop_physics" && Ent:GetClass() != "prop_ragdoll" ) then return false end
	if ( !angularlimit or angularlimit < 0 ) then return end

	local Phys = Ent:GetPhysicsObjectNum( Bone )

	-- Remove any KU's already on entity
	RemoveConstraints( Ent, "Keepupright" )

	onStartConstraint( Ent )

		local Constraint = ents.Create( "phys_keepupright" )
		ConstraintCreated( Constraint )
		Constraint:SetAngles( Ang )
		Constraint:SetKeyValue( "angularlimit", angularlimit )
		Constraint:SetPhysConstraintObjects( Phys, Phys )
		Constraint:Spawn()
		Constraint:Activate()

	onFinishConstraint( Ent )
	AddConstraintTable( Ent, Constraint )

	local ctable = {
		Type = "Keepupright",
		Ent1 = Ent,
		Ang = Ang,
		Bone = Bone,
		angularlimit = angularlimit
	}
	Constraint:SetTable( ctable )

	--
	-- This is a hack to keep the KeepUpright context menu in sync..
	--
	Ent:SetNWBool( "IsUpright", true )

	return Constraint

end
duplicator.RegisterConstraint( "Keepupright", Keepupright, "Ent1", "Ang", "Bone", "angularlimit" )


function CreateStaticAnchorPoint( Pos )

	-- Creates an invisible frozen, not interactive prop.
	local Anchor = ents.Create( "gmod_anchor" )

	Anchor:SetPos( Pos )
	Anchor:Spawn()
	Anchor:Activate()

	return Anchor, Anchor:GetPhysicsObject(), 0, vector_origin

end


--[[----------------------------------------------------------------------
	Slider( ... )
	Creates a slider constraint
------------------------------------------------------------------------]]
function Slider( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, width, material, color )

	-- TODO: If we get rid of sliders we can get rid of gmod_anchor too!

	if ( !CanConstrain( Ent1, Bone1 ) ) then return false end
	if ( !CanConstrain( Ent2, Bone2 ) ) then return false end

	local Phys1 = Ent1:GetPhysicsObjectNum( Bone1 )
	local Phys2 = Ent2:GetPhysicsObjectNum( Bone2 )
	local WPos1 = Phys1:LocalToWorld( LPos1 )
	local WPos2 = Phys2:LocalToWorld( LPos2 )
	local StaticAnchor = nil

	-- Make Constraint
	if ( Phys1 == Phys2 ) then return end

	-- Start World Hack.
	-- Attaching a slider to the world makes it really sucks so we make
	-- a prop and attach to that.

	if ( Ent1:IsWorld() ) then

		Ent1, Phys1, Bone1, LPos1 = CreateStaticAnchorPoint( WPos1 )
		StaticAnchor = Ent1

	end

	if ( Ent2:IsWorld() ) then

		Ent2, Phys2, Bone2, LPos2 = CreateStaticAnchorPoint( WPos2 )
		StaticAnchor = Ent2

	end

	-- End World Hack.

	onStartConstraint( Ent1, Ent2 )

		local Constraint = ents.Create( "phys_slideconstraint" )
		ConstraintCreated( Constraint )
		Constraint:SetPos( WPos1 )
		Constraint:SetKeyValue( "slideaxis", tostring( WPos2 ) )
		Constraint:SetPhysConstraintObjects( Phys1, Phys2 )
		Constraint:Spawn()
		Constraint:Activate()

	onFinishConstraint( Ent1, Ent2 )
	AddConstraintTable( Ent1, Constraint, Ent2 )

	-- Make Rope
	local kv = {
		Collide = 0,
		Type = 2,
		Subdiv = 1,
	}
	local rope = CreateKeyframeRope( WPos1, width, material, Constraint, Ent1, LPos1, Bone1, Ent2, LPos2, Bone2, kv )
	if ( IsValid( rope ) && color ) then rope:SetColor( color ) end

	-- If we have a static anchor - delete it when we die.
	if ( StaticAnchor ) then

		Constraint:DeleteOnRemove( StaticAnchor )

	end

	local ctable = {
		Type = "Slider",
		Ent1 = Ent1,
		Ent2 = Ent2,
		Bone1 = Bone1,
		Bone2 = Bone2,
		LPos1 = LPos1,
		LPos2 = LPos2,
		width = width,
		material = material,
		color = color
	}

	Constraint:SetTable( ctable )

	return Constraint, rope

end
duplicator.RegisterConstraint( "Slider", Slider, "Ent1", "Ent2", "Bone1", "Bone2", "LPos1", "LPos2", "width", "material", "color" )

--[[----------------------------------------------------------------------
	Axis( ... )
	Creates an axis constraint
------------------------------------------------------------------------]]
function Axis( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, forcelimit, torquelimit, friction, nocollide, LocalAxis, DontAddTable )

	if ( !CanConstrain( Ent1, Bone1 ) ) then return false end
	if ( !CanConstrain( Ent2, Bone2 ) ) then return false end

	local Phys1 = Ent1:GetPhysicsObjectNum( Bone1 )
	local Phys2 = Ent2:GetPhysicsObjectNum( Bone2 )
	local WPos1 = Phys1:LocalToWorld( LPos1 )
	local WPos2 = Phys2:LocalToWorld( LPos2 )

	if ( Phys1 == Phys2 ) then return false end

	-- If we have a LocalAxis, use that
	if ( LocalAxis ) then
		WPos2 = Phys1:LocalToWorld( LocalAxis )
	end

	onStartConstraint( Ent1, Ent2 )

		local Constraint = ents.Create( "phys_hinge" )
		ConstraintCreated( Constraint )
		Constraint:SetPos( WPos1 )
		Constraint:SetKeyValue( "hingeaxis", tostring( WPos2 ) )
		if ( forcelimit && forcelimit > 0 ) then Constraint:SetKeyValue( "forcelimit", forcelimit ) end
		if ( torquelimit && torquelimit > 0 ) then Constraint:SetKeyValue( "torquelimit", torquelimit ) end
		if ( friction && friction > 0 ) then Constraint:SetKeyValue( "hingefriction", friction ) end
		if ( nocollide && nocollide > 0 ) then Constraint:SetKeyValue( "spawnflags", 1 ) end
		Constraint:SetPhysConstraintObjects( Phys1, Phys2 )
		Constraint:Spawn()
		Constraint:Activate()

	onFinishConstraint( Ent1, Ent2 )

	if ( !DontAddTable ) then
		AddConstraintTable( Ent1, Constraint, Ent2 )
	end

	local ctable = {
		Type = "Axis",
		Ent1 = Ent1,
		Ent2 = Ent2,
		Bone1 = Bone1,
		Bone2 = Bone2,
		LPos1 = LPos1,
		LPos2 = LPos2,
		forcelimit = forcelimit,
		torquelimit = torquelimit,
		friction = friction,
		nocollide = nocollide,
		LocalAxis = Phys1:WorldToLocal( WPos2 )
	}

	Constraint:SetTable( ctable )

	return Constraint

end
duplicator.RegisterConstraint( "Axis", Axis, "Ent1", "Ent2", "Bone1", "Bone2", "LPos1", "LPos2", "forcelimit", "torquelimit", "friction", "nocollide", "LocalAxis", "DontAddTable" )


--[[----------------------------------------------------------------------
	AdvBallsocket( ... )
	Creates an advanced ballsocket (ragdoll) constraint
------------------------------------------------------------------------]]
function AdvBallsocket( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, forcelimit, torquelimit, xmin, ymin, zmin, xmax, ymax, zmax, xfric, yfric, zfric, onlyrotation, nocollide )

	if ( !CanConstrain( Ent1, Bone1 ) ) then return false end
	if ( !CanConstrain( Ent2, Bone2 ) ) then return false end

	local Phys1 = Ent1:GetPhysicsObjectNum( Bone1 )
	local Phys2 = Ent2:GetPhysicsObjectNum( Bone2 )
	local WPos1 = Phys1:LocalToWorld( LPos1 )
	-- local WPos2 = Phys2:LocalToWorld( LPos2 )

	if ( Phys1 == Phys2 ) then return false end

	-- Make Constraint
	onStartConstraint( Ent1, Ent2 )

		local flags = 0
		if ( onlyrotation && onlyrotation > 0 ) then flags = flags + 2 end
		if ( nocollide && nocollide > 0 ) then flags = flags + 1 end

		local Constraint = ents.Create( "phys_ragdollconstraint" )
		ConstraintCreated( Constraint )
		Constraint:SetPos( WPos1 )
		Constraint:SetKeyValue( "xmin", xmin )
		Constraint:SetKeyValue( "xmax", xmax )
		Constraint:SetKeyValue( "ymin", ymin )
		Constraint:SetKeyValue( "ymax", ymax )
		Constraint:SetKeyValue( "zmin", zmin )
		Constraint:SetKeyValue( "zmax", zmax )
		if ( xfric && xfric > 0 ) then Constraint:SetKeyValue( "xfriction", xfric ) end
		if ( yfric && yfric > 0 ) then Constraint:SetKeyValue( "yfriction", yfric ) end
		if ( zfric && zfric > 0 ) then Constraint:SetKeyValue( "zfriction", zfric ) end
		if ( forcelimit && forcelimit > 0 ) then Constraint:SetKeyValue( "forcelimit", forcelimit ) end
		if ( torquelimit && torquelimit > 0 ) then Constraint:SetKeyValue( "torquelimit", torquelimit ) end
		Constraint:SetKeyValue( "spawnflags", flags )
		Constraint:SetPhysConstraintObjects( Phys1, Phys2 )
		Constraint:Spawn()
		Constraint:Activate()

	onFinishConstraint( Ent1, Ent2 )
	AddConstraintTable( Ent1, Constraint, Ent2 )

	local ctable = {
		Type = "AdvBallsocket",
		Ent1 = Ent1,
		Ent2 = Ent2,
		Bone1 = Bone1,
		Bone2 = Bone2,
		LPos1 = LPos1,
		LPos2 = LPos2,
		forcelimit = forcelimit,
		torquelimit = torquelimit,
		xmin = xmin,
		ymin = ymin,
		zmin = zmin,
		xmax = xmax,
		ymax = ymax,
		zmax = zmax,
		xfric = xfric,
		yfric = yfric,
		zfric = zfric,
		onlyrotation = onlyrotation,
		nocollide = nocollide
	}

	Constraint:SetTable( ctable )

	return Constraint

end
duplicator.RegisterConstraint( "AdvBallsocket", AdvBallsocket, "Ent1", "Ent2", "Bone1", "Bone2", "LPos1", "LPos2", "forcelimit", "torquelimit", "xmin", "ymin", "zmin", "xmax", "ymax", "zmax", "xfric", "yfric", "zfric", "onlyrotation", "nocollide" )


--[[----------------------------------------------------------------------
	NoCollide( ... )
	Creates an nocollide `constraint'
------------------------------------------------------------------------]]
function NoCollide( Ent1, Ent2, Bone1, Bone2 )

	if ( !CanConstrain( Ent1, Bone1 ) ) then return false end
	if ( !CanConstrain( Ent2, Bone2 ) ) then return false end

	local Phys1 = Ent1:GetPhysicsObjectNum( Bone1 )
	local Phys2 = Ent2:GetPhysicsObjectNum( Bone2 )

	if ( Phys1 == Phys2 ) then return false end

	if ( Find( Ent1, Ent2, "NoCollide", Bone1, Bone2 ) ) then

		return false

	end

	-- Make Constraint
	local Constraint = ents.Create( "logic_collision_pair" )
	Constraint:SetKeyValue( "startdisabled", 1 )
	Constraint:SetPhysConstraintObjects( Phys1, Phys2 )
	Constraint:Spawn()
	Constraint:Activate()
	Constraint:Input( "DisableCollisions", nil, nil, nil )

	AddConstraintTable( Ent1, Constraint, Ent2 )

	local ctable = {
		Type = "NoCollide",
		Ent1 = Ent1,
		Ent2 = Ent2,
		Bone1 = Bone1,
		Bone2 = Bone2,
	}

	Constraint:SetTable( ctable )

	return Constraint

end
duplicator.RegisterConstraint( "NoCollide", NoCollide, "Ent1", "Ent2", "Bone1", "Bone2" )


--[[----------------------------------------------------------------------
	MotorControl( pl, motor, onoff, dir )
	Numpad controls for the motor constraints
------------------------------------------------------------------------]]
local function MotorControl( pl, motor, onoff, dir )

	if ( !IsValid( motor ) ) then return false end

	local activate = false

	if ( motor.toggle == 1 ) then

		-- Toggle mode, only do something when the key is pressed
		-- if the motor is off, turn it on, and vice-versa.
		-- This only happens if the same key as the current
		-- direction is pressed, otherwise the direction is changed
		-- with the motor being left on.

		if ( onoff ) then

			if ( motor.direction == dir or !motor.is_on ) then

				-- Direction is the same, Activate if the motor is off
				-- Deactivate if the motor is on.

				motor.is_on = !motor.is_on

				activate = motor.is_on

			else

				-- Change of direction, make sure it's activated

				activate = true

			end

		else

			return

		end

	else

		-- normal mode: activate is based on the key status
		-- (down = on, up = off)

		activate = onoff

	end

	if ( activate ) then

		motor:Fire( "Scale", dir ) -- This makes the direction change
		motor:Fire( "Activate" ) -- Turn on the motor

	else

		-- Turn off the motor, mimicking the wheel tool
		motor:Fire( "Scale", 0 )
		motor:Fire( "Activate" )

		-- For some reason Deactivate causes the torque axis to be fucked up, or rather..
		-- Reinitialized without taking into account possibly new rotation of the "parent" prop
		-- motor:Fire( "Deactivate" )

	end

	motor.direction = dir

	return true

end
numpad.Register( "MotorControl", MotorControl )

--[[----------------------------------------------------------------------
	Motor( ... )
	Creates a motor constraint
------------------------------------------------------------------------]]
function Motor( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, friction, torque, forcetime, nocollide, toggle, pl, forcelimit, numpadkey_fwd, numpadkey_bwd, direction, LocalAxis )

	if ( !CanConstrain( Ent1, Bone1 ) ) then return false end
	if ( !CanConstrain( Ent2, Bone2 ) ) then return false end

	-- Get information we're about to use
	local Phys1 = Ent1:GetPhysicsObjectNum( Bone1 )
	local Phys2 = Ent2:GetPhysicsObjectNum( Bone2 )
	local WPos1 = Phys1:LocalToWorld( LPos1 )
	local WPos2 = Phys2:LocalToWorld( LPos2 )

	if ( Phys1 == Phys2 ) then return false end

	if ( LocalAxis ) then
		WPos2 = Phys1:LocalToWorld( LocalAxis )
	end

	-- The true at the end stops it adding the axis table to the entity's count stuff.
	local axis = Axis( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, forcelimit, 0, friction, nocollide, LocalAxis, true )

	-- Delete the axis when either object dies
	Ent1:DeleteOnRemove( axis )
	Ent2:DeleteOnRemove( axis )

	-- Create the constraint
	onStartConstraint( Ent1, Ent2 )

		local Constraint = ents.Create( "phys_torque" )
		ConstraintCreated( Constraint )
		Constraint:SetPos( WPos1 )
		Constraint:SetKeyValue( "axis", tostring( WPos2 ) )
		Constraint:SetKeyValue( "force", torque )
		Constraint:SetKeyValue( "forcetime", forcetime )
		Constraint:SetKeyValue( "spawnflags", 4 )
		Constraint:SetPhysConstraintObjects( Phys1, Phys1 )
		Constraint:Spawn()
		Constraint:Activate()

	onFinishConstraint( Ent1, Ent2 )

	AddConstraintTableNoDelete( Ent1, Constraint, Ent2 )

	direction = direction or 1

	LocalAxis = Phys1:WorldToLocal( WPos2 )

	-- Delete the phys_torque too!
	axis:DeleteOnRemove( Constraint )

	-- Delete the axis constrain if phys_torque is deleted, with something like Motor tools reload
	Constraint:DeleteOnRemove( axis )

	local ctable = {
		Type = "Motor",
		Ent1 = Ent1,
		Ent2 = Ent2,
		Bone1 = Bone1,
		Bone2 = Bone2,
		LPos1 = LPos1,
		LPos2 = LPos2,
		friction = friction,
		torque = torque,
		forcetime = forcetime,
		nocollide = nocollide,
		toggle = toggle,
		pl = pl,
		forcelimit = forcelimit,
		forcescale = 0,
		direction = direction,
		is_on = false,
		numpadkey_fwd = numpadkey_fwd,
		numpadkey_bwd = numpadkey_bwd,
		LocalAxis = LocalAxis
	}

	Constraint:SetTable( ctable )

	if ( numpadkey_fwd ) then

		numpad.OnDown( pl, numpadkey_fwd, "MotorControl", Constraint, true, 1 )
		numpad.OnUp( pl, numpadkey_fwd, "MotorControl", Constraint, false, 1 )
	end

	if ( numpadkey_bwd ) then

		numpad.OnDown( pl, numpadkey_bwd, "MotorControl", Constraint, true, -1 )
		numpad.OnUp( pl, numpadkey_bwd, "MotorControl", Constraint, false, -1 )

	end

	return Constraint, axis

end
duplicator.RegisterConstraint( "Motor", Motor, "Ent1", "Ent2", "Bone1", "Bone2", "LPos1", "LPos2", "friction", "torque", "forcetime", "nocollide", "toggle", "pl", "forcelimit", "numpadkey_fwd", "numpadkey_bwd", "direction", "LocalAxis" )


--[[----------------------------------------------------------------------
	Pulley( ... )
	Creates a pulley constraint
------------------------------------------------------------------------]]
function Pulley( Ent1, Ent4, Bone1, Bone4, LPos1, LPos4, WPos2, WPos3, forcelimit, rigid, width, material, color )

	if ( !CanConstrain( Ent1, Bone1 ) ) then return false end
	if ( !CanConstrain( Ent4, Bone4 ) ) then return false end

	local Phys1 = Ent1:GetPhysicsObjectNum( Bone1 )
	local Phys4 = Ent4:GetPhysicsObjectNum( Bone4 )
	local WPos1 = Phys1:LocalToWorld( LPos1 )
	local WPos4 = Phys4:LocalToWorld( LPos4 )

	if ( Phys1 == Phys4 ) then return false end

	-- Make Constraint
	onStartConstraint( Ent1, Ent4 )

		local Constraint = ents.Create( "phys_pulleyconstraint" )
		ConstraintCreated( Constraint )
		Constraint:SetPos( WPos2 )
		Constraint:SetKeyValue( "position2", tostring( WPos3 ) )
		Constraint:SetKeyValue( "ObjOffset1", tostring( LPos1 ) )
		Constraint:SetKeyValue( "ObjOffset2", tostring( LPos4 ) )
		Constraint:SetKeyValue( "forcelimit", forcelimit )
		Constraint:SetKeyValue( "addlength", ( WPos3 - WPos4 ):Length() )
		if ( rigid ) then Constraint:SetKeyValue( "spawnflags", 2 ) end
		Constraint:SetPhysConstraintObjects( Phys1, Phys4 )
		Constraint:Spawn()
		Constraint:Activate()

	onFinishConstraint( Ent1, Ent4 )
	AddConstraintTable( Ent1, Constraint, Ent4 )

	local ctable = {
		Type = "Pulley",
		Ent1 = Ent1,
		Ent4 = Ent4,
		Bone1 = Bone1,
		Bone4 = Bone4,
		LPos1 = LPos1,
		LPos4 = LPos4,
		WPos2 = WPos2,
		WPos3 = WPos3,
		forcelimit = forcelimit,
		rigid = rigid,
		width = width,
		material = material,
		color = color
	}
	Constraint:SetTable( ctable )

	-- make Rope
	local World = game.GetWorld()

	local kv = {
		Collide = 1,
		Type = 2,
		Subdiv = 1,
	}

	local rope1 = CreateKeyframeRope( WPos1, width, material, Constraint, Ent1, LPos1, Bone1, World, WPos2, 0, kv )
	local rope2 = CreateKeyframeRope( WPos1, width, material, Constraint, World, WPos3, 0, World, WPos2, 0, kv )
	local rope3 = CreateKeyframeRope( WPos1, width, material, Constraint, World, WPos3, 0, Ent4, LPos4, Bone4, kv )
	if ( color ) then
		if ( IsValid( rope1 ) ) then rope1:SetColor( color ) end
		if ( IsValid( rope2 ) ) then rope2:SetColor( color ) end
		if ( IsValid( rope3 ) ) then rope3:SetColor( color ) end
	end

	return Constraint, rope1, rope2, rope3

end
duplicator.RegisterConstraint( "Pulley", Pulley, "Ent1", "Ent4", "Bone1", "Bone4", "LPos1", "LPos4", "WPos2", "WPos3", "forcelimit", "rigid", "width", "material", "color" )


--[[----------------------------------------------------------------------
	Ballsocket( ... )
	Creates a Ballsocket constraint
------------------------------------------------------------------------]]
function Ballsocket( Ent1, Ent2, Bone1, Bone2, LPos, forcelimit, torquelimit, nocollide )

	if ( !CanConstrain( Ent1, Bone1 ) ) then return false end
	if ( !CanConstrain( Ent2, Bone2 ) ) then return false end

	-- Get information we're about to use
	local Phys1 = Ent1:GetPhysicsObjectNum( Bone1 )
	local Phys2 = Ent2:GetPhysicsObjectNum( Bone2 )
	local WPos = Phys2:LocalToWorld( LPos )

	if ( Phys1 == Phys2 ) then return false end

	onStartConstraint( Ent1, Ent2 )

		local Constraint = ents.Create( "phys_ballsocket" )
		ConstraintCreated( Constraint )
		Constraint:SetPos( WPos )
		if ( forcelimit && forcelimit > 0 ) then Constraint:SetKeyValue( "forcelimit", forcelimit ) end
		if ( torquelimit && torquelimit > 0 ) then Constraint:SetKeyValue( "torquelimit", torquelimit ) end
		if ( nocollide && nocollide > 0 ) then Constraint:SetKeyValue( "spawnflags", 1 ) end
		Constraint:SetPhysConstraintObjects( Phys1, Phys2 )
		Constraint:Spawn()
		Constraint:Activate()

	onFinishConstraint( Ent1, Ent2 )
	AddConstraintTable( Ent1, Constraint, Ent2 )

	local ctable = {
		Type = "Ballsocket",
		Ent1 = Ent1,
		Ent2 = Ent2,
		Bone1 = Bone1,
		Bone2 = Bone2,
		LPos = LPos,
		forcelimit = forcelimit,
		torquelimit = torquelimit,
		nocollide = nocollide
	}

	Constraint:SetTable( ctable )

	return Constraint

end
duplicator.RegisterConstraint( "Ballsocket", Ballsocket, "Ent1", "Ent2", "Bone1", "Bone2", "LPos", "forcelimit", "torquelimit", "nocollide" )


--[[----------------------------------------------------------------------
	Winch( ... )
	Creates a Winch constraint
------------------------------------------------------------------------]]
function Winch( pl, Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, width, fwd_bind, bwd_bind, fwd_speed, bwd_speed, material, toggle, color )

	if ( !CanConstrain( Ent1, Bone1 ) ) then return false end
	if ( !CanConstrain( Ent2, Bone2 ) ) then return false end

	local Phys1 = Ent1:GetPhysicsObjectNum( Bone1 )
	local Phys2 = Ent2:GetPhysicsObjectNum( Bone2 )
	-- local WPos1 = Phys1:LocalToWorld( LPos1 )
	-- local WPos2 = Phys2:LocalToWorld( LPos2 )

	if ( Phys1 == Phys2 ) then return false end

	local const, dampen = CalcElasticConsts( Phys1, Phys2, Ent1, Ent2, false )

	local Constraint, rope = Elastic( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, const, dampen, 0, material, width, true, color )

	if ( !Constraint ) then return nil, rope end

	local ctable = {
		Type = "Winch",
		pl = pl,
		Ent1 = Ent1,
		Ent2 = Ent2,
		Bone1 = Bone1,
		Bone2 = Bone2,
		LPos1 = LPos1,
		LPos2 = LPos2,
		width = width,
		fwd_bind = fwd_bind,
		bwd_bind = bwd_bind,
		fwd_speed = fwd_speed,
		bwd_speed = bwd_speed,
		material = material,
		toggle = toggle,
		color = color
	}
	Constraint:SetTable( ctable )

	-- Attach our Controller to the Elastic constraint
	local controller = ents.Create( "gmod_winch_controller" )
	controller:SetConstraint( Constraint )
	controller:SetRope( rope )
	controller:Spawn()

	Constraint:DeleteOnRemove( controller )
	Ent1:DeleteOnRemove( controller )
	Ent2:DeleteOnRemove( controller )

	if ( toggle ) then

		numpad.OnDown( pl, fwd_bind, "WinchToggle", controller, 1 )
		numpad.OnDown( pl, bwd_bind, "WinchToggle", controller, -1 )

	else

		numpad.OnDown( pl, fwd_bind, "WinchOn", controller, 1 )
		numpad.OnUp( pl, fwd_bind, "WinchOff", controller )
		numpad.OnDown( pl, bwd_bind, "WinchOn", controller, -1 )
		numpad.OnUp( pl, bwd_bind, "WinchOff", controller )

	end

	return Constraint, rope, controller

end
duplicator.RegisterConstraint( "Winch", Winch, "pl", "Ent1", "Ent2", "Bone1", "Bone2", "LPos1", "LPos2", "width", "fwd_bind", "bwd_bind", "fwd_speed", "bwd_speed", "material", "toggle", "color" )


--[[----------------------------------------------------------------------
	Hydraulic( ... )
	Creates a Hydraulic constraint
------------------------------------------------------------------------]]
function Hydraulic( pl, Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, Length1, Length2, width, key, fixed, speed, material, toggle, color )

	if ( !CanConstrain( Ent1, Bone1 ) ) then return false end
	if ( !CanConstrain( Ent2, Bone2 ) ) then return false end

	local Phys1 = Ent1:GetPhysicsObjectNum( Bone1 )
	local Phys2 = Ent2:GetPhysicsObjectNum( Bone2 )
	-- local WPos1 = Phys1:LocalToWorld( LPos1 )
	-- local WPos2 = Phys2:LocalToWorld( LPos2 )

	if ( Phys1 == Phys2 ) then return false end
	if ( toggle == nil ) then toggle = true end -- Retain original behavior

	local const, dampn = CalcElasticConsts( Phys1, Phys2, Ent1, Ent2, fixed )

	local Constraint, rope = Elastic( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, const, dampn, 0, material, width, false, color )
	local ctable = {
		Type = "Hydraulic",
		pl = pl,
		Ent1 = Ent1,
		Ent2 = Ent2,
		Bone1 = Bone1,
		Bone2 = Bone2,
		LPos1 = LPos1,
		LPos2 = LPos2,
		Length1 = Length1,
		Length2 = Length2,
		width = width,
		key = key,
		fixed = fixed,
		fwd_speed = speed,
		bwd_speed = speed,
		toggle = toggle,
		material = material,
		color = color
	}
	Constraint:SetTable( ctable )

	if ( Constraint && Constraint != rope ) then

		local slider

		if ( fixed == 1 ) then
			slider = Slider( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, 0 )
			slider:SetTable( {} )
			Constraint:DeleteOnRemove( slider )
		end

		local controller = ents.Create( "gmod_winch_controller" )
		if ( Length2 > Length1 ) then
			controller:SetKeyValue( "minlength", Length1 )
			controller:SetKeyValue( "maxlength", Length2 )
		else
			controller:SetKeyValue( "minlength", Length2 )
			controller:SetKeyValue( "maxlength", Length1 )
		end

		controller:SetConstraint( Constraint )
		controller:Spawn()

		Ent1:DeleteOnRemove( controller )
		Ent2:DeleteOnRemove( controller )

		Constraint:DeleteOnRemove( controller )

		if ( toggle ) then
			numpad.OnDown( pl, key, "HydraulicToggle", controller )
		else
			numpad.OnUp( pl, key, "HydraulicDir", controller, -1 )
			numpad.OnDown( pl, key, "HydraulicDir", controller, 1 )
		end

		return Constraint, rope, controller, slider
	else
		return Constraint, rope
	end

end
duplicator.RegisterConstraint( "Hydraulic", Hydraulic, "pl", "Ent1", "Ent2", "Bone1", "Bone2", "LPos1", "LPos2", "Length1", "Length2", "width", "key", "fixed", "fwd_speed", "material", "toggle", "color" )


--[[----------------------------------------------------------------------
	Muscle( ... )
	Creates a Muscle constraint
------------------------------------------------------------------------]]
function Muscle( pl, Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, Length1, Length2, width, key, fixed, period, amplitude, starton, material, color )

	if ( !CanConstrain( Ent1, Bone1 ) ) then return false end
	if ( !CanConstrain( Ent2, Bone2 ) ) then return false end

	local Phys1 = Ent1:GetPhysicsObjectNum( Bone1 )
	local Phys2 = Ent2:GetPhysicsObjectNum( Bone2 )
	-- local WPos1 = Phys1:LocalToWorld( LPos1 )
	-- local WPos2 = Phys2:LocalToWorld( LPos2 )

	if ( Phys1 == Phys2 ) then return false end

	local const, dampn = CalcElasticConsts( Phys1, Phys2, Ent1, Ent2, fixed )

	local Constraint, rope = Elastic( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, const, dampn, 0, material, width, false, color )
	if ( !Constraint ) then return false end

	local ctable = {
		Type = "Muscle",
		pl = pl,
		Ent1 = Ent1,
		Ent2 = Ent2,
		Bone1 = Bone1,
		Bone2 = Bone2,
		LPos1 = LPos1,
		LPos2 = LPos2,
		Length1 = Length1,
		Length2 = Length2,
		width = width,
		key = key,
		fixed = fixed,
		period = period,
		amplitude = amplitude,
		toggle = true,
		starton = starton,
		material = material,
		color = color
	}
	Constraint:SetTable( ctable )

	local slider = nil

	if ( fixed == 1 ) then
		slider = Slider( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, 0 )
		slider:SetTable( {} ) -- Remove data for duplicator
		Constraint:DeleteOnRemove( slider )
	end

	local controller = ents.Create( "gmod_winch_controller" )
	if ( Length2 > Length1 ) then
		controller:SetKeyValue( "minlength", Length1 )
		controller:SetKeyValue( "maxlength", Length2 )
	else
		controller:SetKeyValue( "minlength", Length2 )
		controller:SetKeyValue( "maxlength", Length1 )
	end
	controller:SetKeyValue( "type", 1 )
	controller:SetConstraint( Constraint )
	controller:Spawn()

	Ent1:DeleteOnRemove( controller )
	Ent2:DeleteOnRemove( controller )

	Constraint:DeleteOnRemove( controller )

	numpad.OnDown( pl, key, "MuscleToggle", controller )

	if ( starton ) then
		controller:SetDirection( 1 )
	end

	return Constraint, rope, controller, slider

end
duplicator.RegisterConstraint( "Muscle", Muscle, "pl", "Ent1", "Ent2", "Bone1", "Bone2", "LPos1", "LPos2", "Length1", "Length2", "width", "key", "fixed", "period", "amplitude", "starton", "material", "color" )


--[[----------------------------------------------------------------------
	Returns true if this entity has valid constraints
------------------------------------------------------------------------]]
function HasConstraints( ent )

	if ( !ent ) then return false end
	if ( !ent.Constraints ) then return false end

	local count = 0
	for key, Constraint in pairs( ent.Constraints ) do

		if ( !IsValid( Constraint ) ) then

			ent.Constraints[ key ] = nil

		else

			count = count + 1

		end

	end

	return count != 0

end


--[[----------------------------------------------------------------------
	Returns this entities constraints table
	This is for the future, because ideally the constraints table will eventually look like this - and we won't have to build it every time.
------------------------------------------------------------------------]]
function GetTable( ent )

	if ( !HasConstraints( ent ) ) then return {} end

	local RetTable = {}

	for key, ConstraintEntity in pairs( ent.Constraints ) do

		local con = {}

		table.Merge( con, ConstraintEntity:GetTable() )

		con.Constraint = ConstraintEntity
		con.Entity = {}

		for i = 1, 6 do

			if ( con[ "Ent" .. i ] && ( con[ "Ent" .. i ]:IsWorld() or con[ "Ent" .. i ]:IsValid() ) ) then

				con.Entity[ i ] = {}
				con.Entity[ i ].Index = con[ "Ent" .. i ]:EntIndex()
				con.Entity[ i ].Entity = con[ "Ent" .. i ]
				con.Entity[ i ].Bone = con[ "Bone" .. i ]
				con.Entity[ i ].LPos = con[ "LPos" .. i ]
				con.Entity[ i ].WPos = con[ "WPos" .. i ]
				con.Entity[ i ].Length = con[ "Length" .. i ]
				con.Entity[ i ].World = con[ "Ent" .. i ]:IsWorld()

			end

		end

		table.insert( RetTable, con )

	end

	return RetTable

end

--[[----------------------------------------------------------------------
	Make this entity forget any constraints it knows about
------------------------------------------------------------------------]]
function ForgetConstraints( ent )

	ent.Constraints = {}

end


--[[----------------------------------------------------------------------
	Returns a list of constraints, by name
------------------------------------------------------------------------]]
function FindConstraints( ent, name )

	local ConTable = GetTable( ent )

	local Found = {}

	for k, con in ipairs( ConTable ) do

		if ( con.Type == name ) then
			table.insert( Found, con )
		end

	end

	return Found

end

--[[----------------------------------------------------------------------
	Returns the first constraint found by name
------------------------------------------------------------------------]]
function FindConstraint( ent, name )

	local ConTable = GetTable( ent )

	for k, con in ipairs( ConTable ) do

		if ( con.Type == name ) then
			return con
		end

	end

	return nil

end

--[[----------------------------------------------------------------------
	Returns the first constraint found by name
------------------------------------------------------------------------]]
function FindConstraintEntity( ent, name )

	local ConTable = GetTable( ent )

	for k, con in ipairs( ConTable ) do

		if ( con.Type == name ) then
			return con.Constraint
		end

	end

	return NULL

end

--[[----------------------------------------------------------------------
	Returns a table of all the entities constrained to ent
------------------------------------------------------------------------]]
function GetAllConstrainedEntities( ent, ResultTable )

	local ResultTable = ResultTable or {}

	if ( !IsValid( ent ) && !ent:IsWorld() ) then return end
	if ( ResultTable[ ent ] ) then return end

	ResultTable[ ent ] = ent

	local ConTable = GetTable( ent )

	for k, con in ipairs( ConTable ) do

		for EntNum, Ent in pairs( con.Entity ) do
			if ( !Ent.Entity:IsWorld() ) then
				GetAllConstrainedEntities( Ent.Entity, ResultTable )
			end
		end

	end

	return ResultTable

end
