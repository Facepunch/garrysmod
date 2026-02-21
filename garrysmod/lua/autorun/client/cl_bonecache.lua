---------------
	BONE POSITION CACHE

	Entity:GetBonePosition() is expensive and often called
	multiple times per frame for the same entity/bone combo
	(by HUDs, effects, and weapon logic simultaneously).

	This caches bone positions per-frame so subsequent calls
	within the same frame return the cached result.

	Usage:
		-- Instead of: local pos, ang = ent:GetBonePosition( bone )
		-- Use:        local pos, ang = bonecache.Get( ent, bone )

	ConVars:
		cl_bonecache 1        - Enable bone caching

	Console Commands:
		lua_bonecache_info    - Show cache hit rates
----------------

if ( SERVER ) then return end

bonecache = bonecache or {}

CreateClientConVar( "cl_bonecache", "1", true, false, "Enable bone position caching" )

local Cache = {}			-- [entIndex] = { [boneId] = { pos, ang, frame } }
local CurrentFrame = 0
local Stats = { hits = 0, misses = 0 }


--
-- Get bone position (cached per-frame)
--
function bonecache.Get( ent, boneId )

	if ( !GetConVar( "cl_bonecache" ):GetBool() ) then
		return ent:GetBonePosition( boneId )
	end

	if ( !IsValid( ent ) ) then return Vector(), Angle() end

	local entIdx = ent:EntIndex()
	local frame = FrameNumber()

	-- New frame = clear stale entries
	if ( frame != CurrentFrame ) then
		Cache = {}
		CurrentFrame = frame
	end

	-- Check cache
	if ( Cache[ entIdx ] and Cache[ entIdx ][ boneId ] ) then
		local entry = Cache[ entIdx ][ boneId ]
		Stats.hits = Stats.hits + 1
		return entry.pos, entry.ang
	end

	-- Cache miss - compute and store
	local pos, ang = ent:GetBonePosition( boneId )

	if ( !Cache[ entIdx ] ) then Cache[ entIdx ] = {} end
	Cache[ entIdx ][ boneId ] = { pos = pos, ang = ang }

	Stats.misses = Stats.misses + 1
	return pos, ang

end


--
-- Get multiple bones at once
--
function bonecache.GetMultiple( ent, boneIds )

	local results = {}
	for _, boneId in ipairs( boneIds ) do
		local pos, ang = bonecache.Get( ent, boneId )
		results[ boneId ] = { pos = pos, ang = ang }
	end
	return results

end


--
-- Get all bone positions for an entity (cached)
--
function bonecache.GetAll( ent )

	if ( !IsValid( ent ) ) then return {} end

	local boneCount = ent:GetBoneCount()
	if ( !boneCount or boneCount <= 0 ) then return {} end

	local results = {}
	for i = 0, boneCount - 1 do
		local pos, ang = bonecache.Get( ent, i )
		results[ i ] = { pos = pos, ang = ang }
	end

	return results

end


--
-- Stats
--
function bonecache.GetStats()
	local total = Stats.hits + Stats.misses
	return {
		hits = Stats.hits,
		misses = Stats.misses,
		hitRate = total > 0 and math.Round( Stats.hits / total * 100, 1 ) or 0
	}
end

function bonecache.ResetStats()
	Stats = { hits = 0, misses = 0 }
end


-- Console commands
concommand.Add( "lua_bonecache_info", function()

	local s = bonecache.GetStats()

	print( "========== BONE CACHE ==========" )
	print( string.format( "  Cache hits:   %d", s.hits ) )
	print( string.format( "  Cache misses: %d", s.misses ) )
	print( string.format( "  Hit rate:     %s%%", s.hitRate ) )
	print( "=================================" )

end )

MsgN( "[BoneCache] Bone position cache loaded." )
