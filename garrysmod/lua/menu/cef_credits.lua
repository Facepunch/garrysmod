
local PANEL = {}

PANEL.Base = "DFrame"

function PANEL:Init()
	self.HTML = vgui.Create( "Chromium", self )

	-- Trying to open credits on a non-cef build?
	if ( !self.HTML ) then
		self:Remove()
		return
	end

	self.HTML:Dock( FILL )
	self.HTML:OpenURL( "chrome://credits/" )
	self.HTML:SetOpenLinksExternally( true )

	self:SetTitle( "Chromium Embedded Framework Credits" )
	self:SetPos( 16, 16 )
	self:SetSize( 720, 400 )
	self:SetSizable( true )
	self:MakePopup()
end

concommand.Add( "cef_credits", function()
	vgui.CreateFromTable( PANEL )
end )

local PANEL = {}

PANEL.Base = "DFrame"

function PANEL:Init()
	self.HTML = vgui.Create( "HTML", self )

	-- Trying to open credits on a non-cef build?
	if ( !self.HTML ) then
		self:Remove()
		return
	end

	self.HTML:Dock( FILL )
	self.HTML:OpenURL( "https://gmod.facepunch.com/legal/tos" )
	self.HTML:SetOpenLinksExternally( true )

	self:SetTitle( "Garry's Mod Terms of Service" )
	self:SetSize( 720, ScrH() * 0.75 )
	self:SetSizable( true )
	self:Center()
	self:MakePopup()
end

concommand.Add( "gmod_tos", function()
	vgui.CreateFromTable( PANEL )
end )

local PANEL = {}

PANEL.Base = "DFrame"

function PANEL:Init()
	self.HTML = vgui.Create( "HTML", self )

	-- Trying to open credits on a non-cef build?
	if ( !self.HTML ) then
		self:Remove()
		return
	end

	self.HTML:Dock( FILL )
	self.HTML:OpenURL( "https://gmod.facepunch.com/legal/privacy" )
	self.HTML:SetOpenLinksExternally( true )

	self:SetTitle( "Garry's Mod Privacy Policy" )
	self:SetSize( 720, ScrH() * 0.75 )
	self:SetSizable( true )
	self:Center()
	self:MakePopup()
end

concommand.Add( "gmod_privacy", function()
	vgui.CreateFromTable( PANEL )
end )