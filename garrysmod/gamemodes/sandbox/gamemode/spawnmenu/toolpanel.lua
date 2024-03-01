
include( "controlpanel.lua" )

local PANEL = {}

AccessorFunc( PANEL, "m_TabID", "TabID" )

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

	self.SearchBar = vgui.Create( "DTextEntry", leftContainer )
	self.SearchBar:SetWidth( 130 )
	self.SearchBar:SetPlaceholderText( "#spawnmenu.quick_filter" )
	self.SearchBar:DockMargin( 0, 0, 0, 5 )
	self.SearchBar:Dock( TOP )
	self.SearchBar:SetUpdateOnType( true )
	self.SearchBar.OnValueChange = function( s, text )
		local text = text:Trim():lower()

		for id, category in ipairs( self.List.pnlCanvas:GetChildren() ) do
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

	self.List = vgui.Create( "DCategoryList", leftContainer )
	self.List:SetWidth( 130 )
	self.List:Dock( FILL )

	self.HorizontalDivider:SetLeft( leftContainer )

	self.Content = vgui.Create( "DCategoryList", self.HorizontalDivider )
	self.HorizontalDivider:SetRight( self.Content )

end

function PANEL:LoadToolsFromTable( inTable )

	local inTable = table.Copy( inTable )

	for k, v in pairs( inTable ) do

		if ( istable( v ) ) then

			-- Remove these from the table so we can
			-- send the rest of the table to the other
			-- function

			local Name = v.ItemName
			local Label = v.Text
			v.ItemName = nil
			v.Text = nil

			self:AddCategory( Name, Label, v )

		end

	end

end

function PANEL:AddCategory( name, lbl, tItems )

	local Category = self.List:Add( lbl )

	Category:SetCookieName( "ToolMenu." .. tostring( self:GetTabID() ) .. "." .. tostring( name ) )

	local tools = {}
	for k, v in pairs( tItems ) do
		local name = v.Text or v.ItemName or v.Controls or v.Command or tostring( k )
		tools[ language.GetPhrase( name ) ] = v
	end

	local currentMode = GetConVarString( "gmod_toolmode" )
	for k, v in SortedPairs( tools ) do

		local item = Category:Add( v.Text or k )

		item.DoClick = function( button )

			spawnmenu.ActivateTool( button.Name )

		end

		item.ControlPanelBuildFunction	= v.CPanelFunction
		item.Command					= v.Command
		item.Name						= v.ItemName
		item.Controls					= v.Controls
		item.Text						= v.Text

		-- Mark this button as the one to select on first spawnmenu open
		if ( currentMode == v.ItemName ) then
			timer.Simple( 0, function() -- Have to wait a frame to get the g_SpawnMenu global, ew
				g_SpawnMenu.StartupTool = item
			end )
		end

	end

	self:InvalidateLayout()

end

-- Internal, makes the given tool highlighted in its DCategoryList
function PANEL:SetActiveToolText( str )

	for id, category in ipairs( self.List.pnlCanvas:GetChildren() ) do

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
	cp:SetVisible( true )
	cp:Dock( TOP )

end

vgui.Register( "ToolPanel", PANEL, "Panel" )
