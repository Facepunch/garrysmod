--[[
     _
    ( )
   _| |   __   _ __   ___ ___     _ _
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_)

	DColorCube
--]]

local PANEL = {}

AccessorFunc( PANEL, "m_Hue", "Hue" )
AccessorFunc( PANEL, "m_BaseRGB", "BaseRGB" )
AccessorFunc( PANEL, "m_OutRGB", "RGB" )

--[[---------------------------------------------------------
	Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

	self:SetImage( "vgui/minixhair" )
	self.Knob:NoClipping( false )
	
	self.BGSaturation = vgui.Create( "DImage", self )
	self.BGSaturation:SetImage( "vgui/gradient-r" )
	
	self.BGValue = vgui.Create( "DImage", self )
	self.BGValue:SetImage( "vgui/gradient-d" )
	self.BGValue:SetImageColor( Color( 0, 0, 0, 255 ) )
	
	self:SetBaseRGB( Color( 255, 0, 0 ) )
	self:SetRGB( Color( 255, 0, 0 ) )
	self:SetColor( Color( 255, 0, 0 ) )

	self:SetLockX( nil )
	self:SetLockY( nil )

end

--[[---------------------------------------------------------
	Name: PerformLayout
-----------------------------------------------------------]]
function PANEL:PerformLayout()

	DSlider.PerformLayout( self )
	
	self.BGSaturation:StretchToParent( 0,0,0,0 )
	self.BGSaturation:SetZPos( -9 )
	
	self.BGValue:StretchToParent( 0,0,0,0 )
	self.BGValue:SetZPos( -8 )

end

--[[---------------------------------------------------------
	Name: Paint
-----------------------------------------------------------]]
function PANEL:Paint()

	surface.SetDrawColor( self.m_BaseRGB.r, self.m_BaseRGB.g, self.m_BaseRGB.b, 255 )
	self:DrawFilledRect()

end

--[[---------------------------------------------------------
	Name: PaintOver
-----------------------------------------------------------]]
function PANEL:PaintOver()

	surface.SetDrawColor( 0, 0, 0, 250 )
	self:DrawOutlinedRect()

end

--[[---------------------------------------------------------
	Name: TranslateValues
-----------------------------------------------------------]]
function PANEL:TranslateValues( x, y )

	self:UpdateColor( x, y )
	self:OnUserChanged( self.m_OutRGB )
	
	return x, y

end

--[[---------------------------------------------------------
	Name: UpdateColor
-----------------------------------------------------------]]
function PANEL:UpdateColor( x, y )

	x = x or self:GetSlideX()
	y = y or self:GetSlideY()
	
	local value = 1 - y
	local saturation = 1 - x
	local h = ColorToHSV( self.m_BaseRGB )
	
	local color = HSVToColor( h, saturation, value )
	
	self:SetRGB( color )

end

--[[---------------------------------------------------------
	Name: OnUserChanged
-----------------------------------------------------------]]
function PANEL:OnUserChanged()

	-- Override me

end

--[[---------------------------------------------------------
	Name: SetColor
-----------------------------------------------------------]]
function PANEL:SetColor( color )

	local h, s, v = ColorToHSV( color )
	
	self:SetBaseRGB( HSVToColor( h, 1, 1 ) )
	
	self:SetSlideY( 1 - v )
	self:SetSlideX( 1 - s )
	self:UpdateColor()

end

--[[---------------------------------------------------------
	Name: SetBaseRGB
-----------------------------------------------------------]]
function PANEL:SetBaseRGB( color )

	self.m_BaseRGB = color
	self:UpdateColor()

end

derma.DefineControl( "DColorCube", "", PANEL, "DSlider" )