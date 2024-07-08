local gmod = gmod
local pairs = pairs
local isfunction = isfunction
local isstring = isstring
local isnumber = isnumber
local isbool = isbool
local IsValid = IsValid
local type = type
local ErrorNoHaltWithStack = ErrorNoHaltWithStack

module( "hook" )

local Hooks = {}

--[[---------------------------------------------------------
    Name: GetTable
    Desc: Returns a table of all hooks.
-----------------------------------------------------------]]
function GetTable()
	return Hooks
end

--[[---------------------------------------------------------
    Name: Add
    Args: string hookName, any identifier, function func
    Desc: Add a hook to listen to the specified event.
-----------------------------------------------------------]]
function Add( event_name, name, func )

	if ( !isstring( event_name ) ) then ErrorNoHaltWithStack( "bad argument #1 to 'Add' (string expected, got " .. type( event_name ) .. ")" ) return end
	if ( !isfunction( func ) ) then ErrorNoHaltWithStack( "bad argument #3 to 'Add' (function expected, got " .. type( func ) .. ")" ) return end

	local notValid = name == nil || isnumber( name ) or isbool( name ) or isfunction( name ) or !name.IsValid or !IsValid( name )
	if ( !isstring( name ) and notValid ) then ErrorNoHaltWithStack( "bad argument #2 to 'Add' (string expected, got " .. type( name ) .. ")" ) return end

	if ( Hooks[ event_name ] == nil ) then
		Hooks[ event_name ] = {}
	end

	Hooks[ event_name ][ name ] = func

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
    Name: Temporary
    Args: string hookName, any identifier, integer max_runs, function func
    Desc: Add a temporary hook that removes itself after running.
-----------------------------------------------------------]]
function Temporary( event_name, name, max_runs, func )
	--Validate first arg to be a string
	if ( !isstring( event_name ) ) then ErrorNoHaltWithStack( "bad argument #1 to 'Temporary' (string expected, got " .. type( event_name ) .. ")" ) return end

	--Validate second arg to be a string
	local notValid = name == nil || isnumber( name ) or isbool( name ) or isfunction( name ) or !name.IsValid or !IsValid( name )
	if ( !isstring( name ) and notValid ) then ErrorNoHaltWithStack( "bad argument #2 to 'Temporary' (string expected, got " .. type( name ) .. ")" ) return end

	
	local runs = 0		--Times the hook has been ran
	local maxRuns		--Max number of runs before removing the hook
	local RunFunction	--The function we run in the actual hook

	--Verify that the hook was provided a function and a number of times to run
	if func and isfunction( func ) then	--Validate that the fourth arg is a function
		--validate the third arg to be a number
		if !isnumber( max_runs ) then ErrorNoHaltWithStack( "bad argument #3 to 'Temporary' (number expected, got " .. type( event_name ) .. ")" ) return end

		maxRuns = max_runs	--Set the maxRuns variable
		RunFunction = func	--Store the function to run
	else
		--Validate the third arg to be a function
		if !max_runs or !isfunction( max_runs ) then ErrorNoHaltWithStack( "bad argument #3 to 'Temporary' (function expected, got " .. type( name ) .. ")" ) return end

		maxRuns = 1		--Assume this hook should only be ran once before removing itself
		RunFunction = max_runs	--As a failsafe, assume the max_runs argument is the function
	end

	--Logic from hook.Add and hook.Remove migrated over to reduce overhead from double validation of arguments
	if Hooks[ event_name ] == nil then
		Hooks[ event_name ] = {}
	end

	Hooks[ event_name ][ name ] = function( ... ) 	--Utilize the Add function internally to create the one time use hook
		runs = runs + 1
		if runs >= maxRuns and Hooks[ event_name ] ~= nil then
			Hooks[ event_name ][ name ] = nil
		end

		return RunFunction( ... ) 		--Run our original hook function and return it's values or nil
	end
end


--[[---------------------------------------------------------
    Name: Exists
    Args: string hookName, identifier
    Desc: Returns if the hook exists or not
-----------------------------------------------------------]]
function Exists( event_name, name )

	if ( !isstring( event_name ) ) then ErrorNoHaltWithStack( "bad argument #1 to 'Exists' (string expected, got " .. type( event_name ) .. ")" ) return end

	local notValid = isnumber( name ) or isbool( name ) or isfunction( name ) or !name.IsValid or !IsValid( name )
	if ( !isstring( name ) and notValid ) then ErrorNoHaltWithStack( "bad argument #2 to 'Exists' (string expected, got " .. type( name ) .. ")" ) return end

	if ( Hooks[ event_name ] and Hooks[ event_name ][ name ] ) then return true end	--Return true if the hook exists

	return false	--Otherwise return false

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
    Name: Run
    Args: string hookName, table gamemodeTable, vararg args
    Desc: Calls hooks associated with the hook name.
-----------------------------------------------------------]]
function Call( name, gm, ... )

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

	--
	-- Call the gamemode function
	--
	if ( !gm ) then return end

	local GamemodeFunction = gm[ name ]
	if ( GamemodeFunction == nil ) then return end

	return GamemodeFunction( gm, ... )

end
