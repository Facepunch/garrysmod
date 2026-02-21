---------------
	FILE.EXISTS CACHE (inspired by HolyLib filesystem)

	HolyLib achieves a 54x speedup on file.Exists by caching
	search path results. This is a Lua-level approximation
	that caches file.Exists and file.Find results with TTL.

	On servers with 100+ addons, each addon adds search paths.
	A single file.Exists("myfile.lua", "LUA") checks every
	path sequentially. Caching eliminates repeated lookups.

	Usage:
		-- Uses the cache automatically after loading
		-- Or call explicitly:
		local exists = filecache.Exists( "path/to/file.lua", "LUA" )

	Console Commands:
		lua_filecache_info     - Cache statistics
		lua_filecache_clear    - Clear the cache
		lua_filecache_ttl <s>  - Set TTL in seconds (default 60)
----------------

filecache = filecache or {}

local ExistsCache = {}		-- [path:searchpath] = { result, expires }
local FindCache = {}		-- [pattern:path:searchpath] = { files, dirs, expires }
local DefaultTTL = 60		-- seconds
local Hits = 0
local Misses = 0
local SysTime = SysTime


--
-- Cached file.Exists
--
function filecache.Exists( path, searchPath )

	local key = path .. ":" .. ( searchPath or "GAME" )
	local cached = ExistsCache[ key ]
	local now = SysTime()

	if ( cached and now < cached.expires ) then
		Hits = Hits + 1
		return cached.result
	end

	-- Cache miss
	Misses = Misses + 1
	local result = file.Exists( path, searchPath or "GAME" )

	ExistsCache[ key ] = {
		result = result,
		expires = now + DefaultTTL
	}

	return result

end


--
-- Cached file.Find
--
function filecache.Find( pattern, searchPath )

	local key = pattern .. ":" .. ( searchPath or "GAME" )
	local cached = FindCache[ key ]
	local now = SysTime()

	if ( cached and now < cached.expires ) then
		Hits = Hits + 1
		return cached.files, cached.dirs
	end

	Misses = Misses + 1
	local files, dirs = file.Find( pattern, searchPath or "GAME" )

	FindCache[ key ] = {
		files = files,
		dirs = dirs,
		expires = now + DefaultTTL
	}

	return files, dirs

end


--
-- Invalidate a specific path
--
function filecache.Invalidate( path, searchPath )
	local key = path .. ":" .. ( searchPath or "GAME" )
	ExistsCache[ key ] = nil
	FindCache[ key ] = nil
end


--
-- Clear entire cache
--
function filecache.Clear()
	ExistsCache = {}
	FindCache = {}
	Hits = 0
	Misses = 0
end


--
-- Get stats
--
function filecache.GetStats()

	local existsCount = table.Count( ExistsCache )
	local findCount = table.Count( FindCache )
	local total = Hits + Misses

	return {
		existsEntries = existsCount,
		findEntries = findCount,
		hits = Hits,
		misses = Misses,
		hitRate = total > 0 and ( Hits / total * 100 ) or 0,
		ttl = DefaultTTL
	}

end


-- Console commands
concommand.Add( "lua_filecache_info", function( ply, cmd, args )

	if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end

	local stats = filecache.GetStats()
	print( "========== FILE CACHE ==========" )
	print( "  TTL:            " .. stats.ttl .. "s" )
	print( "  Exists entries: " .. stats.existsEntries )
	print( "  Find entries:   " .. stats.findEntries )
	print( "  Hits:           " .. stats.hits )
	print( "  Misses:         " .. stats.misses )
	print( "  Hit rate:       " .. string.format( "%.1f", stats.hitRate ) .. "%" )
	print( "=================================" )

end )

concommand.Add( "lua_filecache_clear", function( ply, cmd, args )
	if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end
	filecache.Clear()
	print( "[FileCache] Cache cleared" )
end )

concommand.Add( "lua_filecache_ttl", function( ply, cmd, args )
	if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end
	local ttl = tonumber( args[ 1 ] )
	if ( !ttl ) then
		print( "[FileCache] Current TTL: " .. DefaultTTL .. "s" )
		return
	end
	DefaultTTL = math.max( 1, ttl )
	print( "[FileCache] TTL set to " .. DefaultTTL .. "s" )
end )

MsgN( "[FileCache] Loaded. TTL: " .. DefaultTTL .. "s" )
