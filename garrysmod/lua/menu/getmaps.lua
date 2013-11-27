
if ( g_MapList ) then return end

local MapPatterns = {}

local function UpdateMapPatterns()

	MapPatterns = {}

	MapPatterns[ "^de_" ] = "Counter-Strike"
	MapPatterns[ "^cs_" ] = "Counter-Strike"
	MapPatterns[ "^es_" ] = "Counter-Strike"
	MapPatterns[ "^ar_" ] = "Counter-Strike"
	MapPatterns[ "^fy_" ] = "Counter-Strike"
	
	MapPatterns[ "^cp_" ] = "Team Fortress 2"
	MapPatterns[ "^sd_" ] = "Team Fortress 2"
	MapPatterns[ "^tc_" ] = "Team Fortress 2"
	MapPatterns[ "^tr_" ] = "Team Fortress 2"
	MapPatterns[ "^pl_" ] = "Team Fortress 2"
	MapPatterns[ "^ctf_" ] = "Team Fortress 2"
	MapPatterns[ "^mvm_" ] = "Team Fortress 2"
	MapPatterns[ "^plr_" ] = "Team Fortress 2"
	MapPatterns[ "^koth_" ] = "Team Fortress 2"
	MapPatterns[ "^arena_" ] = "Team Fortress 2"
	MapPatterns[ "itemtest" ] = "Team Fortress 2"

	MapPatterns[ "^dod_" ] = "Day Of Defeat"

	MapPatterns[ "^d1_" ] = "Half-Life 2"
	MapPatterns[ "^d2_" ] = "Half-Life 2"
	MapPatterns[ "^d3_" ] = "Half-Life 2"
	MapPatterns[ "intro" ] = "Half-Life 2"
	MapPatterns[ "credits" ] = "Half-Life 2"

	MapPatterns[ "^ep1_" ] = "Half-Life 2: Episode 1"
	MapPatterns[ "^ep2_" ] = "Half-Life 2: Episode 2"
	MapPatterns[ "^ep3_" ] = "Half-Life 2: Episode 3"

	MapPatterns[ "^escape_" ] = "Portal"
	MapPatterns[ "^testchmb_" ] = "Portal"

	MapPatterns[ "^phys_" ] = "Physics Maps"

	MapPatterns[ "^c0a" ] = "Half-Life: Source"
	MapPatterns[ "^c1a" ] = "Half-Life: Source"
	MapPatterns[ "^c2a" ] = "Half-Life: Source"
	MapPatterns[ "^c3a" ] = "Half-Life: Source"
	MapPatterns[ "^c4a" ] = "Half-Life: Source"
	MapPatterns[ "^c5a" ] = "Half-Life: Source"
	MapPatterns[ "^t0a" ] = "Half-Life: Source"

	MapPatterns[ "bounce" ] = "Half-Life: Source Deathmatch"
	MapPatterns[ "frenzy" ] = "Half-Life: Source Deathmatch"
	MapPatterns[ "snarkpit" ] = "Half-Life: Source Deathmatch"
	MapPatterns[ "datacore" ] = "Half-Life: Source Deathmatch"
	MapPatterns[ "undertow" ] = "Half-Life: Source Deathmatch"
	MapPatterns[ "boot_camp" ] = "Half-Life: Source Deathmatch"
	MapPatterns[ "crossfire" ] = "Half-Life: Source Deathmatch"
	MapPatterns[ "rapidcore" ] = "Half-Life: Source Deathmatch"
	MapPatterns[ "stalkyard" ] = "Half-Life: Source Deathmatch"
	MapPatterns[ "subtransit" ] = "Half-Life: Source Deathmatch"
	MapPatterns[ "lambda_bunker" ] = "Half-Life: Source Deathmatch"

	MapPatterns[ "^dm_" ] = "Half-Life 2: Deathmatch"

	MapPatterns[ "^pb_" ] = "Dystopia"
	MapPatterns[ "^dys_" ] = "Dystopia"
	MapPatterns[ "dys_lobby" ] = "Dystopia"

	MapPatterns[ "^ins_" ] = "Insurgency"
	MapPatterns[ "^aoc_" ] = "Age of Chivalry"

	MapPatterns[ "^mp_coop_" ] = "Portal 2"
	MapPatterns[ "^sp_a" ] = "Portal 2"
	MapPatterns[ "e1912" ] = "Portal 2"

	MapPatterns[ "^ur_" ] = "DIPRIP"
	MapPatterns[ "dm_dam" ] = "DIPRIP"
	MapPatterns[ "de_dam" ] = "DIPRIP"
	MapPatterns[ "dm_city" ] = "DIPRIP"
	MapPatterns[ "dm_village" ] = "DIPRIP"
	MapPatterns[ "dm_refinery" ] = "DIPRIP"
	MapPatterns[ "dm_supermarket" ] = "DIPRIP"

	MapPatterns[ "^tw_" ] = "Pirates, Vikings and Knights II"
	MapPatterns[ "^bt_" ] = "Pirates, Vikings and Knights II"
	MapPatterns[ "^te_" ] = "Pirates, Vikings and Knights II"
	MapPatterns[ "^lts_" ] = "Pirates, Vikings and Knights II"

	MapPatterns[ "^zps_" ] = "Zombie Panic! Source"
	MapPatterns[ "^zpa_" ] = "Zombie Panic! Source"
	MapPatterns[ "^zpo_" ] = "Zombie Panic! Source"
	MapPatterns[ "^zpl_" ] = "Zombie Panic! Source"

	MapPatterns[ "^surf_" ] = "Surf"
	MapPatterns[ "^rp_" ] = "Roleplay"
	MapPatterns[ "^sb_" ] = "Spacebuild"
	MapPatterns[ "^achievement_" ] = "Achievement"
	MapPatterns[ "^zs_" ] = "Zombie Survival"
	MapPatterns[ "^dr_" ] = "Deathrun"
	MapPatterns[ "^deathrun_" ] = "Deathrun"
	MapPatterns[ "^jb_" ] = "Jailbreak"
	MapPatterns[ "^ba_jail_" ] = "Jailbreak"
	
	MapPatterns[ "^asi-" ] = "Alien Swarm"
	MapPatterns[ "lobby" ] = "Alien Swarm"
	
	MapPatterns[ "^c1m" ] = "Left 4 Dead 2"
	MapPatterns[ "^c2m" ] = "Left 4 Dead 2"
	MapPatterns[ "^c3m" ] = "Left 4 Dead 2"
	MapPatterns[ "^c4m" ] = "Left 4 Dead 2"
	MapPatterns[ "^c5m" ] = "Left 4 Dead 2"
	MapPatterns[ "^c6m" ] = "Left 4 Dead 2" -- DLCs
	MapPatterns[ "^c7m" ] = "Left 4 Dead 2"
	MapPatterns[ "^c8m" ] = "Left 4 Dead 2"
	MapPatterns[ "^c9m" ] = "Left 4 Dead 2"
	MapPatterns[ "^c10m" ] = "Left 4 Dead 2"
	MapPatterns[ "^c11m" ] = "Left 4 Dead 2"
	MapPatterns[ "^c12m" ] = "Left 4 Dead 2"
	MapPatterns[ "^c13m" ] = "Left 4 Dead 2"
	MapPatterns[ "tutorial_standards" ] = "Left 4 Dead 2"
	MapPatterns[ "tutorial_standards_vs" ] = "Left 4 Dead 2"

	local GamemodeList = engine.GetGamemodes()

	for k, gm in pairs( GamemodeList ) do

		local Name			= gm.title or "Unnammed Gamemode"
		local Maps			= string.Split( gm.maps, "|" )

		if ( Maps && gm.maps != "" ) then
	
			for k, pattern in pairs( Maps ) do
				MapPatterns[ pattern ] = Name
			end

		end
	
	end

end


local favmaps

local function LoadFavourites()

	favmaps = favmaps or string.Explode( ";", cookie.GetString( "favmaps", "" ) )
	
end 

local IgnoreMaps = { "background", "^test_", "^styleguide", "^devtest" }

local function RefreshMaps()

	UpdateMapPatterns();

	g_MapList = {}
	g_MapListCategorised = {}
	
	local maps 			= file.Find( "maps/*.bsp", "GAME" )
	LoadFavourites()
	
	for k, v in pairs( maps ) do
		local Ignore = false
		for _, ignore in pairs( IgnoreMaps ) do
			if ( string.find( v, ignore ) ) then
				Ignore = true
			end
		end
		
		-- Don't add useless maps
		if ( !Ignore ) then
		
			local Category = "Other"
			local name = string.gsub( v, ".bsp", "" )
			local lowername = string.lower( v )
			
			for pattern, category in pairs( MapPatterns ) do
				if ( ( string.StartWith( pattern, "^" ) || string.EndsWith( pattern, "_" ) || string.EndsWith( pattern, "-" ) ) && string.find( lowername, pattern ) ) then
					Category = category
				end
			end

			if ( MapPatterns[ name ] ) then Category = MapPatterns[ name ] end
			
			if ( table.HasValue( favmaps, name ) ) then
				-- Hackity hack
				g_MapList[ v .. " " ] = { Name = name, Category = "Favourites" }
			end
			
			g_MapList[ v ] = { Name = name, Category = Category }
			
		end

	end

	for k, v in pairs( g_MapList ) do

		g_MapListCategorised[ v.Category ] = g_MapListCategorised[ v.Category ] or {}
		g_MapListCategorised[ v.Category ][ v.Name ] = v

	end


end


hook.Add( "MenuStart", "FindMaps", function()

	RefreshMaps()

end )


hook.Add( "GameContentChanged", "RefreshMaps", function()

	RefreshMaps()

end )

function ToggleFavourite(map)

	LoadFavourites()
	
	if ( table.HasValue( favmaps, map ) ) then -- is favourite, remove it
		table.remove( favmaps, table.KeysFromValue( favmaps, map )[1] )
	else -- not favourite, add it
		table.insert( favmaps, map )
	end
	
	cookie.Set( "favmaps", table.concat( favmaps, ";" ) )
	
	RefreshMaps()
	
	UpdateMapList()
	
end

function SaveLastMap( map, cat )
	local t = string.Explode( ";", cookie.GetString( "lastmap", "" ) )
	if ( !map ) then map = t[ 1 ] or "" end
	if ( !cat ) then cat = t[ 2 ] or "" end
	
	cookie.Set( "lastmap", map .. ";" .. cat )
end

function LoadLastMap()
	local t = string.Explode( ";", cookie.GetString( "lastmap", "" ) )
	local map = t[ 1 ] or ""
	local cat = t[ 2 ] or ""
	
	pnlMainMenu:Call( "SetLastMap('" .. map .. "','" .. cat .. "')" );
end
