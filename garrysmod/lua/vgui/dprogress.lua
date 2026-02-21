
local PANEL = {}

AccessorFunc( PANEL, "m_fFraction", "Fraction" )

Derma_Hook( PANEL, "Paint", "Paint", "Progress" )

function PANEL:Init()

	self:SetMouseInputEnabled( false )
	self:SetFraction( 0 )

end

function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local ctrl = vgui.Create( ClassName )
	ctrl:SetFraction( 0.6 )
	ctrl:SetSize( 300, 20 )

	PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )

end

derma.DefineControl( "DProgress", "", PANEL, "Panel" )
