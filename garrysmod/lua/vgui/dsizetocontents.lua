
local PANEL = {}
AccessorFunc( PANEL, "m_bSizeX", "SizeX", FORCE_BOOL )
AccessorFunc( PANEL, "m_bSizeY", "SizeY", FORCE_BOOL )

function PANEL:Init()

	self:SetMouseInputEnabled( true )

	self:SetSizeX( true )
	self:SetSizeY( true )

end

function PANEL:PerformLayout()

	self:SizeToChildren( self.m_bSizeX, self.m_bSizeY )

end

derma.DefineControl( "DSizeToContents", "", PANEL, "Panel" )
