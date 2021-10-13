
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

local function ServerSettings( pnl )

	pnl:AddControl( "Header", { Description = "#utilities.serversettings" } )

	local ConVarsDefault = {
		hostname = "Garry's Mod",
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
		sv_timeout = "65"
	}
	pnl:AddControl( "ComboBox", { MenuButton = 1, Folder = "util_server", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

	pnl:AddControl( "TextBox", { Label = "#utilities.hostname", Command = "hostname", WaitForEnter = "1" } )
	pnl:AddControl( "TextBox", { Label = "#utilities.password", Command = "sv_password", WaitForEnter = "1" } )

	pnl:AddControl( "CheckBox", { Label = "#utilities.kickerrornum", Command = "sv_kickerrornum" } )
	pnl:AddControl( "CheckBox", { Label = "#utilities.allowcslua", Command = "sv_allowcslua" } )
	pnl:AddControl( "CheckBox", { Label = "#utilities.sticktoground", Command = "sv_sticktoground", Help = true } )
	pnl:AddControl( "CheckBox", { Label = "#utilities.epickupallowed", Command = "sv_playerpickupallowed" } )
	pnl:AddControl( "CheckBox", { Label = "#utilities.falldamage", Command = "mp_falldamage" } )
	pnl:AddControl( "CheckBox", { Label = "#utilities.gmod_suit", Command = "gmod_suit" } )

	-- Fun convars
	pnl:AddControl( "Slider", { Label = "#utilities.gravity", Type = "Integer", Command = "sv_gravity", Min = "-500", Max = "1000" } )
	pnl:AddControl( "Slider", { Label = "#utilities.friction", Type = "Integer", Command = "sv_friction", Min = "0", Max = "16" } ) -- Float
	pnl:AddControl( "Slider", { Label = "#utilities.timescale", Type = "Float", Command = "phys_timescale", Min = "0", Max = "2" } )
	pnl:AddControl( "Slider", { Label = "#utilities.deployspeed", Type = "Float", Command = "sv_defaultdeployspeed", Min = "0.1", Max = "10" } )
	pnl:AddControl( "Slider", { Label = "#utilities.noclipspeed", Type = "Integer", Command = "sv_noclipspeed", Min = "1", Max = "10" } ) -- Switch this and friction back to Float once Sliders don't reset the convar from 8 to 8.00, etc
	pnl:AddControl( "Slider", { Label = "#utilities.maxammo", Type = "Integer", Command = "gmod_maxammo", Min = "0", Max = "9999", Help = true } )

	-- Technical convars
	pnl:AddControl( "Slider", { Label = "#utilities.iterations", Type = "Integer", Command = "gmod_physiterations", Min = "1", Max = "10" } )
	pnl:AddControl( "Slider", { Label = "#utilities.sv_timeout", Type = "Integer", Command = "sv_timeout", Min = "60", Max = "300" } )

end

local function SandboxClientSettings( pnl )

	pnl:AddControl( "Header", { Description = "#utilities.sandboxsettings_cl" } )

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
	}

	pnl:AddControl( "ComboBox", { MenuButton = 1, Folder = "util_sandbox_cl", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

	pnl:AddControl( "Slider", { Label = "#utilities.max_results", Type = "Integer", Command = "sbox_search_maxresults", Min = "1024", Max = "8192", Help = true } )

	local function AddCheckbox( title, cvar )
		pnl:AddControl( "CheckBox", { Label = title, Command = cvar } )
	end

	AddCheckbox( "#menubar.drawing.hud", "cl_drawhud" )
	AddCheckbox( "#menubar.drawing.toolhelp", "gmod_drawhelp" )
	AddCheckbox( "#menubar.drawing.toolui", "gmod_drawtooleffects" )
	AddCheckbox( "#menubar.drawing.world_tooltips", "cl_drawworldtooltips" )
	AddCheckbox( "#menubar.drawing.spawn_effect", "cl_drawspawneffect" )
	AddCheckbox( "#menubar.drawing.effect_rings", "cl_draweffectrings" )
	AddCheckbox( "#menubar.drawing.cameras", "cl_drawcameras" )
	AddCheckbox( "#menubar.drawing.thrusters", "cl_drawthrusterseffects" )
	AddCheckbox( "#menubar.drawing.hints", "cl_showhints" )

end

local function SandboxSettings( pnl )

	pnl:AddControl( "Header", { Description = "#utilities.sandboxsettings" } )

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

	local ConVarsLimits = {}
	for id, str in pairs( cleanup.GetTable() ) do
		local cvar = GetConVar( "sbox_max" .. str )
		if ( !cvar ) then continue end

		ConVarsDefault[ "sbox_max" .. str ] = cvar:GetDefault()
		table.insert( ConVarsLimits, {
			command = "sbox_max" .. str,
			default = cvar:GetDefault(),
			label = language.GetPhrase( "max_" .. str )
		} )
	end

	pnl:AddControl( "ComboBox", { MenuButton = 1, Folder = "util_sandbox", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

	pnl:AddControl( "TextBox", { Label = "#persistent_mode", Command = "sbox_persist", WaitForEnter = "1" } )
	pnl:ControlHelp( "#persistent_mode.help" ):DockMargin( 16, 4, 16, 8 )

	pnl:AddControl( "CheckBox", { Label = "#enable_weapons", Command = "sbox_weapons" } )
	pnl:AddControl( "CheckBox", { Label = "#allow_god_mode", Command = "sbox_godmode" } )

	pnl:ControlHelp( "#utilities.mp_only" ):DockMargin( 16, 16, 16, 4 )

	pnl:AddControl( "CheckBox", { Label = "#players_damage_players", Command = "sbox_playershurtplayers" } )
	pnl:AddControl( "CheckBox", { Label = "#allow_noclip", Command = "sbox_noclip" } )

	pnl:AddControl( "CheckBox", { Label = "#bone_manipulate_npcs", Command = "sbox_bonemanip_npc" } )
	pnl:AddControl( "CheckBox", { Label = "#bone_manipulate_players", Command = "sbox_bonemanip_player" } )
	pnl:AddControl( "CheckBox", { Label = "#bone_manipulate_others", Command = "sbox_bonemanip_misc" } )

	for id, t in SortedPairsByMemberValue( ConVarsLimits, "label" ) do
		local ctrl = pnl:AddControl( "Slider", { Label = t.label, Command = t.command, Min = "0", Max = "200" } )
		ctrl:SetHeight( 16 ) -- This makes the controls all bunched up like how we want
	end

end

local function PhysgunSettings( pnl )

	pnl:AddControl( "Header", { Description = "#utilities.physgunsettings" } )

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
	pnl:AddControl( "ComboBox", { MenuButton = 1, Folder = "util_physgun", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

	pnl:AddControl( "CheckBox", { Label = "#utilities.physgun_halo", Command = "physgun_halo" } )
	pnl:AddControl( "CheckBox", { Label = "#utilities.physgun_drawbeams", Command = "physgun_drawbeams" } )
	pnl:AddControl( "CheckBox", { Label = "#menubar.drawing.freeze", Command = "effects_freeze" } )
	pnl:AddControl( "CheckBox", { Label = "#menubar.drawing.unfreeze", Command = "effects_unfreeze" } )

	pnl:AddControl( "Slider", { Label = "#utilities.gm_snapgrid", Type = "Integer", Command = "gm_snapgrid", Min = "0", Max = "128" } )
	pnl:AddControl( "Slider", { Label = "#utilities.gm_snapangles", Type = "Integer", Command = "gm_snapangles", Min = "5", Max = "90" } )

	pnl:AddControl( "Slider", { Label = "#utilities.physgun_rotation_sensitivity", Type = "Float", Command = "physgun_rotation_sensitivity", Min = "0.01", Max = "1" } )
	pnl:AddControl( "Slider", { Label = "#utilities.physgun_wheelspeed", Type = "Integer", Command = "physgun_wheelspeed", Min = "0", Max = "50" } )

end

local function PhysgunSVSettings( pnl )

	pnl:AddControl( "Header", { Description = "#utilities.physgunsvsettings" } )

	local ConVarsDefault = {
		physgun_limited = "0",
		physgun_maxrange = "4096",
		physgun_teleportDistance = "0",
		physgun_maxSpeed = "5000",
		physgun_maxAngular = "5000",
		physgun_timeToArrive = "0.05",
		physgun_timeToArriveRagdoll = "0.1"
	}
	pnl:AddControl( "ComboBox", { MenuButton = 1, Folder = "util_physgun_sv", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

	pnl:AddControl( "CheckBox", { Label = "#utilities.physgun_limited", Command = "physgun_limited", Help = true } )

	pnl:AddControl( "Slider", { Label = "#utilities.physgun_maxrange", Type = "Integer", Command = "physgun_maxrange", Min = "128", Max = "8192" } )
	pnl:AddControl( "Slider", { Label = "#utilities.physgun_tpdist", Type = "Integer", Command = "physgun_teleportdistance", Min = "0", Max = "10000" } )
	pnl:AddControl( "Slider", { Label = "#utilities.physgun_maxspeed", Type = "Integer", Command = "physgun_maxspeed", Min = "0", Max = "10000" } )
	pnl:AddControl( "Slider", { Label = "#utilities.physgun_maxangular", Type = "Integer", Command = "physgun_maxangular", Min = "0", Max = "10000" } )
	pnl:AddControl( "Slider", { Label = "#utilities.physgun_timetoarrive", Type = "Float", Command = "physgun_timetoarrive", Min = "0", Max = "2" } )
	pnl:AddControl( "Slider", { Label = "#utilities.physgun_timetoarriveragdoll", Type = "Float", Command = "physgun_timetoarriveragdoll", Min = "0", Max = "2", Help = true } )

end

-- Tool Menu
hook.Add( "PopulateToolMenu", "PopulateUtilityMenus", function()

	spawnmenu.AddToolMenuOption( "Utilities", "User", "User_Cleanup", "#spawnmenu.utilities.cleanup", "", "", User_Cleanup )
	spawnmenu.AddToolMenuOption( "Utilities", "User", "Undo", "#spawnmenu.utilities.undo", "", "", Undo )
	spawnmenu.AddToolMenuOption( "Utilities", "User", "PhysgunSettings", "#spawnmenu.utilities.physgunsettings", "", "", PhysgunSettings )
	spawnmenu.AddToolMenuOption( "Utilities", "User", "SandboxClientSettings", "#spawnmenu.utilities.sandbox_settings", "", "", SandboxClientSettings )

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
