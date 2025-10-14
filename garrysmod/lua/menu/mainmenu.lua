
include( "background.lua" )
include( "cef_credits.lua" )
include( "crosshair_setup.lua" )
include( "openurl.lua" )
include( "ugcpublish.lua" )

pnlMainMenu = nil
local pnlMainMenuFallback = nil

local PANEL = {}

function PANEL:Init()

	self:Dock( FILL )
	self:SetKeyboardInputEnabled( true )
	self:SetMouseInputEnabled( true )

	self.HTML = vgui.Create( "DHTML", self )

	JS_Language( self.HTML )
	JS_Utility( self.HTML )
	JS_Workshop( self.HTML )
	self.HTML:AddFunction( "lua", "Run", function( param, ... )
		local args = { ... }
		for id, arg in pairs( args ) do
			if ( isstring( arg ) ) then
				args[ id ] = "[[" .. arg .. "]]"
			end
		end

		RunString( param:format( unpack( args ) ) )
	end )
	self.HTML:AddFunction( "lua", "PlaySound", function( param ) surface.PlaySound( param ) end )

	-- Detect whenther the HTML engine is even there
	self.menuLoaded = false
	self.HTML.OnBeginLoadingDocument = function()
		self.menuLoaded = true
		if ( IsValid( pnlMainMenuFallback ) ) then pnlMainMenuFallback:Remove() end
	end

	self.HTML:Dock( FILL )
	self.HTML:OpenURL( "asset://garrysmod/html/menu.html" )
	self.HTML:SetKeyboardInputEnabled( true )
	self.HTML:SetMouseInputEnabled( true )
	self.HTML:RequestFocus()

	ws_dupe.HTML = self.HTML
	ws_save.HTML = self.HTML
	addon.HTML = self.HTML
	demo.HTML = self.HTML

	self:MakePopup()
	self:SetPopupStayAtBack( true )

	-- If the console is already open, we've got in its way.
	if ( gui.IsConsoleVisible() ) then
		gui.ShowConsole()
	end

end

function PANEL:ScreenshotScan( folder )

	local bReturn = false

	local Screenshots = file.Find( folder .. "*.*", "GAME" )
	for k, v in RandomPairs( Screenshots ) do

		AddBackgroundImage( folder .. v )
		bReturn = true

	end

	return bReturn

end

function PANEL:Paint()

	DrawBackground()

	if ( self.IsInGame != IsInGame() ) then

		self.IsInGame = IsInGame()

		if ( self.IsInGame ) then

			if ( IsValid( self.InnerPanel ) ) then self.InnerPanel:Remove() end
			self:Call( "SetInGame( true )" )

		else

			self:Call( "SetInGame( false )" )

		end
	end

	if ( !self.IsInGame ) then return end

	local canAdd = CanAddServerToFavorites()
	local isFav = serverlist.IsCurrentServerFavorite()
	if ( self.CanAddServerToFavorites != canAdd or self.IsCurrentServerFavorite != isFav ) then

		self.CanAddServerToFavorites = canAdd
		self.IsCurrentServerFavorite = isFav

		self:Call( "SetShowFavButton( " .. tostring( self.CanAddServerToFavorites ) .. ", " .. tostring( self.IsCurrentServerFavorite ) .. " )" )

	end

end

function PANEL:RefreshContent()

	self:RefreshGamemodes()
	self:RefreshAddons()

end

function PANEL:RefreshGamemodes()

	local json = util.TableToJSON( engine.GetGamemodes() )

	self:Call( "UpdateGamemodes( " .. json .. " )" )
	self:UpdateBackgroundImages()
	self:Call( "UpdateCurrentGamemode( '" .. engine.ActiveGamemode():JavascriptSafe() .. "' )" )

end

function PANEL:RefreshAddons()

	-- TODO

end

function PANEL:SetProblemCount( problems, severity )

	self:Call( "SetProblemCount(" .. problems .. ", " .. severity .. ")" )

end

function PANEL:UpdateBackgroundImages()

	ClearBackgroundImages()

	--
	-- If there's screenshots in gamemodes/<gamemode>/backgrounds/*.jpg use them
	--
	if ( !self:ScreenshotScan( "gamemodes/" .. engine.ActiveGamemode() .. "/backgrounds/" ) ) then

		--
		-- If there's no gamemode specific here we'll use the default backgrounds
		--
		self:ScreenshotScan( "backgrounds/" )

	end

	ChangeBackground( engine.ActiveGamemode() )

end

function PANEL:Call( js )

	self.HTML:QueueJavascript( js )

end

vgui.Register( "MainMenuPanel", PANEL, "EditablePanel" )

local PANEL = {}

function PANEL:SetText( txt )
	self.Text = txt
end

function PANEL:Paint( w, h )
	-- Draw the text
	local parsed = markup.Parse( self.Text, self:GetParent():GetWide() )
	parsed:Draw( 0, 0 )

	-- Size to contents. Ew.
	self:SetSize( parsed:GetWidth(), parsed:GetHeight() )
end

-- TODO: Maybe this panel belongs in client realm as well?
local markupPanel = vgui.RegisterTable( PANEL, "Panel" )

function OnMenuFailedToLoad()
	local frame = vgui.Create( "DFrame" )
	frame:SetSize( ScrW() / 2, ScrH() / 2 )
	frame:Center()
	frame:SetDraggable( false )
	frame:ShowCloseButton( false )
	frame:SetTitle( "Menu failed to load" )
	frame:MakePopup()

	pnlMainMenuFallback = frame

	local lbl = vgui.CreateFromTable( markupPanel, frame )
	lbl:Dock( TOP )
	lbl:DockMargin( 0, 0, 0, 5 )
	lbl:SetText( "Looks like the main menu failed to load.\n\nThis could be due to missing game files (run verification of game file integrity through Steam), or the HTML engine failed to load.\n\nBelow are some simple options to exit the game." )

	local btn_srv = frame:Add( "DButton" )
	btn_srv:Dock( TOP )
	btn_srv:DockMargin( 0, 0, 0, 5 )
	btn_srv:SetText( "#find_mp_game" )
	btn_srv:SetConsoleCommand( "gamemenucommand", "OpenServerBrowser" )

	local btn_opt = frame:Add( "DButton" )
	btn_opt:Dock( TOP )
	btn_opt:DockMargin( 0, 0, 0, 5 )
	btn_opt:SetText( "#options" )
	btn_opt:SetConsoleCommand( "gamemenucommand", "OpenOptionsDialog" )

	local btn_exit = frame:Add( "DButton" )
	btn_exit:Dock( TOP )
	btn_exit:DockMargin( 0, 0, 0, 5 )
	btn_exit:SetText( "#quit" )
	btn_exit.DoClick = function() RunGameUICommand( "quit" ) end
end


--
-- Called from JS when starting a new game
--
function UpdateServerSettings()

	local array = {
		hostname = GetConVarString( "hostname" ),
		sv_lan = GetConVarString( "sv_lan" ),
		p2p_enabled = GetConVarString( "p2p_enabled" ),
		p2p_friendsonly = GetConVarString( "p2p_friendsonly" )
	}

	local settings_file = file.Read( "gamemodes/" .. engine.ActiveGamemode() .. "/" .. engine.ActiveGamemode() .. ".txt", true )

	if ( settings_file ) then

		local Settings = util.KeyValuesToTable( settings_file )

		if ( istable( Settings.settings ) ) then

			array.settings = {}
			for k, v in pairs( Settings.settings ) do
				local cvar = GetConVar( v.name )
				if ( !cvar ) then continue end

				array.settings[ k ] = v
				array.settings[ k ].Value = cvar:GetString()
				array.settings[ k ].Singleplayer = v.singleplayer and true or false
			end

		end

	end

	local json = util.TableToJSON( array )
	pnlMainMenu:Call( "UpdateServerSettings(" .. json .. ")" )

end

--
-- Get the player list for this server
--
function GetPlayerList( serverip )

	serverlist.PlayerList( serverip, function( tbl )

		local json = util.TableToJSON( tbl )
		pnlMainMenu:Call( "SetPlayerList( '" .. serverip:JavascriptSafe() .. "', " .. json .. ")" )

	end )

end

local BlackList = {
	Addresses = {},
	Hostnames = {},
	Descripts = {},
	Gamemodes = {},
	Maps = {},
}

local NewsList = {}

GetAPIManifest( function( result )
	result = util.JSONToTable( result )
	if ( !result ) then return end

	NewsList = result.News and result.News.Blogs or {}
	LoadNewsList()

	for k, v in pairs( result.Servers and result.Servers.Banned or {} ) do
		if ( v:StartsWith( "map:" ) ) then
			table.insert( BlackList.Maps, v:sub( 5 ) )
		elseif ( v:StartsWith( "host:" ) or v:StartsWith( "name:" ) ) then
			table.insert( BlackList.Hostnames, v:sub( 6 ) )
		elseif ( v:StartsWith( "desc:" ) ) then
			table.insert( BlackList.Descripts, v:sub( 6 ) )
		elseif ( v:StartsWith( "gm:" ) ) then
			table.insert( BlackList.Gamemodes, v:sub( 4 ) )
		else
			table.insert( BlackList.Addresses, v )
		end
	end
end )

function LoadNewsList()
	if ( !pnlMainMenu ) then return end

	local json = util.TableToJSON( NewsList )
	local bHide = cookie.GetString( "hide_newslist", "false" ) == "true"

	pnlMainMenu:Call( "UpdateNewsList(" .. json .. ", " .. tostring( bHide ) .. " )" )
end

function SaveHideNews( bHide )
	cookie.Set( "hide_newslist", tostring( bHide ) )
end

function IsServerBlacklisted( address, hostname, description, gm, map )
	local addressNoPort = address:match( "[^:]*" )

	for k, v in ipairs( BlackList.Addresses ) do
		if ( address == v or addressNoPort == v ) then
			return v
		end

		if ( v:EndsWith( "*" ) and address:sub( 1, v:len() - 1 ) == v:sub( 1, v:len() - 1 ) ) then return v end

		-- IP Ranges
		if ( string.find( v, "/", 1, false ) ) then
			local o1, o2, o3, o4, o5 = string.match( v, "(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)/(%d%d?)" )
			local blacklistedIP = 2 ^ 24 * o1 + 2 ^ 16 * o2 + 2 ^ 8 * o3 + o4

			local mask = bit.lshift( 0xFFFFFFFF, 32-o5 )

			o1, o2, o3, o4 = string.match( address, "(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)" )
			local testIP = 2 ^ 24 * o1 + 2 ^ 16 * o2 + 2 ^ 8 * o3 + o4

			if ( bit.band( testIP, mask ) == bit.band( blacklistedIP, mask ) ) then return v end
		end
	end

	for k, v in ipairs( BlackList.Hostnames ) do
		if ( string.match( hostname, v ) or string.match( hostname:lower(), v ) ) then
			return "host: " .. v
		end
	end

	for k, v in ipairs( BlackList.Descripts ) do
		if ( string.match( description, v ) or string.match( description:lower(), v ) ) then
			return "desc: " .. v
		end
	end

	for k, v in ipairs( BlackList.Gamemodes ) do
		if ( string.match( gm, v ) or string.match( gm:lower(), v ) ) then
			return "gm: " .. v
		end
	end

	for k, v in ipairs( BlackList.Maps ) do
		if ( string.match( map, v ) or string.match( map:lower(), v ) ) then
			return "map: " .. v
		end
	end

	return nil
end

local Servers = {}
local ShouldStop = {}

local function SendServer( pnlMainMenu, category, id,
	ping, name, desc, map, players, maxplayers, botplayers, pass, lastplayed, address, gm, workshopid, isAnon, netVersion, luaVersion, loc, gmcat )

	name = string.JavascriptSafe( name )
	desc = string.JavascriptSafe( desc )
	map = string.JavascriptSafe( map )
	address = string.JavascriptSafe( address )
	gm = string.JavascriptSafe( gm )
	workshopid = string.JavascriptSafe( workshopid )
	netVersion = string.JavascriptSafe( tostring( netVersion ) )
	loc = string.JavascriptSafe( loc )
	gmcat = string.JavascriptSafe( gmcat )

	pnlMainMenu:Call( string.format( [[AddServer( "%s", "%s", %i, "%s", "%s", "%s", %i, %i, %i, %s, %i, "%s", "%s", "%s", %s, "%s", "%s", "%s" , "%s" );]],
		category, id, ping, name, desc, map, players, maxplayers, botplayers, tostring( pass ), lastplayed, address, gm, workshopid,
		tostring( isAnon ), netVersion, tostring( serverlist.IsServerFavorite( address ) ), loc, gmcat ) )


end

function GetServers( category, id )

	category = string.JavascriptSafe( category )
	id = string.JavascriptSafe( id )

	ShouldStop[ category ] = false
	Servers[ category ] = {}

	local data = {
		Callback = function( ping, name, desc, map, players, maxplayers, botplayers, pass, lastplayed, address, gm, workshopid, isAnon, netVersion, luaVersion, loc, gmcat )

			if ( Servers[ category ] and Servers[ category ][ address ] ) then print( "Server Browser Error!", address, category ) return end
			Servers[ category ][ address ] = true

			local blackListMatch = IsServerBlacklisted( address, name, desc, gm, map )
			if ( blackListMatch == nil ) then

				SendServer( pnlMainMenu, category, id,
					ping, name, desc, map, players, maxplayers, botplayers, pass, lastplayed, address, gm, workshopid,
					isAnon, netVersion, luaVersion, loc, gmcat )

			else

				Msg( "Ignoring server '", name, "' @ ", address, " - ", blackListMatch, " is blacklisted\n" )

			end

			return !ShouldStop[ category ]

		end,

		CallbackFailed = function( address )

			if ( Servers[ category ] and Servers[ category ][ address ] ) then print( "Server Browser Error!", address, category ) return end
			Servers[ category ][ address ] = true

			local version = string.JavascriptSafe( tostring( VERSION ) )

			SendServer( pnlMainMenu, category, id,
				2000, language.GetPhrase("server_noresponse"):format(address), language.GetPhrase("server_gamemode_unreachable"), "no_map", 0, 2, 0, "false", 0, address, "unkn", "0",
				"true", version, tostring( serverlist.IsServerFavorite( address ) ), "", "" )

			return !ShouldStop[ category ]

		end,

		Finished = function()
			pnlMainMenu:Call( "FinishedServeres( '" .. category:JavascriptSafe() .. "' )" )
			Servers[ category ] = {}
		end,

		Type = category,
		GameDir = "garrysmod",
		AppID = 4000,
	}

	serverlist.Query( data )

end

function DoStopServers( category )
	pnlMainMenu:Call( "FinishedServeres( '" .. category:JavascriptSafe() .. "' )" )
	ShouldStop[ category ] = true
	Servers[ category ] = {}
end

function PingServer( srvAddress )

	serverlist.PingServer( srvAddress, function( ping, name, desc, map, players, maxplayers, botplayers, pass, lastplayed, address, gm, workshopid, isAnon, netVersion, luaVersion, loc, gmcat )

		if ( !name ) then return end

		name = string.JavascriptSafe( name )
		map = string.JavascriptSafe( map )
		address = string.JavascriptSafe( address )

		pnlMainMenu:Call( string.format( [[UpdateServer( "%s", %i, "%s", "%s", %i, %i, %i, %s );]],
			address, ping, name, map, players, maxplayers, botplayers, tostring( pass ) ) )

	end )

end

function FindServersAtAddress( inputStr )

	local hasPort = string.find( inputStr, ":", 0, true )

	local addresses = {}
	if ( hasPort ) then
		table.insert( addresses, inputStr )
	else
		for i = 0, 5 do
			table.insert( addresses, inputStr .. ":" .. tostring( 27015 + i ) )
			table.insert( addresses, inputStr .. ":" .. tostring( 26900 + i ) )
		end

	end

	local output = {}
	for i, addr in ipairs( addresses ) do

		serverlist.PingServer( addr, function( ping, name, desc, map, players, maxplayers, botplayers, pass, lastplayed, address, gm, ... )

			if ( !name ) then
				table.insert( output, {
					name = language.GetPhrase("server_noresponse"):format(addr),
					address = addr, ping = 2000, favorite = false,
					players = 0, maxplayers = 0, botplayers = 0,
					map = "", gamemode = ""
				} )
			else
				name = string.JavascriptSafe( name )
				map = string.JavascriptSafe( map )
				address = string.JavascriptSafe( address )
				gm = string.JavascriptSafe( gm )

				table.insert( output, {
					address = address,
					name = name,
					ping = ping,
					map = map,
					gamemode = gm,
					favorite = serverlist.IsServerFavorite( address ),
					players = players,
					botplayers = botplayers,
					maxplayers = maxplayers,
				} )
			end

			//if ( #output == #addresses ) then
				local json = util.TableToJSON( output )
				pnlMainMenu:Call( "ReceiveFoundServers(" .. json .. ")" )
			//end

		end )

	end

end

--
-- Called from JS
--
function UpdateLanguages()

	local f = file.Find( "resource/localization/*.png", "MOD" )
	local json = util.TableToJSON( f )
	pnlMainMenu:Call( "UpdateLanguages(" .. json .. ")" )

end

--
-- Called from the engine any time the language changes
--
function LanguageChanged( lang )

	if ( !IsValid( pnlMainMenu ) ) then return end

	UpdateLanguages()
	pnlMainMenu:Call( "UpdateLanguage( \"" .. lang:JavascriptSafe() .. "\" )" )

end

function UpdateGames()

	local games = engine.GetGames()
	local json = util.TableToJSON( games )

	pnlMainMenu:Call( "UpdateGames( " .. json .. ")" )

end

function UpdateSubscribedAddons()

	local subscriptions = engine.GetAddons()
	local json = util.TableToJSON( subscriptions )
	pnlMainMenu:Call( "subscriptions.Update( " .. json .. " )" )

	local UGCsubs = engine.GetUserContent()
	local jsonUGC = util.TableToJSON( UGCsubs )
	pnlMainMenu:Call( "subscriptions.UpdateUGC( " .. jsonUGC .. " )" )

end

function UpdateAddonDisabledState()
	local noaddons, noworkshop = GetAddonStatus()
	pnlMainMenu:Call( "UpdateAddonDisabledState( " .. tostring( noaddons ) .. ", " .. tostring( noworkshop ) .. " )" )
end

function MenuGetAddonData( wsid )
	steamworks.FileInfo( wsid, function( data )
		local json = util.TableToJSON( data ) or ""
		pnlMainMenu:Call( "ReceivedChildAddonInfo( " .. json .. " )" )
	end )
end

local presetCache = {}
local function EnsurePresetsLoaded()
	if ( table.IsEmpty( presetCache ) ) then
		presetCache = util.JSONToTable( LoadAddonPresets() or "", true, true ) or {}
	end
end
function CreateNewAddonPreset( json )
	EnsurePresetsLoaded()

	local data = util.JSONToTable( json )
	presetCache[ data.name ] = data

	SaveAddonPresets( util.TableToJSON( presetCache ) )
end
function ImportAddonPreset( id, json )
	EnsurePresetsLoaded()

	steamworks.FileInfo( id, function( fileInfo )

		if ( !fileInfo.children or #fileInfo.children < 1 ) then
			pnlMainMenu:Call( "OnImportPresetFailed()" )
			return
		end

		local data = util.JSONToTable( json )
		presetCache[ data.name ] = data
		presetCache[ data.name ].enabled = fileInfo.children

		SaveAddonPresets( util.TableToJSON( presetCache ) )
		ListAddonPresets()
	end )
end
function DeleteAddonPreset( name )
	EnsurePresetsLoaded()

	presetCache[ name ] = {}
	presetCache[ name ] = nil

	SaveAddonPresets( util.TableToJSON( presetCache ) )

	ListAddonPresets()
end
function ListAddonPresets()
	EnsurePresetsLoaded()

	pnlMainMenu:Call( "OnReceivePresetList(" .. util.TableToJSON( presetCache ) .. ")" )
end

-- Called when UGC subscription status changes
hook.Add( "WorkshopSubscriptionsChanged", "WorkshopSubscriptionsChanged", function( msg )

	UpdateSubscribedAddons()

end )

hook.Add( "GameContentChanged", "RefreshMainMenu", function()

	if ( !IsValid( pnlMainMenu ) ) then return end

	pnlMainMenu:RefreshContent()

	UpdateGames()
	UpdateServerSettings()
	UpdateSubscribedAddons()

end )

hook.Add( "LoadGModSaveFailed", "LoadGModSaveFailed", function( str, wsid )
	local button2 = nil
	if ( wsid and wsid:len() > 0 and wsid != "0" ) then button2 = "Open map on Steam Workshop" end

	Derma_Query( str, "Failed to load save!", "OK", nil, button2, function() steamworks.ViewFile( wsid ) end )
	gui.ActivateGameUI()
end )

--
-- Initialize
--
timer.Simple( 0, function()

	pnlMainMenu = vgui.Create( "MainMenuPanel" )
	pnlMainMenu:Call( "UpdateVersion( '" .. VERSIONSTR:JavascriptSafe() .. "', '" .. NETVERSIONSTR:JavascriptSafe() .. "', '" .. BRANCH:JavascriptSafe() .. "' )" )

	local lang = GetConVarString( "gmod_language" )
	LanguageChanged( lang )

	hook.Run( "GameContentChanged" )

	if ( !file.Exists( "html/menu.html", "MOD" ) ) then
		OnMenuFailedToLoad()
	end

	timer.Simple( 5, function()
		if ( !pnlMainMenu.menuLoaded ) then OnMenuFailedToLoad() end
	end )
end )
