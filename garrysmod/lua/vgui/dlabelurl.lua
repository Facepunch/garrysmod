--[[   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 
	DLabelURL
--]]

local PANEL = {}

AccessorFunc( PANEL, "m_colText", 				"TextColor" )
AccessorFunc( PANEL, "m_colTextStyle", 			"TextStyleColor" )
AccessorFunc( PANEL, "m_strLinkURL", 			"URL" )

AccessorFunc( PANEL, "m_bAutoStretchVertical", 	"AutoStretchVertical" )

--[[---------------------------------------------------------
	Init
-----------------------------------------------------------]]
function PANEL:Init()
	
	self:SetText("LabelURL")
	self:SetTextColor( Color( 0, 0, 255 ) )
	
	-- This turns off the engine drawing
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )
	
end

--[[---------------------------------------------------------
	Paint
-----------------------------------------------------------]]
function PANEL:Paint()

	-- Some trickery to hide the DButton
	surface.SetDrawColor(0,0,0,0)
	surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
	
end

--[[---------------------------------------------------------
	SetTextColor
-----------------------------------------------------------]]
function PANEL:ApplySchemeSettings( col )

	self:UpdateColours( self:GetSkin() );
	
	local col = self.m_colTextStyle
	if ( self.m_colText ) then col = self.m_colText end
	
	self:SetFGColor( col.r, col.g, col.b, col.a )

end

PANEL.SetColor = PANEL.SetTextColor

--[[---------------------------------------------------------
	SetColor
-----------------------------------------------------------]]
function PANEL:GetColor()

	return self.m_colText

end

--[[---------------------------------------------------------
	SetFont
-----------------------------------------------------------]]
function PANEL:SetFont( strFont )

	self.m_FontName = strFont
	self:SetFontInternal( self.m_FontName )	
	self:ApplySchemeSettings()
	
end

--[[---------------------------------------------------------
	DoClick
-----------------------------------------------------------]]
function PANEL:DoClick()
	
	-- Open the URL in the Steam overlay and set the color to 'visited'
	gui.OpenURL( self:GetURL() ) 
	self.m_colText = Color( 11, 0, 128 )

end

--[[---------------------------------------------------------
	Exited
-----------------------------------------------------------]]
function PANEL:OnCursorEntered()

	self:InvalidateLayout()
	
end

--[[---------------------------------------------------------
	Entered
-----------------------------------------------------------]]
function PANEL:OnCursorExited()

	self:InvalidateLayout()
	
end

--[[---------------------------------------------------------
	UpdateColours
-----------------------------------------------------------]]
function PANEL:UpdateColours( skin )

end


derma.DefineControl( "DLabelURL", "A URL Label", PANEL, "DButton" )
