--[[   _                                
	( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 


--]]

local PANEL = {}

AccessorFunc( PANEL, "m_iSpaceX", 				"SpaceX" )
AccessorFunc( PANEL, "m_iSpaceY", 				"SpaceY" )
AccessorFunc( PANEL, "m_iBorder", 				"Border" )
AccessorFunc( PANEL, "m_iBaseSize", 			"BaseSize" )
AccessorFunc( PANEL, "m_iMinHeight", 			"MinHeight" )

--[[---------------------------------------------------------
   Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

	self:SetDropPos( "46" )
	self:SetMinHeight( 1 )
	
	self:SetSpaceX( 0 )
	self:SetSpaceY( 0 )
	self:SetBorder( 0 )
	self:SetBaseSize( 64 )
	
	self.LastW = 0;
	self.LastH = 0;
	
	self.Tiles = {}
	

end

function PANEL:Layout()

	self.LastW = 0;
	self.LastH = 0;
	self:InvalidateLayout()

end

function PANEL:FitsInTile( x, y, w, h )

	for a=x, x+(w-1) do
		for b=y, y+(h-1) do
		
			if ( self:GetTile( a, b ) == 1 ) then
				return false 
			end
				
		end
	end
	
	return true

end

function PANEL:FindFreeTile( x, y, w, h )

	x = x or 1
	y = y or 1

	local span = math.floor( self:GetWide() / self.m_iBaseSize )
	if ( span < 1 ) then span = 1 end
	
	for i=1, span do
	
		-- Too long to fit on this line
		if ( (i + (w-1)) > span ) then 

			-- If we're on the first part
			-- and the line is empty
			-- add it. It might be too long to fit on anyway		
			if ( i == 1 ) then
			
				if ( self:FitsInTile( i, y, w, h ) ) then 
					return i, y
				end	
				
			end
		
			break 
		end
	
		if ( self:FitsInTile( i, y, w, h ) ) then 
			return i, y
		end
	
	end
	
	return self:FindFreeTile( 1, y + 1, w, h )

end

function PANEL:ClearTiles()

	self.Tiles = {}

end

function PANEL:GetTile( x, y )

	if ( !self.Tiles[y] ) then 
		return nil
	end
	
	return self.Tiles[y][x]

end

function PANEL:SetTile( x, y, val )

	if ( !self.Tiles[y] ) then 
		self.Tiles[y] = {}
	end
	
	self.Tiles[y][x] = val

end

function PANEL:ConsumeTiles( x, y, w, h )

	for a=x, x+(w-1) do
		for b=y, y+(h-1) do
			self:SetTile( a, b, 1 )
		end
	end

end

function PANEL:LayoutTiles()

	local StartLine = 1;
	local LastX		= 1;
	local tilesize	= self.m_iBaseSize;
	local MaxWidth	= math.ceil( self:GetWide() / tilesize );
	
	self:ClearTiles()
	
	local chld = self:GetChildren()
	for k, v in pairs( chld ) do
	
		if ( !v:IsVisible() ) then continue end
		
		local w = math.ceil( v:GetWide() / tilesize )
		local h = math.ceil( v:GetTall() / tilesize )
		
		if ( v.OwnLine ) then
			w = MaxWidth
		end
		
		local x, y = self:FindFreeTile( 1, StartLine, w, h )
		
		v:SetPos( (x-1) * tilesize, (y-1) * tilesize )
		
		self:ConsumeTiles( x, y, w, h )
		
		if ( v.OwnLine ) then
			StartLine = y + 1
		end
		
		LastX = x
		

	end
	
end

function PANEL:PerformLayout()

	local ShouldLayout = false;
	
	if ( self.LastW != self:GetWide() )		then ShouldLayout = true end
	if ( self.LastH != self:GetTall() )		then ShouldLayout = true end
	
	self.LastW = self:GetWide()
	self.LastH = self:GetTall()

	if ( ShouldLayout ) then
		self:LayoutTiles()
	end
	
	local w, h = self:ChildrenSize();
	h = math.max( h, self:GetMinHeight() )

	self:SetHeight( h )

end

function PANEL:OnModified()

	-- Override me

end

function PANEL:OnChildRemoved()

	self:Layout()
	
end

function PANEL:OnChildAdded( child )
	
	local dn = self:GetDnD()
	if ( dn ) then
		child:Droppable( self:GetDnD() );			
	end
	
	if ( self:IsSelectionCanvas() ) then
		child:SetSelectable( true )
	end
	
	self:Layout()
	
end

function PANEL:Copy()

	local copy = vgui.Create( "DTileLayout", self:GetParent() )
	copy:CopyBase( self )
	copy:SetSortable( self:GetSortable() )
	copy:SetDnD( self:GetDnD() )
	copy:SetSpaceX( self:GetSpaceX() )
	copy:SetSpaceX( self:GetSpaceX() )
	copy:SetSpaceY( self:GetSpaceY() )
	copy:SetBorder( self:GetBorder() )
	copy:SetSelectionCanvas( self:GetSelectionCanvas() )
	copy.OnModified = self.OnModified
	
	copy:CopyContents( self )
	
	return copy

end

function PANEL:CopyContents( from )

	for k, v in pairs( from:GetChildren() ) do
	
		v:Copy():SetParent( self )
	
	end

end

--[[---------------------------------------------------------
   Name: GenerateExample
-----------------------------------------------------------]]
function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local pnl = vgui.Create( ClassName )
	pnl:MakeDroppable( "ExampleDraggable", false )
	pnl:SetSize( 200, 200 )
	pnl:SetUseLiveDrag( true )
	pnl:SetSelectionCanvas( true )
	pnl:SetSpaceX( 4 )
	pnl:SetSpaceY( 4 )
	
	for i=1, 32 do
		
		local btn = pnl:Add( "DButton" )
		btn:SetSize( 32, 32 )
		btn:SetText( i )
		
	end
		
	PropertySheet:AddSheet( ClassName, pnl, nil, true, true )

end

derma.DefineControl( "DTileLayout", "", PANEL, "DDragBase" )

