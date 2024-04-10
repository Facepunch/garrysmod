
include( "spawnmenu/spawnmenu.lua" )

--[[---------------------------------------------------------
	If false is returned then the spawn menu is never created.
	This saves load times if your mod doesn't actually use the
	spawn menu for any reason.
-----------------------------------------------------------]]
function GM:SpawnMenuEnabled()
	return true
end

--[[---------------------------------------------------------
	Called when spawnmenu is trying to be opened.
	Return false to dissallow it.
-----------------------------------------------------------]]
function GM:SpawnMenuOpen()
	return true
end

function GM:SpawnMenuOpened()
	self:SuppressHint( "OpeningMenu" )
	self:AddHint( "OpeningContext", 20 )
	self:AddHint( "EditingSpawnlists", 5 )
end

function GM:SpawnMenuClosed()
end

function GM:SpawnMenuCreated(spawnmenu)
end

--[[---------------------------------------------------------
	If false is returned then the context menu is never created.
	This saves load times if your mod doesn't actually use the
	context menu for any reason.
-----------------------------------------------------------]]
function GM:ContextMenuEnabled()
	return true
end

--[[---------------------------------------------------------
	Called when context menu is trying to be opened.
	Return false to dissallow it.
-----------------------------------------------------------]]
function GM:ContextMenuOpen()
	return true
end

function GM:ContextMenuOpened()
	self:SuppressHint( "OpeningContext" )
	self:AddHint( "ContextClick", 20 )
end

function GM:ContextMenuClosed()
end

function GM:ContextMenuCreated()
end

--[[---------------------------------------------------------
	Backwards compatibility. Do Not Use!!!
-----------------------------------------------------------]]
function GM:GetSpawnmenuTools( name )
	return spawnmenu.GetToolMenu( name )
end

--[[---------------------------------------------------------
	Backwards compatibility. Do Not Use!!!
-----------------------------------------------------------]]
function GM:AddSTOOL( category, itemname, text, command, controls, cpanelfunction )
	self:AddToolMenuOption( "Main", category, itemname, text, command, controls, cpanelfunction )
end

function GM:PreReloadToolsMenu()
end

--[[---------------------------------------------------------
	Don't hook or override this function.
	Hook AddToolMenuTabs instead!
-----------------------------------------------------------]]
function GM:AddGamemodeToolMenuTabs()

	-- This is named like this to force it to be the first tab
	spawnmenu.AddToolTab( "Main",		"#spawnmenu.tools_tab", "icon16/wrench.png" )
	spawnmenu.AddToolTab( "Utilities",	"#spawnmenu.utilities_tab", "icon16/page_white_wrench.png" )

end

--[[---------------------------------------------------------
	Add your custom tabs here.
-----------------------------------------------------------]]
function GM:AddToolMenuTabs()

	-- Hook me!

end

--[[---------------------------------------------------------
	Add categories to your tabs
-----------------------------------------------------------]]
function GM:AddGamemodeToolMenuCategories()

	spawnmenu.AddToolCategory( "Main", "Constraints",	"#spawnmenu.tools.constraints" )
	spawnmenu.AddToolCategory( "Main", "Construction",	"#spawnmenu.tools.construction" )
	spawnmenu.AddToolCategory( "Main", "Poser",			"#spawnmenu.tools.posing" )
	spawnmenu.AddToolCategory( "Main", "Render",		"#spawnmenu.tools.render" )

end

--[[---------------------------------------------------------
	Add categories to your tabs
-----------------------------------------------------------]]
function GM:AddToolMenuCategories()

	-- Hook this function to add custom stuff

end

function GM:PopulateToolMenu()
end

function GM:PostReloadToolsMenu()
end

--[[---------------------------------------------------------
	Add categories to your tabs
-----------------------------------------------------------]]
function GM:PopulatePropMenu()

	-- This function makes the engine load the spawn menu text files.
	-- We call it here so that any gamemodes not using the default
	-- spawn menu can totally not call it.
	spawnmenu.PopulateFromEngineTextFiles()

end
