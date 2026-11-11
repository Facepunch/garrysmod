
local PANEL = {}

function PANEL:Init()

	self:SetTall( 1 )

end

function PANEL:Paint( w, h )

	derma.SkinHook( "Paint", "MenuSpacer", self, w, h )

end

function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local wrapper = vgui.Create( "DSizeToContents" )
	wrapper:SetSizeX( false )
	wrapper:SetWide( 256 )

	local label1 = vgui.Create( "DLabel", wrapper )
	label1:SetText( "Example Text" )
	label1:Dock( TOP )

	local spacer1 = vgui.Create( ClassName, wrapper )
	spacer1:Dock( TOP )
	spacer1:DockMargin( 0, 4, 0, 4 )

	local buttonLabel = vgui.Create( "DLabel", wrapper )
	buttonLabel:SetText( "Example Button Description Text" )
	buttonLabel:Dock( TOP )

	local button = vgui.Create( "DButton", wrapper )
	button:SetText( "Example Button" )
	button:Dock( TOP )

	local spacer2 = vgui.Create( ClassName, wrapper )
	spacer2:Dock( TOP )
	spacer2:DockMargin( 0, 4, 0, 4 )

	local text = vgui.Create( "DTextEntry", wrapper )
	text:SetText( "Example Edit" )
	text:Dock( TOP )

	PropertySheet:AddSheet( ClassName, wrapper, nil, true, true )

end

derma.DefineControl( "DVerticalSpacer", "", PANEL, "DPanel" )
