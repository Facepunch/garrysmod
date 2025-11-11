
local TranslateNames = {
	["Editors"] = "#spawnmenu.category.editors",
	["Fun + Games"] = "#spawnmenu.category.fun_games",
	["Other"] = "#spawnmenu.category.other"
}

local function AddEntityToCategory( ent, className, propPanel )
	return spawnmenu.CreateContentIcon( ent.ScriptedEntityType or "entity", propPanel, {
		nicename	= ent.PrintName or className,
		spawnname	= className,
		material	= ent.IconOverride or ( "entities/" .. className .. ".png" ),
		admin		= ent.AdminOnly
	} )
end

list.Set( "ContentCategoryIcons", "Half-Life: Source", "games/16/hl1.png" )
list.Set( "ContentCategoryIcons", "Half-Life 2", "games/16/hl2.png" )
list.Set( "ContentCategoryIcons", "Portal", "games/16/portal.png" )

hook.Add( "PopulateEntities", "AddEntityContent", function( pnlContent, tree, browseNode )

	local options = {}

	options.memberSortName = "PrintName"
	options.defaultCategoryIcon = "icon16/bricks.png"
	options.translationMap = TranslateNames
	options.iconBuildFunc = AddEntityToCategory

	spawnmenu.PopulateCreationTabFromList( "SpawnableEntities", pnlContent, tree, options )

	-- Select the first node
	local FirstNode = tree:Root():GetChildNode( 0 )
	if ( IsValid( FirstNode ) ) then
		FirstNode:InternalDoClick()
	end

end )

spawnmenu.AddCreationTab( "#spawnmenu.category.entities", function()

	local ctrl = vgui.Create( "SpawnmenuContentPanel" )
	ctrl:EnableSearch( "entities", "PopulateEntities" )
	ctrl:CallPopulateHook( "PopulateEntities" )

	return ctrl

end, "icon16/bricks.png", 20 )
