---------------
	ADDON HEALTH MONITOR

	Live monitoring dashboard that tracks addon CPU time,
	memory usage, error rates, and network traffic per addon.
	Combines hook profiling + memory tracking + error counting.

	Auto-identifies the "heaviest" addons each minute and
	flags addons exceeding CPU/memory thresholds.

	Console Commands (SuperAdmin):
		lua_addon_health       - Full health dashboard
		lua_addon_health_top   - Top 5 resource consumers
		lua_addon_health_reset - Reset all tracking data

	ConVars:
		sv_addonhealth 1       - Enable health monitoring
		sv_addonhealth_warn 5  - Warn threshold (ms per tick)
----------------

if ( !SERVER ) then return end

addonhealth = addonhealth or {}

local Enabled = false
local WarnThreshold = 5		-- ms per tick
local MonitorData = {}		-- [addonName] = { cpuTime, memDelta, errors, netMsgs, lastUpdate }
local ErrorLog = {}			-- [addonName] = { {time, message}, ... }
local TotalErrors = 0

CreateConVar( "sv_addonhealth", "0", FCVAR_ARCHIVE, "Enable addon health monitoring" )
CreateConVar( "sv_addonhealth_warn", "5", FCVAR_ARCHIVE, "CPU warning threshold in ms per tick" )

cvars.AddChangeCallback( "sv_addonhealth", function( name, old, new )
	Enabled = tonumber( new ) == 1
	if ( Enabled ) then
		MsgN( "[AddonHealth] Monitoring ENABLED" )
	end
end )


--
-- Get or create monitor entry for an addon
--
local function GetEntry( name )
	if ( !MonitorData[ name ] ) then
		MonitorData[ name ] = {
			cpuTime = 0,
			cpuSamples = 0,
			avgCpu = 0,
			peakCpu = 0,
			memBefore = 0,
			memAfter = 0,
			memDelta = 0,
			errors = 0,
			netMsgsSent = 0,
			netMsgsRecv = 0,
			lastUpdate = SysTime(),
			warnings = 0
		}
	end
	return MonitorData[ name ]
end


--
-- Record CPU time for an addon's hook
--
function addonhealth.RecordCPU( addonName, dt )
	if ( !Enabled ) then return end

	local entry = GetEntry( addonName )
	entry.cpuTime = entry.cpuTime + dt
	entry.cpuSamples = entry.cpuSamples + 1
	entry.avgCpu = entry.cpuTime / entry.cpuSamples
	if ( dt > entry.peakCpu ) then entry.peakCpu = dt end

	-- Check threshold
	if ( dt * 1000 > WarnThreshold ) then
		entry.warnings = entry.warnings + 1
	end
end


--
-- Record an error from an addon
--
function addonhealth.RecordError( addonName, errorMsg )
	if ( !Enabled ) then return end

	local entry = GetEntry( addonName )
	entry.errors = entry.errors + 1
	TotalErrors = TotalErrors + 1

	if ( !ErrorLog[ addonName ] ) then ErrorLog[ addonName ] = {} end

	table.insert( ErrorLog[ addonName ], {
		time = SysTime(),
		message = string.sub( tostring( errorMsg ), 1, 200 )
	} )

	-- Keep only last 20 errors per addon
	while ( #ErrorLog[ addonName ] > 20 ) do
		table.remove( ErrorLog[ addonName ], 1 )
	end
end


--
-- Record memory change
--
function addonhealth.RecordMemory( addonName, before, after )
	if ( !Enabled ) then return end

	local entry = GetEntry( addonName )
	entry.memBefore = before
	entry.memAfter = after
	entry.memDelta = after - before
end


--
-- Record net message
--
function addonhealth.RecordNet( addonName, direction )
	if ( !Enabled ) then return end

	local entry = GetEntry( addonName )
	if ( direction == "send" ) then
		entry.netMsgsSent = entry.netMsgsSent + 1
	else
		entry.netMsgsRecv = entry.netMsgsRecv + 1
	end
end


--
-- Get health score (0-100, lower = worse)
--
function addonhealth.GetHealthScore( addonName )

	local entry = MonitorData[ addonName ]
	if ( !entry ) then return 100 end

	local score = 100

	-- Penalize high CPU
	if ( entry.avgCpu * 1000 > 1 ) then score = score - 20 end
	if ( entry.avgCpu * 1000 > 3 ) then score = score - 20 end

	-- Penalize errors
	if ( entry.errors > 0 ) then score = score - math.min( 30, entry.errors * 5 ) end

	-- Penalize high memory
	if ( entry.memDelta > 100 ) then score = score - 10 end
	if ( entry.memDelta > 1000 ) then score = score - 20 end

	-- Penalize warnings
	if ( entry.warnings > 10 ) then score = score - 10 end

	return math.max( 0, score )

end


--
-- Get top consumers sorted by CPU time
--
function addonhealth.GetTopConsumers( limit )

	limit = limit or 5
	local sorted = {}

	for name, data in pairs( MonitorData ) do
		table.insert( sorted, {
			name = name,
			cpu = data.cpuTime,
			avgCpu = data.avgCpu,
			peakCpu = data.peakCpu,
			errors = data.errors,
			memDelta = data.memDelta,
			score = addonhealth.GetHealthScore( name )
		} )
	end

	table.sort( sorted, function( a, b ) return a.cpu > b.cpu end )

	local results = {}
	for i = 1, math.min( limit, #sorted ) do
		results[ i ] = sorted[ i ]
	end

	return results

end


--
-- Reset tracking data
--
function addonhealth.Reset()
	MonitorData = {}
	ErrorLog = {}
	TotalErrors = 0
end


--
-- Integrate with hook profiler if enabled
--
local LastProfileSync = 0
hook.Add( "Think", "AddonHealth_ProfileSync", function()

	if ( !Enabled ) then return end

	WarnThreshold = GetConVar( "sv_addonhealth_warn" ):GetFloat()

	local now = SysTime()
	if ( now - LastProfileSync < 5 ) then return end		-- Every 5 seconds
	LastProfileSync = now

	-- Pull data from hook profiler if available
	if ( hook.GetProfile ) then
		local profileData, _ = hook.GetProfile()
		for event, hooks in pairs( profileData ) do
			for hookName, data in pairs( hooks ) do
				if ( data.avgTime ) then
					addonhealth.RecordCPU( tostring( hookName ), data.avgTime )
				end
			end
		end
	end

end )


-- Console commands
concommand.Add( "lua_addon_health", function( ply, cmd, args )

	if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end

	print( "========== ADDON HEALTH DASHBOARD ==========" )
	print( "  Monitoring: " .. ( Enabled and "ENABLED" or "DISABLED (sv_addonhealth 1)" ) )
	print( "  Total errors tracked: " .. TotalErrors )
	print( "" )

	local sorted = {}
	for name, data in pairs( MonitorData ) do
		table.insert( sorted, {
			name = name,
			data = data,
			score = addonhealth.GetHealthScore( name )
		} )
	end
	table.sort( sorted, function( a, b ) return a.score < b.score end )	-- Worst first

	if ( #sorted > 0 ) then
		print( string.format( "  %-22s %6s %8s %8s %6s %6s",
			"ADDON", "SCORE", "CPU(ms)", "PEAK", "ERRS", "WARNS" ) )
		for _, entry in ipairs( sorted ) do
			local d = entry.data
			local scoreStr = tostring( entry.score )
			if ( entry.score < 50 ) then scoreStr = scoreStr .. " !" end

			print( string.format( "  %-22s %6s %8.2f %8.2f %6d %6d",
				string.sub( entry.name, 1, 22 ),
				scoreStr,
				d.avgCpu * 1000,
				d.peakCpu * 1000,
				d.errors,
				d.warnings
			) )
		end
	else
		print( "  No monitoring data yet." )
	end

	print( "=============================================" )

end )

concommand.Add( "lua_addon_health_top", function( ply, cmd, args )

	if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end

	local top = addonhealth.GetTopConsumers( 5 )

	print( "========== TOP 5 CONSUMERS ==========" )
	for i, entry in ipairs( top ) do
		print( string.format( "  %d. %s (score: %d, avg: %.2fms, peak: %.2fms, errors: %d)",
			i, entry.name, entry.score, entry.avgCpu * 1000, entry.peakCpu * 1000, entry.errors ) )
	end
	print( "=====================================" )

end )

concommand.Add( "lua_addon_health_reset", function( ply, cmd, args )
	if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end
	addonhealth.Reset()
	print( "[AddonHealth] All tracking data reset." )
end )

MsgN( "[AddonHealth] Addon health monitor loaded. Use sv_addonhealth 1 to enable." )
