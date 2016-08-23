
local PANEL = {}

function PANEL:Init()

	self.TextArea = self:Add( "DTextEntry" )
	self.TextArea:Dock( RIGHT )
	self.TextArea:SetPaintBackground( false )
	self.TextArea:SetWide( 45 )
	self.TextArea:SetNumeric( true )
	self.TextArea.OnChange = function( textarea, val ) self:SetValue( self.TextArea:GetText() ) end

	self.Slider = self:Add( "DSlider", self )
	self.Slider:SetLockY( 0.5 )
	self.Slider.TranslateValues = function( slider, x, y ) return self:TranslateSliderValues( x, y ) end
	self.Slider:SetTrapInside( true )
	self.Slider:Dock( FILL )
	self.Slider:SetHeight( 16 )
	Derma_Hook( self.Slider, "Paint", "Paint", "NumSlider" )

	self.Label = vgui.Create ( "DLabel", self )
	self.Label:Dock( LEFT )
	self.Label:SetMouseInputEnabled( true )

	self.Scratch = self.Label:Add( "DNumberScratch" )
	self.Scratch:SetImageVisible( false )
	self.Scratch:Dock( FILL )
	self.Scratch.OnValueChanged = function() self:ValueChanged( self.Scratch:GetFloatValue() ) end

	self:SetTall( 32 )

	self:SetMin( 0 )
	self:SetMax( 1 )
	self:SetDecimals( 2 )
	self:SetText( "" )
	self:SetValue( 0.5 )

	--
	-- You really shouldn't be messing with the internals of these controls from outside..
	-- .. but if you are, this might stop your code from fucking us both.
	--
	self.Wang = self.Scratch

end

function PANEL:SetMinMax( min, max )
	self.Scratch:SetMin( tonumber( min ) )
	self.Scratch:SetMax( tonumber( max ) )
	self:UpdateNotches()
end

function PANEL:SetDark( b )
	self.Label:SetDark( b )
end

function PANEL:GetMin()
	return self.Scratch:GetMin()
end

function PANEL:GetMax()
	return self.Scratch:GetMax()
end

function PANEL:GetRange()
	return self:GetMax() - self:GetMin()
end

function PANEL:SetMin( min )

	if ( !min ) then min = 0 end

	self.Scratch:SetMin( tonumber( min ) )
	self:UpdateNotches()
end

function PANEL:SetMax( max )

	if ( !max ) then max = 0 end

	self.Scratch:SetMax( tonumber( max ) )
	self:UpdateNotches()
end

function PANEL:SetValue( val )

	val = math.Clamp( tonumber( val ) || 0, self:GetMin(), self:GetMax() )
	
	if ( self:GetValue() == val ) then return end

	self.Scratch:SetValue( val )

	self:ValueChanged( self:GetValue() )

end

function PANEL:GetValue()
	return self.Scratch:GetFloatValue()
end

function PANEL:SetDecimals( d )
	self.Scratch:SetDecimals( d )
	self:UpdateNotches()
end

function PANEL:GetDecimals()
	return self.Scratch:GetDecimals()
end

--
-- Are we currently changing the value?
--
function PANEL:IsEditing()

	return self.Scratch:IsEditing() || self.TextArea:IsEditing() || self.Slider:IsEditing()

end

function PANEL:PerformLayout()

	self.Label:SetWide( self:GetWide() / 2.4 )

end

function PANEL:SetConVar( cvar )
	self.Scratch:SetConVar( cvar )
	self.TextArea:SetConVar( cvar )
end

function PANEL:SetText( text )
	self.Label:SetText( text )
end

function PANEL:ValueChanged( val )

	val = math.Clamp( tonumber( val ) || 0, self:GetMin(), self:GetMax() )

	self.Slider:SetSlideX( self.Scratch:GetFraction( val ) )

	if ( self.TextArea != vgui.GetKeyboardFocus() ) then
		self.TextArea:SetValue( self.Scratch:GetTextValue() )
	end

	self:OnValueChanged( val )

end

function PANEL:OnValueChanged( val )

	-- For override

end

function PANEL:TranslateSliderValues( x, y )

	self:SetValue( self.Scratch:GetMin() + ( x * self.Scratch:GetRange() ) )

	return self.Scratch:GetFraction(), y

end

function PANEL:GetTextArea()

	return self.TextArea

end

function PANEL:UpdateNotches()

	local range = self:GetRange()
	self.Slider:SetNotches( nil )

	if ( range < self:GetWide() / 4 ) then
		return self.Slider:SetNotches( range )
	else
		self.Slider:SetNotches( self:GetWide() / 4 )
	end

end

function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local ctrl = vgui.Create( ClassName )
	ctrl:SetWide( 200 )
	ctrl:SetMin( 1 )
	ctrl:SetMax( 10 )
	ctrl:SetText( "Example Slider!" )
	ctrl:SetDecimals( 0 )

	PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )

end

derma.DefineControl( "DNumSlider", "Menu Option Line", table.Copy( PANEL ), "Panel" )

-- No example for this fella
PANEL.GenerateExample = nil

function PANEL:PostMessage( name, _, val )

	if ( name == "SetInteger" ) then
		if ( val == "1" ) then
			self:SetDecimals( 0 )
		else
			self:SetDecimals( 2 )
		end
	end

	if ( name == "SetLower" ) then
		self:SetMin( tonumber(val) )
	end

	if ( name == "SetHigher" ) then
		self:SetMax( tonumber(val) )
	end

	if ( name == "SetValue" ) then
		self:SetValue( tonumber( val ) )
	end

end

function PANEL:PerformLayout()

	self.Scratch:SetVisible( false )
	self.Label:SetVisible( false )

	self.Slider:StretchToParent( 0, 0, 0, 0 )
	self.Slider:SetSlideX( self.Scratch:GetFraction() )

end

function PANEL:SetActionFunction( func )

	self.OnValueChanged = function( self, val ) func( self, "SliderMoved", val, 0 ) end

end

-- Compat
derma.DefineControl( "Slider", "Backwards Compatibility", PANEL, "Panel" )
