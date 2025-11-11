
local TranslateNames = {
	["Chairs"] = "#spawnmenu.category.chairs",
	["Other"] = "#spawnmenu.category.other"
}

local function AddVehicleToCategory( veh, className, propPanel )
	return spawnmenu.CreateContentIcon( "vehicle", propPanel, {
		nicename	= veh.Name or className,
		spawnname	= className,
		material	= veh.IconOverride or "entities/" .. className .. ".png",
		admin		= veh.AdminOnly
	} )
end

hook.Add( "PopulateVehicles", "AddEntityContent", function( pnlContent, tree, browseNode )

	local options = {}

	options.memberSortName = "Name"
	options.defaultCategoryIcon = "icon16/bricks.png"
	options.translationMap = TranslateNames
	options.iconBuildFunc = AddVehicleToCategory

	spawnmenu.PopulateCreationTabFromList( "Vehicles", pnlContent, tree, options )

	-- Select the first node
	local FirstNode = tree:Root():GetChildNode( 0 )
	if ( IsValid( FirstNode ) ) then
		FirstNode:InternalDoClick()
	end

end )

spawnmenu.AddCreationTab( "#spawnmenu.category.vehicles", function()

	local ctrl = vgui.Create( "SpawnmenuContentPanel" )
	ctrl:EnableSearch( "vehicles", "PopulateVehicles" )
	ctrl:CallPopulateHook( "PopulateVehicles" )
	return ctrl

end, "icon16/car.png", 50 )
