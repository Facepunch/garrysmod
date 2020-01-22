local PANEL = {}
local PanelInst = nil

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

	self.Buttons = vgui.Create( "Panel", self )
	self.Buttons:Dock( BOTTOM )

	self.Nope = vgui.Create( "DButton", self.Buttons )
	self.Nope:SetText( "#openurl.nope" )
	self.Nope.DoClick = function() self:DoNope() end
	self.Nope:Dock( RIGHT )

	self.Yes = vgui.Create( "DButton", self.Buttons )
	self.Yes:SetText( "#openurl.yes" )
	self.Yes.DoClick = function() self:DoYes() end
	self.Yes:DockMargin( 0, 0, 8, 0 )
	self.Yes:Dock( RIGHT )

	self.StartTime = SysTime()

	self:SetSize( 680, 104 )
	self:Center()
	self:MakePopup()

	hook.Add( "Think", self, self.AlwaysThink )
end

function PANEL:AlwaysThink()
	if ( self.StartTime + 0.75 > SysTime() ) then
		return
	end

	if not gui.IsGameUIVisible() then
		self:Remove()
	end
end

function PANEL:SetURL( url )
	self.URL:SetText( url )
end

function PANEL:DoNope()
	self:Remove()
	gui.HideGameUI()
end

function PANEL:DoYes()
	if ( self.StartTime + 0.75 > SysTime() ) then
		return
	end

	gui.OpenURL( self.URL:GetText() )
	self:Remove()
	gui.HideGameUI()
end

function RequestOpenURL( url )
	if IsValid( PanelInst ) then
		PanelInst:Remove()
	end

	PanelInst = vgui.CreateFromTable( PANEL )
	PanelInst:SetURL( url )

	timer.Simple( 0, function()
		gui.ActivateGameUI()
	end )
end