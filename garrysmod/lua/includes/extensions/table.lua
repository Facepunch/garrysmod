
function table.Pack( ... )
	return { ... }, select( "#", ... )
end

--[[---------------------------------------------------------
	Name: Inherit( t, base )
	Desc: Copies any missing data from base to t
-----------------------------------------------------------]]
function table.Inherit( t, base )

	for k, v in pairs( base ) do
		if ( t[ k ] == nil ) then t[ k ] = v end
	end

	t[ "BaseClass" ] = base

	return t

end

--[[---------------------------------------------------------
	Name: Copy(t, lookup_table)
	Desc: Taken straight from http://lua-users.org/wiki/PitLibTablestuff
		and modified to the new Lua 5.1 code by me.
		Original function by PeterPrade!
-----------------------------------------------------------]]
function table.Copy( t, lookup_table )
	if ( t == nil ) then return nil end

	local copy = {}
	setmetatable( copy, debug.getmetatable( t ) )
	for i, v in pairs( t ) do
		if ( !istable( v ) ) then
			copy[ i ] = v
		else
			lookup_table = lookup_table or {}
			lookup_table[ t ] = copy
			if ( lookup_table[ v ] ) then
				copy[ i ] = lookup_table[ v ] -- we already copied this table. reuse the copy.
			else
				copy[ i ] = table.Copy( v, lookup_table ) -- not yet copied. copy it.
			end
		end
	end
	return copy
end

--[[---------------------------------------------------------
	Name: Empty( tab )
	Desc: Empty a table
-----------------------------------------------------------]]
function table.Empty( tab )
	for k, v in pairs( tab ) do
		tab[ k ] = nil
	end
end

--[[---------------------------------------------------------
	Name: IsEmpty( tab )
	Desc: Returns whether a table has iterable items in it, useful for non-sequential tables
-----------------------------------------------------------]]
function table.IsEmpty( tab )
	return next( tab ) == nil
end

--[[---------------------------------------------------------
	Name: CopyFromTo( FROM, TO )
	Desc: Make TO exactly the same as FROM - but still the same table.
-----------------------------------------------------------]]
function table.CopyFromTo( from, to )

	-- Erase values from table TO
	table.Empty( to )

	-- Copy values over
	table.Merge( to, from )

end

--[[---------------------------------------------------------
	Name: Merge
	Desc: xx
-----------------------------------------------------------]]
function table.Merge( dest, source, forceOverride )

	for k, v in pairs( source ) do
		if ( !forceOverride and istable( v ) and istable( dest[ k ] ) ) then
			-- don't overwrite one table with another
			-- instead merge them recurisvely
			table.Merge( dest[ k ], v )
		else
			dest[ k ] = v
		end
	end

	return dest

end

--[[---------------------------------------------------------
	Name: HasValue
	Desc: Returns whether the value is in given table
-----------------------------------------------------------]]
function table.HasValue( t, val )
	for k, v in pairs( t ) do
		if ( v == val ) then return true end
	end
	return false
end

--[[---------------------------------------------------------
	Name: table.Add( dest, source )
	Desc: Unlike merge this adds the two tables together and discards keys.
-----------------------------------------------------------]]
function table.Add( dest, source )
	-- The tables should be different otherwise this will just freeze the whole game
	if ( dest == source ) then return dest end

	-- At least one of them needs to be a table or this whole thing will fall on its ass
	if ( !istable( source ) ) then return dest end
	if ( !istable( dest ) ) then dest = {} end

	for k, v in pairs( source ) do
		table.insert( dest, v )
	end

	return dest
end

--[[---------------------------------------------------------
	Name: table.SortDesc( table )
	Desc: Like Lua's default sort, but descending
-----------------------------------------------------------]]
function table.SortDesc( t )
	return table.sort( t, function( a, b ) return a > b end )
end

--[[---------------------------------------------------------
	Name: table.SortByKey( table )
	Desc: Returns a table sorted numerically by Key value
-----------------------------------------------------------]]
function table.SortByKey( t, desc )

	local temp = {}

	for key, _ in pairs( t ) do table.insert( temp, key ) end
	if ( desc ) then
		table.sort( temp, function( a, b ) return t[ a ] < t[ b ] end )
	else
		table.sort( temp, function( a, b ) return t[ a ] > t[ b ] end )
	end

	return temp

end

--[[---------------------------------------------------------
	Name: table.Count( table )
	Desc: Returns the number of keys in a table
-----------------------------------------------------------]]
function table.Count( t )
	local i = 0
	for k in pairs( t ) do i = i + 1 end
	return i
end

--[[---------------------------------------------------------
	Name: table.Random( table )
	Desc: Return a random key
-----------------------------------------------------------]]
function table.Random( t )
	local rk = math.random( 1, table.Count( t ) )
	local i = 1
	for k, v in pairs( t ) do
		if ( i == rk ) then return v, k end
		i = i + 1
	end
end

--[[---------------------------------------------------------
	Name: table.Shuffle( table )
	Desc: Performs an inline Fisher-Yates shuffle on the table in O(n) time
-----------------------------------------------------------]]
function table.Shuffle( t )
	local n = #t
	for i = 1, n - 1 do
		local j = math.random( i, n )
		t[ i ], t[ j ] = t[ j ], t[ i ]
	end
end

--[[----------------------------------------------------------------------
	Name: table.IsSequential( table )
	Desc: Returns true if the tables
		keys are sequential
-------------------------------------------------------------------------]]
function table.IsSequential( t )
	local i = 1
	for key, value in pairs( t ) do
		if ( t[ i ] == nil ) then return false end
		i = i + 1
	end
	return true
end

--[[---------------------------------------------------------
	Name: table.ToString( table,name,nice )
	Desc: Convert a simple table to a string
		table = the table you want to convert (table)
		name  = the name of the table (string)
		nice  = whether to add line breaks and indents (bool)
-----------------------------------------------------------]]
local function MakeTable( t, nice, indent, done )
	local str = ""
	done = done or {}
	indent = indent or 0

	local idt = ""
	if ( nice ) then idt = string.rep( "\t", indent ) end

	local nl, tab  = "", ""
	if ( nice ) then nl, tab = "\n", "\t" end

	local sequential = table.IsSequential( t )

	for key, value in pairs( t ) do

		str = str .. idt .. tab .. tab

		if !sequential then
			if ( isnumber( key ) or isbool( key ) ) then
				key = "[" .. tostring( key ) .. "]" .. tab .. "="
			else
				key = tostring( key ) .. tab .. "="
			end
		else
			key = ""
		end

		if ( istable( value ) and !done[ value ] ) then

			if ( IsColor( value ) ) then
				done[ value ] = true
				value = "Color(" .. value.r .. "," .. value.g .. "," .. value.b .. "," .. value.a .. ")"
				str = str .. key .. tab .. value .. "," .. nl
			else
				done[ value ] = true
				str = str .. key .. tab .. '{' .. nl .. MakeTable( value, nice, indent + 1, done )
				str = str .. idt .. tab .. tab .. tab .. tab .. "}," .. nl
			end

		else

			if ( isstring( value ) ) then
				value = '"' .. tostring( value ) .. '"'
			elseif ( isvector( value ) ) then
				value = "Vector(" .. value.x .. "," .. value.y .. "," .. value.z .. ")"
			elseif ( isangle( value ) ) then
				value = "Angle(" .. value.pitch .. "," .. value.yaw .. "," .. value.roll .. ")"
			else
				value = tostring( value )
			end

			str = str .. key .. tab .. value .. "," .. nl

		end

	end
	return str
end

function table.ToString( t, n, nice )
	local nl, tab  = "", ""
	if ( nice ) then nl, tab = "\n", "\t" end

	local str = ""
	if ( n ) then str = n .. tab .. "=" .. tab end
	return str .. "{" .. nl .. MakeTable( t, nice ) .. "}"
end

--[[---------------------------------------------------------
	Name: table.Sanitise( table )
	Desc: Converts a table containing vectors, angles, bools so it can be converted to and from keyvalues
-----------------------------------------------------------]]
function table.Sanitise( t, done )

	done = done or {}
	local tbl = {}

	for k, v in pairs ( t ) do

		if ( istable( v ) and !IsColor( v ) and !done[ v ] ) then

			done[ v ] = true
			tbl[ k ] = table.Sanitise( v, done )

		else

			if ( isvector( v ) ) then

				local x, y, z = v.x, v.y, v.z
				if y == 0 then y = nil end
				if z == 0 then z = nil end
				tbl[ k ] = { __type = "Vector", x = x, y = y, z = z }

			elseif ( isangle( v ) ) then

				local p, y, r = v.pitch, v.yaw, v.roll
				if p == 0 then p = nil end
				if y == 0 then y = nil end
				if r == 0 then r = nil end
				tbl[ k ] = { __type = "Angle", p = p, y = y, r = r }

			elseif ( IsColor( v ) ) then

				local r, g, b, a = v.r, v.g, v.b, v.a
				if r == 255 then r = nil end
				if g == 255 then g = nil end
				if b == 255 then b = nil end
				if a == 255 then a = nil end
				tbl[ k ] = { __type = "Color", r = r, g = g, b = b, a = a }

			elseif ( isbool( v ) ) then

				tbl[ k ] = { __type = "Bool", tostring( v ) }

			else

				tbl[ k ] = tostring( v )

			end

		end

	end

	return tbl

end

--[[---------------------------------------------------------
	Name: table.DeSanitise( table )
	Desc: Converts a Sanitised table back
-----------------------------------------------------------]]
function table.DeSanitise( t, done )

	done = done or {}
	local tbl = {}

	for k, v in pairs ( t ) do

		if ( istable( v ) and !IsColor( v ) and !done[ v ] ) then

			done[ v ] = true

			if ( v.__type ) then

				if ( v.__type == "Vector" ) then

					tbl[ k ] = Vector( v.x or 0, v.y, v.z )

				elseif ( v.__type == "Angle" ) then

					tbl[ k ] = Angle( v.p or 0, v.y, v.r )

				elseif ( v.__type == "Color" ) then

					tbl[ k ] = Color( v.r or 255, v.g or 255, v.b or 255, v.a or 255 )

				elseif ( v.__type == "Bool" ) then

					tbl[ k ] = ( v[ 1 ] == "true" )

				end

			else

				tbl[ k ] = table.DeSanitise( v, done )

			end

		else

			tbl[ k ] = v

		end

	end

	return tbl

end

function table.ForceInsert( t, v )

	if ( t == nil ) then t = {} end

	table.insert( t, v )

	return t

end

--[[---------------------------------------------------------
	Name: table.SortByMember( table )
	Desc: Sorts table by named member
-----------------------------------------------------------]]
function table.SortByMember( tab, memberName, bAsc )

	local TableMemberSort = function( a, b, MemberName, bReverse )

		--
		-- All this error checking kind of sucks, but really is needed
		--
		if ( !istable( a ) ) then return !bReverse end
		if ( !istable( b ) ) then return bReverse end
		if ( !a[ MemberName ] ) then return !bReverse end
		if ( !b[ MemberName ] ) then return bReverse end

		if ( isstring( a[ MemberName ] ) ) then

			if ( bReverse ) then
				return a[ MemberName ]:lower() < b[ MemberName ]:lower()
			else
				return a[ MemberName ]:lower() > b[ MemberName ]:lower()
			end

		end

		if ( bReverse ) then
			return a[ MemberName ] < b[ MemberName ]
		else
			return a[ MemberName ] > b[ MemberName ]
		end

	end

	table.sort( tab, function( a, b ) return TableMemberSort( a, b, memberName, bAsc or false ) end )

end

--[[---------------------------------------------------------
	Name: table.LowerKeyNames( table )
	Desc: Lowercase the keynames of all tables
-----------------------------------------------------------]]
function table.LowerKeyNames( tab )

	local OutTable = {}

	for k, v in pairs( tab ) do

		-- Recurse
		if ( istable( v ) ) then
			v = table.LowerKeyNames( v )
		end

		OutTable[ k ] = v

		if ( isstring( k ) ) then

			OutTable[ k ]  = nil
			OutTable[ string.lower( k ) ] = v

		end

	end

	return OutTable

end

--[[---------------------------------------------------------
	Name: table.CollapseKeyValue( table )
	Desc: Collapses a table with keyvalue structure
-----------------------------------------------------------]]
function table.CollapseKeyValue( Table )

	local OutTable = {}

	for k, v in pairs( Table ) do

		local Val = v.Value

		if ( istable( Val ) ) then
			Val = table.CollapseKeyValue( Val )
		end

		OutTable[ v.Key ] = Val

	end

	return OutTable

end

--[[---------------------------------------------------------
	Name: table.ClearKeys( table, bSaveKey )
	Desc: Clears the keys, converting to a numbered format
-----------------------------------------------------------]]
function table.ClearKeys( Table, bSaveKey )

	local OutTable = {}

	for k, v in pairs( Table ) do
		if ( bSaveKey ) then
			v.__key = k
		end
		table.insert( OutTable, v )
	end

	return OutTable

end

local function keyValuePairs( state )

	state.Index = state.Index + 1

	local keyValue = state.KeyValues[ state.Index ]
	if ( !keyValue ) then return end

	return keyValue.key, keyValue.val

end

local function toKeyValues( tbl )

	local result = {}

	for k, v in pairs( tbl ) do
		table.insert( result, { key = k, val = v } )
	end

	return result

end

local function getKeys( tbl )

	local keys, i = {}, 0

	for k in pairs( tbl ) do
		i = i + 1
		keys[ i ] = k
	end

	return keys

end

--[[---------------------------------------------------------
	A Pairs function
		Sorted by TABLE KEY
-----------------------------------------------------------]]
function SortedPairs( pTable, Desc )

	local keys = getKeys( pTable )

	if ( Desc ) then
		table.sort( keys, function( a, b )
			return a > b
		end )
	else
		table.sort( keys, function( a, b )
			return a < b
		end )
	end

	local i, key = 1, nil
	return function()
		key, i = keys[ i ], i + 1
		return key, pTable[ key ]
	end

end

--[[---------------------------------------------------------
	A Pairs function
		Sorted by VALUE
-----------------------------------------------------------]]
function SortedPairsByValue( pTable, Desc )

	local sortedTbl = toKeyValues( pTable )

	if ( Desc ) then
		table.sort( sortedTbl, function( a, b ) return a.val > b.val end )
	else
		table.sort( sortedTbl, function( a, b ) return a.val < b.val end )
	end

	return keyValuePairs, { Index = 0, KeyValues = sortedTbl }

end

--[[---------------------------------------------------------
	A Pairs function
		Sorted by Member Value (All table entries must be a table!)
-----------------------------------------------------------]]
function SortedPairsByMemberValue( pTable, pValueName, Desc )

	local sortedTbl = toKeyValues( pTable )

	for k, v in pairs( sortedTbl ) do
		v.member = v.val[ pValueName ]
	end

	table.SortByMember( sortedTbl, "member", !Desc )

	return keyValuePairs, { Index = 0, KeyValues = sortedTbl }

end

--[[---------------------------------------------------------
	A Pairs function
-----------------------------------------------------------]]
function RandomPairs( pTable, Desc )

	local sortedTbl = toKeyValues( pTable )

	for k, v in pairs( sortedTbl ) do
		v.rand = math.random( 1, 1000000 )
	end

	-- descending/ascending for a random order, really?
	if ( Desc ) then
		table.sort( sortedTbl, function( a, b ) return a.rand > b.rand end )
	else
		table.sort( sortedTbl, function( a, b ) return a.rand < b.rand end )
	end

	return keyValuePairs, { Index = 0, KeyValues = sortedTbl }

end

--[[---------------------------------------------------------
	GetFirstKey
-----------------------------------------------------------]]
function table.GetFirstKey( t )
	local k, _ = next( t )
	return k
end

function table.GetFirstValue( t )
	local _, v = next( t )
	return v
end

function table.GetLastKey( t )
	local k, _ = next( t, table.Count( t ) - 1 )
	return k
end

function table.GetLastValue( t )
	local _, v = next( t, table.Count( t ) - 1 )
	return v
end

function table.FindNext( tab, val )
	local bfound = false
	for k, v in pairs( tab ) do
		if ( bfound ) then return v end
		if ( val == v ) then bfound = true end
	end

	return table.GetFirstValue( tab )
end

function table.FindPrev( tab, val )

	local last = table.GetLastValue( tab )
	for k, v in pairs( tab ) do
		if ( val == v ) then return last end
		last = v
	end

	return last

end

function table.GetWinningKey( tab )

	local highest = -math.huge
	local winner = nil

	for k, v in pairs( tab ) do
		if ( v > highest ) then
			winner = k
			highest = v
		end
	end

	return winner

end

function table.KeyFromValue( tbl, val )
	for key, value in pairs( tbl ) do
		if ( value == val ) then return key end
	end
end

function table.RemoveByValue( tbl, val )

	local key = table.KeyFromValue( tbl, val )
	if ( !key ) then return false end

	if ( isnumber( key ) ) then
		table.remove( tbl, key )
	else
		tbl[ key ] = nil
	end

	return key

end

function table.KeysFromValue( tbl, val )
	local res = {}
	for key, value in pairs( tbl ) do
		if ( value == val ) then res[ #res + 1 ] = key end
	end
	return res
end

function table.MemberValuesFromKey( tab, key )
	local res = {}
	for k, v in pairs( tab ) do
		if ( istable( v ) and v[ key ] != nil ) then res[ #res + 1 ] = v[ key ] end
	end
	return res
end

function table.Reverse( tbl )

	local len = #tbl
	local ret = {}

	for i = len, 1, -1 do
		ret[ len - i + 1 ] = tbl[ i ]
	end

	return ret

end

function table.ForEach( tab, funcname )

	for k, v in pairs( tab ) do
		funcname( k, v )
	end

end

function table.GetKeys( tab )

	local keys = {}
	local id = 1

	for k, v in pairs( tab ) do
		keys[ id ] = k
		id = id + 1
	end

	return keys

end

function table.Flip( tab )

	local res = {}

	for k, v in pairs( tab ) do
		res[ v ] = k
	end

	return res

end

-- Polyfill for table.move on 32-bit
-- Don't forget to remove this when it's no longer necessary
if ( !table.move ) then
	function table.move( sourceTbl, from, to, dest, destTbl )

		if ( !istable( sourceTbl ) ) then error( "bad argument #1 to 'move' (table expected, got " .. type( sourceTbl ) .. ")", 2 ) end
		if ( !isnumber( from ) ) then error( "bad argument #2 to 'move' (number expected, got " .. type( from ) .. ")", 2 ) end
		if ( !isnumber( to ) ) then error( "bad argument #3 to 'move' (number expected, got " .. type( to ) .. ")", 2 ) end
		if ( !isnumber( dest ) ) then error( "bad argument #4 to 'move' (number expected, got " .. type( dest ) .. ")", 2 ) end
		if ( destTbl != nil ) then
			if ( !istable( destTbl ) ) then error( "bad argument #5 to 'move' (table expected, got " .. type( destTbl ) .. ")", 2 ) end
		else
			destTbl = sourceTbl
		end

		local buffer = { unpack( sourceTbl, from, to ) }

		dest = math.floor( dest - 1 )
		for i, v in ipairs( buffer ) do
			destTbl[ dest + i ] = v
		end

		return destTbl

	end
end
