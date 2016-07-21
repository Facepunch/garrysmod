
local PANEL = {}

local matGradient	= Material( "vgui/gradient-u" )
local matGrid		= Material( "gui/alpha_grid.png", "nocull" )

AccessorFunc( PANEL, "m_Value", "Value" )
AccessorFunc( PANEL, "m_BarColor", "BarColor" )

function PANEL:Init()

	self:SetBarColor( Color( 255, 255, 255, 255 ) )
	self:SetSize( 26, 26 )
	self:SetValue( 1 )

end

function PANEL:OnCursorMoved( x, y )

	if ( !input.IsMouseDown( MOUSE_LEFT ) ) then return end

	local fHeight = y / self:GetTall()

	fHeight = 1 - math.Clamp( fHeight, 0, 1 )

	self:SetValue( fHeight )
	self:OnChange( fHeight )

end

function PANEL:OnMousePressed( mcode )

	self:MouseCapture( true )
	self:OnCursorMoved( self:CursorPos() )

end

function PANEL:OnMouseReleased( mcode )

	self:MouseCapture( false )
	self:OnCursorMoved( self:CursorPos() )

end

function PANEL:OnChange( fAlpha )
end

function PANEL:Paint( w, h )

	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( matGrid )
	local size = 128
	local x, y = w / 2 - size / 2, h / 2 - size / 2
	surface.DrawTexturedRect( x, y , size, size )
	surface.DrawTexturedRect( x, y - size, size, size )
	surface.DrawTexturedRect( x, y + size, size, size )

	surface.SetDrawColor( self.m_BarColor )
	surface.SetMaterial( matGradient )
	surface.DrawTexturedRect( 0, 0, w, h )
	surface.DrawTexturedRect( 0, 0, w, h )

	surface.SetDrawColor( 0, 0, 0, 250 )
	self:DrawOutlinedRect()
	surface.DrawRect( 0, ( 1-self.m_Value ) * h - 2, w, 3 )

	surface.SetDrawColor( 255, 255, 255, 250 )
	surface.DrawRect( 0, ( 1-self.m_Value ) * h - 1, w, 1 )

end

derma.DefineControl( "DAlphaBar", "", PANEL, "DPanel" )
