
local PANEL = {}

AccessorFunc( PANEL, "m_fSlideX", "SlideX" )
AccessorFunc( PANEL, "m_fSlideY", "SlideY" )

AccessorFunc( PANEL, "m_iLockX", "LockX" )
AccessorFunc( PANEL, "m_iLockY", "LockY" )

AccessorFunc( PANEL, "Dragging", "Dragging" )
AccessorFunc( PANEL, "m_bTrappedInside", "TrapInside" )

Derma_Hook( PANEL, "Paint", "Paint", "Slider" )

function PANEL:Init()

	self:SetMouseInputEnabled( true )

	self:SetSlideX( 0.5 )
	self:SetSlideY( 0.5 )

	self.Knob = vgui.Create( "DButton", self )
	self.Knob:SetText( "" )
	self.Knob:SetSize( 15, 15 )
	self.Knob:NoClipping( true )
	self.Knob.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "SliderKnob", panel, w, h ) end
	self.Knob.OnCursorMoved = function( panel, x, y )
		x, y = panel:LocalToScreen( x, y )
		x, y = self:ScreenToLocal( x, y )
		self:OnCursorMoved( x, y )
	end

	self.Knob.OnMousePressed = function( panel, mcode )
		if ( mcode == MOUSE_MIDDLE ) then
			self:ResetToDefaultValue()
			return
		end

		DButton.OnMousePressed( panel, mcode )
	end

	-- Why is this set by default?
	self:SetLockY( 0.5 )

end

--
-- We we currently editing?
--
function PANEL:IsEditing()

	return self.Dragging || self.Knob.Depressed

end

function PANEL:ResetToDefaultValue()

	-- Override me
	local x, y = self:TranslateValues( 0.5, 0.5 )
	self:SetSlideX( x )
	self:SetSlideY( y )

end

function PANEL:SetBackground( img )

	if ( !self.BGImage ) then
		self.BGImage = vgui.Create( "DImage", self )
	end

	self.BGImage:SetImage( img )
	self:InvalidateLayout()

end

function PANEL:SetEnabled( b )
	self.Knob:SetEnabled( b )
	FindMetaTable( "Panel" ).SetEnabled( self, b ) -- There has to be a better way!
end

function PANEL:OnCursorMoved( x, y )

	if ( !self.Dragging && !self.Knob.Depressed ) then return end

	local w, h = self:GetSize()
	local iw, ih = self.Knob:GetSize()

	if ( self.m_bTrappedInside ) then

		w = w - iw
		h = h - ih

		x = x - iw * 0.5
		y = y - ih * 0.5

	end

	x = math.Clamp( x, 0, w ) / w
	y = math.Clamp( y, 0, h ) / h

	if ( self.m_iLockX ) then x = self.m_iLockX end
	if ( self.m_iLockY ) then y = self.m_iLockY end

	x, y = self:TranslateValues( x, y )

	self:SetSlideX( x )
	self:SetSlideY( y )

	self:InvalidateLayout()

end

function PANEL:OnMousePressed( mcode )

	if ( !self:IsEnabled() ) then return true end

	-- When starting dragging with not pressing on the knob.
	self.Knob.Hovered = true

	self:SetDragging( true )
	self:MouseCapture( true )

	local x, y = self:CursorPos()
	self:OnCursorMoved( x, y )

end

function PANEL:OnMouseReleased( mcode )

	-- This is a hack. Panel.Hovered is not updated when dragging a panel (Source's dragging, not Lua Drag'n'drop)
	self.Knob.Hovered = vgui.GetHoveredPanel() == self.Knob

	self:SetDragging( false )
	self:MouseCapture( false )

end

function PANEL:PerformLayout()

	local w, h = self:GetSize()
	local iw, ih = self.Knob:GetSize()

	if ( self.m_bTrappedInside ) then

		w = w - iw
		h = h - ih
		self.Knob:SetPos( ( self.m_fSlideX || 0 ) * w, ( self.m_fSlideY || 0 ) * h )

	else

		self.Knob:SetPos( ( self.m_fSlideX || 0 ) * w - iw * 0.5, ( self.m_fSlideY || 0 ) * h - ih * 0.5 )

	end

	if ( self.BGImage ) then
		self.BGImage:StretchToParent( 0, 0, 0, 0 )
		self.BGImage:SetZPos( -10 )
	end

	-- In case m_fSlideX/m_fSlideY changed multiple times a frame, we do this here
	self:ConVarChanged( self.m_fSlideX, self.m_strConVarX )
	self:ConVarChanged( self.m_fSlideY, self.m_strConVarY )

end

function PANEL:Think()

	self:ConVarXNumberThink()
	self:ConVarYNumberThink()

end

function PANEL:SetSlideX( i )
	self.m_fSlideX = i
	self:OnValuesChangedInternal()
end

function PANEL:SetSlideY( i )
	self.m_fSlideY = i
	self:OnValuesChangedInternal()
end

function PANEL:GetDragging()
	return self.Dragging || self.Knob.Depressed
end

function PANEL:OnValueChanged( x, y )

	-- For override

end

function PANEL:OnValuesChangedInternal()

	self:OnValueChanged( self.m_fSlideX, self.m_fSlideY )
	self:InvalidateLayout()

end

function PANEL:TranslateValues( x, y )

	-- Give children the chance to manipulate the values..
	return x, y

end

-- ConVars
function PANEL:SetConVarX( strConVar )
	self.m_strConVarX = strConVar
end
function PANEL:SetConVarY( strConVar )
	self.m_strConVarY = strConVar
end
function PANEL:ConVarChanged( newValue, cvar )

	if ( !cvar || cvar:len() < 2 ) then return end

	GetConVar( cvar ):SetFloat( newValue )

	-- Prevent extra convar loops
	if ( cvar == self.m_strConVarX ) then self.m_strConVarXValue = GetConVarNumber( self.m_strConVarX ) end
	if ( cvar == self.m_strConVarY ) then self.m_strConVarYValue = GetConVarNumber( self.m_strConVarY ) end

end
function PANEL:ConVarXNumberThink()

	if ( !self.m_strConVarX || #self.m_strConVarX < 2 ) then return end

	local numValue = GetConVarNumber( self.m_strConVarX )

	-- In case the convar is a "nan"
	if ( numValue != numValue ) then return end
	if ( self.m_strConVarXValue == numValue ) then return end

	self.m_strConVarXValue = numValue
	self:SetSlideX( self.m_strConVarXValue )

end
function PANEL:ConVarYNumberThink()

	if ( !self.m_strConVarY || #self.m_strConVarY < 2 ) then return end

	local numValue = GetConVarNumber( self.m_strConVarY )

	-- In case the convar is a "nan"
	if ( numValue != numValue ) then return end
	if ( self.m_strConVarYValue == numValue ) then return end

	self.m_strConVarYValue = numValue
	self:SetSlideY( self.m_strConVarYValue )

end

-- Deprecated
AccessorFunc( PANEL, "NumSlider", "NumSlider" )
AccessorFunc( PANEL, "m_iNotches", "Notches" )

function PANEL:SetImage( strImage )
	-- RETIRED
end

function PANEL:SetImageColor( color )
	-- RETIRED
end

function PANEL:SetNotchColor( color )

	self.m_cNotchClr = color

end

function PANEL:GetNotchColor()

	return self.m_cNotchClr || self:GetSkin().colNumSliderNotch

end

derma.DefineControl( "DSlider", "", PANEL, "Panel" )
