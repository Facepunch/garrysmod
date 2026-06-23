
local textH = math.max( 12, math.ceil( ScreenScaleH( 9 ) ) )
local iconH = math.ceil( textH * 1.25 )

-- TODO: refresh the sizes and font on screen size change? is that really necessary? how often people change resoltuion in game?

surface.CreateFont( "GModNotify", {
	font	= "Arial",
	size	= textH,
	weight	= 500,
	extended = true
} )

NOTIFY_GENERIC	= 0
NOTIFY_ERROR	= 1
NOTIFY_UNDO		= 2
NOTIFY_HINT		= 3
NOTIFY_CLEANUP	= 4

module( "notification", package.seeall )

local NoticeMaterial = {}

NoticeMaterial[ NOTIFY_GENERIC ]	= Material( "vgui/notices/generic" )
NoticeMaterial[ NOTIFY_ERROR ]		= Material( "vgui/notices/error" )
NoticeMaterial[ NOTIFY_UNDO ]		= Material( "vgui/notices/undo" )
NoticeMaterial[ NOTIFY_HINT ]		= Material( "vgui/notices/hint" )
NoticeMaterial[ NOTIFY_CLEANUP ]	= Material( "vgui/notices/cleanup" )

local NOTIF_START_X = 200 -- Pixels
local NOTIF_CHARGE_X = 0.04 -- Percent of screen size
local NOTIF_GAP_X = 0.015
local NOTIF_ANCHOR_Y = 0.8

local Notices = {}

function AddProgress( uid, text, frac )

	if ( IsValid( Notices[ uid ] ) ) then

		Notices[ uid ].StartTime = SysTime()
		Notices[ uid ].Length = -1
		Notices[ uid ]:SetText( text )
		Notices[ uid ]:SetProgress( frac )
		return

	end

	local parent = nil
	if ( GetOverlayPanel ) then parent = GetOverlayPanel() end

	local Panel = vgui.Create( "NoticePanel", parent )
	Panel.StartTime = SysTime()
	Panel.Length = -1
	Panel.VelX = -5
	Panel.VelY = 0
	Panel.fx = ScrW() + NOTIF_START_X
	Panel.fy = ScrH()
	Panel:SetAlpha( 255 )
	Panel:SetText( text )
	Panel:SetPos( Panel.fx, Panel.fy )
	Panel:SetProgress( frac )

	Notices[ uid ] = Panel

end

function Kill( uid )

	if ( !IsValid( Notices[ uid ] ) ) then return end

	Notices[ uid ].StartTime = SysTime()
	Notices[ uid ].Length = 0.8

end

function AddLegacy( text, type, length )

	local parent = nil
	if ( GetOverlayPanel ) then parent = GetOverlayPanel() end

	local Panel = vgui.Create( "NoticePanel", parent )
	Panel.StartTime = SysTime()
	Panel.Length = math.max( length, 0 )
	Panel.VelX = -5
	Panel.VelY = 0
	Panel.fx = ScrW() + NOTIF_START_X
	Panel.fy = ScrH()
	Panel:SetAlpha( 255 )
	Panel:SetText( text )
	Panel:SetLegacyType( type )
	Panel:SetPos( Panel.fx, Panel.fy )

	table.insert( Notices, Panel )

end

-- This is ugly because it's ripped straight from the old notice system
local function UpdateNotice( pnl, total_h )

	local x = pnl.fx
	local y = pnl.fy

	local w = pnl:GetWide()
	local h = pnl:GetTall() + math.ceil( textH * 0.2 )

	local ideal_y = ScrH() * NOTIF_ANCHOR_Y - h - total_h
	local ideal_x = ScrW() - w - ( ScrW() * NOTIF_GAP_X )

	local timeleft = pnl.StartTime - ( SysTime() - pnl.Length )
	if ( pnl.Length < 0 ) then timeleft = 1 end

	-- Cartoon style about to go thing
	if ( timeleft < 0.7 ) then
		ideal_x = ideal_x - ( ScrW() * NOTIF_CHARGE_X )
	end

	-- Gone!
	if ( timeleft < 0.2 ) then
		ideal_x = ideal_x + w * 2
	end

	local spd = RealFrameTime() * 15

	y = y + pnl.VelY * spd
	x = x + pnl.VelX * spd

	local dist = ideal_y - y
	pnl.VelY = pnl.VelY + dist * spd * 1
	if ( math.abs( dist ) < 2 && math.abs( pnl.VelY ) < 0.1 ) then pnl.VelY = 0 end
	dist = ideal_x - x
	pnl.VelX = pnl.VelX + dist * spd * 1
	if ( math.abs( dist ) < 2 && math.abs( pnl.VelX ) < 0.1 ) then pnl.VelX = 0 end

	-- Friction.. kind of FPS independant.
	pnl.VelX = pnl.VelX * ( 0.95 - RealFrameTime() * 8 )
	pnl.VelY = pnl.VelY * ( 0.95 - RealFrameTime() * 8 )

	pnl.fx = x
	pnl.fy = y

	-- If the panel is too high up (out of screen), do not update its position. This lags a lot when there are lot of panels outside of the screen
	if ( ideal_y > -ScrH() ) then
		pnl:SetPos( pnl.fx, pnl.fy )
	end

	return total_h + h

end

hook.Add( "Think", "NotificationThink", function()

	if ( !Notices ) then return end

	local h = 0
	for key, pnl in pairs( Notices ) do
		h = UpdateNotice( pnl, h )
	end

	for k, Panel in pairs( Notices ) do
		if ( !IsValid( Panel ) || Panel:KillSelf() ) then
			Notices[ k ] = nil
		end
	end

end )

local PANEL = {}

function PANEL:Init()

	self:DockPadding( 3, 3, 3, 3 )

	self.Label = vgui.Create( "DLabel", self )
	self.Label:Dock( FILL )
	self.Label:SetFont( "GModNotify" )
	self.Label:SetTextColor( color_white )
	self.Label:SetExpensiveShadow( 1, Color( 0, 0, 0, 200 ) )
	self.Label:SetContentAlignment( 5 )

	self:SetBackgroundColor( Color( 20, 20, 20, 255 * 0.6 ) )

end

function PANEL:SetText( txt )

	self.Label:SetText( txt )
	self:SizeToContents()

end

function PANEL:SizeToContents()

	self.Label:SizeToContents()

	local width, tall = self.Label:GetSize()

	-- All some padding based on text size
	tall = tall + math.ceil( textH * 0.25 )
	width = width + math.ceil( textH * 0.75 )

	if ( IsValid( self.Image ) ) then
		local iconGap = math.ceil( iconH * 0.1 )
		width = width + self.Image:GetWide() + ( iconGap * 2 )

		local minH = self.Image:GetTall() + ( iconGap * 2 )
		local oldTall = tall
		tall = math.max( tall, minH )
		local diff = math.max( ( oldTall - minH ) / 2, 0 )

		self.Image:DockMargin( iconGap, iconGap + diff, iconGap, iconGap + diff )
	end

	if ( self.Progress ) then
		tall = tall + 10
		self.Label:DockMargin( 0, 0, 0, 10 )
	end

	-- Add our own padding
	local l, t, r, b = self:GetDockPadding()
	width = width + l + r
	tall = tall + t + b

	self:SetSize( width, tall )

	self:InvalidateLayout()

end

function PANEL:SetLegacyType( t )

	if ( IsValid( self.Image ) ) then self.Image:Remove() end

	self.Image = vgui.Create( "DImage", self )
	self.Image:SetMaterial( NoticeMaterial[ t ] )
	self.Image:SetSize( iconH, iconH )
	self.Image:Dock( LEFT )

	-- Make the icons not look terrible when scaled
	self.Image.Paint = function( s, w, h )
		render.PushFilterMag( TEXFILTER.ANISOTROPIC )
		render.PushFilterMin( TEXFILTER.ANISOTROPIC )
		s:PaintAt( 0, 0, w, h )
		render.PopFilterMin()
		render.PopFilterMag()
	end

	self:SizeToContents()

end

function PANEL:Paint( w, h )

	local shouldDraw = !( LocalPlayer && IsValid( LocalPlayer() ) && IsValid( LocalPlayer():GetActiveWeapon() ) && LocalPlayer():GetActiveWeapon():GetClass() == "gmod_camera" )

	if ( IsValid( self.Label ) ) then self.Label:SetVisible( shouldDraw ) end
	if ( IsValid( self.Image ) ) then self.Image:SetVisible( shouldDraw ) end

	if ( !shouldDraw ) then return end

	self.BaseClass.Paint( self, w, h )

	if ( !self.Progress ) then return end

	local boxX, boxY = 10, self:GetTall() - 13
	local boxW, boxH = self:GetWide() - 20, 5
	local boxInnerW = boxW - 2

	surface.SetDrawColor( 0, 100, 0, 150 )
	surface.DrawRect( boxX, boxY, boxW, boxH )

	surface.SetDrawColor( 0, 50, 0, 255 )
	surface.DrawRect( boxX + 1, boxY + 1, boxW - 2, boxH - 2 )

	local w = math.ceil( boxInnerW * 0.25 )
	local x = math.fmod( math.floor( SysTime() * 200 ), boxInnerW + w ) - w

	if ( self.ProgressFrac ) then
		x = 0
		w = math.ceil( boxInnerW * self.ProgressFrac )
	end

	if ( x + w > boxInnerW ) then w = math.ceil( boxInnerW - x ) end
	if ( x < 0 ) then
		w = w + x
		x = 0
	end

	surface.SetDrawColor( 0, 255, 0, 255 )
	surface.DrawRect( boxX + 1 + x, boxY + 1, w, boxH - 2 )

end

function PANEL:SetProgress( frac )

	self.Progress = true
	self.ProgressFrac = frac

	self:SizeToContents()

end

function PANEL:KillSelf()

	-- Infinite length
	if ( self.Length < 0 ) then return false end

	if ( self.StartTime + self.Length < SysTime() ) then

		self:Remove()
		return true

	end

	return false

end

vgui.Register( "NoticePanel", PANEL, "DPanel" )
