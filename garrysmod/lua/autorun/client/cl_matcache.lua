---------------
	MATERIAL & FONT CACHE

	Material() and surface.CreateFont() are expensive calls
	that many addons call every frame inside HUD paint hooks.
	This caches the results so repeated calls are O(1) lookups.

	Usage:
		-- Instead of:  local mat = Material( "vgui/gradient-d" )  inside HUDPaint
		-- Use:         local mat = matcache.Get( "vgui/gradient-d" )

		-- Instead of calling surface.CreateFont every frame:
		-- Use:         matcache.Font( "MyFont", { font = "Roboto", size = 24 } )

	ConVars:
		cl_matcache 1         - Enable material caching (default on)

	Console Commands:
		lua_matcache_info     - Show cache stats
		lua_matcache_clear    - Flush all caches
----------------

if ( SERVER ) then return end

matcache = matcache or {}

CreateClientConVar( "cl_matcache", "1", true, false, "Enable material/font caching" )

local MatStore = {}			-- [path] = IMaterial
local FontStore = {}		-- [name] = true (already created)
local FontDefs = {}			-- [name] = definition table
local Stats = { matHits = 0, matMisses = 0, fontHits = 0, fontCreates = 0 }


--
-- Cached Material() lookup
--
function matcache.Get( path, pngParams )

	if ( !GetConVar( "cl_matcache" ):GetBool() ) then
		return Material( path, pngParams )
	end

	local key = path .. ( pngParams or "" )

	if ( MatStore[ key ] ) then
		Stats.matHits = Stats.matHits + 1
		return MatStore[ key ]
	end

	local mat = Material( path, pngParams )
	MatStore[ key ] = mat
	Stats.matMisses = Stats.matMisses + 1
	return mat

end


--
-- Cached font creation (deduplicates identical CreateFont calls)
--
function matcache.Font( name, definition )

	if ( FontStore[ name ] ) then
		Stats.fontHits = Stats.fontHits + 1
		return name
	end

	surface.CreateFont( name, definition )
	FontStore[ name ] = true
	FontDefs[ name ] = definition
	Stats.fontCreates = Stats.fontCreates + 1
	return name

end


--
-- Batch create multiple fonts at once
--
function matcache.Fonts( definitions )
	for name, def in pairs( definitions ) do
		matcache.Font( name, def )
	end
end


--
-- Clear caches
--
function matcache.Clear()
	MatStore = {}
	FontStore = {}
	FontDefs = {}
	Stats = { matHits = 0, matMisses = 0, fontHits = 0, fontCreates = 0 }
end


--
-- Get stats
--
function matcache.GetStats()
	return {
		materials = table.Count( MatStore ),
		fonts = table.Count( FontStore ),
		matHitRate = ( Stats.matHits + Stats.matMisses ) > 0
			and math.Round( Stats.matHits / ( Stats.matHits + Stats.matMisses ) * 100, 1 ) or 0,
		stats = Stats
	}
end


-- Console commands
concommand.Add( "lua_matcache_info", function()

	local info = matcache.GetStats()

	print( "========== MATERIAL/FONT CACHE ==========" )
	print( string.format( "  Cached materials: %d", info.materials ) )
	print( string.format( "  Cached fonts:     %d", info.fonts ) )
	print( string.format( "  Mat hit rate:     %s%%", info.matHitRate ) )
	print( string.format( "  Mat hits/misses:  %d / %d", info.stats.matHits, info.stats.matMisses ) )
	print( string.format( "  Font hits/creates:%d / %d", info.stats.fontHits, info.stats.fontCreates ) )
	print( "==========================================" )

end )

concommand.Add( "lua_matcache_clear", function()
	matcache.Clear()
	print( "[MatCache] All caches cleared." )
end )

MsgN( "[MatCache] Material & font cache loaded." )
