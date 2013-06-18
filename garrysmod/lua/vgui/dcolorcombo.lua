--[[
	 _
	( )
   _| |   __   _ __   ___ ___     _ _
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_)

	DColorMixer
--]]


local PANEL = {}

AccessorFunc( PANEL, "m_Color", "Color" )

function PANEL:Init()

	self:SetSize( 256, 256 )
	self:BuildControls()
	self:SetColor( Color( 255, 255, 255, 255 ) )

end

function PANEL:BuildControls()

	--
	-- Mixer
	--
	local ctrl = self:Add( "DColorMixer" )
		ctrl:Dock( FILL )
		ctrl:DockMargin( 8, 8, 8, 8 )
		ctrl:SetPalette( false )
		ctrl:SetAlphaBar( false )
		ctrl:SetWangs( false )
		--ctrl:SetNumRows( 35 )
		--ctrl:Reset()
		ctrl.ValueChanged = function( ctrl, color ) self.m_bEditing = true self:OnValueChanged( color ) self.m_bEditing = false end
		self.Mixer = ctrl;
	self:AddSheet( "", ctrl, "icon16/color_wheel.png" )

	--
	-- Palettes
	--
	local ctrl = self:Add( "DColorPalette" )
		ctrl:Dock( FILL )
		ctrl:DockMargin( 8, 2, 8, 8 )
		ctrl:SetButtonSize( 16 )
		ctrl:SetNumRows( 35 )
		ctrl:Reset()
		ctrl.OnValueChanged = function( ctrl, color ) self.m_bEditing = true self:OnValueChanged( color ) self.m_bEditing = false end
		self.Palette = ctrl;
	self:AddSheet( "", ctrl, "icon16/palette.png" )

end

function PANEL:IsEditing()

	return self.m_bEditing

end

function PANEL:PerformLayout()

end


function PANEL:OnValueChanged( newcol )

end

function PANEL:SetColor( newcol )

	self.Mixer:SetColor( newcol )
	self.Palette:SetColor( newcol )

end

derma.DefineControl( "DColorCombo", "", PANEL, "DPropertySheet" )