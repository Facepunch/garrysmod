
if ( g_MapList ) then return end

local MapPatterns = {}

local function UpdateMapPatterns()

	MapPatterns = {}

	MapPatterns[ "^de_" ] = "Counter-Strike"
	MapPatterns[ "^cs_" ] = "Counter-Strike"
	MapPatterns[ "^es_" ] = "Counter-Strike"
	MapPatterns[ "^cp_" ] = "Team Fortress 2"
	MapPatterns[ "^ctf_" ] = "Team Fortress 2"
	MapPatterns[ "^mvm_" ] = "Team Fortress 2"
	MapPatterns[ "^sd_" ] = "Team Fortress 2"
	MapPatterns[ "^tc_" ] = "Team Fortress 2"
	MapPatterns[ "^tr_" ] = "Team Fortress 2"
	MapPatterns[ "^pl_" ] = "Team Fortress 2"
	MapPatterns[ "^plr_" ] = "Team Fortress 2"
	MapPatterns[ "^arena_" ] = "Team Fortress 2"
	MapPatterns[ "^koth_" ] = "Team Fortress 2"
	MapPatterns[ "itemtest" ] = "Team Fortress 2"

	MapPatterns[ "^dod_" ] = "Day Of Defeat"

	MapPatterns[ "^d1_" ] = "Half-Life 2"
	MapPatterns[ "^d2_" ] = "Half-Life 2"
	MapPatterns[ "^d3_" ] = "Half-Life 2"
	MapPatterns[ "credits" ] = "Half-Life 2"
	MapPatterns[ "intro" ] = "Half-Life 2"

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

	MapPatterns[ "boot_camp" ] = "Half-Life: Source Deathmatch"
	MapPatterns[ "bounce" ] = "Half-Life: Source Deathmatch"
	MapPatterns[ "crossfire" ] = "Half-Life: Source Deathmatch"
	MapPatterns[ "datacore" ] = "Half-Life: Source Deathmatch"
	MapPatterns[ "frenzy" ] = "Half-Life: Source Deathmatch"
	MapPatterns[ "rapidcore" ] = "Half-Life: Source Deathmatch"
	MapPatterns[ "stalkyard" ] = "Half-Life: Source Deathmatch"
	MapPatterns[ "snarkpit" ] = "Half-Life: Source Deathmatch"
	MapPatterns[ "subtransit" ] = "Half-Life: Source Deathmatch"
	MapPatterns[ "undertow" ] = "Half-Life: Source Deathmatch"
	MapPatterns[ "lambda_bunker" ] = "Half-Life: Source Deathmatch"

	MapPatterns[ "dm_" ] = "Half-Life 2 Deathmatch"

	MapPatterns[ "^dys_" ] = "Dystopia"
	MapPatterns[ "^pb_" ] = "Dystopia"
	MapPatterns[ "dys_lobby" ] = "Dystopia"

	MapPatterns[ "^ins_" ] = "Insurgency"
	MapPatterns[ "^aoc_" ] = "Age Of Chivalry"
	MapPatterns[ "^mp_coop_" ] = "Portal 2"

	MapPatterns[ "^ur_" ] = "DIPRIP"
	MapPatterns[ "dm_village" ] = "DIPRIP"
	MapPatterns[ "dm_supermarket" ] = "DIPRIP"
	MapPatterns[ "dm_refinery" ] = "DIPRIP"
	MapPatterns[ "dm_dam" ] = "DIPRIP"
	MapPatterns[ "dm_city" ] = "DIPRIP"
	MapPatterns[ "de_dam" ] = "DIPRIP"

	MapPatterns[ "^tw_" ] = "Pirates, Vikings and Knights II"
	MapPatterns[ "^bt_" ] = "Pirates, Vikings and Knights II"
	MapPatterns[ "^lts_" ] = "Pirates, Vikings and Knights II"
	MapPatterns[ "^te_" ] = "Pirates, Vikings and Knights II"

	MapPatterns[ "^zps_" ] = "Zombie Panic! Source"
	MapPatterns[ "^zpa_" ] = "Zombie Panic! Source"
	MapPatterns[ "^zpo_" ] = "Zombie Panic! Source"
	MapPatterns[ "^zpl_" ] = "Zombie Panic! Source"

	MapPatterns[ "^rp_" ] = "Roleplay"
	MapPatterns[ "^zs_" ] = "Zombie Survival"
	MapPatterns[ "^jb_" ] = "Jailbreak"
	MapPatterns[ "^ba_jail_" ] = "Jailbreak"
	MapPatterns[ "^deathrun_" ] = "Deathrun"
	MapPatterns[ "^dr_" ] = "Deathrun"
	MapPatterns[ "^surf_" ] = "Surf"
	MapPatterns[ "^sb_" ] = "Spacebuild"
	
	MapPatterns[ "^asi-" ] = "Alien Swarm"
	MapPatterns[ "lobby" ] = "Alien Swarm"
	
	MapPatterns[ "tutorial_standards" ] = "Left 4 Dead 2"
	MapPatterns[ "tutorial_standards_vs" ] = "Left 4 Dead 2"
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





local IgnoreMaps = { "background", "^test_", "^styleguide", "^devtest" }

matNoIcon = Material( "maps/noicon" )

local function RefreshMaps()

	UpdateMapPatterns();

	g_MapList = {}
	g_MapListCategorised = {}

	for k, v in pairs( file.Find( "maps/*.bsp", "GAME" ) ) do

		local Ignore = false
		for _, ignore in pairs( IgnoreMaps ) do
			if ( string.find( v, ignore ) ) then
				Ignore = true
			end
		end
		
		-- Don't add useless maps
		if ( !Ignore ) then
		
			local Mat = nil
			local Category = "Other"
			local name = string.gsub( v, ".bsp", "" )
			local lowername = string.lower( v )
		
			Mat = "../maps/"..name..".png"
			
			for pattern, category in pairs( MapPatterns ) do
				if ( string.find( lowername, pattern ) ) then
					Category = category
				end
			end

			if ( MapPatterns[ name ] ) then Category = MapPatterns[ name ] end
			
			g_MapList[ v ] = { Material = Mat, Name = name, Category = Category }
			
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