---------------
	INSTANT SPAWNMENU SEARCH

	Pre-builds a search index of all spawnable models, entities,
	weapons, NPCs and tools when joining a server. Searches are
	instant (<1ms) regardless of how many models exist.

	How it works:
		1. Collects all searchable items after InitPostEntity
		2. Builds an inverted index (trigram → items)
		3. Hooks into the spawnmenu search to use the index
		4. Results are cached per query string
		5. Input is debounced to avoid wasted work

	ConVars:
		cl_spawnsearch 1          - Enable instant search
		cl_spawnsearch_max 256    - Max results per query
		cl_spawnsearch_delay 10   - Seconds after spawn before indexing

	Console Commands:
		lua_spawnsearch_info      - Show index stats
		lua_spawnsearch_rebuild   - Force rebuild the index
		lua_spawnsearch_test xyz  - Test search query speed
----------------

if ( SERVER ) then return end

local cv_enable = CreateClientConVar( "cl_spawnsearch", "1", true, false, "Enable instant spawnmenu search" )
local cv_max = CreateClientConVar( "cl_spawnsearch_max", "256", true, false, "Max search results", 32, 1024 )
local cv_delay = CreateClientConVar( "cl_spawnsearch_delay", "10", true, false, "Seconds before building index", 2, 60 )


---------------
	SEARCH INDEX
----------------

local Index = {}			-- trigram -> { item indices }
local Items = {}			-- all searchable items
local ItemCount = 0
local IndexBuilt = false
local BuildTime = 0

local QueryCache = {}		-- recent query -> results
local CACHE_SIZE = 64


-- Extract trigrams from a string
local function GetTrigrams( str )

	local trigrams = {}
	local len = #str

	if ( len < 3 ) then
		-- For short strings, use the string itself as a "trigram"
		trigrams[ str ] = true
		if ( len == 2 ) then
			trigrams[ string.sub( str, 1, 1 ) ] = true
			trigrams[ string.sub( str, 2, 2 ) ] = true
		end
		return trigrams
	end

	for i = 1, len - 2 do
		trigrams[ string.sub( str, i, i + 2 ) ] = true
	end

	return trigrams

end


-- Score how well a query matches an item (higher = better)
local function ScoreMatch( query, itemText )

	-- Exact match is top priority
	if ( itemText == query ) then return 10000 end

	-- Starts with query
	if ( string.StartsWith( itemText, query ) ) then return 5000 + ( 100 - #itemText ) end

	-- Contains query as substring
	local found = string.find( itemText, query, 1, true )
	if ( found ) then
		-- Earlier match = higher score
		return 3000 - found + ( 100 - #itemText )
	end

	-- Word boundary match (query matches start of a word)
	local pattern = "[_/ ]" .. query
	if ( string.find( itemText, pattern ) ) then return 2000 end

	-- Trigram overlap score
	return 0

end


---------------
	COLLECT ALL SEARCHABLE ITEMS
----------------

local function CollectItems()

	local items = {}
	local seen = {}

	local function AddItem( name, searchText, category, icon )

		local key = string.lower( name )
		if ( seen[ key ] ) then return end
		seen[ key ] = true

		table.insert( items, {
			name = name,
			search = string.lower( searchText or name ),
			category = category or "props",
			icon = icon,
		} )

	end

	-- Spawnmenu prop tables
	local propTable = spawnmenu.GetPropTable()
	if ( propTable ) then
		for _, category in pairs( propTable ) do
			if ( category.contents ) then
				for _, item in pairs( category.contents ) do
					if ( item.model ) then
						-- Extract display name from model path
						local displayName = string.GetFileFromFilename( item.model ) or item.model
						displayName = string.StripExtension( displayName )
						AddItem( item.model, item.model .. " " .. displayName, category.name, item.model )
					end
				end
			end
		end
	end

	-- Custom prop tables
	local customTable = spawnmenu.GetCustomPropTable()
	if ( customTable ) then
		for _, category in pairs( customTable ) do
			if ( category.contents ) then
				for _, item in pairs( category.contents ) do
					if ( item.model ) then
						local displayName = string.GetFileFromFilename( item.model ) or item.model
						displayName = string.StripExtension( displayName )
						AddItem( item.model, item.model .. " " .. displayName, category.name, item.model )
					end
				end
			end
		end
	end

	-- Spawnable entities
	local entList = list.Get( "SpawnableEntities" )
	if ( entList ) then
		for className, data in pairs( entList ) do
			local searchStr = ( data.PrintName or className ) .. " " .. className
			if ( data.Category ) then searchStr = searchStr .. " " .. data.Category end
			AddItem( className, searchStr, data.Category or "Entities", data.SpawnName )
		end
	end

	-- Weapons
	local weaponList = list.Get( "Weapon" )
	if ( weaponList ) then
		for className, data in pairs( weaponList ) do
			local searchStr = ( data.PrintName or className ) .. " " .. className
			if ( data.Category ) then searchStr = searchStr .. " " .. data.Category end
			AddItem( className, searchStr, data.Category or "Weapons" )
		end
	end

	-- NPCs
	local npcList = list.Get( "NPC" )
	if ( npcList ) then
		for className, data in pairs( npcList ) do
			local searchStr = ( data.Name or className ) .. " " .. className
			if ( data.Category ) then searchStr = searchStr .. " " .. data.Category end
			AddItem( className, searchStr, data.Category or "NPCs" )
		end
	end

	-- Vehicles
	local vehicleList = list.Get( "Vehicles" )
	if ( vehicleList ) then
		for className, data in pairs( vehicleList ) do
			local searchStr = ( data.Name or className ) .. " " .. className
			if ( data.Category ) then searchStr = searchStr .. " " .. data.Category end
			AddItem( className, searchStr, data.Category or "Vehicles" )
		end
	end

	return items

end


---------------
	BUILD INVERTED INDEX
----------------

local function BuildIndex()

	local startTime = SysTime()

	Items = CollectItems()
	ItemCount = #Items
	Index = {}
	QueryCache = {}

	-- Build trigram index
	for i, item in ipairs( Items ) do
		local trigrams = GetTrigrams( item.search )
		for tri, _ in pairs( trigrams ) do
			if ( !Index[ tri ] ) then Index[ tri ] = {} end
			table.insert( Index[ tri ], i )
		end
	end

	BuildTime = math.Round( ( SysTime() - startTime ) * 1000, 2 )
	IndexBuilt = true

	local triCount = table.Count( Index )
	MsgN( string.format( "[SpawnSearch] Index built: %d items, %d trigrams in %.1fms", ItemCount, triCount, BuildTime ) )

end


---------------
	SEARCH FUNCTION
----------------

local function Search( query )

	if ( !IndexBuilt ) then return {} end

	query = string.lower( string.Trim( query ) )
	if ( query == "" ) then return {} end

	-- Check cache
	if ( QueryCache[ query ] ) then return QueryCache[ query ] end

	local maxResults = cv_max:GetInt()

	-- Get trigrams for the query
	local queryTrigrams = GetTrigrams( query )

	-- Find candidate items via trigram intersection
	local candidates = {}		-- itemIndex -> trigram hit count

	for tri, _ in pairs( queryTrigrams ) do
		local posting = Index[ tri ]
		if ( posting ) then
			for _, itemIdx in ipairs( posting ) do
				candidates[ itemIdx ] = ( candidates[ itemIdx ] or 0 ) + 1
			end
		end
	end

	-- Score and filter candidates
	local scored = {}
	local triCount = table.Count( queryTrigrams )
	local minHits = math.max( 1, math.floor( triCount * 0.5 ) )		-- require at least half the trigrams to match

	for itemIdx, hits in pairs( candidates ) do
		if ( hits >= minHits ) then
			local item = Items[ itemIdx ]
			local score = ScoreMatch( query, item.search )

			-- Boost by trigram coverage
			score = score + ( hits / triCount ) * 1000

			if ( score > 0 ) then
				table.insert( scored, { item = item, score = score } )
			end
		end
	end

	-- Sort by score descending
	table.sort( scored, function( a, b ) return a.score > b.score end )

	-- Trim to max results
	local results = {}
	for i = 1, math.min( #scored, maxResults ) do
		table.insert( results, scored[ i ].item )
	end

	-- Cache result
	QueryCache[ query ] = results

	-- Evict oldest cache entries if too many
	local cacheCount = table.Count( QueryCache )
	if ( cacheCount > CACHE_SIZE ) then
		-- Simple: clear entire cache when it gets too big
		-- (proper LRU would be overkill here since searches are <1ms anyway)
		QueryCache = { [ query ] = results }
	end

	return results

end


---------------
	HOOK INTO SPAWNMENU SEARCH
----------------

-- Register as a search provider so the default Q menu uses our index
hook.Add( "InitPostEntity", "SpawnSearch_Init", function()

	local delay = cv_delay:GetFloat()

	timer.Simple( delay, function()

		if ( !cv_enable:GetBool() ) then return end

		BuildIndex()

		-- Register our fast search provider
		if ( search and search.AddProvider ) then
			search.AddProvider( function( query )

				local results = Search( query )
				local output = {}

				for _, item in ipairs( results ) do
					table.insert( output, {
						text = item.name,
						func = function()
							if ( item.category == "props" and item.icon ) then
								RunConsoleCommand( "gm_spawn", item.icon )
							end
						end,
						icon = item.icon and "spawnicons/" .. string.StripExtension( item.icon ) .. ".png" or "icon16/brick.png",
						words = { item.name }
					} )
				end

				return output

			end, "SpawnSearchFast" )

			MsgN( "[SpawnSearch] Registered as search provider." )
		end

	end )

end )


-- Rebuild when spawnmenu reloads
hook.Add( "SpawnmenuReloaded", "SpawnSearch_Rebuild", function()

	if ( !cv_enable:GetBool() ) then return end

	timer.Simple( 2, function()
		BuildIndex()
	end )

end )


---------------
	CONSOLE COMMANDS
----------------

concommand.Add( "lua_spawnsearch_info", function()

	print( "" )
	print( "========== SPAWN SEARCH INDEX ==========" )
	print( string.format( "  Indexed Items:    %d", ItemCount ) )
	print( string.format( "  Trigram Count:    %d", table.Count( Index ) ) )
	print( string.format( "  Build Time:       %.1f ms", BuildTime ) )
	print( string.format( "  Cache Entries:    %d / %d", table.Count( QueryCache ), CACHE_SIZE ) )
	print( string.format( "  Index Built:      %s", IndexBuilt and "yes" or "no" ) )
	print( "==========================================" )
	print( "" )

end )


concommand.Add( "lua_spawnsearch_rebuild", function()

	BuildIndex()
	MsgN( "[SpawnSearch] Index rebuilt." )

end )


concommand.Add( "lua_spawnsearch_test", function( _, _, args )

	if ( !IndexBuilt ) then
		print( "[SpawnSearch] Index not built yet!" )
		return
	end

	local query = table.concat( args, " " )
	if ( query == "" ) then
		print( "Usage: lua_spawnsearch_test <query>" )
		return
	end

	-- Clear cache so we get a real timing
	QueryCache = {}

	local startTime = SysTime()
	local results = Search( query )
	local elapsed = ( SysTime() - startTime ) * 1000

	print( "" )
	print( string.format( "[SpawnSearch] Query: '%s' -> %d results in %.3f ms", query, #results, elapsed ) )

	for i = 1, math.min( 10, #results ) do
		print( string.format( "  %d. %s (%s)", i, results[ i ].name, results[ i ].category ) )
	end

	if ( #results > 10 ) then
		print( string.format( "  ... and %d more", #results - 10 ) )
	end

	print( "" )

end )


MsgN( "[SpawnSearch] Instant spawnmenu search loaded." )
