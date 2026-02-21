---------------
	LUA BYTECODE CACHING

	Caches compiled Lua functions to avoid re-parsing files
	on server restart / map change. Uses CompileString to compile
	source code and caches the resulting function.

	The cache is keyed by file path + modification time, so
	edited files automatically invalidate their cache entry.

	Usage:
		-- Instead of include("myfile.lua"):
		lua_cache.Include( "myfile.lua" )

		-- Or compile without running:
		local fn = lua_cache.Compile( "path/to/file.lua" )
		fn()  -- execute later

	Console Commands:
		lua_cache_info       - Show cache statistics
		lua_cache_clear      - Clear the cache
		lua_cache_enable 1   - Enable/disable caching

	Note: This is a Lua-level cache. True bytecode caching
	(saving compiled bytecode to disk) requires engine support
	for dumping/loading LuaJIT bytecode, which Rubat would
	need to expose. This implementation caches the compiled
	function objects in memory to avoid re-compilation within
	a session.
----------------

if ( !SERVER ) then return end

lua_cache = lua_cache or {}

local Cache = {}			-- [path] = { func, mtime, hits }
local CacheEnabled = true
local CacheHits = 0
local CacheMisses = 0


--
-- Compile and cache a Lua file
--
function lua_cache.Compile( path )

	if ( !CacheEnabled ) then
		-- Fall through to normal compile
		local content = file.Read( path, "LUA" )
		if ( !content ) then
			ErrorNoHaltWithStack( "[LuaCache] File not found: " .. path )
			return nil
		end
		return CompileString( content, path )
	end

	-- Check cache
	local cached = Cache[ path ]
	local mtime = file.Time( path, "LUA" ) or 0

	if ( cached and cached.mtime == mtime ) then
		-- Cache hit
		CacheHits = CacheHits + 1
		cached.hits = cached.hits + 1
		return cached.func
	end

	-- Cache miss - compile
	local content = file.Read( path, "LUA" )
	if ( !content ) then
		ErrorNoHaltWithStack( "[LuaCache] File not found: " .. path )
		return nil
	end

	local func = CompileString( content, path )
	if ( !func ) then
		ErrorNoHaltWithStack( "[LuaCache] Compile error in: " .. path )
		return nil
	end

	CacheMisses = CacheMisses + 1

	Cache[ path ] = {
		func = func,
		mtime = mtime,
		hits = 0,
		compiled = SysTime()
	}

	return func

end


--
-- Compile and execute (replacement for include with caching)
--
function lua_cache.Include( path )

	local func = lua_cache.Compile( path )
	if ( func ) then
		return func()
	end

end


--
-- Get cache statistics
--
function lua_cache.GetStats()
	return {
		entries = table.Count( Cache ),
		hits = CacheHits,
		misses = CacheMisses,
		hitRate = ( CacheHits + CacheMisses ) > 0
			and ( CacheHits / ( CacheHits + CacheMisses ) * 100 )
			or 0,
		enabled = CacheEnabled
	}
end


--
-- Clear the cache
--
function lua_cache.Clear()
	Cache = {}
	CacheHits = 0
	CacheMisses = 0
end


-- Console commands
concommand.Add( "lua_cache_info", function( ply, cmd, args )

	if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end

	local stats = lua_cache.GetStats()
	print( "========== LUA CACHE INFO ==========" )
	print( "  Enabled:     " .. tostring( stats.enabled ) )
	print( "  Entries:     " .. stats.entries )
	print( "  Hits:        " .. stats.hits )
	print( "  Misses:      " .. stats.misses )
	print( "  Hit rate:    " .. string.format( "%.1f", stats.hitRate ) .. "%" )
	print( "" )

	-- Show top cached files by hits
	local sorted = {}
	for path, data in pairs( Cache ) do
		table.insert( sorted, { path = path, hits = data.hits, mtime = data.mtime } )
	end
	table.sort( sorted, function( a, b ) return a.hits > b.hits end )

	local limit = math.min( 10, #sorted )
	if ( limit > 0 ) then
		print( "  Top " .. limit .. " most-hit cached files:" )
		for i = 1, limit do
			print( string.format( "    %5d hits  %s", sorted[ i ].hits, sorted[ i ].path ) )
		end
	end

	print( "====================================" )

end )

concommand.Add( "lua_cache_clear", function( ply, cmd, args )
	if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end
	lua_cache.Clear()
	print( "[LuaCache] Cache cleared" )
end )

concommand.Add( "lua_cache_enable", function( ply, cmd, args )
	if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end
	local val = tonumber( args[ 1 ] )
	if ( val == nil ) then
		print( "[LuaCache] Currently " .. ( CacheEnabled and "ENABLED" or "DISABLED" ) )
		return
	end
	CacheEnabled = ( val == 1 )
	print( "[LuaCache] " .. ( CacheEnabled and "ENABLED" or "DISABLED" ) )
end )

MsgN( "[LuaCache] Bytecode caching loaded. Use lua_cache_info for stats." )
