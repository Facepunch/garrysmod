include( "background.lua" )
include( "cef_credits.lua" )
include( "openurl.lua" )
include( "ugcpublish.lua" )

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
			self.HTML:QueueJavascript( "SetInGame( true )" )

		else

			self.HTML:QueueJavascript( "SetInGame( false )" )

		end
	end

	if ( self.CanAddServerToFavorites != CanAddServerToFavorites() ) then

		self.CanAddServerToFavorites = CanAddServerToFavorites()

		if ( self.CanAddServerToFavorites ) then

			self.HTML:QueueJavascript( "SetShowFavButton( true )" )

		else

			self.HTML:QueueJavascript( "SetShowFavButton( false )" )

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
	self.HTML:QueueJavascript( "UpdateCurrentGamemode( '" .. engine.ActiveGamemode():JavascriptSafe() .. "' )" )

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
		sv_lan = GetConVarString( "sv_lan" ),
		p2p_enabled = GetConVarString( "p2p_enabled" )
	}

	local settings_file = file.Read( "gamemodes/" .. engine.ActiveGamemode() .. "/" .. engine.ActiveGamemode() .. ".txt", true )

	if ( settings_file ) then

		local Settings = util.KeyValuesToTable( settings_file )

		if ( istable( Settings.settings ) ) then

			array.settings = Settings.settings

			for k, v in pairs( array.settings ) do
				v.Value = GetConVarString( v.name )
				v.Singleplayer = v.singleplayer && true || false
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
		if ( v:StartWith( "map:" ) ) then
			table.insert( BlackList.Maps, v:sub( 5 ) )
		elseif ( v:StartWith( "desc:" ) ) then
			table.insert( BlackList.Descripts, v:sub( 6 ) )
		elseif ( v:StartWith( "host:" ) ) then
			table.insert( BlackList.Hostnames, v:sub( 6 ) )
		elseif ( v:StartWith( "gm:" ) ) then
			table.insert( BlackList.Gamemodes, v:sub( 4 ) )
		else
			table.insert( BlackList.Addresses, v )
		end
	end
end )

function LoadNewsList()
	if ( !pnlMainMenu ) then return end

	local json = util.TableToJSON( NewsList )
	pnlMainMenu:Call( "UpdateNewsList(" .. json .. ", " .. cookie.GetString( "hide_newslist", "false" ) .. " )" )
end

function SaveHideNews( bHide )
	cookie.Set( "hide_newslist", tostring( bHide ) )
end

local function IsServerBlacklisted( address, hostname, description, gm, map )
	local addressNoPort = address:match( "[^:]*" )

	for k, v in ipairs( BlackList.Addresses ) do
		if ( address == v || addressNoPort == v ) then
			return v
		end

		if ( v:EndsWith( "*" ) && address:sub( 1, v:len() - 1 ) == v:sub( 1, v:len() - 1 ) ) then return v end
	end

	for k, v in ipairs( BlackList.Hostnames ) do
		if string.match( hostname, v ) then
			return v
		end
	end

	for k, v in ipairs( BlackList.Descripts ) do
		if string.match( description, v ) then
			return v
		end
	end

	for k, v in ipairs( BlackList.Gamemodes ) do
		if string.match( gm, v ) then
			return v
		end
	end

	for k, v in ipairs( BlackList.Maps ) do
		if string.match( map, v ) then
			return v
		end
	end

	return nil
end

local Servers = {}
local ShouldStop = {}

function GetServers( category, id )

	category = string.JavascriptSafe( category )
	id = string.JavascriptSafe( id )

	ShouldStop[ category ] = false
	Servers[ category ] = {}

	local data = {
		Callback = function( ping, name, desc, map, players, maxplayers, botplayers, pass, lastplayed, address, gm, workshopid, isAnon, steamID64 )

			if Servers[ category ] && Servers[ category ][ address ] then print( "Server Browser Error!", address, category ) return end
			Servers[ category ][ address ] = true

			local blackListMatch = IsServerBlacklisted( address, name, desc, gm, map )
			if ( blackListMatch == nil ) then

				name = string.JavascriptSafe( name )
				desc = string.JavascriptSafe( desc )
				map = string.JavascriptSafe( map )
				address = string.JavascriptSafe( address )
				gm = string.JavascriptSafe( gm )
				workshopid = string.JavascriptSafe( workshopid )

				pnlMainMenu:Call( string.format( 'AddServer( "%s", "%s", %i, "%s", "%s", "%s", %i, %i, %i, %s, %i, "%s", "%s", "%s", %s, "%s" );',
					category, id, ping, name, desc, map, players, maxplayers, botplayers, tostring( pass ), lastplayed, address, gm, workshopid, tostring( isAnon ), steamID64 ) )

			else

				Msg( "Ignoring server '", name, "' @ ", address, " - ", blackListMatch, " is blacklisted\n" )

			end

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
function CreateNewAddonPreset( data )
	if ( table.IsEmpty( presetCache ) ) then presetCache = util.JSONToTable( LoadAddonPresets() or "" ) or {} end

	local data = util.JSONToTable( data )
	presetCache[ data.name ] = data

	SaveAddonPresets( util.TableToJSON( presetCache ) )
end
function DeleteAddonPreset( name )
	if ( table.IsEmpty( presetCache ) ) then presetCache = util.JSONToTable( LoadAddonPresets() or "" ) or {} end

	presetCache[ name ] = {}
	presetCache[ name ] = nil

	SaveAddonPresets( util.TableToJSON( presetCache ) )

	ListAddonPresets()
end
function ListAddonPresets()
	if ( table.IsEmpty( presetCache ) ) then presetCache = util.JSONToTable( LoadAddonPresets() or "" ) or {} end

	pnlMainMenu:Call( "OnReceivePresetList(" .. util.TableToJSON( presetCache ) .. ")" )
end

--
-- Called from JS
--
function ImportPreset(presetData)
	if ( table.IsEmpty( presetCache ) ) then presetCache = util.JSONToTable( LoadAddonPresets() or "" ) or {} end

	-- Import: Base64 encoded & compressed JSON > compressed JSON > JSON > Lua table
	-- Export: Lua table > JSON > compressed JSON > Base64 encoded & compressed JSON
	local data = util.JSONToTable( util.Decompress( util.Base64Decode(presetData) or "" ) or "" )
	if ( not data or not data.name or not data.enabled or not data.disabled or not data.newAction ) then print( "Got invalid data, aborting preset import..." ) return end

	presetCache[ data.name ] = data

	SaveAddonPresets( util.TableToJSON( presetCache ) )
end

--
-- Called from JS
--
function ImportPresetFromJSON( presetJSON )
	if ( table.IsEmpty( presetCache ) ) then presetCache = util.JSONToTable( LoadAddonPresets() or "" ) or {} end

	local data = util.JSONToTable( presetJSON )
	if ( not data or not data.name or not data.enabled or not data.disabled or not data.newAction ) then print( "Got invalid JSON data, aborting preset import..." ) return end

	presetCache[ data.name ] = data

	SaveAddonPresets( util.TableToJSON( presetCache ) )
end

-- Flag so that multiple imports don't get started and step on each other
local urlImportInProgress = false
-- Table used for HTTP function
local importPresetURLOptions = {
	method = "GET",
	success = function( code, body, headers )
		urlImportInProgress = false
		ImportPreset( body or "{}" )
	end,
	failed = function( reason )
		urlImportInProgress = false
		print( "Failed to retrieve addon preset for reason: " .. reason )
	end
}
--
-- Called from JS
--
function ImportPresetFromURL( presetURL )
	if ( urlImportInProgress ) then print( "URL preset import already in progress, aborting..." ) return end
	if ( table.IsEmpty( presetCache ) ) then presetCache = util.JSONToTable( LoadAddonPresets() or "" ) or {} end

	urlImportInProgress = true
	importPresetURLOptions.url = presetURL
	HTTP(importPresetURLOptions)
end

-- Locals for storing collection info and data
local collectionImportInProgress, currentPreset, collectionQueue, collectionHistory = false, nil, {}, {}
-- Table used for HTTP function
local importCollectionURLOptions = {
	url = "https://api.steampowered.com/ISteamRemoteStorage/GetCollectionDetails/v1/",
	method = "POST",
	failed = function( reason )
		collectionImportInProgress, currentPreset, collectionQueue, collectionHistory = false, nil, {}, {}
		print( "Failed to retrieve collection info for reason: " .. reason )
	end
}
-- Add this to table after so we can access importCollectionURLOptions in a recursive sense
importCollectionURLOptions.success = function( code, body, headers )
	local data, childCollections = util.JSONToTable( body ), {}

	-- Loop over each collection retrieved
	for i=1, #data.response.collectiondetails do
		local collection = data.response.collectiondetails[ i ]

		-- Loop over each item in the collection
		if collection.children then
			for i2=1, #collection.children do
				local item = collection.children[ i2 ]
				item.filetype = tonumber( item.filetype )

				-- Workshop item
				if ( item.filetype == 0 ) then
					currentPreset.enabled[ #currentPreset.enabled+1 ] = item.publishedfileid
				-- Workshop collection
				elseif ( item.filetype == 2 and not collectionHistory[ item.publishedfileid ] ) then
					table.insert( childCollections, item.publishedfileid )
					collectionHistory[ item.publishedfileid ] = true
				end
			end
		end

		collectionQueue[ collection.publishedfileid ] = nil
	end

	-- Add any child collections
	if ( #childCollections > 0 ) then
		local parameters = {
			collectioncount = tostring( #childCollections )
		}
		for i=1, #childCollections do
			parameters[ string.format( "publishedfileids[%d]", i-1 ) ] = childCollections[ i ]
			collectionQueue[ childCollections[ i ] ] = true
		end
		importCollectionURLOptions.parameters = parameters

		HTTP(importCollectionURLOptions)
	-- Check if all collections have been processed
	elseif ( table.IsEmpty( collectionQueue ) ) then
		if ( #currentPreset.enabled > 0 ) then
			local addonList = {}
			for i=1, #currentPreset.enabled do
				if ( addonList[ currentPreset.enabled[ i ] ] ) then
					table.remove( currentPreset.enabled, i )
					i = i-1
				else
					addonList[ currentPreset.enabled[ i ] ] = true
				end
			end

			presetCache[ currentPreset.name ] = currentPreset

			SaveAddonPresets( util.TableToJSON( presetCache ) )
		end

		collectionImportInProgress, currentPreset, collectionHistory = false, nil, {}
	end
end

--
-- Called from JS
--
function ImportPresetFromCollection( collections )
	if ( collectionImportInProgress ) then print( "Collection import already in progress, aborting..." ) return end
	if ( table.IsEmpty( presetCache ) ) then presetCache = util.JSONToTable( LoadAddonPresets() or "" ) or {} end

	-- Filter for valid collection IDs (numbers)
	local collectionIDs = string.Explode( " ", collections )
	for i=1, #collectionIDs do
		if ( not tonumber( collectionIDs[ i ] ) ) then
			table.remove( collectionIDs, i )
			i = i-1
		end
	end

	if ( #collectionIDs == 0 ) then print( "Didn't get any collection IDs, aborting..." ) return end

	collectionImportInProgress = true

	local parameters = {
		collectioncount = tostring( #collectionIDs )
	}
	for i=1, #collectionIDs do
		parameters[ string.format( "publishedfileids[%d]", i-1 ) ] = collectionIDs[ i ]
		collectionQueue[ collectionIDs[ i ] ] = true
		collectionHistory[ collectionIDs[ i ] ] = true
	end
	importCollectionURLOptions.parameters = parameters

	-- Setup preset table
	currentPreset = {
		name = string.format( "Collection Preset: %s", collections ),
		newAction = "disable",
		enabled = {},
		disabled = {}
	}

	HTTP(importCollectionURLOptions)
end

--
-- Called from JS
--
function ExportPreset( name )
	if ( table.IsEmpty( presetCache ) ) then presetCache = util.JSONToTable( LoadAddonPresets() or "" ) or {} end

	-- Export: Lua table > JSON > compressed JSON > Base64 encoded & compressed JSON
	-- Import: Base64 encoded & compressed JSON > compressed JSON > JSON > Lua table
	local data = util.Base64Encode( util.Compress( util.TableToJSON( presetCache[ name ] or {} ) ) )
	data = string.Replace(string.Replace(data, "\n", ""), "\r", "")
	SetClipboardText(data)
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

	-- We update the maps with a delay because another hook updates the maps on content changed
	-- so we really only want to update this after that.
	timer.Simple( 0.5, function() UpdateMapList() end )

end )

hook.Add( "LoadGModSaveFailed", "LoadGModSaveFailed", function( str )
	Derma_Message( str, "Failed to load save!", "OK" )
end )

--
-- Initialize
--
timer.Simple( 0, function()

	pnlMainMenu = vgui.Create( "MainMenuPanel" )
	pnlMainMenu:Call( "UpdateVersion( '" .. VERSIONSTR:JavascriptSafe() .. "', '" .. BRANCH:JavascriptSafe() .. "' )" )

	local language = GetConVarString( "gmod_language" )
	LanguageChanged( language )

	hook.Run( "GameContentChanged" )

end )
