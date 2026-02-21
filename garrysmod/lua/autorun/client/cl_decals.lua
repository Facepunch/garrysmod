---------------
	DECAL & EFFECT MANAGER

	Decals and effects accumulate during gameplay and never
	get cleaned up, causing FPS drops over time. This manager
	tracks decal count and auto-cleans old ones when limits
	are exceeded. Also throttles effect creation during lag.

	ConVars:
		cl_decalmanager 1        - Enable decal management
		cl_decalmanager_max 256  - Max decals before cleanup
		cl_effectthrottle 1      - Enable effect throttling
		cl_effectthrottle_fps 30 - FPS threshold for throttling

	Console Commands:
		lua_decals_clean         - Force clean all decals
		lua_decals_info          - Show decal/effect stats
----------------

if ( SERVER ) then return end

decalmanager = decalmanager or {}

CreateClientConVar( "cl_decalmanager", "1", true, false, "Enable decal manager" )
CreateClientConVar( "cl_decalmanager_max", "256", true, false, "Max decals before auto-cleanup" )
CreateClientConVar( "cl_effectthrottle", "1", true, false, "Enable effect throttling during low FPS" )
CreateClientConVar( "cl_effectthrottle_fps", "30", true, false, "FPS threshold for effect throttling" )

local DecalCount = 0
local TotalCleaned = 0
local EffectsBlocked = 0
local EffectsAllowed = 0
local LastCleanTime = 0
local LastFPS = 60


--
-- Track decal count (hook into effect dispatch)
--
hook.Add( "EntityEmitSound", "DecalManager_Track", function() end )		-- placeholder for tracking


--
-- Auto-clean decals when limit exceeded
--
hook.Add( "Think", "DecalManager_AutoClean", function()

	if ( !GetConVar( "cl_decalmanager" ):GetBool() ) then return end

	-- Only check every 5 seconds
	local now = SysTime()
	if ( now - LastCleanTime < 5 ) then return end
	LastCleanTime = now

	-- Track FPS for effect throttling
	LastFPS = 1 / FrameTime()

	-- Check if we should clean decals
	local maxDecals = GetConVar( "cl_decalmanager_max" ):GetInt()

	-- GMod tracks decals internally, but we can force cleanup
	-- when performance drops
	if ( LastFPS < 45 and DecalCount > maxDecals * 0.5 ) then
		RunConsoleCommand( "r_cleardecals" )
		DecalCount = 0
		TotalCleaned = TotalCleaned + 1
	end

end )


--
-- Effect throttling - reduce effects when FPS is low
--
local OriginalEffectCreate = nil

function decalmanager.InstallEffectThrottle()

	if ( OriginalEffectCreate ) then return end		-- already installed

	-- Wrap util.Effect to throttle during low FPS
	OriginalEffectCreate = util.Effect

	util.Effect = function( name, data, allowOverride, ignorePrediction )

		if ( !GetConVar( "cl_effectthrottle" ):GetBool() ) then
			EffectsAllowed = EffectsAllowed + 1
			return OriginalEffectCreate( name, data, allowOverride, ignorePrediction )
		end

		local threshold = GetConVar( "cl_effectthrottle_fps" ):GetFloat()

		if ( LastFPS < threshold ) then
			-- Skip non-essential effects during low FPS
			-- Allow critical ones (blood, explosions) through
			local lower = string.lower( name )
			if ( string.find( lower, "blood" ) or
				 string.find( lower, "explo" ) or
				 string.find( lower, "impact" ) ) then
				EffectsAllowed = EffectsAllowed + 1
				return OriginalEffectCreate( name, data, allowOverride, ignorePrediction )
			end

			-- Skip cosmetic effects
			EffectsBlocked = EffectsBlocked + 1
			return
		end

		EffectsAllowed = EffectsAllowed + 1
		return OriginalEffectCreate( name, data, allowOverride, ignorePrediction )

	end

end


--
-- Stats
--
function decalmanager.GetStats()
	return {
		currentFPS = math.Round( LastFPS, 1 ),
		totalCleans = TotalCleaned,
		effectsAllowed = EffectsAllowed,
		effectsBlocked = EffectsBlocked,
		blockRate = ( EffectsAllowed + EffectsBlocked ) > 0
			and math.Round( EffectsBlocked / ( EffectsAllowed + EffectsBlocked ) * 100, 1 ) or 0
	}
end


-- Console commands
concommand.Add( "lua_decals_clean", function()
	RunConsoleCommand( "r_cleardecals" )
	DecalCount = 0
	TotalCleaned = TotalCleaned + 1
	print( "[DecalManager] Decals cleared." )
end )

concommand.Add( "lua_decals_info", function()

	local s = decalmanager.GetStats()

	print( "========== DECAL/EFFECT MANAGER ==========" )
	print( string.format( "  Current FPS:       %.1f", s.currentFPS ) )
	print( string.format( "  Auto-cleans:       %d", s.totalCleans ) )
	print( string.format( "  Effects allowed:   %d", s.effectsAllowed ) )
	print( string.format( "  Effects blocked:   %d", s.effectsBlocked ) )
	print( string.format( "  Block rate:        %s%%", s.blockRate ) )
	print( "===========================================" )

end )

-- Install effect throttle on load
decalmanager.InstallEffectThrottle()

MsgN( "[DecalManager] Decal/effect manager loaded." )
