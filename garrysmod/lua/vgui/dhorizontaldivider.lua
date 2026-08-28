
local PANEL = {}

function PANEL:Init()

	self:SetCursor( "sizewe" )
	self:SetPaintBackground( false )

end

function PANEL:OnMousePressed( mcode )

	if ( mcode == MOUSE_LEFT ) then
		self:GetParent():StartGrab()
	end

end

derma.DefineControl( "DHorizontalDividerBar", "", PANEL, "DPanel" )

local PANEL = {}

AccessorFunc( PANEL, "m_pLeft",				"Left" )
AccessorFunc( PANEL, "m_pRight",			"Right" )
AccessorFunc( PANEL, "m_pMiddle",			"Middle" )
AccessorFunc( PANEL, "m_iDividerWidth",		"DividerWidth" )
AccessorFunc( PANEL, "m_iLeftWidth",		"LeftWidth" )
AccessorFunc( PANEL, "m_bDragging",			"Dragging", FORCE_BOOL )

AccessorFunc( PANEL, "m_iLeftWidthMin",		"LeftMin" )
AccessorFunc( PANEL, "m_iRightWidthMin",	"RightMin" )

AccessorFunc( PANEL, "m_iHoldPos",			"HoldPos" )

function PANEL:Init()

	self:SetDividerWidth( 8 )
	self:SetLeftWidth( 100 )

	self:SetLeftMin( 50 )
	self:SetRightMin( 50 )

	self:SetPaintBackground( false )

	self.m_DragBar = vgui.Create( "DHorizontalDividerBar", self )

end


function PANEL:LoadCookies()

	if ( self:GetCookieNumber( "LeftWidthPct" ) ) then
		self._iLeftWidthPct = self:GetCookieNumber( "LeftWidthPct" )
		self:SetLeftWidth( math.floor( self._iLeftWidthPct * self:GetWide() ) )
		self._iLastWidth = self:GetWide()
		self._OldCookiePct = self:GetCookieNumber( "LeftWidthPct" )
	else
		-- Legacy stored value
		self:SetLeftWidth( self:GetCookieNumber( "LeftWidth", self:GetLeftWidth() ) )
	end

end

function PANEL:SetLeft( pnl )

	self.m_pLeft = pnl

	if ( IsValid( self.m_pLeft ) ) then
		self.m_pLeft:SetParent( self )
	end

end

function PANEL:SetMiddle( Middle )

	self.m_pMiddle = Middle

	if ( IsValid( self.m_pMiddle ) ) then
		self.m_pMiddle:SetParent( self.m_DragBar )
	end

end

function PANEL:SetRight( pnl )

	self.m_pRight = pnl

	if ( IsValid( self.m_pRight ) ) then
		self.m_pRight:SetParent( self )
	end

end

function PANEL:PerformLayout( w, h )

	-- On resize, use the percent to set the left width, so that it re-scales with the size of the panel
	if ( self._iLeftWidthPct && self._iLastWidth && self._iLastWidth != w ) then
		self:SetLeftWidth( math.floor( self._iLeftWidthPct * w ) )
	end

	self._iLastWidth = self:GetWide()

	-- Clamp the size to minimums
	self:SetLeftWidth( math.Clamp( self:GetLeftWidth(), self:GetLeftMin(), math.max( w - self:GetRightMin() - self:GetDividerWidth(), self:GetLeftMin() ) ), true )

	if ( IsValid( self.m_pLeft ) ) then

		self.m_pLeft:StretchToParent( 0, 0, nil, 0 )
		self.m_pLeft:SetWide( self:GetLeftWidth() )
		self.m_pLeft:InvalidateLayout()

	end

	self.m_DragBar:SetPos( self:GetLeftWidth(), 0 )
	self.m_DragBar:SetSize( self:GetDividerWidth(), self:GetTall() )
	self.m_DragBar:SetZPos( -1 )

	if ( IsValid( self.m_pRight ) ) then

		self.m_pRight:StretchToParent( self:GetLeftWidth() + self.m_DragBar:GetWide(), 0, 0, 0 )
		self.m_pRight:InvalidateLayout()

	end

	if ( IsValid( self.m_pMiddle ) ) then

		self.m_pMiddle:StretchToParent( 0, 0, 0, 0 )
		self.m_pMiddle:InvalidateLayout()

	end

end

function PANEL:OnCursorMoved( x, y )

	if ( !self:GetDragging() ) then return end

	local oldLeftWidth = self:GetLeftWidth()

	x = math.Clamp( x - self:GetHoldPos(), self:GetLeftMin(), self:GetWide() - self:GetRightMin() - self:GetDividerWidth() )

	self:SetLeftWidth( x )
	self._iLeftWidthPct = x / self:GetWide()
	if ( oldLeftWidth != x ) then self:InvalidateLayout() end

end

function PANEL:Think()

	-- If 2 or more panels use the same cookie name, make every panel resize automatically to the same size
	if ( self._OldCookiePct && self._OldCookiePct != self:GetCookieNumber( "LeftWidthPct", self._OldCookiePct ) && !self:GetDragging() ) then
		self:LoadCookies()
		self:InvalidateLayout()
	end

end

function PANEL:StartGrab()

	self:SetCursor( "sizewe" )

	local x, y = self.m_DragBar:CursorPos()
	self:SetHoldPos( x )

	self:SetDragging( true )
	self:MouseCapture( true )

end

function PANEL:OnMouseReleased( mcode )

	if ( mcode == MOUSE_LEFT ) then
		self:SetCursor( "none" )
		self:SetDragging( false )
		self:MouseCapture( false )

		-- Store left width as percentage, this helps when resizing panels, and with screen resolution changes
		self:SetCookie( "LeftWidthPct", self._iLeftWidthPct )
	end

end

function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local ctrl = vgui.Create( ClassName )
	ctrl:SetSize( 256, 256 )
	ctrl:SetLeft( vgui.Create( "DButton" ) )
	ctrl:SetRight( vgui.Create( "DButton" ) )

	PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )

end

derma.DefineControl( "DHorizontalDivider", "", PANEL, "DPanel" )
