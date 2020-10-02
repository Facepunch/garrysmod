

--[[---------------------------------------------------------
   Duplicator module,
   to add new constraints or entity classes use...

   duplicator.RegisterConstraint( "name", funct, ... )
   duplicator.RegisterEntityClass( "class", funct, ... )

-----------------------------------------------------------]]

module( "duplicator", package.seeall )

--
-- When saving or loading all coordinates are saved relative to these
--
local LocalPos = Vector( 0, 0, 0 )
local LocalAng = Angle( 0, 0, 0 )

--
-- Should be set to the player that is creating/copying stuff. Can be nil.
--
local ActionPlayer = nil

--
-- The physics object Saver/Loader
--
local PhysicsObject =
{
	Save = function( data, phys )

		data.Pos = phys:GetPos()
		data.Angle = phys:GetAngles()
		data.Frozen = !phys:IsMoveable()
		if ( !phys:IsGravityEnabled() ) then data.NoGrav = true end
		if ( phys:IsAsleep() ) then data.Sleep = true end

		data.Pos, data.Angle = WorldToLocal( data.Pos, data.Angle, LocalPos, LocalAng )

	end,

	Load = function( data, phys )

		if ( isvector( data.Pos ) && isangle( data.Angle ) ) then

			local pos, ang = LocalToWorld( data.Pos, data.Angle, LocalPos, LocalAng )
			phys:SetPos( pos )
			phys:SetAngles( ang )

		end

		-- Let's not Wake or put anything to sleep for now
		--[[
		if ( data.Sleep ) then
			if ( IsValid( phys ) ) then phys:Sleep() end
		else
			phys:Wake()
		end
		]]

		if ( data.Frozen ) then

			phys:EnableMotion( false )

			-- If we're being created by a player then add these to their frozen list so they can unfreeze them all
			if ( IsValid( ActionPlayer ) ) then
				ActionPlayer:AddFrozenPhysicsObject( Entity, phys )
			end

		end

		if ( data.NoGrav ) then phys:EnableGravity( false ) end

	end,
}

--
-- Entity physics saver
--
local EntityPhysics =
{
	--
	-- Loop each bone, calling PhysicsObject.Save
	--
	Save = function( data, Entity )

		local num = Entity:GetPhysicsObjectCount()

		for objectid = 0, num-1 do
	
			local obj = Entity:GetPhysicsObjectNum( objectid )
			if ( !IsValid( obj ) ) then continue end

			data[ objectid ] = {}
			PhysicsObject.Save( data[ objectid ], obj )
	
		end

	end,

	--
	-- Loop each bone, calling PhysicsObject.Load
	--
	Load = function( data, Entity )

		if ( !istable( data ) ) then return end
	
		for objectid, objectdata in pairs( data ) do
	
			local Phys = Entity:GetPhysicsObjectNum( objectid )
			if ( !IsValid( Phys ) ) then continue end
		
			PhysicsObject.Load( objectdata, Phys )
		
		end

	end,
}

--
-- Entity saver
--
local EntitySaver =
{
	--
	-- Called on each entity when saving
	--
	Save = function( data, ent )

		--
		-- Merge the entities actual table with the table we're saving
		-- this is terrible behaviour - but it's what we've always done.
		--
		if ( ent.PreEntityCopy ) then ent:PreEntityCopy() end
		table.Merge( data, ent:GetTable() )
		if ( ent.PostEntityCopy ) then ent:PostEntityCopy() end

		--
		-- Set so me generic variables that pretty much all entities
		-- would like to save.
		--
		data.Pos				= ent:GetPos()
		data.Angle				= ent:GetAngles()
		data.Class				= ent:GetClass()
		data.Model				= ent:GetModel()
		data.Skin				= ent:GetSkin()
		data.Mins, data.Maxs	= ent:GetCollisionBounds()
		data.ColGroup			= ent:GetCollisionGroup()
		data.Name				= ent:GetName()
		data.WorkshopID			= ent:GetWorkshopID()

		data.Pos, data.Angle	= WorldToLocal( data.Pos, data.Angle, LocalPos, LocalAng )

		data.ModelScale			= ent:GetModelScale()
		if ( data.ModelScale == 1 ) then data.ModelScale = nil end

		-- We have no reason to keep the creation ID anymore - but we will
		if ( ent:CreatedByMap() ) then
			data.MapCreationID = ent:MapCreationID()
		end

		-- Allow the entity to override the class
		-- (this is a hack for the jeep, since it's real class is different from the one it reports as)
		if ( ent.ClassOverride ) then data.Class = ent.ClassOverride end

		-- Save the physics
		data.PhysicsObjects = data.PhysicsObjects or {}
		EntityPhysics.Save( data.PhysicsObjects, ent )

	
		-- Flexes
		data.FlexScale = ent:GetFlexScale()
		for i = 0, ent:GetFlexNum() do
	
			local w = ent:GetFlexWeight( i )
			if ( w != 0 ) then
				data.Flex = data.Flex or {}
				data.Flex[ i ] = w
			end
	
		end

		-- Body Groups
		local bg = ent:GetBodyGroups()
		if ( bg ) then

			for k, v in pairs( bg ) do
		
				--
				-- If it has a non default setting, save it.
				--
				if ( ent:GetBodygroup( v.id ) > 0 ) then
	
					data.BodyG = data.BodyG or {}
					data.BodyG[ v.id ] = ent:GetBodygroup( v.id )
	
				end
		
			end

		end
		
		-- Bone Manipulator
		if ( ent:HasBoneManipulations() ) then
	
			data.BoneManip = {}
	
			for i=0, ent:GetBoneCount() do
		
				local t = {}
			
				local s = ent:GetManipulateBoneScale( i )
				local a = ent:GetManipulateBoneAngles( i )
				local p = ent:GetManipulateBonePosition( i )
			
				if ( s != Vector( 1, 1, 1 ) ) then t[ 's' ] = s end -- scale
				if ( a != angle_zero ) then t[ 'a' ] = a end -- angle
				if ( p != vector_origin ) then t[ 'p' ] = p end -- position
		
				if ( !table.IsEmpty( t ) ) then
					data.BoneManip[ i ] = t
				end
		
			end
	
		end

		--
		-- Store networks vars/DT vars (assigned using SetupDataTables)
		--
		if ( ent.GetNetworkVars ) then
			data.DT = ent:GetNetworkVars()
		end
		
	
		-- Make this function on your SENT if you want to modify the
		-- returned table specifically for your entity.
		if ( ent.OnEntityCopyTableFinish ) then
			ent:OnEntityCopyTableFinish( data )
		end

		--
		-- Exclude this crap
		--
		for k, v in pairs( data ) do

			if ( isfunction( v ) ) then
				data[k] = nil
			end

		end

		data.OnDieFunctions = nil
		data.AutomaticFrameAdvance = nil
		data.BaseClass = nil

	end,

	--
	-- Fill in the data!
	--
	Load = function( data, ent )

		if ( !data ) then return end

		-- We do the second check for models because apparently setting the model on an NPC causes some position changes
		-- And to prevent NPCs going into T-pose briefly upon duplicating
		if ( data.Model && data.Model != ent:GetModel() ) then ent:SetModel( data.Model ) end
		if ( data.Angle ) then ent:SetAngles( data.Angle ) end
		if ( data.Pos ) then ent:SetPos( data.Pos ) end
		if ( data.Skin ) then ent:SetSkin( data.Skin ) end
		if ( data.Flex ) then DoFlex( ent, data.Flex, data.FlexScale ) end
		if ( data.BoneManip ) then DoBoneManipulator( ent, data.BoneManip ) end
		if ( data.ModelScale ) then ent:SetModelScale( data.ModelScale, 0 ) end
		if ( data.ColGroup ) then ent:SetCollisionGroup( data.ColGroup ) end
		if ( data.Name ) then ent:SetName( data.Name ) end

		-- Body Groups
		if ( data.BodyG ) then
			for k, v in pairs( data.BodyG ) do
				ent:SetBodygroup( k, v )
			end
		end

		--
		-- Restore NetworkVars/DataTable variables (the SetupDataTables values)
		--
		if ( ent.RestoreNetworkVars ) then
			ent:RestoreNetworkVars( data.DT )
		end

	end,
}

local DuplicateAllowed = {}

--
-- Allow this entity to be duplicated
--
function Allow( classname )

	DuplicateAllowed[ classname ] = true

end

--
-- Returns true if we can copy/paste this entity
--
function IsAllowed( classname )

	return DuplicateAllowed[ classname ]

end

ConstraintType 	= ConstraintType or {}

--
-- When a copy is copied it will be translated according to these
-- If you set them - make sure to set them back to 0 0 0!
--
function SetLocalPos( v ) LocalPos = v * 1 end
function SetLocalAng( v ) LocalAng = v * 1 end

--[[---------------------------------------------------------
	Register a constraint to be duplicated
-----------------------------------------------------------]]
function RegisterConstraint( _name_ , _function_, ... )	

	ConstraintType[ _name_ ] = {}

	ConstraintType[ _name_ ].Func = _function_
	ConstraintType[ _name_ ].Args = { ... }

end

EntityClasses = EntityClasses or {}

--[[---------------------------------------------------------
	Register an entity's class, to allow it to be duplicated
-----------------------------------------------------------]]
function RegisterEntityClass( _name_ , _function_, ... )

	EntityClasses[ _name_ ] = {}

	EntityClasses[ _name_ ].Func = _function_
	EntityClasses[ _name_ ].Args = {...}

	Allow( _name_ )

end

--[[---------------------------------------------------------
   Returns an entity class factory
-----------------------------------------------------------]]
function FindEntityClass( _name_ )

	if ( !_name_ ) then return end
	return EntityClasses[ _name_ ]

end

BoneModifiers = BoneModifiers or {}
EntityModifiers = EntityModifiers or {}

function RegisterBoneModifier( _name_, _function_ ) BoneModifiers[ _name_ ] = _function_ end
function RegisterEntityModifier( _name_, _function_ ) EntityModifiers[ _name_ ] = _function_ end

if ( CLIENT ) then return end

--[[---------------------------------------------------------
   Restore's the flex data
-----------------------------------------------------------]]
function DoFlex( ent, Flex, Scale )

	if ( !Flex ) then return end
	if ( !IsValid( ent ) ) then return end

	for k, v in pairs( Flex ) do
		ent:SetFlexWeight( k, v )
	end

	if ( Scale ) then
		ent:SetFlexScale( Scale )
	end

end

--[[---------------------------------------------------------
   Restore's the bone's data
-----------------------------------------------------------]]
function DoBoneManipulator( ent, Bones )

	if ( !Bones ) then return end
	if ( !IsValid( ent ) ) then return end

	for k, v in pairs( Bones ) do

		if ( v.s ) then ent:ManipulateBoneScale( k, v.s ) end
		if ( v.a ) then ent:ManipulateBoneAngles( k, v.a ) end
		if ( v.p ) then ent:ManipulateBonePosition( k, v.p ) end

	end

end

--[[---------------------------------------------------------
   Generic function for duplicating stuff
-----------------------------------------------------------]]
function GenericDuplicatorFunction( Player, data )

	if ( !IsAllowed( data.Class ) ) then
		-- MsgN( "duplicator: ", data.Class, " isn't allowed to be duplicated!" )
		return
	end

	--
	-- Is this entity 'admin only'?
	--
	if ( IsValid( Player ) && !Player:IsAdmin() ) then

		if ( !scripted_ents.GetMember( data.Class, "Spawnable" ) ) then return end
		if ( scripted_ents.GetMember( data.Class, "AdminOnly" ) ) then return end

	end

	local Entity = ents.Create( data.Class )
	if ( !IsValid( Entity ) ) then return end

	-- TODO: Entity not found - maybe spawn a prop_physics with their model?

	DoGeneric( Entity, data )

	Entity:Spawn()
	Entity:Activate()

	EntityPhysics.Load( data.PhysicsObjects, Entity )

	table.Merge( Entity:GetTable(), data )

	return Entity

end

--[[---------------------------------------------------------
	Automates the process of adding crap the EntityMods table
-----------------------------------------------------------]]
function StoreEntityModifier( Entity, Type, Data )

	if ( !IsValid( Entity ) ) then return end

	Entity.EntityMods = Entity.EntityMods or {}

	-- Copy the data
	local NewData = Entity.EntityMods[ Type ] or {}
	table.Merge( NewData, Data )

	Entity.EntityMods[ Type ] = NewData

end

--[[---------------------------------------------------------
	Clear entity modification
-----------------------------------------------------------]]
function ClearEntityModifier( Entity, Type )

	if ( !IsValid( Entity ) ) then return end

	Entity.EntityMods = Entity.EntityMods or {}
	Entity.EntityMods[ Type ] = nil

end

--[[---------------------------------------------------------
	Automates the process of adding crap the BoneMods table
-----------------------------------------------------------]]
function StoreBoneModifier( Entity, BoneID, Type, Data )

	if ( !IsValid( Entity ) ) then return end

	-- Copy the data
	NewData = {}
	table.Merge( NewData , Data )
	
	-- Add it to the entity
	Entity.BoneMods = Entity.BoneMods or {}
	Entity.BoneMods[ BoneID ] = Entity.BoneMods[ BoneID ] or {}
	
	Entity.BoneMods[ BoneID ][ Type ] = NewData

end

--[[---------------------------------------------------------
	Returns a copy of the passed entity's table
-----------------------------------------------------------]]
function CopyEntTable( Ent )

	local output = {}
	EntitySaver.Save( output, Ent )
	return output

end

--
-- Work out the AABB size
--
function WorkoutSize( Ents )

	local mins = Vector( -1, -1, -1 )
	local maxs = Vector( 1, 1, 1 )


	for k, v in pairs( Ents ) do
	
		if ( !v.Mins || !v.Maxs ) then continue end
		if ( !v.Angle || !v.Pos ) then continue end

		--
		-- Rotate according to the entity!
		--
		local RotMins = v.Mins * 1
		local RotMaxs = v.Maxs * 1
		RotMins:Rotate( v.Angle )
		RotMaxs:Rotate( v.Angle )

		--
		-- This is dumb and the logic is wrong, but it works for now.
		--
		mins.x = math.min( mins.x, v.Pos.x + RotMins.x )
		mins.y = math.min( mins.y, v.Pos.y + RotMins.y )
		mins.z = math.min( mins.z, v.Pos.z + RotMins.z )
		mins.x = math.min( mins.x, v.Pos.x + RotMaxs.x )
		mins.y = math.min( mins.y, v.Pos.y + RotMaxs.y )
		mins.z = math.min( mins.z, v.Pos.z + RotMaxs.z )

		maxs.x = math.max( maxs.x, v.Pos.x + RotMins.x )
		maxs.y = math.max( maxs.y, v.Pos.y + RotMins.y )
		maxs.z = math.max( maxs.z, v.Pos.z + RotMins.z )
		maxs.x = math.max( maxs.x, v.Pos.x + RotMaxs.x )
		maxs.y = math.max( maxs.y, v.Pos.y + RotMaxs.y )
		maxs.z = math.max( maxs.z, v.Pos.z + RotMaxs.z )

	end

	return mins, maxs

end

--[[---------------------------------------------------------
   Copy this entity, and all of its constraints and entities
   and put them in a table.
-----------------------------------------------------------]]
function Copy( Ent, AddToTable )

	local Ents = {}
	local Constraints = {}

	GetAllConstrainedEntitiesAndConstraints( Ent, Ents, Constraints )

	local EntTables = {}
	if ( AddToTable != nil ) then EntTables = AddToTable.Entities or {} end

	for k, v in pairs( Ents ) do
		EntTables[ k ] = CopyEntTable( v )
	end

	local ConstraintTables = {}
	if ( AddToTable != nil ) then ConstraintTables = AddToTable.Constraints or {} end

	for k, v in pairs( Constraints ) do
		ConstraintTables[ k ] = v
	end

	local mins, maxs = WorkoutSize( EntTables )

	return {
		Entities = EntTables,
		Constraints = ConstraintTables,
		Mins = mins,
		Maxs = maxs
	}

end

function CopyEnts( Ents )

	local Ret = { Entities = {}, Constraints = {} }
	
	for k, v in pairs( Ents ) do
	
		Ret = Copy( v, Ret )

	end

	return Ret

end

--[[---------------------------------------------------------
   Create an entity from a table.
-----------------------------------------------------------]]
function CreateEntityFromTable( Player, EntTable )

	--
	-- Convert position/angle to `local`
	--
	if ( EntTable.Pos && EntTable.Angle ) then

		EntTable.Pos, EntTable.Angle = LocalToWorld( EntTable.Pos, EntTable.Angle, LocalPos, LocalAng )

	end

	local EntityClass = FindEntityClass( EntTable.Class )

	-- This class is unregistered. Instead of failing try using a generic
	-- Duplication function to make a new copy..
	if ( !EntityClass ) then
	
		return GenericDuplicatorFunction( Player, EntTable )
	
	end

	-- Build the argument list
	local ArgList = {}

	for iNumber, Key in pairs( EntityClass.Args ) do

		local Arg = nil
	
		-- Translate keys from old system
		if ( Key == "pos" || Key == "position" ) then Key = "Pos" end
		if ( Key == "ang" || Key == "Ang" || Key == "angle" ) then Key = "Angle" end
		if ( Key == "model" ) then Key = "Model" end
		
		Arg = EntTable[ Key ]
		
		-- Special keys
		if ( Key == "Data" ) then Arg = EntTable end
		
		-- If there's a missing argument then unpack will stop sending at that argument so send it as `false`
		if ( Arg == nil ) then Arg = false end
		
		ArgList[ iNumber ] = Arg
		
	end

	-- Create and return the entity
	return EntityClass.Func( Player, unpack(ArgList) )

end


--[[---------------------------------------------------------
  Make a constraint from a constraint table
-----------------------------------------------------------]]
function CreateConstraintFromTable( Constraint, EntityList )

	local Factory = ConstraintType[ Constraint.Type ]
	if ( !Factory ) then return end

	local Args = {}
	for k, Key in pairs( Factory.Args ) do
	
		local Val = Constraint[ Key ]
		
		for i=1, 6 do

			if ( Constraint.Entity[ i ] ) then

				if ( Key == "Ent"..i ) then
					Val = EntityList[ Constraint.Entity[ i ].Index ]
					if ( Constraint.Entity[ i ].World ) then
						Val = game.GetWorld()
					end
				end

				if ( Key == "Bone" .. i ) then Val = Constraint.Entity[ i ].Bone or 0 end
				if ( Key == "LPos" .. i ) then Val = Constraint.Entity[ i ].LPos end
				if ( Key == "WPos" .. i ) then Val = Constraint.Entity[ i ].WPos end
				if ( Key == "Length" .. i ) then Val = Constraint.Entity[ i ].Length or 0 end

			end
		end
		
		-- If there's a missing argument then unpack will stop sending at that argument
		if ( Val == nil ) then Val = false end
		
		table.insert( Args, Val )
	
	end

	local Entity = Factory.Func( unpack(Args) )

	return Entity

end

--[[---------------------------------------------------------
   Given entity list and constranit list, create all entities
   and return their tables
-----------------------------------------------------------]]
function Paste( Player, EntityList, ConstraintList )

	--
	-- Store the player
	--
	local oldplayer = ActionPlayer
	ActionPlayer = Player

	--
	-- Copy the table - because we're gonna be changing some stuff on it.
	--
	local EntityList = table.Copy( EntityList )
	local ConstraintList = table.Copy( ConstraintList )

	local CreatedEntities = {}

	--
	-- Create the Entities
	--
	for k, v in pairs( EntityList ) do
	
		local e = nil
		local b = ProtectedCall( function() e = CreateEntityFromTable( Player, v ) end )
		if ( !b ) then continue end

		if ( IsValid( e ) ) then

			--
			-- Call this here ( as well as before :Spawn) because Spawn/Init might have stomped the values
			--
			if ( e.RestoreNetworkVars ) then
				e:RestoreNetworkVars( v.DT )
			end

			if ( e.OnDuplicated ) then
				e:OnDuplicated( v )
			end

		end

		CreatedEntities[ k ] = e
		
		if ( CreatedEntities[ k ] ) then
		
			CreatedEntities[ k ].BoneMods = table.Copy( v.BoneMods )
			CreatedEntities[ k ].EntityMods = table.Copy( v.EntityMods )
			CreatedEntities[ k ].PhysicsObjects = table.Copy( v.PhysicsObjects )
		
		else
		
			CreatedEntities[ k ] = nil
		
		end
		
	end

	--
	-- Apply modifiers to the created entities
	--
	for EntID, Ent in pairs( CreatedEntities ) do
	
		ApplyEntityModifiers ( Player, Ent )
		ApplyBoneModifiers ( Player, Ent )
	
		if ( Ent.PostEntityPaste ) then
			Ent:PostEntityPaste( Player, Ent, CreatedEntities )
		end
	
	end

	local CreatedConstraints = {}

	--
	-- Create constraints
	--
	for k, Constraint in pairs( ConstraintList ) do

		local Entity = nil
		ProtectedCall( function() Entity = CreateConstraintFromTable( Constraint, CreatedEntities ) end )

		if ( IsValid( Entity ) ) then
			table.insert( CreatedConstraints, Entity )
		end

	end

	ActionPlayer = oldplayer

	return CreatedEntities, CreatedConstraints

end


--[[---------------------------------------------------------
  Applies entity modifiers
-----------------------------------------------------------]]
function ApplyEntityModifiers( Player, Ent )

	if ( !Ent ) then return end
	if ( !Ent.EntityMods ) then return end

	for Type, ModFunction in pairs( EntityModifiers ) do
	
		if ( Ent.EntityMods[ Type ] ) then
	
			ModFunction( Player, Ent, Ent.EntityMods[ Type ] )
			
		end
	end

end


--[[---------------------------------------------------------
  Applies Bone Modifiers
-----------------------------------------------------------]]
function ApplyBoneModifiers( Player, Ent )

	if ( !Ent ) then return end
	if ( !Ent.PhysicsObjects ) then return end
	if ( !Ent.BoneMods ) then return end

	--
	-- Loop every Bone on the entity
	--
	for Bone, Types in pairs( Ent.BoneMods ) do

		-- The physics object isn't valid, skip it.
		if ( !Ent.PhysicsObjects[ Bone ] ) then continue end

		-- Loop through each modifier on this bone
		for Type, Data in pairs( Types ) do

			-- Find and all the function
			local ModFunction = BoneModifiers[ Type ]
			if ( ModFunction ) then
				ModFunction( Player, Ent, Bone, Ent:GetPhysicsObjectNum( Bone ), Data )
			end

		end

	end

end


--[[---------------------------------------------------------
  Returns all constrained Entities and constraints
  This is kind of in the wrong place. No not call this
  from outside of this code. It will probably get moved to
  constraint.lua soon.
-----------------------------------------------------------]]
function GetAllConstrainedEntitiesAndConstraints( ent, EntTable, ConstraintTable )

	if ( !IsValid( ent ) ) then return end

	-- Translate the class name
	local classname = ent:GetClass()
	if ( ent.ClassOverride ) then classname = ent.ClassOverride end
	
	-- Is the entity in the dupe whitelist?
	if ( !IsAllowed( classname ) ) then
		-- MsgN( "duplicator: ", classname, " isn't allowed to be duplicated!" )
		return
	end

	-- Entity doesn't want to be duplicated.
	if ( ent.DoNotDuplicate ) then return end

	EntTable[ ent:EntIndex() ] = ent

	if ( !constraint.HasConstraints( ent ) ) then return end

	local ConTable = constraint.GetTable( ent )

	for key, constraint in pairs( ConTable ) do

		local index = constraint.Constraint:GetCreationID()
		
		if ( !ConstraintTable[ index ] ) then

			-- Add constraint to the constraints table
			ConstraintTable[ index ] = constraint

			-- Run the Function for any ents attached to this constraint
			for key, ConstrainedEnt in pairs( constraint.Entity ) do

				GetAllConstrainedEntitiesAndConstraints( ConstrainedEnt.Entity, EntTable, ConstraintTable )
			
			end
			
		end
	end

	return EntTable, ConstraintTable

end


--
-- Return true if this entity should be removed when RemoveMapCreatedEntities is called
-- We don't want to remove all entities.
--
local function ShouldMapEntityBeRemoved( ent, classname )

	if ( classname == "prop_physics" ) then return true end
	if ( classname == "prop_physics_multiplayer" ) then return true end
	if ( classname == "prop_ragdoll" ) then return true end
	if ( ent:IsNPC() ) then return true end
	if ( IsAllowed( classname ) ) then return true end

	return false

end

--
-- Help to remove certain map created entities before creating the saved entities
-- This is obviously so we don't get duplicate props everywhere. It should be called
-- before calling Paste.
--
function RemoveMapCreatedEntities()

	for k, v in pairs( ents.GetAll() ) do

		if ( v:CreatedByMap() && ShouldMapEntityBeRemoved( v, v:GetClass() ) ) then
			v:Remove()
		end

	end

end

--
-- BACKWARDS COMPATIBILITY - PHASE OUT, RENAME?
--
function DoGenericPhysics( Entity, Player, data )

	if ( !data || !data.PhysicsObjects ) then return end

	EntityPhysics.Load( data.PhysicsObjects, Entity )

end

function DoGeneric( ent, data )

	EntitySaver.Load( data, ent )

end
