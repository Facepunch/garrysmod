
function ents.FindByClassAndParent( classname, entity )

	if ( !IsValid( entity ) ) then return end

	local out = {}

	for k, v in ipairs( ents.FindByClass( classname ) ) do

		if ( v:GetParent() == entity ) then
			table.insert( out, v )
		end

	end

	if ( out[1] == nil ) then return end

	return out

end


--[[---------------------------------------------------------
	OPTIMISED ENTITY FINDING

	Combined find+filter operations to reduce Lua-side
	iteration overhead on entity-heavy servers.
-----------------------------------------------------------]]


--[[---------------------------------------------------------
	Name: ents.FindByClassInSphere
	Args: string classname, Vector origin, number radius
	Desc: Find entities of a class within a sphere.
	      Combines ents.FindByClass + distance check in one pass.
-----------------------------------------------------------]]
function ents.FindByClassInSphere( classname, origin, radius )

	local out = {}
	local radiusSqr = radius * radius
	local count = 0

	for k, v in ipairs( ents.FindByClass( classname ) ) do

		if ( v:GetPos():DistToSqr( origin ) <= radiusSqr ) then
			count = count + 1
			out[ count ] = v
		end

	end

	return out

end


--[[---------------------------------------------------------
	Name: ents.FindInSphereFiltered
	Args: Vector origin, number radius, string classFilter (optional), function callback (optional)
	Desc: Find entities in sphere with optional class filter and callback.
	      Callback receives (entity) and should return true to include.
	      If both classFilter and callback are given, both must pass.
-----------------------------------------------------------]]
function ents.FindInSphereFiltered( origin, radius, classFilter, callback )

	local out = {}
	local count = 0

	for k, v in ipairs( ents.FindInSphere( origin, radius ) ) do

		local include = true

		if ( classFilter and v:GetClass() != classFilter ) then
			include = false
		end

		if ( include and callback and !callback( v ) ) then
			include = false
		end

		if ( include ) then
			count = count + 1
			out[ count ] = v
		end

	end

	return out

end


--[[---------------------------------------------------------
	Name: ents.FindInBox
	Args: Vector mins, Vector maxs, string classFilter (optional)
	Desc: Find entities within an axis-aligned bounding box.
-----------------------------------------------------------]]
function ents.FindInBox( mins, maxs, classFilter )

	local out = {}
	local count = 0

	for k, v in ipairs( ents.GetAll() ) do

		local pos = v:GetPos()

		if ( pos.x >= mins.x and pos.x <= maxs.x and
			 pos.y >= mins.y and pos.y <= maxs.y and
			 pos.z >= mins.z and pos.z <= maxs.z ) then

			if ( !classFilter or v:GetClass() == classFilter ) then
				count = count + 1
				out[ count ] = v
			end

		end

	end

	return out

end


--[[---------------------------------------------------------
	Name: ents.FindNClosest
	Args: Vector origin, number n, string classFilter (optional)
	Desc: Find the N closest entities to a point.
-----------------------------------------------------------]]
function ents.FindNClosest( origin, n, classFilter )

	local all = classFilter and ents.FindByClass( classFilter ) or ents.GetAll()

	-- Build distance list
	local distList = {}
	local count = 0

	for k, v in ipairs( all ) do
		count = count + 1
		distList[ count ] = { ent = v, dist = v:GetPos():DistToSqr( origin ) }
	end

	-- Sort by distance
	table.sort( distList, function( a, b ) return a.dist < b.dist end )

	-- Return first N
	local out = {}
	local limit = math.min( n, count )

	for i = 1, limit do
		out[ i ] = distList[ i ].ent
	end

	return out

end
