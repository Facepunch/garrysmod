---------------
	PARTICLE THROTTLE (Inspired by a local performance addon i've been progressivley working on over last couple months)

	Dynamically adjusts particle rendering quality based on
	real-time FPS. During heavy events (lightsaber battles,
	explosions, NPC waves), automatically reduces particle
	count to maintain playable framerates.

	4 throttle levels:
		0 = Full Quality
		1 = Reduced (mat_reduceparticles on)
		2 = Minimal (+ particle retire cost)
		3 = Emergency (aggressive particle culling)

	ConVars:
		cl_particlethrottle 1           - Enable particle throttling
		cl_particlethrottle_target 45   - FPS to start throttling
		cl_particlethrottle_recover 60  - FPS to restore quality

	Console Commands:
		lua_particle_status  - Show current throttle level
		lua_particle_reset   - Force restore particle quality
----------------

if ( SERVER ) then return end

local cv_enable = CreateClientConVar( "cl_particlethrottle", "1", true, false, "Enable dynamic particle throttling" )
local cv_target = CreateClientConVar( "cl_particlethrottle_target", "45", true, false, "FPS to start throttling", 20, 144 )
local cv_recover = CreateClientConVar( "cl_particlethrottle_recover", "60", true, false, "FPS to restore quality", 30, 165 )

local CurrentLevel = 0
local LastLevelChange = 0
local LEVEL_COOLDOWN = 4
local CHECK_INTERVAL = 2
local NextCheck = 0
local StartupTime = RealTime()
local STARTUP_GRACE = 45

local FPSSamples = {}
local MAX_SAMPLES = 30


---------------
	THROTTLE LEVELS
----------------

local LEVELS = {
	[0] = { name = "Full Quality", reduced = "0", flecks = "0", retire = "0" },
	[1] = { name = "Reduced",      reduced = "1", flecks = "0", retire = "5" },
	[2] = { name = "Minimal",      reduced = "1", flecks = "0", retire = "10" },
	[3] = { name = "Emergency",    reduced = "1", flecks = "0", retire = "20" },
}


---------------
	ORIGINAL VALUES
----------------

local Originals = {
	mat_reduceparticles = nil,
	r_drawflecks = nil,
	cl_particle_retire_cost = nil,
}

local function SaveOriginals()
	if ( Originals.mat_reduceparticles != nil ) then return end

	local cv

	cv = GetConVar( "mat_reduceparticles" )
	Originals.mat_reduceparticles = cv and cv:GetString() or "0"

	cv = GetConVar( "r_drawflecks" )
	Originals.r_drawflecks = cv and cv:GetString() or "0"

	cv = GetConVar( "cl_particle_retire_cost" )
	Originals.cl_particle_retire_cost = cv and cv:GetString() or "0"
end


local function ApplyLevel( level )

	local settings = LEVELS[ level ]
	if ( !settings ) then return end

	RunConsoleCommand( "mat_reduceparticles", settings.reduced )
	RunConsoleCommand( "r_drawflecks", settings.flecks )

	local cv = GetConVar( "cl_particle_retire_cost" )
	if ( cv ) then
		RunConsoleCommand( "cl_particle_retire_cost", settings.retire )
	end

	CurrentLevel = level
	LastLevelChange = CurTime()

	print( string.format( "[ParticleThrottle] %s (avg FPS: %d)", settings.name, math.Round( GetAverageFPS() ) ) )

end


local function RestoreOriginals()

	if ( Originals.mat_reduceparticles ) then
		RunConsoleCommand( "mat_reduceparticles", Originals.mat_reduceparticles )
	end
	if ( Originals.r_drawflecks ) then
		RunConsoleCommand( "r_drawflecks", Originals.r_drawflecks )
	end
	if ( Originals.cl_particle_retire_cost ) then
		local cv = GetConVar( "cl_particle_retire_cost" )
		if ( cv ) then
			RunConsoleCommand( "cl_particle_retire_cost", Originals.cl_particle_retire_cost )
		end
	end

	CurrentLevel = 0

end


function GetAverageFPS()
	if ( #FPSSamples == 0 ) then return 60 end
	local sum = 0
	for _, fps in ipairs( FPSSamples ) do sum = sum + fps end
	return sum / #FPSSamples
end


---------------
	THROTTLE CHECK
----------------

hook.Add( "Think", "ParticleThrottle_Tick", function()

	if ( !cv_enable:GetBool() ) then return end
	if ( RealTime() - StartupTime < STARTUP_GRACE ) then return end

	local now = CurTime()
	if ( now < NextCheck ) then return end
	NextCheck = now + CHECK_INTERVAL

	local fps = 1 / RealFrameTime()
	table.insert( FPSSamples, fps )
	if ( #FPSSamples > MAX_SAMPLES ) then table.remove( FPSSamples, 1 ) end
	if ( #FPSSamples < 5 ) then return end

	if ( now - LastLevelChange < LEVEL_COOLDOWN ) then return end

	SaveOriginals()

	local avgFPS = GetAverageFPS()
	local target = cv_target:GetFloat()
	local recover = cv_recover:GetFloat()

	local targetLevel = CurrentLevel

	if ( avgFPS < target * 0.6 ) then
		targetLevel = 3
	elseif ( avgFPS < target * 0.8 ) then
		targetLevel = math.max( CurrentLevel, 2 )
	elseif ( avgFPS < target ) then
		targetLevel = math.max( CurrentLevel, 1 )
	elseif ( avgFPS > recover and CurrentLevel > 0 ) then
		targetLevel = CurrentLevel - 1
	end

	if ( targetLevel != CurrentLevel ) then
		ApplyLevel( targetLevel )
	end

end )


-- Restore on shutdown
hook.Add( "ShutDown", "ParticleThrottle_Restore", function()
	RestoreOriginals()
end )

-- Restore when disabled
cvars.AddChangeCallback( "cl_particlethrottle", function( _, _, new )
	if ( new == "0" ) then RestoreOriginals() end
end, "ParticleThrottle" )


-- Console commands
concommand.Add( "lua_particle_status", function()
	local level = LEVELS[ CurrentLevel ]
	print( string.format( "[ParticleThrottle] Level: %s | Avg FPS: %d | Target: %s | Recover: %s",
		level.name, math.Round( GetAverageFPS() ), cv_target:GetString(), cv_recover:GetString() ) )
end )

concommand.Add( "lua_particle_reset", function()
	RestoreOriginals()
	FPSSamples = {}
	print( "[ParticleThrottle] Particle settings restored." )
end )

MsgN( "[ParticleThrottle] Dynamic particle throttling loaded." )
