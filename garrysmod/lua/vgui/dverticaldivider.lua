
local PANEL = {}

function PANEL:Init()

	self:SetCursor( "sizens" )
	self:SetPaintBackground( false )

end

function PANEL:OnMousePressed( mcode )

	if ( mcode == MOUSE_LEFT ) then
		self:GetParent():StartGrab()
	end

end

derma.DefineControl( "DVerticalDividerBar", "", PANEL, "DPanel" )

--[[---------------------------------------------------------
	DVerticalDivider
-----------------------------------------------------------]]

local PANEL = {}

AccessorFunc( PANEL, "m_pTop", "Top" )
AccessorFunc( PANEL, "m_pBottom", "Bottom" )
AccessorFunc( PANEL, "m_pMiddle", "Middle" )
AccessorFunc( PANEL, "m_iDividerHeight", "DividerHeight" )
AccessorFunc( PANEL, "m_iTopHeight", "TopHeight" )
AccessorFunc( PANEL, "m_bDragging", "Dragging" )

AccessorFunc( PANEL, "m_iTopHeightMin", "TopMin" )
AccessorFunc( PANEL, "m_iTopHeightMax", "TopMax" )
AccessorFunc( PANEL, "m_iBottomHeightMin", "BottomMin" )

AccessorFunc( PANEL, "m_iHoldPos", "HoldPos" )

function PANEL:Init()

	self:SetDividerHeight( 8 )
	self:SetTopHeight( 100 )

	self:SetTopMin( 50 )
	self:SetTopMax( 4096 )

	self:SetBottomMin( 50 )

	self:SetPaintBackground( false )

	self.m_DragBar = vgui.Create( "DVerticalDividerBar", self )

end

function PANEL:LoadCookies()

	self:SetTopHeight( self:GetCookieNumber( "TopHeight", self:GetTopHeight() ) )

end

function PANEL:SetTop( pnl )

	self.m_pTop = pnl
	self.m_pTop:SetParent( self )

end

function PANEL:SetBottom( pnl )

	self.m_pBottom = pnl
	self.m_pBottom:SetParent( self )

end

function PANEL:DoConstraints()

	if ( self:GetTall() == 0 ) then return end

	self.m_iTopHeight = math.Clamp( self.m_iTopHeight, self:GetTopMin(), self:GetTall() - self:GetBottomMin() - self:GetDividerHeight() )

end

function PANEL:PerformLayout()

	self:DoConstraints()

	if ( self.m_pTop ) then

		self.m_pTop:StretchToParent( 0, 0, 0, nil )
		self.m_pTop:SetTall( self.m_iTopHeight )
		self.m_pTop:InvalidateLayout()

	end

	if ( self.m_pBottom ) then

		self.m_pBottom:StretchToParent( 0, self.m_iTopHeight + self.m_iDividerHeight, 0, 0 )
		self.m_pBottom:InvalidateLayout()

	end

	self.m_DragBar:StretchToParent( 0, self.m_iTopHeight, 0, 0 )
	self.m_DragBar:SetTall( self.m_iDividerHeight )
	self.m_DragBar:SetZPos( -1 )

	if ( self.m_pMiddle ) then

		self.m_pMiddle:StretchToParent( 0, 0, 0, 0 )
		self.m_pMiddle:InvalidateLayout()

	end

end

function PANEL:SetMiddle( Middle )

	self.m_pMiddle = Middle

	if ( Middle ) then

		Middle:SetParent( self.m_DragBar )

	end

end

function PANEL:OnCursorMoved( x, y )

	if ( !self:GetDragging() ) then return end

	self.m_iTopHeight = y - self:GetHoldPos()

	self.m_iTopHeight = math.min( self.m_iTopHeight, self:GetTopMax() )

	self:InvalidateLayout( true )

end

function PANEL:StartGrab()

	self:SetCursor( "sizens" )

	local x, y = self.m_DragBar:CursorPos()
	self:SetHoldPos( y )

	self:SetDragging( true )
	self:MouseCapture( true )

end

function PANEL:OnMouseReleased( mcode )

	if ( mcode == MOUSE_LEFT ) then
		self:SetCursor( "none" )
		self:SetDragging( false )
		self:MouseCapture( false )
		self:SetCookie( "TopHeight", self.m_iTopHeight )
	end

end

function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local ctrl = vgui.Create( ClassName )
	ctrl:SetSize( 256, 256 )
	ctrl:SetTop( vgui.Create( "DButton" ) )
	ctrl:SetBottom( vgui.Create( "DButton" ) )

	PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )

end

derma.DefineControl( "DVerticalDivider", "", PANEL, "DPanel" )
