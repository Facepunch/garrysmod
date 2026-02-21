
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

concommand.Add( "gmod_tos", function()
	gui.OpenURL( "https://facepunch.com/legal/tos" )
end )

concommand.Add( "gmod_privacy", function()
	gui.OpenURL( "https://facepunch.com/legal/privacy" )
end )

concommand.Add( "gmod_modding", function()
	gui.OpenURL( "https://facepunch.com/legal/modding" )
end )

concommand.Add( "gmod_servers", function()
	gui.OpenURL( "https://wiki.facepunch.com/gmod/server_operator_rules" )
end )
