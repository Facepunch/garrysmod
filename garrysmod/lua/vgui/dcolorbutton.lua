
local PANEL = {}

local matGrid = Material( "gui/alpha_grid.png", "nocull" )

AccessorFunc( PANEL, "m_bBorder", "DrawBorder", FORCE_BOOL )
AccessorFunc( PANEL, "m_bSelected", "Selected", FORCE_BOOL )

AccessorFunc( PANEL, "m_Color", "Color" )
AccessorFunc( PANEL, "m_PanelID", "ID" )

function PANEL:Init()

	self:SetSize( 10, 10 )
	self:SetMouseInputEnabled( true )
	self:SetText( "" )
	self:SetCursor( "hand" )
	self:SetZPos( 0 )

	self:SetColor( Color( 255, 0, 255 ) )

end

function PANEL:IsDown()

	return self.Depressed

end

function PANEL:SetColor( color, hideTooltip )

	if ( !hideTooltip ) then

		local colorStr = "R: " .. color.r .. "\nG: " .. color.g .. "\nB: " .. color.b .. "\nA: " .. color.a
		self:SetTooltip( colorStr )

	end

	self.m_Color = color

end

function PANEL:Paint( w, h )

	if ( self:GetColor().a < 255 ) then -- Grid for Alpha

		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( matGrid )

		local size = math.max( 128, math.max( w, h ) )
		local x, y = w / 2 - size / 2, h / 2 - size / 2
		surface.DrawTexturedRect( x, y , size, size )

	end
	
	local panelColor = self:GetColor()
	
	surface.SetDrawColor( panelColor.r, panelColor.g, panelColor.b, panelColor.a )
	self:DrawFilledRect()

	surface.SetDrawColor( 0, 0, 0, 200 )
	surface.DrawRect( 0, 0, w, 1 )
	surface.DrawRect( 0, 0, 1, h )

	return false
end

function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local ctrl = vgui.Create( ClassName )
	ctrl:SetSize( 64, 64 )
	ctrl:SetColor( Color( 255, 0, 0, 128 ) )

	PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )

end

derma.DefineControl( "DColorButton", "A Color Button", PANEL, "DLabel" )
