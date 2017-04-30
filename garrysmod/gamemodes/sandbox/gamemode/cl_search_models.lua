
local totalCalls = 0
local expectedCalls = 1

local queuedSearch = {}

local function GetAllFiles( tab, folder, extension, path )

	totalCalls = totalCalls + 1

	local files, folders = file.Find( folder .. "*", path )

	if ( !files ) then
		MsgN( "Warning! Ignoring '" .. folder .. "' because we cannot search in it!"  )
		return
	end

	for k, v in pairs( files ) do

		if ( v:EndsWith( extension ) ) then
			table.insert( tab, ( folder .. v ):lower() )
		end

	end

	for k, v in pairs( folders ) do
		expectedCalls = expectedCalls + 1
		table.insert( queuedSearch, { tab, folder .. v .. "/", extension, path } )
	end

end

hook.Add( "Think", "sandbox_queued_search", function()
	if ( #queuedSearch < 1 ) then return end

	local call = queuedSearch[ 1 ]
	GetAllFiles( call[ 1 ], call[ 2 ], call[ 3 ], call[ 4 ] )
	table.remove( queuedSearch, 1 )

	if ( !timer.Exists( "search_models_update" ) || #queuedSearch < 1 ) then
		timer.Create( "search_models_update", 1, 1, function() hook.Run( "SearchUpdate" ) end )
	end
end )

hook.Add( "DrawOverlay","sandbox_search_progress", function()
	if ( !IsValid( g_SpawnMenu ) || !IsValid( g_SpawnMenu.SearchPropPanel ) || expectedCalls == 1 || totalCalls == expectedCalls ) then return end

	-- This code is bad
	--[[local pnl = g_SpawnMenu.SearchPropPanel
	local c = pnl:GetChildren()[1]:GetChildren()[1]:GetChildren()[1]
	if ( IsValid( c ) ) then
		c.OriginalText = c.OriginalText or c:GetText()
		c:SetText( c.OriginalText .. " ( Scanning: " .. math.ceil( totalCalls / expectedCalls * 100 ) .. "% )")
	end]]

	if ( !g_SpawnMenu:IsVisible() ) then return end

	local pnl = g_SpawnMenu.SearchPropPanel
	local x, y = pnl:LocalToScreen( 0, 0 )
	local maxw = pnl:GetWide()
	if ( pnl.VBar && pnl.VBar.Enabled ) then maxw = maxw - 20 end

	draw.RoundedBox( 0, x, y, maxw, 8, Color( 0, 0, 0, 200 ) )
	draw.RoundedBox( 0, x, y, maxw * ( totalCalls / expectedCalls ), 8, Color( 0, 128, 255, 200 ) )
end )

local model_list = nil
--
-- Model Search
--
search.AddProvider( function( str )

	str = str:PatternSafe()

	if ( model_list == nil ) then

		model_list = {}
		GetAllFiles( model_list, "models/", ".mdl", "GAME" )

	end

	local list = {}

	for k, v in pairs( model_list ) do

		if ( v:find( str ) ) then

			if ( IsUselessModel( v ) ) then continue end

			local entry = {
				text = v:GetFileFromFilename(),
				func = function() RunConsoleCommand( "gm_spawn", v ) end,
				icon = spawnmenu.CreateContentIcon( "model", g_SpawnMenu.SearchPropPanel, { model = v } ),
				words = { v }
			}

			table.insert( list, entry )

		end

		if ( #list >= 256 ) then break end

	end

	return list

end, "props" )

--
-- Entity, vehicles
--
search.AddProvider( function( str )

	str = str:PatternSafe()

	local results = {}

	local entities = {}

	//for k, v in pairs( scripted_ents.GetSpawnable() ) do
	for k, v in pairs( list.Get( "SpawnableEntities" ) ) do
		v.ClassName = k
		v.ScriptedEntityType = "entity"
		table.insert( entities, v )
	end

	for k, v in pairs( list.Get( "Vehicles" ) ) do
		v.ClassName = k
		v.PrintName = v.Name
		v.ScriptedEntityType = "vehicle"
		table.insert( entities, v )
	end

	for k, v in pairs( list.Get( "NPC" ) ) do
		v.ClassName = k
		v.PrintName = v.Name
		v.ScriptedEntityType = "npc"
		table.insert( entities, v )
	end

	for k, v in pairs( list.Get( "Weapon" ) ) do
		v.ClassName = k
		v.ScriptedEntityType = "weapon"
		table.insert( entities, v )
	end

	for k, v in pairs( entities ) do

		local name = v.ClassName or v.PrintName
		if ( !name ) then continue end

		if ( name:lower():find( str ) ) then -- TODO: Search print name AND class name?

			local entry = {
				text = v.PrintName or v.ClassName,
				icon = spawnmenu.CreateContentIcon( v.ScriptedEntityType or "entity", nil, {
					nicename = v.PrintName or v.ClassName,
					spawnname = v.ClassName,
					material = "entities/" .. v.ClassName .. ".png",

					admin = v.AdminOnly
				} ),
				words = { v }
			}

			table.insert( results, entry )

		end

		if ( #results >= 128 ) then break end

	end

	return results

end, "entities" )
