
local spawnmenu_engine = spawnmenu

module( "spawnmenu", package.seeall )

local g_ToolMenu = {}
local CreationMenus = {}
local PropTable = {}
local PropTableCustom = {}

local ActiveToolPanel = nil
local ActiveSpawnlistID = 1000

--[[---------------------------------------------------------

	Tool Tabs

-----------------------------------------------------------]]

function SetActiveControlPanel( pnl )
	ActiveToolPanel = pnl
end

function ActiveControlPanel()
	return ActiveToolPanel
end

function GetTools()
	return g_ToolMenu
end

function GetToolMenu( name, label, icon )

	--
	-- This is a dirty hack so that Main stays at the front of the tabs.
	--
	if ( name == "Main" ) then name = "AAAAAAA_Main" end

	label = label or name
	icon = icon or "icon16/wrench.png"

	for k, v in ipairs( g_ToolMenu ) do

		if ( v.Name == name ) then return v.Items end

	end

	local NewMenu = { Name = name, Items = {}, Label = label, Icon = icon }
	table.insert( g_ToolMenu, NewMenu )

	--
	-- Order the tabs by NAME
	--
	table.SortByMember( g_ToolMenu, "Name", true )

	return NewMenu.Items

end

function ClearToolMenus()

	g_ToolMenu = {}

end

function AddToolTab( strName, strLabel, Icon )

	GetToolMenu( strName, strLabel, Icon )

end

function SwitchToolTab( id )

	local Tab = g_SpawnMenu:GetToolMenu():GetToolPanel( id )
	if ( !IsValid( Tab ) or !IsValid( Tab.PropertySheetTab ) ) then return end

	Tab.PropertySheetTab:DoClick()

end

function ActivateToolPanel( tabId, ctrlPnl, toolName )

	local Tab = g_SpawnMenu:GetToolMenu():GetToolPanel( tabId )
	if ( !IsValid( Tab ) ) then return end

	spawnmenu.SetActiveControlPanel( ctrlPnl )

	if ( ctrlPnl ) then
		Tab:SetActive( ctrlPnl )
	end

	SwitchToolTab( tabId )

	if ( toolName && Tab.SetActiveToolText ) then
		Tab:SetActiveToolText( toolName )
	end

end

-- While technically tool class names CAN be duplicate, it normally should never happen.
function ActivateTool( strName, noCommand )

	-- I really don't like this triple loop
	for tab, v in ipairs( g_ToolMenu ) do
		for _, category in pairs( v.Items ) do
			for _, item in pairs( category ) do

				if ( istable( item ) && item.ItemName && item.ItemName == strName ) then

					if ( !noCommand && item.Command && string.len( item.Command ) > 1 ) then
						RunConsoleCommand( unpack( string.Explode( " ", item.Command ) ) )
					end

					local cp = controlpanel.Get( strName )
					if ( !cp:GetInitialized() ) then
						cp:FillViaTable( { Text = item.Text, ControlPanelBuildFunction = item.CPanelFunction } )
					end

					ActivateToolPanel( tab, cp, strName )

					return

				end

			end
		end
	end

end

function AddToolCategory( tab, RealName, PrintName )

	local Menu = GetToolMenu( tab )

	-- Does this category already exist?
	for k, v in ipairs( Menu ) do

		if ( v.Text == PrintName ) then return end
		if ( v.ItemName == RealName ) then return end

	end

	table.insert( Menu, { Text = PrintName, ItemName = RealName } )

end

function AddToolMenuOption( tab, category, itemname, text, command, controls, cpanelfunction, TheTable )

	local Menu = GetToolMenu( tab )
	local CategoryTable = nil

	for k, v in ipairs( Menu ) do
		if ( v.ItemName && v.ItemName == category ) then CategoryTable = v break end
	end

	-- No table found.. lets create one
	if ( !CategoryTable ) then
		CategoryTable = { Text = "#" .. category, ItemName = category }
		table.insert( Menu, CategoryTable )
	end

	TheTable = TheTable or {}

	TheTable.ItemName = itemname
	TheTable.Text = text
	TheTable.Command = command
	TheTable.Controls = controls
	TheTable.CPanelFunction = cpanelfunction

	table.insert( CategoryTable, TheTable )

	-- Keep the table sorted
	table.SortByMember( CategoryTable, "Text", true )

end

--[[---------------------------------------------------------

	Creation Tabs

-----------------------------------------------------------]]
function AddCreationTab( strName, pFunction, pMaterial, iOrder, strTooltip )

	iOrder = iOrder or 1000

	pMaterial = pMaterial or "icon16/exclamation.png"

	CreationMenus[ strName ] = { Function = pFunction, Icon = pMaterial, Order = iOrder, Tooltip = strTooltip }

end

function GetCreationTabs()

	return CreationMenus

end

function SwitchCreationTab( id )

	local tab = g_SpawnMenu:GetCreationMenu():GetCreationTab( id )
	if ( !tab or !IsValid( tab.Tab ) ) then return end

	tab.Tab:DoClick()

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

function PopulateCreationTabFromList( listName, pnlContent, tree, options )

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

		node.Populate = function( self )

			-- Create the container panel
			local propPanel = vgui.Create( "ContentContainer", pnlContent )
			self.PropPanel = propPanel
			
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

		node.RefreshContent = function( self )

			local propPanel = self.PropPanel
			if ( !IsValid( propPanel ) ) then return end

			local selected = pnlContent.SelectedPanel == propPanel

			-- Get an up-to-date list
			categorisedList = createCategorizedList( listName, options )

			propPanel:Remove()

			if ( selected ) then
				pnlContent:SwitchPanel( self:Populate() )
			end

		end

		-- If we click on the node populate it and switch to it.
		node.DoClick = function( self )

			self:DoPopulate()
			pnlContent:SwitchPanel( self.PropPanel )

		end

		node.DoPopulate = function( self )

			if ( !IsValid( self.PropPanel ) ) then
				self:Populate()
			end

		end

	end

	return categoryNodes

end

--[[---------------------------------------------------------

	Spawn lists

-----------------------------------------------------------]]
function GetPropTable()

	return PropTable

end

function GetCustomPropTable()

	return PropTableCustom

end

function AddPropCategory( strFilename, strName, tabContents, icon, id, parentid, needsapp )

	PropTableCustom[ strFilename ] = {
		name = strName,
		contents = tabContents,
		icon = icon,
		id = id or ActiveSpawnlistID,
		parentid = parentid or 0,
		needsapp = needsapp
	}

	if ( !id ) then ActiveSpawnlistID = ActiveSpawnlistID + 1 end

end

-- Populate the spawnmenu from the text files (engine)
function PopulateFromEngineTextFiles()

	-- Reset the already loaded prop list before loading them again.
	-- This caused the spawnlists to duplicate into crazy trees when spawnmenu_reload'ing after saving edited spawnlists
	PropTable = {}

	spawnmenu_engine.PopulateFromTextFiles( function( strFilename, strName, tabContents, icon, id, parentid, needsapp )
		PropTable[ strFilename ] = {
			name = strName,
			contents = tabContents,
			icon = icon,
			id = id,
			parentid = parentid or 0,
			needsapp = needsapp
		}
	end )

end

-- Save the spawnfists to text files (engine)
function DoSaveToTextFiles( props )

	spawnmenu_engine.SaveToTextFiles( props )

end

--[[

Content Providers

Functions that populate the spawnmenu from the spawnmenu txt files.

function MyFunction( ContentPanel, ObjectTable )

	local myspawnicon = CreateSpawnicon( ObjectTable.model )
	ContentPanel:AddItem( myspawnicon )

end

spawnmenu.AddContentType( "model", MyFunction )

--]]

local cp = {}

function AddContentType( name, func )
	cp[ name ] = func
end

function GetContentType( name )

	if ( !name ) then
		ErrorNoHaltWithStack( "spawnmenu.GetContentType got an invalid value\n" )
		return
	end

	if ( !cp[ name ] ) then

		cp[ name ] = function() end
		Msg( "spawnmenu.GetContentType( ", name, " ) - not found!\n" )

	end

	return cp[ name ]
end

function CreateContentIcon( type, parent, tbl )

	local ctrlpnl = GetContentType( type )
	if ( ctrlpnl ) then return ctrlpnl( parent, tbl ) end

end
