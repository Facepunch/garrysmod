
if ( SERVER ) then

	-- If you're a server admin and you want your physics to spazz out less you can
	-- use the convar. The higher you set it the more accurate physics will be.
	-- This is set to 4 by default, since we are a physics mod.

	CreateConVar( "gmod_physiterations", "4", { FCVAR_REPLICATED, FCVAR_ARCHIVE }, "Additional solver iterations make constraint systems more stable." )

end

module( "constraint", package.seeall )

-- Clients don't need this module.
if ( CLIENT ) then return end

-- I think 128 constraints is around the max that causes the crash
-- So at this number we'll refuse to add more to the system
local MAX_CONSTRAINTS_PER_SYSTEM = 100
local CurrentSystem = NULL
local SystemLookup = {}

-- HACK: Entity.IsConstraint is false for these
local constraintClasses = {}
constraintClasses[ "phys_spring" ] = true
constraintClasses[ "phys_slideconstraint" ] = true
constraintClasses[ "phys_torque" ] = true
constraintClasses[ "logic_collision_pair" ] = true

hook.Add( "EntityRemoved", "Constraint Library - ConstraintRemoved", function( ent )

	-- Remove this constraint from Entity.Constraints table of the constrained entities
	if ( ent:IsConstraint() || constraintClasses[ ent:GetClass() ] ) then
		for i = 1, 6 do
			local entX = ent[ "Ent" .. i ]
			if ( IsValid( entX ) and entX.Constraints ) then
				table.RemoveByValue( entX.Constraints, ent )
			end
		end
	end

	-- Update constraint system entity's constraint count
	local constSystem = SystemLookup[ ent ]
	if ( !IsValid( constSystem ) ) then return end

	constSystem.__ConstraintCount = ( constSystem.__ConstraintCount or 0 ) - 1

	if ( constSystem.__ConstraintCount <= 0 ) then
		constSystem.__BadConstraintSystem = true
		constSystem:Remove()
	end

end )

local function ConstraintCreated( constr )
	assert( IsValid( CurrentSystem ) )
	SystemLookup[ constr ] = CurrentSystem
	CurrentSystem.__ConstraintCount = ( CurrentSystem.__ConstraintCount or 0 ) + 1
end


--[[----------------------------------------------------------------------
	CreateConstraintSystem
------------------------------------------------------------------------]]
local function CreateConstraintSystem()

	local iterations = GetConVarNumber( "gmod_physiterations" )

	local csystem = ents.Create( "phys_constraintsystem" )
	if ( !IsValid( csystem ) ) then return end

	csystem:SetKeyValue( "additionaliterations", iterations )
	csystem:Spawn()
	csystem:Activate()
	csystem.__ConstraintCount = 0

	return csystem

end


--[[----------------------------------------------------------------------
	FindOrCreateConstraintSystem

	Takes 2 entities. If the entities don't have a constraint system
	associated with them it creates one and associates it with them.

	It then returns the constraint system
------------------------------------------------------------------------]]
local function FindOrCreateConstraintSystem( ent1, ent2 )

	local system = NULL

	ent2 = ent2 or ent1

	-- Does Ent1 have a constraint system?
	if ( !ent1:IsWorld() && IsValid( ent1.ConstraintSystem ) && !ent1.ConstraintSystem.__BadConstraintSystem ) then
		system = ent1.ConstraintSystem
	end

	-- Don't add to this system - we have too many constraints on it already.
	if ( IsValid( system ) && ( system.__ConstraintCount or 0 ) >= MAX_CONSTRAINTS_PER_SYSTEM ) then system = nil end

	-- Does Ent2 have a constraint system?
	if ( !IsValid( system ) && !ent2:IsWorld() && IsValid( ent2.ConstraintSystem ) && !ent2.ConstraintSystem.__BadConstraintSystem ) then
		system = ent2.ConstraintSystem
	end

	-- Don't add to this system - we have too many constraints on it already.
	if ( IsValid( system ) && ( system.__ConstraintCount or 0 ) >= MAX_CONSTRAINTS_PER_SYSTEM ) then system = nil end

	-- No constraint system yet (Or they're both full) - make a new one
	if ( !IsValid( system ) ) then

		--Msg( "New Constrant System\n" )
		system = CreateConstraintSystem()

	end

	ent1.ConstraintSystem = system
	ent2.ConstraintSystem = system

	return system

end


--[[----------------------------------------------------------------------
	onStartConstraint( Ent1, Ent2 )
	Should be called before creating a constraint
------------------------------------------------------------------------]]
local function onStartConstraint( ent1, ent2 )

	-- Get constraint system
	CurrentSystem = FindOrCreateConstraintSystem( ent1, ent2 )

	-- Any constraints called after this call will use this system
	SetPhysConstraintSystem( CurrentSystem )

end

--[[----------------------------------------------------------------------
	onFinishConstraint()
	Should be called before creating a constraint
------------------------------------------------------------------------]]
local function onFinishConstraint()

	-- Turn off constraint system override
	CurrentSystem = nil
	SetPhysConstraintSystem( NULL )

end

local function SetPhysicsCollisions( ent, collisions )

	if ( !IsValid( ent ) or !IsValid( ent:GetPhysicsObject() ) ) then return end

	ent:GetPhysicsObject():EnableCollisions( collisions )

end

--[[----------------------------------------------------------------------
	RemoveConstraints( Ent, Type )
	Removes all constraints of type from entity
------------------------------------------------------------------------]]
function RemoveConstraints( ent, const_type )

	if ( !ent.Constraints ) then return end

	local c = ent.Constraints
	local i = 0

	for k, v in pairs( c ) do

		if ( !IsValid( v ) ) then

			c[ k ] = nil

		elseif ( v.Type == const_type ) then

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
		ent:IsConstrained()
	end

	local bool = i != 0
	return bool, i

end


--[[----------------------------------------------------------------------
	RemoveAll( Ent )
	Removes all constraints from entity
------------------------------------------------------------------------]]
function RemoveAll( ent )

	if ( !ent.Constraints ) then return end

	local c = ent.Constraints
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
	ent:IsConstrained()

	return ( i != 0 ), i

end

--[[----------------------------------------------------------------------
	Find( Ent1, Ent2, Type, Bone1, Bone2 )
	Returns a constraint of given type between the two entities, if one exists
------------------------------------------------------------------------]]
function Find( ent1, ent2, const_type, bone1, bone2 )

	if ( !ent1.Constraints ) then return end

	for k, v in pairs( ent1.Constraints ) do

		if ( IsValid( v ) && v.Type == const_type ) then

			if ( v.Ent1 == ent1 && v.Ent2 == ent2 && v.Bone1 == bone1 && v.Bone2 == bone2 ) then
				return v
			end

			if ( v.Ent2 == ent1 && v.Ent1 == ent2 && v.Bone2 == bone1 && v.Bone1 == bone2 ) then
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
function CanConstrain( ent, bone )

	if ( !ent ) then return false end
	if ( !isnumber( bone ) ) then return false end
	if ( !ent:IsWorld() && !ent:IsValid() ) then return false end
	if ( !IsValid( ent:GetPhysicsObjectNum( bone ) ) ) then return false end

	return true

end

--[[----------------------------------------------------------------------
	CalcElasticConsts( ... )
	This attempts to scale the elastic constraints such as the winch
	to keep a stable but responsive constraint..
------------------------------------------------------------------------]]
local function CalcElasticConsts( phys1, phys2, ent1, ent2, fixed )

	local minMass = 0

	if ( ent1:IsWorld() ) then minMass = phys2:GetMass()
	elseif ( ent2:IsWorld() ) then minMass = phys1:GetMass()
	else
		minMass = math.min( phys1:GetMass(), phys2:GetMass() )
	end

	-- const, damp
	local const = minMass * 100
	local damp = const * 0.2

	if ( !fixed ) then

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
	if ( width <= 0 ) then return end

	-- Clamp the rope to a sensible width
	width = math.Clamp( width, 0.2, 100 )

	local rope = ents.Create( "keyframe_rope" )
	if ( !IsValid( rope ) ) then return end

	rope:SetPos( Pos )
	rope:SetKeyValue( "Width", width )
	rope:SetKeyValue( "TextureScale", "1.6" ) -- Preserve old scaling before 28 July 2025

	if ( isstring( material ) and material != "" ) then
		-- Check if the material looks right. Do not allow missing materials. Do not allow weird shaders.
		-- This is not ideal because it is tested on the server, but whatever. Better than checking "RopeMaterials" list.
		local mat = Material( material )
		local shader = mat:GetShader():lower()
		local shaderGood = shader == "cable_dx9" or shader == "cable_dx8" or shader == "cable" or shader == "unlitgeneric" or shader == "splinerope"
		if ( mat and !mat:IsError() and shaderGood ) then
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
function AddConstraintTable( ent, constraint, ent2, ent3, ent4 )

	if ( !IsValid( constraint ) ) then return end

	if ( IsValid( ent ) || ( ent && ent:IsWorld() ) ) then
		ent.Constraints = ent.Constraints or {}
		table.insert( ent.Constraints, constraint )
		ent:DeleteOnRemove( constraint )
	end

	if ( ent2 && ent2 != ent ) then
		AddConstraintTable( ent2, constraint, ent3, ent4 )
	end

end

--[[----------------------------------------------------------------------
	AddConstraintTableNoDelete( Ent, Constraint, Ent2, Ent3, Ent4 )
	Stores info about the constraints on the entity's table
------------------------------------------------------------------------]]
function AddConstraintTableNoDelete( ent, constraint, ent2, ent3, ent4 )

	if ( !IsValid( constraint ) ) then return end

	if ( IsValid( ent ) || ( ent && ent:IsWorld() ) ) then
		ent.Constraints = ent.Constraints or {}
		table.insert( ent.Constraints, constraint )
	end

	if ( ent2 && ent2 != ent ) then
		AddConstraintTableNoDelete( ent2, constraint, ent3, ent4 )
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

	onFinishConstraint()

	-- Optionally delete Ent1 when the weld is broken
	-- This is to fix bug #310
	if ( deleteonbreak ) then
		Ent2:DeleteOnRemove( Ent1 )
	end

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

	AddConstraintTable( Ent1, Constraint, Ent2 )

	Phys1:Wake()
	Phys2:Wake()

	return Constraint

end
duplicator.RegisterConstraint( "Weld", Weld, "Ent1", "Ent2", "Bone1", "Bone2", "forcelimit", "nocollide", "deleteonbreak" )


--[[----------------------------------------------------------------------
	Rope( ... )
	Creates a rope constraint - with rope!
------------------------------------------------------------------------]]
function Rope( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, length, addLength, forcelimit, width, material, rigid, color )

	if ( !CanConstrain( Ent1, Bone1 ) ) then return false end
	if ( !CanConstrain( Ent2, Bone2 ) ) then return false end

	local Phys1 = Ent1:GetPhysicsObjectNum( Bone1 )
	local Phys2 = Ent2:GetPhysicsObjectNum( Bone2 )
	local WPos1 = Phys1:LocalToWorld( LPos1 )
	local WPos2 = Phys2:LocalToWorld( LPos2 )
	addLength = math.Clamp( addLength or 0, -56756, 56756 )

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
			Constraint:SetKeyValue( "length", length + addLength )
			if ( forcelimit ) then Constraint:SetKeyValue( "forcelimit", forcelimit ) end
			if ( rigid ) then Constraint:SetKeyValue( "spawnflags", 2 ) end
			Constraint:SetPhysConstraintObjects( Phys1, Phys2 )
			Constraint:Spawn()
			Constraint:Activate()

		onFinishConstraint()

	end

	-- Make Rope
	local kv = {
		Length = length + addLength,
		Collide = 1
	}
	if ( rigid ) then kv.Type = 2 end

	local rope = CreateKeyframeRope( WPos1, width, material, Constraint, Ent1, LPos1, Bone1, Ent2, LPos2, Bone2, kv )
	if ( IsValid( rope ) && color ) then rope:SetColor( color ) end

	-- What the fuck
	if ( !Constraint ) then Constraint, rope = rope, nil end

	if ( IsValid( Constraint ) ) then
		local ctable = {
			Type = "Rope",
			Ent1 = Ent1,
			Ent2 = Ent2,
			Bone1 = Bone1,
			Bone2 = Bone2,
			LPos1 = LPos1,
			LPos2 = LPos2,
			length = length,
			addlength = addLength,
			forcelimit = forcelimit,
			width = width,
			material = material,
			rigid = rigid,
			color = color
		}
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

		onFinishConstraint()

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

		AddConstraintTable( Ent1, Constraint, Ent2 )

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
	-- This was once here. Is there any specific reason this was the case?
	--if ( Ent:GetClass() != "prop_physics" && Ent:GetClass() != "prop_ragdoll" ) then return false end
	if ( Ent:IsPlayer() || Ent:IsWorld() ) then return false end
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

	onFinishConstraint()

	local ctable = {
		Type = "Keepupright",
		Ent1 = Ent,
		Ang = Ang,
		Bone = Bone,
		angularlimit = angularlimit
	}
	Constraint:SetTable( ctable )

	AddConstraintTable( Ent, Constraint )

	--
	-- This is a hack to keep the KeepUpright context menu in sync..
	--
	Ent:SetNWBool( "IsUpright", true )

	return Constraint

end
duplicator.RegisterConstraint( "Keepupright", Keepupright, "Ent1", "Ang", "Bone", "angularlimit" )


function CreateStaticAnchorPoint( pos )

	-- Creates an invisible frozen, not interactive prop.
	local anchor = ents.Create( "gmod_anchor" )
	if ( !IsValid( anchor ) ) then return end

	anchor:SetPos( pos )
	anchor:Spawn()
	anchor:Activate()

	return anchor, anchor:GetPhysicsObject(), 0, vector_origin

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

	onFinishConstraint()

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

	AddConstraintTable( Ent1, Constraint, Ent2 )

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

	onFinishConstraint()

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

	if ( !DontAddTable ) then
		AddConstraintTable( Ent1, Constraint, Ent2 )
	end

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

	onFinishConstraint()

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

	AddConstraintTable( Ent1, Constraint, Ent2 )

	return Constraint

end
duplicator.RegisterConstraint( "AdvBallsocket", AdvBallsocket, "Ent1", "Ent2", "Bone1", "Bone2", "LPos1", "LPos2", "forcelimit", "torquelimit", "xmin", "ymin", "zmin", "xmax", "ymax", "zmax", "xfric", "yfric", "zfric", "onlyrotation", "nocollide" )


--[[----------------------------------------------------------------------
	NoCollide( ... )
	Creates an nocollide `constraint'
------------------------------------------------------------------------]]
function NoCollide( Ent1, Ent2, Bone1, Bone2, disableOnRemove )

	if ( !CanConstrain( Ent1, Bone1 ) ) then return false end
	if ( !CanConstrain( Ent2, Bone2 ) ) then return false end

	local Phys1 = Ent1:GetPhysicsObjectNum( Bone1 )
	local Phys2 = Ent2:GetPhysicsObjectNum( Bone2 )

	if ( Phys1 == Phys2 ) then return false end

	if ( Find( Ent1, Ent2, "NoCollide", Bone1, Bone2 ) ) then return false end

	-- Make Constraint
	local constr = ents.Create( "logic_collision_pair" )
	if ( !IsValid( constr ) ) then return end

	constr:SetKeyValue( "startdisabled", 1 )
	if ( disableOnRemove ) then constr:SetKeyValue( "disable_on_remove", 1 ) end
	constr:SetPhysConstraintObjects( Phys1, Phys2 )
	constr:Spawn()
	constr:Activate()
	constr:Input( "DisableCollisions" )

	local ctable = {
		Type = "NoCollide",
		Ent1 = Ent1,
		Ent2 = Ent2,
		Bone1 = Bone1,
		Bone2 = Bone2,
		disableOnRemove = disableOnRemove
	}
	constr:SetTable( ctable )

	AddConstraintTable( Ent1, constr, Ent2 )

	return constr

end
duplicator.RegisterConstraint( "NoCollide", NoCollide, "Ent1", "Ent2", "Bone1", "Bone2", "disableOnRemove" )


--[[----------------------------------------------------------------------
	MotorControl( pl, motor, onoff, dir )
	Numpad controls for the motor constraints
------------------------------------------------------------------------]]
local function MotorControl( pl, motor, onoff, dir )

	if ( !IsValid( motor ) ) then return false end

	local activate = false

	if ( motor.toggle == 1 || motor.toggle == true ) then

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

		-- Make sure the internal axis is set on spawn, not on first activation
		Constraint:Fire( "Scale", 0 )
		Constraint:Fire( "Activate" )

	onFinishConstraint()

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
		direction = direction or 1,
		is_on = false,
		numpadkey_fwd = numpadkey_fwd,
		numpadkey_bwd = numpadkey_bwd,
		LocalAxis = LocalAxis
	}
	Constraint:SetTable( ctable )

	AddConstraintTableNoDelete( Ent1, Constraint, Ent2 )

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

	onFinishConstraint()

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

	AddConstraintTable( Ent1, Constraint, Ent4 )

	-- make Rope
	local world = game.GetWorld()

	local kv = {
		Collide = 1,
		Type = 2,
		Subdiv = 1,
	}

	local rope1 = CreateKeyframeRope( WPos1, width, material, Constraint, Ent1, LPos1, Bone1, world, WPos2, 0, kv )
	local rope2 = CreateKeyframeRope( WPos1, width, material, Constraint, world, WPos3, 0, world, WPos2, 0, kv )
	local rope3 = CreateKeyframeRope( WPos1, width, material, Constraint, world, WPos3, 0, Ent4, LPos4, Bone4, kv )
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

	onFinishConstraint()

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

	AddConstraintTable( Ent1, Constraint, Ent2 )

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
function Hydraulic( pl, Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, lengthMin, lengthMax, width, key, fixed, speed, material, toggle, color )

	if ( !CanConstrain( Ent1, Bone1 ) ) then return false end
	if ( !CanConstrain( Ent2, Bone2 ) ) then return false end

	local Phys1 = Ent1:GetPhysicsObjectNum( Bone1 )
	local Phys2 = Ent2:GetPhysicsObjectNum( Bone2 )
	-- local WPos1 = Phys1:LocalToWorld( LPos1 )
	-- local WPos2 = Phys2:LocalToWorld( LPos2 )

	if ( Phys1 == Phys2 ) then return false end
	if ( toggle == nil ) then toggle = true end -- Retain original behavior

	local const, dampn = CalcElasticConsts( Phys1, Phys2, Ent1, Ent2, tobool( fixed ) )

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
		Length1 = lengthMin,
		Length2 = lengthMax,
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
			slider.Type = nil -- Do not duplicate this one!
			Constraint:DeleteOnRemove( slider )
		end

		local controller = ents.Create( "gmod_winch_controller" )
		if ( lengthMax > lengthMin ) then
			controller:SetKeyValue( "minlength", lengthMin )
			controller:SetKeyValue( "maxlength", lengthMax )
		else
			controller:SetKeyValue( "minlength", lengthMax )
			controller:SetKeyValue( "maxlength", lengthMin )
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

	local const, dampn = CalcElasticConsts( Phys1, Phys2, Ent1, Ent2, tobool( fixed ) )

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
		slider.Type = nil -- Do not duplicate this one!
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
function GetAllConstrainedEntities( ent, result )

	local results = result or {}

	if ( !IsValid( ent ) && !ent:IsWorld() ) then return end
	if ( results[ ent ] ) then return end

	results[ ent ] = ent

	local conTable = GetTable( ent )

	for k, con in ipairs( conTable ) do

		for EntNum, Ent in pairs( con.Entity ) do
			if ( !Ent.Entity:IsWorld() ) then
				GetAllConstrainedEntities( Ent.Entity, results )
			end
		end

	end

	return results

end
