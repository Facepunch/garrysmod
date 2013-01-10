


--[[---------------------------------------------------------
   Duplicator module, 
   to add new constraints or entity classes use...
   
   duplicator.RegisterConstraint( "name", funct, ... )
   duplicator.RegisterEntityClass( "class", funct, ... )
   
-----------------------------------------------------------]]

module( "duplicator", package.seeall )


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

local LocalPos = Vector( 0, 0, 0 )
local LocalAng = Angle( 0, 0, 0 )

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

	ConstraintType[ _name_ ] 	= {}
	
	ConstraintType[ _name_ ].Func = _function_;
	ConstraintType[ _name_ ].Args = {...}
	
end


EntityClasses	= EntityClasses or {}

--[[---------------------------------------------------------
   Register an entity's class, to allow it to be duplicated
-----------------------------------------------------------]]
function RegisterEntityClass( _name_ , _function_, ... )

	EntityClasses[ _name_ ] 		= {}
	
	EntityClasses[ _name_ ].Func 	= _function_
	EntityClasses[ _name_ ].Args 	= {...}

	Allow( _name_ )
	
end

--[[---------------------------------------------------------
   Returns an entity class factory
-----------------------------------------------------------]]
function FindEntityClass( _name_ )

	if ( !_name_ ) then return end
	return EntityClasses[ _name_ ]

end

--[[---------------------------------------------------------

-----------------------------------------------------------]]
BoneModifiers 				= BoneModifiers or {}
EntityModifiers				= EntityModifiers or {}

function RegisterBoneModifier( _name_, _function_ )		BoneModifiers[ _name_ ] 			= _function_ end
function RegisterEntityModifier( _name_, _function_ )	EntityModifiers[ _name_ ] 			= _function_ end

if (!SERVER) then return end

--[[---------------------------------------------------------
   Restore's the flex data
-----------------------------------------------------------]]
function DoFlex( ent, Flex, Scale )

	if ( !Flex ) then return end
	if ( !IsValid(ent) ) then return end

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
	if ( !IsValid(ent) ) then return end
	
	for k, v in pairs( Bones ) do
	
		if ( v.s ) then ent:ManipulateBoneScale( k, v.s ) end
		if ( v.a ) then ent:ManipulateBoneAngles( k, v.a ) end
		if ( v.p ) then ent:ManipulateBonePosition( k, v.p ) end
		
	end

end

--[[---------------------------------------------------------
   Applies generic every-day entity stuff for ent from table data.
-----------------------------------------------------------]]
function DoGeneric( ent, data )

	if ( !data ) then return end
	if ( data.Model ) then ent:SetModel( data.Model ) end
	if ( data.Angle ) then ent:SetAngles( data.Angle ) end
	if ( data.Pos ) then ent:SetPos( data.Pos ) end
	if ( data.Skin ) then ent:SetSkin( data.Skin ) end
	if ( data.Flex ) then DoFlex( ent, data.Flex, data.FlexScale ) end
	if ( data.BoneManip ) then DoBoneManipulator( ent, data.BoneManip ) end
	if ( data.ModelScale ) then ent:SetModelScale( data.ModelScale, 0 ) end
	if ( data.ColGroup ) then ent:SetCollisionGroup( data.ColGroup ) end

	--
	-- Restore NetworkVars/DataTable variables (the SetupDataTables values)
	--
	if ( ent.RestoreNetworkVars ) then
		ent:RestoreNetworkVars( data.DT )
	end

end


--[[---------------------------------------------------------
   Applies bone data, generically. 
-----------------------------------------------------------]]
function DoGenericPhysics( Entity, Player, data )

	if (!data) then return end
	if (!data.PhysicsObjects) then return end
	
	for Bone, Args in pairs( data.PhysicsObjects ) do
	
		local Phys = Entity:GetPhysicsObjectNum(Bone)
		
		if ( Phys && Phys:IsValid() && isvector( Args.Pos ) && isangle( Args.Angle ) ) then	

			--
			-- Convert to `local`
			--
			local pos = Args.Pos
			local ang = Args.Angle
			if ( pos && ang ) then

				pos, ang = LocalToWorld( pos, ang, LocalPos, LocalAng )

			end

			Phys:SetPos( pos )
			Phys:SetAngles( ang )

			if ( Args.Frozen == true ) then 
				Phys:EnableMotion( false ) 
				if ( IsValid( Player ) ) then
					Player:AddFrozenPhysicsObject( Entity, Phys )
				end
			end
							
		end
		
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
	
	DoGenericPhysics( Entity, Player, data )	
	
	table.Add( Entity:GetTable(), data )
	
	return Entity
	
end

--[[---------------------------------------------------------
	Automates the process of adding crap the EntityMods table
-----------------------------------------------------------]]
function StoreEntityModifier( Entity, Type, Data )

	if (!Entity) then return end
	if (!Entity:IsValid()) then return end

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

	if (!Entity) then return end
	if (!Entity:IsValid()) then return end
	
	Entity.EntityMods = Entity.EntityMods or {}
	Entity.EntityMods[ Type ] = nil

end

--[[---------------------------------------------------------
	Automates the process of adding crap the BoneMods table
-----------------------------------------------------------]]
function StoreBoneModifier( Entity, BoneID, Type, Data )

	if (!Entity) then return end
	if (!Entity:IsValid()) then return end

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

	local Tab = {}

	if ( Ent.PreEntityCopy ) then
		Ent:PreEntityCopy()
	end
	
	table.Merge( Tab, Ent:GetTable() )
	
	if ( Ent.PostEntityCopy ) then
		Ent:PostEntityCopy()
	end

	Tab.Pos = Ent:GetPos()
	Tab.Angle = Ent:GetAngles()
	Tab.Class = Ent:GetClass()
	Tab.Model = Ent:GetModel()
	Tab.Skin = Ent:GetSkin()
	Tab.Mins, Tab.Maxs = Ent:GetCollisionBounds()
	Tab.ColGroup = Ent:GetCollisionGroup()

	Tab.Pos, Tab.Angle = WorldToLocal( Tab.Pos, Tab.Angle, LocalPos, LocalAng )

	Tab.ModelScale = Ent:GetModelScale()
	if ( Tab.ModelScale == 1 ) then Tab.ModelScale = nil end
	
	-- Allow the entity to override the class
	-- This is a hack for the jeep, since it's real class is different from the one it reports as
	-- (It reports a different class to avoid compatibility problems)
	if ( Ent.ClassOverride ) then Tab.Class = Ent.ClassOverride end
	
	Tab.PhysicsObjects = Tab.PhysicsObjects or {}
	
	-- Physics Objects
	local iNumPhysObjects = Ent:GetPhysicsObjectCount()
	for Bone = 0, iNumPhysObjects-1 do 
	
		local PhysObj = Ent:GetPhysicsObjectNum( Bone )
		if ( PhysObj:IsValid() ) then
		
			Tab.PhysicsObjects[ Bone ] = Tab.PhysicsObjects[ Bone ] or {}
			Tab.PhysicsObjects[ Bone ].Pos = PhysObj:GetPos()
			Tab.PhysicsObjects[ Bone ].Angle = PhysObj:GetAngles()
			Tab.PhysicsObjects[ Bone ].Frozen = !PhysObj:IsMoveable()

			Tab.PhysicsObjects[ Bone ].Pos, Tab.PhysicsObjects[ Bone ].Angle = WorldToLocal( Tab.PhysicsObjects[ Bone ].Pos, Tab.PhysicsObjects[ Bone ].Angle, LocalPos, LocalAng )
			
		end
	
	end
	
	-- Flexes
	local FlexNum = Ent:GetFlexNum()
	for i = 0, FlexNum do
	
		Tab.Flex = Tab.Flex or {}
		
		local w = Ent:GetFlexWeight( i );
		if ( w != 0 ) then
			Tab.Flex[ i ] = w
		end
	
	end
	
	Tab.FlexScale = Ent:GetFlexScale()
	
	-- Bone Manipulator
	if ( Ent:HasBoneManipulations() ) then
	
		Tab.BoneManip = {}
	
		for i=0, Ent:GetBoneCount() do
		
			local t = {}
			
			local s = Ent:GetManipulateBoneScale( i )
			local a = Ent:GetManipulateBoneAngles( i )
			local p = Ent:GetManipulateBonePosition( i )
			
			if ( s != Vector( 1, 1, 1 ) ) then	t[ 's' ] = s end
			if ( a != Angle( 0, 0, 0 ) ) then	t[ 'a' ] = a end
			if ( p != Vector( 0, 0, 0 ) ) then	t[ 'p' ] = p end
		
			if ( table.Count( t ) > 0 ) then
				Tab.BoneManip[ i ] = t
			end
		
		end
	
	end

	--
	-- Store networks vars/DT vars (assigned using SetupDataTables)
	--
	if ( Ent.GetNetworkVars ) then
		Tab.DT = Ent:GetNetworkVars();
	end
		
	
	-- Make this function on your SENT if you want to modify the
	--  returned table specifically for your entity.
	if ( Ent.OnEntityCopyTableFinish ) then
		Ent:OnEntityCopyTableFinish( Tab )
	end
	
	-- Store the map creation ID, so if we clean the map and load this
	-- entity we can replace the map entity rather than creating a new one.
	if ( Ent:CreatedByMap() ) then
		Tab.MapCreationID = Ent:MapCreationID();
	end

	--
	-- Exclude this crap
	--
	for k, v in pairs( Tab ) do

		if ( isfunction(v) ) then
			Tab[k] = nil
		end

	end

	Tab.OnDieFunctions			= nil
	Tab.AutomaticFrameAdvance	= nil
	Tab.BaseClass				= nil

	return Tab

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
		local RotMins = v.Mins * 1;
		local RotMaxs = v.Maxs * 1;
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

	for k, v in pairs(Ents) do
		EntTables[ k ] = CopyEntTable( v )
	end
	
	local ConstraintTables = {}
	if ( AddToTable != nil ) then ConstraintTables = AddToTable.Constraints or {} end

	for k, v in pairs(Constraints) do
		ConstraintTables[ k ] = v
	end

	local mins, maxs = WorkoutSize( EntTables )

	return {

		Entities		=	EntTables,
		Constraints		=	ConstraintTables,
		Mins			=	mins,
		Maxs			=	maxs

	}

end

--[[---------------------------------------------------------
-----------------------------------------------------------]]
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
	
	if ( ReplaceMapEntities && EntTable.MapCreationID != nil ) then
		
		local del = ents.GetMapCreatedEntity( EntTable.MapCreationID )
		if ( IsValid( del ) ) then del:Remove(); end
		
	end
	
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
				if ( Key == "Bone"..i ) then Val = Constraint.Entity[ i ].Bone end
				if ( Key == "LPos"..i ) then Val = Constraint.Entity[ i ].LPos end
				if ( Key == "WPos"..i ) then Val = Constraint.Entity[ i ].WPos end
				if ( Key == "Length"..i ) then Val = Constraint.Entity[ i ].Length end
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
	-- Copy the table - because we're gonna be changing some stuff on it.	
	--
	local EntityList = table.Copy( EntityList );
	local ConstraintList = table.Copy( ConstraintList );

	local CreatedEntities = {}
	
	--
	-- Create the Entities
	--
	for k, v in pairs( EntityList ) do
	
		local e = nil
		local b = ProtectedCall( function() e = CreateEntityFromTable( Player, v ) end )
		if  ( !b ) then continue; end

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
	
		local Entity = CreateConstraintFromTable( Constraint, CreatedEntities )
		
		if ( Entity && Entity:IsValid() ) then
			table.insert( CreatedConstraints, Entity )
		end
	
	end


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
        if ( !Ent.PhysicsObjects[Bone] ) then continue end

		-- Loop through each modifier on this bone 
        for Type, Data in pairs(Types) do
 
			-- Find and all the function
            local ModFunction = BoneModifiers[Type];
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
	local classname = ent:GetClass();
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

