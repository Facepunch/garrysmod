
include( "contenticon.lua" )
include( "postprocessicon.lua" )

include( "contentcontainer.lua" )
include( "contentsidebar.lua" )

include( "contenttypes/custom.lua" )
include( "contenttypes/npcs.lua" )
include( "contenttypes/weapons.lua" )
include( "contenttypes/entities.lua" )
include( "contenttypes/postprocess.lua" )
include( "contenttypes/vehicles.lua" )
include( "contenttypes/saves.lua" )
include( "contenttypes/dupes.lua" )

include( "contenttypes/gameprops.lua" )
include( "contenttypes/addonprops.lua" )

local PANEL = {}

AccessorFunc( PANEL, "m_pSelectedPanel", "SelectedPanel" )

function PANEL:Init()

	self:SetPaintBackground( false )

	self.CategoryTable = {}

	self.HorizontalDivider = vgui.Create( "DHorizontalDivider", self )
	self.HorizontalDivider:Dock( FILL )
	self.HorizontalDivider:SetLeftWidth( 192 )
	self.HorizontalDivider:SetLeftMin( 100 )
	self.HorizontalDivider:SetRightMin( 100 )
	self.HorizontalDivider:SetDividerWidth( 6 )
	self.HorizontalDivider:SetCookieName( "SpawnMenuCreationMenuDiv" )

	if ( ScrW() >= 1024 ) then
		self.HorizontalDivider:SetLeftMin( 192 )
		self.HorizontalDivider:SetRightMin( 400 )
	end

	self.ContentNavBar = vgui.Create( "ContentSidebar", self.HorizontalDivider )
	self.HorizontalDivider:SetLeft( self.ContentNavBar )

end

function PANEL:EnableModify()
	self.ContentNavBar:EnableModify()
end

function PANEL:EnableSearch( ... )
	self.ContentNavBar:EnableSearch( ... )
end

function PANEL:CallPopulateHook( HookName )

	hook.Call( HookName, GAMEMODE, self, self.ContentNavBar.Tree, self.OldSpawnlists )

end

function PANEL:SwitchPanel( panel )

	if ( IsValid( self.SelectedPanel ) ) then
		self.SelectedPanel:SetVisible( false )
		self.SelectedPanel = nil
	end

	self.SelectedPanel = panel

	if ( !IsValid( panel ) ) then return end

	self.HorizontalDivider:SetRight( self.SelectedPanel )
	self.HorizontalDivider:InvalidateLayout( true )

	self.SelectedPanel:SetVisible( true )
	self:InvalidateParent()

end

function PANEL:OnSizeChanged()
	self.HorizontalDivider:LoadCookies()
end

local function BuildCategorizedList( listName, nameOverrides )

	local categorised = {}

	for k, v in pairs( list.Get( listName ) ) do

		if ( listName == "Weapon" && !v.Spawnable ) then continue end

		-- Post Processing effects use lower case values... sigh
		if ( !v.Category ) then v.Category = v.category end

		local categoryName = v.Category

		-- Manual category localization for old addons that want to appear in base game categories
		if ( nameOverrides ) then categoryName = nameOverrides[ categoryName ] or categoryName end

		local Category = language.GetPhrase( categoryName or "#spawnmenu.category.other" )
		if ( !isstring( Category ) ) then Category = tostring( Category ) end
		categorised[ Category ] = categorised[ Category ] or {}

		v.SpawnName = k
		if ( !v.PrintName ) then v.PrintName = v.Name end

		table.insert( categorised[ Category ], v )

	end

	return categorised

end

local function AddCategory( tree, catName, options )

	local node = tree:AddNode( catName, list.GetEntry( "ContentCategoryIcons", catName ) or options.CategoryIcon )
	tree.Categories[ catName ] = node

	-- When we click on the node - populate it using this function
	node.DoPopulate = function( self )

		-- If we've already populated it - forget it.
		if ( self.PropPanel ) then return end

		-- Create the container panel
		self.PropPanel = vgui.Create( "ContentContainer", tree.ContentPanel )
		self.PropPanel:SetVisible( false )
		self.PropPanel:SetTriggerSpawnlistChange( false )
		self.PropPanel.SubCategories = {}

		-- Get a fresh copy in case the list has changed since the category was created,
		-- but before it's populated with actual icons
		local items = BuildCategorizedList( tree.ContentListName, options.TranslateNames )[ catName ]

		local subCats = {}
		for k, v in pairs( items ) do
			local subCat = language.GetPhrase( v.SubCategory or "" )
			subCats[ subCat ] = subCats[ subCat ] or {}
			table.insert( subCats[ subCat ], { item = v, sortName = ( v[ options.SortName ] and language.GetPhrase( v[ options.SortName ] ) or v.SpawnName ) } )
		end

		for subCatName, itemList in SortedPairs( subCats ) do

			local subCatItems = {}

			if ( subCatName != "" ) then
				local header = vgui.Create( "ContentHeader" )
				header:SetText( subCatName )
				self.PropPanel:Add( header )

				table.insert( subCatItems, header )
			end

			for _, item in SortedPairsByMemberValue( itemList, "sortName" ) do
				local icon = tree.CreateIconFunc( item.item, self.PropPanel )
				-- Post processing functions do not return an icon (and make multiple), sigh
				if ( icon ) then table.insert( subCatItems, icon ) end
			end

			self.PropPanel.SubCategories[ subCatName ] = subCatItems

		end

	end

	-- If we click on the node, populate it and switch to it.
	node.DoClick = function( self )

		self:DoPopulate()
		tree.ContentPanel:SwitchPanel( self.PropPanel )

	end

	return node

end

--
-- Populate creation tab from list
--
function PANEL:PopulateFromList( listName, tree, options )

	-- Store some useful things we may need later
	tree.Categories = {}
	tree.ContentPanel = self
	tree.ContentListName = listName
	tree.CreateIconFunc = options.CreateIconFunc

	-- Set up sorting by categories
	local categorised = BuildCategorizedList( listName, options.TranslateNames )

	-- Add a tree node for each category
	for catName, items in SortedPairs( categorised ) do
		AddCategory( tree, catName, options )
	end

	-- Handle auto refresh moving an icon to a different category or adding a new one
	tree.RefreshContent = function( self, item, spawnname )

		local newCategory = language.GetPhrase( item.Category or "#spawnmenu.category.other" )

		-- Remove from previous category..
		for cat, catPnl in pairs( self.Categories ) do
			if ( !IsValid( catPnl.PropPanel ) ) then continue end

			for subCatName, icons in pairs( catPnl.PropPanel.SubCategories ) do
				for id, icon in pairs( icons ) do
					if ( icon:GetName() != "ContentIcon" ) then continue end

					if ( icon:GetSpawnName() == spawnname ) then
						icon:Remove()
						table.remove( icons, id )
						break
					end
				end

				-- Remove the header too if it is empty
				if ( subCatName != "" && #icons == 1 && icons[ 1 ]:GetName() == "ContentHeader" ) then
					icons[ 1 ]:Remove()
					table.remove( icons, 1 )
					catPnl.PropPanel.SubCategories[ subCatName ] = nil
				end
			end

			-- Leave the empty categories, this only applies to devs anyway
		end

		-- Add to new category
		if ( IsValid( self.Categories[ newCategory ] ) ) then
			-- Only do this if it is already populated.
			-- If not, the weapon will appear automatically when user clicks on the category
			local propPnl = self.Categories[ newCategory ].PropPanel
			if ( IsValid( propPnl ) ) then
				-- TODO: Find correct alphabetical spot to insert?
				local subCat = language.GetPhrase( item.SubCategory or "" )

				if ( !propPnl.SubCategories[ subCat ] ) then
					propPnl.SubCategories[ subCat ] = {}
					if ( subCat != "" ) then
						local header = vgui.Create( "ContentHeader" )
						header:SetText( subCat )
						propPnl:Add( header )
						table.insert( propPnl.SubCategories[ subCat ], header )
					end
				end

				-- Just append it to the end
				local icon = self.CreateIconFunc( item, propPnl )
				if ( icon ) then table.insert( propPnl.SubCategories[ subCat ], icon ) end

				-- Moe it to the correct sub category
				icon:MoveToAfter( propPnl.SubCategories[ subCat ][ #propPnl.SubCategories[ subCat ] ] )

			end
		else
			AddCategory( self, newCategory, options )
		end

	end

	-- Select the first node
	local FirstNode = tree:Root():GetChildNode( 0 )
	if ( IsValid( FirstNode ) ) then
		FirstNode:InternalDoClick()
	end

end

vgui.Register( "SpawnmenuContentPanel", PANEL, "DPanel" )

local function CreateContentPanel()

	local ctrl = vgui.Create( "SpawnmenuContentPanel" )

	ctrl.OldSpawnlists = ctrl.ContentNavBar.Tree:AddNode( "#spawnmenu.category.browse", "icon16/cog.png" )

	ctrl:EnableModify()
	hook.Call( "PopulatePropMenu", GAMEMODE )
	ctrl:CallPopulateHook( "PopulateContent" )

	ctrl.OldSpawnlists:MoveToFront()
	ctrl.OldSpawnlists:SetExpanded( true )

	return ctrl

end

spawnmenu.AddCreationTab( "#spawnmenu.content_tab", CreateContentPanel, "icon16/application_view_tile.png", -10 )
