
local PANEL = {}

AccessorFunc( PANEL, "m_Color", "Color" )

function PANEL:Init()

	self:SetSize( 256, 256 )
	self:BuildControls()
	self:SetColor( color_white )

end

function PANEL:BuildControls()

	--
	-- Mixer
	--
	local ctrl = self:Add( "DColorMixer" )
	ctrl:Dock( FILL )
	ctrl:DockMargin( 8, 0, 8, 8 )
	ctrl:SetPalette( false )
	ctrl:SetAlphaBar( false )
	ctrl:SetWangs( false )
	ctrl.ValueChanged = function( ctrl, color )
		self.m_bEditing = true
		self:OnValueChanged( color )
		self.m_Color = color
		self.m_bEditing = false
	end

	self.Mixer = ctrl
	self:AddSheet( "", ctrl, "icon16/color_wheel.png" )

	--
	-- Palettes
	--
	local ctrl = self:Add( "DColorPalette" )
	ctrl:Dock( FILL )
	ctrl:DockMargin( 8, 0, 8, 8 )
	ctrl:SetButtonSize( 16 )
	ctrl:SetNumRows( 35 )
	ctrl:Reset()
	ctrl.OnValueChanged = function( ctrl, color )
		self.m_bEditing = true
		self.Mixer:SetColor( color )
		self:OnValueChanged( color )
		self.m_Color = color
		self.m_bEditing = false
	end

	self.Palette = ctrl
	self:AddSheet( "", ctrl, "icon16/palette.png" )

end

function PANEL:IsEditing()

	return self.m_bEditing

end

function PANEL:OnValueChanged( newcol )

	-- For override

end

function PANEL:SetColor( newcol )

	self.m_Color = newcol
	self.Mixer:SetColor( newcol )
	self.Palette:SetColor( newcol )

end

derma.DefineControl( "DColorCombo", "", PANEL, "DPropertySheet" )
