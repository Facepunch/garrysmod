
AddCSLuaFile()

PANEL.Base = "Panel"

local ContentPanel = nil

function PANEL:Init()

	self:Dock( TOP )
	self:SetHeight( 20 )
	self:DockMargin( 0, 0, 0, 3 )

	self.Search = self:Add( "DTextEntry" )
	self.Search:Dock( FILL )
	--self.Search:SetWidth( 150 )

	self.Search.OnChange = function() self:RefreshResults() end
	self.Search.OnFocusChanged = function( _, b ) if ( b ) then self:RefreshResults() end end

	local btn = self.Search:Add( "DImage" )

	btn:SetImage( "icon16/magnifier.png" )
	btn:SetText( "" )
	btn:Dock( RIGHT )
	btn:DockMargin( 4, 2, 4, 2 )
	btn:SetSize( 16, 16 )

	self.Search.OnKeyCode = function( p, code )

		if ( code == KEY_F1 ) then hook.Run( "OnSpawnMenuClose" ) end
		if ( code == KEY_ESCAPE ) then hook.Run( "OnSpawnMenuClose" ) end

	end

	hook.Add( "StartSearch", "StartSearch", function()

		if ( g_SpawnMenu:IsVisible() ) then return hook.Run( "OnSpawnMenuClose" ) end

		hook.Run( "OnSpawnMenuOpen" )
		hook.Run( "OnTextEntryGetFocus", self.Search )		

		self.Search:RequestFocus()
		self.Search:SetText( "" );

		--
		-- If we don't call this we'd have to press F1 twice to close it!
		-- It's in a timer because of some good reason that!
		--
		timer.Simple( 0.1, function() g_SpawnMenu:HangOpen( false ) end )

		ContentPanel:SwitchPanel( self.PropPanel );

	end);

	hook.Add( "SearchUpdate", "SearchUpdate", function()

		if ( !g_SpawnMenu:IsVisible() ) then return end
		self:RefreshResults()

	end);

	self.PropPanel = vgui.Create( "ContentContainer", self )
	self.PropPanel:SetVisible( false )
	self.PropPanel:SetTriggerSpawnlistChange( false )
	
end

function PANEL:RefreshResults() 

	if ( self.Search:GetText() == "" ) then return end

	self.PropPanel:Clear()

	local results = search.GetResults( self.Search:GetText() )

	local Header = self:Add( "ContentHeader" )
		Header:SetText( #results .. " Results for \""..self.Search:GetText().."\"" )
		self.PropPanel:Add( Header )

	for k, v in pairs( results ) do
		self:AddSearchResult( v.text, v.func, v.icon )
	end

	self.PropPanel:SetParent( ContentPanel )
	ContentPanel:SwitchPanel( self.PropPanel );

end

function PANEL:AddSearchResult( text, func, icon )

	if ( !IsValid( icon ) ) then return end

	icon:SetParent( self.PropPanel )
	self.PropPanel:Add( icon )

end


hook.Add( "PopulateContent", "AddSearchContent", function( pnlContent, tree, node )

	-- Add a node to the tree
	--local node = tree:AddNode( "Search", "icon16/magnifier.png" );
	
	-- If we click on the node populate it and switch to it.
	--node.DoClick = function( self )
	
	--	self:DoPopulate()		
	--	pnlContent:SwitchPanel( self.PropPanel );
	
	--end

	ContentPanel = pnlContent

end )