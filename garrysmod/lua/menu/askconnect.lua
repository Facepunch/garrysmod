local ASK_CONNECT_WAIT_TIME = 5

local MAT_GMOD_LOGO = Material( "../html/img/gmod_logo_brave.png", "smooth" )
local MAT_BACKGROUND = Material( "../html/img/bg.png", "smooth" )

local ASK_CONNECT_HEIGHT = 340
local ASK_CONNECT_WITH_DETAILS_HEIGHT = 374

surface.CreateFont( "AskConnectTitle", {
	font = "Roboto Bk",
	size = 70,
	weight = 1000
} )

surface.CreateFont( "AskConnectServerName", {
	font = "Roboto Bk",
	size = 36,
	weight = 1000
} )

surface.CreateFont( "AskConnectSubtitle", {
	font = "Roboto Bk",
	size = 24,
	weight = 1000
} )

local function DrawCenteredText( text, x, y )
	local w, h = surface.GetTextSize( text )
	x = x - ( w / 2 )

	surface.SetTextPos( x, y )
	surface.DrawText( text )

	return h
end

local easeInOutCubic = ( math.ease && math.ease.InOutCubic ) || function( x )
	return x < 0.5 && 4 * x ^ 3 || 1 - ( ( -2 * x + 2 ) ^ 3 ) / 2
end

local easeInCirc = ( math.ease && math.ease.InCirc ) || function( x )
	return 1 - math.sqrt( 1 - ( x ^ 2 ) )
end

local PANEL = {}

PANEL.Base = "DPanel"

function PANEL:Init()

	self.m_bCloseGameUI = gui.IsGameUIVisible()
	gui.ActivateGameUI()
	hook.Add( "Think", self, self.AlwaysThink )
	
	self.Paint = nil

	self:SetKeyboardInputEnabled( true )
	self:SetMouseInputEnabled( true )

	self:SetSize( ScrW(), ScrH() )
	self:MakePopup()
	self:DoModal()
	self:SetDrawOnTop(true)

	self.m_ServerName = nil
	self.m_ServerDetails = nil

end

function PANEL:OnScreenSizeChanged()
	self:SetSize( ScrW(), ScrH() )
	self:SetPos( 0, 0 )
end

function PANEL:LoadServerInfo()
	serverlist.PingServer( self:GetDestination(), function( ping, name, desc, map, players, maxplayers, bot, pass, lp, ip, gamemode )
		if ( !IsValid( self ) ) then return end
	
		if ( ping ) then
			self.m_ServerName = name
			self.m_ServerDetails = string.format( language.GetPhrase( "#askconnect.server_details" ), players, maxplayers, map, desc, ping )
		end
	end )
end

function PANEL:SetDestination( destination )
	self.m_sDestination = destination

	self.m_iStartTime = SysTime()
	self.Paint = self.PaintAskConnect

	self:LoadServerInfo()
end

function PANEL:GetDestination()
	return self.m_sDestination
end

function PANEL:GetEscapeKey()
	local keyName = input.LookupBinding( "cancelselect" )
	if ( keyName ) then
		return input.GetKeyCode( keyName ), keyName
	end
end

function PANEL:GetWaitFraction()
	return math.min( math.TimeFraction( self.m_iStartTime, self.m_iStartTime + ASK_CONNECT_WAIT_TIME, SysTime() ), 1)
end

function PANEL:GetFadeFraction()
	return easeInOutCubic( math.min( math.TimeFraction( self.m_iStartTime, self.m_iStartTime + 0.5, SysTime() ), 1) )
end

function PANEL:PaintAskConnect()
	local keyName = select( 2, self:GetEscapeKey() )

	local waitFrac = self:GetWaitFraction()

	if ( waitFrac >= 1 && self.m_sDestination ) then

		self:Remove()
		JoinServer( self.m_sDestination )
		return

	end

	local deltaTime = ( self.m_iStartTime + ASK_CONNECT_WAIT_TIME ) - SysTime()

	local fadeFrac = self:GetFadeFraction()
	self:SetAlpha( fadeFrac * 255 )
	surface.SetAlphaMultiplier( fadeFrac )
	
	surface.SetDrawColor( color_white )
	surface.DrawRect( 0, 0, ScrW(), ScrH() )
	surface.SetMaterial( MAT_BACKGROUND )
	surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )

	-- Slides the content up a bit to that it's centered in the screen.
	-- See the debug print at the end of the function.
	local yCenterOffset = ( self.m_ServerDetails && ASK_CONNECT_WITH_DETAILS_HEIGHT || ASK_CONNECT_HEIGHT ) / 2

	local xCenter, yCenter = ScrW() / 2, ( ScrH() / 2 ) - ( yCenterOffset || 0 )
	
	surface.SetDrawColor( color_white )
	surface.SetMaterial( MAT_GMOD_LOGO )
	surface.DrawTexturedRect( xCenter - ( 201 / 2 ), yCenter, 201, 149 )

	yCenter = yCenter + 149

	surface.SetTextColor( color_black )
	surface.SetFont( "AskConnectTitle" )
	yCenter = yCenter + DrawCenteredText( "#askconnect.on_your_way", xCenter, yCenter ) + 30
	
	surface.SetTextPos( xCenter, yCenter + 45 )
	surface.SetFont( "AskConnectServerName" )
	yCenter = yCenter + DrawCenteredText( self.m_ServerName || self.m_sDestination, xCenter, yCenter )
	
	surface.SetFont( "AskConnectSubtitle" )
	if ( self.m_ServerDetails ) then
		yCenter = yCenter + 10
		yCenter = yCenter + DrawCenteredText( self.m_ServerDetails, xCenter, yCenter )
	end

	yCenter = yCenter + 30

	local r = easeInCirc( waitFrac ) * 255
	surface.SetTextColor( r, 0, 0 )

	yCenter = yCenter + DrawCenteredText(
		string.format( language.GetPhrase( "#askconnect.cancel" ), keyName && string.upper( keyName ) || "NOT BOUND", math.max( math.ceil( deltaTime ), 0 ) ),
		xCenter, yCenter
	)

	--print( yCenter - ( ScrH() / 2 ) ) -- prints the height of the entire content, for setting the height constants. comment out yCenterOffset!

end

function PANEL:AlwaysThink()

	if ( !gui.IsGameUIVisible() ) then
		self:Remove()
	end

end

-- Called from the engine
local PanelInst = nil
function RequestConnectToServer( serverip )

	if ( IsValid( PanelInst ) ) then
		if ( PanelInst:GetDestination() == serverip ) then return end
	else
		PanelInst = vgui.CreateFromTable( PANEL )
	end

	PanelInst:SetDestination( serverip )
	
	timer.Simple( 0, function()
		if ( !gui.IsGameUIVisible() ) then gui.ActivateGameUI() end
	end )

end
