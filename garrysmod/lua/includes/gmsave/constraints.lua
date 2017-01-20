
local function GetPhysicsObjectNum( ent, object )

	for k = 0, ent:GetPhysicsObjectCount() - 1 do

		local obj = ent:GetPhysicsObjectNum( k )
		if ( obj == object ) then return k end

	end

	return 0

end

function gmsave.ConstraintSave( ent )

	local t = {}

	t.EntOne, t.EntTwo = ent:GetConstrainedEntities()
	local PhysA, PhysB = ent:GetConstrainedPhysObjects()

	t.BoneOne = GetPhysicsObjectNum( t.EntOne, PhysA )
	t.BoneTwo = GetPhysicsObjectNum( t.EntTwo, PhysB )

	t.EntOne = gmsave.EntityEncode( t.EntOne )
	t.EntTwo = gmsave.EntityEncode( t.EntTwo )

	return t

end

--
-- Creates a save table from a table of entities
--
function gmsave.ConstraintSaveList( ents )

	local SavedConstraints = {}

	for k, v in pairs( ents ) do

		if ( !IsValid( v ) ) then continue end
		if ( !v:IsConstraint() ) then continue end

		SavedConstraints[ k ] = gmsave.ConstraintSave( v )

	end

	return SavedConstraints

end

--
-- Creates a single entity from a table
--
function gmsave.ConstraintLoad( t, ent, ents )

	local EntOne = gmsave.EntityDecode( t.EntOne, ents )
	local EntTwo = gmsave.EntityDecode( t.EntTwo, ents )

	local PhysOne = EntOne:GetPhysicsObjectNum( t.BoneOne )
	local PhysTwo = EntTwo:GetPhysicsObjectNum( t.BoneTwo )

	ent:SetPhysConstraintObjects( PhysOne, PhysTwo )
	ent:SetParent( ent.LoadData.m_pParent )
	ent:Spawn()
	ent:Activate()

	gmsave.ApplyValuesToEntity( ent, ent.LoadData, ent.LoadData.lua_variables, ents )
	ent.LoadData = nil

end

--
-- Restores multiple entitys from a table
--
function gmsave.ConstraintsLoadFromTable( tab, ents )

	if ( !tab ) then return end

	for k, v in pairs( tab ) do

		local ent = ents[ k ]
		if ( !IsValid( ent ) ) then continue end

		gmsave.ConstraintLoad( v, ent, ents )

	end

end
