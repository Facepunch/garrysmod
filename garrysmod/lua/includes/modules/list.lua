--=============================================================================--							 
--
--  A really simple module to allow easy additions to lists of items
--
--=============================================================================--

local table 	= table
local pairs		= pairs

module( "list" )


local g_Lists = {}

--
--	Get a list
--
function Get( list )

	g_Lists[ list ] = g_Lists[ list ] or {}
	return table.Copy( g_Lists[ list ] )
	
end

--
--	Get a list
--
function GetForEdit( list )

	g_Lists[ list ] = g_Lists[ list ] or {}
	return g_Lists[ list ]
	
end

--
--	Get all list names
--
function GetTable()

	return table.GetKeys( g_Lists )

end

--
--	Set a key value
--
function Set( list, key, value )

	local list = GetForEdit( list )
	list[ key ] = value

end

--
--	Add a value to a list
--
function Add( list, value )

	local list = GetForEdit( list )
	table.insert( list, value )

end

--
--	Returns true if the list contains the value (as a value - not a key)
--
function Contains( list, value )

	if ( !g_Lists[ list ] ) then return false end

	for k, v in pairs( g_Lists[ list ] ) do

		-- If it contains this entry, bail early
		if ( v == value ) then return true end

	end

	return false

end

--
--	Returns true if the list has an entry
--
function HasEntry( list, key )

	if ( !g_Lists[ list ] ) then return false end
	return g_Lists[ list ][ key ] ~= nil

end
