
local sensor_color_show = CreateConVar( "sensor_color_show", "0", FCVAR_DONTRECORD )
local sensor_color_scale = CreateConVar( "sensor_color_scale", "0.5", FCVAR_ARCHIVE + FCVAR_DONTRECORD )
local sensor_color_x = CreateConVar( "sensor_color_x", "32", FCVAR_ARCHIVE + FCVAR_DONTRECORD )
local sensor_color_y = CreateConVar( "sensor_color_y", "-32", FCVAR_ARCHIVE + FCVAR_DONTRECORD )

local function DrawColorBox()

	if ( !sensor_color_show:GetBool() ) then return end

	local mat = motionsensor.GetColourMaterial()
	if ( !mat ) then return end

	local size = sensor_color_scale:GetFloat()
	local w = 640 * size
	local h = 480 * size

	local x = sensor_color_x:GetInt()
	if ( x < 0 ) then
		x = x * -1
		x = ScrW() - x - w
	end

	local y = sensor_color_y:GetInt()
	if ( y < 0 ) then
		y = y * -1
		y = ScrH() - y - h
	end

	local alpha = 255

	--
	-- fade the box down if we get close, so we can click on stuff that's under it.
	--
	if ( vgui.CursorVisible() ) then
		local mx, my = input.GetCursorPos()
		local dist = Vector( mx, my, 0 ):Distance( Vector( x + w * 0.5, y + h * 0.5, 0 ) )
		alpha = math.Clamp( alpha - ( 512 - dist ), 10, 255 )
	end

	surface.SetDrawColor( 0, 0, 0, alpha )
	surface.DrawRect( x - 3, y - 3, 3, h + 6 )
	surface.DrawRect( w + x, y - 3, 3, h + 6 )
	surface.DrawRect( x, y - 3, w, 3 )
	surface.DrawRect( x, y + h, w, 3 )

	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.DrawRect( x - 1, y - 1, 1, h + 2 )
	surface.DrawRect( w + x, y - 1, 1, h + 2 )
	surface.DrawRect( x, y - 1, w, 1 )
	surface.DrawRect( x, y + h, w, 1 )

	surface.SetMaterial( mat )
	surface.DrawTexturedRectUV( x, y, w, h, 640 / 1024, 0, 0, 480 / 512 )

end

hook.Add( "DrawOverlay", "DrawMotionSensor", DrawColorBox )
