
AddCSLuaFile()

PANEL.Base = "Panel"

local ContentPanel = nil
local CurrentSearch = ""
local OldResults = -1

function PANEL:Init()

	self:Dock( TOP )
	self:SetHeight( 20 )
	self:DockMargin( 0, 0, 0, 3 )

	self.Search = self:Add( "DTextEntry" )
	self.Search:Dock( FILL )

	self.Search.OnEnter = function() self:RefreshResults() end
	self.Search.OnFocusChanged = function( _, b ) if ( b ) then ContentPanel:SwitchPanel( self.PropPanel ) end end
	self.Search:SetTooltip( "Press enter to search" )

	local btn = self.Search:Add( "DImageButton" )

	btn:SetImage( "icon16/magnifier.png" )
	btn:SetText( "" )
	btn:Dock( RIGHT )
	btn:DockMargin( 4, 2, 4, 2 )
	btn:SetSize( 16, 16 )
	btn:SetTooltip( "Press to search" )
	btn.DoClick = function()
		self:RefreshResults()
	end

	self.Search.OnKeyCode = function( p, code )

		if ( code == KEY_F1 ) then hook.Run( "OnSpawnMenuClose" ) end
		if ( code == KEY_ESCAPE ) then hook.Run( "OnSpawnMenuClose" ) end

	end

	hook.Add( "StartSearch", "StartSearch", function()

		if ( g_SpawnMenu:IsVisible() ) then return hook.Run( "OnSpawnMenuClose" ) end

		hook.Run( "OnSpawnMenuOpen" )
		hook.Run( "OnTextEntryGetFocus", self.Search )

		self.Search:RequestFocus()
		self.Search:SetText( "" )

		--
		-- If we don't call this we'd have to press F1 twice to close it!
		-- It's in a timer because of some good reason that!
		--
		timer.Simple( 0.1, function() g_SpawnMenu:HangOpen( false ) end )

		ContentPanel:SwitchPanel( self.PropPanel )

	end )

	hook.Add( "SearchUpdate", "SearchUpdate", function()

		if ( !g_SpawnMenu:IsVisible() ) then return end
		self:RefreshResults( CurrentSearch )

	end )

	self.PropPanel = vgui.Create( "ContentContainer", self )
	self.PropPanel:SetVisible( false )
	self.PropPanel:SetTriggerSpawnlistChange( false )

	-- Some sort of placeholder
	local Header = self:Add( "ContentHeader" )
	Header:SetText( "Press Enter to search" )
	self.PropPanel:Add( Header )

	g_SpawnMenu.SearchPropPanel = self.PropPanel

end

function PANEL:RefreshResults( str )

	if ( !str ) then -- User tried to search for something
		CurrentSearch = self.Search:GetText()
		str = CurrentSearch
		OldResults = -1
	else
		-- Don't force open the search when you click away from search while this function is called from cl_search_models.lua
		if ( ContentPanel.SelectedPanel != self.PropPanel ) then
			return
		end
	end

	if ( !str or str == "" ) then return end

	local results = search.GetResults( str )
	for id, result in pairs( results ) do
		result.icon:SetParent( GetHUDPanel() ) -- Don't parent the icons to search panel prematurely
	end

	-- I know this is not perfect, but this is the best I am willing to do with how the search library was set up
	if ( OldResults == #results ) then -- No updates, don't rebuild
		for id, result in pairs( results ) do result.icon:Remove() end -- Kill all icons
		return
	end 
	OldResults = #results

	self.PropPanel:Clear()

	local Header = self:Add( "ContentHeader" )
	Header:SetText( #results .. " Results for \"" .. str .. "\"" )
	self.PropPanel:Add( Header )

	for k, v in pairs( results ) do
		self:AddSearchResult( v.text, v.func, v.icon )
	end

	self.PropPanel:SetParent( ContentPanel )
	ContentPanel:SwitchPanel( self.PropPanel )

end

function PANEL:AddSearchResult( text, func, icon )

	if ( !IsValid( icon ) ) then return end

	icon:SetParent( self.PropPanel )
	self.PropPanel:Add( icon )

end

hook.Add( "PopulateContent", "AddSearchContent", function( pnlContent, tree, node )

	-- Add a node to the tree
	--[[
	local node = tree:AddNode( "Search", "icon16/magnifier.png" )

	-- If we click on the node populate it and switch to it.
	node.DoClick = function( self )

		self:DoPopulate()
		pnlContent:SwitchPanel( self.PropPanel )

	end
	--]]

	ContentPanel = pnlContent

end )
