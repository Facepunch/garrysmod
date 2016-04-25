local gmod                        = gmod
local pairs                        = pairs
local isfunction        = isfunction
local isstring                = isstring
local isnumber                = isnumber
local IsValid                = IsValid
local table_insert                = table.insert
local table_remove               = table.remove

module( "hook" )

local Hooks = {} -- All hooks regardless of ordering
local HooksNonOrdered = {} -- All hooks that don't require ordering
local HooksOrderedPre = {} -- All hooks that run before the non-ordered hooks (<0 order)
local HooksOrderedPost = {} -- All hooks that run after the non-ordered hooks (>0 order)
local HooksToRemove = {} -- Table that will hold any ordered hooks needed to be removed while the table is being iterated
local HooksToAdd = {} -- Table that will hold any ordered hooks needed to be added while the table is being iterated
local HooksIterating = false -- Variable that indicates if the ordered hook table is being iterated.

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


	if ( Hooks[ event_name ] == nil ) then
		Hooks[ event_name ] = {}
		HooksNonOrdered[ event_name ] = {}
		HooksOrderedPre[ event_name ] = {}
		HooksOrderedPost[ event_name ] = {}
	end

	-- Make sure the hook is removed first
	Remove( event_name, name )

	if isnumber( order ) and order != 0 then
		-- Currently iterating an ordered table so can't modify it
		if HooksIterating then
			HooksToAdd[ #HooksToAdd + 1 ] = { event_name, name, func, order }
		else
			-- Find the position of the next greater order. table.insert here will move greater orders to the right.
			local hooks_ordered = ( ( order < 0 ) and HooksOrderedPre[ event_name ] or HooksOrderedPost[ event_name ] )
			local position = #hooks_ordered + 1
			for i = 1, #hooks_ordered do
				if hooks_ordered[ i ].order > order then
					position = i
					break
				end
			end
			table_insert( hooks_ordered, position, { name = name, order = order, func = func } )
		end
	else
		HooksNonOrdered[ event_name ][ name ] = func
	end

	Hooks[ event_name ][ name ] = func

end


--[[---------------------------------------------------------
    Name: Remove
    Args: string hookName, identifier
    Desc: Removes the hook with the given indentifier.
-----------------------------------------------------------]]
function Remove( event_name, name )

	if ( !isstring( event_name ) ) then return end
	if ( !Hooks[ event_name ] ) then return end

	-- Make sure the hook actually exists before doing these loops
	if ( Hooks[ event_name ][ name ] != nil ) then
		-- Check if it is an unordered hook which is easy to remove
		if HooksNonOrdered[ event_name ][ name ] != nil then
			HooksNonOrdered[ event_name ][ name ] = nil
		else
			-- Check if hooks are iterating and add to queue if it is
			if HooksIterating then
				HooksToRemove[ #HooksToRemove + 1 ] = { event_name, name, func, order }
			else
				-- Find the ordered hook in all tables and remove it
				local hooks
				hooks = HooksOrderedPre[ event_name ]
				for i = 1, #hooks do
					if hooks[ i ].name == name then
						table_remove( hooks, i )
						break
					end
				end
				hooks = HooksOrderedPost[ event_name ]
				for i = 1, #hooks do
					if hooks[ i ].name == name then
						table_remove( hooks, i )
						break
					end
				end
				hooks = HooksToAdd
				for i = 1, #hooks do
					if hooks[ i ][ 1 ] == event_name and hooks[ i ][ 2 ] == name then0
						table_remove( hooks, i )
						break
					end
				end
			end
		end
		-- Remove from the string indexed table
		Hooks[ event_name ][ name ] = nil
		
		if next( Hooks[ event_name ] ) == nil then
			Hooks[ event_name ] = nil
			HooksNonOrdered[ event_name ] = nil
			HooksOrderedPre[ event_name ] = nil
			HooksOrderedPost[ event_name ] = nil
		end
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

	local hooks
	hooks = HooksOrderedPre[ event_name ]
	for i = 1, #hooks do
		if hooks[ i ].name == name then
			return hooks[ i ].order
		end
	end
	hooks = HooksOrderedPost[ event_name ]
	for i = 1, #hooks do
		if hooks[ i ].name == name then
			return hooks[ i ].order
		end
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
    Name: Run
    Args: string hookName, table gamemodeTable, vararg args
    Desc: Calls hooks associated with the hook name.
-----------------------------------------------------------]]
function Call( name, gm, ... )

	--
	-- Run hooks
	--
	local HookTable, a, b, c, d, e, f;
	local function FinishedIterating()
		HooksIterating = false
		for _, v in pairs( HooksToAdd ) do
			Add( unpack( v ) )
			HooksToAdd[ _ ] = nil
		end
		for _, v in pairs( HooksToRemove ) do
			Remove( unpack( v ) )
			HooksToRemove[ _ ] = nil
		end
	end

	-- Iterate ordered hooks with <0 order
	HookTable = HooksOrderedPre[ name ]
	if ( HookTable != nil ) then

		HooksIterating = true

		for i = 1, #HookTable do

			local k, v = HookTable[i].name, HookTable[i].func

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
					Remove( name, k )
				end
			end

			--
			-- Hook returned a value - it overrides the gamemode function
			--
			if ( a != nil ) then
				FinishedIterating()
				return a, b, c, d, e, f
			end

		end
	end

	-- Iterate non ordered hooks
	HookTable = HooksNonOrdered[ name ]
	if ( HookTable != nil ) then

		HooksIterating = false

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
					Remove( name, k )
				end
			end

			--
			-- Hook returned a value - it overrides the gamemode function
			--
			if ( a != nil ) then
				FinishedIterating()
				return a, b, c, d, e, f
			end

		end
	end

	-- Iterate ordered hooks with >0 order
	HookTable = HooksOrderedPost[ name ]
	if ( HookTable != nil ) then

		HooksIterating = true

		for i = 1, #HookTable do

			local k, v = HookTable[i].name, HookTable[i].func

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
					Remove( name, k )
				end
			end

			--
			-- Hook returned a value - it overrides the gamemode function
			--
			if ( a != nil ) then
				FinishedIterating()
				return a, b, c, d, e, f
			end

		end
	end

	FinishedIterating()

	--
	-- Call the gamemode function
	--
	if ( !gm ) then return end
	
	local GamemodeFunction = gm[ name ]
	if ( GamemodeFunction == nil ) then return end
			
	return GamemodeFunction( gm, ... )        
	
end
