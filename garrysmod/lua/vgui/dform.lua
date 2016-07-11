
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
