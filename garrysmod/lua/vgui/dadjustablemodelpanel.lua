
local PANEL = {}

AccessorFunc( PANEL, "m_bFirstPerson", "FirstPerson" )

function PANEL:Init()

	self.mx = 0
	self.my = 0
	self.aLookAngle = Angle( 0, 0, 0 )

end

function PANEL:OnMousePressed( mousecode )

	self:MouseCapture( true )
	self.Capturing = true
	self.MouseKey = mousecode

	self:SetFirstPerson( true )

	self:CaptureMouse()

end

function PANEL:Think()

	if ( !self.Capturing ) then return end

	if ( self.m_bFirstPerson ) then
		return self:FirstPersonControls()
	end

end

function PANEL:CaptureMouse()

	local x, y = input.GetCursorPos()

	local dx = x - self.mx
	local dy = y - self.my

	local centerx, centery = self:LocalToScreen( self:GetWide() * 0.5, self:GetTall() * 0.5 )
	input.SetCursorPos( centerx, centery )
	self.mx = centerx
	self.my = centery

	return dx, dy

end

function PANEL:FirstPersonControls()

	local x, y = self:CaptureMouse()

	local scale = self:GetFOV() / 180
	x = x * -0.5 * scale
	y = y * 0.5 * scale

	if ( self.MouseKey == MOUSE_LEFT ) then
	
		if ( input.IsShiftDown() ) then y = 0 end
		
		self.aLookAngle = self.aLookAngle + Angle( y * 4, x * 4, 0 )
		
		self.vCamPos = self.Entity:OBBCenter() - self.aLookAngle:Forward() * self.vCamPos:Length()
		
		return
	end

	-- Look around
	self.aLookAngle = self.aLookAngle + Angle( y, x, 0 )

	local Movement = Vector( 0, 0, 0 )

	-- TODO: Use actual key bindings, not hardcoded keys.
	if ( input.IsKeyDown( KEY_W ) || input.IsKeyDown( KEY_UP ) ) then Movement = Movement + self.aLookAngle:Forward() end
	if ( input.IsKeyDown( KEY_S ) || input.IsKeyDown( KEY_DOWN ) ) then Movement = Movement - self.aLookAngle:Forward() end
	if ( input.IsKeyDown( KEY_A ) || input.IsKeyDown( KEY_LEFT ) ) then Movement = Movement - self.aLookAngle:Right() end
	if ( input.IsKeyDown( KEY_D ) || input.IsKeyDown( KEY_RIGHT ) ) then Movement = Movement + self.aLookAngle:Right() end
	if ( input.IsKeyDown( KEY_SPACE ) || input.IsKeyDown( KEY_SPACE ) ) then Movement = Movement + self.aLookAngle:Up() end
	if ( input.IsKeyDown( KEY_LCONTROL ) || input.IsKeyDown( KEY_LCONTROL ) ) then Movement = Movement - self.aLookAngle:Up() end

	local scale = 0.5
	if ( input.IsShiftDown() ) then scale = 4.0 end

	self.vCamPos = self.vCamPos + Movement * scale

end

function PANEL:OnMouseWheeled( dlta )

	local scale = self:GetFOV() / 180
	self.fFOV = self.fFOV + dlta * -10.0 * scale

end

function PANEL:OnMouseReleased( mousecode )

	self:MouseCapture( false )
	self.Capturing = false

end

derma.DefineControl( "DAdjustableModelPanel", "A panel containing a model", PANEL, "DModelPanel" )
