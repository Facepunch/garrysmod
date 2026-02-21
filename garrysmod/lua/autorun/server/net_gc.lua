---------------
	NETWORK GARBAGE COLLECTION (inspired by slib)

	Cleans up stale network state for disconnected players.
	Our net_delta.lua and net.lua rate limiting track per-player
	state that can leak if not cleaned up.

	Also monitors net message volume and warns when queue
	counts exceed thresholds (common sign of net exploits).

	Usage:
		Net GC runs automatically. No addon action needed.

	Console Commands:
		lua_netgc_info    - Show orphaned state counts
		lua_netgc_run     - Force a GC pass
----------------

if ( !SERVER ) then return end

local NetGC = {}
local OrphansCleaned = 0
local LastRun = 0
local RunInterval = 30		-- seconds
local WarningThreshold = 500

--
-- Clean up stale per-player net state
--
function NetGC.CollectGarbage()

	local activeSteamIDs = {}
	for _, ply in ipairs( player.GetAll() ) do
		if ( IsValid( ply ) ) then
			activeSteamIDs[ ply:SteamID() ] = true
		end
	end

	local cleaned = 0

	-- Clean net.lua rate limit buckets (if accessible)
	-- The rate buckets are local to net.lua, so we clean via
	-- the PlayerDisconnected hook instead

	-- Clean net_delta state (if the module exposes it)
	if ( net_delta and net_delta.PlayerStates ) then
		for steamID, _ in pairs( net_delta.PlayerStates ) do
			if ( !activeSteamIDs[ steamID ] ) then
				net_delta.PlayerStates[ steamID ] = nil
				cleaned = cleaned + 1
			end
		end
	end

	-- Clean chunked transfer state
	if ( net_delta and net_delta.ChunkBuffers ) then
		for steamID, _ in pairs( net_delta.ChunkBuffers ) do
			if ( !activeSteamIDs[ steamID ] ) then
				net_delta.ChunkBuffers[ steamID ] = nil
				cleaned = cleaned + 1
			end
		end
	end

	OrphansCleaned = OrphansCleaned + cleaned
	return cleaned

end


--
-- Monitor net message volume
--
local MessageCounts = {}	-- [messageName] = count this interval
local MessageCountResetTime = 0

function NetGC.TrackMessage( name )
	MessageCounts[ name ] = ( MessageCounts[ name ] or 0 ) + 1
end

function NetGC.GetMessageVolume()
	return MessageCounts
end

function NetGC.CheckThresholds()

	local warnings = {}

	for name, count in pairs( MessageCounts ) do
		if ( count >= WarningThreshold ) then
			table.insert( warnings, {
				name = name,
				count = count
			} )
		end
	end

	if ( #warnings > 0 ) then
		table.sort( warnings, function( a, b ) return a.count > b.count end )
		print( "[NetGC] WARNING: High net message volume detected:" )
		for _, w in ipairs( warnings ) do
			print( string.format( "  %s: %d messages in %ds", w.name, w.count, RunInterval ) )
		end
	end

	return warnings

end


-- Periodic GC
hook.Add( "Think", "NetGC_Process", function()

	local now = SysTime()
	if ( now - LastRun < RunInterval ) then return end
	LastRun = now

	-- Run GC
	NetGC.CollectGarbage()

	-- Check thresholds then reset counters
	NetGC.CheckThresholds()
	MessageCounts = {}
	MessageCountResetTime = now

end )

-- Auto-cleanup on disconnect
hook.Add( "PlayerDisconnected", "NetGC_PlayerCleanup", function( ply )

	if ( !IsValid( ply ) ) then return end

	local steamID = ply:SteamID()

	-- Clean any per-player state in net_delta
	if ( net_delta and net_delta.PlayerStates ) then
		net_delta.PlayerStates[ steamID ] = nil
	end

	if ( net_delta and net_delta.ChunkBuffers ) then
		net_delta.ChunkBuffers[ steamID ] = nil
	end

	OrphansCleaned = OrphansCleaned + 1

end )


-- Console commands
concommand.Add( "lua_netgc_info", function( ply, cmd, args )

	if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end

	print( "========== NET GC ==========" )
	print( "  Orphans cleaned: " .. OrphansCleaned )
	print( "  Run interval:    " .. RunInterval .. "s" )
	print( "  Warning at:      " .. WarningThreshold .. " msg/interval" )

	local vol = NetGC.GetMessageVolume()
	local volCount = table.Count( vol )
	if ( volCount > 0 ) then
		print( "" )
		print( "  Current interval message counts:" )
		local sorted = {}
		for name, count in pairs( vol ) do
			table.insert( sorted, { name = name, count = count } )
		end
		table.sort( sorted, function( a, b ) return a.count > b.count end )
		local limit = math.min( 10, #sorted )
		for i = 1, limit do
			print( string.format( "    %-30s %d", sorted[ i ].name, sorted[ i ].count ) )
		end
	end

	print( "============================" )

end )

concommand.Add( "lua_netgc_run", function( ply, cmd, args )
	if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end
	local cleaned = NetGC.CollectGarbage()
	print( "[NetGC] Forced GC: " .. cleaned .. " orphans cleaned" )
end )

MsgN( "[NetGC] Network garbage collector loaded." )
