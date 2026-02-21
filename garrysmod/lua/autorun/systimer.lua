---------------
	SYSTIME-BASED TIMERS (inspired by HolyLib systimer)

	Standard GMod timers use CurTime which pauses during lag
	spikes and freezes. These timers use SysTime — they run
	regardless of server performance.

	Critical for: GC scheduling, cache invalidation, health
	monitors, auto-save, cleanup tasks.

	Usage:
		systimer.Create( "my_timer", 5, 0, function()
			print( "Runs every 5 real seconds, lag or not" )
		end )

		systimer.Simple( 10, function()
			print( "Runs in 10 real seconds" )
		end )

		systimer.Remove( "my_timer" )
		systimer.Toggle( "my_timer" )
----------------

systimer = systimer or {}

local Timers = {}		-- [id] = { delay, reps, func, nextRun, repsLeft, paused }
local SimpleTimers = {}	-- sequential { deadline, func }
local SysTime = SysTime


--
-- Create a named repeating timer
--
function systimer.Create( id, delay, reps, func )

	Timers[ id ] = {
		delay = delay,
		reps = reps,
		func = func,
		nextRun = SysTime() + delay,
		repsLeft = reps,
		paused = false
	}

end


--
-- Create a one-shot anonymous timer
--
function systimer.Simple( delay, func )

	table.insert( SimpleTimers, {
		deadline = SysTime() + delay,
		func = func
	} )

end


--
-- Remove a named timer
--
function systimer.Remove( id )
	Timers[ id ] = nil
end


--
-- Check existence
--
function systimer.Exists( id )
	return Timers[ id ] != nil
end


--
-- Pause/unpause
--
function systimer.Pause( id )
	local t = Timers[ id ]
	if ( t ) then t.paused = true end
end

function systimer.UnPause( id )
	local t = Timers[ id ]
	if ( t ) then
		t.paused = false
		t.nextRun = SysTime() + t.delay
	end
end

function systimer.Toggle( id )
	local t = Timers[ id ]
	if ( !t ) then return end

	if ( t.paused ) then
		systimer.UnPause( id )
	else
		systimer.Pause( id )
	end
end


--
-- Get time left
--
function systimer.TimeLeft( id )
	local t = Timers[ id ]
	if ( !t ) then return 0 end
	return math.max( 0, t.nextRun - SysTime() )
end


--
-- Adjust delay
--
function systimer.Adjust( id, delay, reps, func )
	local t = Timers[ id ]
	if ( !t ) then return false end

	if ( delay ) then t.delay = delay end
	if ( reps ) then t.reps = reps; t.repsLeft = reps end
	if ( func ) then t.func = func end

	t.nextRun = SysTime() + ( delay or t.delay )
	return true
end


--
-- Get count
--
function systimer.Count()
	return table.Count( Timers )
end


--
-- Process timers each frame
--
hook.Add( "Think", "SysTimer_Process", function()

	local now = SysTime()

	-- Named timers
	for id, t in pairs( Timers ) do

		if ( t.paused ) then continue end
		if ( now < t.nextRun ) then continue end

		-- Fire the callback
		local ok, err = pcall( t.func )
		if ( !ok ) then
			ErrorNoHaltWithStack( "[SysTimer] Timer '" .. id .. "' error: " .. tostring( err ) )
		end

		-- Handle repetitions
		if ( t.reps > 0 ) then
			t.repsLeft = t.repsLeft - 1
			if ( t.repsLeft <= 0 ) then
				Timers[ id ] = nil
				continue
			end
		end

		t.nextRun = now + t.delay

	end

	-- Simple (one-shot) timers
	for i = #SimpleTimers, 1, -1 do

		local t = SimpleTimers[ i ]
		if ( now < t.deadline ) then continue end

		local ok, err = pcall( t.func )
		if ( !ok ) then
			ErrorNoHaltWithStack( "[SysTimer] Simple timer error: " .. tostring( err ) )
		end

		table.remove( SimpleTimers, i )

	end

end )


-- Console command
concommand.Add( "lua_systimer_info", function( ply, cmd, args )

	if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end

	print( "========== SYSTIMERS ==========" )
	print( "  Named timers:  " .. systimer.Count() )
	print( "  Simple timers: " .. #SimpleTimers )

	if ( systimer.Count() > 0 ) then
		print( "" )
		for id, t in pairs( Timers ) do
			local status = t.paused and "PAUSED" or "RUNNING"
			local left = math.max( 0, t.nextRun - SysTime() )
			print( string.format( "    [%s] %s  delay=%.1fs  left=%.1fs  reps=%s",
				id, status, t.delay, left,
				t.reps == 0 and "inf" or tostring( t.repsLeft ) ) )
		end
	end

	print( "===============================" )

end )

MsgN( "[SysTimer] SysTime-based timers loaded." )
