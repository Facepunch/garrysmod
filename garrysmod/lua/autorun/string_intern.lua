---------------
	STRING INTERNING

	Reduces GC pressure and memory fragmentation by maintaining
	a canonical string pool with weak references. When the same
	string is created many times (entity classes, hook names,
	chat messages on RP servers), interning ensures only one
	copy exists in memory.

	Usage:
		local class = string.Intern( ent:GetClass() )
		-- Returns canonical reference, GC can collect unused strings

	API:
		string.Intern( str )     - Return canonical reference
		string.InternCount()     - Number of interned strings
		string.InternClear()     - Clear the pool

	The pool uses weak values so strings with no other references
	are automatically garbage collected.
----------------

local InternPool = setmetatable( {}, { __mode = "v" } )
local InternCount = 0

--
-- Return the canonical reference for a string.
-- If the string is already in the pool, returns the pooled version.
-- If not, adds it and returns it.
--
function string.Intern( str )

	if ( !isstring( str ) ) then return str end

	local existing = InternPool[ str ]
	if ( existing ) then return existing end

	InternPool[ str ] = str
	InternCount = InternCount + 1

	return str

end

--
-- Get the current number of interned strings
--
function string.InternCount()
	-- Recount since weak references may have been collected
	local count = 0
	for k, v in pairs( InternPool ) do
		count = count + 1
	end
	InternCount = count
	return count
end

--
-- Clear the intern pool
--
function string.InternClear()
	InternPool = setmetatable( {}, { __mode = "v" } )
	InternCount = 0
end

--
-- Batch intern all values in a table
--
function string.InternTable( tbl )

	for k, v in pairs( tbl ) do
		if ( isstring( v ) ) then
			tbl[ k ] = string.Intern( v )
		elseif ( istable( v ) ) then
			string.InternTable( v )
		end
	end

	return tbl

end
