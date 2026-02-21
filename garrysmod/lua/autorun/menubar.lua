
AddCSLuaFile()

if ( SERVER ) then return end

local checkList = {}
checkList[ "cheat" ] = { tooltip = "#menubar.cheatstip", func = function() return GetConVarNumber( "sv_cheats" ) != 0 end }
checkList[ "cheatSP" ] = { tooltip = "#menubar.cheatstip", func = function() return GetConVarNumber( "sv_cheats" ) != 0 or game.SinglePlayer() end }
checkList[ "host" ] = { tooltip = "#menubar.host_only", func = function() return IsValid( LocalPlayer() ) and LocalPlayer():IsListenServerHost() end }

local function AddCVar( s, checkStr, ... )
	local cvar = s:AddCVar( ... )
	cvar.OldThink = cvar.Think
	cvar.Think = function( se )
		se:OldThink()
		local checks = string.Split( checkStr, " " )
		for k, v in ipairs( checks ) do
			if ( checkList[ v ] and !checkList[ v ].func() ) then
				se:SetEnabled( false )
				se:SetTooltip( checkList[ v ].tooltip )
				return
			end
		end

		se:SetEnabled( true )
		se:SetTooltip()
	end
end

local function AddHostCVar( s, ... ) AddCVar( s, "host", ... ) end
local function AddCheatCVar( s, ... ) AddCVar( s, "cheat", ... ) end
local function AddCheatOrSPCVar( s, ... ) AddCVar( s, "cheatSP host", ... ) end

-- Display options
hook.Add( "PopulateMenuBar", "DisplayOptions_MenuBar", function( menubar )

	local m = menubar:AddOrGetMenu( "#menubar.drawing" )

	m:AddCVar( "#menubar.drawing.physgun_beam", "physgun_drawbeams", "1", "0" )
	m:AddCVar( "#menubar.drawing.physgun_halo", "physgun_halo", "1", "0" )
	m:AddCVar( "#menubar.drawing.freeze", "effects_freeze", "1", "0" )
	m:AddCVar( "#menubar.drawing.unfreeze", "effects_unfreeze", "1", "0" )

	m:AddSpacer()

	m:AddCVar( "#menubar.drawing.hud", "cl_drawhud", "1", "0" )
	m:AddCVar( "#menubar.drawing.toolhelp", "gmod_drawhelp", "1", "0" )
	m:AddCVar( "#menubar.drawing.toolui", "gmod_drawtooleffects", "1", "0" )
	m:AddCVar( "#menubar.drawing.world_tooltips", "cl_drawworldtooltips", "1", "0" )
	m:AddCVar( "#menubar.drawing.spawn_effect", "cl_drawspawneffect", "1", "0" )
	m:AddCVar( "#menubar.drawing.effect_rings", "cl_draweffectrings", "1", "0" )
	m:AddCVar( "#menubar.drawing.cameras", "cl_drawcameras", "1", "0" )
	m:AddCVar( "#menubar.drawing.thrusters", "cl_drawthrusterseffects", "1", "0" )

	m:AddSpacer()

	m:AddCVar( "#menubar.drawing.shadows", "r_shadows", "1", "0" )
	m:AddCVar( "#menubar.drawing.detailprops", "r_drawdetailprops", "1", "0" )

	m:AddSpacer()

	m:AddCVar( "#menubar.drawing.showfps", "cl_showfps", "1", "0" )

	AddCheatOrSPCVar( m, "#menubar.drawing.minecraftify", "mat_showlowresimage", "1", "0", function() timer.Simple( 0.1, function() RunConsoleCommand( "mat_reloadallmaterials" ) end ) end )
	AddCheatCVar( m, "#menubar.drawing.wireframe", "mat_wireframe", "1", "0" )

	m:AddSpacer()

	m:AddCVar( "#menubar.drawing.hints", "cl_showhints", "1", "0" )

end )

-- AI Options
hook.Add( "PopulateMenuBar", "NPCOptions_MenuBar", function( menubar )

	local m = menubar:AddOrGetMenu( "#menubar.npcs" )

	AddHostCVar( m, "#menubar.npcs.disableai", "ai_disabled", "1", "0" )
	AddHostCVar( m, "#menubar.npcs.ignoreplayers", "ai_ignoreplayers", "1", "0" )
	AddHostCVar( m, "#menubar.npcs.keepcorpses", "ai_serverragdolls", "1", "0" )
	AddHostCVar( m, "#menubar.npcs.autoplayersquad", "npc_citizen_auto_player_squad", "1", "0" )

	local wpns = m:AddSubMenu( "#menubar.npcs.weapon" )

	wpns:SetDeleteSelf( false )
	wpns:AddCVar( "#menubar.npcs.defaultweapon", "gmod_npcweapon", "" )
	wpns:AddCVar( "#menubar.npcs.noweapon", "gmod_npcweapon", "none" )
	wpns:AddSpacer()

	local groupedWeps = {}
	for _, v in pairs( list.Get( "NPCUsableWeapons" ) ) do
		local cat = ( v.category or "" ):lower()
		groupedWeps[ cat ] = groupedWeps[ cat ] or {}
		groupedWeps[ cat ][ v.class ] = language.GetPhrase( v.title )
	end

	for group, items in SortedPairs( groupedWeps ) do
		wpns:AddSpacer()
		for class, title in SortedPairsByValue( items ) do
			wpns:AddCVar( title, "gmod_npcweapon", class )
		end
	end

end )

-- Server options
hook.Add( "PopulateMenuBar", "MenuBar_ServerOptions", function( menubar )

	local m = menubar:AddOrGetMenu( "#menubar.server" )

	AddHostCVar( m, "#utilities.allowcslua", "sv_allowcslua", "1", "0" )
	AddHostCVar( m, "#utilities.falldamage", "mp_falldamage", "1", "0" )
	AddHostCVar( m, "#utilities.gmod_suit", "gmod_suit", "1", "0" )
	AddCheatOrSPCVar( m, "#physcannon_mega_enabled", "physcannon_mega_enabled", "1", "0" )

	m:AddSpacer()
	AddHostCVar( m, "#enable_weapons", "sbox_weapons", "1", "0" )
	AddHostCVar( m, "#allow_god_mode", "sbox_godmode", "1", "0" )

	m:AddSpacer()
	AddHostCVar( m, "#players_damage_players", "sbox_playershurtplayers", "1", "0" )
	AddHostCVar( m, "#allow_noclip", "sbox_noclip", "1", "0" )
	AddHostCVar( m, "#bone_manipulate_npcs", "sbox_bonemanip_npc", "1", "0" )
	AddHostCVar( m, "#bone_manipulate_players", "sbox_bonemanip_player", "1", "0" )
	AddHostCVar( m, "#bone_manipulate_others", "sbox_bonemanip_misc", "1", "0" )

end )
