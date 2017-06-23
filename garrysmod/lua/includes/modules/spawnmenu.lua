
local spawnmenu_engine = spawnmenu

module( "spawnmenu", package.seeall )

local g_ToolMenu = {}
local CreationMenus = {}
local PropTable = {}
local PropTableCustom = {}

local ActiveToolPanel = nil
local ActiveSpawnlistID = 1000

function SetActiveControlPanel( pnl )
	ActiveToolPanel = pnl
end

function ActiveControlPanel()
	return ActiveToolPanel
end

--[[---------------------------------------------------------
	GetTools
-----------------------------------------------------------]]
function GetTools()
	return g_ToolMenu
end

--[[---------------------------------------------------------
	GetToolMenu - This is WRONG. Probably.
-----------------------------------------------------------]]
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

function AddToolCategory( tab, RealName, PrintName )

	tab = GetToolMenu( tab )

	-- Does this category already exist?
	for k, v in ipairs( tab ) do

		if ( v.Text == PrintName ) then return end
		if ( v.ItemName == RealName ) then return end

	end

	table.insert( tab, { Text = PrintName, ItemName = RealName } )

end

function AddToolMenuOption( tab, category, itemname, text, command, controls, cpanelfunction, TheTable )

	local Menu = GetToolMenu( tab )
	local CategoryTable = nil

	for k, v in ipairs( Menu ) do
		if ( v.ItemName && v.ItemName == category ) then CategoryTable = v break end
	end

	-- No table found.. lets create one
	if ( !CategoryTable ) then
		CategoryTable = { Text = "#"..category, ItemName = category }
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
	AddCreationTab
-----------------------------------------------------------]]
function AddCreationTab( strName, pFunction, pMaterial, iOrder, strTooltip )

	iOrder = iOrder or 1000

	pMaterial = pMaterial or "icon16/exclamation.png"

	CreationMenus[ strName ] = { Function = pFunction, Icon = pMaterial, Order = iOrder, Tooltip = strTooltip }

end

--[[---------------------------------------------------------
	GetCreationTabs
-----------------------------------------------------------]]
function GetCreationTabs()

	return CreationMenus

end

--[[---------------------------------------------------------
	GetPropTable
-----------------------------------------------------------]]
function GetPropTable()

	return PropTable

end

--[[---------------------------------------------------------
	GetCustomPropTable
-----------------------------------------------------------]]
function GetCustomPropTable()

	return PropTableCustom

end

--[[---------------------------------------------------------
	AddPropCategory
-----------------------------------------------------------]]
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

--[[---------------------------------------------------------
	Populate the spawnmenu from the text files (engine)
-----------------------------------------------------------]]
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

--[[---------------------------------------------------------
	Populate the spawnmenu from the text files (engine)
-----------------------------------------------------------]]
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

function GetContentType( name, func )

	if ( !cp[ name ] ) then

		cp[ name ] = function() end
		Msg( "spawnmenu.GetContentType( ", name, " ) - not found!\n" )

	end

	return cp[ name ]
end

function CreateContentIcon( type, parent, tbl )

	local cp = GetContentType( type )
	if ( cp ) then return cp( parent, tbl ) end

end

function SwitchToolTab( id )

	local Tab = g_SpawnMenu:GetToolMenu():GetToolPanel( id )
	if ( !IsValid( Tab ) ) then return end

	--Tab:GetParent():GetParent().Tab:DoClick()

end

function ActivateToolPanel( id, cp )

	local Tab = g_SpawnMenu:GetToolMenu():GetToolPanel( id )
	if ( !IsValid( Tab ) ) then return end

	spawnmenu.SetActiveControlPanel( cp )

	if ( cp ) then
		Tab:SetActive( cp )
	end

	SwitchToolTab( id )

end

-- While technically tool class names CAN be duplicate, it normally should never happen.
function ActivateTool( strName, noCommand )

	-- I really don't like this triple loop
	for tab, v in ipairs( g_ToolMenu ) do
		for _, items in pairs( v.Items ) do
			for _, item in pairs( items ) do

				if ( istable( item ) && item.ItemName && item.ItemName == strName ) then

					if ( !noCommand && item.Command ) then
						RunConsoleCommand( unpack( string.Explode( " ", item.Command ) ) )
					end

					local cp = controlpanel.Get( strName )
					if ( !cp:GetInitialized() ) then
						cp:FillViaTable( { Text = item.Text, ControlPanelBuildFunction = item.CPanelFunction, Controls = item.Controls } )
					end

					ActivateToolPanel( tab, cp )

					break

				end

			end
		end
	end

end
