
local PANEL_Browser = {}

PANEL_Browser.Base = "DFrame"

function PANEL_Browser:Init()

	self.HTML = vgui.Create( "HTML", self )

	if ( !self.HTML ) then
		print( "SteamOverlayReplace: Failed to create HTML element" )
		self:Remove()
		return
	end

	self.HTML:Dock( FILL )
	--self.HTML:SetOpenLinksExternally( true )

	self:SetTitle( "Steam overlay replacement" )
	self:SetSize( ScrW() * 0.75, ScrH() * 0.75 )
	self:SetSizable( true )
	self:Center()
	self:MakePopup()

end

function PANEL_Browser:SetURL( url )

	self.HTML:OpenURL( url )

end

-- Called from the engine
function GMOD_OpenURLNoOverlay( url )

	local BrowserInst = vgui.CreateFromTable( PANEL_Browser )
	BrowserInst:SetURL( url )

	timer.Simple( 0, function()
		if ( !gui.IsGameUIVisible() ) then gui.ActivateGameUI() end
	end )

end

----------------------------------------------

local RememberedDenials = {}

local PANEL = {}

PANEL.Base = "DFrame"

function PANEL:Init()

	self.Type = "openurl"

	self:SetTitle( "#openurl.title" )

	self.Garble = vgui.Create( "DLabel", self )
	self.Garble:SetText( "#openurl.text" )
	self.Garble:SetContentAlignment( 5 )
	self.Garble:Dock( TOP )

	self.URL = vgui.Create( "DTextEntry", self )
	self.URL:SetEnabled( false )
	self.URL:Dock( TOP )

	self.CustomPanel = vgui.Create( "DLabel", self )
	self.CustomPanel:Dock( TOP )
	self.CustomPanel:SetContentAlignment( 5 )
	self.CustomPanel:DockMargin( 0, 5, 0, 0 )
	self.CustomPanel:SetVisible( false )
	self.CustomPanel.Color = Color( 0, 0, 0, 0 )
	self.CustomPanel.Paint = function( s, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, s.Color )
	end

	self.Buttons = vgui.Create( "Panel", self )
	self.Buttons:Dock( TOP )
	self.Buttons:DockMargin( 0, 5, 0, 0 )

	self.Disconnect = vgui.Create( "DButton", self.Buttons )
	self.Disconnect:SetText( "#openurl.disconnect" )
	self.Disconnect.DoClick = function() self:DoNope() RunConsoleCommand( "disconnect" ) end
	self.Disconnect:Dock( LEFT )
	self.Disconnect:SizeToContents()
	self.Disconnect:SetWide( self.Disconnect:GetWide() + 10 )

	self.Nope = vgui.Create( "DButton", self.Buttons )
	self.Nope:SetText( "#openurl.nope" )
	self.Nope.DoClick = function() self:DoNope() end
	self.Nope:DockMargin( 0, 0, 0, 0 )
	self.Nope:Dock( RIGHT )

	self.Yes = vgui.Create( "DButton", self.Buttons )
	self.Yes:SetText( "#openurl.yes" )
	self.Yes.DoClick = function() self:DoYes() end
	self.Yes:DockMargin( 0, 0, 20, 0 )
	self.Yes:Dock( RIGHT )

	self.YesPerma = vgui.Create( "DCheckBoxLabel", self.Buttons )
	self.YesPerma:SetText( "#openurl.yes_remember" )
	self.YesPerma:DockMargin( 0, 0, 20, 0 )
	self.YesPerma:Dock( RIGHT )
	self.YesPerma:SetVisible( false )

	self:SetSize( 680, 104 )
	self:Center()
	self:MakePopup()
	self:DoModal()

	hook.Add( "Think", self, self.AlwaysThink )

	if ( !IsInGame() ) then self.Disconnect:SetVisible( false ) end

end

function PANEL:LoadServerInfo()

	self.CustomPanel:SetVisible( true )
	self.CustomPanel:SetText( "#askconnect.loading" )
	self.CustomPanel:SizeToContents()

	serverlist.PingServer( self:GetURL(), function( ping, name, desc, map, players, maxplayers, bot, pass, lp, ip, gamemode )
		if ( !IsValid( self ) ) then return end

		if ( !ping ) then
			self.CustomPanel.Color = Color( 200, 50, 50 )
			self.CustomPanel:SetText( "#askconnect.no_response" )
		else
			self.CustomPanel:SetText( string.format( "%s\n%i/%i players | %s | %s | %ims", name, players, maxplayers, map, desc, ping ) )
		end
		self.CustomPanel:SizeToContents()
	end )

end

function PANEL:DisplayPermissionInfo()

	self.CustomPanel.Color = Color( 200, 200, 200 )
	self.CustomPanel:SetVisible( true )
	self.CustomPanel:SetDark( true )
	self.CustomPanel:SetText( "\n" .. language.GetPhrase( "permission." .. self:GetURL() ) .. "\n" .. language.GetPhrase( "permission." .. self:GetURL() .. ".help" ) .. "\n" )
	self.CustomPanel:SizeToContents()

end

function PANEL:AlwaysThink()

	-- Ping the server for details
	if ( SysTime() - self.StartTime > 0.1 and self.Type == "askconnect" and !self.CustomPanel:IsVisible() ) then
		self:LoadServerInfo()
	end

	if ( self.StartTime + 1 > SysTime() ) then
		return
	end

	if ( !self.Yes:IsEnabled() ) then
		self.Yes:SetEnabled( true )
	end

	if ( !gui.IsGameUIVisible() ) then
		self:Remove()
	end

end

function PANEL:PerformLayout( w, h )

	DFrame.PerformLayout( self, w, h )

	self:SizeToChildren( false, true )

end

function PANEL:SetURL( url )

	self.URL:SetText( url )

	self.StartTime = SysTime()
	self.Yes:SetEnabled( false )
	self.CustomPanel:SetVisible( false )
	self.CustomPanel.Color = Color( 0, 0, 0, 0 )
	self:InvalidateLayout()

	if ( self.Type == "permission" ) then
		self:DisplayPermissionInfo()
	end

end

function PANEL:GetURL()

	return self.URL:GetText()

end

function PANEL:DoNope()

	self:Remove()
	gui.HideGameUI()

	-- Keep track of what the player wants to ignore, but only for this session. 
	local remember = self.YesPerma:GetChecked()
	if ( remember ) then
		RememberedDenials[ self.uniquePermID ] = true
	end
end

function PANEL:DoYes()

	if ( self.StartTime + 1 > SysTime() ) then
		return
	end

	local saveYes = self.YesPerma:GetChecked()
	self:DoYesAction( !saveYes )
	self:Remove()
	gui.HideGameUI()

end

function PANEL:DoYesAction( bSessionOnly )

	if ( self.Type == "openurl" ) then
		gui.OpenURL( self.URL:GetText() )
	elseif ( self.Type == "askconnect" ) then
		permissions.Grant( "connect", bSessionOnly )
		permissions.Connect( self.URL:GetText() )
	elseif ( self.Type == "permission" ) then
		permissions.Grant( self.URL:GetText(), bSessionOnly )
	else
		ErrorNoHaltWithStack( "Unhandled confirmation type '" .. tostring( self.Type ) .. "'!" )
	end

end

function PANEL:SetType( t )

	self.Type = t

	self:SetTitle( "#" .. t .. ".title" )
	self.Garble:SetText( "#" .. t .. ".text" )

	if ( self.Type == "permission" or self.Type == "askconnect" ) then
		self.YesPerma:SetVisible( true )
	end

end

local PanelInst = nil
local function OpenConfirmationDialog( address, confirm_type )

	local permID = tostring( confirm_type ) .. "|" .. tostring( address ) .. "|" .. tostring( engine.CurrentServerAddress() )
	if ( RememberedDenials[ permID ] ) then
		print( "Ignoring request for denied permission " .. tostring( confirm_type ) .. " to " .. tostring( address ) ) -- Debug
		return
	end

	if ( IsValid( PanelInst ) and PanelInst:GetURL() == address ) then return end
	if ( !IsValid( PanelInst ) ) then PanelInst = vgui.CreateFromTable( PANEL ) end

	PanelInst.uniquePermID = permID
	PanelInst:SetType( confirm_type )
	PanelInst:SetURL( address )

	timer.Simple( 0, function()
		if ( !gui.IsGameUIVisible() ) then gui.ActivateGameUI() end
	end )

end

-- Called from the engine
function RequestOpenURL( url )

	OpenConfirmationDialog( url, "openurl" )

end
function RequestConnectToServer( serverip )

	if ( permissions.IsGranted( "connect" ) ) then
		permissions.Connect( serverip )
	else
		OpenConfirmationDialog( serverip, "askconnect" )
	end

end
function RequestPermission( perm )

	OpenConfirmationDialog( perm, "permission" )

end
