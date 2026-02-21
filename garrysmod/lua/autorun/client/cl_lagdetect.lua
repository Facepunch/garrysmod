---------------
	SERVER LAG DETECTOR (inspired by sups_performance)

	Client-side server health monitoring. Watches tickrate
	and alerts in console when the server is struggling,
	with diagnostic reasons (entity count, player count,
	Lua execution, network saturation).

	ConVars:
		cl_lagdetect 1            - Enable lag detection
		cl_lagdetect_threshold 15 - Tickrate drop % to alert
		cl_lagdetect_cooldown 10  - Seconds between alerts

	Console Commands:
		lua_lagcheck              - Manual server health check
----------------

if ( SERVER ) then return end

local cv_enable = CreateClientConVar( "cl_lagdetect", "1", true, false, "Enable server lag detection" )
local cv_threshold = CreateClientConVar( "cl_lagdetect_threshold", "15", true, false, "Tickrate drop % to trigger alert", 5, 50 )
local cv_cooldown = CreateClientConVar( "cl_lagdetect_cooldown", "10", true, false, "Seconds between alerts", 5, 120 )

local expectedTick = 0
local tickSmooth = 0
local lastAlertTime = 0
local wasLagging = false
local lagStartTime = 0
local entityHistory = {}


---------------
	SEVERITY LEVELS
----------------

local SEVERITY = {
	{ threshold = 50, name = "CRITICAL",  icon = "!!!" },
	{ threshold = 30, name = "SEVERE",    icon = "!! " },
	{ threshold = 15, name = "MODERATE",  icon = "!  " },
	{ threshold = 5,  name = "MINOR",     icon = ".  " },
}

local function GetSeverity( dropPercent )
	for _, sev in ipairs( SEVERITY ) do
		if ( dropPercent >= sev.threshold ) then return sev end
	end
	return SEVERITY[ #SEVERITY ]
end


---------------
	DIAGNOSTIC REASONS
----------------

local function GetReasons( currentTick, entityCount, playerCount )

	local reasons = {}
	local drop = math.Round( ( ( expectedTick - currentTick ) / expectedTick ) * 100 )

	if ( entityCount > 3000 ) then
		table.insert( reasons, "Very high entity count (" .. entityCount .. ") - cleanup needed" )
	elseif ( entityCount > 2000 ) then
		table.insert( reasons, "High entity count (" .. entityCount .. ") - may cause tick drops" )
	end

	-- Check for entity spikes
	if ( #entityHistory >= 3 ) then
		local avg = 0
		for _, v in ipairs( entityHistory ) do avg = avg + v end
		avg = avg / #entityHistory
		if ( entityCount > avg * 1.3 ) then
			table.insert( reasons, "Entity spike +" .. math.Round( entityCount - avg ) .. " (sudden spawns/dupes)" )
		end
	end

	if ( playerCount > 80 ) then
		table.insert( reasons, "Very high player count (" .. playerCount .. ") - networking overhead" )
	elseif ( playerCount > 50 ) then
		table.insert( reasons, "High player count (" .. playerCount .. ")" )
	end

	if ( drop > 40 ) then
		table.insert( reasons, "Severe tick drop (" .. drop .. "%) - heavy Lua execution likely" )
	end

	if ( drop > 20 and playerCount > 40 ) then
		table.insert( reasons, "Network bandwidth saturation likely" )
	end

	if ( #reasons == 0 ) then
		table.insert( reasons, "General server load (tick dropped " .. drop .. "%)" )
	end

	return reasons

end


---------------
	MAIN CHECK LOOP
----------------

local nextCheck = 0

hook.Add( "Think", "LagDetect_Monitor", function()

	if ( !cv_enable:GetBool() ) then return end

	local now = CurTime()
	if ( now < nextCheck ) then return end
	nextCheck = now + 1

	local rawTick = 1 / engine.TickInterval()

	if ( expectedTick == 0 ) then
		expectedTick = math.Round( rawTick )
		tickSmooth = rawTick
		return
	end

	tickSmooth = tickSmooth + ( rawTick - tickSmooth ) * 0.2
	local currentTick = math.Round( tickSmooth )
	local dropPercent = math.max( 0, ( ( expectedTick - currentTick ) / expectedTick ) * 100 )

	local entityCount = #ents.GetAll()
	local playerCount = #player.GetAll()

	table.insert( entityHistory, entityCount )
	if ( #entityHistory > 10 ) then table.remove( entityHistory, 1 ) end

	if ( dropPercent >= cv_threshold:GetFloat() ) then
		if ( !wasLagging ) then
			wasLagging = true
			lagStartTime = now
		end

		if ( now - lastAlertTime >= cv_cooldown:GetFloat() ) then
			lastAlertTime = now
			local sev = GetSeverity( dropPercent )
			local reasons = GetReasons( currentTick, entityCount, playerCount )

			print( "" )
			print( "[Lag Detector] " .. sev.icon .. " " .. sev.name .. " SERVER LAG DETECTED" )
			print( string.format( "  Tickrate: %d / %d (-%d%%)", currentTick, expectedTick, math.Round( dropPercent ) ) )
			print( string.format( "  Entities: %d | Players: %d", entityCount, playerCount ) )

			for _, reason in ipairs( reasons ) do
				print( "  > " .. reason )
			end

			print( "" )
		end
	else
		if ( wasLagging ) then
			local duration = math.Round( now - lagStartTime, 1 )
			if ( duration > 2 ) then
				print( "[Lag Detector] Server recovered (lag lasted " .. duration .. "s)" )
			end
			wasLagging = false
		end
	end

end )


-- Reset on map change
hook.Add( "InitPostEntity", "LagDetect_Reset", function()
	expectedTick = 0
	tickSmooth = 0
	wasLagging = false
	entityHistory = {}
	lastAlertTime = 0
end )


-- Manual check
concommand.Add( "lua_lagcheck", function()

	local currentTick = math.Round( 1 / engine.TickInterval() )
	local entityCount = #ents.GetAll()
	local playerCount = #player.GetAll()
	local lp = LocalPlayer()
	local ping = IsValid( lp ) and lp:Ping() or 0

	print( "" )
	print( "========== SERVER HEALTH CHECK ==========" )
	print( string.format( "  Tickrate:    %d (expected: %d)", currentTick, expectedTick > 0 and expectedTick or currentTick ) )
	print( string.format( "  Your Ping:   %d ms", ping ) )
	print( string.format( "  Entities:    %d", entityCount ) )
	print( string.format( "  Players:     %d", playerCount ) )
	print( string.format( "  Lua Memory:  %.1f MB", collectgarbage( "count" ) / 1024 ) )
	print( string.format( "  Status:      %s", wasLagging and "LAGGING" or "HEALTHY" ) )
	print( "==========================================" )
	print( "" )

end )

MsgN( "[LagDetect] Server lag detection loaded." )
