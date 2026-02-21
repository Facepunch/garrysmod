---------------
	ADDON MEMORY PROFILING

	Tracks Lua memory usage per addon by snapshotting
	collectgarbage("count") before and after addon operations.

	Console Commands (SuperAdmin only):
		lua_addon_memory           - Show memory per addon
		lua_addon_memory_snapshot  - Take a new snapshot
		lua_addon_memory_track 1   - Enable continuous tracking

	Also hooks into the addon load process to automatically
	measure memory impact of each addon at startup.
----------------

if ( !SERVER ) then return end

local AddonMemory = {}		-- [addonName] = { before, after, delta }
local TrackingEnabled = false
local Snapshots = {}		-- [timestamp] = { total, addonData }


--
-- Take a memory snapshot
--
local function TakeSnapshot( label )

	collectgarbage( "collect" )		-- Clean slate for accurate measurement
	local mem = collectgarbage( "count" )

	local snapshot = {
		label = label or "manual",
		time = SysTime(),
		memory = mem,
		addons = table.Copy( AddonMemory )
	}

	table.insert( Snapshots, snapshot )

	return mem

end


--
-- Measure memory delta for a function call
--
local function MeasureMemory( name, func )

	collectgarbage( "collect" )
	local before = collectgarbage( "count" )

	func()

	collectgarbage( "collect" )
	local after = collectgarbage( "count" )

	AddonMemory[ name ] = {
		before = before,
		after = after,
		delta = after - before
	}

	return after - before

end


--
-- Track addon loading automatically
-- Hook into InitPostEntity to measure after all addons are loaded
--
hook.Add( "InitPostEntity", "AddonMemory_Init", function()

	local totalMem = collectgarbage( "count" )
	TakeSnapshot( "post_init" )

	MsgN( "[AddonMemory] Post-init memory: " .. string.format( "%.1f", totalMem / 1024 ) .. " MB" )

end )


--
-- Periodic memory tracking (when enabled)
--
local LastTrack = 0
hook.Add( "Think", "AddonMemory_Track", function()

	if ( !TrackingEnabled ) then return end

	local now = SysTime()
	if ( now - LastTrack < 30 ) then return end		-- Every 30 seconds
	LastTrack = now

	local mem = collectgarbage( "count" )
	TakeSnapshot( "periodic" )

end )


-- Console commands
concommand.Add( "lua_addon_memory", function( ply, cmd, args )

	if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end

	local totalMem = collectgarbage( "count" )

	print( "========== ADDON MEMORY USAGE ==========" )
	print( string.format( "  Total Lua memory: %.1f MB", totalMem / 1024 ) )
	print( "" )

	if ( table.Count( AddonMemory ) > 0 ) then

		-- Sort by delta
		local sorted = {}
		for name, data in pairs( AddonMemory ) do
			table.insert( sorted, { name = name, delta = data.delta, after = data.after } )
		end
		table.sort( sorted, function( a, b ) return a.delta > b.delta end )

		print( string.format( "  %-30s %10s %10s", "ADDON", "DELTA(KB)", "TOTAL(KB)" ) )
		for _, entry in ipairs( sorted ) do
			print( string.format( "  %-30s %10.1f %10.1f",
				string.sub( entry.name, 1, 30 ),
				entry.delta,
				entry.after
			) )
		end

	else
		print( "  No addon memory data recorded yet." )
		print( "  Use lua_addon_memory_snapshot to capture current state." )
	end

	-- Show snapshots history
	if ( #Snapshots > 0 ) then
		print( "" )
		print( "  Memory history (" .. #Snapshots .. " snapshots):" )
		local limit = math.min( 5, #Snapshots )
		for i = #Snapshots, math.max( 1, #Snapshots - limit + 1 ), -1 do
			local s = Snapshots[ i ]
			print( string.format( "    [%s] %.1f MB", s.label, s.memory / 1024 ) )
		end
	end

	print( "========================================" )

end )

concommand.Add( "lua_addon_memory_snapshot", function( ply, cmd, args )
	if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end

	local mem = TakeSnapshot( args[ 1 ] or "manual" )
	print( "[AddonMemory] Snapshot taken: " .. string.format( "%.1f", mem / 1024 ) .. " MB" )
end )

concommand.Add( "lua_addon_memory_track", function( ply, cmd, args )
	if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end

	local val = tonumber( args[ 1 ] )
	if ( val == nil ) then
		print( "[AddonMemory] Tracking: " .. ( TrackingEnabled and "ON" or "OFF" ) )
		return
	end

	TrackingEnabled = ( val == 1 )
	print( "[AddonMemory] Tracking " .. ( TrackingEnabled and "ENABLED (every 30s)" or "DISABLED" ) )
end )


--
-- Expose measurement API for addon developers
--
function addon_memory_measure( name, func )
	return MeasureMemory( name, func )
end

MsgN( "[AddonMemory] Loaded. Use lua_addon_memory for stats." )
