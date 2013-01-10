--=============================================================================--
--  ___  ___   _   _   _    __   _   ___ ___ __ __
-- |_ _|| __| / \ | \_/ |  / _| / \ | o \ o \\ V /
--  | | | _| | o || \_/ | ( |_n| o ||   /   / \ / 
--  |_| |___||_n_||_| |_|  \__/|_n_||_|\\_|\\ |_|  2007
--										 
--
--  A really simple module to allow easy additions to lists of items
--
--=============================================================================--

local table 	= table

module( "list" )


local g_Lists = {}

--[[---------------------------------------------------------
   Get a list
-----------------------------------------------------------]]
function Get( list )

	g_Lists[ list ] = g_Lists[ list ] or {}
	return table.Copy( g_Lists[ list ] )
	
end

--[[---------------------------------------------------------
   Get a list
-----------------------------------------------------------]]
function GetForEdit( list )

	g_Lists[ list ] = g_Lists[ list ] or {}
	return g_Lists[ list ]
	
end

--[[---------------------------------------------------------
   Set a key value
-----------------------------------------------------------]]
function Set( list, key, value )

	local list = GetForEdit( list )
	list[ key ] = value

end


--[[---------------------------------------------------------
   Add a value to a list
-----------------------------------------------------------]]
function Add( list, value )

	local list = GetForEdit( list )
	table.insert( list, value )

end
