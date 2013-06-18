--[[
	 _
	( )
   _| |   __   _ __   ___ ___     _ _
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_)

	DColorButton
--]]

local matGrid = Material( "gui/bg-lines.png", "nocull" )

local PANEL = {}

AccessorFunc( PANEL, "m_bBorder", "DrawBorder", FORCE_BOOL )
AccessorFunc( PANEL, "m_bDisabled", "Disabled", FORCE_BOOL )
AccessorFunc( PANEL, "m_bSelected", "Selected", FORCE_BOOL )

AccessorFunc( PANEL, "m_Color", "Color" )
AccessorFunc( PANEL, "m_PanelID", "ID" )

--[[---------------------------------------------------------
	Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

	self:SetSize( 10, 10 )
	self:SetMouseInputEnabled( true )
	self:SetText( "" )
	self:SetCursor( "hand" )
	self:SetZPos( 0 )

	self:SetColor( Color( 255, 0, 255 ) )
	self.PosX, self.PosY, self.SizeX, self.SizeY = self:GetBounds()

end

--[[---------------------------------------------------------
	Name: IsDown
-----------------------------------------------------------]]
function PANEL:IsDown()

	return self.Depressed

end

--[[---------------------------------------------------------
	Name: SetColor
-----------------------------------------------------------]]
function PANEL:SetColor( color )

	local colorStr = "R: "..color.r.."\nG: "..color.g.."\nB: "..color.b.."\nA: "..color.a

	self:SetToolTip( colorStr )
	self.m_Color = color

end

--[[---------------------------------------------------------
	Name: Paint
-----------------------------------------------------------]]
function PANEL:Paint( w, h )

	if ( self.m_Color.a < 255 ) then -- Grid for Alpha

		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( matGrid )

		local size = math.max( 128, math.max( w, h ) )
		local x, y = w / 2 - size / 2, h / 2 - size / 2 
		surface.DrawTexturedRect( x, y , size, size )

	end

	surface.SetDrawColor( self.m_Color )
	self:DrawFilledRect()

	surface.SetDrawColor( 0, 0, 0, 200 )
	surface.DrawRect( 0, 0, w, 1 )
	surface.DrawRect( 0, 0, 1, h )

	return false
end

--[[---------------------------------------------------------
	Name: SetDisabled
-----------------------------------------------------------]]
function PANEL:SetDisabled( bDisabled )

	self.m_bDisabled = bDisabled	
	self:InvalidateLayout()

end

--[[---------------------------------------------------------
	Name: GenerateExample
-----------------------------------------------------------]]
function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local ctrl = vgui.Create( ClassName )
		ctrl:SetSize( 64, 64 )

	PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )

end

derma.DefineControl( "DColorButton", "A Color Button", PANEL, "DLabel" )