
surface.CreateFont( "GModNotify", {
	font	= "Arial",
	size	= 21,
	weight	= 0,
	extended = true
} )

NOTIFY_GENERIC	= 0
NOTIFY_ERROR	= 1
NOTIFY_UNDO		= 2
NOTIFY_HINT		= 3
NOTIFY_CLEANUP	= 4

module( "notification", package.seeall )

local Notices = {}
local NoticeIcon = {}

NoticeIcon[ NOTIFY_GENERIC ]	= "vgui/notices/generic"
NoticeIcon[ NOTIFY_ERROR ]		= "vgui/notices/error"
NoticeIcon[ NOTIFY_UNDO ]		= "vgui/notices/undo"
NoticeIcon[ NOTIFY_HINT ]		= "vgui/notices/hint"
NoticeIcon[ NOTIFY_CLEANUP ]	= "vgui/notices/cleanup"

local function CreateNotice( msg, length )

	local parent = nil
	if ( GetOverlayPanel ) then parent = GetOverlayPanel() end

	local notice = vgui.Create( "NoticePanel", parent )
	notice.StartTime = SysTime()
	notice.Length = length
	notice.VelX = -5
	notice.VelY = 0
	notice.fx = ScrW() + 200
	notice.fy = ScrH()
	notice:SetAlpha( 255 )
	notice:SetText( msg )
	notice:SetPos( notice.fx, notice.fy )

	return notice

end

function Add( text, length, icon, color )

	local notice = CreateNotice( text, math.max( length or 5, 0 ) )
	notice:SetIcon( icon or "vgui/notices/generic" )

	if ( color ) then
		notice.Label:SetTextColor( color )
	end

	return table.insert( Notices, notice )

end

function AddLegacy( text, type, length )

	Add( text, length or 0, NoticeIcon[ type ] )

end

function AddProgress( uid, text, frac )

	local notice = Notices[ uid ]

	if ( IsValid( notice ) ) then

		notice.StartTime = SysTime()
		notice.Length = -1
		notice:SetText( text )
		notice:SetProgress( frac )
		return

	end

	notice = CreateNotice( text, -1 )
	notice:SetProgress( frac )

	Notices[ uid ] = notice

end

function Kill( uid )

	local notice = Notices[ uid ]
	if ( !IsValid( notice ) ) then return end

	notice.StartTime = SysTime()
	notice.Length = 0.8

end

-- This is ugly because it's ripped straight from the old notice system
local function UpdateNotice( pnl, total_h )

	local x = pnl.fx
	local y = pnl.fy

	local w = pnl:GetWide() + 16
	local h = pnl:GetTall() + 4

	local ideal_y = ScrH() - 150 - h - total_h
	local ideal_x = ScrW() - w - 20

	local timeleft = pnl.StartTime - ( SysTime() - pnl.Length )
	if ( pnl.Length < 0 ) then timeleft = 1 end

	-- Cartoon style about to go thing
	if ( timeleft < 0.7 ) then
		ideal_x = ideal_x - 50
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

local function Update()

	if ( !Notices ) then return end

	local h = 0
	for key, pnl in pairs( Notices ) do

		h = UpdateNotice( pnl, h )

	end

	for k, Panel in pairs( Notices ) do

		if ( !IsValid( Panel ) || Panel:KillSelf() ) then Notices[ k ] = nil end

	end

end

hook.Add( "Think", "NotificationThink", Update )

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

	tall = math.max( tall, 32 ) + 6
	width = width + 20

	if ( IsValid( self.Image ) ) then
		width = width + 32 + 8

		local x = ( tall - 36 ) / 2
		self.Image:DockMargin( 0, x, 0, x )
	end

	if ( self.Progress ) then
		tall = tall + 10
		self.Label:DockMargin( 0, 0, 0, 10 )
	end

	self:SetSize( width, tall )

	self:InvalidateLayout()

end

function PANEL:SetIcon( icon )

	self.Image = vgui.Create( "DImageButton", self )
	self.Image:SetMaterial( Material( icon ) )
	self.Image:SetSize( 32, 32 )
	self.Image:Dock( LEFT )
	self.Image:DockMargin( 0, 0, 8, 0 )
	self.Image.DoClick = function()
		self.StartTime = 0
	end

	self:SizeToContents()

end

function PANEL:SetLegacyType( t )

	self:SetIcon( NoticeIcon[ t ] )

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
