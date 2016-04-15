local gmod                        = gmod
local pairs                        = pairs
local isfunction        = isfunction
local isstring                = isstring
local IsValid                = IsValid
local tinsert                = table.insert
local tremove               = table.remove

module( "hook" )

local Hooks = {}
local HooksOrdered = {}

--[[---------------------------------------------------------
    Name: GetTable
    Desc: Returns a table of all hooks.
-----------------------------------------------------------]]
function GetTable() return Hooks end


--[[---------------------------------------------------------
    Name: Add
    Args: string hookName, any identifier, function func
    Desc: Add a hook to listen to the specified event.
-----------------------------------------------------------]]
function Add( event_name, name, func, order )

	if ( !isfunction( func ) ) then return end
	if ( !isstring( event_name ) ) then return end
	if ( !order ) then order = 0 end

	if ( Hooks[ event_name ] == nil ) then
		Hooks[ event_name ] = {}
		HooksOrdered[ event_name ] = {}
	end

	-- Check if the hook has been added before and remove it's previous ordering if so.
	if ( Hooks[ event_name ][ name ] != nil ) then
		Remove( event_name, name )
	end
	Hooks[ event_name ][ name ] = func

	-- Find the position of the next greater order. table.insert here will move greater orders to the right.
	local hooks_ordered = HooksOrdered[ event_name ]
	local position = #hooks_ordered + 1
	for i = 1, #hooks_ordered do
		if hooks_ordered[ i ].order > order then
			position = i
			break
		end
	end
	tinsert( hooks_ordered, position, { name = name, order = order, func = func } )

end


--[[---------------------------------------------------------
    Name: Remove
    Args: string hookName, identifier
    Desc: Removes the hook with the given indentifier.
-----------------------------------------------------------]]
function Remove( event_name, name )

	if ( !isstring( event_name ) ) then return end
	if ( !Hooks[ event_name ] ) then return end

	if ( Hooks[ event_name ][ name ] != nil ) then
		-- Find the ordered index of the hook and remove it
		local hooks_ordered = HooksOrdered[ event_name ]
		for i = 1, #hooks_ordered do
			if hooks_ordered[ i ].name == name then
				tremove( hooks_ordered, i )
				break
			end
		end
		-- Remove from the string indexed table
		Hooks[ event_name ][ name ] = nil
	end

end


--[[---------------------------------------------------------
    Name: GetOrder
    Args: string hookName, identifier
    Desc: Returns the position of the hook in the order table or nil if it wasn't found.
-----------------------------------------------------------]]
function GetOrder( event_name, name )

	if ( !isstring( event_name ) ) then return end
	if ( !Hooks[ event_name ] ) then return end

	local hooks_ordered = HooksOrdered[ event_name ]
	local ret = nil
	for i = 1, #hooks_ordered do
		if hooks_ordered[ i ].name == name then
			ret = i
			break
		end
	end
	return ret
	
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
	local HookTable = HooksOrdered[ name ]
	if ( HookTable != nil ) then
	
		local a, b, c, d, e, f;

		for _, v in pairs( HookTable ) do
			local k = v.name
			local func = v.func
			
			if ( isstring( k ) ) then
				
				--
				-- If it's a string, it's cool
				--
				a, b, c, d, e, f = func( ... )

			else

				--
				-- If the key isn't a string - we assume it to be an entity
				-- Or panel, or something else that IsValid works on.
				--
				if ( IsValid( k ) ) then
					--
					-- If the object is valid - pass it as the first argument (self)
					--
					a, b, c, d, e, f = func( k, ... )
				else
					--
					-- If the object has become invalid - remove it
					--
					Remove( name, k )
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
