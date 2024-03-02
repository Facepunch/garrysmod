
local table 	= table
local pairs		= pairs

module( "list" )


local Lists = {}

function Get( listid )

	return table.Copy( GetForEdit( listid ) )

end

function GetForEdit( listid, nocreate )

	local list = Lists[ listid ]

	if ( !nocreate && list == nil ) then
		list = {}
		Lists[ listid ] = list
	end

	return list

end

function GetTable()

	return table.GetKeys( Lists )

end

function Set( listid, key, value )

	GetForEdit( listid )[ key ] = value

end

function Add( listid, value )

	return table.insert( GetForEdit( listid ), value )

end

function Contains( listid, value )

	local list = Lists[ listid ]
	if ( list == nil ) then return false end

	for k, v in pairs( list ) do
		if ( v == value ) then return true end
	end

	return false

end

function HasEntry( listid, key )

	local list = Lists[ listid ]

	return list != nil && list[ key ] != nil

end
