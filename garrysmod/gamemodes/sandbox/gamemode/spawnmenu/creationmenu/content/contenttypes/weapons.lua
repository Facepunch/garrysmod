
local function CreateWeaponIcon( ent, propPanel )
	return spawnmenu.CreateContentIcon( ent.ScriptedEntityType or "weapon", propPanel, {
		nicename	= ent.PrintName or ent.ClassName,
		spawnname	= ent.ClassName,
		material	= ent.IconOverride or ( "entities/" .. ent.ClassName .. ".png" ),
		admin		= ent.AdminOnly
	} )
end

hook.Add( "PopulateWeapons", "AddWeaponContent", function( pnlContent, tree, browseNode )

	pnlContent:PopulateFromList( "Weapon", tree, {
		SortName = "PrintName",
		CategoryIcon = "icon16/gun.png",
		CreateIconFunc = CreateWeaponIcon
	} )

end )

local function AutorefreshWeaponToSpawnmenu( weapon, name )

	local swepTab = g_SpawnMenu.CreateMenu:GetCreationTab( "#spawnmenu.category.weapons" )
	if ( !swepTab || !swepTab.ContentPanel || !IsValid( swepTab.Panel ) ) then return end

	local tree = swepTab.ContentPanel.ContentNavBar.Tree
	if ( !tree.Categories ) then return end

	tree:RefreshContent( weapon, name )

end

local function OnPreRegisterSWEP( weapon, name )
	if ( !weapon.Spawnable || !g_SpawnMenu ) then return end

	-- Gotta wait for the next frame because this hook is called just before the weapon is registered
	timer.Simple( 0, function() AutorefreshWeaponToSpawnmenu( weapon, name ) end )
end


spawnmenu.AddCreationTab( "#spawnmenu.category.weapons", function()

	local ctrl = vgui.Create( "SpawnmenuContentPanel" )
	ctrl:EnableSearch( "weapons", "PopulateWeapons" )
	ctrl:CallPopulateHook( "PopulateWeapons" )

	hook.Add( "PreRegisterSWEP", "spawnmenu_reload_swep", OnPreRegisterSWEP )

	return ctrl

end, "icon16/gun.png", 10 )
