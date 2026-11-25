local gmod = gmod
local pairs = pairs
local isfunction = isfunction
local isstring = isstring
local isnumber = isnumber
local isbool = isbool
local IsValid = IsValid
local type = type
local ErrorNoHaltWithStack = ErrorNoHaltWithStack
local ProtectedCall = ProtectedCall
local xpcall = xpcall

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

	local notValid = name == nil or isnumber( name ) or isbool( name ) or isfunction( name ) or !name.IsValid
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

	local notValid = isnumber( name ) or isbool( name ) or isfunction( name ) or !name.IsValid
	if ( !isstring( name ) and notValid ) then ErrorNoHaltWithStack( "bad argument #2 to 'Remove' (string expected, got " .. type( name ) .. ")" ) return end

	if ( !Hooks[ event_name ] ) then return end

	Hooks[ event_name ][ name ] = nil

end


--[[---------------------------------------------------------
    Name: Run
    Args: string hookName, vararg args
    Desc: Calls hooks associated with the hook name.
-----------------------------------------------------------]]
local currentGM

function Run( name, ... )
	if ( !currentGM ) then
		currentGM = gmod and gmod.GetGamemode() or nil
	end

	return Call( name, currentGM, ... )
end

--[[---------------------------------------------------------
    Name: Call
    Args: string hookName, table gamemodeTable, vararg args
    Desc: Calls hooks associated with the hook name.
-----------------------------------------------------------]]
local function ProtectGamemodeFunction( ok, ... )
	if ( ok ) then return ... end
end

function Call( name, gm, ... )

	--
	-- Run hooks
	--
	local HookTable = Hooks[ name ]
	if ( HookTable != nil ) then

		local _, a, b, c, d, e, f

		for k, v in pairs( HookTable ) do

			if ( isstring( k ) ) then

				--
				-- If it's a string, it's cool
				--
				_, a, b, c, d, e, f = xpcall( v, ErrorNoHaltWithStack, ... )

			else

				--
				-- If the key isn't a string - we assume it to be an entity
				-- Or panel, or something else that IsValid works on.
				--
				if ( IsValid( k ) ) then
					--
					-- If the object is valid - pass it as the first argument (self)
					--
					_, a, b, c, d, e, f = xpcall( v, ErrorNoHaltWithStack, k, ... )
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

	return ProtectGamemodeFunction( xpcall( GamemodeFunction, ErrorNoHaltWithStack, gm, ... ) )

end

--[[---------------------------------------------------------
	Name: CallProtected
	Args: string hookName, table gamemodeTable, vararg args. No return values.
	Desc: Calls hooks associated with the hook name, but protected.
-----------------------------------------------------------]]

function CallProtected( name, gm, ... )

	--
	-- Run hooks
	--
	local HookTable = Hooks[ name ]
	if ( HookTable != nil ) then

		for k, v in pairs( HookTable ) do

			if ( isstring( k ) ) then

				--
				-- If it's a string, it's cool
				--
				ProtectedCall( v, ... )

			else

				--
				-- If the key isn't a string - we assume it to be an entity
				-- Or panel, or something else that IsValid works on.
				--
				if ( IsValid( k ) ) then
					--
					-- If the object is valid - pass it as the first argument (self)
					--
					ProtectedCall( v, k, ... )
				else
					--
					-- If the object has become invalid - remove it
					--
					HookTable[ k ] = nil
				end
			end

		end
	end

	if ( !gm ) then return end

	local GamemodeFunction = gm[ name ]
	if ( GamemodeFunction == nil ) then return end

	ProtectedCall( GamemodeFunction, gm, ... )
end

--[[---------------------------------------------------------
	Name: RunProtected
	Args: string hookName, vararg args. No return values.
	Desc: Calls hooks associated with the hook name, but protected.
-----------------------------------------------------------]]

function RunProtected( name, ... )
	if ( !currentGM ) then
		currentGM = gmod and gmod.GetGamemode() or nil
	end

	return CallProtected( name, currentGM, ... )
end