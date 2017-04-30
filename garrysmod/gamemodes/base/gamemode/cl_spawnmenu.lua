
--[[---------------------------------------------------------
	If false is returned then the spawn menu is never created.
	This saves load times if your mod doesn't actually use the
	spawn menu for any reason.
-----------------------------------------------------------]]
function GM:SpawnMenuEnabled()
	return false
end

--[[---------------------------------------------------------
  Called when spawnmenu is trying to be opened.
   Return false to dissallow it.
-----------------------------------------------------------]]
function GM:SpawnMenuOpen()
	return true
end

--[[---------------------------------------------------------
  Called when context menu is trying to be opened.
   Return false to dissallow it.
-----------------------------------------------------------]]
function GM:ContextMenuOpen()
	return false
end

--[[---------------------------------------------------------
  Called to populate the Scripted Tool menu. Overridden
   by the sandbox gamemode.
-----------------------------------------------------------]]
function GM:PopulateSTOOLMenu()
end

--[[---------------------------------------------------------
  Called right before the Lua Loaded tool menus are reloaded
-----------------------------------------------------------]]
function GM:PreReloadToolsMenu()
end

--[[---------------------------------------------------------
  Called right after the Lua Loaded tool menus are reloaded
  This is a good place to set up any ControlPanels
-----------------------------------------------------------]]
function GM:PostReloadToolsMenu()
end

--[[---------------------------------------------------------
	Guess what this does. See the bottom of stool.lua
-----------------------------------------------------------]]
function GM:PopulateToolMenu()
end

--[[---------------------------------------------------------
	+menu binds
-----------------------------------------------------------]]
concommand.Add( "+menu", function() hook.Call( "OnSpawnMenuOpen", GAMEMODE ) end, nil, "Opens the spawnmenu", { FCVAR_DONTRECORD } )
concommand.Add( "-menu", function() if ( input.IsKeyTrapping() ) then return end hook.Call( "OnSpawnMenuClose", GAMEMODE ) end, nil, "Closes the spawnmenu", { FCVAR_DONTRECORD } )

--[[---------------------------------------------------------
	+menu_context binds
-----------------------------------------------------------]]
concommand.Add( "+menu_context", function() hook.Call( "OnContextMenuOpen", GAMEMODE ) end, nil, "Opens the context menu", { FCVAR_DONTRECORD } )
concommand.Add( "-menu_context", function() if ( input.IsKeyTrapping() ) then return end hook.Call( "OnContextMenuClose", GAMEMODE ) end, nil, "Closes the context menu", { FCVAR_DONTRECORD } )
