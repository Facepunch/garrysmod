
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

local function createCategorizedList( listName, options )

	local memberSortName = options.memberSortName -- The name of the field with the presenting name
	local translationMap = options.translationMap -- Category localization support for old addons
	local checkSpawnable = options.checkSpawnable -- Filters out ones that do not have the Spawnable field, or have it set to false

	local dataList = list.Get( listName ) -- Create a copy of the list
	local categorisedList = {}
	
	for className, data in pairs( dataList ) do

		if ( !checkSpawnable or data.Spawnable ) then

			local sortName = data[ memberSortName ]
			data.SortName = sortName and language.GetPhrase( sortName ) or className

			local category = data[ options.categoryMemberName ]

			if ( !category ) then
				category = "#spawnmenu.category.other"
			elseif translationMap and translationMap[ category ] then
				category = translationMap[ category ]
			end

			category = language.GetPhrase( category )

			local categoryTab = categorisedList[ category ]

			if ( !categoryTab ) then
				categoryTab = {}
				categorisedList[ category ] = categoryTab
			end

			categoryTab[ className ] = data

		end

	end

	return categorisedList

end

-- 
-- Populate creation tab from list
--
function PANEL:PopulateFromList( listName, tree, options )

	options = options or {}
	options.categoryMemberName = options.categoryMemberName or "Category"
	options.headerMemberName = options.headerMemberName or "CategoryHeader"

	local categorisedList = createCategorizedList( listName, options )
	local categoryIconsList = list.GetForEdit( "ContentCategoryIcons" )

	local defaultCategoryIcon = options.defaultCategoryIcon
	local iconBuildFunc = options.iconBuildFunc

	local categoryNodes = {}
	
	for _, childNode in ipairs( tree:Root():GetChildNodes() ) do
		categoryNodes[ childNode:GetText() ] = childNode
	end

	-- Add a node for each category to the tree
	for categoryName in SortedPairs( categorisedList ) do

		-- Don't add duplicate nodes
		if ( categoryNodes[ categoryName ] ) then continue end

		local node = tree:AddNode( categoryName, categoryIconsList[ categoryName ] or defaultCategoryIcon )
		categoryNodes[ categoryName ] = node

		node.Populate = function( node )

			-- Create the container panel
			local propPanel = vgui.Create( "ContentContainer", self )
			node.PropPanel = propPanel
			
			propPanel:SetVisible( false )
			propPanel:SetTriggerSpawnlistChange( false )

			local categorisedData = categorisedList[ categoryName ]
			if ( !categorisedData ) then return end -- May no longer have anything due to autorefresh

			local createdHeaders = {}
			local noHeaderIcons = {}
			local hasHeaders = false

			for name, data in SortedPairsByMemberValue( categorisedData, "SortName" ) do

				local headerName = data[ options.headerMemberName ]
				local hasHeader = isstring( headerName )

				headerName = hasHeader and language.GetPhrase( headerName )

				if ( hasHeader and !createdHeaders[ headerName ] ) then

					local header = vgui.Create( "ContentHeader" )

					header:SetText( headerName )
					propPanel:Add( header )

					createdHeaders[ headerName ] = header
					hasHeaders = true

				end

				local icon = iconBuildFunc( data, name, propPanel, tree, node )

				if ( icon and !hasHeader ) then
					noHeaderIcons[ icon ] = icon.m_NiceName
				end

			end

			-- Move ones without a header to the top
			if ( hasHeaders and !table.IsEmpty( noHeaderIcons ) ) then

				local children = propPanel.IconList:GetChildren()
				local pos = 0

				for icon in SortedPairsByValue( noHeaderIcons ) do

					table.RemoveByValue( children, icon )

					pos = pos + 1
					table.insert( children, pos, icon )

				end

				for zPos, childIcon in ipairs( children ) do
					childIcon:SetZPos( zPos )
				end

			end

			return propPanel

		end
		
		node.RefreshContent = function( node )

			local propPanel = node.PropPanel
			if ( !IsValid( propPanel ) ) then return end

			local selected = self.SelectedPanel == propPanel

			-- Get an up-to-date list
			categorisedList = createCategorizedList( listName, options )

			propPanel:Remove()

			if ( selected ) then
				self:SwitchPanel( node:Populate() )
			end

		end

		-- If we click on the node populate it and switch to it.
		node.DoClick = function( node )

			node:DoPopulate()
			self:SwitchPanel( node.PropPanel )

		end

		node.DoPopulate = function( node )

			if ( !IsValid( node.PropPanel ) ) then
				node:Populate()
			end

		end

	end

	return categoryNodes

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
