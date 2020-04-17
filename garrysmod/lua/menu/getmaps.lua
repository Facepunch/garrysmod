
local MapPatterns = {}
local MapNames = {}

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

	MapNames[ "d1_" ] = "Half-Life 2"
	MapNames[ "d2_" ] = "Half-Life 2"
	MapNames[ "d3_" ] = "Half-Life 2"

	MapNames[ "dm_" ] = "Half-Life 2: Deathmatch"
	MapNames[ "halls3" ] = "Half-Life 2: Deathmatch"

	MapNames[ "ep1_" ] = "Half-Life 2: Episode 1"
	MapNames[ "ep2_" ] = "Half-Life 2: Episode 2"
	MapNames[ "ep3_" ] = "Half-Life 2: Episode 3"

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
	MapNames[ "tc_" ] = "Team Fortress 2"
	MapNames[ "tr_" ] = "Team Fortress 2"
	MapNames[ "trade_" ] = "Team Fortress 2"
	MapNames[ "pass_" ] = "Team Fortress 2"

	MapNames[ "zpa_" ] = "Zombie Panic! Source"
	MapNames[ "zpl_" ] = "Zombie Panic! Source"
	MapNames[ "zpo_" ] = "Zombie Panic! Source"
	MapNames[ "zps_" ] = "Zombie Panic! Source"
	MapNames[ "zph_" ] = "Zombie Panic! Source"

	MapNames[ "fof_" ] = "Fistful of Frags"
	MapNames[ "cm_" ] = "Fistful of Frags"
	MapNames[ "gt_" ] = "Fistful of Frags"
	MapNames[ "tp_" ] = "Fistful of Frags"
	MapNames[ "vs_" ] = "Fistful of Frags"

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
	MapNames[ "coop_" ] = "Cooperative"

	local GamemodeList = engine.GetGamemodes()

	for k, gm in ipairs( GamemodeList ) do

		local Name = gm.title or "Unnammed Gamemode"
		local Maps = string.Split( gm.maps, "|" )

		if ( Maps && gm.maps != "" ) then

			for k, pattern in ipairs( Maps ) do
				-- When in doubt, just try to match it with string.find
				MapPatterns[ string.lower( pattern ) ] = Name
			end

		end

	end

end

local favmaps

local function LoadFavourites()

	local cookiestr = cookie.GetString( "favmaps" )
	favmaps = favmaps || ( cookiestr && string.Explode( ";", cookiestr ) || {} )

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
		Category = Category or "Other"

		local fav

		if ( table.HasValue( favmaps, name ) ) then
			fav = true
		end

		local csgo = false

		if ( Category == "Counter-Strike" ) then
			if ( file.Exists( "maps/" .. name .. ".bsp", "csgo" ) ) then
				if ( file.Exists( "maps/" .. name .. ".bsp", "cstrike" ) ) then -- Map also exists in CS:GO
					csgo = true
				else
					Category = "Counter-Strike: GO"
				end
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
			-- We have to make the CS:GO name different from the CS:S name to prevent Favourites conflicts
			table.insert( MapList[ "Counter-Strike: GO" ], name .. " " )
		end

	end

end

hook.Add( "MenuStart", "FindMaps", RefreshMaps )

hook.Add( "GameContentChanged", "RefreshMaps", RefreshMaps )

function GetMapList()
	-- Nice maplist accessor instead of a global table
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
