
local function AddWeaponToCategory( wep, className, propPanel )
	return spawnmenu.CreateContentIcon( wep.ScriptedEntityType or "weapon", propPanel, {
		nicename	= wep.PrintName or className,
		spawnname	= className,
		material	= wep.IconOverride or ( "entities/" .. className .. ".png" ),
		admin		= wep.AdminOnly
	} )
end

local PopulateOptions = {}
PopulateOptions.memberSortName = "PrintName"
PopulateOptions.defaultCategoryIcon = "icon16/gun.png"
PopulateOptions.checkSpawnable = true
PopulateOptions.iconBuildFunc = AddWeaponToCategory

hook.Add( "PopulateWeapons", "AddWeaponContent", function( pnlContent, tree, browseNode )

	-- Helpers for auto refresh
	tree.CategoryNodes = spawnmenu.PopulateCreationTabFromList( "Weapon", pnlContent, tree, PopulateOptions )
	tree.pnlContent = pnlContent

	-- Select the first node
	local FirstNode = tree:Root():GetChildNode( 0 )
	if ( IsValid( FirstNode ) ) then FirstNode:InternalDoClick() end

end )

local function AutorefreshWeaponToSpawnmenu( weaponData, className )

	local swepTab = g_SpawnMenu.CreateMenu:GetCreationTab( "#spawnmenu.category.weapons" )
	if ( !swepTab || !swepTab.ContentPanel || !IsValid( swepTab.Panel ) ) then return end

	local tree = swepTab.ContentPanel.ContentNavBar.Tree
	local categoryNodes = tree.CategoryNodes

	if ( !categoryNodes ) then return end

	local populatedNode
	local wepCategoryChanged
	local wepCategory = language.GetPhrase( weaponData.Category or "#spawnmenu.category.other" )

	for categoryName, node in pairs( categoryNodes ) do

		if ( populatedNode ) then break end

		local propPanel = node.PropPanel
		if ( !IsValid( propPanel ) ) then continue end

		for _, icon in pairs( propPanel.IconList:GetChildren() ) do

			if ( icon:GetName() != "ContentIcon" ) then continue end

			local spawnName = icon:GetSpawnName()

			if ( spawnName == className ) then

				populatedNode = node
				wepCategoryChanged = wepCategory != categoryName

				node:RefreshContent()

				break

			end

		end

		-- Leave the empty categories, this only applies to devs anyway
	end

	if ( !wepCategoryChanged ) then return end

	local newCategoryNode = categoryNodes[ wepCategory ]

	if ( !IsValid( newCategoryNode ) ) then 
		tree.CategoryNodes = spawnmenu.PopulateCreationTabFromList( "Weapon", tree.pnlContent, tree, PopulateOptions )
	else
		newCategoryNode:RefreshContent()
	end

end

local function OnPreRegisterSWEP( weapon, className )
	if ( !weapon.Spawnable || !g_SpawnMenu ) then return end

	-- Gotta wait for the next frame because this hook is called just before the weapon is registered
	timer.Simple( 0, function() AutorefreshWeaponToSpawnmenu( weapon, className ) end )
end

spawnmenu.AddCreationTab( "#spawnmenu.category.weapons", function()

	local ctrl = vgui.Create( "SpawnmenuContentPanel" )
	ctrl:EnableSearch( "weapons", "PopulateWeapons" )
	ctrl:CallPopulateHook( "PopulateWeapons" )

	hook.Add( "PreRegisterSWEP", "spawnmenu_reload_swep", OnPreRegisterSWEP )

	return ctrl

end, "icon16/gun.png", 10 )
