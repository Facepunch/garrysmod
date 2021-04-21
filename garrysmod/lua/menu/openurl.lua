
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

local PANEL = {}

PANEL.Base = "DFrame"

function PANEL:Init()

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

	self:SetSize( 680, 104 )
	self:Center()
	self:MakePopup()
	self:DoModal()

	hook.Add( "Think", self, self.AlwaysThink )

	if ( !IsInGame() ) then self.Disconnect:SetVisible( false ) end

end

function PANEL:AlwaysThink()
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

	self:DoYesAction()
	self:Remove()
	gui.HideGameUI()
end

function PANEL:DoYesAction()
	gui.OpenURL( self.URL:GetText() )
end

local PanelInst = nil
local function OpenConfirmationDialog( address, confirm_type )

	if ( IsValid( PanelInst ) && PanelInst:GetURL() == address ) then return end
	if ( !IsValid( PanelInst ) ) then PanelInst = vgui.CreateFromTable( PANEL ) end

	PanelInst:SetURL( address )

	timer.Simple( 0, function()
		if ( !gui.IsGameUIVisible() ) then gui.ActivateGameUI() end
	end )

end

-- Called from the engine
function RequestOpenURL( url )

	OpenConfirmationDialog( url, "openurl" )

end
