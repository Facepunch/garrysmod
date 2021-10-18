
local PANEL = {}

Derma_Hook( PANEL, "Paint", "Paint", "ComboBox" )

Derma_Install_Convar_Functions( PANEL )

AccessorFunc( PANEL, "m_bDoSort", "SortItems", FORCE_BOOL )

function PANEL:Init()

	-- Create button
	self.DropButton = vgui.Create( "DPanel", self )
	self.DropButton.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "ComboDownArrow", panel, w, h ) end
	self.DropButton:SetMouseInputEnabled( false )
	self.DropButton.ComboBox = self

	-- Apply default panel hight
	self:SetTall( 22 )
	self:Clear()

	-- Setup internals
	self:SetContentAlignment( 4 )
	self:SetTextInset( 8, 0 )
	self:SetIsMenu( true )
	self:SetSortItems( true )

end

function PANEL:CloseMenu()

	if ( IsValid( self.Menu ) ) then
		self.Menu:Remove()
	end

	self.Menu = nil

end

function PANEL:Clear()

	-- Does not allocate another table
	self:SetText( "" )
	self.Data = {}
	self.Choices = {}
	self.Spacers = {}
	self.ChoiceIcons = {}
	self.selected = nil
	self:CloseMenu()

end

function PANEL:GetSelectedID()

	return self.selected

end

function PANEL:GetOptionCount()

	return #self.Choices

end

function PANEL:GetOptionText( id )

	return self.Choices[ id ]

end

function PANEL:GetOptionData( id )

	return self.Data[ id ]

end

function PANEL:AddSpacer()

	local id = self:GetOptionCount()

	self.Spacers[ id ] = true

end

function PANEL:GetOptionTextByData( data )

	for id, dat in pairs( self.Data ) do
		if ( dat == data ) then
			return self:GetOptionText( id )
		end
	end

	-- Try interpreting it as a number
	for id, dat in pairs( self.Data ) do
		if ( dat == tonumber( data ) ) then
			return self:GetOptionText( id )
		end
	end

	-- In case we fail
	return data

end

function PANEL:PerformLayout()

	self.DropButton:SetSize( 15, 15 )
	self.DropButton:AlignRight( 4 )
	self.DropButton:CenterVertical()

	-- Make sure the text color is updated
	DButton.PerformLayout( self, w, h )

end

function PANEL:ChooseOption( value, id )

	self:CloseMenu()
	self:SetText( value )

	-- This should really be the here, but it is too late now and convar
	-- changes are handled differently by different child elements
	-- self:ConVarChanged( self.Data[ id ] )

	self.selected = id
	self:OnSelect( id, value, self.Data[ id ] )

end

function PANEL:ChooseOptionID( id )

	local value = self:GetOptionText( id )
	self:ChooseOption( value, id )

end

function PANEL:RemoveChoiceID( id )

	-- The second argument must be convertable to number
	-- Removing non-positive or fractional does nothing
	-- Entry will be removed only on positive integers

	if ( !id ) then return end

	local text = table.remove( self.Choices, id )
	local data = table.remove( self.Data   , id )

	return text, data -- Using the logic of reading an ID

end

function PANEL:RemoveChoiceName( name )

	local id = table.KeyFromValue( self.Choices, name )

	if ( !id ) then return end

	return self:RemoveChoiceID( id )

end

function PANEL:RemoveChoiceData( data )

	local id = table.KeyFromValue( self.Data, data )

	if ( !id ) then return end

	return self:RemoveChoiceID( id )

end

function PANEL:RemoveSelected()

	local id = self:GetSelectedID()
	return self:RemoveChoiceID( id )

end

function PANEL:GetSelected()

	local id = self:GetSelectedID()

	if ( !id ) then return end

	local text = self:GetOptionText( id )
	local data = self:GetOptionData( id )

	return text, data

end

function PANEL:OnSelect( id, value, data )

	-- For override

end

function PANEL:OnMenuOpened( menu )

	-- For override

end

function PANEL:AddChoice( value, data, choose, icon )

	local id = table.insert( self.Choices, value )

	if ( data ) then
		self.Data[ id ] = data
	end

	if ( icon ) then
		self.ChoiceIcons[ id ] = icon
	end

	if ( choose ) then

		self:ChooseOption( value, id )

	end

	return id

end

function PANEL:IsMenuOpen()

	return IsValid( self.Menu ) && self.Menu:IsVisible()

end

function PANEL:OpenMenu( pControlOpener )

	if ( pControlOpener && pControlOpener == self.TextEntry ) then
		return
	end

	-- Don't do anything if there aren't any options..
	if ( self:GetOptionCount() == 0 ) then return end

	-- If the menu still exists and hasn't been deleted
	-- then just close it and don't open a new one.
	self:CloseMenu()

	-- If we have a modal parent at some level, we gotta parent to
	-- that or our menu items are not gonna be selectable
	local parent = self
	while ( IsValid( parent ) && !parent:IsModal() ) do
		parent = parent:GetParent()
	end
	if ( !IsValid( parent ) ) then parent = self end

	self.Menu = DermaMenu( false, parent )

	if ( self:GetSortItems() ) then
		local sorted = {}
		for k, v in pairs( self.Choices ) do
			local val = tostring( v ) --tonumber( v ) || v -- This would make nicer number sorting, but SortedPairsByMemberValue doesn't seem to like number-string mixing
			if ( string.len( val ) > 1 && !tonumber( val ) && val:StartWith( "#" ) ) then val = language.GetPhrase( val:sub( 2 ) ) end
			table.insert( sorted, { id = k, data = v, label = val } )
		end
		for k, v in SortedPairsByMemberValue( sorted, "label" ) do
			local option = self.Menu:AddOption( v.data, function() self:ChooseOption( v.data, v.id ) end )
			if ( self.ChoiceIcons[ v.id ] ) then
				option:SetIcon( self.ChoiceIcons[ v.id ] )
			end
			if ( self.Spacers[ v.id ] ) then
				self.Menu:AddSpacer()
			end
		end
	else
		for k, v in pairs( self.Choices ) do
			local option = self.Menu:AddOption( v, function() self:ChooseOption( v, k ) end )
			if ( self.ChoiceIcons[ k ] ) then
				option:SetIcon( self.ChoiceIcons[ k ] )
			end
			if ( self.Spacers[ k ] ) then
				self.Menu:AddSpacer()
			end
		end
	end

	local x, y = self:LocalToScreen( 0, self:GetTall() )

	self.Menu:SetMinimumWidth( self:GetWide() )
	self.Menu:Open( x, y, false, self )

	self:OnMenuOpened( self.Menu )

end

-- This really should use a convar change hook
function PANEL:CheckConVarChanges()

	if ( !self.m_strConVar ) then return end

	local strValue = GetConVarString( self.m_strConVar )
	if ( self.m_strConVarValue == strValue ) then return end

	self.m_strConVarValue = strValue

	self:SetValue( self:GetOptionTextByData( self.m_strConVarValue ) )

end

function PANEL:Think()

	self:CheckConVarChanges()

end

function PANEL:SetValue( strValue )

	self:SetText( strValue )

end

function PANEL:DoClick()

	if ( self:IsMenuOpen() ) then
		return self:CloseMenu()
	end

	self:OpenMenu()

end

function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local ctrl = vgui.Create( ClassName )
	ctrl:AddChoice( "Some Choice" )
	ctrl:AddChoice( "Another Choice", "myData" )
	ctrl:AddChoice( "Default Choice", "myData2", true )
	ctrl:AddChoice( "Icon Choice", "myData3", false, "icon16/star.png" )
	ctrl:SetWide( 150 )

	PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )

end

derma.DefineControl( "DComboBox", "", PANEL, "DButton" )
