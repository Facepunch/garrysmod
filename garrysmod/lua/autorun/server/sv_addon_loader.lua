---------------
	SMART ADDON LOADER

	Manages addon loading with dependency resolution,
	conflict detection, and load timing.

	Usage:
		-- Register an addon with dependencies:
		addonloader.Register( "my_addon", {
			depends = { "base_framework", "data_lib" },
			priority = 100,
			version = "1.2.0"
		} )

		-- Load all registered addons in dependency order:
		addonloader.LoadAll()

		-- Or just resolve the order:
		local order = addonloader.ResolveOrder()

	Console Commands (SuperAdmin):
		lua_addon_loadorder    - Show resolved load order
		lua_addon_conflicts    - Show detected conflicts
		lua_addon_timing       - Show load times
----------------

if ( !SERVER ) then return end

addonloader = addonloader or {}

local Registry = {}		-- [name] = { depends, priority, version, file, loaded }
local LoadOrder = {}	-- Resolved topological order
local LoadTimes = {}	-- [name] = seconds
local Conflicts = {}	-- [{ addon1, addon2, type, detail }]
local HookRegistry = {}	-- [event][hookName] = addonName


--
-- Register an addon
--
function addonloader.Register( name, opts )

	opts = opts or {}

	Registry[ name ] = {
		name = name,
		depends = opts.depends or {},
		priority = opts.priority or 500,
		version = opts.version or "1.0.0",
		file = opts.file or nil,
		loaded = false
	}

end


--
-- Topological sort for dependency resolution
--
function addonloader.ResolveOrder()

	local visited = {}
	local visiting = {}
	local order = {}

	local function visit( name )

		if ( visiting[ name ] ) then
			print( "[AddonLoader] WARNING: Circular dependency detected involving '" .. name .. "'" )
			return false
		end

		if ( visited[ name ] ) then return true end

		visiting[ name ] = true

		local addon = Registry[ name ]
		if ( addon ) then
			for _, dep in ipairs( addon.depends ) do
				if ( !Registry[ dep ] ) then
					print( "[AddonLoader] WARNING: '" .. name .. "' depends on '" .. dep .. "' which is not registered" )
				else
					if ( !visit( dep ) ) then return false end
				end
			end
		end

		visiting[ name ] = nil
		visited[ name ] = true
		table.insert( order, name )
		return true

	end

	-- Sort by priority first, then resolve dependencies
	local sorted = {}
	for name, _ in pairs( Registry ) do
		table.insert( sorted, name )
	end
	table.sort( sorted, function( a, b )
		return ( Registry[ a ].priority or 500 ) < ( Registry[ b ].priority or 500 )
	end )

	for _, name in ipairs( sorted ) do
		visit( name )
	end

	LoadOrder = order
	return order

end


--
-- Detect conflicts (two addons registering same hook name)
--
function addonloader.DetectConflicts()

	Conflicts = {}

	-- Check for duplicate hook registrations
	local hookTable = hook.GetTable()
	local hookOwners = {}

	for event, hooks in pairs( hookTable ) do
		for hookName, _ in pairs( hooks ) do
			local key = event .. ":" .. tostring( hookName )

			if ( hookOwners[ key ] ) then
				table.insert( Conflicts, {
					type = "hook_override",
					detail = "Hook '" .. tostring( hookName ) .. "' on event '" .. event .. "'",
					addon1 = hookOwners[ key ],
					addon2 = "unknown"
				} )
			end

			hookOwners[ key ] = tostring( hookName )
		end
	end

	-- Check for duplicate concommands
	-- (We can only detect this if addons register through us)

	return Conflicts

end


--
-- Load a single registered addon
--
function addonloader.Load( name )

	local addon = Registry[ name ]
	if ( !addon ) then
		print( "[AddonLoader] Addon not registered: " .. name )
		return false
	end

	if ( addon.loaded ) then return true end

	-- Load dependencies first
	for _, dep in ipairs( addon.depends ) do
		if ( !addonloader.Load( dep ) ) then
			print( "[AddonLoader] Failed to load dependency '" .. dep .. "' for '" .. name .. "'" )
			return false
		end
	end

	-- Load the addon
	local startTime = SysTime()

	if ( addon.file ) then
		local ok, err = pcall( include, addon.file )
		if ( !ok ) then
			print( "[AddonLoader] Error loading '" .. name .. "': " .. tostring( err ) )
			return false
		end
	end

	local loadTime = SysTime() - startTime
	LoadTimes[ name ] = loadTime
	addon.loaded = true

	return true

end


--
-- Load all in resolved order
--
function addonloader.LoadAll()

	local order = addonloader.ResolveOrder()

	for _, name in ipairs( order ) do
		addonloader.Load( name )
	end

	return order

end


--
-- Get info
--
function addonloader.GetRegistry()
	return Registry
end

function addonloader.GetLoadOrder()
	return LoadOrder
end

function addonloader.GetLoadTimes()
	return LoadTimes
end


-- Console commands
concommand.Add( "lua_addon_loadorder", function( ply, cmd, args )

	if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end

	local order = addonloader.ResolveOrder()

	print( "========== ADDON LOAD ORDER ==========" )
	for i, name in ipairs( order ) do
		local addon = Registry[ name ]
		local deps = #addon.depends > 0 and table.concat( addon.depends, ", " ) or "none"
		local status = addon.loaded and "LOADED" or "PENDING"
		print( string.format( "  %2d. [%s] %-20s (priority: %d, deps: %s)",
			i, status, name, addon.priority, deps ) )
	end
	print( "  Total: " .. #order .. " addons registered" )
	print( "=======================================" )

end )

concommand.Add( "lua_addon_conflicts", function( ply, cmd, args )

	if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end

	local conflicts = addonloader.DetectConflicts()

	print( "========== ADDON CONFLICTS ==========" )
	if ( #conflicts == 0 ) then
		print( "  No conflicts detected." )
	else
		for _, c in ipairs( conflicts ) do
			print( string.format( "  [%s] %s", c.type, c.detail ) )
		end
	end
	print( "=====================================" )

end )

concommand.Add( "lua_addon_timing", function( ply, cmd, args )

	if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end

	print( "========== ADDON LOAD TIMES ==========" )

	local sorted = {}
	for name, time in pairs( LoadTimes ) do
		table.insert( sorted, { name = name, time = time } )
	end
	table.sort( sorted, function( a, b ) return a.time > b.time end )

	local total = 0
	for _, entry in ipairs( sorted ) do
		print( string.format( "  %-25s %.3f ms", entry.name, entry.time * 1000 ) )
		total = total + entry.time
	end

	print( string.format( "  Total: %.3f ms", total * 1000 ) )
	print( "======================================" )

end )

MsgN( "[AddonLoader] Smart addon loader ready." )
