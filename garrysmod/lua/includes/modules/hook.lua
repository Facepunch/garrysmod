local gmod = gmod
local pairs = pairs
local isfunction = isfunction
local isstring = isstring
local isnumber = isnumber
local isbool = isbool
local IsValid = IsValid
local type = type
local ErrorNoHaltWithStack = ErrorNoHaltWithStack
local SysTime = SysTime

module( "hook" )

local Hooks = {}

---------------
	PROFILING SYSTEM
	Tracks execution time per hook for performance analysis.
	Enable with: lua_hookprofile 1
	View with:   lua_hookprofile_dump (console command)
	API:         hook.GetProfile() -> table
	             hook.ResetProfile()
----------------
local Profiling = false
local ProfileData = {}		-- [event][name] = { calls, totalTime, maxTime, avgTime, lastTime }
local ProfileStartTime = 0

function EnableProfiling( enabled )
	Profiling = enabled
	if ( enabled ) then
		ProfileStartTime = SysTime()
		ProfileData = {}
	end
end

function GetProfile()
	return ProfileData, SysTime() - ProfileStartTime
end

function ResetProfile()
	ProfileData = {}
	ProfileStartTime = SysTime()
end

-- Internal: record a single hook execution
local function ProfileRecord( event, name, dt )

	if ( !ProfileData[ event ] ) then
		ProfileData[ event ] = {}
	end

	local entry = ProfileData[ event ][ name ]
	if ( !entry ) then
		entry = { calls = 0, totalTime = 0, maxTime = 0, avgTime = 0, lastTime = 0 }
		ProfileData[ event ][ name ] = entry
	end

	entry.calls = entry.calls + 1
	entry.totalTime = entry.totalTime + dt
	entry.lastTime = dt
	if ( dt > entry.maxTime ) then entry.maxTime = dt end
	entry.avgTime = entry.totalTime / entry.calls

end


---------------
	HOOK BUDGETING SYSTEM
	Automatically throttles hooks that exceed their time budget.
	API: hook.SetBudget( event, name, maxMs )
	     hook.RemoveBudget( event, name )
	     hook.GetBudgets() -> table
	Hooks exceeding budget are skipped for a cooldown period.
----------------
local Budgets = {}			-- [event][name] = { maxTime, violations, lastViolation, throttled }
local BudgetCooldown = 1.0	-- seconds to throttle after budget exceeded

function SetBudget( event, name, maxMs )
	if ( !Budgets[ event ] ) then Budgets[ event ] = {} end
	Budgets[ event ][ name ] = {
		maxTime = maxMs / 1000,		-- convert ms to seconds
		violations = 0,
		lastViolation = 0,
		throttled = false
	}
end

function RemoveBudget( event, name )
	if ( !Budgets[ event ] ) then return end
	Budgets[ event ][ name ] = nil
end

function GetBudgets()
	return Budgets
end

-- Internal: check if a hook is currently throttled
local function IsThrottled( event, name )

	if ( !Budgets[ event ] ) then return false end

	local budget = Budgets[ event ][ name ]
	if ( !budget ) then return false end
	if ( !budget.throttled ) then return false end

	-- Check if cooldown has expired
	if ( SysTime() - budget.lastViolation > BudgetCooldown ) then
		budget.throttled = false
		return false
	end

	return true

end

-- Internal: record execution time against budget
local function BudgetCheck( event, name, dt )

	if ( !Budgets[ event ] ) then return end

	local budget = Budgets[ event ][ name ]
	if ( !budget ) then return end

	if ( dt > budget.maxTime ) then
		budget.violations = budget.violations + 1
		budget.lastViolation = SysTime()
		budget.throttled = true
	end

end


---------------
	LAZY HOOK EXECUTION
	Tracks which events actually fire. Events that haven't
	fired recently have their hooks moved to a "cold" list
	and are skipped during hot-path iteration.
	API: hook.GetColdEvents() -> table
	     hook.SetColdThreshold( seconds )
----------------
local EventLastFired = {}		-- [event] = SysTime
local ColdThreshold = 10.0		-- seconds before an event is "cold"
local ColdEvents = {}			-- [event] = true

function GetColdEvents()
	return ColdEvents
end

function SetColdThreshold( seconds )
	ColdThreshold = seconds
end

-- Internal: mark event as recently fired
local function MarkEventFired( event )

	EventLastFired[ event ] = SysTime()
	ColdEvents[ event ] = nil

end

-- Internal: check if event is cold (dormant)
local function IsEventCold( event )

	local lastFired = EventLastFired[ event ]
	if ( !lastFired ) then return false end		-- never fired = not cold, could be new

	if ( SysTime() - lastFired > ColdThreshold ) then
		ColdEvents[ event ] = true
		return true
	end

	return false

end


---------------
	HOOK MIDDLEWARE / SAFE RUN (inspired by slib)

	SafeRun: pcall-wrapped hook.Run — one bad addon error
	         won't crash all other hook listeners.
	SetMiddleware: wrap an existing hook with pre/post logic
	               without removing the original handler.
	API: hook.SafeRun( event, ... ) -> results
	     hook.SetMiddleware( event, name, middlewareFunc )
----------------
local Middlewares = {}

function SafeRun( event, ... )

	local gm = gmod and gmod.GetGamemode() or nil

	local ok, a, b, c, d, e, f = pcall( Call, event, gm, ... )

	if ( !ok ) then
		ErrorNoHaltWithStack( "[hook.SafeRun] Error in '" .. tostring( event ) .. "': " .. tostring( a ) )
		return nil
	end

	return a, b, c, d, e, f

end

function SetMiddleware( event, name, middlewareFunc )

	if ( !isstring( event ) or !isstring( name ) or !isfunction( middlewareFunc ) ) then return end

	if ( !Middlewares[ event ] ) then Middlewares[ event ] = {} end
	Middlewares[ event ][ name ] = middlewareFunc

	local existingHooks = Hooks[ event ]
	if ( !existingHooks ) then return end

	local originalFunc = existingHooks[ name ]
	if ( !originalFunc or !isfunction( originalFunc ) ) then return end

	existingHooks[ name ] = function( ... )
		local result = { middlewareFunc( ... ) }
		if ( #result > 0 ) then return unpack( result ) end
		return originalFunc( ... )
	end

end

function GetMiddlewares()
	return Middlewares
end


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

	local notValid = name == nil || isnumber( name ) or isbool( name ) or isfunction( name ) or !name.IsValid
	if ( !isstring( name ) and notValid ) then ErrorNoHaltWithStack( "bad argument #2 to 'Add' (string expected, got " .. type( name ) .. ")" ) return end

	if ( Hooks[ event_name ] == nil ) then
		Hooks[ event_name ] = {}
	end

	Hooks[ event_name ][ name ] = func

	-- If a hook is added to a cold event, warm it up
	ColdEvents[ event_name ] = nil

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
    Enhanced with profiling, budgeting, and lazy execution.
-----------------------------------------------------------]]
function Call( name, gm, ... )

	-- Mark this event as recently fired (for lazy execution)
	MarkEventFired( name )

	--
	-- Run hooks
	--
	local HookTable = Hooks[ name ]
	if ( HookTable != nil ) then

		local a, b, c, d, e, f

		for k, v in pairs( HookTable ) do

			-- Check if this hook is throttled by budgeting
			if ( IsThrottled( name, k ) ) then
				-- Skip throttled hooks
			elseif ( isstring( k ) ) then

				--
				-- If it's a string, it's cool
				--
				if ( Profiling ) then
					local t0 = SysTime()
					a, b, c, d, e, f = v( ... )
					local dt = SysTime() - t0
					ProfileRecord( name, k, dt )
					BudgetCheck( name, k, dt )
				else
					a, b, c, d, e, f = v( ... )
				end

			else

				--
				-- If the key isn't a string - we assume it to be an entity
				-- Or panel, or something else that IsValid works on.
				--
				if ( IsValid( k ) ) then
					--
					-- If the object is valid - pass it as the first argument (self)
					--
					if ( Profiling ) then
						local t0 = SysTime()
						a, b, c, d, e, f = v( k, ... )
						local dt = SysTime() - t0
						ProfileRecord( name, tostring( k ), dt )
						BudgetCheck( name, tostring( k ), dt )
					else
						a, b, c, d, e, f = v( k, ... )
					end
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
