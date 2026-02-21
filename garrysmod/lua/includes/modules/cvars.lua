
local table				= table
local type				= type
local istable 			= istable
local isstring			= isstring
local assert			= assert
local format			= string.format
local GetConVar			= GetConVar

--[[---------------------------------------------------------
	Name: cvar
	Desc: Callbacks when cvars change
-----------------------------------------------------------]]
module( "cvars" )

local ConVars = {}

--[[---------------------------------------------------------
	Name: GetConVarCallbacks
	Desc: Returns a table of the given ConVars callbacks
-----------------------------------------------------------]]
function GetConVarCallbacks( name, createIfNotFound )

	local tab = ConVars[ name ]
	if ( createIfNotFound and !tab ) then
		tab = {}
		ConVars[ name ] = tab
	end

	return tab

end

--[[---------------------------------------------------------
	Name: OnConVarChanged
	Desc: Called by the engine
-----------------------------------------------------------]]
function OnConVarChanged( name, old, new )

	local tab = GetConVarCallbacks( name )
	if ( !tab ) then return end

	for i = 1, #tab do
		local callback = tab[ i ]
		if ( istable( callback ) ) then
			callback[ 1 ]( name, old, new )
		else
			callback( name, old, new )
		end
	end

end

--[[---------------------------------------------------------
	Name: AddChangeCallback
	Desc: Adds a callback to be called when convar changes
-----------------------------------------------------------]]
function AddChangeCallback( name, func, identifier )

	if ( identifier ) then
		assert( isstring( identifier ), format( "bad argument #%i (string expected, got %s)", 3, type( identifier ) ) )
	end

	local tab = GetConVarCallbacks( name, true )

	if ( !identifier ) then
		table.insert( tab, func )
		return
	end

	for i = 1, #tab do
		local callback = tab[ i ]
		if ( istable( callback ) and callback[ 2 ] == identifier ) then
			callback[ 1 ] = func
			return
		end
	end

	table.insert( tab, { func, identifier } )

end

--[[---------------------------------------------------------
	Name: RemoveChangeCallback
	Desc: Removes callback with identifier
-----------------------------------------------------------]]
function RemoveChangeCallback( name, identifier )

	if ( identifier ) then
		assert( isstring( identifier ), format( "bad argument #%i (string expected, got %s)", 2, type( identifier ) ) )
	end

	local tab = GetConVarCallbacks( name, true )
	for i = 1, #tab do
		local callback = tab[ i ]
		if ( istable( callback ) and callback[ 2 ] == identifier ) then
			table.remove( tab, i )
			break
		end
	end

end

--[[---------------------------------------------------------
	Name: String
	Desc: Retrieves console variable as a string
-----------------------------------------------------------]]
function String( name, default )

	local convar = GetConVar( name )
	if ( convar ~= nil ) then
		return convar:GetString()
	end

	return default

end

--[[---------------------------------------------------------
	Name: Number
	Desc: Retrieves console variable as a number
-----------------------------------------------------------]]
function Number( name, default )

	local convar = GetConVar( name )
	if ( convar ~= nil ) then
		return convar:GetFloat()
	end

	return default

end

--[[---------------------------------------------------------
	Name: Bool
	Desc: Retrieves console variable as a boolean
-----------------------------------------------------------]]
function Bool( name, default )

	local convar = GetConVar( name )
	if ( convar ~= nil ) then
		return convar:GetBool()
	end

	return default

end
