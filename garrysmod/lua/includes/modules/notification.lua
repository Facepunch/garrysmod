
surface.CreateFont( "GModNotify", {
	font	= "Arial",
	size	= 20,
	weight	= 1000
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

local Notices = {}

function AddProgress( uid, text )

	if ( IsValid( Notices[ uid ] ) ) then

		Notices[ uid ].StartTime = SysTime()
		Notices[ uid ].Length = 1000000
		Notices[ uid ]:SetText( text )
		Notices[ uid ]:SetProgress()
		return

	end

	local parent = nil
	if ( GetOverlayPanel ) then parent = GetOverlayPanel() end

	local Panel = vgui.Create( "NoticePanel", parent )
	Panel.StartTime = SysTime()
	Panel.Length = 1000000
	Panel.VelX = -5
	Panel.VelY = 0
	Panel.fx = ScrW() + 200
	Panel.fy = ScrH()
	Panel:SetAlpha( 255 )
	Panel:SetText( text )
	Panel:SetPos( Panel.fx, Panel.fy )
	Panel:SetProgress()

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
	Panel.Length = length
	Panel.VelX = -5
	Panel.VelY = 0
	Panel.fx = ScrW() + 200
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

	local w = pnl:GetWide() + 16
	local h = pnl:GetTall() + 4

	local ideal_y = ScrH() - 150 - h - total_h
	local ideal_x = ScrW() - w - 20

	local timeleft = pnl.StartTime - ( SysTime() - pnl.Length )

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
	pnl:SetPos( pnl.fx, pnl.fy )

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
	self.Label:SetTextColor( Color( 255, 255, 255, 255 ) )
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

function PANEL:SetLegacyType( t )

	self.Image = vgui.Create( "DImageButton", self )
	self.Image:SetMaterial( NoticeMaterial[ t ] )
	self.Image:SetSize( 32, 32 )
	self.Image:Dock( LEFT )
	self.Image:DockMargin( 0, 0, 8, 0 )
	self.Image.DoClick = function()
		self.StartTime = 0
	end

	self:SizeToContents()

end

function PANEL:Paint( w, h )

	self.BaseClass.Paint( self, w, h )

	if ( !self.Progress ) then return end

	surface.SetDrawColor( 0, 100, 0, 150 )
	surface.DrawRect( 4, self:GetTall() - 10, self:GetWide() - 8, 5 )

	surface.SetDrawColor( 0, 50, 0, 255 )
	surface.DrawRect( 5, self:GetTall() - 9, self:GetWide() - 10, 3 )

	local w = self:GetWide() * 0.25
	local x = math.fmod( SysTime() * 200, self:GetWide() + w ) - w

	if ( x + w > self:GetWide() - 11 ) then w = ( self:GetWide() - 11 ) - x end
	if ( x < 0 ) then w = w + x; x = 0 end

	surface.SetDrawColor( 0, 255, 0, 255 )
	surface.DrawRect( 5 + x, self:GetTall() - 9, w, 3 )

end

function PANEL:SetProgress()

	self.Progress = true

	self:SizeToContents()

end

function PANEL:KillSelf()

	if ( self.StartTime + self.Length < SysTime() ) then

		self:Remove()
		return true

	end

	return false

end

vgui.Register( "NoticePanel", PANEL, "DPanel" )
