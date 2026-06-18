
local sbox_search_maxresults = CreateClientConVar( "sbox_search_maxresults", "1024", true, false, "The maximum amount of results the spawnmenu search should show. Model amount limited to 1/2 of this value, entities are limited to 1/4", 1024 )

local totalCalls = 0
local expectedCalls = 1

local queuedSearch = {}

local function GetAllFiles( tab, folder, extension, path )

	totalCalls = totalCalls + 1

	local files, folders = file.Find( folder .. "*", path )

	if ( !files ) then
		MsgN( "Warning! Ignoring '" .. folder .. "' because we cannot search in it!" )
		return
	end

	for k, v in ipairs( files ) do

		if ( v:EndsWith( extension ) ) then
			table.insert( tab, ( folder .. v ):lower() )
		end

	end

	for k, v in ipairs( folders ) do
		expectedCalls = expectedCalls + 1
		table.insert( queuedSearch, { tab, folder .. v .. "/", extension, path } )
	end

	notification.AddProgress( "SandboxSearchIndexing", "#spawnmenu.searchindex", totalCalls / expectedCalls )
	if ( totalCalls >= expectedCalls ) then notification.Kill( "SandboxSearchIndexing" ) end

end

hook.Add( "Think", "sandbox_queued_search", function()

	if ( #queuedSearch < 1 ) then return end

	local call = queuedSearch[ 1 ]
	GetAllFiles( unpack( call ) )
	table.remove( queuedSearch, 1 )

	if ( !timer.Exists( "search_models_update" ) or #queuedSearch < 1 ) then
		timer.Create( "search_models_update", 1, 1, function() hook.Run( "SearchUpdate" ) end )
	end

end )

--
-- Model Search
--
local model_list = nil
search.AddProvider( function( str )

	if ( model_list == nil ) then

		model_list = {}
		GetAllFiles( model_list, "models/", ".mdl", "GAME" )

	end

	local models = {}

	for k, v in ipairs( model_list ) do

		-- Don't search in the models/ and .mdl bit of every model, because every model has this bit, unless they are looking for direct model path
		local modelpath = v
		if ( modelpath:StartsWith( "models/" ) and modelpath:EndsWith( ".mdl" ) and !str:EndsWith( ".mdl" ) ) then modelpath = modelpath:sub( 8, modelpath:len() - 4 ) end

		if ( modelpath:find( str, nil, true ) ) then

			if ( IsUselessModel( v ) ) then continue end

			local entry = {
				text = v:GetFileFromFilename(),
				func = function() RunConsoleCommand( "gm_spawn", v ) end,
				icon = spawnmenu.CreateContentIcon( "model", g_SpawnMenu.SearchPropPanel, { model = v } ),
				words = { v }
			}

			table.insert( models, entry )

		end

		if ( #models >= sbox_search_maxresults:GetInt() / 2 ) then break end

	end

	return models

end, "props" )

hook.Add( "GameContentChanged", "ResetModelSearchCache", function()

	-- Addons got remounted, reset the model search cache
	model_list = nil

	-- Reset any ongoing search process
	totalCalls = 0
	expectedCalls = 1
	queuedSearch = {}

end )


--
-- Entity, vehicles
--
local function AddSearchProvider( listname, ctype, stype )
	search.AddProvider( function( str )

		local results = {}
		for name_c, v in pairs( list.Get( listname ) ) do
			if ( !istable( v ) ) then continue end -- Some mod doing something wrong
			if ( listname == "Weapon" and !v.Spawnable ) then continue end

			local name = v.PrintName or v.Name
			local name_language = language.GetPhrase( name )
			if ( !isstring( name ) and !isstring( name_c ) ) then continue end

			if ( ( isstring( name_language ) and name_language:lower():find( str, nil, true ) ) or ( isstring( name_c ) and name_c:lower():find( str, nil, true ) ) ) then

				local contentIconData = {
					nicename = name or name_c,
					spawnname = name_c,
					material = "entities/" .. name_c .. ".png",
					admin = v.AdminOnly
				}

				if ( listname == "NPC" ) then contentIconData.weapon = v.Weapons end

				local entry = {
					text = name or name_c,
					icon = spawnmenu.CreateContentIcon( ctype or "entity", nil, contentIconData ),
					words = { v }
				}

				table.insert( results, entry )

			end

			if ( #results >= sbox_search_maxresults:GetInt() / 4 ) then break end

		end

		table.SortByMember( results, "text", true )
		return results

	end, stype )
end

AddSearchProvider( "SpawnableEntities", "entity", "entities" )
AddSearchProvider( "Vehicles", "vehicle", "vehicles" )
AddSearchProvider( "NPC", "npc", "npcs" )
AddSearchProvider( "Weapon", "weapon", "weapons" )
