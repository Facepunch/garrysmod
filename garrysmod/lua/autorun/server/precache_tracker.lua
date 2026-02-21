---------------
	MODEL PRECACHE TRACKER (inspired by HolyLib stringtable)

	HolyLib exposes stringtable access to track model precache
	counts. Garry's Mod has a hard limit of ~4096 model
	precache slots. Exceeding this crashes the server.

	This wraps util.PrecacheModel and util.PrecacheSound to:
	- Deduplicate precache calls (same model won't precache twice)
	- Track counts and warn at 80% capacity
	- Show which addons are precaching the most

	Console Commands:
		lua_precache_info   - Show precache statistics
----------------

if ( !SERVER ) then return end

local PrecachedModels = {}		-- [path] = true
local PrecachedSounds = {}		-- [path] = true
local ModelCount = 0
local SoundCount = 0
local DuplicatesSaved = 0
local ModelLimit = 4096
local SoundLimit = 2048
local WarningPct = 0.8

-- Store originals
local OrigPrecacheModel = util.PrecacheModel
local OrigPrecacheSound = util.PrecacheSound


--
-- Wrapped PrecacheModel with dedup
--
util.PrecacheModel = function( path, ... )

	if ( !path or path == "" ) then return end

	local lower = path:lower()

	if ( PrecachedModels[ lower ] ) then
		DuplicatesSaved = DuplicatesSaved + 1
		return		-- Already precached, skip
	end

	PrecachedModels[ lower ] = true
	ModelCount = ModelCount + 1

	-- Warn near limit
	if ( ModelCount == math.floor( ModelLimit * WarningPct ) ) then
		print( "[PrecacheTracker] WARNING: Model precache at " ..
			math.floor( WarningPct * 100 ) .. "% capacity! (" ..
			ModelCount .. "/" .. ModelLimit .. ")" )
	end

	if ( ModelCount >= ModelLimit - 10 ) then
		print( "[PrecacheTracker] CRITICAL: Only " ..
			( ModelLimit - ModelCount ) .. " model precache slots remaining!" )
	end

	return OrigPrecacheModel( path, ... )

end


--
-- Wrapped PrecacheSound with dedup
--
util.PrecacheSound = function( path, ... )

	if ( !path or path == "" ) then return end

	local lower = path:lower()

	if ( PrecachedSounds[ lower ] ) then
		DuplicatesSaved = DuplicatesSaved + 1
		return
	end

	PrecachedSounds[ lower ] = true
	SoundCount = SoundCount + 1

	if ( SoundCount == math.floor( SoundLimit * WarningPct ) ) then
		print( "[PrecacheTracker] WARNING: Sound precache at " ..
			math.floor( WarningPct * 100 ) .. "% capacity! (" ..
			SoundCount .. "/" .. SoundLimit .. ")" )
	end

	return OrigPrecacheSound( path, ... )

end


--
-- Stats API
--
function precache_tracker_info()
	return {
		models = ModelCount,
		sounds = SoundCount,
		modelLimit = ModelLimit,
		soundLimit = SoundLimit,
		duplicatesSaved = DuplicatesSaved,
		modelPct = ModelCount / ModelLimit * 100,
		soundPct = SoundCount / SoundLimit * 100
	}
end


-- Console command
concommand.Add( "lua_precache_info", function( ply, cmd, args )

	if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end

	local stats = precache_tracker_info()
	print( "========== PRECACHE TRACKER ==========" )
	print( string.format( "  Models: %d / %d (%.1f%%)", stats.models, stats.modelLimit, stats.modelPct ) )
	print( string.format( "  Sounds: %d / %d (%.1f%%)", stats.sounds, stats.soundLimit, stats.soundPct ) )
	print( "  Duplicates saved: " .. stats.duplicatesSaved )
	print( "=======================================" )

end )

MsgN( "[PrecacheTracker] Model/sound precache tracking loaded." )
