if ( g_MapList ) then return end

local MapPatterns = {}

local function UpdateMapPatterns()

  MapPatterns = {}
  
  MapPatterns[ "^aoc_" ] = "Age of Chivalry"
  MapPatterns[ "^asi-" ] = "Alien Swarm"

  MapPatterns[ "lobby" ] = "Alien Swarm"
  
  MapPatterns[ "^ar_" ] = "Counter-Strike"
  MapPatterns[ "^cs_" ] = "Counter-Strike"
  MapPatterns[ "^de_" ] = "Counter-Strike"
  MapPatterns[ "^es_" ] = "Counter-Strike"
  MapPatterns[ "^fy_" ] = "Counter-Strike"
  MapPatterns[ "training1" ] = "Counter-Strike"
  
  MapPatterns[ "^dod_" ] = "Day Of Defeat"
  
  MapPatterns[ "cp_pacentro" ] = "Dino D-Day"
  MapPatterns[ "cp_snowypark" ] = "Dino D-Day"
  MapPatterns[ "cp_troina" ] = "Dino D-Day"
  MapPatterns[ "dm_canyon" ] = "Dino D-Day"
  MapPatterns[ "dm_depot" ] = "Dino D-Day"
  MapPatterns[ "dm_fortress_trex" ] = "Dino D-Day"
  MapPatterns[ "dm_gela_trex" ] = "Dino D-Day"
  MapPatterns[ "dm_hilltop" ] = "Dino D-Day"
  MapPatterns[ "dm_market" ] = "Dino D-Day"
  MapPatterns[ "dm_pacentro" ] = "Dino D-Day"
  MapPatterns[ "dm_snowypark" ] = "Dino D-Day"
  MapPatterns[ "dm_troina" ] = "Dino D-Day"
  MapPatterns[ "koth_hilltop" ] = "Dino D-Day"
  MapPatterns[ "KOTH_Market" ] = "Dino D-Day"
  MapPatterns[ "koth_pacentro" ] = "Dino D-Day"
  MapPatterns[ "koth_snowypark" ] = "Dino D-Day"
  MapPatterns[ "obj_canyon" ] = "Dino D-Day"
  MapPatterns[ "obj_depot" ] = "Dino D-Day"
  MapPatterns[ "obj_fortress" ] = "Dino D-Day"
  
  MapPatterns[ "de_dam" ] = "DIPRIP"
  MapPatterns[ "dm_city" ] = "DIPRIP"
  MapPatterns[ "dm_refinery" ] = "DIPRIP"
  MapPatterns[ "dm_supermarket" ] = "DIPRIP"
  MapPatterns[ "dm_village" ] = "DIPRIP"
  MapPatterns[ "^ur_" ] = "DIPRIP"
  
  MapPatterns[ "^dys_" ] = "Dystopia"
  MapPatterns[ "^pb_" ] = "Dystopia"
  
  MapPatterns[ "credits" ] = "Half-Life 2"
  MapPatterns[ "^d1_" ] = "Half-Life 2"
  MapPatterns[ "^d2_" ] = "Half-Life 2"
  MapPatterns[ "^d3_" ] = "Half-Life 2"
  MapPatterns[ "intro" ] = "Half-Life 2"
  
  MapPatterns[ "^dm_" ] = "Half-Life 2: Deathmatch"
  MapPatterns[ "halls3" ] = "Half-Life 2: Deathmatch"
  
  MapPatterns[ "^ep1_" ] = "Half-Life 2: Episode 1"
  MapPatterns[ "^ep2_" ] = "Half-Life 2: Episode 2"
  MapPatterns[ "^ep3_" ] = "Half-Life 2: Episode 3"
  
  MapPatterns[ "d2_lostcoast" ] = "Half-Life 2: Lost Coast"
  MapPatterns[ "vst_lostcoast" ] = "Half-Life 2: Lost Coast"
  
  MapPatterns[ "^c0a" ] = "Half-Life: Source"
  MapPatterns[ "^c1a" ] = "Half-Life: Source"
  MapPatterns[ "^c2a" ] = "Half-Life: Source"
  MapPatterns[ "^c3a" ] = "Half-Life: Source"
  MapPatterns[ "^c4a" ] = "Half-Life: Source"
  MapPatterns[ "^c5a" ] = "Half-Life: Source"
  MapPatterns[ "^t0a" ] = "Half-Life: Source"
  
  MapPatterns[ "boot_camp" ] = "Half-Life Deathmatch: Source"
  MapPatterns[ "bounce" ] = "Half-Life Deathmatch: Source"
  MapPatterns[ "crossfire" ] = "Half-Life Deathmatch: Source"
  MapPatterns[ "datacore" ] = "Half-Life Deathmatch: Source"
  MapPatterns[ "frenzy" ] = "Half-Life Deathmatch: Source"
  MapPatterns[ "lambda_bunker" ] = "Half-Life Deathmatch: Source"
  MapPatterns[ "rapidcore" ] = "Half-Life Deathmatch: Source"
  MapPatterns[ "snarkpit" ] = "Half-Life Deathmatch: Source"
  MapPatterns[ "stalkyard" ] = "Half-Life Deathmatch: Source"
  MapPatterns[ "subtransit" ] = "Half-Life Deathmatch: Source"
  MapPatterns[ "undertow" ] = "Half-Life Deathmatch: Source"
  
  MapPatterns[ "^ins_" ] = "Insurgency"
  
  MapPatterns[ "^l4d" ] = "Left 4 Dead"
  
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
  MapPatterns[ "curling_stadium" ] = "Left 4 Dead 2"
  MapPatterns[ "tutorial_standards" ] = "Left 4 Dead 2"
  MapPatterns[ "tutorial_standards_vs" ] = "Left 4 Dead 2"
  
  MapPatterns[ "clocktower" ] = "Nuclear Dawn"
  MapPatterns[ "coast" ] = "Nuclear Dawn"
  MapPatterns[ "downtown" ] = "Nuclear Dawn"
  MapPatterns[ "gate" ] = "Nuclear Dawn"
  MapPatterns[ "hydro" ] = "Nuclear Dawn"
  MapPatterns[ "metro" ] = "Nuclear Dawn"
  MapPatterns[ "metro_training" ] = "Nuclear Dawn"
  MapPatterns[ "oasis" ] = "Nuclear Dawn"
  MapPatterns[ "oilfield" ] = "Nuclear Dawn"
  MapPatterns[ "silo" ] = "Nuclear Dawn"
  MapPatterns[ "sk_metro" ] = "Nuclear Dawn"
  MapPatterns[ "training" ] = "Nuclear Dawn"
  
  MapPatterns[ "^bt_" ] = "Pirates, Vikings, & Knights II"
  MapPatterns[ "^lts_" ] = "Pirates, Vikings, & Knights II"
  MapPatterns[ "^te_" ] = "Pirates, Vikings, & Knights II"
  MapPatterns[ "^tw_" ] = "Pirates, Vikings, & Knights II"
  
  MapPatterns[ "^escape_" ] = "Portal"
  MapPatterns[ "^testchmb_" ] = "Portal"
  
  MapPatterns[ "e1912" ] = "Portal 2"
  MapPatterns[ "^mp_coop_" ] = "Portal 2"
  MapPatterns[ "^sp_a" ] = "Portal 2"
  
  MapPatterns[ "^arena_" ] = "Team Fortress 2"
  MapPatterns[ "^cp_" ] = "Team Fortress 2"
  MapPatterns[ "^ctf_" ] = "Team Fortress 2"
  MapPatterns[ "itemtest" ] = "Team Fortress 2"
  MapPatterns[ "^koth_" ] = "Team Fortress 2"
  MapPatterns[ "^mvm_" ] = "Team Fortress 2"
  MapPatterns[ "^pl_" ] = "Team Fortress 2"
  MapPatterns[ "^plr_" ] = "Team Fortress 2"
  MapPatterns[ "^sd_" ] = "Team Fortress 2"
  MapPatterns[ "^tc_" ] = "Team Fortress 2"
  MapPatterns[ "^tr_" ] = "Team Fortress 2"
  
  MapPatterns[ "^zpa_" ] = "Zombie Panic! Source"
  MapPatterns[ "^zpl_" ] = "Zombie Panic! Source"
  MapPatterns[ "^zpo_" ] = "Zombie Panic! Source"
  MapPatterns[ "^zps_" ] = "Zombie Panic! Source"
  --Custom Map Categories--
  MapPatterns[ "^achievement_" ] = "Achievement"
  MapPatterns[ "^cinema_" ] = "Cinema"
  MapPatterns[ "^theater_" ] = "Cinema"
  MapPatterns[ "^xc_" ] = "Climb"
  MapPatterns[ "^deathrun_" ] = "Deathrun"
  MapPatterns[ "^dr_" ] = "Deathrun"
  MapPatterns[ "^gmt_" ] = "GMod Tower"
  MapPatterns[ "^jb_" ] = "Jailbreak"
  MapPatterns[ "^ba_jail_" ] = "Jailbreak"
  MapPatterns[ "^mg_" ] = "Minigames"
  MapPatterns[ "^phys_" ] = "Physics Maps"
  MapPatterns[ "^pw_" ] = "Pirate Ship Wars"
  MapPatterns[ "^ph_" ] = "Prop Hunt"
  MapPatterns[ "^rp_" ] = "Roleplay"
  MapPatterns[ "^sb_" ] = "Spacebuild"
  MapPatterns[ "^slender_" ] = "Stop it Slender"
  MapPatterns[ "^gms_" ] = "Stranded"
  MapPatterns[ "^surf_" ] = "Surf"
  MapPatterns[ "^ts_" ] = "The Stalker"
  MapPatterns[ "^zm_" ] = "Zombie Survival"
  MapPatterns[ "^zombiesurvival_" ] = "Zombie Survival"
  MapPatterns[ "^zs_" ] = "Zombie Survival"
  
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

local IgnoreMaps = { "background", "^test_", "^styleguide", "^devtest", "sdk_shader_samples" }

local function RefreshMaps()

	UpdateMapPatterns()

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

	local mapinfo = g_MapList[ map .. ".bsp" ]

	if ( !mapinfo ) then map = "gm_flatgrass" end
	if ( !g_MapListCategorised[ cat ] ) then cat = mapinfo and mapinfo.Category or "Sandbox" end

	cat = string.gsub( cat, "'", "\\'" )

	pnlMainMenu:Call( "SetLastMap('" .. map .. "','" .. cat .. "')" )

end
