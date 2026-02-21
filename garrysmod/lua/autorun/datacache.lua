---------------
	DATA CACHE FRAMEWORK

	Generic namespaced key-value cache with TTL for addons
	to store expensive computation results. Prevents cache
	key collisions between addons via namespacing.

	Usage:
		-- Store with 60 second TTL:
		datacache.Set( "my_addon", "player_count", 42, 60 )

		-- Retrieve (nil if expired):
		local count = datacache.Get( "my_addon", "player_count" )

		-- Lazy evaluation (compute only if missing/expired):
		local data = datacache.GetOrCompute( "my_addon", "expensive_query",
			function() return RunExpensiveQuery() end,
			120  -- cache for 2 minutes
		)

	Console Commands (SuperAdmin):
		lua_datacache_info          - Show all namespaces
		lua_datacache_clear [ns]    - Clear a namespace or all
----------------

datacache = datacache or {}

local Store = {}		-- [namespace] = { [key] = { value, expiry } }
local Stats = {
	hits = 0,
	misses = 0,
	sets = 0,
	evictions = 0
}


--
-- Set a value with optional TTL (seconds)
--
function datacache.Set( namespace, key, value, ttl )

	if ( !Store[ namespace ] ) then
		Store[ namespace ] = {}
	end

	Store[ namespace ][ key ] = {
		value = value,
		expiry = ttl and ( SysTime() + ttl ) or nil,
		setTime = SysTime()
	}

	Stats.sets = Stats.sets + 1

end


--
-- Get a value (returns nil if expired or missing)
--
function datacache.Get( namespace, key )

	local ns = Store[ namespace ]
	if ( !ns ) then
		Stats.misses = Stats.misses + 1
		return nil
	end

	local entry = ns[ key ]
	if ( !entry ) then
		Stats.misses = Stats.misses + 1
		return nil
	end

	-- Check expiry
	if ( entry.expiry and SysTime() > entry.expiry ) then
		ns[ key ] = nil
		Stats.evictions = Stats.evictions + 1
		Stats.misses = Stats.misses + 1
		return nil
	end

	Stats.hits = Stats.hits + 1
	return entry.value

end


--
-- Get or compute (lazy evaluation)
--
function datacache.GetOrCompute( namespace, key, computeFunc, ttl )

	local cached = datacache.Get( namespace, key )
	if ( cached != nil ) then return cached end

	local value = computeFunc()
	datacache.Set( namespace, key, value, ttl )
	return value

end


--
-- Check if a key exists and is not expired
--
function datacache.Has( namespace, key )
	return datacache.Get( namespace, key ) != nil
end


--
-- Remove a specific key
--
function datacache.Remove( namespace, key )
	if ( Store[ namespace ] ) then
		Store[ namespace ][ key ] = nil
	end
end


--
-- Clear a namespace or everything
--
function datacache.Clear( namespace )
	if ( namespace ) then
		Store[ namespace ] = nil
	else
		Store = {}
	end
end


--
-- Get all namespaces info
--
function datacache.GetNamespaces()

	local info = {}
	for ns, entries in pairs( Store ) do
		local count = 0
		local expired = 0
		local now = SysTime()

		for key, entry in pairs( entries ) do
			count = count + 1
			if ( entry.expiry and now > entry.expiry ) then
				expired = expired + 1
			end
		end

		table.insert( info, {
			namespace = ns,
			entries = count,
			expired = expired,
			active = count - expired
		} )
	end

	return info

end


--
-- Periodic cleanup of expired entries
--
local LastCleanup = 0
hook.Add( "Think", "DataCache_Cleanup", function()

	local now = SysTime()
	if ( now - LastCleanup < 60 ) then return end		-- Every 60 seconds
	LastCleanup = now

	for ns, entries in pairs( Store ) do
		for key, entry in pairs( entries ) do
			if ( entry.expiry and now > entry.expiry ) then
				entries[ key ] = nil
				Stats.evictions = Stats.evictions + 1
			end
		end
	end

end )


-- Console commands
concommand.Add( "lua_datacache_info", function( ply, cmd, args )

	if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end

	print( "========== DATA CACHE ==========" )
	print( string.format( "  Hits: %d | Misses: %d | Sets: %d | Evictions: %d",
		Stats.hits, Stats.misses, Stats.sets, Stats.evictions ) )

	local total = Stats.hits + Stats.misses
	if ( total > 0 ) then
		print( string.format( "  Hit rate: %.1f%%", Stats.hits / total * 100 ) )
	end

	print( "" )

	local namespaces = datacache.GetNamespaces()
	if ( #namespaces > 0 ) then
		print( string.format( "  %-20s %8s %8s", "NAMESPACE", "ACTIVE", "EXPIRED" ) )
		for _, ns in ipairs( namespaces ) do
			print( string.format( "  %-20s %8d %8d", ns.namespace, ns.active, ns.expired ) )
		end
	else
		print( "  No namespaces in use." )
	end

	print( "================================" )

end )

concommand.Add( "lua_datacache_clear", function( ply, cmd, args )

	if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end

	if ( args[ 1 ] ) then
		datacache.Clear( args[ 1 ] )
		print( "[DataCache] Cleared namespace: " .. args[ 1 ] )
	else
		datacache.Clear()
		print( "[DataCache] All caches cleared." )
	end

end )

MsgN( "[DataCache] Generic data cache loaded." )
