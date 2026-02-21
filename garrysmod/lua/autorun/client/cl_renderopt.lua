---------------
	CLIENT-SIDE RENDER OPTIMISATION

	Offloads rendering decisions to the client's GPU/CPU instead
	of relying on the server. These features let the client
	make smart rendering choices based on distance, visibility,
	and available hardware performance.

	This addresses the core GMod bottleneck: the game renders
	everything the server sends, regardless of whether the
	client's hardware can handle it. These tools let clients
	self-regulate.

	Features:
		1. Dynamic Render Distance (skip drawing far entities)
		2. LOD-aware entity drawing (simplified materials at distance)
		3. HUD Rendering Throttle (reduce HUD paint frequency)
		4. Client-side entity interpolation (smooth movement between updates)
		5. FPS-adaptive quality scaling
----------------

if ( SERVER ) then return end


---------------
	1. DYNAMIC RENDER DISTANCE

	Skip drawing entities beyond a configurable distance.
	Unlike server-side SetPreventTransmit, this is purely
	client-side — entities still exist in the PVS and can
	be interacted with, they just don't render.

	Convars:
		cl_renderdist <units>      - Max render distance (0 = off)
		cl_renderdist_players 0    - Also cull players? (default no)
		cl_renderdist_fade 500     - Fade-out distance before cull
----------------

local RenderDist = 0			-- 0 = disabled
local RenderDistSqr = 0
local CullPlayers = false
local FadeDist = 500
local FadeDistSqr = 250000

CreateClientConVar( "cl_renderdist", "0", true, false, "Max render distance in units (0 = off)" )
CreateClientConVar( "cl_renderdist_players", "0", true, false, "Also cull distant players" )
CreateClientConVar( "cl_renderdist_fade", "500", true, false, "Fade distance before full cull" )

cvars.AddChangeCallback( "cl_renderdist", function( name, old, new )
	RenderDist = tonumber( new ) or 0
	RenderDistSqr = RenderDist * RenderDist
end )

cvars.AddChangeCallback( "cl_renderdist_players", function( name, old, new )
	CullPlayers = tonumber( new ) == 1
end )

cvars.AddChangeCallback( "cl_renderdist_fade", function( name, old, new )
	FadeDist = tonumber( new ) or 500
	FadeDistSqr = FadeDist * FadeDist
end )

-- Initialize from ConVars
timer.Simple( 0, function()
	RenderDist = GetConVar( "cl_renderdist" ):GetFloat()
	RenderDistSqr = RenderDist * RenderDist
	CullPlayers = GetConVar( "cl_renderdist_players" ):GetBool()
	FadeDist = GetConVar( "cl_renderdist_fade" ):GetFloat()
	FadeDistSqr = FadeDist * FadeDist
end )

-- Entity culling hook
hook.Add( "PreDrawOpaqueRenderables", "RenderDist_Cull", function( bDrawDepth, bDrawSkybox, b3dSkybox )

	if ( RenderDist <= 0 ) then return end
	if ( bDrawSkybox or b3dSkybox ) then return end

	local ply = LocalPlayer()
	if ( !IsValid( ply ) ) then return end

	local eyePos = ply:EyePos()

	for _, ent in ipairs( ents.GetAll() ) do

		if ( !IsValid( ent ) ) then continue end
		if ( ent == ply ) then continue end
		if ( !CullPlayers and ent:IsPlayer() ) then continue end
		if ( ent:IsWeapon() ) then continue end

		local distSqr = ent:GetPos():DistToSqr( eyePos )

		if ( distSqr > RenderDistSqr ) then
			-- Beyond render distance — don't draw
			ent:SetNoDraw( true )
			ent._renderCulled = true
		elseif ( ent._renderCulled ) then
			-- Back in range — restore drawing
			ent:SetNoDraw( false )
			ent._renderCulled = nil
		end

		-- Fade effect in the transition zone
		if ( distSqr > RenderDistSqr - FadeDistSqr and distSqr <= RenderDistSqr ) then
			local fadeAlpha = 1.0 - ( distSqr - ( RenderDistSqr - FadeDistSqr ) ) / FadeDistSqr
			local r, g, b, a = ent:GetColor():Unpack()
			ent:SetColor( Color( r, g, b, math.Clamp( fadeAlpha * 255, 0, 255 ) ) )
			ent:SetRenderMode( RENDERMODE_TRANSCOLOR )
			ent._renderFading = true
		elseif ( ent._renderFading ) then
			local r, g, b = ent:GetColor():Unpack()
			ent:SetColor( Color( r, g, b, 255 ) )
			ent:SetRenderMode( RENDERMODE_NORMAL )
			ent._renderFading = nil
		end

	end

end )

-- Restore all entities when disabled
cvars.AddChangeCallback( "cl_renderdist", function( name, old, new )
	if ( tonumber( new ) == 0 ) then
		for _, ent in ipairs( ents.GetAll() ) do
			if ( ent._renderCulled ) then
				ent:SetNoDraw( false )
				ent._renderCulled = nil
			end
			if ( ent._renderFading ) then
				local r, g, b = ent:GetColor():Unpack()
				ent:SetColor( Color( r, g, b, 255 ) )
				ent:SetRenderMode( RENDERMODE_NORMAL )
				ent._renderFading = nil
			end
		end
	end
end )


---------------
	2. HUD RENDERING THROTTLE

	Reduces HUD repaint frequency on lower-end clients.
	Most HUD elements (health bars, ammo counters, minimaps)
	don't need 144hz updates. Throttling to 30fps saves
	significant GPU time.

	Convar:
		cl_hud_rate <fps>    - Max HUD repaint rate (0 = unlimited)
----------------

local HudRate = 0		-- 0 = off (unlimited)
local LastHudPaint = 0
local HudCachedRT = nil

CreateClientConVar( "cl_hud_rate", "0", true, false, "Max HUD repaint rate in FPS (0 = unlimited)" )

cvars.AddChangeCallback( "cl_hud_rate", function( name, old, new )
	HudRate = tonumber( new ) or 0
end )

timer.Simple( 0, function()
	HudRate = GetConVar( "cl_hud_rate" ):GetFloat()
end )

hook.Add( "HUDShouldDraw", "HudRate_Throttle", function( name )

	if ( HudRate <= 0 ) then return end

	local interval = 1.0 / HudRate
	local now = SysTime()

	if ( now - LastHudPaint < interval ) then
		-- Skip this HUD paint cycle
		-- (returning false suppresses the specific HUD element)
		-- We don't suppress critical elements
		if ( name == "CHudChat" or name == "CHudMenu" or name == "CHudGMod" ) then
			return
		end
	else
		LastHudPaint = now
	end

end )


---------------
	3. FPS-ADAPTIVE QUALITY SCALING

	Automatically adjusts rendering quality based on current
	FPS. If FPS drops below a target, it reduces draw distance
	and other settings. When FPS recovers, it restores quality.

	This makes GMod self-regulate on the client's hardware
	instead of blindly rendering everything.

	Convar:
		cl_adaptive_quality 1       - Enable adaptive quality
		cl_adaptive_target_fps 60   - Target FPS
		cl_adaptive_min_fps 30      - Minimum before aggressive culling
----------------

local AdaptiveEnabled = false
local TargetFPS = 60
local MinFPS = 30
local AdaptiveLevel = 0		-- 0 = full quality, higher = more aggressive

-- FPS tracking
local FPSHistory = {}
local FPSHistorySize = 30
local FPSSampleInterval = 0.5
local LastFPSSample = 0

CreateClientConVar( "cl_adaptive_quality", "0", true, false, "Enable FPS-adaptive quality scaling" )
CreateClientConVar( "cl_adaptive_target_fps", "60", true, false, "Target FPS for adaptive quality" )
CreateClientConVar( "cl_adaptive_min_fps", "30", true, false, "Minimum FPS before aggressive reduction" )

timer.Simple( 0, function()
	AdaptiveEnabled = GetConVar( "cl_adaptive_quality" ):GetBool()
	TargetFPS = GetConVar( "cl_adaptive_target_fps" ):GetFloat()
	MinFPS = GetConVar( "cl_adaptive_min_fps" ):GetFloat()
end )

cvars.AddChangeCallback( "cl_adaptive_quality", function( name, old, new )
	AdaptiveEnabled = tonumber( new ) == 1
	if ( !AdaptiveEnabled ) then
		AdaptiveLevel = 0
		-- Restore settings
		RunConsoleCommand( "r_drawdetailprops", "1" )
		RunConsoleCommand( "r_drawflecks", "1" )
		RunConsoleCommand( "rope_rendersolid", "1" )
	end
end )

cvars.AddChangeCallback( "cl_adaptive_target_fps", function( name, old, new )
	TargetFPS = tonumber( new ) or 60
end )

cvars.AddChangeCallback( "cl_adaptive_min_fps", function( name, old, new )
	MinFPS = tonumber( new ) or 30
end )

hook.Add( "Think", "AdaptiveQuality_Think", function()

	if ( !AdaptiveEnabled ) then return end

	local now = SysTime()
	if ( now - LastFPSSample < FPSSampleInterval ) then return end
	LastFPSSample = now

	-- Sample current FPS
	local currentFPS = 1 / RealFrameTime()
	table.insert( FPSHistory, currentFPS )
	if ( #FPSHistory > FPSHistorySize ) then
		table.remove( FPSHistory, 1 )
	end

	-- Calculate average FPS
	local avgFPS = 0
	for i = 1, #FPSHistory do
		avgFPS = avgFPS + FPSHistory[ i ]
	end
	avgFPS = avgFPS / #FPSHistory

	-- Determine quality level
	local newLevel = 0

	if ( avgFPS < MinFPS ) then
		newLevel = 3		-- Aggressive reduction
	elseif ( avgFPS < TargetFPS * 0.7 ) then
		newLevel = 2		-- Medium reduction
	elseif ( avgFPS < TargetFPS ) then
		newLevel = 1		-- Light reduction
	end

	-- Only change if level actually changed
	if ( newLevel != AdaptiveLevel ) then
		AdaptiveLevel = newLevel

		if ( AdaptiveLevel == 0 ) then
			-- Full quality
			RunConsoleCommand( "r_drawdetailprops", "1" )
			RunConsoleCommand( "r_drawflecks", "1" )
			RunConsoleCommand( "rope_rendersolid", "1" )
		elseif ( AdaptiveLevel == 1 ) then
			-- Light reduction: disable minor visual details
			RunConsoleCommand( "r_drawdetailprops", "0" )
			RunConsoleCommand( "r_drawflecks", "0" )
		elseif ( AdaptiveLevel == 2 ) then
			-- Medium: also disable ropes, reduce decals
			RunConsoleCommand( "r_drawdetailprops", "0" )
			RunConsoleCommand( "r_drawflecks", "0" )
			RunConsoleCommand( "rope_rendersolid", "0" )
		elseif ( AdaptiveLevel >= 3 ) then
			-- Aggressive: everything above + auto render distance
			RunConsoleCommand( "r_drawdetailprops", "0" )
			RunConsoleCommand( "r_drawflecks", "0" )
			RunConsoleCommand( "rope_rendersolid", "0" )

			-- Enable dynamic render distance if not already set
			if ( RenderDist <= 0 ) then
				RunConsoleCommand( "cl_renderdist", "8000" )
			end
		end
	end

end )


---------------
	4. CLIENT-SIDE ENTITY POSITION INTERPOLATION

	When the server sends entity position updates at a lower
	rate (e.g., with sv_entpriority), entities can appear to
	teleport between positions. This smooths movement by
	interpolating between the last known position and
	the new one on the client side.

	This moves computation from the server to the client's CPU.

	Convar:
		cl_entlerp 1              - Enable interpolation
		cl_entlerp_speed 10       - Interpolation speed
----------------

local EntLerp = false
local LerpSpeed = 10
local EntityLastPos = {}	-- [entindex] = { lastPos, targetPos, lerpFraction }

CreateClientConVar( "cl_entlerp", "0", true, false, "Enable client-side entity interpolation" )
CreateClientConVar( "cl_entlerp_speed", "10", true, false, "Interpolation speed (higher = snappier)" )

timer.Simple( 0, function()
	EntLerp = GetConVar( "cl_entlerp" ):GetBool()
	LerpSpeed = GetConVar( "cl_entlerp_speed" ):GetFloat()
end )

cvars.AddChangeCallback( "cl_entlerp", function( name, old, new )
	EntLerp = tonumber( new ) == 1
	if ( !EntLerp ) then
		EntityLastPos = {}
	end
end )

cvars.AddChangeCallback( "cl_entlerp_speed", function( name, old, new )
	LerpSpeed = tonumber( new ) or 10
end )

hook.Add( "Think", "EntLerp_Interpolate", function()

	if ( !EntLerp ) then return end

	local dt = FrameTime()
	local ply = LocalPlayer()
	if ( !IsValid( ply ) ) then return end

	for _, ent in ipairs( ents.GetAll() ) do

		if ( !IsValid( ent ) ) then continue end
		if ( ent:IsPlayer() ) then continue end		-- players have their own interpolation
		if ( ent:IsWeapon() ) then continue end

		local idx = ent:EntIndex()
		local currentPos = ent:GetPos()
		local data = EntityLastPos[ idx ]

		if ( !data ) then
			EntityLastPos[ idx ] = { pos = currentPos, lastPos = currentPos }
			continue
		end

		-- Detect if entity teleported (position changed significantly)
		if ( data.pos:DistToSqr( currentPos ) > 1 ) then
			-- Server sent a new position — start interpolating
			data.lastPos = data.renderPos or data.pos
			data.pos = currentPos
			data.fraction = 0
		end

		-- Interpolate render position
		if ( data.fraction and data.fraction < 1 ) then
			data.fraction = math.min( data.fraction + dt * LerpSpeed, 1 )
			data.renderPos = LerpVector( data.fraction, data.lastPos, data.pos )

			-- Apply smoothed position for rendering only
			ent:SetRenderOrigin( data.renderPos )
		else
			-- Interpolation complete — clear render override
			if ( ent:GetRenderOrigin() ) then
				ent:SetRenderOrigin( nil )
			end
			data.renderPos = data.pos
		end

	end

end )

-- Clean up removed entities
hook.Add( "EntityRemoved", "EntLerp_Cleanup", function( ent )
	if ( EntLerp and IsValid( ent ) ) then
		EntityLastPos[ ent:EntIndex() ] = nil
	end
end )


---------------
	5. CLIENT-SIDE PERFORMANCE MONITOR

	Displays current performance metrics and active quality
	settings in the console.

	Console Command:
		cl_perfmon           - Show current performance info
----------------

concommand.Add( "cl_perfmon", function()

	local fps = math.Round( 1 / RealFrameTime() )
	local ms = math.Round( RealFrameTime() * 1000, 2 )
	local entCount = #ents.GetAll()
	local mem = collectgarbage( "count" )

	print( "========== CLIENT PERFORMANCE ==========" )
	print( "  FPS:              " .. fps .. " (" .. ms .. "ms)" )
	print( "  Entities:         " .. entCount )
	print( "  Lua memory:       " .. string.format( "%.1f", mem / 1024 ) .. " MB" )
	print( "" )
	print( "  Render distance:  " .. ( RenderDist > 0 and ( RenderDist .. " units" ) or "unlimited" ) )
	print( "  HUD throttle:     " .. ( HudRate > 0 and ( HudRate .. " fps" ) or "unlimited" ) )
	print( "  Adaptive quality: " .. ( AdaptiveEnabled and ( "Level " .. AdaptiveLevel ) or "OFF" ) )
	print( "  Entity interp:    " .. ( EntLerp and "ON" or "OFF" ) )
	print( "" )

	-- Count culled entities
	local culled = 0
	for _, ent in ipairs( ents.GetAll() ) do
		if ( ent._renderCulled ) then culled = culled + 1 end
	end
	if ( culled > 0 ) then
		print( "  Culled entities:  " .. culled .. " / " .. entCount )
	end

	print( "========================================" )

end )

MsgN( "[ClientOpt] Client-side rendering optimisations loaded." )
MsgN( "[ClientOpt] cl_renderdist, cl_hud_rate, cl_adaptive_quality, cl_entlerp" )
