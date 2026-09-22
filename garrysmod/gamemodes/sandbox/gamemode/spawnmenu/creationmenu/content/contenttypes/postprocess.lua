
local TranslateNames = {
	["Effects"] = "#effects_pp",
	["Overlay"] = "#overlay_pp",
	["Shaders"] = "#shaders_pp",
	["Texturize"] = "#texturize_pp"
}

local function CreatePostProcessIcon( pp, propPanel )
	if ( pp.func ) then
		return pp.func( propPanel )
	end

	return spawnmenu.CreateContentIcon( "postprocess", propPanel, {
		name	= pp.SpawnName,
		icon	= pp.icon
	} )
end

hook.Add( "PopulatePostProcess", "AddPostProcess", function( pnlContent, tree, node )

	pnlContent:PopulateFromList( "PostProcess", tree, {
		SortName = "SpawnName",
		CategoryIcon = "icon16/picture.png",
		TranslateNames = TranslateNames,
		CreateIconFunc = CreatePostProcessIcon
	} )

end )

spawnmenu.AddCreationTab( "#spawnmenu.category.postprocess", function()

	local ctrl = vgui.Create( "SpawnmenuContentPanel" )
	ctrl:CallPopulateHook( "PopulatePostProcess" )
	return ctrl

end, "icon16/picture.png", 100 )
