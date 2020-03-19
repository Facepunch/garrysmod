local gmod = gmod
local debug = debug
local pairs = pairs
local getmetatable = getmetatable
local setmetatable = setmetatable

module("hook")

local events = {}

local NewEvent
do
	local Event = {}
	local EventMeta = { __index = Event }

	NewEvent = function()
		return setmetatable({
			n = 0,
			keys = {},
		}, EventMeta)
	end

	function Event:Add( name, func, object )

		local pos = self.keys[ name ]
		if ( pos ) then

			--
			-- Hook exists, just update it
			--
			self[ pos + 1 ] = func
			self[ pos + 2 ] = object

		else

			local n = self.n

			self[ n + 1 ] = name
			self[ n + 2 ] = func
			self[ n + 3 ] = object
			self.keys[ name ] = n + 1 -- Keep a reference to hook position, so we can have fast hook removing/replacing

			self.n = n + 3

		end

	end

	function Event:Remove( name )

		local pos = self.keys[ name ]
		if ( pos ) then

			self[ pos ] = nil --[[name]]
			self[ pos + 1 ] = nil --[[func]]
			self[ pos + 2 ] = nil --[[object]]
			self.keys[ name ] = nil

		end

	end

	function Event:GetHooks()

		local hooks = {}
		local i, n = 1, self.n

		::loop::
		local name = self[ i ]
		if ( name ) then
			hooks[ name ] = self[ i + 1 ] --[[func]]
		end

		i = i + 3
		if ( i <= n ) then
			goto loop
		end

		return hooks

	end
end

do
	--
	-- "type" function in Garry's Mod is not jit compiled and for some reason
	-- that idk, the hook library performs worse with it
	--

	local stringMeta = getmetatable( "" )
	local function isstring( value )
		return getmetatable( value ) == stringMeta
	end

	local functionMeta = getmetatable( isstring ) || {}
	if ( !getmetatable(isstring) ) then
		debug.setmetatable( isstring, functionMeta )
	end

	local function isfunction( value )
		return getmetatable( value ) == functionMeta
	end

	--[[---------------------------------------------------------
		Name: Add
		Args: string hookName, any identifier, function func
		Desc: Add a hook to listen to the specified event.
	-----------------------------------------------------------]]
	function Add( event_name, name, func )

		if ( !isstring( event_name ) ) then return end
		if ( !isfunction( func ) ) then return end
		if ( !name ) then return end

		local object = false
		if ( !isstring( name ) ) then
			object = name
		end

		local event = events[ event_name ]
		if ( !event ) then
			event = NewEvent()
			events[ event_name ] = event
		end

		event:Add( name, func, object )

	end
end

--[[---------------------------------------------------------
    Name: Remove
    Args: string hookName, identifier
    Desc: Removes the hook with the given indentifier.
-----------------------------------------------------------]]
function Remove( event_name, name )

	local event = events[ event_name ]
	if ( event ) then
		event:Remove( name )
	end

end

--[[---------------------------------------------------------
    Name: GetTable
    Desc: Returns a table of all hooks.
-----------------------------------------------------------]]
function GetTable()

	local new_events = {}

	for event_name, event in pairs( events ) do

		new_events[ event_name ] = event:GetHooks()

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

		local i, n = 2, event.n

		::loop:: -- https://github.com/Facepunch/garrysmod/pull/1508#issuecomment-398231260
		local func = event[ i ]
		if ( func ) then

			local object = event[ i + 1 ]
			if ( object ) then

				if ( object.IsValid && object:IsValid() ) then
					--
					-- The object is valid - pass it as the first argument (self)
					--
					local a, b, c, d, e, f = func( object, ... )
					if ( a != nil ) then
						return a, b, c, d, e, f
					end
				else
					--
					-- The object has become invalid - remove it
					--
					event:Remove( event[ i - 1 ] --[[name]] )
				end

			else
				local a, b, c, d, e, f = func( ... )
				if ( a != nil ) then
					return a, b, c, d, e, f
				end
			end

			i = i + 3

		else

			--
			-- hook got removed, we gotta do some work!
			--

			local _n, _i = n, i

			if ( event.n != n ) then
				-- a new hook was added while "Call" is running, we will replace
				-- the removed one with it and continue without calling it
				_n = event.n
				i = i + 3
			else
				-- replace the removed hook with the last hook in the table and repeat the loop
				n = n - 3
			end

			local new_name = event[_n - 2 --[[name]]]
			if ( new_name ) then

				--[[name]] --[[func]] --[[object]]
				event[ _i - 1 ], event[ _i ], event[ _i + 1 ] = new_name, event[ _n - 1 ], event[ _n ]
				event[ _n - 2 ], event[ _n - 1 ], event[ _n ] = nil, nil, nil
				event.keys[ new_name ] = _i - 1 -- update hook position

			end

			event.n = event.n - 3

			--
			-- no hooks, so no need to keep it in the events table!
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

	local GamemodeFunction = gm[event_name]
	if ( !GamemodeFunction ) then return end

	return GamemodeFunction( gm, ... )

end

function Run( name, ... )
	return Call( name, gmod && gmod.GetGamemode() || nil, ... )
end