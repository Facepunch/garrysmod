
local PANEL = {}

AccessorFunc( PANEL, "m_pMother", "Mother" )

function PANEL:Init()

	self:SetMouseInputEnabled( true )
	self:SetTextInset( 5, 0 )
	self:SetTall( 19 )
	self:SetDark( true )

end

function PANEL:OnMousePressed( mcode )

	if ( mcode == MOUSE_LEFT ) then
		self:Select( true )
	end

	self:SetTextColor( color_black )
end

function PANEL:Paint( w, h )
	if ( self:IsSelected() ) then
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 128, 255, 200 ) )
	elseif ( self.Hovered ) then
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 128, 255, 128 ) )
	end
end

function PANEL:OnCursorMoved( x, y )

	if ( input.IsMouseDown( MOUSE_LEFT ) ) then
		self:Select( false )
	end

end

function PANEL:Select( bOnlyMe )

	self.m_pMother:SelectItem( self, bOnlyMe )

	self:DoClick()

end

function PANEL:DoClick()

	-- For override

end

function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )
end

derma.DefineControl( "DListBoxItem", "", PANEL, "DLabel" )

--[[---------------------------------------------------------
	DListBox
-----------------------------------------------------------]]

local PANEL = {}

AccessorFunc( PANEL, "m_bSelectMultiple", "Multiple", FORCE_BOOL )
AccessorFunc( PANEL, "SelectedItems", "SelectedItems" )	-- All selected in a table

Derma_Hook( PANEL, "Paint", "Paint", "ListBox" )

function PANEL:Init()

	self:SetMultiple( true )
	self:EnableHorizontal( false )
	self:EnableVerticalScrollbar()

	self:SetPadding( 1 )

	self.m_bSelectionCanvas = true
	self.SelectedItems = {}

end

function PANEL:Clear()

	self.SelectedItems = {}
	DPanelList.Clear( self, true )

end

function PANEL:AddItem( strLabel )

	local item = vgui.Create( "DListBoxItem", self )
	item:SetMother( self )
	item:SetText( strLabel )

	DPanelList.AddItem( self, item )

	return item

end

function PANEL:Rebuild()

	local Offset = 0

	local x, y = self.Padding, self.Padding
	for k, panel in pairs( self.Items ) do

		local w = panel:GetWide()
		local h = panel:GetTall()

		panel:SetPos( self.Padding, y )
		panel:SetWide( self:GetCanvas():GetWide() - self.Padding * 2 )

		x = x + w + self.Spacing

		y = y + h + self.Spacing

		Offset = y + h + self.Spacing

	end

	self:GetCanvas():SetTall( Offset + (self.Padding * 2) - self.Spacing )

end

function PANEL:SelectItem( item, onlyme )

	if ( !onlyme && item:IsSelected() ) then return end

	-- Unselect old items
	if ( onlyme || !self.m_bSelectMultiple ) then

		for k, v in pairs( self.SelectedItems ) do
			v:SetSelected( false )
		end

		self.SelectedItems = {}
		self.m_pSelected = nil

	end

	if ( self.OnSelect ) then self:OnSelect( item ) end

	self.m_pSelected = item
	item:SetSelected( true )
	table.insert( self.SelectedItems, item )

end

function PANEL:SelectByName( strName )

	for k, panel in pairs( self.Items ) do

		if ( panel:GetValue() == strName ) then
			self:SelectItem( panel, true )
		return end

	end

end

function PANEL:GetSelectedValues()

	local items = self:GetSelectedItems()

	if ( #items > 1 ) then

		local ret = {}
		for _, v in pairs( items ) do table.insert( ret, v:GetValue() ) end
		return ret

	elseif ( #items == 1 ) then

		return items[1]:GetValue()

	end

end

function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local ctrl = vgui.Create( ClassName )
	ctrl:AddItem( "Bread" )
	ctrl:AddItem( "Carrots" )
	ctrl:AddItem( "Toilet Paper" )
	ctrl:AddItem( "Air Freshner" )
	ctrl:AddItem( "Shovel" )
	ctrl:SetSize( 100, 300 )

	PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )

end

derma.DefineControl( "DListBox", "", PANEL, "DPanelList" )
