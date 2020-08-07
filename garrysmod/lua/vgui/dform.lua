
local PANEL = {}

DEFINE_BASECLASS( "DCollapsibleCategory" )

AccessorFunc( PANEL, "m_bSizeToContents",	"AutoSize", FORCE_BOOL)
AccessorFunc( PANEL, "m_iSpacing",			"Spacing" )
AccessorFunc( PANEL, "m_Padding",			"Padding" )

function PANEL:Init()

	self.Items = {}

	self:SetSpacing( 4 )
	self:SetPadding( 10 )

	self:SetPaintBackground( true )

	self:SetMouseInputEnabled( true )
	self:SetKeyboardInputEnabled( true )

end

function PANEL:SetName( name )

	self:SetLabel( name )

end

function PANEL:Clear()

	for k, v in pairs( self.Items ) do

		if ( IsValid(v) ) then v:Remove() end

	end

	self.Items = {}

end

function PANEL:AddItem( left, right )

	self:InvalidateLayout()

	local Panel = vgui.Create( "DSizeToContents", self )
	--Panel.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "CategoryButton", panel, w, h ) end
	Panel:SetSizeX( false )
	Panel:Dock( TOP )
	Panel:DockPadding( 10, 10, 10, 0 )
	Panel:InvalidateLayout()

	if ( IsValid( right ) ) then

		left:SetParent( Panel )
		left:Dock( LEFT )
		left:InvalidateLayout( true )
		left:SetSize( 100, 20 )

		right:SetParent( Panel )
		right:SetPos( 110, 0 )
		right:InvalidateLayout( true )

	elseif ( IsValid( left ) ) then

		left:SetParent( Panel )
		left:Dock( TOP )

	end

	table.insert( self.Items, Panel )

end

function PANEL:TextEntry( strLabel, strConVar )

	local left = vgui.Create( "DLabel", self )
	left:SetText( strLabel )
	left:SetDark( true )

	local right = vgui.Create( "DTextEntry", self )
	right:SetConVar( strConVar )
	right:Dock( TOP )

	self:AddItem( left, right )

	return right, left

end

function PANEL:PropSelect( strLab, strVar, arList )

	local props = vgui.Create( "PropSelect", self )

	props:ControlValues( { convar = strVar, label = strLab } )

	for ID = 1, #arList do
		local dat = arList[ID]
		local mdl = tostring( dat.model or dat[1] or "")
		local tip = tostring( dat.tooltip or dat[2] or mdl )

		props:AddModel(mdl):SetToolTip(tip)
	end

	self:AddPanel(props)

	return props
end

function PANEL:ControlPresets( strDir, cvList )

	local preset = vgui.Create("ControlPresets", self )

	preset:SetPreset( strDir )
	preset:AddOption( "Default", cvList )
	for key, val in pairs( table.GetKeys( cvList ) ) do
		preset:AddConVar(val)
	end

	self:AddItem( preset )

	return preset
end

function PANEL:NumpadControl( strLab1, strVar1, strLab2, strVar2 )

	if ( strLab1 == nil or strVar1 == nil ) then return nil end

	local numpad = vgui.Create( "CtrlNumPad", self )

	numpad:SetLabel1( tostring( strLabel1 or "" ) )
	numpad:SetConVar1( tostring( strConVar1 or "" ) )

	if ( strLab2 != nil and strVar2 != nil) then
		numpad:SetLabel2( tostring( strLab2 or "" ) )
		numpad:SetConVar2( tostring( strVar2 or "" ) )
	end

	self:AddPanel(numpad)

	return numpad
end

function PANEL:ComboBox( strLabel, strConVar )

	local left = vgui.Create( "DLabel", self )
	left:SetText( strLabel )
	left:SetDark( true )

	local right = vgui.Create( "DComboBox", self )
	right:SetConVar( strConVar )
	right:Dock( FILL )
	function right:OnSelect( index, value, data )
		if ( !self.m_strConVar ) then return end
		RunConsoleCommand( self.m_strConVar, tostring( data or value ) )
	end

	self:AddItem( left, right )

	return right, left

end

function PANEL:NumberWang( strLabel, strConVar, numMin, numMax, numDecimals )

	local left = vgui.Create( "DLabel", self )
	left:SetText( strLabel )
	left:SetDark( true )

	local right = vgui.Create( "DNumberWang", self )
	right:SetMinMax( numMin, numMax )

	if ( numDecimals != nil ) then right:SetDecimals( numDecimals ) end

	right:SetConVar( strConVar )
	right:SizeToContents()

	self:AddItem( left, right )

	return right, left

end

function PANEL:NumSlider( strLabel, strConVar, numMin, numMax, numDecimals )

	local left = vgui.Create( "DNumSlider", self )
	left:SetText( strLabel )
	left:SetMinMax( numMin, numMax )
	left:SetDark( true )

	if ( numDecimals != nil ) then left:SetDecimals( numDecimals ) end

	left:SetConVar( strConVar )
	left:SizeToContents()

	self:AddItem( left, nil )

	return left

end

function PANEL:CheckBox( strLabel, strConVar )

	local left = vgui.Create( "DCheckBoxLabel", self )
	left:SetText( strLabel )
	left:SetDark( true )
	left:SetConVar( strConVar )

	self:AddItem( left, nil )

	return left

end

function PANEL:Help( strHelp )

	local left = vgui.Create( "DLabel", self )

	left:SetDark( true )
	left:SetWrap( true )
	left:SetTextInset( 0, 0 )
	left:SetText( strHelp )
	left:SetContentAlignment( 7 )
	left:SetAutoStretchVertical( true )
	left:DockMargin( 8, 0, 8, 8 )

	self:AddItem( left, nil )

	left:InvalidateLayout( true )

	return left

end

function PANEL:ControlHelp( strHelp )

	local Panel = vgui.Create( "DSizeToContents", self )
	Panel:SetSizeX( false )
	Panel:Dock( TOP )
	Panel:InvalidateLayout()

	local left = vgui.Create( "DLabel", Panel )
	left:SetDark( true )
	left:SetWrap( true )
	left:SetTextInset( 0, 0 )
	left:SetText( strHelp )
	left:SetContentAlignment( 5 )
	left:SetAutoStretchVertical( true )
	left:DockMargin( 32, 0, 32, 8 )
	left:Dock( TOP )
	left:SetTextColor( self:GetSkin().Colours.Tree.Hover )

	table.insert( self.Items, Panel )

	return left

end

--[[---------------------------------------------------------
	Note: If you're running a console command like "maxplayers 10" you
	need to add the "10" to the arguments, like so
	Button( "LabelName", "maxplayers", "10" )
-----------------------------------------------------------]]
function PANEL:Button( strName, strConCommand, ... --[[ console command args!! --]] )

	local left = vgui.Create( "DButton", self )

	if ( strConCommand ) then
		left:SetConsoleCommand( strConCommand, ... )
	end

	left:SetText( strName )
	self:AddItem( left, nil )

	return left

end

function PANEL:PanelSelect()

	local left = vgui.Create( "DPanelSelect", self )
	self:AddItem( left, nil )
	return left

end

function PANEL:ListBox( strLabel )

	if ( strLabel ) then
		local left = vgui.Create( "DLabel", self )
		left:SetText( strLabel )
		self:AddItem( left )
		left:SetDark( true )
	end

	local right = vgui.Create( "DListBox", self )
	--right:SetConVar( strConVar )
	right.Stretch = true

	self:AddItem( right )

	return right, left

end

function PANEL:Rebuild()
end

-- No example for this control
function PANEL:GenerateExample( class, tabs, w, h )
end

derma.DefineControl( "DForm", "WHAT", PANEL, "DCollapsibleCategory" )
