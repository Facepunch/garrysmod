
DEFINE_BASECLASS( "DImageButton" )

local g_Active = nil

local PANEL = {}

AccessorFunc( PANEL, "m_numMin",		"Min" )
AccessorFunc( PANEL, "m_numMax",		"Max" )
AccessorFunc( PANEL, "m_Zoom",			"Zoom" )
AccessorFunc( PANEL, "m_fFloatValue",	"FloatValue" )
AccessorFunc( PANEL, "m_bActive",		"Active" )
AccessorFunc( PANEL, "m_iDecimals",		"Decimals" )
AccessorFunc( PANEL, "m_bDrawScreen",	"ShouldDrawScreen" )

Derma_Install_Convar_Functions( PANEL )

function PANEL:Init()

	self:SetMin( 0 )
	self:SetMax( 10 )
	self:SetZoom( 0 )
	self:SetDecimals( 2 )
	self:SetFloatValue( 1.5 )
	self:SetShouldDrawScreen( false )

	self.MouseX = 0
	self.MouseY = 0
	self.UnderMaterial = Material( "gui/numberscratch_under.png" )
	self.CoverMaterial = Material( "gui/numberscratch_cover.png" )

	self:SetImage( "icon16/scratchnumber.png" )
	self:SetStretchToFit( false )
	self:SetSize( 16, 16 )

	self:SetCursor( "sizewe" )

end

function PANEL:SetValue( val )

	local val = tonumber( val )
	if ( val == nil ) then return end
	if ( val == self:GetFloatValue() ) then return end

	self:SetFloatValue( val )
	self:OnValueChanged( val )
	self:UpdateConVar()

end

function PANEL:SetFraction( fFraction )

	self:SetFloatValue( self:GetMin() + ( fFraction * self:GetRange() ) )

end

function PANEL:GetFraction()

	return ( self:GetFloatValue() - self:GetMin() ) / self:GetRange()

end

function PANEL:GetDecimals()

	return self.m_iDecimals or 0

end

function PANEL:GetRange()
	return self:GetMax() - self:GetMin()
end

function PANEL:IdealZoom()

	return 400 / self:GetRange()

end

function PANEL:OnMousePressed( mousecode )

	if ( !self:IsEnabled() ) then return end

	if ( self:GetZoom() == 0 ) then self:SetZoom( self:IdealZoom() ) end

	self:SetActive( true )
	self:MouseCapture( true )

	self:LockCursor()

	-- Temporary fix for Linux
	-- Something keeps snapping the cursor to the center of the screen when it is invisible
	-- and we definitely don't want that, let's keep the cursor visible for now
	if ( !system.IsLinux() ) then
		self:SetCursor( "none" )
	end

	self:SetShouldDrawScreen( mousecode == MOUSE_LEFT )

	g_Active = self

end

function PANEL:OnMouseReleased( mousecode )

	g_Active = nil

	self:SetActive( false )
	self:MouseCapture( false )
	self:SetCursor( "sizewe" )

end

function PANEL:LockCursor()

	local x, y = self:LocalToScreen( math.floor( self:GetWide() * 0.5 ), math.floor( self:GetTall() * 0.5 ) )
	input.SetCursorPos( x, y )

end

function PANEL:OnCursorMoved( x, y )

	if ( !self:GetActive() ) then return end

	x = x - math.floor( self:GetWide() * 0.5 )
	y = y - math.floor( self:GetTall() * 0.5 )

	local zoom = self:GetZoom()

	local ControlScale = 100 / zoom

	local maxzoom = 10 ^ ( 1 + self:GetDecimals() )

	zoom = math.Clamp( zoom + ( ( y * -0.6 ) / ControlScale ), 0.01, maxzoom )
	if ( !input.IsKeyDown( KEY_LSHIFT ) ) then self:SetZoom( zoom ) end

	local oldValue = self:GetFloatValue()
	local value = self:GetFloatValue()
	value = math.Clamp( value + ( x * ControlScale * 0.002 ), self:GetMin(), self:GetMax() )
	self:SetFloatValue( value )

	self:LockCursor()

	if ( oldValue != value ) then self:OnValueChanged( value ) end
	self:UpdateConVar()

end

function PANEL:GetTextValue()

	local iDecimals = self:GetDecimals()
	if ( iDecimals == 0 ) then
		return Format( "%i", self:GetFloatValue() )
	end

	return Format( "%." .. iDecimals .. "f", self:GetFloatValue() )

end

function PANEL:UpdateConVar()

	self:ConVarChanged( self:GetTextValue() )

end

function PANEL:DrawNotches( level, x, y, w, h, range, value, min, max )

	local size = level * self:GetZoom()
	if ( size < 5 ) then return end
	if ( size > w * 2 ) then return end

	local alpha = 255

	if ( size < 150 ) then alpha = alpha * ( ( size - 2 ) / 140 ) end
	if ( size > ( w * 2 ) - 100 ) then alpha = alpha * ( 1 - ( ( size - ( w - 50 ) ) / 50 ) ) end

	local halfw = w * 0.5
	local span = math.ceil( w / size )
	local realmid = x + w * 0.5 - ( value * self:GetZoom() )
	local mid = x + w * 0.5 - math.fmod( value * self:GetZoom(), size )
	local top = h * 0.4
	local nh = h - top

	local frame_min = math.floor( realmid + min * self:GetZoom() )
	local frame_width = math.ceil( range * self:GetZoom() )
	local targetW = math.min( w - math.max( 0, frame_min - x ), frame_width - math.max( 0, x - frame_min ) )

	surface.SetDrawColor( 0, 0, 0, alpha )
	surface.DrawRect( math.max( x, frame_min ), y + top, targetW, 2 )

	surface.SetFont( "DermaDefault" )

	for n = -span, span, 1 do

		local nx = mid + n * size

		if ( nx > x + w or nx < x ) then continue end

		local dist = 1 - ( math.abs( halfw - nx + x ) / w )

		local val = ( nx - realmid ) / self:GetZoom()

		if ( val <= min + 0.001 ) then continue end
		if ( val >= max - 0.001 ) then continue end

		surface.SetDrawColor( 0, 0, 0, alpha * dist )
		surface.SetTextColor( 0, 0, 0, alpha * dist )

		surface.DrawRect( nx, y + top, 2, nh )

		local tw, th = surface.GetTextSize( val )

		surface.SetTextPos( nx - ( tw * 0.5 ), y + top - th )
		surface.DrawText( val )

	end

	surface.SetDrawColor( 0, 0, 0, alpha )
	surface.SetTextColor( 0, 0, 0, alpha )

	--
	-- Draw the last one.
	--
	local nx = realmid + max * self:GetZoom()
	if ( nx < x + w ) then
		surface.DrawRect( nx, y + top, 2, nh )

		local val = max
		local tw, th = surface.GetTextSize( val )

		surface.SetTextPos( nx - ( tw * 0.5 ), y + top - th )
		surface.DrawText( val )
	end

	--
	-- Draw the first
	--
	local nx = realmid + min * self:GetZoom()
	if ( nx > x ) then
		surface.DrawRect( nx, y + top, 2, nh )

		local val = min
		local tw, th = surface.GetTextSize( val )

		surface.SetTextPos( nx - ( tw * 0.5 ), y + top - th )
		surface.DrawText( val )
	end

end

function PANEL:Think()

	if ( !self:GetActive() ) then
		self:ConVarNumberThink()
	end

end

function PANEL:IsEditing()
	return self:GetActive()
end

function PANEL:DrawScreen( x, y, w, h )

	if ( !self:GetShouldDrawScreen() ) then return end

	local wasEnabled = DisableClipping( true )

	--
	-- Background
	--
	surface.SetMaterial( self.UnderMaterial )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( x, y, w, h )

	local min = self:GetMin()
	local max = self:GetMax()
	local range = self:GetMax() - self:GetMin()
	local value = self:GetFloatValue()

	--
	-- Background colour block
	--
	surface.SetDrawColor( 255, 250, 180, 100 )
	local targetX = x + w * 0.5 - ( ( value - min ) * self:GetZoom() )
	local targetW = range * self:GetZoom()
	targetW = targetW - math.max( 0, x - targetX )
	targetW = math.min( targetW, w - math.max( 0, targetX - x ) )
	surface.DrawRect( math.max( targetX, x ) + 3, y + h * 0.4, targetW - 6, h * 0.6 )

	for i = 1, 4 do
		self:DrawNotches( 10 ^ i, x, y, w, h, range, value, min, max )
	end

	for i = 0, self:GetDecimals() do
		self:DrawNotches( 1 / 10 ^ i, x, y, w, h, range, value, min, max )
	end

	--
	-- Cover
	--
	surface.SetMaterial( self.CoverMaterial )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( x, y, w, h )

	--
	-- Text Value
	--
	surface.SetFont( "DermaLarge" )
	local str = self:GetTextValue()
	str = string.Comma( str )
	local tw, th = surface.GetTextSize( str )

	draw.RoundedBoxEx( 8, x + w * 0.5 - tw / 2 - 10, y + h - 43, tw + 20, 39, Color( 0, 186, 255, 255 ), true, true, false, false )

	surface.SetTextColor( 255, 255, 255, 255 )
	surface.SetTextPos( x + w * 0.5 - tw * 0.5, y + h - th - 6 )
	surface.DrawText( str )

	DisableClipping( wasEnabled )

end

function PANEL:PaintScratchWindow()

	if ( !self:GetActive() ) then return end

	if ( self:GetZoom() == 0 ) then self:SetZoom( self:IdealZoom() ) end

	local w, h = 512, 256
	local x, y = self:LocalToScreen( 0, 0 )

	x = x + self:GetWide() * 0.5 - w * 0.5
	y = y - 8 - h

	if ( x + w + 32 > ScrW() ) then x = ScrW() - w - 32 end
	if ( y + h + 32 > ScrH() ) then y = ScrH() - h - 32 end
	if ( x < 32 ) then x = 32 end
	if ( y < 32 ) then y = 32 end

	if ( render ) then render.SetScissorRect( x, y, x + w, y + h, true ) end
		self:DrawScreen( x, y, w, h )
	if ( render ) then render.SetScissorRect( x, y, w, h, false ) end

end

--
-- For your pleasure.
--
function PANEL:OnValueChanged( value )
end

PANEL.AllowAutoRefresh = true

function PANEL:GenerateExample()

	-- The concommand derma_controls currently runs in the menu realm
	-- DNumberScratch uses the render library which is currently unavailable in this realm
	-- Therefor we cannot generate an example without spitting errors

end

derma.DefineControl( "DNumberScratch", "", PANEL, "DImageButton" )

hook.Add( "DrawOverlay", "DrawNumberScratch", function()

	if ( !IsValid( g_Active ) ) then return end

	g_Active:PaintScratchWindow()

end )
