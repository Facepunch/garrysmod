
local function AddCategory( tree, categoryName )

	local CustomIcons = list.GetForEdit( "ContentCategoryIcons" )

	-- Add a node to the tree
	local node = tree:AddNode( categoryName, CustomIcons[ categoryName ] or "icon16/gun.png" )
	local CategoryNodes = tree.CategoryNodes

	CategoryNodes[ categoryName ] = node

	node.Populate = function( self )

		local propPanel = vgui.Create( "ContentContainer", tree.pnlContent )
		propPanel:SetVisible(false)
		propPanel:SetTriggerSpawnlistChange( false )

		self.WeaponData = {}
		self.CategoryNodes = CategoryNodes
		self.PropPanel = propPanel

		-- Generate a new list for auto refresh
		local headers = spawnmenu.GenerateCategoryList( list.Get( "Weapon" ), true )[ categoryName ]
		if ( !headers ) then return end

		-- Don't create the "Other" header if it's the only header
		local other = language.GetPhrase( "#spawnmenu.category.other" )
		local createOtherHeader = headers[ other ] and table.Count( headers ) > 1

		for headerName, wepList in SortedPairs( headers ) do
			
			if ( headerName != other or createOtherHeader ) then
				local header = vgui.Create( "ContentHeader" )
				header:SetText( headerName )

				self.PropPanel:Add( header )
			end

			for className, wep in SortedPairsByMemberValue( wepList, "PrintName" ) do

				node.WeaponData[ className ] = wep
				node.CategoryNodes[ className ] = node

				spawnmenu.CreateContentIcon( wep.ScriptedEntityType or "weapon", propPanel, {
					nicename	= wep.PrintName or wep.ClassName,
					spawnname	= wep.ClassName,
					material	= wep.IconOverride or ( "entities/" .. wep.ClassName .. ".png" ),
					admin		= wep.AdminOnly
				} )

			end

		end

		return propPanel

	end

	-- When we click on the node - populate it using this function
	node.DoPopulate = function( self )

		-- If we've already populated it - forget it.
		if ( IsValid( self.PropPanel ) ) then return end

		self:Populate()

	end

	node.Repopulate = function( self )

		local propPanel = self.PropPanel
		if ( !IsValid( propPanel ) ) then return end

		local selected = tree.pnlContent.SelectedPanel == propPanel

		propPanel:Remove()
		propPanel = self:Populate()

		if ( selected ) then
			tree.pnlContent:SwitchPanel( propPanel )
		end

	end

	-- If we click on the node populate it and switch to it.
	node.DoClick = function( self )

		self:DoPopulate()
		tree.pnlContent:SwitchPanel( self.PropPanel )

	end

	node.OnRemove = function( self )

		if ( IsValid( self.PropPanel ) ) then self.PropPanel:Remove() end

	end

end

hook.Add( "PopulateWeapons", "AddWeaponContent", function( pnlContent, tree, browseNode )

	local WeaponList = list.Get( "Weapon" )
	local CategorisedList = spawnmenu.GenerateCategoryList( WeaponList, true )

	-- Helper
	tree.CategoryNodes = {}
	tree.pnlContent = pnlContent

	-- Loop through each category
	for categoryName in SortedPairs( CategorisedList ) do
		AddCategory( tree, categoryName )
	end

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

	local populatedNode = categoryNodes[ className ]
	if ( !IsValid( populatedNode ) ) then return end

	local wepCategory = language.GetPhrase( weaponData.Category or "#spawnmenu.category.other" )
	local wepHeader = weaponData.Header and language.GetPhrase( weaponData.Header ) or nil

	local oldData = populatedNode.WeaponData[ className ]
	local weaponCategoryChanged = oldData.Category != wepCategory

	-- Only update the spawnlist if some data of the weapon actually changed
	local weaponDataChanged = weaponCategoryChanged ||
	(oldData.Header != wepHeader) ||
	(oldData.PrintName != weaponData.PrintName) ||
	(oldData.Author != weaponData.Author) ||
	(oldData.Purpose != weaponData.Purpose) ||
	(oldData.IconOverride != weaponData.IconOverride) ||
	(oldData.AdminOnly != weaponData.AdminOnly)

	if ( !weaponDataChanged ) then return end

	-- If any of the data changed, just nuke the prop panel and repopulate
	populatedNode:Repopulate()

	if ( !weaponCategoryChanged ) then return end

	local newCategoryNode = categoryNodes[ wepCategory ]

	if ( !IsValid( newCategoryNode ) ) then 
		AddCategory( tree, wepCategory )
	else
		newCategoryNode:Repopulate()
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
