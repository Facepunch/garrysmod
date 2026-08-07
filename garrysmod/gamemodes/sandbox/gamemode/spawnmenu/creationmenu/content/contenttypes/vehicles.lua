
local TranslateNames = {
	["Chairs"] = "#spawnmenu.category.chairs",
	["Other"] = "#spawnmenu.category.other"
}

local function CreateVehicleIcon( ent, propPanel )
	return spawnmenu.CreateContentIcon( ent.ScriptedEntityType or "vehicle", propPanel, {
		nicename	= ent.PrintName or ent.SpawnName,
		spawnname	= ent.SpawnName,
		material	= ent.IconOverride or "entities/" .. ent.SpawnName .. ".png",
		admin		= ent.AdminOnly
	} )
end

hook.Add( "PopulateVehicles", "AddVehicleContent", function( pnlContent, tree, browseNode )

	pnlContent:PopulateFromList( "Vehicles", tree, {
		SortName = "PrintName",
		CategoryIcon = "icon16/car.png",
		TranslateNames = TranslateNames,
		CreateIconFunc = CreateVehicleIcon
	} )

end )

spawnmenu.AddCreationTab( "#spawnmenu.category.vehicles", function()

	local ctrl = vgui.Create( "SpawnmenuContentPanel" )
	ctrl:EnableSearch( "vehicles", "PopulateVehicles" )
	ctrl:CallPopulateHook( "PopulateVehicles" )
	return ctrl

end, "icon16/car.png", 50 )
