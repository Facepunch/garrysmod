--=============================================================================--
--  ___  ___   _   _   _    __   _   ___ ___ __ __
-- |_ _|| __| / \ | \_/ |  / _| / \ | o \ o \\ V /
--  | | | _| | o || \_/ | ( |_n| o ||   /   / \ / 
--  |_| |___||_n_||_| |_|  \__/|_n_||_|\\_|\\ |_|  2010
--										 
--=============================================================================--

g_ServerName	= ""
g_MapName		= ""
g_ServerURL		= ""
g_MaxPlayers	= ""
g_SteamID		= ""

local PANEL = {}

--[[---------------------------------------------------------

-----------------------------------------------------------]]
function PANEL:Init()

	self:SetSize( ScrW(), ScrH() )

end


function PANEL:ShowURL( url, force )

	if ( string.len( url ) < 5 ) then
		return;
	end

	if ( IsValid( self.HTML ) ) then 
		if ( !force ) then return end
		self.HTML:Remove() 
	end

	self:SetSize( ScrW(), ScrH() );

	self.HTML = vgui.Create( "DHTML", self )
	self.HTML:SetSize( ScrW(), ScrH() );
	self.HTML:Dock( FILL )
	self.HTML:OpenURL( url )
		
	self:InvalidateLayout()
	
	self.LoadedURL = url

end

function PANEL:PerformLayout()

	self:SetSize( ScrW(), ScrH() )
	
end


function PANEL:Paint()

	surface.SetDrawColor( 30, 30, 30, 255 )
	surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )

	if ( self.JavascriptRun && IsValid( self.HTML ) && !self.HTML:IsLoading() ) then

		-- MsgN( self.JavascriptRun )
		self:RunJavascript( self.JavascriptRun )
		self.JavascriptRun = nil

	end
	
end


--[[---------------------------------------------------------

-----------------------------------------------------------]]
function PANEL:RunJavascript( str )

	if ( !IsValid( self.HTML ) ) then return end
	if ( self.HTML:IsLoading() ) then return end

	self.HTML:RunJavascript( str );
	
end


--[[---------------------------------------------------------

-----------------------------------------------------------]]
function PANEL:OnActivate()

	g_ServerName	= ""
	g_MapName		= ""
	g_ServerURL		= ""
	g_MaxPlayers	= ""
	g_SteamID		= ""

	self:ShowURL( GetDefaultLoadingHTML() )

end

--[[---------------------------------------------------------

-----------------------------------------------------------]]
function PANEL:OnDeactivate()

	if ( IsValid( self.HTML ) ) then self.HTML:Remove() end
	self.LoadedURL = nil
	
end

local PanelType_Loading = vgui.RegisterTable( PANEL, "EditablePanel" )

local pnlLoading = nil

function GetLoadPanel()

	if ( !IsValid( pnlLoading ) ) then
		pnlLoading = vgui.CreateFromTable( PanelType_Loading )
	end

	return pnlLoading
	
end

function UpdateLoadPanel( strJavascript )
	
	if ( !pnlLoading ) then return end

	pnlLoading:RunJavascript( strJavascript )

end


function GameDetails( servername, serverurl, mapname, maxplayers, steamid, gamemode )

	if ( engine.IsPlayingDemo() ) then return end

	g_ServerName	= servername
	g_MapName		= mapname
	g_ServerURL		= serverurl
	g_MaxPlayers	= maxplayers
	g_SteamID		= steamid
	g_GameMode		= gamemode

	MsgN( servername )
	MsgN( serverurl )
	MsgN( gamemode )
	MsgN( mapname )
	MsgN( maxplayers )
	MsgN( steamid )
	
	serverurl = serverurl:Replace( "%s", steamid )
	serverurl = serverurl:Replace( "%m", mapname )

	if ( maxplayers > 1 ) then 
		pnlLoading:ShowURL( serverurl, true ) 
	end

	pnlLoading.JavascriptRun = string.format( "GameDetails( \"%s\", \"%s\", \"%s\", %i, \"%s\", \"%s\" );", servername:JavascriptSafe(), serverurl:JavascriptSafe(), mapname:JavascriptSafe(), maxplayers, steamid:JavascriptSafe(), g_GameMode:JavascriptSafe() )

end