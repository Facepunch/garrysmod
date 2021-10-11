local hook_func = 1
local hook_name = 2
local next_hook = 3
local real_hook_func = 4
local last_hook = 5
local hook_priority = 6

local event_table = {}

-- keeps the record of how many hooks are in an event metatable to always
-- return a value so you don't need to do checks everywhere
local event_count = setmetatable({}, {
	__index = function(self, k)
		self[k] = 0
		return 0
	end
})
local gmod = gmod
local type = type
local math = math
local pairs = pairs
local assert = assert
local IsValid = IsValid

local noop_hook = {
	-- hook_func
	function() return false end,
	-- hook_name
	nil,
	-- next_hook
	nil,
	-- real_hook_func
	nil,
	-- last_hook
	nil,
	-- hook_priority
	-math.huge
}

module "hook"

-- This is not modifiable like in the past. Other hook libraries that were
-- implemented and overrode the library in the past also did this, so I
-- doubt many addons will break because of this.

local function _GetTable()
	local out = {}
	for event, hooklist in pairs( event_table ) do
		out[ event ] = {}

		for i = 1, event_count[ event ] do
			out[ event ][ hooklist[ hook_name ] ] = hooklist[ real_hook_func ]
			hooklist = hooklist[ next_hook ]
		end
	end
	return out
end

local function _GetPriority( event, name )
	assert( type( event ) ~= "nil", "bad argument #1 to 'Remove' (value expected)" )
	assert( type( name ) ~= "nil",  "bad argument #2 to 'Remove' (value expected)" )

	local iterator = event_table[ event ]
	if ( not iterator ) then
		return
	end

	for i = 1, event_count[ event ] do
		if ( iterator[ hook_name ] == name ) then
			return iterator[ hook_priority ]
		end
		iterator = iterator[ next_hook ]
	end
end


local function _Remove( event, name )
	assert( type( event ) ~= "nil", "bad argument #1 to 'Remove' (value expected)" )
	assert( type( name ) ~= "nil",  "bad argument #2 to 'Remove' (value expected)" )

	local iterator = event_table[ event ]
	if ( not iterator ) then
		return
	end

	local first_hook = iterator

	for i = 1, event_count[ event ] do
		if ( iterator[ hook_name ] == name ) then
			local last, next = iterator[ last_hook ], iterator[ next_hook ]

			if ( last ) then
				last[ next_hook ] = iterator[ next_hook ]
			end

			if ( next ~= noop_hook ) then
				next[ last_hook ] = iterator[ last_hook ]
			end

			-- If this is the start of the list, update it to the correct value
			-- don't ever let the first value be noop_hook since it will just
			-- waste time
			if ( iterator == first_hook ) then
				event_table[ event ] = next ~= noop_hook and next or nil
			end

			-- Removed, decrement the event hook count
			event_count[ event ] = event_count[ event ] - 1

			break
		end

		iterator = iterator[ next_hook ]
	end
end

local function _Add( event, name, real_fn, priority )
	assert( event ~= nil, "bad argument #1 to 'Add' (value expected)" )
	assert( type( real_fn ) == "function", "bad argument #3 to 'Add' (function expected)" )
	assert( type( priority ) == "number" or type( priority ) == "nil", "bad argument #4 to 'Add' (number or nil expected)" )
	assert( priority == priority, "bad argument #4 to 'Add' (number cannot be nan)" )

	if ( not name ) then
		return
	end

	priority = priority or 0

	-- To remove loops in hook.Call we replace every function with another
	-- that calls the next or returns its values

	local fn

	if ( type( name ) ~= "string" ) then
		-- IsValid checks are required
		fn = function( myentry, ... )
			if ( not IsValid( name ) ) then
				_Remove( event, name )
			else
				local a, b, c, d, e, f = myentry[ real_hook_func ]( name, ... )
				if (a ~= nil) then
					return true, a, b, c, d, e, f
				end
			end

			local next = myentry[ next_hook ]
			return next[ hook_func ]( next, ... )
		end
	else
		fn = function( myentry, ... )
			local a, b, c, d, e, f = real_fn( ... )
			if (a == nil) then
				local next = myentry[ next_hook ]
				return next[ hook_func ]( next, ... )
			end
			return true, a, b, c, d, e, f
		end
	end

	local iterator = event_table[ event ]

	local new_hook

	-- Check if a hook with the given name already exists
	for i = 1, event_count[ event ] do
		if ( iterator[ hook_name ] == name ) then
			new_hook = iterator
			break
		end
		iterator = iterator[ next_hook ]
	end

	-- If it does, update
	if ( new_hook ) then
		new_hook[ hook_func ]      = fn
		new_hook[ real_hook_func ] = real_fn

		-- If the old hook existed and had the same priority, no need to 
		-- reposition the hook, so just stop here
		if ( new_hook[ hook_priority ] == priority ) then
			return
		end

		-- WARNING: UNDEFINED BEHAVIOR WARNING doing this inside another hook
		-- with earlier priority than the hook running could run the hook again
		_Remove( event, name )
		new_hook[ hook_priority ] = priority
		new_hook[ next_hook ]	   = noop_hook
		new_hook[ last_hook ]	   = nil
	else
		-- Hook didn't exist, create it
		new_hook = {
			-- hook_func
			fn,
			-- hook_name
			name,
			-- next_hook
			noop_hook,
			-- real_hook_func
			real_fn,
			-- last_hook
			nil,
			-- hook_priority
			priority
		}
	end

	-- increment hook count here
	event_count[ event ] = event_count[ event ] + 1

	-- find link in hook list to add to
	iterator = event_table[ event ]
	local first_hook = iterator

	if ( iterator ) then
		local lasthook

		for i = 1, event_count[ event ] do
			-- Check priority to see if we can fit
			-- This will ALWAYS happen since we have noop_hook at -infinity
			-- priority and filter out NaN as priority
			if ( iterator[ hook_priority ] <= priority ) then
				-- insert between last and next hook
				if ( lasthook ) then
					lasthook[ next_hook ] = new_hook
				end

				iterator[ last_hook ] = new_hook
				new_hook[ next_hook ] = iterator
				new_hook[ last_hook ] = lasthook

				-- If this hook is not at the start of the array we don't need
				-- to update anything further
				if ( first_hook ~= iterator ) then
					return
				end

				break
			end

			-- not suitable here, check next hook in list
			lasthook = iterator
			iterator = iterator[ next_hook ]
		end
	end

	-- List was empty or was inserted at the beginning
	event_table[ event ] = new_hook
end

local function _Call( event, gm, ... )
	local hook = event_table[ event ]

	if ( hook ) then
		-- this single call will tail recurse until it finds a hook that
		-- returns or at the end of the list
		local found, a, b, c, d, e, f = hook[ hook_func ]( hook, ... )
		if ( found ) then
			return a, b, c, d, e, f
		end
	end

	if ( gm ) then
		local fn = gm[ event ]
		if ( fn ) then
			return fn( gm, ... )
		end
	end
end

local function _Run( event, ... )
	return _Call( event, gmod and gmod.GetGamemode() or nil, ... )
end

Remove = _Remove
GetTable = _GetTable
Add = _Add
Call = _Call
Run = _Run
GetPriority = _GetPriority
Priority = {
	NO_RETURN = math.huge -- not enforced, just should be followed
}

-- Leave this for people to not mess with the library and have people who need
-- to stil able to, just don't document it
GetInternal = function()
	return event_table, event_count
end