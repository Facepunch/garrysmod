
AddCSLuaFile()

PANEL.Base = "Panel"

function PANEL:Init()

	self.CurrentSearch = ""
	self.OldResults = -1
	self.RebuildResults = false

	self:Dock( TOP )
	self:SetHeight( 20 )
	self:DockMargin( 0, 0, 0, 3 )

	self.Search = self:Add( "DTextEntry" )
	self.Search:Dock( FILL )
	self.Search:SetPlaceholderText( "#spawnmenu.search" )

	self.Search.OnEnter = function() self:RefreshResults() end
	self.Search.OnFocusChanged = function( _, b ) if ( b ) then self.ContentPanel:SwitchPanel( self.PropPanel ) end end
	self.Search:SetTooltip( "#spawnmenu.enter_search" )

	local btn = self.Search:Add( "DImageButton" )

	btn:SetImage( "icon16/magnifier.png" )
	btn:SetText( "" )
	btn:Dock( RIGHT )
	btn:DockMargin( 4, 2, 4, 2 )
	btn:SetSize( 16, 16 )
	btn:SetTooltip( "#spawnmenu.press_search" )
	btn.DoClick = function()
		self:RefreshResults()
	end

	self.Search.OnKeyCode = function( p, code )

		if ( code == KEY_F1 ) then hook.Run( "OnSpawnMenuClose" ) end
		if ( code == KEY_ESCAPE ) then hook.Run( "OnSpawnMenuClose" ) end

	end

	self.PropPanel = vgui.Create( "ContentContainer", self )
	self.PropPanel:SetVisible( false )
	self.PropPanel:SetTriggerSpawnlistChange( false )

	-- Some sort of placeholder
	local Header = self:Add( "ContentHeader" )
	Header:SetText( "#spawnmenu.enter_search" )
	self.PropPanel:Add( Header )

end

function PANEL:Paint()
	-- This is a bit of a hack, if there was a request to rebuild the results from the search indexer
	-- Do it when the player next sees the search panel, in case they got the spawnmenu closed
	-- Think hook causes unexpected 1 frame duplication of all the elements
	if ( self.RebuildResults ) then
		self.RebuildResults = false
		self:RefreshResults( self.CurrentSearch )
	end
end

function PANEL:SetSearchType( stype, hookname )
	self.m_strSearchType = stype
	hook.Add( hookname, "AddSearchContent_" .. hookname, function( pnlContent, tree, node )
		self.ContentPanel = pnlContent
	end )
	hook.Add( "SearchUpdate", "SearchUpdate_" .. hookname, function()
		if ( !g_SpawnMenu:IsVisible() ) then self.RebuildResults = true return end
		self:RefreshResults( self.CurrentSearch )
	end )

	-- This stuff is only for the primary search
	if ( hookname != "PopulateContent" ) then return end

	g_SpawnMenu.SearchPropPanel = self.PropPanel
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

		self.ContentPanel:SwitchPanel( self.PropPanel )

	end )
end

function PANEL:RefreshResults( str )

	if ( !str ) then -- User tried to search for something
		self.CurrentSearch = self.Search:GetText()
		str = self.CurrentSearch
		self.OldResults = -1
	else
		-- Don't force open the search when you click away from search while this function is called from cl_search_models.lua
		if ( self.ContentPanel.SelectedPanel != self.PropPanel ) then
			return
		end
	end

	if ( !str or str == "" ) then return end

	local results = search.GetResults( str, self.m_strSearchType, GetConVarNumber( "sbox_search_maxresults" ) )
	for id, result in ipairs( results ) do
		if ( !IsValid( result.icon ) ) then ErrorNoHalt( "Failed to create icon for " .. ( result.words && isstring( result.words[ 1 ] ) && result.words[ 1 ] || result.text ).. "\n" ) continue end
		result.icon:SetParent( vgui.GetWorldPanel() ) -- Don't parent the icons to search panel prematurely
	end

	-- I know this is not perfect, but this is the best I am willing to do with how the search library was set up
	if ( self.OldResults == #results ) then -- No updates, don't rebuild
		for id, result in ipairs( results ) do
			if ( IsValid( result.icon ) ) then result.icon:Remove() end -- Kill all icons
		end
		return
	end
	self.OldResults = #results

	self.PropPanel:Clear()

	local Header = self:Add( "ContentHeader" )
	Header:SetText( #results .. " Results for \"" .. str .. "\"" )
	self.PropPanel:Add( Header )

	for k, v in ipairs( results ) do
		self:AddSearchResult( v.text, v.func, v.icon )
	end

	self.PropPanel:SetParent( self.ContentPanel )
	self.ContentPanel:SwitchPanel( self.PropPanel )

end

function PANEL:AddSearchResult( text, func, icon )

	if ( !IsValid( icon ) ) then return end

	icon:SetParent( self.PropPanel )
	self.PropPanel:Add( icon )

end
