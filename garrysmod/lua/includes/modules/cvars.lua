
local table				= table
local pairs				= pairs
local type				= type
local isstring			= isstring
local istable			= istable
local assert			= assert
local format			= string.format
local GetConVarString	= GetConVarString
local GetConVarNumber	= GetConVarNumber
local ConVarExists		= ConVarExists

--[[---------------------------------------------------------
	Name: cvar
	Desc: Callbacks when cvars change
-----------------------------------------------------------]]
module( "cvars" )

local ConVars = {}

function GetConVarCallbacks( name, CreateIfNotFound )

	local Tab = ConVars[ name ]

	if ( CreateIfNotFound && !Tab ) then
		Tab = {}
		ConVars[ name ] = Tab
	end

	return Tab
end

--[[---------------------------------------------------------
	Name: OnConVarChanged
	Desc: Called by the engine
-----------------------------------------------------------]]
function OnConVarChanged( name, oldvalue, newvalue )

	local Callbacks = GetConVarCallbacks( name )
	if ( !Callbacks ) then return end

	for k, v in pairs( Callbacks ) do

		if ( istable( v ) ) then
			v[ 1 ]( name, oldvalue, newvalue )
		else
			v( name, oldvalue, newvalue )
		end

	end

end

--[[---------------------------------------------------------
	Name: OnConvarChanged
	Desc: Called by the engine
-----------------------------------------------------------]]
function AddChangeCallback( name, func, sIdentifier )

	if ( sIdentifier ) then
		assert( isstring( sIdentifier ), format( "bad argument #%i (string expected, got %s)", 3, type( sIdentifier ) ) )
	end

	local tab = GetConVarCallbacks( name, true )

	if ( sIdentifier ) then
		for i = 1, #tab do
			local a = tab[ i ]

			if ( istable( a ) and a[ 2 ] == sIdentifier ) then
				tab[ i ][ 1 ] = func
				return
			end
		end

		table.insert( tab, { func, sIdentifier } )
	else
		table.insert( tab, func )
	end

end

--[[---------------------------------------------------------
	Name: RemoveChangeCallback
	Desc: Removes callback with identifier
-----------------------------------------------------------]]
function RemoveChangeCallback( name, sIdentifier )

	if ( sIdentifier ) then
		assert( isstring( sIdentifier ), format( "bad argument #%i (string expected, got %s)", 2, type( sIdentifier ) ) )
	end

	local tab = GetConVarCallbacks( name, true )

	for i = 1, #tab do
		local a = tab[ i ]

		if ( istable( a ) and a[ 2 ] == sIdentifier ) then
			table.remove( tab, i )
			break
		end
	end

end

function String( name, default )

	if ( !ConVarExists( name ) ) then return default end

	return GetConVarString( name )

end

function Number( name, default )

	if ( !ConVarExists( name ) ) then return default end

	return GetConVarNumber( name )

end

function Bool( name, default )

	if ( default ) then default = 1 else default = 0 end

	return Number( name, default ) != 0

end
