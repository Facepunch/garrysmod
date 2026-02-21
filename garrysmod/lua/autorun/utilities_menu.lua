
--
-- The server only runs this file so it can send it to the client
--

if ( SERVER ) then AddCSLuaFile( "utilities_menu.lua" ) return end

local function Undo( pnl )

	-- This is added by the undo module dynamically

end

local function User_Cleanup( pnl )

	-- This is added by the cleanup module dynamically

end

local function LoadInConvarDefaults( cvars )
	for k, v in pairs( cvars ) do
		local convar = GetConVar( k )
		if ( convar and convar:GetDefault():len() != 0 ) then
			cvars[ k ] = convar:GetDefault()
		end
	end
end

local function ServerSettings( pnl )

	pnl:Help( "#utilities.serversettings" )

	local ConVarsDefault = {
		hostname = "My Garry's Mod Server",
		-- sv_password = "", -- Can't be read by addons/servers
		sv_kickerrornum = "0",
		sv_allowcslua = "0",
		sv_sticktoground = "1",
		sv_playerpickupallowed = "1",
		mp_falldamage = "0",
		gmod_suit = "0",
		gmod_maxammo = "9999",
		sv_gravity = "600",
		sv_friction = "8",
		phys_timescale = "1.00",
		gmod_physiterations = "4",
		sv_defaultdeployspeed = "4.00",
		sv_noclipspeed = "5",
		g_ragdoll_maxcount = "32",
		sv_timeout = "65"
	}
	LoadInConvarDefaults( ConVarsDefault )
	pnl:ToolPresets( "util_server", ConVarsDefault )

	pnl:TextEntry( "#utilities.hostname", "hostname" )
	pnl:TextEntry( "#utilities.password", "sv_password" )

	pnl:CheckBox( "#utilities.kickerrornum", "sv_kickerrornum" )
	pnl:CheckBox( "#utilities.allowcslua", "sv_allowcslua" )

	pnl:CheckBox( "#utilities.sticktoground", "sv_sticktoground" )
	pnl:ControlHelp( "#utilities.sticktoground.help" ):DockMargin( 32, 4, 32, 8 ) -- 4 extra on top

	pnl:CheckBox( "#utilities.epickupallowed", "sv_playerpickupallowed" )
	pnl:CheckBox( "#utilities.falldamage", "mp_falldamage" )
	pnl:CheckBox( "#utilities.gmod_suit", "gmod_suit" )

	-- Fun convars
	pnl:NumSlider( "#utilities.gravity", "sv_gravity", -500, 1000, 0 )
	pnl:NumSlider( "#utilities.friction", "sv_friction", 0, 16, 0 )
	pnl:NumSlider( "#utilities.timescale", "phys_timescale", 0, 2 )
	pnl:NumSlider( "#utilities.deployspeed", "sv_defaultdeployspeed", 0.1, 10 )
	pnl:NumSlider( "#utilities.noclipspeed", "sv_noclipspeed", 1, 10, 0 ) -- TODO: Switch this and friction back to Float once the sliders dont reset the convar from 8 to 8.00

	pnl:NumSlider( "#utilities.maxammo", "gmod_maxammo", 0, 9999, 0 )
	pnl:ControlHelp( "#utilities.maxammo.help" )

	pnl:NumSlider( "#utilities.max_ragdolls", "g_ragdoll_maxcount", 0, 128, 0 )

	-- Technical convars
	pnl:NumSlider( "#utilities.iterations", "gmod_physiterations", 1, 10, 0 )
	pnl:NumSlider( "#utilities.sv_timeout", "sv_timeout", 60, 300, 0 )

end

local function SandboxClientSettings( pnl )

	pnl:Help( "#utilities.sandboxsettings_cl" )

	local ConVarsDefault = {
		sbox_search_maxresults = "1024",
		cl_drawhud = "1",
		gmod_drawhelp = "1",
		gmod_drawtooleffects = "1",
		cl_drawworldtooltips = "1",
		cl_drawspawneffect = "1",
		cl_draweffectrings = "1",
		cl_drawcameras = "1",
		cl_drawthrusterseffects = "1",
		cl_showhints = "1",
		spawnmenu_toggle = "0",
	}
	LoadInConvarDefaults( ConVarsDefault )
	pnl:ToolPresets( "util_sandbox_cl", ConVarsDefault )

	pnl:NumSlider( "#utilities.max_results", "sbox_search_maxresults", 1024, 8192, 0 )
	pnl:ControlHelp( "#utilities.max_results.help" )

	pnl:CheckBox( "#menubar.drawing.hud", "cl_drawhud" )
	pnl:CheckBox( "#menubar.drawing.toolhelp", "gmod_drawhelp" )
	pnl:CheckBox( "#menubar.drawing.toolui", "gmod_drawtooleffects" )
	pnl:CheckBox( "#menubar.drawing.world_tooltips", "cl_drawworldtooltips" )
	pnl:CheckBox( "#menubar.drawing.spawn_effect", "cl_drawspawneffect" )
	pnl:CheckBox( "#menubar.drawing.effect_rings", "cl_draweffectrings" )
	pnl:CheckBox( "#menubar.drawing.cameras", "cl_drawcameras" )
	pnl:CheckBox( "#menubar.drawing.thrusters", "cl_drawthrusterseffects" )
	pnl:CheckBox( "#menubar.drawing.hints", "cl_showhints" )

	pnl:CheckBox( "#utilities.spawnmenu_toggle", "spawnmenu_toggle" )
	pnl:ControlHelp( "#utilities.spawnmenu_toggle.help" ):DockMargin( 32, 4, 32, 8 ) -- 4 extra on top

end

local function SandboxSettings( pnl )

	pnl:Help( "#utilities.sandboxsettings" )

	local ConVarsDefault = {
		sbox_persist = "",
		sbox_noclip = "1",
		sbox_weapons = "1",
		sbox_godmode = "0",
		sbox_playershurtplayers = "1",
		physgun_limited = "0",
		physgun_maxrange = "4096",
		sbox_bonemanip_npc = "1",
		sbox_bonemanip_player = "0",
		sbox_bonemanip_misc = "0"
	}
	LoadInConvarDefaults( ConVarsDefault )

	local ConVarsLimits = {}
	for id, str in pairs( cleanup.GetTable() ) do
		local cvar = GetConVar( "sbox_max" .. str )
		if ( !cvar ) then continue end

		ConVarsDefault[ "sbox_max" .. str ] = cvar:GetDefault()
		table.insert( ConVarsLimits, {
			command = "sbox_max" .. str,
			default = cvar:GetDefault(),
			label = language.GetPhrase( "max_" .. str ),
			min = 0,
			max = math.max( 200, cvar:GetDefault() * 1.4 )
		} )
	end

	pnl:ToolPresets( "util_sandbox", ConVarsDefault )

	pnl:TextEntry( "#persistent_mode", "sbox_persist" )
	pnl:ControlHelp( "#persistent_mode.help" ):DockMargin( 16, 4, 16, 8 )

	pnl:CheckBox( "#enable_weapons", "sbox_weapons" )
	pnl:CheckBox( "#allow_god_mode", "sbox_godmode" )

	pnl:ControlHelp( "#utilities.mp_only" ):DockMargin( 16, 16, 16, 4 )

	pnl:CheckBox( "#players_damage_players", "sbox_playershurtplayers" )
	pnl:CheckBox( "#allow_noclip", "sbox_noclip" )

	pnl:CheckBox( "#bone_manipulate_npcs", "sbox_bonemanip_npc" )
	pnl:CheckBox( "#bone_manipulate_players", "sbox_bonemanip_player" )
	pnl:CheckBox( "#bone_manipulate_others", "sbox_bonemanip_misc" )

	for id, t in SortedPairsByMemberValue( ConVarsLimits, "label" ) do
		pnl:NumSlider( t.label, t.command, t.min, t.max, 0 ):SetHeight( 16 ) -- This makes the controls all bunched up like how we want
	end

end

local function PhysgunSettings( pnl )

	pnl:Help( "#utilities.physgunsettings" )

	local ConVarsDefault = {
		physgun_halo = "1",
		physgun_drawbeams = "1",
		effects_freeze = "1",
		effects_unfreeze = "1",
		gm_snapgrid = "0",
		gm_snapangles = "45",
		physgun_rotation_sensitivity = "0.05",
		physgun_wheelspeed = "10"
	}
	LoadInConvarDefaults( ConVarsDefault )
	pnl:ToolPresets( "util_physgun", ConVarsDefault )

	pnl:CheckBox( "#utilities.physgun_halo", "physgun_halo" )
	pnl:CheckBox( "#utilities.physgun_drawbeams", "physgun_drawbeams" )
	pnl:CheckBox( "#menubar.drawing.freeze", "effects_freeze" )
	pnl:CheckBox( "#menubar.drawing.unfreeze", "effects_unfreeze" )

	pnl:NumSlider( "#utilities.gm_snapgrid", "gm_snapgrid", 0, 128, 0 )
	pnl:NumSlider( "#utilities.gm_snapangles", "gm_snapangles", 5, 90, 0 )

	pnl:NumSlider( "#utilities.physgun_rotation_sensitivity", "physgun_rotation_sensitivity", 0.01, 1, 2 )
	pnl:NumSlider( "#utilities.physgun_wheelspeed", "physgun_wheelspeed", 0, 50, 0 )

end

local function PhysgunSVSettings( pnl )

	pnl:Help( "#utilities.physgunsvsettings" )

	local ConVarsDefault = {
		physgun_limited = "0",
		physgun_maxrange = "4096",
		physgun_teleportDistance = "0",
		physgun_maxSpeed = "5000",
		physgun_maxAngular = "5000",
		physgun_timeToArrive = "0.05",
		physgun_timeToArriveRagdoll = "0.1"
	}
	LoadInConvarDefaults( ConVarsDefault )
	pnl:ToolPresets( "util_physgun_sv", ConVarsDefault )

	pnl:CheckBox( "#utilities.physgun_limited", "physgun_limited" )
	pnl:ControlHelp( "#utilities.physgun_limited.help" ):DockMargin( 32, 4, 32, 8 ) -- 4 extra on top

	pnl:NumSlider( "#utilities.physgun_maxrange", "physgun_maxrange", 128, 8192, 0 )
	pnl:NumSlider( "#utilities.physgun_tpdist", "physgun_teleportdistance", 0, 10000, 0 )
	pnl:NumSlider( "#utilities.physgun_maxspeed", "physgun_maxspeed", 0, 10000, 0 )
	pnl:NumSlider( "#utilities.physgun_maxangular", "physgun_maxangular", 0, 10000, 0 )
	pnl:NumSlider( "#utilities.physgun_timetoarrive", "physgun_timetoarrive", 0, 2, 2 )
	pnl:NumSlider( "#utilities.physgun_timetoarriveragdoll", "physgun_timetoarriveragdoll", 0, 2, 2 )
	pnl:ControlHelp( "#utilities.physgun_timetoarriveragdoll.help" )

end

local function PlayerOptions( pnl )

	pnl:Help( "#smwidget.playermodel_title" )

	pnl:Button( "#smwidget.playermodel_title", "open_playermodel_selector" )

end

-- Tool Menu
hook.Add( "PopulateToolMenu", "PopulateUtilityMenus", function()

	spawnmenu.AddToolMenuOption( "Utilities", "User", "User_Cleanup", "#spawnmenu.utilities.cleanup", "", "", User_Cleanup )
	spawnmenu.AddToolMenuOption( "Utilities", "User", "Undo", "#spawnmenu.utilities.undo", "", "", Undo )
	spawnmenu.AddToolMenuOption( "Utilities", "User", "PhysgunSettings", "#spawnmenu.utilities.physgunsettings", "", "", PhysgunSettings )
	spawnmenu.AddToolMenuOption( "Utilities", "User", "SandboxClientSettings", "#spawnmenu.utilities.sandbox_settings", "", "", SandboxClientSettings )
	spawnmenu.AddToolMenuOption( "Utilities", "User", "PlayerModelSelector", "#smwidget.playermodel_title", "", "", PlayerOptions )

	spawnmenu.AddToolMenuOption( "Utilities", "Admin", "Admin_Cleanup", "#spawnmenu.utilities.cleanup", "", "", User_Cleanup )
	spawnmenu.AddToolMenuOption( "Utilities", "Admin", "ServerSettings", "#spawnmenu.utilities.server_settings", "", "", ServerSettings )
	spawnmenu.AddToolMenuOption( "Utilities", "Admin", "SandboxSettings", "#spawnmenu.utilities.sandbox_settings", "", "", SandboxSettings )
	spawnmenu.AddToolMenuOption( "Utilities", "Admin", "PhysgunSVSettings", "#spawnmenu.utilities.physgunsettings", "", "", PhysgunSVSettings )

end )

-- Categories
hook.Add( "AddToolMenuCategories", "CreateUtilitiesCategories", function()

	spawnmenu.AddToolCategory( "Utilities", "User", "#spawnmenu.utilities.user" )
	spawnmenu.AddToolCategory( "Utilities", "Admin", "#spawnmenu.utilities.admin" )

end )
