
local PANEL = {}

local color_00255 = Color( 0, 0, 255 ) 
local color_050255 = Color( 0, 50, 255 )

AccessorFunc( PANEL, "m_colText", "TextColor" )
AccessorFunc( PANEL, "m_colTextStyle", "TextStyleColor" )

AccessorFunc( PANEL, "m_bAutoStretchVertical", "AutoStretchVertical" )

function PANEL:Init()

	self:SetTextStyleColor( color_00255 )

	-- Nicer default height
	self:SetTall( 20 )

	-- This turns off the engine drawing
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )

end

function PANEL:ApplySchemeSettings()

	self:UpdateFGColor()

end

function PANEL:SetTextColor( clr )

	self.m_colText = clr
	self:UpdateFGColor()

end
PANEL.SetColor = PANEL.SetTextColor

function PANEL:GetColor()

	return self.m_colText or self.m_colTextStyle

end

function PANEL:OnCursorEntered()

	self:SetTextStyleColor( color_050255 )
	self:UpdateFGColor()

end

function PANEL:OnCursorExited()

	self:SetTextStyleColor( color_00255 )
	self:UpdateFGColor()

end

function PANEL:UpdateFGColor()

	local col = self:GetColor()
	self:SetFGColor( col.r, col.g, col.b, col.a )

end

derma.DefineControl( "DLabelURL", "A Label", PANEL, "URLLabel" )
