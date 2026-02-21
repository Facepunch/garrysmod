---------------
	UNUSED HOOK CLEANUP (Inspired by a local performance addon i've been progressivley working on over last couple months)

	Removes default GMod hooks that run every frame but are
	rarely used in normal gameplay: DOF, widgets, frameblend.

	Also suspends Wire debug/overlay hooks when the player
	isn't actively using a Wire tool, and restores them
	when a Wire tool is equipped.

	ConVars:
		cl_hookcleanup 1      - Enable hook cleanup
		cl_wirecleanup 1      - Suspend Wire hooks when not using Wire

	Console Commands:
		lua_hookcleanup_info  - Show removed/suspended hooks
----------------

if ( SERVER ) then return end

CreateClientConVar( "cl_hookcleanup", "1", true, false, "Remove unused engine hooks (DOF, widgets)" )
CreateClientConVar( "cl_wirecleanup", "1", true, false, "Suspend Wire debug hooks when not using Wire" )


---------------
	UNUSED ENGINE HOOKS
----------------

local ENGINE_HOOKS = {
	{ "RenderScreenspaceEffects", "RenderBokeh" },
	{ "PreventScreenClicks",     "SuperDOFPreventClicks" },
	{ "Think",                   "DOFThink" },
	{ "NeedsDepthPass",          "NeedsDepthPass_Bokeh" },
	{ "PreRender",               "PreRenderFrameBlend" },
	{ "RenderScene",             "RenderFrameBlend" },
	{ "RenderScreenspaceEffects", "RenderWidgets" },
	{ "PlayerTick",               "TickWidgets" },
}

local EngineRemoved = 0


hook.Add( "InitPostEntity", "HookCleanup_Engine", function()

	if ( !GetConVar( "cl_hookcleanup" ):GetBool() ) then return end

	timer.Simple( 2, function()

		if ( !GetConVar( "cl_hookcleanup" ):GetBool() ) then return end

		local hookTable = hook.GetTable()

		for _, data in ipairs( ENGINE_HOOKS ) do
			if ( hookTable[ data[ 1 ] ] and hookTable[ data[ 1 ] ][ data[ 2 ] ] ) then
				hook.Remove( data[ 1 ], data[ 2 ] )
				EngineRemoved = EngineRemoved + 1
			end
		end

		if ( EngineRemoved > 0 ) then
			MsgN( "[HookCleanup] Removed " .. EngineRemoved .. " unused engine hooks (DOF, widgets, frameblend)" )
		end

	end )

end )


---------------
	WIRE HOOK SUSPENSION
----------------

local WIRE_HOOKS = {
	{ "Think",           "Wire.WireScroll" },
	{ "Think",           "WireMapInterface_Think" },
	{ "Think",           "wire_base_lookedatbylocalplayer" },
	{ "HUDPaint",        "wire_hud_debug" },
	{ "HUDPaint",        "wire_ports_test" },
	{ "HUDPaint",        "wire_draw_world_tips" },
	{ "HUDPaint",        "Wire_DataSocket_DrawLinkHelperLine" },
	{ "HUDPaint",        "Wire_Socket_DrawLinkHelperLine" },
	{ "HUDPaint",        "wire_trigger_draw_all_triggers" },
}

local WireBackup = {}		-- saved hook funcs for restoration
local WireSuspended = false

local function IsUsingWireTool()

	local lp = LocalPlayer()
	if ( !IsValid( lp ) ) then return false end

	local wep = lp:GetActiveWeapon()
	if ( !IsValid( wep ) ) then return false end
	if ( wep:GetClass() != "gmod_tool" ) then return false end

	local tool = lp:GetInfo( "gmod_toolmode" ) or ""
	return string.StartWith( tool, "wire" ) or tool == "advdupe2"

end

local function SuspendWireHooks()

	if ( WireSuspended ) then return end

	local count = 0
	local hookTable = hook.GetTable()

	for _, data in ipairs( WIRE_HOOKS ) do
		if ( hookTable[ data[ 1 ] ] and hookTable[ data[ 1 ] ][ data[ 2 ] ] ) then
			WireBackup[ data[ 1 ] .. "|" .. data[ 2 ] ] = hookTable[ data[ 1 ] ][ data[ 2 ] ]
			hook.Remove( data[ 1 ], data[ 2 ] )
			count = count + 1
		end
	end

	if ( count > 0 ) then
		WireSuspended = true
	end

end

local function RestoreWireHooks()

	if ( !WireSuspended ) then return end

	for key, func in pairs( WireBackup ) do
		local parts = string.Split( key, "|" )
		hook.Add( parts[ 1 ], parts[ 2 ], func )
	end

	WireBackup = {}
	WireSuspended = false

end


-- Wire check loop
local wireNextCheck = 0

hook.Add( "Think", "WireCleanup_Tick", function()

	if ( !GetConVar( "cl_wirecleanup" ):GetBool() ) then
		if ( WireSuspended ) then RestoreWireHooks() end
		return
	end

	local now = CurTime()
	if ( now < wireNextCheck ) then return end
	wireNextCheck = now + 1

	if ( IsUsingWireTool() ) then
		if ( WireSuspended ) then RestoreWireHooks() end
	else
		if ( !WireSuspended ) then SuspendWireHooks() end
	end

end )


-- Initial suspend after all addons load
hook.Add( "InitPostEntity", "WireCleanup_Init", function()
	timer.Simple( 5, function()
		if ( GetConVar( "cl_wirecleanup" ):GetBool() and !IsUsingWireTool() ) then
			SuspendWireHooks()
		end
	end )
end )


-- Restore on shutdown
hook.Add( "ShutDown", "WireCleanup_Restore", function()
	if ( WireSuspended ) then RestoreWireHooks() end
end )


-- Info command
concommand.Add( "lua_hookcleanup_info", function()

	print( "========== HOOK CLEANUP ==========" )
	print( string.format( "  Engine hooks removed: %d", EngineRemoved ) )
	print( string.format( "  Wire hooks suspended: %s", WireSuspended and "yes" or "no" ) )
	print( string.format( "  Wire backup count:    %d", table.Count( WireBackup ) ) )
	print( "===================================" )

end )

MsgN( "[HookCleanup] Hook cleanup loaded." )
