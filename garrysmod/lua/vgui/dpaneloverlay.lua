
local InnerCorner8	= surface.GetTextureID( "gui/icorner8" )

local PANEL = {}

AccessorFunc( PANEL, "m_Color", "Color" )
AccessorFunc( PANEL, "m_Type", "Type" )

function PANEL:Init()

	self:SetColor( color_white )
	self:SetMouseInputEnabled( false )
	self:SetKeyboardInputEnabled( false )

	self:SetType( 1 )

end

function PANEL:PaintInnerCorners( size )

	local w, h = self:GetSize()

	surface.SetTexture( InnerCorner8 )
	surface.DrawTexturedRectRotated( size * 0.5, size * 0.5, size, size, 0 )
	surface.DrawTexturedRectRotated( w - size * 0.5, size * 0.5, size, size, -90 )
	surface.DrawTexturedRectRotated( w - size * 0.5, h - size * 0.5, size, size, 180 )
	surface.DrawTexturedRectRotated( size * 0.5, h - size * 0.5, size, size, 90 )

end

function PANEL:PaintDifferentColours( cola, colb, colc, cold, size )

	local w, h = self:GetSize()

	surface.SetTexture( InnerCorner8 )
	surface.SetDrawColor( cola )
	surface.DrawTexturedRectRotated( size * 0.5, size * 0.5, size, size, 0 )
	surface.SetDrawColor( colb )
	surface.DrawTexturedRectRotated( w - size * 0.5, size * 0.5, size, size, -90 )
	surface.SetDrawColor( colc )
	surface.DrawTexturedRectRotated( w - size * 0.5, h - size * 0.5, size, size, 180 )
	surface.SetDrawColor( cold )
	surface.DrawTexturedRectRotated( size * 0.5, h - size * 0.5, size, size, 90 )

end

function PANEL:Paint()

	self:SetPos( 0, 0 )
	self:SetSize( self:GetParent():GetSize() )

	surface.SetDrawColor( self.m_Color.r, self.m_Color.g, self.m_Color.b, self.m_Color.a )

	if ( self.m_Type == 1 ) then
		return self:PaintInnerCorners( 8 )
	end

	if ( self.m_Type == 2 ) then
		return self:PaintInnerCorners( 4 )
	end

	if ( self.m_Type == 3 ) then
		local c = Color( 40, 40, 40, 255 )
		return self:PaintDifferentColours( c, c, self.m_Color, self.m_Color, 8 )
	end

	return true

end

derma.DefineControl( "DPanelOverlay", "", PANEL, "DPanel" )
