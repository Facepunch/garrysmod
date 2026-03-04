
include( "controlpanel.lua" )

local PANEL = {}

AccessorFunc( PANEL, "m_TabID", "TabID" )

local spawnmenu_view_disabled_tools = CreateClientConVar( "spawnmenu_view_disabled_tools", "1", true, false, "Whether to show disabled tools in the spawn menu or not." )
function PANEL:Init()

	self.HorizontalDivider = vgui.Create( "DHorizontalDivider", self )
	self.HorizontalDivider:Dock( FILL )
	self.HorizontalDivider:SetLeftWidth( 130 )
	self.HorizontalDivider:SetLeftMin( 130 )
	self.HorizontalDivider:SetRightMin( 200 )
	if ( ScrW() >= 1024 ) then self.HorizontalDivider:SetRightMin( 256 ) end
	self.HorizontalDivider:SetDividerWidth( 6 )
	self.HorizontalDivider:SetCookieName( "SpawnMenuToolMenuDiv" )

	local leftContainer = vgui.Create( "Panel", self.HorizontalDivider )

	local searchContainer = vgui.Create( "Panel", leftContainer )
	searchContainer:Dock( TOP )
	searchContainer:SetTall( 20 )
	searchContainer:DockMargin( 0, 0, 0, 5 )

	self.ViewDesactived = vgui.Create( "DCheckBox", searchContainer )
	self.ViewDesactived:SetTooltip( "#spawnmenu.tools.show_disabled" )
	self.ViewDesactived:Dock( RIGHT )
	self.ViewDesactived:SetWidth( 20 )
	self.ViewDesactived:DockMargin(5, 0, 0, 0)
	self.ViewDesactived:SetConVar( spawnmenu_view_disabled_tools:GetName() )
	self.ViewDisabled = spawnmenu_view_disabled_tools:GetBool()

	self.SearchBar = vgui.Create( "DTextEntry", searchContainer )
	self.SearchBar:SetPlaceholderText( "#spawnmenu.quick_filter" )
	self.SearchBar:Dock( FILL )
	self.SearchBar:SetUpdateOnType( true )
	self.SearchBar.OnValueChange = function( s, text )
		self:PerformToolFiltering( text:Trim():lower() )
	end

	self.List = vgui.Create( "DCategoryList", leftContainer )
	self.List:SetWidth( 130 )
	self.List:Dock( FILL )

	self.HorizontalDivider:SetLeft( leftContainer )

	self.Content = vgui.Create( "DCategoryList", self.HorizontalDivider )
	self.HorizontalDivider:SetRight( self.Content )

	self.LastUpdate = 0
	self.IsToolTab = false

	local label = vgui.Create( "Panel", self )
	label:Dock( BOTTOM )
	label:SetVisible( false )
	label:SetTall( 72 )
	label.Text = ""
	label.Paint = function( s, w, h )
		local parsed = markup.Parse( "<font=DermaLarge>" .. s.Text .. "</font>", w )
		parsed:Draw( w / 2, h / 2, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 255, TEXT_ALIGN_CENTER )
	end
	self.WarningLabel = label

end

function PANEL:Think()

	if ( self.LastUpdate + 0.5 < SysTime() ) then
		self.LastUpdate = SysTime()

		self:UpdateToolDisabledStatus()

		if ( !self.IsToolTab ) then return end

		local disabled = self.ActiveCPName && self.ConVar && !self.ConVar:GetBool() or false
		local noToolgun = IsValid( LocalPlayer() ) && !LocalPlayer():HasWeapon( "gmod_tool" )

		self.WarningLabel.Text = noToolgun && language.GetPhrase( "#spawnmenu.tools.no_toolgun" ) or language.GetPhrase( "#spawnmenu.tools.disabled_selected" )
		if ( ( disabled or noToolgun ) != self.WarningLabel:IsVisible() ) then
			self.WarningLabel:SetVisible( disabled or noToolgun )
			self:InvalidateLayout()
		end
	end

end

function PANEL:PerformToolFiltering( text )

	for cid, category in ipairs( self.List.pnlCanvas:GetChildren() ) do
		local count = 0
		local category_matched = false

		if ( string.find( category.Header:GetText():lower(), text, nil, true ) ) then
			category_matched = true
		end

		for id, item in ipairs( category:GetChildren() ) do
			if ( item == category.Header ) then continue end

			local str = item.Text
			if ( str:StartsWith( "#" ) ) then str = str:sub( 2 ) end
			str = language.GetPhrase( str )

			if ( !category_matched && !string.find( str:lower(), text, nil, true ) ) then
				item:SetVisible( false )
			else
				item:SetVisible( true )
				count = count + 1
			end
			item:InvalidateLayout()
		end

		if ( count < 1 && !category_matched ) then
			category:SetVisible( false )
		else
			category:SetVisible( true )

			-- Make sure the category is expanded, but restore the state when we quit searching
			if ( text == "" ) then
				if ( category._preSearchState != nil ) then
					category:SetExpanded( category._preSearchState )
					category._preSearchState = nil
				end
			else
				if ( category._preSearchState == nil ) then category._preSearchState = category:GetExpanded() end
				category:SetExpanded( true )
			end
		end
		category:InvalidateLayout()
	end
	self.List.pnlCanvas:InvalidateLayout()
	self.List:InvalidateLayout()

end

function PANEL:UpdateToolDisabledStatus()

	if !self.Tools or #self.Tools < 1 then return end

	local ply = LocalPlayer()
	for _, item in ipairs( self.Tools or {} ) do

		local cvar = item.ConVar
		local enabled = cvar && cvar:GetBool() && hook.Run( "CanTool", ply, ply:GetEyeTrace(), item.Name, ply:GetTool(), -1 ) != false
		if ( enabled == item:IsEnabled() && self.ViewDisabled == spawnmenu_view_disabled_tools:GetBool() ) then continue end

		self:SetEnabledItem( item, enabled )

	end

	self.ViewDisabled = spawnmenu_view_disabled_tools:GetBool()

end

function PANEL:SetEnabledItem( item, enabled )

	if ( !spawnmenu_view_disabled_tools:GetBool() ) then

		local category = item:GetParent()

		if ( category:IsVisible() && category:GetExpanded() && !enabled ) then
			category:Toggle()
			category:Toggle()
		end

		item:SetVisible( enabled )
		return
	end

	item:SetEnabled( enabled )
	item:SetVisible( true )

	if ( enabled ) then
		item:SetTooltip()
	else
		item:SetTooltip( "#spawnmenu.tools.disabled" )
	end

end

function PANEL:LoadToolsFromTable( inTable )

	for k, v in pairs( table.Copy( inTable ) ) do

		if ( istable( v ) ) then

			-- Remove these from the table so we can
			-- send the rest of the table to the other
			-- function

			local Name = v.ItemName
			local Label = v.Text
			v.ItemName = nil
			v.Text = nil

			if ( v[ 1 ] && v[ 1 ].Command && v[ 1 ].Command:StartsWith( "gmod_tool " ) ) then
				self.IsToolTab = true
			end

			self:AddCategory( Name, Label, v )

		end

	end

end

function PANEL:AddCategory( name, catName, tItems )

	local Category = self.List:Add( catName )
	local tabID = self:GetTabID()

	Category:SetCookieName( "ToolMenu." .. tostring( tabID ) .. "." .. tostring( name ) )

	local tools = {}
	self.ToolTable = self.ToolTable or {}
	table.insert( self.ToolTable, {
		name = name,
		Text = catName,
		Items = tItems
	} )

	for k, v in ipairs( tItems ) do
		local name_tool = v.Text or v.ItemName or v.Controls or v.Command or tostring( k )
		if ( name_tool:StartsWith( "#" ) ) then name_tool = name_tool:sub( 2 ) end
		tools[ language.GetPhrase( name_tool ) ] = v
	end

	local currentMode = GetConVar( "gmod_toolmode" ):GetString()
	self.Tools = self.Tools or {}
	for k, v in SortedPairs( tools ) do

		local item = Category:Add( v.Text or k )

		item.DoClick = function( button )

			spawnmenu.ActivateTool( button.Name )

		end
		item.DoRightClick = function( button )
			local menu = DermaMenu()
			menu:AddOption( "#spawnmenu.menu.copy", function() SetClipboardText( button.Name ) end ):SetIcon( "icon16/page_copy.png" )
			menu:Open()
		end

		item.ControlPanelBuildFunction	= v.CPanelFunction
		item.Command					= v.Command
		item.Name						= v.ItemName
		item.Controls					= v.Controls
		item.Text						= v.Text
		item.ConVar 					= GetConVar( "toolmode_allow_" .. v.ItemName )

		-- Mark this button as the one to select on first spawnmenu open
		if ( currentMode == v.ItemName ) then
			timer.Simple( 0, function() -- Have to wait a frame to get the g_SpawnMenu global, ew
				g_SpawnMenu.StartupTool = item
			end )
		end

		table.insert( self.Tools, item )
	end

	self:InvalidateLayout()

end

function PANEL:ReloadTools()

	self.List:Clear()

	for _, v in ipairs( self.ToolTable ) do
		self:AddCategory( v.name, v[ "Text" ], v[ "Items" ] )
	end

end

-- Internal, makes the given tool highlighted in its DCategoryList
function PANEL:SetActiveToolText( str )

	for cid, category in ipairs( self.List.pnlCanvas:GetChildren() ) do

		for id, item in ipairs( category:GetChildren() ) do
			if ( item == category.Header ) then continue end

			if ( item.Name == str ) then
				self.List:UnselectAll()
				item:SetSelected( true )
				return
			end
		end

	end

end

function PANEL:SetActive( cp )

	local kids = self.Content:GetCanvas():GetChildren()
	for k, v in pairs( kids ) do
		v:SetVisible( false )
	end

	self.Content:AddItem( cp )
	self.ActiveCPName = cp.Name
	self.ConVar = GetConVar( "toolmode_allow_" .. self.ActiveCPName )
	cp:SetVisible( true )
	cp:Dock( TOP )

end

vgui.Register( "ToolPanel", PANEL, "Panel" )
