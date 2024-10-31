
local function BuildWeaponCategories()
	local weapons = list.Get( "Weapon" )
	local Categorised = {}

	-- Build into categories
	for k, weapon in pairs( weapons ) do

		if ( !weapon.Spawnable ) then continue end

		local Category = weapon.Category or "Other"
		Category = tostring( Category )

		local SubCategory = weapon.SubCategory or "Other"
		SubCategory = tostring( SubCategory )

		Categorised[ Category ] = Categorised[ Category ] or {}
		Categorised[ Category ][ SubCategory ] = Categorised[ Category ][ SubCategory ] or {}

		table.insert( Categorised[ Category ][ SubCategory ], weapon )

	end

	return Categorised
end

local function BuildContentList( tab, propPanel )

	local orderedList = {}

	for k, ent in SortedPairsByMemberValue( tab, "PrintName" ) do

		local order = isnumber( ent.SpawnListOrder ) and ent.SpawnListOrder

		if ( order ) then

			table.insert( orderedList, order, ent )

		else
			
			table.insert( orderedList, ent )

		end

	end

	for k, ent in SortedPairs( orderedList ) do

		spawnmenu.CreateContentIcon( ent.ScriptedEntityType or "weapon", propPanel, {
			nicename	= ent.PrintName or ent.ClassName,
			spawnname	= ent.ClassName,
			material	= ent.IconOverride or ( "entities/" .. ent.ClassName .. ".png" ),
			admin		= ent.AdminOnly
		} )

	end

end

local function AddCategory( tree, cat )
	local CustomIcons = list.Get( "ContentCategoryIcons" )

	-- Add a node to the tree
	local node = tree:AddNode( cat, CustomIcons[ cat ] or "icon16/gun.png" )
	tree.Categories[ cat ] = node

	-- When we click on the node - populate it using this function
	node.DoPopulate = function( self )

		-- If we've already populated it - forget it.
		if ( IsValid( self.PropPanel ) ) then return end

		-- Create the container panel
		self.PropPanel = vgui.Create( "ContentContainer", tree.pnlContent )
		self.PropPanel:SetVisible( false )
		self.PropPanel:SetTriggerSpawnlistChange( false )

		local subCategories = BuildWeaponCategories()[ cat ]
		local createOtherHeader = false

		for subCategoryName, weps in SortedPairs( subCategories ) do

			if ( subCategoryName == "Other" ) then continue end

			local label = vgui.Create( "ContentHeader" )

			label:SetText( subCategoryName )

			self.PropPanel:Add( label )

			BuildContentList( weps, self.PropPanel )

			createOtherHeader = true

		end

		if ( subCategories.Other ) then

			if ( createOtherHeader ) then

				local label = vgui.Create( "ContentHeader" )

				label:SetText( "Other" )

				self.PropPanel:Add( label )

			end

			BuildContentList( subCategories.Other, self.PropPanel )

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

	return node
end

hook.Add( "PopulateWeapons", "AddWeaponContent", function( pnlContent, tree, browseNode )

	-- Loop through the weapons and add them to the menu
	local Categorised = BuildWeaponCategories()

	-- Helper
	tree.Categories = {}
	tree.pnlContent = pnlContent

	-- Loop through each category
	for cat, weps in SortedPairs( Categorised ) do

		AddCategory( tree, cat )

	end

	-- Select the first node
	local FirstNode = tree:Root():GetChildNode( 0 )
	if ( IsValid( FirstNode ) ) then FirstNode:InternalDoClick() end

end )

local function AutorefreshWeaponToSpawnmenu( weapon, name )
	local swepTab = g_SpawnMenu.CreateMenu:GetCreationTab( "#spawnmenu.category.weapons" )
	if ( !swepTab || !swepTab.ContentPanel || !IsValid( swepTab.Panel ) ) then return end

	local tree = swepTab.ContentPanel.ContentNavBar.Tree
	if ( !tree.Categories ) then return end

	local selectedCat = ""
	if ( IsValid( tree:GetSelectedItem() ) ) then selectedCat = tree:GetSelectedItem():GetText() end

	-- Remove from previous category..
	for cat, catPnl in pairs( tree.Categories ) do
		if ( !IsValid( catPnl.PropPanel ) ) then continue end

		for _, icon in pairs( catPnl.PropPanel.IconList:GetChildren() ) do
			if ( icon:GetName() != "ContentIcon" ) then continue end

			if ( icon:GetSpawnName() == name ) then
				icon:Remove()
			end
		end

		-- Leave the empty categories, this only applies to devs anyway
	end

	-- Add to new category.. by rebuilding it
	local category = weapon.Category or "Other"

	if ( IsValid( tree.Categories[ category ] ) ) then
		if ( IsValid( tree.Categories[ category ].PropPanel ) ) then
			tree.Categories[ category ].PropPanel:Remove()
		end
		tree.Categories[ category ]:DoPopulate()

		if ( selectedCat == category ) then
			tree.Categories[ category ]:InternalDoClick()
		end
	else
		local node = AddCategory( tree, category )

		-- Reselect the category 
		if ( selectedCat == category ) then
			node:InternalDoClick()
		end
	end

end

hook.Add( "PreRegisterSWEP", "spawnmenu_reload_swep", function( weapon, name )
	if ( !weapon.Spawnable ) then return end

	-- Gotta wait for the next frame because this hook is called just before the weapon is registered
	timer.Simple( 0, function() AutorefreshWeaponToSpawnmenu( weapon, name ) end )
end )

spawnmenu.AddCreationTab( "#spawnmenu.category.weapons", function()

	local ctrl = vgui.Create( "SpawnmenuContentPanel" )
	ctrl:EnableSearch( "weapons", "PopulateWeapons" )
	ctrl:CallPopulateHook( "PopulateWeapons" )
	return ctrl

end, "icon16/gun.png", 10 )
