
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

	self.Search.SpawnlistBtn = self.Search:Add( "DImageButton" )
	self.Search.SpawnlistBtn:SetImage( "icon16/page_add.png" )
	self.Search.SpawnlistBtn:SetText( "" )
	self.Search.SpawnlistBtn:Dock( RIGHT )
	self.Search.SpawnlistBtn:DockMargin( 4, 2, 4, 2 )
	self.Search.SpawnlistBtn:SetSize( 16, 16 )
	self.Search.SpawnlistBtn:SetTooltip( "Create spawnlist from results" )
	self.Search.SpawnlistBtn.DoClick = function()

		self:CreateSpawnlistFromResults( self.Search:GetText() )

	end
	self.Search.SpawnlistBtn:SetVisible( false )

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

	if ( self.Search:GetText() == "" ) then self.Search.SpawnlistBtn:SetVisible( false ) return end
	self.Search.SpawnlistBtn:SetVisible( true )

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

function PANEL:CreateSpawnlistFromResults( name )

	--
	-- Search results don't just include models, they pick up vehicles, NPCs, weapons, etc too
	-- Spawnlists are intended for models only (as far as I can see), so filter then out
	--
	local results = self.PropPanel:ContentsToTable()
	local mdlresults = {}
	for k, v in pairs( results ) do

		if v.type == "model" then

			table.insert( mdlresults, v )

		end

	end

	if #mdlresults == 0 then return end -- don't create an empty spawnlist

	local node = CustomizableSpawnlistNode:AddNode( name, "icon16/magnifier.png" )

	node.OnModified = function()
		hook.Run( "SpawnlistContentChanged" )
	end
		
	node.DoRightClick = function( self )
	
		local menu = DermaMenu()
		menu:AddOption( "Edit", function() self:InternalDoClick(); hook.Run( "OpenToolbox" )  end )
		menu:AddOption( "New Category", function() AddCustomizableNode( ContentPanel, "New Category", "", self ); self:SetExpanded( true ); hook.Run( "SpawnlistContentChanged" ) end )
		menu:AddOption( "Delete", function() node:Remove(); hook.Run( "SpawnlistContentChanged" ) end )
		
		
		menu:Open()
	
	end
	
	node.DoPopulate = function( self )
	
		if self.PropPanel then return end

		self.PropPanel = vgui.Create( "ContentContainer", ContentPanel )
		self.PropPanel:SetVisible( false )
		
		for i, object in SortedPairs( mdlresults ) do

			local cp = spawnmenu.GetContentType( object.type )
			if ( cp ) then cp( self.PropPanel, object ) end

		end 

		self.PropPanel:SetTriggerSpawnlistChange( true )

	end
	
	node.DoClick = function( self )
	
		self:DoPopulate()		
		ContentPanel:SwitchPanel( self.PropPanel );
	
	end

	--
	-- Save the new spawnlist
	--
	hook.Run( "SpawnlistContentChanged" )

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