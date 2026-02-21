
local PANEL = {}

AccessorFunc( PANEL, "m_numMin",		"Min" )
AccessorFunc( PANEL, "m_numMax",		"Max" )
AccessorFunc( PANEL, "m_iDecimals",		"Decimals" ) -- The number of decimal places in the output
AccessorFunc( PANEL, "m_fFloatValue",	"FloatValue" )
AccessorFunc( PANEL, "m_iInterval",		"Interval" )

-- AnchorValue and UnAnchorValue functions are internally used for "drag-changing" the value
local function AnchorValue( wang, button, mcode )

	button:OldOnMousePressed( mcode )
	wang.mouseAnchor = gui.MouseY()
	wang.valAnchor = wang:GetValue()

end

local function UnAnchorValue( wang, button, mcode )

	button:OldOnMouseReleased( mcode )
	wang.mouseAnchor = nil
	wang.valAnchor = nil

end

function PANEL:Init()

	self:SetDecimals( 2 )
	self:SetTall( 20 )
	self:SetMinMax( 0, 100 )

	self:SetInterval( 1 )

	self:SetUpdateOnType( true )
	self:SetNumeric( true )

	self.OnChange = function() self:OnValueChanged( self:GetValue() ) end

	self.Up = vgui.Create( "DButton", self )
	self.Up:SetText( "" )
	self.Up.DoClick = function( button, mcode ) self:SetValue( self:GetValue() + self:GetInterval() ) end
	self.Up.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "NumberUp", panel, w, h ) end

	self.Up.OldOnMousePressed = self.Up.OnMousePressed
	self.Up.OldOnMouseReleased = self.Up.OnMouseReleased
	self.Up.OnMousePressed = function( button, mcode ) AnchorValue( self, button, mcode ) end
	self.Up.OnMouseReleased = function( button, mcode ) UnAnchorValue( self, button, mcode ) end
	self.Up.OnMouseWheeled = function( button, delta ) self:SetValue( self:GetValue() + delta ) end

	self.Down = vgui.Create( "DButton", self )
	self.Down:SetText( "" )
	self.Down.DoClick = function( button, mcode ) self:SetValue( self:GetValue() - self:GetInterval() ) end
	self.Down.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "NumberDown", panel, w, h ) end

	self.Down.OldOnMousePressed = self.Down.OnMousePressed
	self.Down.OldOnMouseReleased = self.Down.OnMouseReleased
	self.Down.OnMousePressed = function( button, mcode ) AnchorValue( self, button, mcode ) end
	self.Down.OnMouseReleased = function( button, mcode ) UnAnchorValue( self, button, mcode ) end
	self.Down.OnMouseWheeled = function( button, delta ) self:SetValue( self:GetValue() + delta ) end

	self:SetValue( 0 )

end

function PANEL:HideWang()

	self.Up:Hide()
	self.Down:Hide()

end

function PANEL:Think()

	if ( self.mouseAnchor ) then
		self:SetValue( self.valAnchor + self.mouseAnchor - gui.MouseY() )
	end

end

function PANEL:SetDecimals( num )

	self.m_iDecimals = num
	self:SetValue( self:GetValue() )

end

function PANEL:SetMinMax( min, max )

	self:SetMin( min )
	self:SetMax( max )

end

function PANEL:SetMin( min )

	self.m_numMin = tonumber( min )

end

function PANEL:SetMax( max )

	self.m_numMax = tonumber( max )

end

function PANEL:GetFloatValue( max )

	if ( !self.m_fFloatValue ) then self.m_fFloatValue = 0 end

	return tonumber( self.m_fFloatValue ) or 0

end

function PANEL:SetValue( val )

	if ( val == nil ) then return end

	val = tonumber( val )
	val = val or 0

	if ( self.m_numMax != nil ) then
		val = math.min( self.m_numMax, val )
	end

	if ( self.m_numMin != nil ) then
		val = math.max( self.m_numMin, val )
	end

	local valText
	if ( self.m_iDecimals == 0 ) then

		valText = Format( "%i", val )

	elseif ( val != 0 ) then

		valText = Format( "%." .. self.m_iDecimals .. "f", val )

		-- Trim trailing 0's and .'s 0 this gets rid of .00 etc
		valText = string.TrimRight( valText, "0" )
		valText = string.TrimRight( valText, "." )

	else

		valText = tostring( val )

	end

	local hasChanged = tonumber( val ) != tonumber( self:GetValue() )

	--
	-- Don't change the value while we're typing into it!
	-- It causes confusion!
	--
	if ( !self:HasFocus() ) then
		self:SetText( valText )
		self:ConVarChanged( valText )
	end

	if ( hasChanged ) then
		self:OnValueChanged( val )
	end

end

local meta = FindMetaTable( "Panel" )

function PANEL:GetValue()

	return tonumber( meta.GetValue( self ) ) or 0

end

function PANEL:PerformLayout()

	local s = math.floor( self:GetTall() * 0.5 )

	self.Up:SetSize( s, s - 1 )
	self.Up:AlignRight( 3 )
	self.Up:AlignTop( 0 )

	self.Down:SetSize( s, s - 1 )
	self.Down:AlignRight( 3 )
	self.Down:AlignBottom( 2 )

end

function PANEL:SizeToContents()

	-- Size based on the max number and max amount of decimals

	local chars = 0

	local min = math.Round( self:GetMin(), self:GetDecimals() )
	local max = math.Round( self:GetMax(), self:GetDecimals() )

	local minchars = string.len( "" .. min .. "" )
	local maxchars = string.len( "" .. max .. "" )

	chars = chars + math.max( minchars, maxchars )

	if ( self:GetDecimals() && self:GetDecimals() > 0 ) then

		chars = chars + 1
		chars = chars + self:GetDecimals()

	end

	self:InvalidateLayout( true )
	self:SetWide( chars * 6 + 10 + 5 + 5 )
	self:InvalidateLayout()

end

function PANEL:GetFraction( val )

	local Value = val or self:GetValue()

	local Fraction = ( Value - self.m_numMin ) / ( self.m_numMax - self.m_numMin )
	return Fraction

end

function PANEL:SetFraction( val )

	local Fraction = self.m_numMin + ( ( self.m_numMax - self.m_numMin ) * val )
	self:SetValue( Fraction )

end

function PANEL:OnValueChanged( val )

end

function PANEL:GetTextArea()

	return self

end

function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local ctrl = vgui.Create( ClassName )
	ctrl:SetDecimals( 0 )
	ctrl:SetMinMax( 0, 255 )
	ctrl:SetValue( 3 )

	PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )

end

derma.DefineControl( "DNumberWang", "Menu Option Line", PANEL, "DTextEntry" )
