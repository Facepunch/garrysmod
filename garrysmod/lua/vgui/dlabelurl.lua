--[[   _
    ( )
   _| |   __   _ __   ___ ___     _ _
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_)

	DLabelURL

--]]
PANEL = {}

AccessorFunc( PANEL, "m_colText", 				"TextColor" )
AccessorFunc( PANEL, "m_colTextStyle", 			"TextStyleColor" )

AccessorFunc( PANEL, "m_bAutoStretchVertical", 	"AutoStretchVertical" )

--[[---------------------------------------------------------
   Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

	self:SetTextColor( Color( 0, 0, 255 ) )

	-- Nicer default height
	self:SetTall( 20 )

	-- This turns off the engine drawing
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )

end

--[[---------------------------------------------------------
   Name: ApplySchemeSettings
-----------------------------------------------------------]]
function PANEL:ApplySchemeSettings( col )

	self:UpdateColours( self:GetSkin() );

	local col = self.m_colTextStyle
	if ( self.m_colText ) then col = self.m_colText end

	self:SetFGColor( col.r, col.g, col.b, col.a )

end

--[[---------------------------------------------------------
   Name: SetColor
   Desc: Compatibility
-----------------------------------------------------------]]
PANEL.SetColor = PANEL.SetTextColor

--[[---------------------------------------------------------
   Name: GetColor
-----------------------------------------------------------]]
function PANEL:GetColor()

	return self.m_colText

end

--[[---------------------------------------------------------
   Name: OnCursorEntered
-----------------------------------------------------------]]
function PANEL:OnCursorEntered()

	self:InvalidateLayout()
	self:SetTextColor( Color( 0, 50, 255 ) )

end

--[[---------------------------------------------------------
   Name: OnCursorExited
-----------------------------------------------------------]]
function PANEL:OnCursorExited()

	self:InvalidateLayout()
	self:SetTextColor( Color( 0, 50, 255 ) )

end

--[[---------------------------------------------------------
   Name: UpdateColours
-----------------------------------------------------------]]
function PANEL:UpdateColours( skin )

end


derma.DefineControl( "DLabelURL", "A Label", PANEL, "URLLabel" )
