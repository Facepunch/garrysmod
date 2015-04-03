--[[   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

DHorizontalDivider: modified from DVerticalDivider by TAD2020
--]]

local PANEL = {}

--[[---------------------------------------------------------
	Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

	self:SetCursor( "sizewe" )
	self:SetPaintBackground( false )

end

--[[---------------------------------------------------------
	Name: OnMousePressed
-----------------------------------------------------------]]
function PANEL:OnMousePressed( mcode )

	if ( mcode == MOUSE_LEFT ) then
		self:GetParent():StartGrab()
	end

end



derma.DefineControl( "DHorizontalDividerBar", "", PANEL, "DPanel" )




local PANEL = {}

AccessorFunc( PANEL, "m_pLeft", 				"Left" )
AccessorFunc( PANEL, "m_pRight", 				"Right" )
AccessorFunc( PANEL, "m_pMiddle", 				"Middle" )
AccessorFunc( PANEL, "m_iDividerWidth", 		"DividerWidth" )
AccessorFunc( PANEL, "m_iLeftWidth", 			"LeftWidth" )
AccessorFunc( PANEL, "m_bDragging", 			"Dragging", 		FORCE_BOOL )

AccessorFunc( PANEL, "m_iLeftWidthMin", 		"LeftMin" )
AccessorFunc( PANEL, "m_iRightWidthMin", 		"RightMin" )

AccessorFunc( PANEL, "m_iHoldPos", 				"HoldPos" )

--[[---------------------------------------------------------
	Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

	self:SetDividerWidth( 8 )
	self:SetLeftWidth( 100 )
	
	self:SetLeftMin( 50 )
	self:SetRightMin( 50 )
	
	self:SetPaintBackground( false )
	
	self.m_DragBar = vgui.Create( "DHorizontalDividerBar", self )

end

--[[---------------------------------------------------------
	Name: LoadCookies
-----------------------------------------------------------]]
function PANEL:LoadCookies()

	self:SetLeftWidth( self:GetCookieNumber( "LeftWidth", self:GetLeftWidth() ) )

end

--[[---------------------------------------------------------
	Name: SetLeft
-----------------------------------------------------------]]
function PANEL:SetLeft( pnl )

	self.m_pLeft = pnl
	self.m_pLeft:SetParent( self )

end

--[[---------------------------------------------------------
	Name: SetRight
-----------------------------------------------------------]]
function PANEL:SetRight( pnl )

	self.m_pRight = pnl
	self.m_pRight:SetParent( self )

end

--[[---------------------------------------------------------
	Name: PerformLayout
-----------------------------------------------------------]]
function PANEL:PerformLayout()

	if ( self.m_pLeft ) then
	
		self.m_pLeft:StretchToParent( 0, 0, nil, 0 )
		self.m_pLeft:SetWide( self.m_iLeftWidth )
		self.m_pLeft:InvalidateLayout()
	
	end
	
	if ( self.m_pRight ) then
	
		self.m_pRight:StretchToParent( self.m_iLeftWidth + self.m_iDividerWidth, 0, 0, 0 )
		self.m_pRight:InvalidateLayout()
		
	end
	
	self.m_DragBar:StretchToParent( self.m_iLeftWidth, 0, 0, 0 )
	self.m_DragBar:SetWide( self.m_iDividerWidth )
	self.m_DragBar:SetZPos( -1 )
	
	if ( self.m_pMiddle ) then

		self.m_pMiddle:StretchToParent( 0, 0, 0, 0 )
		self.m_pMiddle:InvalidateLayout()

	end

end


--[[---------------------------------------------------------
	Name: SetMiddle
-----------------------------------------------------------]]
function PANEL:SetMiddle( Middle )

	self.m_pMiddle = Middle

	if ( Middle ) then
	
		Middle:SetParent( self.m_DragBar )
	
	end

	
end

--[[---------------------------------------------------------
	Name: OnCursorMoved
-----------------------------------------------------------]]
function PANEL:OnCursorMoved( x, y )

	if ( !self:GetDragging() ) then return end
	
	x = math.Clamp( x - self:GetHoldPos(), self:GetLeftMin(), self:GetWide() - self:GetRightMin() - self:GetDividerWidth() )
	
	self:SetLeftWidth( x )
	self:InvalidateLayout()

	
end

--[[---------------------------------------------------------
	Name: StartGrab
-----------------------------------------------------------]]
function PANEL:StartGrab()

	self:SetCursor( "sizewe" )
	
	local x, y = self.m_DragBar:CursorPos()
	self:SetHoldPos( x )
	
	self:SetDragging( true )
	self:MouseCapture( true )

end

--[[---------------------------------------------------------
	Name: OnMouseReleased
-----------------------------------------------------------]]
function PANEL:OnMouseReleased( mcode )

	if ( mcode == MOUSE_LEFT ) then
		self:SetCursor( "none" )
		self:SetDragging( false )
		self:MouseCapture( false )
		self:SetCookie( "LeftWidth", self.m_iLeftWidth )
	end

end

--[[---------------------------------------------------------
   Name: GenerateExample
-----------------------------------------------------------]]
function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local ctrl = vgui.Create( ClassName )

		ctrl:SetSize( 256, 256 )
		ctrl:SetLeft( vgui.Create( "DButton" ) )
		ctrl:SetRight( vgui.Create( "DButton" ) )
	
	PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )

end

derma.DefineControl( "DHorizontalDivider", "", PANEL, "DPanel" )