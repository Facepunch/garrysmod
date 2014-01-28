local gmod		= gmod
local pairs		= pairs
local isfunction	= isfunction
local isstring		= isstring
local IsValid		= IsValid
local unpack		= unpack

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
	if not isfunction( func ) then return end
	if not isstring( event_name ) then return end

	if Hooks[ event_name ] == nil then
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
	if not isstring( event_name ) then return end
	if not Hooks[ event_name ] then return end

	Hooks[ event_name ][ name ] = nil
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
	local HookTable = Hooks[ name ]
	if HookTable ~= nil then
		for k, v in pairs( HookTable ) do 
			local ret

			if isstring( k ) then
				ret = { v( ... ) }
			else
				-- If the key isn't a string - we assume it to be an entity
				-- Or panel, or something else that IsValid works on.
				if IsValid( k ) then
					ret = { v( k, ... ) } -- If the object is valid - pass it as the first argument (self)
				else
					HookTable[ k ] = nil -- If the object has become invalid - remove it
				end
			end

			-- Hook returned a value - it overrides the gamemode function
			if ret and #ret > 0 then
				return unpack( ret )
			end
		end
	end
	
	-- Call the gamemode function
	if not gm then return end
	
	local GamemodeFunction = gm[ name ]
	if GamemodeFunction == nil then return end
		
	return GamemodeFunction( gm, ... )
end
