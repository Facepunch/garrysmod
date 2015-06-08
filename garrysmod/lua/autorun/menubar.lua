
AddCSLuaFile()

if ( SERVER ) then return end

-- Display options

hook.Add( "PopulateMenuBar", "DisplayOptions_MenuBar", function( menubar )

	local m = menubar:AddOrGetMenu( "Drawing" )

	m:AddCVar( "Physgun Grab Halo", "physgun_halo", "1", "0" )
	m:AddCVar( "Physgun Beams", "physgun_drawbeams", "1", "0" )

	m:AddSpacer()

	m:AddCVar( "Draw HUD", "cl_drawhud", "1", "0" )
	m:AddCVar( "Draw Freeze", "effects_freeze", "1", "0" )
	m:AddCVar( "Draw Cameras", "cl_drawcameras", "1", "0" )
	m:AddCVar( "Draw Unfreeze", "effects_unfreeze", "1", "0" )
	m:AddCVar( "Draw Thrusters", "cl_drawthrusterseffects", "1", "0" )
	m:AddCVar( "Draw Toolgun Help", "gmod_drawhelp", "1", "0" )
	m:AddCVar( "Draw Effect Rings", "cl_draweffectrings", "1", "0" )
	m:AddCVar( "Draw Spawn Effect", "cl_drawspawneffect", "1", "0" )
	m:AddCVar( "Draw World Tooltips", "cl_drawworldtooltips", "1", "0" )

	m:AddSpacer()

	m:AddCVar( "Draw Shadows", "r_shadows", "1", "0" )	
	m:AddCVar( "Detail Props", "r_drawdetailprops", "1", "0" )

	m:AddSpacer()

	m:AddCVar( "Show FPS", "cl_showfps", "1", "0" )
	m:AddCVar( "Minecraftify", "mat_showlowresimage", "1", "0", function() timer.Simple( 0.1, function() RunConsoleCommand( "mat_reloadallmaterials" ) end ) end )
	m:AddCVar( "Wireframe", "mat_wireframe", "1", "0" )

	m:AddSpacer()

	m:AddCVar( "Hints", "cl_showhints", "1", "0" )

end )

-- AI Options

hook.Add( "PopulateMenuBar", "NPCOptions_MenuBar", function( menubar )

	local m = menubar:AddOrGetMenu( "NPCs" )
	
	m:AddCVar( "Disable Thinking", "ai_disabled", "1", "0" )
	m:AddCVar( "Ignore Players", "ai_ignoreplayers", "1", "0" )
	m:AddCVar( "Keep Corpses", "ai_serverragdolls", "1", "0" )
	m:AddCVar( "Join Player's Squad", "npc_citizen_auto_player_squad", "1", "0" )

	local weapons = m:AddSubMenu( "Weapon Override" )

	weapons:SetDeleteSelf( false )
	weapons:AddCVar( "Default Weapon", "gmod_npcweapon", "" )
	weapons:AddCVar( "#None", "gmod_npcweapon", "none" )
	weapons:AddSpacer()

	for _, v in pairs( list.Get( "NPCUsableWeapons" ) ) do

		weapons:AddCVar( v.title, "gmod_npcweapon", v.class )

	end

end )
