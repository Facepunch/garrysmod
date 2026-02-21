
local PANEL = {}

AccessorFunc( PANEL, "m_pRoot", "Root" )

AccessorFunc( PANEL, "m_pParentNode", "ParentNode" )

AccessorFunc( PANEL, "m_strFolder", "Folder" )
AccessorFunc( PANEL, "m_strFileName", "FileName" )
AccessorFunc( PANEL, "m_strPathID", "PathID" )
AccessorFunc( PANEL, "m_strWildCard", "WildCard" )
AccessorFunc( PANEL, "m_bNeedsPopulating", "NeedsPopulating" )
AccessorFunc( PANEL, "m_bShowFiles", "ShowFiles", FORCE_BOOL )

AccessorFunc( PANEL, "m_bDirty", "Dirty", FORCE_BOOL )
AccessorFunc( PANEL, "m_bHideExpander", "HideExpander", FORCE_BOOL )
AccessorFunc( PANEL, "m_bNeedsChildSearch", "NeedsChildSearch", FORCE_BOOL )

AccessorFunc( PANEL, "m_bForceShowExpander", "ForceShowExpander", FORCE_BOOL )
AccessorFunc( PANEL, "m_bDoubleClickToOpen", "DoubleClickToOpen", FORCE_BOOL )

AccessorFunc( PANEL, "m_bLastChild", "LastChild", FORCE_BOOL )
AccessorFunc( PANEL, "m_bDrawLines", "DrawLines", FORCE_BOOL )
AccessorFunc( PANEL, "m_bExpanded", "Expanded", FORCE_BOOL )
AccessorFunc( PANEL, "m_strDraggableName", "DraggableName" )

function PANEL:Init()

	self:SetDoubleClickToOpen( true )

	self.Label = vgui.Create( "DTree_Node_Button", self )
	self.Label:SetDragParent( self )
	self.Label.DoClick = function() self:InternalDoClick() end
	self.Label.DoDoubleClick = function() self:InternalDoClick() end
	self.Label.DoRightClick = function() self:InternalDoRightClick() end
	self.Label.DragHover = function( s, t ) self:DragHover( t ) end

	self.Expander = vgui.Create( "DExpandButton", self )
	self.Expander.DoClick = function() self:SetExpanded( !self:GetExpanded() ) end
	self.Expander:SetVisible( false )

	self.Icon = vgui.Create( "DImage", self )
	self.Icon:SetImage( "icon16/folder.png" )
	self.Icon:SizeToContents()

	self.animSlide = Derma_Anim( "Anim", self, self.AnimSlide )

	self.fLastClick = SysTime()

	self:SetDrawLines( false )
	self:SetLastChild( false )

end

function PANEL:IsRootNode()
	return self.m_pRoot == self.m_pParentNode
end

function PANEL:InternalDoClick()

	self:GetRoot():SetSelectedItem( self )

	if ( self:DoClick() ) then return end
	if ( self:GetRoot():DoClick( self ) ) then return end

	if ( !self.m_bDoubleClickToOpen || ( SysTime() - self.fLastClick < 0.3 ) ) then
		self:SetExpanded( !self:GetExpanded() )
	end

	self.fLastClick = SysTime()

end

function PANEL:OnNodeSelected( node )

	local parent = self:GetParentNode()
	if ( IsValid( parent ) && parent.OnNodeSelected ) then
		parent:OnNodeSelected( node )
	end

end

function PANEL:OnNodeAdded( node )
	-- Called when Panel.AddNode is called on this node
end

function PANEL:InternalDoRightClick()

	if ( self:DoRightClick() ) then return end
	if ( self:GetRoot():DoRightClick( self ) ) then return end

end

function PANEL:DoClick()
	return false
end

function PANEL:DoRightClick()
	return false
end

function PANEL:Clear()
	if ( IsValid( self.ChildNodes ) ) then self.ChildNodes:Clear() end
end

function PANEL:AnimSlide( anim, delta, data )

	if ( !IsValid( self.ChildNodes ) ) then anim:Stop() return end

	if ( anim.Started ) then
		data.To = self:GetTall()
		data.Visible = self.ChildNodes:IsVisible()
	end

	if ( anim.Finished ) then
		self:InvalidateLayout()
		self.ChildNodes:SetVisible( data.Visible )
		self:SetTall( data.To )
		self:GetParentNode():ChildExpanded()
		return
	end

	self.ChildNodes:SetVisible( true )

	self:SetTall( Lerp( delta, data.From, data.To ) )

	self:GetParentNode():ChildExpanded()

end

function PANEL:SetIcon( str )
	if ( !str || str == "" ) then return end

	self.Icon:SetImage( str )
end

function PANEL:ShowIcons()
	return self:GetParentNode():ShowIcons()
end

function PANEL:GetLineHeight()
	return self:GetParentNode():GetLineHeight()
end

function PANEL:GetIndentSize()
	return self:GetParentNode():GetIndentSize()
end

function PANEL:SetText( strName )

	self.Label:SetText( strName )

end

function PANEL:GetText()

	return self.Label:GetText()

end

function PANEL:ExpandRecurse( bExpand )

	self:SetExpanded( bExpand, true )

	if ( !IsValid( self.ChildNodes ) ) then return end

	for k, Child in pairs( self.ChildNodes:GetChildren() ) do
		if ( Child.ExpandRecurse ) then
			Child:ExpandRecurse( bExpand )
		end
	end

end

function PANEL:ExpandTo( bExpand )

	self:SetExpanded( bExpand, true )
	self:GetParentNode():ExpandTo( bExpand )

end

function PANEL:SetExpanded( bExpand, bSurpressAnimation )

	self:GetParentNode():ChildExpanded( bExpand )
	self.Expander:SetExpanded( bExpand )
	self.m_bExpanded = bExpand
	self:InvalidateLayout( true )

	if ( !IsValid( self.ChildNodes ) ) then return end

	local StartTall = self:GetTall()
	self.animSlide:Stop()

	-- Populate the child folders..
	if ( bExpand && self:PopulateChildrenAndSelf( true ) ) then
		-- Could really do with a 'loading' thing here
		return
	end

	if ( IsValid( self.ChildNodes ) ) then
		self.ChildNodes:SetVisible( bExpand )
		if ( bExpand ) then
			self.ChildNodes:InvalidateLayout( true )
		end
	end

	self:InvalidateLayout( true )

	-- Do animation..
	if ( !bSurpressAnimation ) then
		self.animSlide:Start( 0.3, { From = StartTall } )
		self.animSlide:Run()
	end

end

function PANEL:ChildExpanded( bExpand )

	self.ChildNodes:InvalidateLayout( true )
	self:InvalidateLayout( true )
	self:GetParentNode():ChildExpanded( bExpand )

end

function PANEL:Paint()
end

function PANEL:HasChildren()

	if ( !IsValid( self.ChildNodes ) ) then return false end
	return self.ChildNodes:HasChildren()

end

function PANEL:DoChildrenOrder()

	if ( !IsValid( self.ChildNodes ) ) then return end

	local children = self.ChildNodes:GetChildren()
	local last = #children
	if ( last <= 0 ) then return end

	for i = 1, (last - 1) do
		children[i]:SetLastChild( false )
	end
	children[last]:SetLastChild( true )

end

function PANEL:PerformRootNodeLayout()

	self.Expander:SetVisible( false )
	self.Label:SetVisible( false )
	self.Icon:SetVisible( false )

	if ( IsValid( self.ChildNodes ) ) then

		self.ChildNodes:Dock( TOP )
		self:SetTall( self.ChildNodes:GetTall() )

	end

end

function PANEL:PerformLayout()

	if ( self:IsRootNode() ) then
		return self:PerformRootNodeLayout()
	end

	if ( self.animSlide:Active() ) then return end

	local LineHeight = self:GetLineHeight()

	if ( self.m_bHideExpander ) then

		self.Expander:SetPos( -11, 0 )
		self.Expander:SetSize( 15, 15 )
		self.Expander:SetVisible( false )

	else

		self.Expander:SetPos( 2, 0 )
		self.Expander:SetSize( 15, 15 )
		self.Expander:SetVisible( self:HasChildren() || self:GetForceShowExpander() )
		self.Expander:SetZPos( 10 )

	end

	self.Label:StretchToParent( 0, nil, 0, nil )
	self.Label:SetTall( LineHeight )

	if ( self:ShowIcons() ) then
		self.Icon:SetVisible( true )
		self.Icon:SetPos( self.Expander.x + self.Expander:GetWide() + 4, ( LineHeight - self.Icon:GetTall() ) * 0.5 )
		self.Label:SetTextInset( self.Icon.x + self.Icon:GetWide() + 4, 0 )
	else
		self.Icon:SetVisible( false )
		self.Label:SetTextInset( self.Expander.x + self.Expander:GetWide() + 4, 0 )
	end

	if ( !IsValid( self.ChildNodes ) || !self.ChildNodes:IsVisible() ) then
		self:SetTall( LineHeight )
		return
	end

	self.ChildNodes:SizeToContents()
	self:SetTall( LineHeight + self.ChildNodes:GetTall() )

	self.ChildNodes:StretchToParent( LineHeight, LineHeight, 0, 0 )

	self:DoChildrenOrder()

end

function PANEL:CreateChildNodes()

	if ( IsValid( self.ChildNodes ) ) then return end

	self.ChildNodes = vgui.Create( "DListLayout", self )
	self.ChildNodes:SetDropPos( "852" )
	self.ChildNodes:SetVisible( self:GetExpanded() )
	self.ChildNodes.OnChildRemoved = function()

		self.ChildNodes:InvalidateLayout()

		-- Root node should never be closed
		if ( !self.ChildNodes:HasChildren() && !self:IsRootNode() ) then
			self:SetExpanded( false )
		end

	end

	self.ChildNodes.OnModified = function()

		self:OnModified()

	end

	self:InvalidateLayout()

end

function PANEL:AddPanel( pPanel )

	self:CreateChildNodes()

	self.ChildNodes:Add( pPanel )
	self:InvalidateLayout()

end

function PANEL:AddNode( strName, strIcon )

	self:CreateChildNodes()

	local pNode = vgui.Create( "DTree_Node", self )
	pNode:SetText( strName )
	pNode:SetParentNode( self )
	pNode:SetTall( self:GetLineHeight() )
	pNode:SetRoot( self:GetRoot() )
	pNode:SetIcon( strIcon )
	pNode:SetDrawLines( !self:IsRootNode() )

	self:InstallDraggable( pNode )

	self.ChildNodes:Add( pNode )
	self:InvalidateLayout()

	-- Let addons do whatever they need
	self:OnNodeAdded( pNode )

	return pNode

end

function PANEL:InsertNode( pNode )

	self:CreateChildNodes()

	pNode:SetParentNode( self )
	pNode:SetRoot( self:GetRoot() )
	self:InstallDraggable( pNode )

	self.ChildNodes:Add( pNode )
	self:InvalidateLayout()

	return pNode

end

function PANEL:InstallDraggable( pNode )

	local DragName = self:GetDraggableName()
	if ( !DragName ) then return end

	-- Make this node draggable
	pNode:SetDraggableName( DragName )
	pNode:Droppable( DragName )

	-- Allow item dropping onto us
	self.ChildNodes:MakeDroppable( DragName, true )

end

function PANEL:DroppedOn( pnl )

	self:InsertNode( pnl )
	self:SetExpanded( true )

end

function PANEL:AddFolder( strName, strFolder, strPath, bShowFiles, strWildCard, bDontForceExpandable )

	local node = self:AddNode( strName )
	node:MakeFolder( strFolder, strPath, bShowFiles, strWildCard, bDontForceExpandable )
	return node

end

function PANEL:MakeFolder( strFolder, strPath, bShowFiles, strWildCard, bDontForceExpandable )

	-- Store the data
	self:SetNeedsPopulating( true )
	self:SetWildCard( strWildCard || "*" )
	self:SetFolder( strFolder )
	self:SetPathID( strPath )
	self:SetShowFiles( bShowFiles || false )

	self:CreateChildNodes()
	self:SetNeedsChildSearch( true )

	if ( !bDontForceExpandable ) then
		self:SetForceShowExpander( true )
	end

	-- If the parent is already open, populate myself. Do not require the user to collapse and expand for this to happen
	if ( self:GetParentNode():GetExpanded() ) then
		-- Yuck! This is basically a hack for gameprops.lua
		timer.Simple( 0, function()
			if ( !IsValid( self ) ) then return end
			self:PopulateChildrenAndSelf()
		end )
	end

end

function PANEL:FilePopulateCallback( files, folders, foldername, path, bAndChildren, wildcard )

	local showfiles = self:GetShowFiles()

	self.ChildNodes:InvalidateLayout( true )

	local FileCount = 0

	if ( folders ) then

		for k, File in SortedPairsByValue( folders ) do

			local Node = self:AddNode( File )
			Node:MakeFolder( string.Trim( foldername .. "/" .. File, "/" ), path, showfiles, wildcard, true )
			FileCount = FileCount + 1

		end

	end

	if ( showfiles ) then

		for k, File in SortedPairs( files ) do

			local icon = "icon16/page_white.png"

			local Node = self:AddNode( File, icon )
			Node:SetFileName( string.Trim( foldername .. "/" .. File, "/" ) )
			FileCount = FileCount + 1

		end

	end

	if ( FileCount == 0 ) then
		self.ChildNodes:Remove()
		self.ChildNodes = nil

		self:SetNeedsPopulating( false )
		self:SetShowFiles( nil )
		self:SetWildCard( nil )

		self:InvalidateLayout()

		self.Expander:SetExpanded( true )

		return
	end

	self:InvalidateLayout()

end

function PANEL:FilePopulate( bAndChildren, bExpand )

	if ( !self:GetNeedsPopulating() ) then return end

	local folder = self:GetFolder()
	local path = self:GetPathID()
	local wildcard = self:GetWildCard()

	if ( !folder || !wildcard || !path ) then return false end

	local files, folders = file.Find( string.Trim( folder .. "/" .. wildcard, "/" ), path )
	if ( folders && folders[ 1 ] == "/" ) then table.remove( folders, 1 ) end

	self:SetNeedsPopulating( false )
	self:SetNeedsChildSearch( false )

	self:FilePopulateCallback( files, folders, folder, path, bAndChildren, wildcard )

	if ( bExpand ) then
		self:SetExpanded( true )
	end

	return true

end

function PANEL:PopulateChildren()

	if ( !IsValid( self.ChildNodes ) ) then return end

	for k, v in ipairs( self.ChildNodes:GetChildren() ) do
		timer.Simple( k * 0.1, function()

			if ( IsValid( v ) ) then
				v:FilePopulate( false )
			end

		end )

	end

end

function PANEL:PopulateChildrenAndSelf( bExpand )

	-- Make sure we're populated
	if ( self:FilePopulate( true, bExpand ) ) then return true end

	self:PopulateChildren()

end

function PANEL:SetSelected( b )

	self.Label:SetSelected( b )
	self.Label:InvalidateLayout()

end

function PANEL:Think()

	self.animSlide:Run()

end

--
-- DragHoverClick
--
function PANEL:DragHoverClick( HoverTime )

	if ( !self:GetExpanded() ) then
		self:SetExpanded( true )
	end

	if ( self:GetRoot():GetClickOnDragHover() ) then

		self:InternalDoClick()

	end

end

function PANEL:MoveToTop()

	local parent = self:GetParentNode()
	if ( !IsValid( parent ) ) then return end

	self:GetParentNode():MoveChildTo( self, 1 )

end

function PANEL:MoveChildTo( child )

	self.ChildNodes:InsertAtTop( child )

end

function PANEL:GetText()
	return self.Label:GetText()
end

function PANEL:GetIcon()
	return self.Icon:GetImage()
end

function PANEL:CleanList()

	for k, panel in pairs( self.Items ) do

		if ( !IsValid( panel ) || panel:GetParent() != self.pnlCanvas ) then
			self.Items[k] = nil
		end

	end

end

function PANEL:Insert( pNode, pNodeNextTo, bBefore )

	pNode:SetParentNode( self )
	pNode:SetRoot( self:GetRoot() )

	self:CreateChildNodes()

	if ( bBefore ) then
		self.ChildNodes:InsertBefore( pNodeNextTo, pNode )
	else
		self.ChildNodes:InsertAfter( pNodeNextTo, pNode )
	end

	self:InvalidateLayout()

end

function PANEL:LeaveTree( pnl )

	self.ChildNodes:RemoveItem( pnl, true )
	self:InvalidateLayout()

end

function PANEL:OnModified()

	-- Override Me

end

function PANEL:GetChildNode( iNum )

	if ( !IsValid( self.ChildNodes ) ) then return end
	return self.ChildNodes:GetChild( iNum )

end

function PANEL:GetChildNodes()

	if ( !IsValid( self.ChildNodes ) ) then return {} end
	return self.ChildNodes:GetChildren()

end

function PANEL:GetChildNodeCount()

	if ( !IsValid( self.ChildNodes ) ) then return 0 end
	return self.ChildNodes:ChildCount()

end

function PANEL:Paint( w, h )

	derma.SkinHook( "Paint", "TreeNode", self, w, h )

end

function PANEL:Copy()

	local copy = vgui.Create( "DTree_Node", self:GetParent() )
	copy:SetText( self:GetText() )
	copy:SetIcon( self:GetIcon() )
	copy:SetRoot( self:GetRoot() )
	copy:SetParentNode( self:GetParentNode() )

	if ( self.ChildNodes ) then

		for k, v in ipairs( self.ChildNodes:GetChildren() ) do

			local childcopy = v:Copy()
			copy:InsertNode( childcopy )

		end

	end

	self:SetupCopy( copy )

	return copy

end

function PANEL:SetupCopy( copy )

	-- TODO.

end

derma.DefineControl( "DTree_Node", "Tree Node", PANEL, "DPanel" )
