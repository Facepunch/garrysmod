
local PANEL = {}

AccessorFunc( PANEL, "m_strName",			"Name" )
AccessorFunc( PANEL, "m_strPath",			"Path" )
AccessorFunc( PANEL, "m_strFilter",			"FileTypes" )
AccessorFunc( PANEL, "m_strBaseFolder",		"BaseFolder" )
AccessorFunc( PANEL, "m_strCurrentFolder",	"CurrentFolder" )
AccessorFunc( PANEL, "m_strSearch",			"Search" )
AccessorFunc( PANEL, "m_bModels",			"Models" )
AccessorFunc( PANEL, "m_bOpen",				"Open" )

function PANEL:Init()

	self:SetPath( "GAME" )

	self.Divider = self:Add( "DHorizontalDivider" )
	self.Divider:Dock( FILL )
	self.Divider:SetLeftWidth( 160 )
	self.Divider:SetDividerWidth( 4 )
	self.Divider:SetLeftMin( 100 )
	self.Divider:SetRightMin( 100 )

	self.Tree = self.Divider:Add( "DTree" )
	self.Divider:SetLeft( self.Tree )

	self.Tree.DoClick = function( _, node )
		local folder = node:GetFolder()
		if ( !folder ) then return end

		self:SetCurrentFolder( folder )
	end

end

function PANEL:SetName( strName )

	if ( strName ) then
		self.m_strName = tostring( strName )
	else
		self.m_strName = nil
	end

	if ( !self.bSetup ) then return end

	self:SetupTree()

end

function PANEL:SetBaseFolder( strBase )

	self.m_strBaseFolder = tostring( strBase )
	if ( !self.bSetup ) then return end

	self:SetupTree()

end

function PANEL:SetPath( strPath )

	self.m_strPath = tostring( strPath )
	if ( !self.bSetup ) then return end

	self:SetupTree()

end

function PANEL:SetSearch( strSearch )

	if ( !strSearch || strSearch == "" ) then
		strSearch = "*"
	end

	self.m_strSearch = tostring( strSearch )
	if ( !self.bSetup ) then return end

	self:SetupTree()

end

function PANEL:SetFileTypes( strTypes )

	self.m_strFilter = tostring( strTypes || "*.*" )
	if ( !self.bSetup ) then return end

	if ( self.m_strCurrentFolder ) then
		self:ShowFolder( self.m_strCurrentFolder )
	end

end

function PANEL:SetModels( bUseModels )

	self.m_bModels = tobool( bUseModels )
	if ( !self.bSetup ) then return end

	self:SetupFiles()
	if ( self.m_strCurrentFolder ) then
		self:ShowFolder( self.m_strCurrentFolder )
	end

end

function PANEL:SetCurrentFolder( strDir )

	strDir = tostring( strDir )
	strDir = string.Trim( strDir, "/" )

	if ( self.m_strBaseFolder && !string.StartWith( strDir, self.m_strBaseFolder ) ) then
		strDir = string.Trim( self.m_strBaseFolder, "/" ) .. "/" .. string.Trim( strDir, "/" )
	end

	self.m_strCurrentFolder = strDir
	if ( !self.bSetup ) then return end

	self:ShowFolder( strDir )

end

function PANEL:SetOpen( bOpen, bAnim )

	bOpen = tobool( bOpen )
	self.m_bOpen = bOpen

	if ( !self.bSetup ) then return end

	self.FolderNode:SetExpanded( bOpen, !bAnim )
	self.m_bOpen = bOpen
	self:SetCookie( "Open", bOpen && "1" || "0" )

end

function PANEL:Paint( w, h )

	DPanel.Paint( self, w, h )

	if ( !self.bSetup ) then
		self.bSetup = self:Setup()
	end

end

function PANEL:SetupTree()

	local name = self.m_strName
	if ( !name ) then name = string.Trim( string.match( self.m_strBaseFolder, "/.+$" ) || self.m_strBaseFolder, "/" ) end

	local children = self.Tree.RootNode.ChildNodes
	if ( IsValid( children ) ) then
		children:Clear()
	end

	self.FolderNode = self.Tree.RootNode:AddFolder( name, self.m_strBaseFolder, self.m_strPath, false, self.m_strSearch )
	self.Tree.RootNode.ChildExpanded = function( node, bExpand )
		DTree_Node.ChildExpanded( node, bExpand )
		self.m_bOpen = tobool( self.FolderNode.m_bExpanded )
		self:SetCookie( "Open", self.m_bOpen && "1" || "0" )
	end

	self.FolderNode:SetExpanded( self.m_bOpen, true )
	self:SetCookie( "Open", self.m_bOpen && "1" || "0" )

	self:ShowFolder()

	return true

end

function PANEL:SetupFiles()

	if ( IsValid( self.Files ) ) then self.Files:Remove() end

	if ( self.m_bModels ) then
		self.Files = self.Divider:Add( "DIconBrowser" )
		self.Files:SetManual( true )
		self.Files:SetBackgroundColor( Color( 234, 234, 234 ) )
	else
		self.Files = self.Divider:Add( "DListView" )
		self.Files:SetMultiSelect( false )
		self.FileHeader = self.Files:AddColumn( "Files" ).Header

		self.Files.DoDoubleClick = function( pnl, _, line )
			self:OnDoubleClick( string.Trim( self:GetCurrentFolder() .. "/" .. line:GetColumnText( 1 ), "/" ), line )
		end
		self.Files.OnRowSelected = function( pnl, _, line )
			self:OnSelect( string.Trim( self:GetCurrentFolder() .. "/" .. line:GetColumnText( 1 ), "/" ), line )
		end
		self.Files.OnRowRightClick = function( pnl, _, line )
			self:OnRightClick( string.Trim( self:GetCurrentFolder() .. "/" .. line:GetColumnText( 1 ), "/" ), line )
		end
	end
	self.Divider:SetRight( self.Files )

	if ( self.m_strCurrentFolder && self.m_strCurrentFolder != "" ) then
		self:ShowFolder( self.m_strCurrentFolder )
	end

	return true

end

function PANEL:Setup()

	if ( !self.m_strBaseFolder ) then return false end

	return self:SetupTree() && self:SetupFiles()

end

function PANEL:ShowFolder( path )

	if ( !IsValid( self.Files ) ) then return end

	self.Files:Clear()

	if ( IsValid( self.FileHeader ) ) then
		self.FileHeader:SetText( path || "Files" )
	end

	if ( !path ) then return end

	local filters = self.m_strFilter
	if ( !filters || filters == "" ) then
		filters = "*.*"
	end

	for _, filter in pairs( string.Explode( " ", filters ) ) do

		local files = file.Find( string.Trim( path .. "/" .. ( filter || "*.*" ), "/" ), self.m_strPath )
		if ( !istable( files ) ) then continue end

		for _, v in pairs( files ) do

			if ( self.m_bModels ) then

				local icon = self.Files:Add( "SpawnIcon" )
				icon:SetModel( path .. "/" .. v )
				icon.DoClick = function( pnl )
					if ( pnl.LastClickTime && SysTime() - pnl.LastClickTime < 0.3 ) then
						self:OnDoubleClick( path .. "/" .. v, icon )
					else
						self:OnSelect( path .. "/" .. v, icon )
					end
					pnl.LastClickTime = SysTime()
				end
				icon.DoRightClick = function()
					self:OnRightClick( path .. "/" .. v, icon )
				end
			else
				self.Files:AddLine( v )
			end

		end

	end

end

function PANEL:SortFiles( desc )

	if ( !self:GetModels() ) then
		self.Files:SortByColumn( 1, tobool( desc ) )
	end

end

function PANEL:GetFolderNode()

	return self.FolderNode

end

function PANEL:Clear()

	DPanel.Clear( self )

	self.m_strBaseFolder, self.m_strCurrentFolder, self.m_strFilter, self.m_strName, self.m_strSearch, self.Divider.m_pRight = nil
	self.m_bOpen, self.m_bModels, self.m_strPath = false, false, "GAME"
	self.bSetup = nil

	self:Init()

end

function PANEL:LoadCookies()

	self:SetOpen( self:GetCookieNumber( "Open" ), true )

end

function PANEL:OnSelect( path, pnl )

	-- For override

end

function PANEL:OnDoubleClick( path, pnl )

	-- For override

end

function PANEL:OnRightClick( path, pnl )

	-- For override

end

function PANEL:GenerateExample( class, sheet, w, h )

	local browser = vgui.Create( class, frame )
	browser:Dock( FILL )
	browser:DockMargin( 5, 0, 5, 5 )

	browser:SetPath( "GAME" ) -- The access path i.e. GAME, LUA, DATA etc.
	browser:SetBaseFolder( "data" ) -- The root folder
	browser:SetOpen( true ) -- Open the tree to show sub-folders

	function browser:OnSelect( path, pnl ) -- Called when a file is clicked
		-- Do something
	end

	sheet:AddSheet( class, browser, nil, true, true )

end

derma.DefineControl( "DFileBrowser", "A tree and list-based file browser", PANEL, "DPanel" )
