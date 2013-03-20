--[[   _                                
	( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 


--]]
local PANEL = {}

AccessorFunc( PANEL, "m_bSizeToContents", 		"AutoSize" )
AccessorFunc( PANEL, "m_bStretchHorizontally", 	"StretchHorizontally" )
AccessorFunc( PANEL, "m_bNoSizing", 			"NoSizing" )
AccessorFunc( PANEL, "m_bSortable", 			"Sortable" )
AccessorFunc( PANEL, "m_fAnimTime", 			"AnimTime" )
AccessorFunc( PANEL, "m_fAnimEase", 			"AnimEase" )
AccessorFunc( PANEL, "m_strDraggableName", 		"DraggableName" )

AccessorFunc( PANEL, "Spacing", 	"Spacing" )
AccessorFunc( PANEL, "Padding", 	"Padding" )

--[[---------------------------------------------------------
   Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

	self:SetDraggableName( "GlobalDPanel" );

	self.pnlCanvas 	= vgui.Create( "DPanel", self )
	self.pnlCanvas:SetPaintBackground( false )
	self.pnlCanvas.OnMousePressed = function( self, code ) self:GetParent():OnMousePressed( code ) end
	self.pnlCanvas.OnChildRemoved = function() self:OnChildRemoved() end
	self.pnlCanvas:SetMouseInputEnabled( true )
	self.pnlCanvas.InvalidateLayout = function() self:InvalidateLayout() end
	
	self.Items = {}
	self.YOffset = 0
	self.m_fAnimTime = 0;
	self.m_fAnimEase = -1; -- means ease in out
	self.m_iBuilds = 0
	
	self:SetSpacing( 0 )
	self:SetPadding( 0 )
	self:EnableHorizontal( false )
	self:SetAutoSize( false )
	self:SetDrawBackground( true )
	self:SetNoSizing( false )
	
	self:SetMouseInputEnabled( true )
	
	-- This turns off the engine drawing
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )

end

function PANEL:OnModified()

	-- Override me

end

function PANEL:SizeToContents()

	self:SetSize( self.pnlCanvas:GetSize() )
	
end

function PANEL:GetItems()

	-- Should we return a copy of this to stop 
	-- people messing with it?
	return self.Items
	
end

--[[---------------------------------------------------------
   Name: EnableHorizontal
-----------------------------------------------------------]]
function PANEL:EnableHorizontal( bHoriz )

	self.Horizontal = bHoriz
	
end

--[[---------------------------------------------------------
   Name: EnableVerticalScrollbar
-----------------------------------------------------------]]
function PANEL:EnableVerticalScrollbar()

	if (self.VBar) then return end
	
	self.VBar = vgui.Create( "DVScrollBar", self )
	
end

--[[---------------------------------------------------------
   Name: GetCanvas
-----------------------------------------------------------]]
function PANEL:GetCanvas()

	return self.pnlCanvas

end

--[[---------------------------------------------------------
   Name: Clear
-----------------------------------------------------------]]
function PANEL:Clear( bDelete )

	for k, panel in pairs( self.Items ) do
	
		if ( !IsValid( panel ) ) then continue end
		
		panel:SetVisible( false )
	
		if ( bDelete ) then
			panel:Remove()
		end
		
	end
	
	self.Items = {}

end


--[[---------------------------------------------------------
   Name: AddItem
-----------------------------------------------------------]]
function PANEL:AddItem( item, strLineState )

	if ( !IsValid( item ) ) then return end

	item:SetVisible( true )
	item:SetParent( self:GetCanvas() )
	item.m_strLineState = strLineState or item.m_strLineState;
	table.insert( self.Items, item )
	
	if ( self.m_bSortable ) then
	
		//local DragSlot = item:MakeDraggable( self:GetDraggableName(), self );
		//DragSlot.OnDrop = self.DropAction
			
	end
	
	item:SetSelectable( self.m_bSelectionCanvas );
	
	self:InvalidateLayout()

end

function PANEL:InsertBefore( before, insert, strLineState )

	table.RemoveByValue( self.Items, insert )
	
	self:AddItem( insert, strLineState )
	
	local key = table.KeyFromValue( self.Items, before )
	
	if ( key ) then
		table.RemoveByValue( self.Items, insert )
		table.insert( self.Items, key, insert )
	end

end

function PANEL:InsertAfter( before, insert, strLineState )

	table.RemoveByValue( self.Items, insert )
	self:AddItem( insert, strLineState )
	
	local key = table.KeyFromValue( self.Items, before )
	
	if ( key ) then
		table.RemoveByValue( self.Items, insert )
		table.insert( self.Items, key+1, insert )
	end

end

function PANEL:InsertAtTop( insert, strLineState )

	table.RemoveByValue( self.Items, insert )
	self:AddItem( insert, strLineState )
	
	local key = 1
	if ( key ) then
		table.RemoveByValue( self.Items, insert )
		table.insert( self.Items, key, insert )
	end
	
end

function PANEL.DropAction( Slot, RcvSlot )

	local PanelToMove = Slot.Panel;	
	if ( dragndrop.m_MenuData == "copy" ) then
	
		if ( PanelToMove.Copy ) then
			
			PanelToMove = Slot.Panel:Copy()
			
			PanelToMove.m_strLineState = Slot.Panel.m_strLineState
		else
			return
		end
	
	end
	
	PanelToMove:SetPos( RcvSlot.Data.pnlCanvas:ScreenToLocal( gui.MouseX() - dragndrop.m_MouseLocalX, gui.MouseY() - dragndrop.m_MouseLocalY ) )
	
	if ( dragndrop.DropPos == 4 || dragndrop.DropPos == 8 ) then
		RcvSlot.Data:InsertBefore( RcvSlot.Panel, PanelToMove )
	else
		RcvSlot.Data:InsertAfter( RcvSlot.Panel, PanelToMove )
	end

end

--[[---------------------------------------------------------
   Name: RemoveItem
-----------------------------------------------------------]]
function PANEL:RemoveItem( item, bDontDelete )

	for k, panel in pairs( self.Items ) do
	
		if ( panel == item ) then
		
			self.Items[ k ] = nil
			
			if (!bDontDelete) then
				panel:Remove()
			end
		
			self:InvalidateLayout()
		
		end
	
	end

end

function PANEL:CleanList()

	for k, panel in pairs( self.Items ) do
	
		if ( !IsValid( panel ) || panel:GetParent() != self.pnlCanvas ) then
			self.Items[k] = nil
		end
	
	end

end

--[[---------------------------------------------------------
   Name: Rebuild
-----------------------------------------------------------]]
function PANEL:Rebuild()

	local Offset = 0
	self.m_iBuilds = self.m_iBuilds + 1;

	self:CleanList()
	
	if ( self.Horizontal ) then
	
		local x, y = self.Padding, self.Padding;
		for k, panel in pairs( self.Items ) do
		
			if ( panel:IsVisible() ) then
			
				local OwnLine = (panel.m_strLineState && panel.m_strLineState == "ownline");
			
				local w = panel:GetWide()
				local h = panel:GetTall()
				
				if ( x > self.Padding && (x + w  > self:GetWide() || OwnLine) ) then
				
					x = self.Padding
					y = y + h + self.Spacing
				
				end
				
				if ( self.m_fAnimTime > 0 && self.m_iBuilds > 1 ) then
					panel:MoveTo( x, y, self.m_fAnimTime, 0, self.m_fAnimEase )
				else
					panel:SetPos( x, y )
				end
				
				x = x + w + self.Spacing
				Offset = y + h + self.Spacing
				
				if ( OwnLine ) then
				
					x = self.Padding
					y = y + h + self.Spacing
				
				end
			
			end
		
		end
	
	else
	
		for k, panel in pairs( self.Items ) do
		
			if ( panel:IsVisible() ) then
				
				if ( self.m_bNoSizing ) then
					panel:SizeToContents()
					if ( self.m_fAnimTime > 0 && self.m_iBuilds > 1 ) then
						panel:MoveTo( (self:GetCanvas():GetWide() - panel:GetWide()) * 0.5, self.Padding + Offset, self.m_fAnimTime, 0, self.m_fAnimEase )
					else
						panel:SetPos( (self:GetCanvas():GetWide() - panel:GetWide()) * 0.5, self.Padding + Offset )
					end
				else
					panel:SetSize( self:GetCanvas():GetWide() - self.Padding * 2, panel:GetTall() )
					if ( self.m_fAnimTime > 0 && self.m_iBuilds > 1 ) then
						panel:MoveTo( self.Padding, self.Padding + Offset, self.m_fAnimTime, self.m_fAnimEase )
					else
						panel:SetPos( self.Padding, self.Padding + Offset )
					end
				end
				
				-- Changing the width might ultimately change the height
				-- So give the panel a chance to change its height now, 
				-- so when we call GetTall below the height will be correct.
				-- True means layout now.
				panel:InvalidateLayout( true )
				
				Offset = Offset + panel:GetTall() + self.Spacing
				
			end
		
		end
		
		Offset = Offset + self.Padding
		
	end
	
	self:GetCanvas():SetTall( Offset + self.Padding - self.Spacing ) 

	-- Although this behaviour isn't exactly implied, center vertically too
	if ( self.m_bNoSizing && self:GetCanvas():GetTall() < self:GetTall() ) then

		self:GetCanvas():SetPos( 0, (self:GetTall()-self:GetCanvas():GetTall()) * 0.5 )
	
	end
	
end

--[[---------------------------------------------------------
   Name: OnMouseWheeled
-----------------------------------------------------------]]
function PANEL:OnMouseWheeled( dlta )

	if ( self.VBar ) then
		return self.VBar:OnMouseWheeled( dlta )
	end
	
end

--[[---------------------------------------------------------
   Name: Paint
-----------------------------------------------------------]]
function PANEL:Paint( w, h )
	
	derma.SkinHook( "Paint", "PanelList", self, w, h )
	return true
	
end

--[[---------------------------------------------------------
   Name: OnVScroll
-----------------------------------------------------------]]
function PANEL:OnVScroll( iOffset )

	self.pnlCanvas:SetPos( 0, iOffset )
	
end

--[[---------------------------------------------------------
   Name: PerformLayout
-----------------------------------------------------------]]
function PANEL:PerformLayout()

	local Wide = self:GetWide()
	local YPos = 0
	
	if ( !self.Rebuild ) then
		debug.Trace()
	end
	
	self:Rebuild()
	
	if ( self.VBar && !m_bSizeToContents ) then

		self.VBar:SetPos( self:GetWide() - 13, 0 )
		self.VBar:SetSize( 13, self:GetTall() )
		self.VBar:SetUp( self:GetTall(), self.pnlCanvas:GetTall() )
		YPos = self.VBar:GetOffset()
		
		if ( self.VBar.Enabled ) then Wide = Wide - 13 end

	end

	self.pnlCanvas:SetPos( 0, YPos )
	self.pnlCanvas:SetWide( Wide )
	
	self:Rebuild()
	
	if ( self:GetAutoSize() ) then
	
		self:SetTall( self.pnlCanvas:GetTall() )
		self.pnlCanvas:SetPos( 0, 0 )
	
	end	

end


function PANEL:OnChildRemoved()

	self:CleanList()
	self:InvalidateLayout()
	
end

--[[---------------------------------------------------------
   Name: ScrollToChild
-----------------------------------------------------------]]
function PANEL:ScrollToChild( panel )

	local x, y = self.pnlCanvas:GetChildPosition( panel )
	local w, h = panel:GetSize()
	
	y = y + h * 0.5;
	y = y - self:GetTall() * 0.5;

	self.VBar:AnimateTo( y, 0.5, 0, 0.5 );
	
end


--[[---------------------------------------------------------
   Name: SortByMember
-----------------------------------------------------------]]
function PANEL:SortByMember( key, desc )

	desc = desc or true

	table.sort( self.Items, function( a, b ) 

								if ( desc ) then
								
									local ta = a
									local tb = b
									
									a = tb
									b = ta
								
								end
	
								if ( a[ key ] == nil ) then return false end
								if ( b[ key ] == nil ) then return true end
								
								return a[ key ] > b[ key ]
								
							end )

end

derma.DefineControl( "DPanelList", "A Panel that neatly organises other panels", PANEL, "DPanel" )
