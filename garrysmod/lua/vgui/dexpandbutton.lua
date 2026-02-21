
local PANEL = {}

AccessorFunc( PANEL, "m_bExpanded", "Expanded", FORCE_BOOL )
Derma_Hook( PANEL, "Paint", "Paint", "ExpandButton" )

function PANEL:Init()

	self:SetSize( 15, 15 )
	self:SetText( "" )

end

-- No example for this control
function PANEL:GenerateExample( class, tabs, w, h )
end

derma.DefineControl( "DExpandButton", "", PANEL, "DButton" )
