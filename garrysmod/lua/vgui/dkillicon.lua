
local PANEL = {}

AccessorFunc( PANEL, "m_Name", "Name" )

function PANEL:Init()

	self.m_Name = ""
	self.m_fOffset = 0
	self:NoClipping( true )

end

function PANEL:SizeToContents()

	local w, h = killicon.GetSize( self.m_Name )
	self.m_fOffset = h * 0.1
	self:SetSize( w, 5 )

end

function PANEL:Paint()

	killicon.Draw( self:GetWide() * 0.5, self.m_fOffset, self.m_Name, 255 )

end

derma.DefineControl( "DKillIcon", "A kill icon", PANEL, "Panel" )
