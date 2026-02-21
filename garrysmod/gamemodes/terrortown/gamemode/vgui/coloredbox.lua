-- Removed in GM13, still need it
local PANEL = {}
AccessorFunc( PANEL, "m_bBorder", "Border" )
AccessorFunc( PANEL, "m_Color", "Color" )

function PANEL:Init()
    self:SetBorder( true )
    self:SetColor( Color( 0, 255, 0, 255 ) )
end

function PANEL:Paint()
    surface.SetDrawColor( self.m_Color.r, self.m_Color.g, self.m_Color.b, 255 )
    self:DrawFilledRect()
end

function PANEL:PaintOver()
    if not self.m_bBorder then return end

    surface.SetDrawColor( 0, 0, 0, 255 )
    self:DrawOutlinedRect()
end
derma.DefineControl( "ColoredBox", "", PANEL, "DPanel" )
