
--
-- The server only runs this file so it can send it to the client
--

if ( SERVER ) then AddCSLuaFile( "utilities_menu.lua" ) return end

local function Undo( CPanel )

	-- This is added by the undo module dynamically

end

local function User_Cleanup( CPanel )

	-- This is added by the cleanup module dynamically

end

local function ServerSettings( CPanel )

	CPanel:AddControl( "Header", { Description = "#utilities.serversettings" } )

	CPanel:AddControl( "TextBox", { Label = "#utilities.password", Command = "sv_password", WaitForEnter = "1" } )

	CPanel:AddControl( "CheckBox", { Label = "#utilities.kickerrornum", Command = "sv_kickerrornum" } )
	CPanel:AddControl( "CheckBox", { Label = "#utilities.allowcslua", Command = "sv_allowcslua" } )

	CPanel:AddControl( "Slider", { Label = "#utilities.gravity", Type = "Float", Command = "sv_gravity", Min = "-200", Max = "600" } )
	CPanel:AddControl( "Slider", { Label = "#utilities.timescale", Type = "Float", Command = "phys_timescale", Min = "0", Max = "2" } )
	CPanel:AddControl( "Slider", { Label = "#utilities.iterations", Type = "Integer", Command = "gmod_physiterations", Min = "1", Max = "10" } )

	CPanel:AddControl( "Header", { Description = "#utilities.sandboxsettings" } )

	CPanel:AddControl( "TextBox", { Label = "#persistent_mode", Command = "sbox_persist", WaitForEnter = "1" } )

	CPanel:AddControl( "CheckBox", { Label = "#noclip", Command = "sbox_noclip" } )
	CPanel:AddControl( "CheckBox", { Label = "#enable_weapons", Command = "sbox_weapons" } )
	CPanel:AddControl( "CheckBox", { Label = "#god_mode", Command = "sbox_godmode" } )
	CPanel:AddControl( "CheckBox", { Label = "#players_damage_players", Command = "sbox_playershurtplayers" } )
	CPanel:AddControl( "CheckBox", { Label = "#limit_physgun", Command = "physgun_limited" } )

	CPanel:AddControl( "CheckBox", { Label = "#bone_manipulate_npcs", Command = "sbox_bonemanip_npc" } )
	CPanel:AddControl( "CheckBox", { Label = "#bone_manipulate_players", Command = "sbox_bonemanip_player" } )
	CPanel:AddControl( "CheckBox", { Label = "#bone_manipulate_others", Command = "sbox_bonemanip_misc" } )

	local cleanup_types_s = {}
	for id, str in pairs( cleanup.GetTable() ) do
		cleanup_types_s[ language.GetPhrase( "#max_" .. str ) ] = str
	end

	for lbl, str in SortedPairs( cleanup_types_s ) do
		if ( !GetConVar( "sbox_max" .. str ) ) then continue end
		CPanel:AddControl( "Slider", { Label = lbl, Command = "sbox_max" .. str, Min = "0", Max = "200" } )
	end

end

-- Tool Menu
hook.Add( "PopulateToolMenu", "PopulateUtilityMenus", function()

	spawnmenu.AddToolMenuOption( "Utilities", "User", "User_Cleanup", "#spawnmenu.utilities.cleanup", "", "", User_Cleanup )
	spawnmenu.AddToolMenuOption( "Utilities", "User", "Undo", "#spawnmenu.utilities.undo", "", "", Undo )

	spawnmenu.AddToolMenuOption( "Utilities", "Admin", "Admin_Cleanup", "#spawnmenu.utilities.cleanup", "", "", User_Cleanup )
	spawnmenu.AddToolMenuOption( "Utilities", "Admin", "ServerSettings", "#spawnmenu.utilities.settings", "", "", ServerSettings )

end )

-- Categories
hook.Add( "AddToolMenuCategories", "CreateUtilitiesCategories", function()

	spawnmenu.AddToolCategory( "Utilities", "User", "#spawnmenu.utilities.user" )
	spawnmenu.AddToolCategory( "Utilities", "Admin", "#spawnmenu.utilities.admin" )

end )
