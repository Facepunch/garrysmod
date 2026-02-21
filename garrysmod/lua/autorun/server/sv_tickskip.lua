---------------
	DECOUPLED LUA THINK RATE

	Allows physics/networking to run at full server tickrate
	while heavy Lua hooks (Think, PlayerTick, Tick) execute
	at a lower frequency to reduce CPU load.

	This is the #1 requested feature for RP servers stuck at
	16 tick because Lua eats all the frame budget.

	Convars:
		sv_lua_thinkskip <n>   - Only run Think hooks every Nth tick (default 1 = every tick)
		sv_lua_tickskip <n>    - Only run Tick hooks every Nth tick (default 1)
		sv_lua_playerthinkskip <n> - PlayerTick frequency divisor (default 1)
		sv_tickskip_info       - Print current skip settings

	Example for a 33-tick server that can't handle 33-tick Lua:
		sv_lua_thinkskip 2     - Think hooks run at 16.5 effective tick
		sv_lua_playerthinkskip 2

	The engine's physics, networking, and entity updates still
	run at the full tickrate. Only Lua hook execution is throttled.
----------------

if ( !SERVER ) then return end

local SysTime = SysTime
local hook_GetTable = hook.GetTable

-- Skip counters
local ThinkSkip = 1
local TickSkip = 1
local PlayerThinkSkip = 1

-- Tick tracking
local TickCount = 0

-- ConVars
concommand.Add( "sv_lua_thinkskip", function( ply, cmd, args )
	if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end
	local val = tonumber( args[ 1 ] )
	if ( !val ) then
		print( "[TickSkip] sv_lua_thinkskip = " .. ThinkSkip )
		return
	end
	ThinkSkip = math.Clamp( math.floor( val ), 1, 16 )
	print( "[TickSkip] Think hooks now fire every " .. ThinkSkip .. " tick(s)" )
end )

concommand.Add( "sv_lua_tickskip", function( ply, cmd, args )
	if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end
	local val = tonumber( args[ 1 ] )
	if ( !val ) then
		print( "[TickSkip] sv_lua_tickskip = " .. TickSkip )
		return
	end
	TickSkip = math.Clamp( math.floor( val ), 1, 16 )
	print( "[TickSkip] Tick hooks now fire every " .. TickSkip .. " tick(s)" )
end )

concommand.Add( "sv_lua_playerthinkskip", function( ply, cmd, args )
	if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end
	local val = tonumber( args[ 1 ] )
	if ( !val ) then
		print( "[TickSkip] sv_lua_playerthinkskip = " .. PlayerThinkSkip )
		return
	end
	PlayerThinkSkip = math.Clamp( math.floor( val ), 1, 16 )
	print( "[TickSkip] PlayerTick hooks now fire every " .. PlayerThinkSkip .. " tick(s)" )
end )

concommand.Add( "sv_tickskip_info", function( ply, cmd, args )
	if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end
	print( "========== TICK SKIP INFO ==========" )
	print( "  Think skip:       " .. ThinkSkip .. " (fires every " .. ThinkSkip .. " ticks)" )
	print( "  Tick skip:        " .. TickSkip .. " (fires every " .. TickSkip .. " ticks)" )
	print( "  PlayerTick skip:  " .. PlayerThinkSkip .. " (fires every " .. PlayerThinkSkip .. " ticks)" )
	print( "  Current tick:     " .. TickCount )
	print( "" )
	print( "  Server tickrate:  " .. math.Round( 1 / engine.TickInterval() ) )
	print( "  Effective Think:  " .. math.Round( ( 1 / engine.TickInterval() ) / ThinkSkip, 1 ) .. " hz" )
	print( "  Effective Tick:   " .. math.Round( ( 1 / engine.TickInterval() ) / TickSkip, 1 ) .. " hz" )
	print( "====================================" )
end )


---------------
	Core mechanism: intercept Think/Tick/PlayerTick and skip
	execution on non-matching ticks.

	We use a pre-hook that returns non-nil to suppress the
	event on skipped ticks. This is lightweight because it
	only runs once per event per tick, not once per hook.
----------------

-- Store original hook.Call so we can wrap it
local OriginalHookCall = hook.Call

-- Override hook.Call to intercept specific events
function hook.Call( name, gm, ... )

	TickCount = TickCount + 1

	-- Check if this event should be skipped this tick
	if ( name == "Think" and ThinkSkip > 1 ) then
		if ( TickCount % ThinkSkip != 0 ) then
			-- Still call gamemode function but skip addon hooks
			if ( gm and gm[ name ] ) then
				return gm[ name ]( gm, ... )
			end
			return
		end
	elseif ( name == "Tick" and TickSkip > 1 ) then
		if ( TickCount % TickSkip != 0 ) then
			if ( gm and gm[ name ] ) then
				return gm[ name ]( gm, ... )
			end
			return
		end
	elseif ( name == "PlayerTick" and PlayerThinkSkip > 1 ) then
		if ( TickCount % PlayerThinkSkip != 0 ) then
			if ( gm and gm[ name ] ) then
				return gm[ name ]( gm, ... )
			end
			return
		end
	end

	return OriginalHookCall( name, gm, ... )

end

MsgN( "[TickSkip] Loaded. Use sv_tickskip_info for current settings." )
