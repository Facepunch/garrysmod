local pairs		= pairs
local table 	= table


module( "list" )


local Lists = {}

function GetStored( listid )
	return Lists[ listid ]
end

function GetForEdit( listid )
	local list = Lists[ listid ]

	if ( list == nil ) then
		list = {}
		Lists[ listid ] = list
	end

	return list
end

function Get( listid )
	return table.Copy( GetForEdit( listid ) )
end

function GetTable()
	return table.GetKeys( Lists )
end

function Set( listid, key, val )
	GetForEdit( listid )[ key ] = val
end

function Add( listid, val )
	return table.insert( GetForEdit( listid ), val )
end

function Contains( listid, val )
	local list = Lists[ listid ]
	if ( list == nil ) then return false end

	for k, v in pairs( list ) do
		if ( v == val ) then return true end
	end

	return false
end

function HasEntry( listid, key )
	local list = Lists[ listid ]

	return list != nil && list[ key ] != nil
end
