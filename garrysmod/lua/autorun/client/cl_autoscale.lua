---------------
	AUTO-PERFORMANCE SCALER (Inspired by a local performance addon i've been progressivley working on over last couple months)

	Automatically adjusts engine quality settings based on
	real-time FPS. Prevents stuttering by progressively
	reducing quality before it gets bad, then recovers
	when FPS stabilizes.

	4 quality levels:
		0 = Full Quality (restores user's original settings)
		1 = Reduced (detail, decals, flecks)
		2 = Low (+ dynamic lights, bumpmaps, specular)
		3 = Emergency (+ shadows, water, detail props)

	ConVars:
		cl_autoscale 1           - Enable auto-scaling
		cl_autoscale_target 40   - Target FPS to maintain
		cl_autoscale_recover 60  - FPS to start recovering quality

	Console Commands:
		lua_autoscale_status     - Show current level and FPS
		lua_autoscale_reset      - Force restore original quality
----------------

if ( SERVER ) then return end

CreateClientConVar( "cl_autoscale", "1", true, false, "Enable auto-performance scaling" )
CreateClientConVar( "cl_autoscale_target", "40", true, false, "Target FPS to maintain", 20, 300 )
CreateClientConVar( "cl_autoscale_recover", "60", true, false, "FPS to start recovering quality", 30, 300 )

local FPSHistory = {}
local FPS_HISTORY_SIZE = 120
local CurrentLevel = 0
local LevelChangeTime = 0
local LEVEL_COOLDOWN = 3
local STARTUP_GRACE = 30
local StartupTime = RealTime()

local Originals = {}
local SavedOriginals = false


---------------
	FPS TRACKING
----------------

local function GetAverageFPS()
	if ( #FPSHistory == 0 ) then return 60 end
	local sum = 0
	for _, fps in ipairs( FPSHistory ) do sum = sum + fps end
	return sum / #FPSHistory
end

local function TrackFPS()
	table.insert( FPSHistory, 1 / RealFrameTime() )
	if ( #FPSHistory > FPS_HISTORY_SIZE ) then
		table.remove( FPSHistory, 1 )
	end
end


---------------
	CONVAR TRACKING
----------------

local TRACKED_CVARS = {
	"r_dynamic", "r_shadows", "r_decals",
	"cl_detaildist", "cl_detailfade", "r_drawflecks",
	"cl_ejectbrass", "mat_bumpmap", "mat_specular",
	"r_drawmodeldecals", "r_drawdetailprops", "r_waterforceexpensive",
}

local function SaveOriginals()
	if ( SavedOriginals ) then return end
	for _, name in ipairs( TRACKED_CVARS ) do
		local cvar = GetConVar( name )
		if ( cvar ) then Originals[ name ] = cvar:GetString() end
	end
	SavedOriginals = true
end


---------------
	QUALITY LEVELS
----------------

local LEVELS = {
	[0] = {
		name = "Full Quality",
		apply = function()
			for cvar, val in pairs( Originals ) do
				RunConsoleCommand( cvar, tostring( val ) )
			end
		end,
	},
	[1] = {
		name = "Reduced",
		apply = function()
			RunConsoleCommand( "cl_detaildist", "800" )
			RunConsoleCommand( "cl_detailfade", "200" )
			RunConsoleCommand( "r_decals", "256" )
			RunConsoleCommand( "r_drawflecks", "0" )
		end,
	},
	[2] = {
		name = "Low",
		apply = function()
			RunConsoleCommand( "r_dynamic", "0" )
			RunConsoleCommand( "cl_detaildist", "200" )
			RunConsoleCommand( "cl_detailfade", "50" )
			RunConsoleCommand( "r_decals", "64" )
			RunConsoleCommand( "r_drawflecks", "0" )
			RunConsoleCommand( "cl_ejectbrass", "0" )
			RunConsoleCommand( "mat_bumpmap", "0" )
			RunConsoleCommand( "mat_specular", "0" )
		end,
	},
	[3] = {
		name = "EMERGENCY",
		apply = function()
			RunConsoleCommand( "r_dynamic", "0" )
			RunConsoleCommand( "r_shadows", "0" )
			RunConsoleCommand( "cl_detaildist", "0" )
			RunConsoleCommand( "cl_detailfade", "0" )
			RunConsoleCommand( "r_decals", "0" )
			RunConsoleCommand( "r_drawflecks", "0" )
			RunConsoleCommand( "cl_ejectbrass", "0" )
			RunConsoleCommand( "mat_bumpmap", "0" )
			RunConsoleCommand( "mat_specular", "0" )
			RunConsoleCommand( "r_drawmodeldecals", "0" )
			RunConsoleCommand( "r_drawdetailprops", "0" )
			RunConsoleCommand( "r_waterforceexpensive", "0" )
		end,
	},
}


---------------
	SCALING LOGIC
----------------

local function SetLevel( newLevel )

	if ( newLevel == CurrentLevel ) then return end
	if ( CurTime() - LevelChangeTime < LEVEL_COOLDOWN ) then return end

	local levelData = LEVELS[ newLevel ]
	if ( !levelData ) then return end

	CurrentLevel = newLevel
	LevelChangeTime = CurTime()
	levelData.apply()

	print( string.format( "[AutoScale] %s (Level %d/3 | avg FPS: %d)",
		levelData.name, newLevel, math.Round( GetAverageFPS() ) ) )

end

local nextCheck = 0

hook.Add( "Think", "AutoScale_Tick", function()

	if ( !GetConVar( "cl_autoscale" ):GetBool() ) then
		if ( CurrentLevel > 0 ) then SetLevel( 0 ) end
		return
	end

	TrackFPS()

	if ( RealTime() - StartupTime < STARTUP_GRACE ) then return end

	local now = CurTime()
	if ( now < nextCheck ) then return end
	nextCheck = now + 1

	SaveOriginals()

	local avgFPS = GetAverageFPS()
	local target = GetConVar( "cl_autoscale_target" ):GetFloat()
	local recover = GetConVar( "cl_autoscale_recover" ):GetFloat()

	local desiredLevel

	if ( avgFPS < target * 0.33 ) then
		desiredLevel = 3
	elseif ( avgFPS < target * 0.5 ) then
		desiredLevel = 2
	elseif ( avgFPS < target * 0.75 ) then
		desiredLevel = 1
	elseif ( avgFPS >= recover ) then
		desiredLevel = 0
	else
		desiredLevel = CurrentLevel
	end

	if ( desiredLevel > CurrentLevel ) then
		SetLevel( desiredLevel )
	elseif ( desiredLevel < CurrentLevel ) then
		SetLevel( CurrentLevel - 1 )		-- recover one level at a time
	end

end )


-- Restore on shutdown
hook.Add( "ShutDown", "AutoScale_Restore", function()
	if ( CurrentLevel > 0 and SavedOriginals ) then
		LEVELS[ 0 ].apply()
	end
end )

-- Restore when disabled
cvars.AddChangeCallback( "cl_autoscale", function( _, _, new )
	if ( new == "0" and CurrentLevel > 0 and SavedOriginals ) then
		CurrentLevel = 0
		LEVELS[ 0 ].apply()
		print( "[AutoScale] Disabled, quality restored." )
	end
end, "AutoScale_Restore" )


-- Console commands
concommand.Add( "lua_autoscale_status", function()
	local levelData = LEVELS[ CurrentLevel ] or LEVELS[ 0 ]
	print( string.format( "[AutoScale] Level %d (%s) | Avg FPS: %d", CurrentLevel, levelData.name, math.Round( GetAverageFPS() ) ) )
end )

concommand.Add( "lua_autoscale_reset", function()
	if ( SavedOriginals ) then
		LEVELS[ 0 ].apply()
		CurrentLevel = 0
		FPSHistory = {}
		print( "[AutoScale] Quality restored to original settings." )
	end
end )

MsgN( "[AutoScale] Auto-performance scaler loaded." )
