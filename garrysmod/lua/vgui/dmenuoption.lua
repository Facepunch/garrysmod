local PANEL = {}

AccessorFunc( PANEL, "m_pMenu", 		"Menu" )
AccessorFunc( PANEL, "m_bChecked", 		"Checked" )
AccessorFunc( PANEL, "m_bCheckable", 	"IsCheckable" )
AccessorFunc( PANEL, "m_RadioGroup", 	"RadioGroup" )

function PANEL:Init()

	self:SetContentAlignment( 4 )
	self:SetTextInset( 30, 0 )			-- Room for icon on left
	self:SetTextColor( Color( 10, 10, 10 ) )
	self:SetChecked( false )

end

function PANEL:SetSubMenu( menu )

	self.SubMenu = menu	
	
	if ( !self.SubMenuArrow ) then
	
		self.SubMenuArrow = vgui.Create( "DPanel", self )
		self.SubMenuArrow.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "MenuRightArrow", panel, w, h ) end
	
	end
	
end

function PANEL:AddSubMenu()

	local SubMenu = DermaMenu( self )
		SubMenu:SetVisible( false )
		SubMenu:SetParent( self )

	self:SetSubMenu( SubMenu )
	
	return SubMenu

end

function PANEL:OnCursorEntered()
	
	if ( self:GetDisabled() ) then return end

	if ( IsValid( self.ParentMenu ) ) then
		self.ParentMenu:OpenSubMenu( self, self.SubMenu )	
		return
	end
	
	self:GetParent():OpenSubMenu( self, self.SubMenu )	
	
end

function PANEL:OnCursorExited()

end

function PANEL:Paint( w, h )

	derma.SkinHook( "Paint", "MenuOption", self, w, h )

	-- Draw the button text
	return false

end

function PANEL:OnMousePressed( mousecode )
	
	if ( self:GetDisabled() ) then return end
	
	self.m_MenuClicking = true
	
	DButton.OnMousePressed( self, mousecode )
	
end

function PANEL:OnMouseReleased( mousecode )
	
	if ( self:GetDisabled() ) then return end
	
	DButton.OnMouseReleased( self, mousecode )
	
	if ( self.m_MenuClicking && mousecode == MOUSE_LEFT ) then
		
		self.m_MenuClicking = false
		CloseDermaMenus()
		
	end
	
	if ( self.m_MenuClicking && mousecode == MOUSE_RIGHT ) then
		
		self.m_MenuClicking = false
		self:DoClick()
		
	end
	
end

function PANEL:DoRightClick()
	
	if ( self:GetDisabled() ) then return end
	
	if ( self:GetIsCheckable() ) then
		self:ToggleCheck()
	end
	
	if ( self:GetRadioGroup() ) then
		self:DoClickInternal()
	end

end

function PANEL:DoClickInternal()
	
	if ( self:GetDisabled() ) then return end
	
	if ( self:GetIsCheckable() ) then
		self:ToggleCheck()
	end
	
	if ( self.m_pMenu ) then
	
		self.m_pMenu:OptionSelectedInternal( self )
	
	end
	
end

function PANEL:ToggleCheck()

	self:SetChecked( !self:GetChecked() )
	self:OnChecked( self:GetChecked() )

end

function PANEL:OnChecked( b )

end

function PANEL:PerformLayout()

	self:SizeToContents()
	self:SetWide( self:GetWide() + 30 )
	
	local w = math.max( self:GetParent():GetWide(), self:GetWide() )

	self:SetSize( w, 22 )
	
	if ( self.SubMenuArrow ) then
	
		self.SubMenuArrow:SetSize( 15, 15 )
		self.SubMenuArrow:CenterVertical()
		self.SubMenuArrow:AlignRight( 4 )
		
	end

	DButton.PerformLayout( self )
		
end

function PANEL:UpdateColours( skin )

	if ( self:GetDisabled() ) then return self:SetTextColor( skin.Colours.Button.Disabled ) end

	return self:SetTextColor( skin.Colours.Button.Normal )

end

function PANEL:GenerateExample()

	// Do nothing!

end

derma.DefineControl( "DMenuOption", "Menu Option Line", PANEL, "DButton" )
