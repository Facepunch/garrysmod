
local TranslateNames = {
	["Effects"] = "#effects_pp",
	["Overlay"] = "#overlay_pp",
	["Shaders"] = "#shaders_pp",
	["Texturize"] = "#texturize_pp"
}

local function AddPPToCategory( pp, className, propPanel )
	if ( pp.func ) then
		pp.func( propPanel )
		return
	end

	return spawnmenu.CreateContentIcon( "postprocess", propPanel, {
		name	= pp.label or className,
		icon	= pp.icon
	} )
end

hook.Add( "PopulatePostProcess", "AddPostProcess", function( pnlContent, tree, node )

	local options = {}

	options.memberSortName = "label"
	options.defaultCategoryIcon = "icon16/picture.png"
	options.categoryMemberName = "category"
	options.headerMemberName = "categoryHeader"
	options.translationMap = TranslateNames
	options.iconBuildFunc = AddPPToCategory

	pnlContent:PopulateFromList( "PostProcess", tree, options )

	-- Select the first node
	local FirstNode = tree:Root():GetChildNode( 0 )
	if ( IsValid( FirstNode ) ) then
		FirstNode:InternalDoClick()
	end

end )

spawnmenu.AddCreationTab( "#spawnmenu.category.postprocess", function()

	local ctrl = vgui.Create( "SpawnmenuContentPanel" )
	ctrl:CallPopulateHook( "PopulatePostProcess" )
	return ctrl

end, "icon16/picture.png", 100 )
