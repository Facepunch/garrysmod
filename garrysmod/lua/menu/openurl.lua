
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
	self.HTML:SetOpenLinksExternally( true )

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
-- patch by @catSIXe - can be used in orig. gmod code if wanted
----------------------------------------------

-- better code, but we should try to save this somewhere where only the menu context can write to(read should be no problem lol)
local _whitelistFilePath = "_connectwhitelist.json"
local _whitelistDir = "DATA"
local function parseAddress(serverip)
	local Host, Port = "", 27015
	if string.find(serverip, ":") then
		local parts = string.Split(serverip, ":")
		if #parts != 2 then return -1 end
		Host = parts[1]
		Port = tonumber(parts[2])
	else
		Host = serverip
	end

	local a, b, c, d = Host:match("^(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)$")
	a = tonumber(a)
	b = tonumber(b)
	c = tonumber(c)
	d = tonumber(d)
	if not a or not b or not c or not d then return 0, Host, Port end
	if a<0 or 255<a then return 0, Host, Port end
	if b<0 or 255<b then return 0, Host, Port end
	if c<0 or 255<c then return 0, Host, Port end
	if d<0 or 255<d then return 0, Host, Port end
	return 1, Host, Port
end
local function writeWhitelist(newWhitelist)
	PrintTable(newWhitelist)
	-- TODO: Protect this filepath, or maybe write to a different directory where only the menu Context can write
	local f = file.Open(_whitelistFilePath, "wb", _whitelistDir)
	if ( !f ) then MsgN("FAILED WRITING WHITELIST") return false end
	f:Write(util.TableToJSON(newWhitelist))
	MsgN("writing to file")
	MsgN(util.TableToJSON(newWhitelist))
	f:Close()
	return true
end
local function readWhitelist()
	whitelist = {}
	if file.Exists(_whitelistFilePath, _whitelistDir) then
		local f = file.Open(_whitelistFilePath, "rb", _whitelistDir)
		if ( !f ) then return end
		local str = f:Read(f:Size())
		f:Close()
		if ( !str ) then str = "" end
		whitelist = util.JSONToTable(str)
		MsgN("Read Whitelist File")
		PrintTable(whitelist)
	end
	return whitelist
end
local function clearWhitelist()
	writeWhitelist({})
end
local function getEntryForAddress( address )
	local ipv4, Host, Port = parseAddress( address )
	if ipv4 > -1 then -- if not invalid
		if ipv4 == 0 then -- if Domain
			local Domain = Host
			local HostParts = string.Split(Domain, ".")
			if #HostParts > 2 then -- if we have a subdomain, lets just take the domain+tld itself
				Domain = HostParts[ #HostParts - 1 ] .. "." .. HostParts[ #HostParts ]
			end
			return Domain .. ":" .. Port
		else -- if IPv4
			return Host .. ":" .. Port
		end
		return "--invalid address--"
	end
end
local function checkWhitelist(serverip)
	local entryToConnect = getEntryForAddress( serverip )
	local checkList = readWhitelist()
	for i,entryComp in pairs(checkList) do
		if entryToConnect == entryComp then
			return true
		end
	end
	return false
end
local function addServerToWhitelist( address )
	local entry = getEntryForAddress( address )

	if entry == "--invalid address--" then
		return false
	end

	local newWhitelist = readWhitelist()
	newWhitelist[#newWhitelist + 1 ] =  entry
	writeWhitelist(newWhitelist)

	return false
end

----------------------------------------------
----------------------------------------------

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
	self.URL:SetDisabled( true )
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
	self.Nope:DockMargin( 0, 0, 5, 0 )
	self.Nope:Dock( RIGHT )

	self.Yes = vgui.Create( "DButton", self.Buttons )
	self.Yes:SetText( "#openurl.yes" )
	self.Yes.DoClick = function() self:DoYes() end
	self.Yes:DockMargin( 0, 0, 5, 0 )
	self.Yes:Dock( RIGHT )

	-- Makes this Menu 200x better than it was implemented before.
	self.WhitelistCheckbox = vgui.Create( "DCheckBoxLabel", self.Buttons )
	self.WhitelistCheckbox:SetText( "Don't ask again for this IP / Domain" ) -- "#openurl.whitelist"
	self.WhitelistCheckbox:DockMargin( 0, 0, 5, 0 )
	self.WhitelistCheckbox:Dock( RIGHT )
	self.WhitelistCheckbox:SetVisible( false )

	self:SetSize( 680, 104 + 250 )
	self:Center()
	self:MakePopup()
	self:DoModal()

	hook.Add( "Think", self, self.AlwaysThink )

	if ( !IsInGame() ) then self.Disconnect:SetVisible( false ) end
end

function PANEL:LoadServerInfo()
	self.CustomPanel:SetVisible( true )
	self.CustomPanel:SetText( "Loading server info..." )
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

function PANEL:AlwaysThink()
	-- Ping the server for details
	if ( SysTime() - self.StartTime > 0.1 && self.Type == "askconnect" && !self.CustomPanel:IsVisible() ) then
		self:LoadServerInfo()
	end

	if ( self.StartTime + 1 > SysTime() ) then
		return
	end

	if ( !self.WhitelistCheckbox:IsEnabled() ) then
		self.WhitelistCheckbox:SetEnabled( true )
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
	if self.Type == "askconnect" then	
		self.WhitelistCheckbox:SetText( "Don't ask again for '" .. getEntryForAddress( url ) .. "'" )
	end

	self.StartTime = SysTime()
	self.Yes:SetEnabled( false )
	self.WhitelistCheckbox:SetEnabled( false )
	self.CustomPanel:SetVisible( false )
	self.CustomPanel.Color = Color( 0, 0, 0, 0 )
	self:InvalidateLayout()
end

function PANEL:GetURL()
	return self.URL:GetText()
end

function PANEL:DoNope()
	self:Remove()
	gui.HideGameUI()
end

function PANEL:DoYes()
	if ( self.StartTime + 1 > SysTime() ) then
		return
	end
	if self.WhitelistCheckbox:GetChecked() == true then
		addServerToWhitelist(self:GetURL())
	end
	self:DoYesAction()
	self:Remove()
	gui.HideGameUI()
end

function PANEL:DoYesAction()
	if ( self.Type == "openurl" ) then
		gui.OpenURL( self.URL:GetText() )
	elseif ( self.Type == "askconnect" ) then
		JoinServer( self.URL:GetText() )
	end
end

function PANEL:SetType( t )
	self.Type = t

	self:SetTitle( "#" .. t .. ".title" )
	self.Garble:SetText( "#" .. t .. ".text" )

	self.WhitelistCheckbox:SetVisible( t == "askconnect" )
end

local PanelInst = nil
local function OpenConfirmationDialog( address, confirm_type )

	if ( IsValid( PanelInst ) && PanelInst:GetURL() == address ) then return end
	if ( !IsValid( PanelInst ) ) then PanelInst = vgui.CreateFromTable( PANEL ) end

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

-- Called from the engine
function RequestConnectToServer( serverip )
	readWhitelist()
	if checkWhitelist( serverip ) then
		JoinServer( serverip )
	else
		OpenConfirmationDialog( serverip, "askconnect" )
	end
end

concommand.Add("connect_clearwhitelist", function()
	clearWhitelist()
	writeWhitelist()
end)
