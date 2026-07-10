
local TranslateNames = {
	["Editors"] = "#spawnmenu.category.editors",
	["Fun + Games"] = "#spawnmenu.category.fun_games",
	["Other"] = "#spawnmenu.category.other"
}

local function CreateEntityIcon( ent, propPanel )
	return spawnmenu.CreateContentIcon( ent.ScriptedEntityType or "entity", propPanel, {
		nicename	= ent.PrintName or ent.SpawnName,
		spawnname	= ent.SpawnName,
		material	= ent.IconOverride or ( "entities/" .. ent.SpawnName .. ".png" ),
		admin		= ent.AdminOnly
	} )
end

list.Set( "ContentCategoryIcons", "Half-Life: Source", "games/16/hl1.png" )
list.Set( "ContentCategoryIcons", "Half-Life 2", "games/16/hl2.png" )
list.Set( "ContentCategoryIcons", "Portal", "games/16/portal.png" )

hook.Add( "PopulateEntities", "AddEntityContent", function( pnlContent, tree, browseNode )

	pnlContent:PopulateFromList( "SpawnableEntities", tree, {
		SortName = "PrintName",
		CategoryIcon = "icon16/bricks.png",
		TranslateNames = TranslateNames,
		CreateIconFunc = CreateEntityIcon
	} )

end )

spawnmenu.AddCreationTab( "#spawnmenu.category.entities", function()

	local ctrl = vgui.Create( "SpawnmenuContentPanel" )
	ctrl:EnableSearch( "entities", "PopulateEntities" )
	ctrl:CallPopulateHook( "PopulateEntities" )

	return ctrl

end, "icon16/bricks.png", 20 )
