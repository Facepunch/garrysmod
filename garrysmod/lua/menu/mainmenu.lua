
include( 'background.lua' )

pnlMainMenu = nil

local PANEL = {}

function PANEL:Init()

	self:Dock( FILL )
	self:SetKeyboardInputEnabled( true )
	self:SetMouseInputEnabled( true )

	self.HTML = vgui.Create( "DHTML", self )

	JS_Language( self.HTML )
	JS_Utility( self.HTML )
	JS_Workshop( self.HTML )

	self.HTML:Dock( FILL )
	self.HTML:OpenURL( "asset://garrysmod/html/menu.html" )
	self.HTML:SetKeyboardInputEnabled( true )
	self.HTML:SetMouseInputEnabled( true )
	self.HTML:SetAllowLua( true )
	self.HTML:RequestFocus()

	ws_save.HTML = self.HTML
	addon.HTML = self.HTML
	demo.HTML = self.HTML

	self:MakePopup()
	self:SetPopupStayAtBack( true )
	--self:MoveToBack() --Breaks Awesomium input 

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
			self.HTML:QueueJavascript( "SetInGame( true )" )
		
		else 
		
			self.HTML:QueueJavascript( "SetInGame( false )" )
		
		end
		
	end

end

function PANEL:RefreshContent()

	self:RefreshGamemodes()
	self:RefreshAddons()

end

function PANEL:RefreshGamemodes()

	local json = util.TableToJSON( engine.GetGamemodes() )

	self.HTML:QueueJavascript( "UpdateGamemodes( " .. json .. " )" )
	self:UpdateBackgroundImages()
	self.HTML:QueueJavascript( "UpdateCurrentGamemode( '" .. engine.ActiveGamemode() .. "' )" )

end

function PANEL:RefreshAddons()

	-- TODO

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

function UpdateSteamName( id, time )

	if ( !id ) then return end

	if ( !time ) then time = 0.2 end

	local name = steamworks.GetPlayerName( id )
	if ( name != "" && name != "[unknown]" ) then

		pnlMainMenu:Call( "SteamName( \"" .. id .. "\", \"" .. name .. "\" )" )
		return

	end

	steamworks.RequestPlayerInfo( id )
	timer.Simple( time, function() UpdateSteamName( id, time + 0.2 ) end )

end

--
-- Called from JS when starting a new game
--
function UpdateMapList()

	local MapList = GetMapList()
	if ( !MapList ) then return end

	local json = util.TableToJSON( MapList )
	if ( !json ) then return end

	pnlMainMenu:Call( "UpdateMaps(" .. json .. ")" )

end

--
-- Called from JS when starting a new game
--
function UpdateServerSettings()

	local array = {
		hostname = GetConVarString( "hostname" ),
		sv_lan = GetConVarString( "sv_lan" )
	}

	local settings_file = file.Read( "gamemodes/" .. engine.ActiveGamemode() .. "/" .. engine.ActiveGamemode() .. ".txt", true )
	
	if ( settings_file ) then

		local Settings = util.KeyValuesToTable( settings_file )

		if ( Settings.settings ) then

			array.settings = Settings.settings

			for k, v in pairs( array.settings ) do
				v.Value = GetConVarString( v.name )
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
		pnlMainMenu:Call( "SetPlayerList( '" .. serverip .. "', " .. json .. ")" )

	end )

end

local Servers = {}
local ShouldStop = {}

function GetServers( type, id )

	ShouldStop[ type ] = false

	local data = {
		Callback = function( ping , name, desc, map, players, maxplayers, botplayers, pass, lastplayed, address, gamemode, workshopid )

			name = string.JavascriptSafe( name )
			desc = string.JavascriptSafe( desc )
			map = string.JavascriptSafe( map )
			address = string.JavascriptSafe( address )
			gamemode = string.JavascriptSafe( gamemode )
			workshopid = string.JavascriptSafe( workshopid )
			
			if ( pass ) then pass = "true" else pass = "false" end

			pnlMainMenu:Call( "AddServer( '"..type.."', '"..id.."', "..ping..", \""..name.."\", \""..desc.."\", \""..map.."\", "..players..", "..maxplayers..", "..botplayers..", "..pass..", "..lastplayed..", \""..address.."\", \""..gamemode.."\", \""..workshopid.."\" )" )

			return !ShouldStop[ type ]
			
		end,
		
		Finished = function()
			pnlMainMenu:Call( "FinishedServeres( '" .. type .. "' )" )
		end,

		Type = type,
		GameDir = 'garrysmod',
		AppID = 4000,
	}

	serverlist.Query( data )

end

function DoStopServers( type )
	pnlMainMenu:Call( "FinishedServeres( '" .. type .. "' )" )
	ShouldStop[ type ] = true
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

end

hook.Add( "GameContentChanged", "RefreshMainMenu", function()

	if ( !IsValid( pnlMainMenu ) ) then return end

	pnlMainMenu:RefreshContent()

	UpdateGames()
	UpdateServerSettings()
	UpdateSubscribedAddons()

	-- We update the maps with a delay because another hook updates the maps on content changed
	-- so we really only want to update this after that.
	timer.Simple( 0.5, function() UpdateMapList() end )

end )

--
-- Initialize
--
timer.Simple( 0, function()

	pnlMainMenu = vgui.Create( "MainMenuPanel" )
	pnlMainMenu:Call( "UpdateVersion( '" .. VERSIONSTR .. "', '" .. BRANCH .. "' )" )

	local language = GetConVarString( "gmod_language" )
	LanguageChanged( language )

	hook.Run( "GameContentChanged" )

end )
