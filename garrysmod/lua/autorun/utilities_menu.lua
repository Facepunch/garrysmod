
--
-- The server only runs this file so it can send it to the client
--

if ( SERVER ) then AddCSLuaFile( "utilities_menu.lua" ) return end


local function Undo( CPanel )

	CPanel:AddControl( "Header", { Text = "#Undo" }  )
	
	-- The rest is added by the undo module dynamically
	
end

local function User_Cleanup( CPanel )

	CPanel:AddControl( "Header", { Text = "#Cleanup" }  )
	
	-- The rest is added by the undo module dynamically
	
end

local function ServerSettings( CPanel )

	CPanel:AddControl( "Header", { Text = "#Server Settings" }  )
		
	CPanel:AddControl( "TextBox", 	{ Label = "#Server Password",			Command = "sv_password", 	WaitForEnter =	"1" }  )	
	
	-- Not needed anymore
	--CPanel:AddControl( "Button", 	{ Label = "#Enable/Disable AI",			Command = "ai_disable", 	Text = "Toggle" }  )	
	
	-- sbox_maxnpcs 0
	--CPanel:AddControl( "CheckBox", 	{ Label = "#Allow NPCs",				Command = "sbox_allownpcs" }  )	
	
	CPanel:AddControl( "CheckBox", 	{ Label = "#Allow Flying (Noclip)",		Command = "sbox_noclip" }  )	
	CPanel:AddControl( "CheckBox", 	{ Label = "#Allow Weapons",				Command = "sbox_weapons" }  )
	CPanel:AddControl( "CheckBox", 	{ Label = "#God Mode",					Command = "sbox_godmode" }  )	
	CPanel:AddControl( "CheckBox", 	{ Label = "#Enable PvP Damage",			Command = "sbox_playershurtplayers" }  )	
	
	CPanel:AddControl( "Slider", 	{ Label = "#Gravity", Type = "Float", 	Command = "sv_gravity", 	Min = "-200", 	Max = "600" }  )
	CPanel:AddControl( "Slider", 	{ Label = "#Physics Timescale",	Type = "Float", 	Command = "phys_timescale", 	Min = "0", 	Max = "2" }  )
	CPanel:AddControl( "Slider", 	{ Label = "#Physics Iterations", Type = "Integer", 	Command = "gmod_physiterations", 	Min = "1", 	Max = "10" }  )
	
end


	
--[[
-- Tool Menu
--]]
local function PopulateUtilityMenus()

	spawnmenu.AddToolMenuOption( "Utilities", "User", 	"User_Cleanup",	"#Cleanup", 	"", 	"", 	User_Cleanup )
	spawnmenu.AddToolMenuOption( "Utilities", "User", 	"Undo", 	"#Undo", 			"", 	"", 	Undo )
	
	spawnmenu.AddToolMenuOption( "Utilities", "Admin", 	"Admin_Cleanup", 	"#Cleanup", 	"", 	"", 	User_Cleanup )
	spawnmenu.AddToolMenuOption( "Utilities", "Admin", 	"ServerSettings", 	"#Settings", 	"", 	"", 	ServerSettings )

end

hook.Add( "PopulateToolMenu", "PopulateUtilityMenus", PopulateUtilityMenus )

--[[ 
-- Categories
--]]
local function CreateUtilitiesCategories()

	spawnmenu.AddToolCategory( "Utilities", 	"User", 	"#User" )
	spawnmenu.AddToolCategory( "Utilities", 	"Admin", 	"#Admin" )

end	

hook.Add( "AddToolMenuCategories", "CreateUtilitiesCategories", CreateUtilitiesCategories )