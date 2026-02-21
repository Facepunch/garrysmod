
local PANEL = {}

AccessorFunc( PANEL, "m_Hue", "Hue" )
AccessorFunc( PANEL, "m_BaseRGB", "BaseRGB" )
AccessorFunc( PANEL, "m_OutRGB", "RGB" )
AccessorFunc( PANEL, "m_DefaultColor", "DefaultColor" )

function PANEL:Init()

	self:SetImage( "vgui/minixhair" )
	self.Knob:NoClipping( false )

	self.BGSaturation = vgui.Create( "DImage", self )
	self.BGSaturation:SetImage( "vgui/gradient-r" )

	self.BGValue = vgui.Create( "DImage", self )
	self.BGValue:SetImage( "vgui/gradient-d" )
	self.BGValue:SetImageColor( color_black )

	self:SetBaseRGB( Color( 255, 0, 0 ) )
	self:SetRGB( Color( 255, 0, 0 ) )
	self:SetColor( Color( 255, 0, 0 ) )

	self:SetLockX( nil )
	self:SetLockY( nil )
	self:SetDefaultColor( color_white )

end

function PANEL:PerformLayout( w, h )

	DSlider.PerformLayout( self, w, h )

	self.BGSaturation:StretchToParent( 0, 0, 0, 0 )
	self.BGSaturation:SetZPos( -9 )

	self.BGValue:StretchToParent( 0, 0, 0, 0 )
	self.BGValue:SetZPos( -8 )

end

function PANEL:ResetToDefaultValue()

	self:SetColor( self:GetDefaultColor() )
	self:OnUserChanged( self.m_OutRGB )

end


function PANEL:Paint()

	surface.SetDrawColor( self.m_BaseRGB.r, self.m_BaseRGB.g, self.m_BaseRGB.b, 255 )
	self:DrawFilledRect()

end

function PANEL:PaintOver()

	surface.SetDrawColor( 0, 0, 0, 250 )
	self:DrawOutlinedRect()

end

function PANEL:TranslateValues( x, y )

	self:UpdateColor( x, y )
	self:OnUserChanged( self.m_OutRGB )

	return x, y

end

function PANEL:UpdateColor( x, y )

	x = x or self:GetSlideX()
	y = y or self:GetSlideY()

	local value = 1 - y
	local saturation = 1 - x
	local h = ColorToHSV( self.m_BaseRGB )

	local color = HSVToColor( h, saturation, value )

	self:SetRGB( color )

end

function PANEL:OnUserChanged( color )

	-- Override me

end

function PANEL:SetColor( color )

	local h, s, v = ColorToHSV( color )

	self:SetBaseRGB( HSVToColor( h, 1, 1 ) )

	self:SetSlideY( 1 - v )
	self:SetSlideX( 1 - s )
	self:UpdateColor()

end

function PANEL:SetBaseRGB( color )

	self.m_BaseRGB = color
	self:UpdateColor()

end

derma.DefineControl( "DColorCube", "", PANEL, "DSlider" )
