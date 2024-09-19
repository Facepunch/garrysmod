local gmod = gmod
local pairs = pairs
local isfunction = isfunction
local isstring = isstring
local isnumber = isnumber
local isbool = isbool
local IsValid = IsValid
local type = type
local ErrorNoHaltWithStack = ErrorNoHaltWithStack
local error = error

module( "hook" )

local Hooks = {}
local Listeners = {}
local ListenersPost = {}

--[[---------------------------------------------------------
    Name: GetTable
    Desc: Returns a table of all hooks.
-----------------------------------------------------------]]
function GetTable()
	return Hooks
end

--[[---------------------------------------------------------
    Name: GetListeners
    Desc: Returns the listeners and post listeners hook tables.
-----------------------------------------------------------]]
function GetListeners()
	return Listeners, ListenersPost
end

--[[---------------------------------------------------------
    Name: Add
    Args: string hookName, any identifier, function func
    Desc: Add a hook to listen to the specified event.
-----------------------------------------------------------]]
function Add( event_name, name, func )

	if ( !isstring( event_name ) ) then ErrorNoHaltWithStack( "bad argument #1 to 'Add' (string expected, got " .. type( event_name ) .. ")") return end
	if ( !isfunction( func ) ) then ErrorNoHaltWithStack( "bad argument #3 to 'Add' (function expected, got " .. type( func ) .. ")") return end

	local notValid = !name or name == true or isnumber( name ) or isfunction( name ) or !IsValid( name )
	if ( !isstring( name ) and notValid ) then ErrorNoHaltWithStack( "bad argument #2 to 'Add' (string expected, got " .. type( name ) .. ")") return end

	if ( Hooks[ event_name ] == nil ) then
		Hooks[ event_name ] = {}
	end

	Hooks[ event_name ][ name ] = func

end

--[[---------------------------------------------------------
    Name: Listen
    Args: string eventName, any name, bool isPost, function func
    Desc: Add a listen only hook to the specified event.
-----------------------------------------------------------]]
function Listen( eventName, name, isPost, func )

	if ( !isstring(eventName) ) then error( "bad argument #1 to 'Listen' (string expected, got " .. type( eventName ) .. ")", 2 ) return end
	if ( !isfunction(func) ) then error( "bad argument #3 to 'Listen' (function expected, got " .. type( func ) .. ")", 2 ) return end

	local notValid = !name or name == true or isnumber( name ) or isfunction( name ) or !IsValid( name )
	if ( !isstring( name ) and notValid ) then error( "bad argument #2 to 'Listen' (string expected, got " .. type( name ) .. ")", 2 ) return end

	local tbl = isPost and ListenersPost or Listeners
	local tab = tbl[ eventName ]

	if ( !tab ) then
		tab = {}
		tbl[ eventName ] = tab
	end

	tab[ name ] = func

end

--[[---------------------------------------------------------
    Name: Remove
    Args: string hookName, identifier
    Desc: Removes the hook with the given indentifier.
-----------------------------------------------------------]]
function Remove( event_name, name )

	if ( !isstring( event_name ) ) then ErrorNoHaltWithStack( "bad argument #1 to 'Remove' (string expected, got " .. type( event_name ) .. ")" ) return end

	local notValid = isnumber( name ) or isbool( name ) or isfunction( name ) or !name.IsValid or !IsValid( name )
	if ( !isstring( name ) and notValid ) then ErrorNoHaltWithStack( "bad argument #2 to 'Remove' (string expected, got " .. type( name ) .. ")" ) return end

	if ( !Hooks[ event_name ] ) then return end

	Hooks[ event_name ][ name ] = nil

end

--[[---------------------------------------------------------
    Name: Forget
    Args: string eventName, any name, bool isPost
    Desc: Removes the listen-only hook with the given indentifier.
-----------------------------------------------------------]]
function Forget( eventName, name, isPost )

	if ( !isstring( eventName ) ) then error( "bad argument #1 to 'Forget' (string expected, got " .. type( eventName ) .. ")", 2 ) return end
	if ( name == nil ) then error( "bad argument #2 to 'Forget' (any value expected, got nil)", 2 ) return end

	local tbl = isPost and ListenersPost or Listeners
	local tab = tbl[ eventName ]

	if ( tab ) then
		tab[ name ] = nil
	end
	
end

--[[---------------------------------------------------------
    Name: Run
    Args: string hookName, vararg args
    Desc: Calls hooks associated with the hook name.
-----------------------------------------------------------]]
function Run( name, ... )
	return Call( name, gmod and gmod.GetGamemode() or nil, ... )
end


--[[---------------------------------------------------------
    Name: Call
    Args: string hookName, table gamemodeTable, vararg args
    Desc: Calls hooks associated with the hook name.
-----------------------------------------------------------]]
local function callHooks( tbl, name, ... )

	local tab = tbl[ name ]
	if ( !tab ) then return end

	for k, func in pairs( tab ) do

		if ( isstring( k ) ) then

			func( ... )

		else
			if ( IsValid( k ) ) then

				func( k, ... ) 

			else

				tab[ k ] = nil

			end
		end

	end

end

function Call( name, gm, ... )

	callHooks( Listeners, name, ... )

	--
	-- Run hooks
	--
	local HookTable = Hooks[ name ]
	if ( HookTable != nil ) then

		local a, b, c, d, e, f;

		for k, v in pairs( HookTable ) do

			if ( isstring( k ) ) then

				--
				-- If it's a string, it's cool
				--
				a, b, c, d, e, f = v( ... )

			else

				--
				-- If the key isn't a string - we assume it to be an entity
				-- Or panel, or something else that IsValid works on.
				--
				if ( IsValid( k ) ) then
					--
					-- If the object is valid - pass it as the first argument (self)
					--
					a, b, c, d, e, f = v( k, ... )
				else
					--
					-- If the object has become invalid - remove it
					--
					HookTable[ k ] = nil
				end
			end

			--
			-- Hook returned a value - it overrides the gamemode function
			--
			if ( a != nil ) then
				return a, b, c, d, e, f
			end

		end
	end

	callHooks( ListenersPost, name, ... )

	--
	-- Call the gamemode function
	--
	if ( !gm ) then return end

	local GamemodeFunction = gm[ name ]
	if ( GamemodeFunction == nil ) then return end

	return GamemodeFunction( gm, ... )

end
