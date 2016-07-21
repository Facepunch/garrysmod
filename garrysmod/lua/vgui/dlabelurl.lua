
local PANEL = {}

AccessorFunc( PANEL, "m_colText", "TextColor" )
AccessorFunc( PANEL, "m_colTextStyle", "TextStyleColor" )

AccessorFunc( PANEL, "m_bAutoStretchVertical", "AutoStretchVertical" )

function PANEL:Init()

	self:SetTextColor( Color( 0, 0, 255 ) )

	-- Nicer default height
	self:SetTall( 20 )

	-- This turns off the engine drawing
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )

end

function PANEL:ApplySchemeSettings()

	self:UpdateColours( self:GetSkin() )

	local col = self.m_colTextStyle
	if ( self.m_colText ) then col = self.m_colText end

	self:SetFGColor( col.r, col.g, col.b, col.a )

end

PANEL.SetColor = PANEL.SetTextColor

function PANEL:GetColor()

	return self.m_colText

end

function PANEL:OnCursorEntered()

	self:InvalidateLayout()
	self:SetTextColor( Color( 0, 50, 255 ) )

end

function PANEL:OnCursorExited()

	self:InvalidateLayout()
	self:SetTextColor( Color( 0, 50, 255 ) )

end

function PANEL:UpdateColours( skin )
end

derma.DefineControl( "DLabelURL", "A Label", PANEL, "URLLabel" )
