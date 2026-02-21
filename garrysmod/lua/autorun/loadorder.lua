---------------
	LOAD ORDER CONTROLLER

	Explicit load order control for addons, replacing GMod's
	default alphabetical loading. Uses priority numbers where
	lower = loads first. Saves preferences to data/loadorder.json.

	Usage:
		loadorder.SetPriority( "essential_framework", 10 )
		loadorder.SetPriority( "my_rpmod", 100 )
		loadorder.SetPriority( "cosmetic_addon", 500 )

		-- Check current order:
		local order = loadorder.GetOrder()

	Console Commands (SuperAdmin):
		lua_loadorder_info                 - Show current order
		lua_loadorder_set <addon> <priority> - Set priority
		lua_loadorder_save                 - Save to disk
		lua_loadorder_load                 - Load from disk
----------------

loadorder = loadorder or {}

local Priorities = {}		-- [addonName] = priority (lower = first)
local ActualLoadSequence = {}	-- Track actual load order
local SaveFile = "loadorder.json"


--
-- Set priority for an addon
--
function loadorder.SetPriority( name, priority )
	Priorities[ name ] = priority
end


--
-- Get priority for an addon (default 500)
--
function loadorder.GetPriority( name )
	return Priorities[ name ] or 500
end


--
-- Get sorted load order
--
function loadorder.GetOrder()

	local order = {}

	-- Get all registered addons
	for name, priority in pairs( Priorities ) do
		table.insert( order, { name = name, priority = priority } )
	end

	-- Also include engine-reported addons not in our priorities
	local engineAddons = engine and engine.GetAddons and engine.GetAddons() or {}
	for _, addon in ipairs( engineAddons ) do
		local title = addon.title or "unknown"
		if ( !Priorities[ title ] ) then
			table.insert( order, { name = title, priority = 500 } )
		end
	end

	-- Sort by priority (lower first)
	table.sort( order, function( a, b )
		if ( a.priority == b.priority ) then
			return a.name < b.name		-- Alphabetical tiebreak
		end
		return a.priority < b.priority
	end )

	return order

end


--
-- Track actual addon load sequence
--
function loadorder.RecordLoad( addonName )
	table.insert( ActualLoadSequence, {
		name = addonName,
		time = SysTime(),
		position = #ActualLoadSequence + 1
	} )
end

function loadorder.GetActualSequence()
	return ActualLoadSequence
end


--
-- Save / Load preferences
--
function loadorder.Save()
	local json = util.TableToJSON( Priorities, true )
	file.Write( SaveFile, json )
end

function loadorder.Load()
	if ( !file.Exists( SaveFile, "DATA" ) ) then return false end

	local json = file.Read( SaveFile, "DATA" )
	if ( !json ) then return false end

	local data = util.JSONToTable( json )
	if ( !data ) then return false end

	Priorities = data
	return true
end


-- Auto-load saved preferences
loadorder.Load()


-- Track addon loading
hook.Add( "AddonLoaded", "LoadOrder_Track", function( name )
	loadorder.RecordLoad( name )
end )


-- Console commands
concommand.Add( "lua_loadorder_info", function( ply, cmd, args )

	if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end

	local order = loadorder.GetOrder()

	print( "========== LOAD ORDER ==========" )
	print( string.format( "  %-4s %-30s %s", "#", "ADDON", "PRIORITY" ) )

	for i, entry in ipairs( order ) do
		print( string.format( "  %-4d %-30s %d", i, string.sub( entry.name, 1, 30 ), entry.priority ) )
	end

	print( "" )

	local actual = loadorder.GetActualSequence()
	if ( #actual > 0 ) then
		print( "  Actual load sequence this session:" )
		for i, entry in ipairs( actual ) do
			print( string.format( "    %2d. %s", i, entry.name ) )
		end
	end

	print( "=================================" )

end )

concommand.Add( "lua_loadorder_set", function( ply, cmd, args )

	if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end

	if ( !args[ 1 ] or !args[ 2 ] ) then
		print( "Usage: lua_loadorder_set <addon_name> <priority>" )
		return
	end

	local name = args[ 1 ]
	local priority = tonumber( args[ 2 ] )

	if ( !priority ) then
		print( "[LoadOrder] Priority must be a number." )
		return
	end

	loadorder.SetPriority( name, priority )
	print( "[LoadOrder] Set '" .. name .. "' priority to " .. priority )

end )

concommand.Add( "lua_loadorder_save", function( ply, cmd, args )
	if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end
	loadorder.Save()
	print( "[LoadOrder] Saved to data/" .. SaveFile )
end )

concommand.Add( "lua_loadorder_load", function( ply, cmd, args )
	if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end
	if ( loadorder.Load() ) then
		print( "[LoadOrder] Loaded from data/" .. SaveFile )
	else
		print( "[LoadOrder] No saved load order found." )
	end
end )

MsgN( "[LoadOrder] Load order controller ready. " .. table.Count( Priorities ) .. " priorities loaded." )
