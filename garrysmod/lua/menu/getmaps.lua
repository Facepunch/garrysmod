
local MapPatterns = {}
local MapNames = {}

local AddonMaps = {}

local function UpdateMaps()

	MapPatterns = {}
	MapNames = {}

	MapNames[ "aoc_" ] = "Age of Chivalry"
	MapNames[ "infra_" ] = "INFRA"

	MapPatterns[ "^asi-" ] = "Alien Swarm"
	MapNames[ "lobby" ] = "Alien Swarm"

	MapNames[ "cp_docks" ] = "Blade Symphony"
	MapNames[ "cp_parkour" ] = "Blade Symphony"
	MapNames[ "cp_sequence" ] = "Blade Symphony"
	MapNames[ "cp_terrace" ] = "Blade Symphony"
	MapNames[ "cp_test" ] = "Blade Symphony"
	MapNames[ "duel_" ] = "Blade Symphony"
	MapNames[ "ffa_community" ] = "Blade Symphony"
	MapNames[ "free_" ] = "Blade Symphony"
	MapNames[ "practice_box" ] = "Blade Symphony"
	MapNames[ "tut_training" ] = "Blade Symphony"
	MapNames[ "lightstyle_test" ] = "Blade Symphony"

	MapNames[ "ar_" ] = "Counter-Strike"
	MapNames[ "cs_" ] = "Counter-Strike"
	MapNames[ "de_" ] = "Counter-Strike"
	MapNames[ "es_" ] = "Counter-Strike"
	MapNames[ "fy_" ] = "Counter-Strike"
	MapNames[ "gd_" ] = "Counter-Strike"
	MapNames[ "dz_" ] = "Counter-Strike"
	MapNames[ "training1" ] = "Counter-Strike"
	MapNames[ "lobby_mapveto" ] = "Counter-Strike"

	-- Various custom cs maps
	MapNames[ "35hp_" ] = "Counter-Strike (Custom)"
	MapNames[ "aim_" ] = "Counter-Strike (Custom)"
	MapNames[ "awp_" ] = "Counter-Strike (Custom)"
	MapNames[ "am_" ] = "Counter-Strike (Custom)"
	MapNames[ "fy_" ] = "Counter-Strike (Custom)"
	MapNames[ "1v1_" ] = "Counter-Strike (Custom)"

	MapNames[ "dod_" ] = "Day Of Defeat"

	MapNames[ "ddd_" ] = "Dino D-Day"

	MapNames[ "de_dam" ] = "DIPRIP"
	MapNames[ "dm_city" ] = "DIPRIP"
	MapNames[ "dm_refinery" ] = "DIPRIP"
	MapNames[ "dm_supermarket" ] = "DIPRIP"
	MapNames[ "dm_village" ] = "DIPRIP"
	MapNames[ "ur_city" ] = "DIPRIP"
	MapNames[ "ur_refinery" ] = "DIPRIP"
	MapNames[ "ur_supermarket" ] = "DIPRIP"
	MapNames[ "ur_village" ] = "DIPRIP"

	MapNames[ "dys_" ] = "Dystopia"
	MapNames[ "pb_dojo" ] = "Dystopia"
	MapNames[ "pb_rooftop" ] = "Dystopia"
	MapNames[ "pb_round" ] = "Dystopia"
	MapNames[ "pb_urbandome" ] = "Dystopia"
	MapNames[ "sav_dojo6" ] = "Dystopia"
	MapNames[ "varena" ] = "Dystopia"

	-- Do these manually, so edits of these maps don't end up in the same category.
	local HL2Maps = {
		"d1_trainstation_01", "d1_trainstation_02", "d1_trainstation_03", "d1_trainstation_04", "d1_trainstation_05", "d1_trainstation_06",
		"d1_canals_01", "d1_canals_01a", "d1_canals_02",  "d1_canals_03", "d1_canals_05", "d1_canals_06", "d1_canals_07", "d1_canals_08", "d1_canals_09",
		"d1_canals_10", "d1_canals_11","d1_canals_12", "d1_canals_13", "d1_eli_01", "d1_eli_02",
		"d1_town_01", "d1_town_01a", "d1_town_02", "d1_town_02a", "d1_town_03", "d1_town_04","d1_town_05",
		"d2_coast_01", "d2_coast_03", "d2_coast_04", "d2_coast_05","d2_coast_07", "d2_coast_08", "d2_coast_09", "d2_coast_10", "d2_coast_11", "d2_coast_12",
		"d2_prison_01", "d2_prison_02", "d2_prison_03", "d2_prison_04", "d2_prison_05", "d2_prison_06", "d2_prison_07", "d2_prison_08",
		"d3_c17_01", "d3_c17_02", "d3_c17_03", "d3_c17_04", "d3_c17_05", "d3_c17_06a", "d3_c17_06b", "d3_c17_07", "d3_c17_08",
		"d3_c17_09", "d3_c17_10a", "d3_c17_10b", "d3_c17_11", "d3_c17_12", "d3_c17_12b", "d3_c17_13",
		"d3_citadel_01", "d3_citadel_02", "d3_citadel_03", "d3_citadel_04", "d3_citadel_05", "d3_breen_01"
	}
	for _, map in ipairs( HL2Maps ) do MapNames[ map ] = "Half-Life 2" end

	local EP1Maps = {
		"ep1_citadel_00", "ep1_citadel_01", "ep1_citadel_02", "ep1_citadel_02b", "ep1_citadel_03", "ep1_citadel_04", "ep1_c17_00",
		"ep1_c17_00a", "ep1_c17_01", "ep1_c17_01a", "ep1_c17_02", "ep1_c17_02b", "ep1_c17_02a", "ep1_c17_05", "ep1_c17_06"
	}
	for _, map in ipairs( EP1Maps ) do MapNames[ map ] = "Half-Life 2: Episode 1" end

	local EP2Maps = {
		"ep2_outland_01", "ep2_outland_01a", "ep2_outland_02", "ep2_outland_03", "ep2_outland_04", "ep2_outland_05", "ep2_outland_06", "ep2_outland_06a", "ep2_outland_07",
		"ep2_outland_08", "ep2_outland_09", "ep2_outland_10", "ep2_outland_10a", "ep2_outland_11", "ep2_outland_11a", "ep2_outland_11b", "ep2_outland_12", "ep2_outland_12a"
	}
	for _, map in ipairs( EP2Maps ) do MapNames[ map ] = "Half-Life 2: Episode 2" end

	local GStringMaps = {
		"dragon_girl", "dragon_girl1", "dragon_girl2", "dragon_girl3", "free_mars1", "free_mars2",
		"free_mars3", "hazardous_ai", "hazardous_ai_more",  "hazardous_ai0", "hazardous_ai01", "hazardous_ai2", "hazardous_ai3", "hazardous_ai3b", "hazardous_ai4",
		"hazardous_ai5", "hazardous_ai6","hazardous_ai7", "human_waste_x1", "human_waste1", "human_waste2",
		"human_waste3", "human_waste4", "human_waste5", "human_waste6", "human_waste7", "human_waste8","human_waste9",
		"lab_rat", "lab_rat1", "money_is_dead", "money_is_dead_1","money_is_dead0", "money_is_dead2", "money_is_dead2_1", "money_is_dead2_2", "money_is_dead3", "money_is_dead3_2",
		"money_is_dead4", "money_is_dead4_2", "money_is_dead4_3", "murdock_air_x1", "murdock_air_x2", "murdock_air_x3", "murdock_air_x4", "murdock_air_x5",
		"murdock_air_x6", "murdock_air1", "murdock_air2", "murdock_air3", "murdock_air4", "murdock_air5", "murdock_air6", "murdock_air7", "murdock_air8",
		"murdock_air9", "perp_org1", "perp_org2", "perp_org3", "perp_org4", "sabotage", "sabotage1",
		"smog_storm", "smog_storm1", "smog_storm2", "smog_storm3", "space_race", "space_race1",
		"space_race2", "space_race3", "space_race4", "space_race5", "terror_management_x1", "terror_management_x2",
		"terror_management_x3", "the_call1"
	}
	for _, map in ipairs( GStringMaps ) do MapNames[ map ] = "G String" end

	MapNames[ "dm_" ] = "Half-Life 2: Deathmatch"
	MapNames[ "halls3" ] = "Half-Life 2: Deathmatch"

	MapNames[ "d2_lostcoast" ] = "Half-Life 2: Lost Coast"

	MapPatterns[ "^c[%d]a" ] = "Half-Life"
	MapPatterns[ "^t0a" ] = "Half-Life"

	MapNames[ "boot_camp" ] = "Half-Life Deathmatch"
	MapNames[ "bounce" ] = "Half-Life Deathmatch"
	MapNames[ "crossfire" ] = "Half-Life Deathmatch"
	MapNames[ "datacore" ] = "Half-Life Deathmatch"
	MapNames[ "frenzy" ] = "Half-Life Deathmatch"
	MapNames[ "lambda_bunker" ] = "Half-Life Deathmatch"
	MapNames[ "rapidcore" ] = "Half-Life Deathmatch"
	MapNames[ "snarkpit" ] = "Half-Life Deathmatch"
	MapNames[ "stalkyard" ] = "Half-Life Deathmatch"
	MapNames[ "subtransit" ] = "Half-Life Deathmatch"
	MapNames[ "undertow" ] = "Half-Life Deathmatch"

	MapNames[ "ins_" ] = "Insurgency"

	MapNames[ "t_" ] = "Klaus Veen's Treason"

	MapNames[ "l4d_" ] = "Left 4 Dead"

	MapPatterns[ "^c[%d]m" ] = "Left 4 Dead 2"
	MapPatterns[ "^c1[%d]m" ] = "Left 4 Dead 2"
	MapNames[ "curling_stadium" ] = "Left 4 Dead 2"
	MapNames[ "tutorial_standards" ] = "Left 4 Dead 2"
	MapNames[ "tutorial_standards_vs" ] = "Left 4 Dead 2"

	MapNames[ "clocktower" ] = "Nuclear Dawn"
	MapNames[ "coast" ] = "Nuclear Dawn"
	MapNames[ "downtown" ] = "Nuclear Dawn"
	MapNames[ "gate" ] = "Nuclear Dawn"
	MapNames[ "hydro" ] = "Nuclear Dawn"
	MapNames[ "metro" ] = "Nuclear Dawn"
	MapNames[ "metro_training" ] = "Nuclear Dawn"
	MapNames[ "oasis" ] = "Nuclear Dawn"
	MapNames[ "oilfield" ] = "Nuclear Dawn"
	MapNames[ "silo" ] = "Nuclear Dawn"
	MapNames[ "sk_metro" ] = "Nuclear Dawn"
	MapNames[ "training" ] = "Nuclear Dawn"

	MapNames[ "bt_" ] = "Pirates, Vikings, & Knights II"
	MapNames[ "lts_" ] = "Pirates, Vikings, & Knights II"
	MapNames[ "te_" ] = "Pirates, Vikings, & Knights II"
	MapNames[ "tw_" ] = "Pirates, Vikings, & Knights II"

	MapNames[ "escape_" ] = "Portal"
	MapNames[ "testchmb_" ] = "Portal"

	MapNames[ "e1912" ] = "Portal 2"
	MapPatterns[ "^mp_coop_" ] = "Portal 2"
	MapPatterns[ "^sp_a" ] = "Portal 2"

	MapNames[ "achievement_" ] = "Team Fortress 2"
	MapNames[ "arena_" ] = "Team Fortress 2"
	MapNames[ "cp_" ] = "Team Fortress 2"
	MapNames[ "ctf_" ] = "Team Fortress 2"
	MapNames[ "itemtest" ] = "Team Fortress 2"
	MapNames[ "koth_" ] = "Team Fortress 2"
	MapNames[ "mvm_" ] = "Team Fortress 2"
	MapNames[ "pl_" ] = "Team Fortress 2"
	MapNames[ "plr_" ] = "Team Fortress 2"
	MapNames[ "rd_" ] = "Team Fortress 2"
	MapNames[ "pd_" ] = "Team Fortress 2"
	MapNames[ "sd_" ] = "Team Fortress 2"
	MapNames[ "tc_" ] = "Team Fortress 2" // Territory Control
	MapNames[ "tr_" ] = "Team Fortress 2" // Training
	MapNames[ "trade_" ] = "Team Fortress 2"
	MapNames[ "pass_" ] = "Team Fortress 2" // PASS time
	MapNames[ "vsh_" ] = "Team Fortress 2" // Versus Saxton Hale
	MapNames[ "zi_" ] = "Team Fortress 2" // Zombie Invasion
	MapNames[ "tow_" ] = "Team Fortress 2" // Tug of War

	MapNames[ "zpa_" ] = "Zombie Panic! Source"
	MapNames[ "zpl_" ] = "Zombie Panic! Source"
	MapNames[ "zpo_" ] = "Zombie Panic! Source"
	MapNames[ "zps_" ] = "Zombie Panic! Source"
	MapNames[ "zph_" ] = "Zombie Panic! Source"

	MapNames[ "fof_" ] = "Fistful of Frags"
	MapNames[ "fofhr_" ] = "Fistful of Frags"
	MapNames[ "cm_" ] = "Fistful of Frags"
	MapNames[ "gt_" ] = "Fistful of Frags"
	MapNames[ "tp_" ] = "Fistful of Frags"
	MapNames[ "vs_" ] = "Fistful of Frags"

	MapNames[ "ff_" ] = "Fortress Forever"

	MapNames[ "bhop_" ] = "Bunny Hop"
	MapNames[ "cinema_" ] = "Cinema"
	MapNames[ "theater_" ] = "Cinema"
	MapNames[ "xc_" ] = "Climb"
	MapNames[ "deathrun_" ] = "Deathrun"
	MapNames[ "dr_" ] = "Deathrun"
	MapNames[ "fm_" ] = "Flood"
	MapNames[ "gmt_" ] = "GMod Tower"
	MapNames[ "gg_" ] = "Gun Game"
	MapNames[ "scoutzknivez" ] = "Gun Game"
	MapNames[ "ba_" ] = "Jailbreak"
	MapNames[ "jail_" ] = "Jailbreak"
	MapNames[ "jb_" ] = "Jailbreak"
	MapNames[ "mg_" ] = "Minigames"
	MapNames[ "pw_" ] = "Pirate Ship Wars"
	MapNames[ "ph_" ] = "Prop Hunt"
	MapNames[ "rp_" ] = "Roleplay"
	MapNames[ "slb_" ] = "Sled Build"
	MapNames[ "sb_" ] = "Spacebuild"
	MapNames[ "slender_" ] = "Stop it Slender"
	MapNames[ "gms_" ] = "Stranded"
	MapNames[ "surf_" ] = "Surf"
	MapNames[ "ts_" ] = "The Stalker"
	MapNames[ "zm_" ] = "Zombie Survival"
	MapNames[ "zombiesurvival_" ] = "Zombie Survival"
	MapNames[ "zs_" ] = "Zombie Survival"
	MapNames[ "ze_" ] = "Zombie Escape"
	MapNames[ "coop_" ] = "Cooperative"

	local GamemodeList = engine.GetGamemodes()

	for k, gm in ipairs( GamemodeList ) do

		local Name = gm.title or "Unnammed Gamemode"
		local Maps = string.Split( gm.maps, "|" )

		if ( Maps and gm.maps != "" ) then

			for _, pattern in ipairs( Maps ) do
				-- When in doubt, just try to match it with string.find
				MapPatterns[ string.lower( pattern ) ] = Name
			end

		end

	end

	AddonMaps = {}
	for k, addon in ipairs( engine.GetAddons() ) do

		local name = addon.title or "Unnammed Addon"

		local files = file.Find( "maps/*.bsp", name )
		if ( #files > 0 ) then AddonMaps[ name ] = files end

	end

end

local favmaps

local function LoadFavourites()

	local cookiestr = cookie.GetString( "favmaps" )
	favmaps = favmaps or ( cookiestr and string.Explode( ";", cookiestr ) or {} )

end

function UpdateAddonMapList()

	local json = util.TableToJSON( AddonMaps )
	if ( !json ) then return end

	pnlMainMenu:Call( "UpdateAddonMaps(" .. json .. ")" )

end

-- Called from JS when starting a new game
function UpdateMapList()

	UpdateAddonMapList()

	local mapList = GetMapList()
	if ( !mapList ) then return end

	local json = util.TableToJSON( mapList )
	if ( !json ) then return end

	pnlMainMenu:Call( "UpdateMaps(" .. json .. ")" )

end

local IgnorePatterns = {
	"^background",
	"^devtest",
	"^ep1_background",
	"^ep2_background",
	"^styleguide",
}

local IgnoreMaps = {
	-- Prefixes
	[ "sdk_" ] = true,
	[ "test_" ] = true,
	[ "vst_" ] = true,

	-- Maps
	[ "c4a1y" ] = true,
	[ "credits" ] = true,
	[ "d2_coast_02" ] = true,
	[ "d3_c17_02_camera" ] = true,
	[ "ep1_citadel_00_demo" ] = true,
	[ "c5m1_waterfront_sndscape" ] = true,
	[ "intro" ] = true,
	[ "test" ] = true
}

local MapList = {}

local function RefreshMaps( skip )

	if ( !skip ) then UpdateMaps() end

	MapList = {}

	local maps = file.Find( "maps/*.bsp", "GAME" )
	LoadFavourites()

	for k, v in ipairs( maps ) do
		local name = string.lower( string.gsub( v, "%.bsp$", "" ) )
		local prefix = string.match( name, "^(.-_)" )

		local Ignore = IgnoreMaps[ name ] or IgnoreMaps[ prefix ]

		-- Don't loop if it's already ignored
		if ( Ignore ) then continue end

		for _, ignore in ipairs( IgnorePatterns ) do
			if ( string.find( name, ignore ) ) then
				Ignore = true
				break
			end
		end

		-- Don't add useless maps
		if ( Ignore ) then continue end

		-- Check if the map has a simple name or prefix
		local Category = MapNames[ name ] or MapNames[ prefix ]

		-- Check if the map has an embedded prefix, or is TTT/Sandbox
		if ( !Category ) then
			for pattern, category in pairs( MapPatterns ) do
				if ( string.find( name, pattern ) ) then
					Category = category
				end
			end
		end

		-- Throw all uncategorised maps into Other
		Category = Category or language.GetPhrase( "spawnmenu.category.other" )

		local fav

		if ( table.HasValue( favmaps, name ) ) then
			fav = true
		end

		local csgo = false

		if ( Category == "Counter-Strike" and file.Exists( "maps/" .. name .. ".bsp", "csgo" ) ) then
			if ( file.Exists( "maps/" .. name .. ".bsp", "cstrike" ) ) then -- Map also exists in CS:GO
				csgo = true
			else
				Category = "Counter-Strike: GO"
			end
		end

		if ( !MapList[ Category ] ) then
			MapList[ Category ] = {}
		end

		table.insert( MapList[ Category ], name )

		if ( fav ) then
			if ( !MapList[ "Favourites" ] ) then
				MapList[ "Favourites" ] = {}
			end

			table.insert( MapList[ "Favourites" ], name )
		end

		if ( csgo ) then
			if ( !MapList[ "Counter-Strike: GO" ] ) then
				MapList[ "Counter-Strike: GO" ] = {}
			end
			-- HACK: We have to make the CS:GO name different from the CS:S name to prevent Favourites conflicts
			table.insert( MapList[ "Counter-Strike: GO" ], name .. " " )
		end

	end

	-- Send the new list to the HTML menu
	UpdateMapList()

end

-- Update only after a short while for when these hooks are called very rapidly back to back
local function DelayedRefreshMaps()
	timer.Create( "menu_refreshmaps", 0.1, 1, RefreshMaps )
end

hook.Add( "MenuStart", "FindMaps", DelayedRefreshMaps )
hook.Add( "GameContentChanged", "RefreshMaps", DelayedRefreshMaps )

-- Nice maplist accessor instead of a global table
function GetMapList()
	return MapList
end

function ToggleFavourite( map )

	LoadFavourites()

	if ( table.HasValue( favmaps, map ) ) then -- is favourite, remove it
		table.remove( favmaps, table.KeysFromValue( favmaps, map )[1] )
	else -- not favourite, add it
		table.insert( favmaps, map )
	end

	cookie.Set( "favmaps", table.concat( favmaps, ";" ) )

	RefreshMaps( true )

	UpdateMapList()

end

function SaveLastMap( map, cat )

	local t = string.Explode( ";", cookie.GetString( "lastmap", "" ) )
	if ( !map ) then map = t[ 1 ] or "gm_flatgrass" end
	if ( !cat ) then cat = t[ 2 ] or "Sandbox" end

	cookie.Set( "lastmap", map .. ";" .. cat )

end

function LoadLastMap()

	local t = string.Explode( ";", cookie.GetString( "lastmap", "" ) )

	local map = t[ 1 ] or "gm_flatgrass"
	local cat = t[ 2 ] or "Sandbox"

	cat = string.gsub( cat, "'", "\\'" )

	if ( !file.Exists( "maps/" .. map .. ".bsp", "GAME" ) ) then return end

	pnlMainMenu:Call( "SetLastMap('" .. map:JavascriptSafe() .. "','" .. cat:JavascriptSafe() .. "')" )

end
