local gmod			= gmod
local pairs 		= pairs
local isstring 		= isstring
local isfunction 	= isfunction

module("hook")

local events = {}

--[[---------------------------------------------------------
	Name: Add
	Args: string hookName, any identifier, function func
	Desc: Add a hook to listen to the specified event.
-----------------------------------------------------------]]
function Add( event_name, name, func )

	if ( !isstring( event_name ) ) then return end
	if ( !isfunction( func ) ) then return end
	if ( !name ) then return end

	if ( !events[ event_name ] ) then
		events[ event_name ] = { n = 0 }
	end

	local event = events[ event_name ]

	local new_hook = {
		name = name,
		func = func,
		object = !isstring( name ) && name || false
	}

	--
	-- If hook exists, then update it
	--
	for i = 1, event.n do

		local hook = event[ i ]
		if ( hook && hook.name == name ) then
			event[ i ] = new_hook
			return
		end

	end

	event[ event.n + 1 ] = new_hook

	event.n = event.n + 1

end

--[[---------------------------------------------------------
	Name: Remove
	Args: string hookName, identifier
	Desc: Removes the hook with the given indentifier.
-----------------------------------------------------------]]
function Remove( event_name, name )

	local event = events[ event_name ]
	if (!event) then return end

	for i = 1, event.n do

		local hook = event[ i ]
		if ( hook && hook.name == name ) then
			event[ i ] = nil
			break
		end

	end

end

--[[---------------------------------------------------------
	Name: GetTable
	Desc: Returns a table of all hooks.
-----------------------------------------------------------]]
function GetTable()

	local new_events = {}

	for event_name, event in pairs( events ) do

		local hooks = {}

		for i = 1, event.n do

			local hook = event[ i ]
			if ( hook ) then
				hooks[ hook.name ] = hook.func
			end

		end

		new_events[ event_name ] = hooks

	end

	return new_events

end

--[[---------------------------------------------------------
	Name: Call
	Args: string hookName, table gamemodeTable, vararg args
	Desc: Calls hooks associated with the hook name.
-----------------------------------------------------------]]
function Call( event_name, gm, ... )

	local event = events[ event_name ]
	if ( event ) then

		local i, n = 1, event.n

		--
		-- Using normal loops causes the function to be blacklisted by jit (Credits to meepen)
		--
		::loop::

		local hook = event[ i ]
		if ( hook ) then

			if ( hook.object ) then

				local object = hook.object
				if ( object.IsValid && object:IsValid() ) then
					--
					-- The object is valid - pass it as the first argument (self)
					--
					local a, b, c, d, e, f = hook.func( object, ... )
					if ( a != nil ) then
						return a, b, c, d, e, f
					end
				else
					--
					-- The object has become invalid - remove it
					--
					event[ i ] = nil
				end

			else
				local a, b, c, d, e, f = hook.func( ... )
				if ( a != nil ) then
					return a, b, c, d, e, f
				end
			end

			i = i + 1

		else

			--
			-- the hook got removed, we gotta do some work!
			--

			if ( event.n != n ) then
				--
				-- a new hook was added in this call, we will replace the removed one with it then continue
				--
				event[ i ], event [ event.n ] = event [ event.n ], nil
				i = i + 1
			else
				--
				-- replace the removed hook with the last hook in the table then repeat
				--
				event[ i ], event [ n ] = event [ n ], nil
				n = n - 1
			end

			event.n = event.n - 1

			--
			-- no hooks left, so no need to keep the event in events table
			--
			if ( event.n == 0 ) then
				events[ event_name ] = nil
			end

		end

		if ( i <= n ) then
			goto loop
		end

	end

	--
	-- Call the gamemode function
	--

	if ( !gm ) then return end

	local GamemodeFunction = gm[ event_name ]
	if ( !GamemodeFunction ) then return end

	return GamemodeFunction( gm, ... )

end

--[[---------------------------------------------------------
	Name: Run
	Args: string hookName, vararg args
	Desc: Calls hooks associated with the hook name.
-----------------------------------------------------------]]
function Run( name, ... )
	return Call( name, gmod.GetGamemode(), ... )
end