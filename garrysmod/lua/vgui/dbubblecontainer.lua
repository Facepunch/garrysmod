
local PANEL = {}

AccessorFunc( PANEL, "m_bgColor", "BackgroundColor" )

function PANEL:Init()

	self.matPoint = Material( "gui/point.png" )
	self:DockPadding( 0, 0, 0, 32 )
	self:SetBackgroundColor( Color( 190, 190, 190, 230 ) )

end

function PANEL:OpenForPos( x, y, w, h )

	local center = x

	x = x - w * 0.5
	if ( x < 10 ) then x = 10 end

	y = y - h - 64
	if ( y < 10 ) then y = 10 end

	self:SetPos( x, y )
	self:SetSize( w, h )

	self.Center = center - x

end

function PANEL:PerformLayout()
end

function PANEL:Paint( w, h )

	local top = h - 32
	draw.RoundedBox( 8, 0, 0, w, top, self.m_bgColor )

	local tipx = self.Center - 32
	if ( tipx < 8 ) then tipx = 8 end
	if ( tipx > w - 64 - 8 ) then tipx = w - 64 - 8 end

	surface.SetDrawColor( self.m_bgColor )
	surface.SetMaterial( self.matPoint )
	surface.DrawTexturedRect( self.Center - 32, top, 64, 32 )

end

derma.DefineControl( "DBubbleContainer", "", PANEL, "DPanel" )
