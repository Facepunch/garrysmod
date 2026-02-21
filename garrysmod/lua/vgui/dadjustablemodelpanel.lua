
local PANEL = {}

AccessorFunc( PANEL, "m_bFirstPerson", "FirstPerson" )
AccessorFunc( PANEL, "m_iMoveScale", "MovementScale" )

function PANEL:Init()

	self.mx = 0
	self.my = 0
	self.aLookAngle = angle_zero
	self:SetMovementScale( 1 )

end

function PANEL:OnMousePressed( mousecode )

	-- input.SetCursorPos does not work while main menu is open
	if ( !MENU_DLL and gui.IsGameUIVisible() ) then return end

	if ( mousecode != MOUSE_LEFT and mousecode != MOUSE_RIGHT ) then return end

	self:SetCursor( "none" )
	self:MouseCapture( true )
	self.Capturing = true
	self.MouseKey = mousecode

	self:SetFirstPerson( true )

	self:CaptureMouse()

	if ( !IsValid( self.Entity ) ) then
		self.OrbitPoint = vector_origin
		self.OrbitDistance = ( self.OrbitPoint - self.vCamPos ):Length()
		return
	end

	-- Helpers for the orbit movement
	local mins, maxs = self.Entity:GetModelBounds()
	local center = ( mins + maxs ) / 2

	local hit1 = util.IntersectRayWithPlane( self.vCamPos, self.aLookAngle:Forward(), vector_origin, Vector( 0, 0, 1 ) )
	self.OrbitPoint = hit1

	local hit2 = util.IntersectRayWithPlane( self.vCamPos, self.aLookAngle:Forward(), vector_origin, Vector( 0, 1, 0 ) )
	if ( ( !hit1 and hit2 ) or hit2 and hit2:Distance( self.Entity:GetPos() ) < hit1:Distance( self.Entity:GetPos() ) ) then self.OrbitPoint = hit2 end

	local hit3 = util.IntersectRayWithPlane( self.vCamPos, self.aLookAngle:Forward(), vector_origin, Vector( 1, 0, 0 ) )
	if ( ( ( !hit1 or !hit2 ) and hit3 ) or hit3 and hit3:Distance( self.Entity:GetPos() ) < hit2:Distance( self.Entity:GetPos() ) ) then self.OrbitPoint = hit3 end

	self.OrbitPoint = self.OrbitPoint or center
	self.OrbitDistance = ( self.OrbitPoint - self.vCamPos ):Length()

end

function PANEL:Think()

	if ( !self.Capturing ) then return end

	if ( self.m_bFirstPerson ) then
		return self:FirstPersonControls()
	end

end

function PANEL:CaptureMouse()

	-- input.SetCursorPos does not work while main menu is open
	if ( !MENU_DLL and gui.IsGameUIVisible() ) then return 0, 0 end

	local x, y = input.GetCursorPos()

	local dx = x - self.mx
	local dy = y - self.my

	local centerx, centery = self:LocalToScreen( self:GetWide() * 0.5, self:GetTall() * 0.5 )
	input.SetCursorPos( centerx, centery )
	self.mx = centerx
	self.my = centery

	return dx, dy

end

local function IsKeyBindDown( cmd )

	-- Yes, this is how engine does it for input.LookupBinding
	for keyCode = 1, BUTTON_CODE_LAST do

		if ( input.LookupKeyBinding( keyCode ) == cmd and input.IsKeyDown( keyCode ) ) then
			return true
		end

	end

	return false

end

function PANEL:FirstPersonControls()

	local x, y = self:CaptureMouse()

	local scale = self:GetFOV() / 180
	x = x * -0.5 * scale
	y = y * 0.5 * scale

	if ( self.MouseKey == MOUSE_LEFT ) then

		if ( input.IsShiftDown() ) then y = 0 end

		self.aLookAngle = self.aLookAngle + Angle( y * 4, x * 4, 0 )

		self.vCamPos = self.OrbitPoint - self.aLookAngle:Forward() * self.OrbitDistance

		return
	end

	-- Look around
	self.aLookAngle = self.aLookAngle + Angle( y, x, 0 )
	self.aLookAngle.p = math.Clamp( self.aLookAngle.p, -90, 90 )

	local Movement = vector_origin

	if ( IsKeyBindDown( "+forward" ) or input.IsKeyDown( KEY_UP ) ) then
		Movement = Movement + self.aLookAngle:Forward()
	end

	if ( IsKeyBindDown( "+back" ) or input.IsKeyDown( KEY_DOWN ) ) then
		Movement = Movement - self.aLookAngle:Forward()
	end

	if ( IsKeyBindDown( "+moveleft" ) or input.IsKeyDown( KEY_LEFT ) ) then
		Movement = Movement - self.aLookAngle:Right()
	end

	if ( IsKeyBindDown( "+moveright" ) or input.IsKeyDown( KEY_RIGHT ) ) then
		Movement = Movement + self.aLookAngle:Right()
	end

	if ( IsKeyBindDown( "+jump" ) or input.IsKeyDown( KEY_SPACE ) ) then
		Movement = Movement + vector_up
	end

	if ( IsKeyBindDown( "+duck" ) or input.IsKeyDown( KEY_LCONTROL ) ) then
		Movement = Movement - vector_up
	end

	local speed = 0.5
	if ( input.IsShiftDown() ) then speed = 4.0 end

	self.vCamPos = self.vCamPos + Movement * speed * self:GetMovementScale()

end

function PANEL:OnMouseWheeled( dlta )

	local scale = self:GetFOV() / 180
	self.fFOV = math.Clamp( self.fFOV + dlta * -10.0 * scale, 0.001, 179 )

end

function PANEL:OnMouseReleased( mousecode )

	self:SetCursor( "arrow" )
	self:MouseCapture( false )
	self.Capturing = false

end

function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local ctrl = vgui.Create( ClassName )
	ctrl:SetSize( 300, 300 )
	ctrl:SetModel( "models/props_junk/PlasticCrate01a.mdl" )
	ctrl:GetEntity():SetSkin( 2 )
	ctrl:SetLookAng( Angle( 45, 0, 0 ) )
	ctrl:SetCamPos( Vector( -20, 0, 20 ) )

	PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )

end

derma.DefineControl( "DAdjustableModelPanel", "A panel containing a model", PANEL, "DModelPanel" )
