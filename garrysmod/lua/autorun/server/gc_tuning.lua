---------------
	GC TUNING CONVARS

	Expose LuaJIT garbage collector tuning parameters
	as server convars, allowing server owners to tune
	GC behaviour for their specific workload.

	Convars:
		lua_gc_pause <number>    - GC pause (default 200)
		lua_gc_stepmul <number>  - GC step multiplier (default 200)
		lua_gc_step              - Force a GC step
		lua_gc_collect           - Force a full GC cycle
		lua_gc_count             - Print current GC memory usage
		lua_gc_info              - Print all GC tuning info

	Higher pause = less frequent GC cycles (less CPU, more memory)
	Higher stepmul = more aggressive per-step collection

	Typical tuning for heavy RP servers:
		lua_gc_pause 300         - Less frequent GC (reduce tick spikes)
		lua_gc_stepmul 150       - Gentler per-step collection
----------------

if ( SERVER ) then

	-- Apply GC pause setting
	concommand.Add( "lua_gc_pause", function( ply, cmd, args )

		if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end

		local val = tonumber( args[ 1 ] )
		if ( !val ) then
			local current = collectgarbage( "setpause", 200 )
			collectgarbage( "setpause", current )		-- read without changing
			print( "[GC Tuning] Current gc_pause: " .. current )
			return
		end

		val = math.Clamp( val, 50, 1000 )
		local old = collectgarbage( "setpause", val )
		print( "[GC Tuning] gc_pause: " .. old .. " -> " .. val )

	end )

	-- Apply GC step multiplier
	concommand.Add( "lua_gc_stepmul", function( ply, cmd, args )

		if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end

		local val = tonumber( args[ 1 ] )
		if ( !val ) then
			local current = collectgarbage( "setstepmul", 200 )
			collectgarbage( "setstepmul", current )
			print( "[GC Tuning] Current gc_stepmul: " .. current )
			return
		end

		val = math.Clamp( val, 50, 1000 )
		local old = collectgarbage( "setstepmul", val )
		print( "[GC Tuning] gc_stepmul: " .. old .. " -> " .. val )

	end )

	-- Force a GC step
	concommand.Add( "lua_gc_step", function( ply, cmd, args )

		if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end

		local size = tonumber( args[ 1 ] ) or 0
		collectgarbage( "step", size )
		print( "[GC Tuning] Forced GC step (size: " .. size .. ")" )

	end )

	-- Force a full GC cycle
	concommand.Add( "lua_gc_collect", function( ply, cmd, args )

		if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end

		local before = collectgarbage( "count" )
		collectgarbage( "collect" )
		local after = collectgarbage( "count" )

		print( "[GC Tuning] Full GC collect: " .. string.format( "%.1f", before ) .. " KB -> " .. string.format( "%.1f", after ) .. " KB (freed " .. string.format( "%.1f", before - after ) .. " KB)" )

	end )

	-- Print current memory usage
	concommand.Add( "lua_gc_count", function( ply, cmd, args )

		if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end

		local mem = collectgarbage( "count" )
		print( "[GC Tuning] Lua memory: " .. string.format( "%.1f", mem ) .. " KB (" .. string.format( "%.1f", mem / 1024 ) .. " MB)" )

	end )

	-- Print all GC info
	concommand.Add( "lua_gc_info", function( ply, cmd, args )

		if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end

		local mem = collectgarbage( "count" )

		-- Read current values by setting and restoring
		local pause = collectgarbage( "setpause", 200 )
		collectgarbage( "setpause", pause )
		local stepmul = collectgarbage( "setstepmul", 200 )
		collectgarbage( "setstepmul", stepmul )

		print( "========== GC TUNING INFO ==========" )
		print( "  Memory:        " .. string.format( "%.1f", mem ) .. " KB (" .. string.format( "%.1f", mem / 1024 ) .. " MB)" )
		print( "  gc_pause:      " .. pause )
		print( "  gc_stepmul:    " .. stepmul )
		print( "====================================" )
		print( "  lua_gc_pause <50-1000>    Set GC pause (higher = less frequent)" )
		print( "  lua_gc_stepmul <50-1000>  Set step multiplier (higher = more aggressive)" )
		print( "  lua_gc_step [size]        Force a GC step" )
		print( "  lua_gc_collect            Force full GC cycle" )
		print( "====================================" )

	end )

	-- Hook profiler console commands
	concommand.Add( "lua_hookprofile", function( ply, cmd, args )

		if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end

		local val = tonumber( args[ 1 ] )
		if ( val == nil ) then
			print( "[Hook Profiler] Usage: lua_hookprofile 1 (enable) or lua_hookprofile 0 (disable)" )
			return
		end

		hook.EnableProfiling( val == 1 )
		print( "[Hook Profiler] " .. ( val == 1 and "ENABLED" or "DISABLED" ) )

	end )

	concommand.Add( "lua_hookprofile_dump", function( ply, cmd, args )

		if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end

		local profile, elapsed = hook.GetProfile()

		print( "========== HOOK PROFILE (" .. string.format( "%.1f", elapsed ) .. "s) ==========" )
		print( string.format( "%-30s %-20s %8s %10s %10s %10s", "EVENT", "HOOK", "CALLS", "TOTAL(ms)", "AVG(ms)", "MAX(ms)" ) )

		-- Collect and sort by total time
		local entries = {}
		for event, hooks in pairs( profile ) do
			for name, data in pairs( hooks ) do
				table.insert( entries, {
					event = event,
					name = tostring( name ),
					calls = data.calls,
					totalTime = data.totalTime,
					avgTime = data.avgTime,
					maxTime = data.maxTime
				} )
			end
		end

		table.sort( entries, function( a, b ) return a.totalTime > b.totalTime end )

		local limit = tonumber( args[ 1 ] ) or 20
		for i = 1, math.min( limit, #entries ) do
			local e = entries[ i ]
			print( string.format( "%-30s %-20s %8d %10.3f %10.3f %10.3f",
				string.sub( e.event, 1, 30 ),
				string.sub( e.name, 1, 20 ),
				e.calls,
				e.totalTime * 1000,
				e.avgTime * 1000,
				e.maxTime * 1000
			) )
		end

		print( "====================================" )
		print( "Showing top " .. math.min( limit, #entries ) .. " of " .. #entries .. " hooks" )

	end )

	concommand.Add( "lua_hookprofile_reset", function( ply, cmd, args )

		if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end

		hook.ResetProfile()
		print( "[Hook Profiler] Profile data reset" )

	end )

end
