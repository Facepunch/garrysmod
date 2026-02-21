---------------
	CONVAR LOOKUP CACHE (inspired by HolyLib)

	Every GetConVar("name") call does string hashing and
	dictionary lookup. On a busy server calling GetConVar
	hundreds of times per tick, this adds up.

	This caches the ConVar object reference so lookups are O(1).

	Usage:
		-- Instead of GetConVar("sv_cheats"):
		local cv = cvar.Get( "sv_cheats" )
		cv:GetBool()

		-- Batch get multiple convars:
		local cvars = cvar.GetMany( "sv_cheats", "sv_gravity", "host_timescale" )

	Console Commands:
		lua_cvarcache_info   - Show cache statistics
----------------

cvarcache = cvarcache or {}

local Cache = {}
local Hits = 0
local Misses = 0


--
-- Get a cached ConVar object
--
function cvarcache.Get( name )

	local cached = Cache[ name ]
	if ( cached ) then
		Hits = Hits + 1
		return cached
	end

	Misses = Misses + 1
	local cv = GetConVar( name )

	if ( cv ) then
		Cache[ name ] = cv
	end

	return cv

end


--
-- Get multiple ConVar objects at once
--
function cvarcache.GetMany( ... )

	local names = { ... }
	local results = {}

	for i = 1, #names do
		results[ i ] = cvarcache.Get( names[ i ] )
	end

	return results

end


--
-- Get value directly (shorthand)
--
function cvarcache.GetBool( name )
	local cv = cvarcache.Get( name )
	return cv and cv:GetBool() or false
end

function cvarcache.GetInt( name )
	local cv = cvarcache.Get( name )
	return cv and cv:GetInt() or 0
end

function cvarcache.GetFloat( name )
	local cv = cvarcache.Get( name )
	return cv and cv:GetFloat() or 0
end

function cvarcache.GetString( name )
	local cv = cvarcache.Get( name )
	return cv and cv:GetString() or ""
end


--
-- Invalidate a specific entry (if convar was recreated)
--
function cvarcache.Invalidate( name )
	Cache[ name ] = nil
end

function cvarcache.Clear()
	Cache = {}
	Hits = 0
	Misses = 0
end


--
-- Get stats
--
function cvarcache.GetStats()
	local total = Hits + Misses
	return {
		entries = table.Count( Cache ),
		hits = Hits,
		misses = Misses,
		hitRate = total > 0 and ( Hits / total * 100 ) or 0
	}
end


--
-- Pre-warm common engine ConVars
--
local function WarmCache()
	local common = {
		"sv_cheats", "sv_gravity", "sv_friction", "sv_maxrate",
		"sv_minrate", "sv_maxupdaterate", "sv_minupdaterate",
		"host_timescale", "sv_alltalk", "sv_accelerate",
		"sv_airaccelerate", "sv_wateraccelerate",
		"physgun_limited", "sbox_noclip", "sbox_maxprops",
		"sbox_maxragdolls", "sbox_maxnpcs", "sbox_maxballoons",
		"sbox_maxeffects", "sbox_maxdynamite", "sbox_maxlamps",
		"sbox_maxthrusters", "sbox_maxwheels", "sbox_maxhoverballs"
	}

	for _, name in ipairs( common ) do
		cvarcache.Get( name )
	end
end

-- Warm on load
WarmCache()


-- Console command
concommand.Add( "lua_cvarcache_info", function( ply, cmd, args )

	if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end

	local stats = cvarcache.GetStats()
	print( "========== CONVAR CACHE ==========" )
	print( "  Cached entries: " .. stats.entries )
	print( "  Hits:           " .. stats.hits )
	print( "  Misses:         " .. stats.misses )
	print( "  Hit rate:       " .. string.format( "%.1f", stats.hitRate ) .. "%" )
	print( "==================================" )

end )

MsgN( "[CvarCache] Loaded. " .. table.Count( Cache ) .. " convars pre-warmed." )
