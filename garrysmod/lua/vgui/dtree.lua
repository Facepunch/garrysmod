--[[   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

	DTree
	
--]]
	
local PANEL = {}

AccessorFunc( PANEL, "m_bShowIcons", 			"ShowIcons" )
AccessorFunc( PANEL, "m_iIndentSize", 			"IndentSize" )
AccessorFunc( PANEL, "m_iLineHeight", 			"LineHeight" )
AccessorFunc( PANEL, "m_pSelectedItem",			"SelectedItem" )
AccessorFunc( PANEL, "m_bClickOnDragHover",		"ClickOnDragHover" )

--[[---------------------------------------------------------
   Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

	//self:SetMouseInputEnabled( true )
	//self:SetClickOnDragHover( false )
	
	self:SetShowIcons( true )
	self:SetIndentSize( 14 )
	self:SetLineHeight( 17 )
	//self:SetPadding( 2 )
	
	self.RootNode = self:GetCanvas():Add( "DTree_Node" );
	self.RootNode:SetRoot( self )
	self.RootNode:SetParentNode( self )
	self.RootNode:Dock( TOP )
	self.RootNode:SetText( "" )
	self.RootNode:SetExpanded( true, true )
	self.RootNode:DockMargin( 0, 4, 0, 0 )
	
	self:SetPaintBackground( true )

end

--
-- Get the root node
--
function PANEL:Root()
	return self.RootNode;
end

--[[---------------------------------------------------------
   Name: AddNode
-----------------------------------------------------------]]
function PANEL:AddNode( strName, strIcon )

	return self.RootNode:AddNode( strName, strIcon )
	
end

--[[---------------------------------------------------------
   Name: ChildExpanded
-----------------------------------------------------------]]
function PANEL:ChildExpanded( bExpand )

	self:InvalidateLayout()
	
end

--[[---------------------------------------------------------
   Name: ShowIcons
-----------------------------------------------------------]]
function PANEL:ShowIcons()

	return self.m_bShowIcons

end

--[[---------------------------------------------------------
   Name: ExpandTo
-----------------------------------------------------------]]
function PANEL:ExpandTo( bExpand )

end

--[[---------------------------------------------------------
   Name: SetExpanded
-----------------------------------------------------------]]
function PANEL:SetExpanded( bExpand )

	-- The top most node shouldn't react to this.

end

--[[---------------------------------------------------------
   Name: Clear
-----------------------------------------------------------]]
function PANEL:Clear()

end

--[[---------------------------------------------------------
   Name: Paint
-----------------------------------------------------------]]
function PANEL:Paint( w, h )
	
	derma.SkinHook( "Paint", "Tree", self, w, h )
	return true
	
end

--[[---------------------------------------------------------
   Name: DoClick
-----------------------------------------------------------]]
function PANEL:DoClick( node )
	return false
end

--[[---------------------------------------------------------
   Name: DoRightClick
-----------------------------------------------------------]]
function PANEL:DoRightClick( node )
	return false
end

--[[---------------------------------------------------------
   Name: SetSelectedItem
-----------------------------------------------------------]]
function PANEL:SetSelectedItem( node )
	
	if ( IsValid( self.m_pSelectedItem ) ) then
		self.m_pSelectedItem:SetSelected( false )
	end
	
	self.m_pSelectedItem = node
	
	if ( node ) then
		node:SetSelected( true )
		node:OnNodeSelected( node )
	end
	
end

function PANEL:OnNodeSelected( node )

end

function PANEL:MoveChildTo( child, pos )

	self:InsertAtTop( child )

end

function PANEL:LayoutTree()

	self:InvalidateChildren( true )

end

--[[---------------------------------------------------------
   Name: GenerateExample
-----------------------------------------------------------]]
function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local ctrl = vgui.Create( ClassName )
		//ctrl:SetPadding( 5 )
		ctrl:SetSize( 300, 300 )
		
		local node = ctrl:AddNode( "Node One" )
		local node = ctrl:AddNode( "Node Two" )
			local cnode = node:AddNode( "Node 2.1" )
			local cnode = node:AddNode( "Node 2.2" )
			local cnode = node:AddNode( "Node 2.3" )
			local cnode = node:AddNode( "Node 2.4" )
			local cnode = node:AddNode( "Node 2.5" )
			for i=1, 64 do
				local gcnode = cnode:AddNode( "Node 2.5."..i )
			end
			local cnode = node:AddNode( "Node 2.6" )
		local node = ctrl:AddNode( "Node Three ( Maps Folder )" )
			node:MakeFolder( "maps", "GAME" )
		local node = ctrl:AddNode( "Node Four" )
		
	
	PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )

end


derma.DefineControl( "DTree", "Tree View", PANEL, "DScrollPanel" )

