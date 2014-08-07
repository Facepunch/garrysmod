--[[   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

	DMenuOption

--]]

local PANEL = {}

AccessorFunc( PANEL, "m_pMenu", 		"Menu" )
AccessorFunc( PANEL, "m_bChecked", 		"Checked" )
AccessorFunc( PANEL, "m_bCheckable", 	"IsCheckable" )
AccessorFunc( PANEL, "m_bDisabled", 	"Disabled", FORCE_BOOL )

--[[---------------------------------------------------------

-----------------------------------------------------------]]
function PANEL:Init()

	self:SetContentAlignment( 4 )
	self:SetTextInset( 30, 0 )			-- Room for icon on left
	self:SetTextColor( Color( 10, 10, 10 ) )
	self:SetChecked( false )

end


--[[---------------------------------------------------------

-----------------------------------------------------------]]
function PANEL:SetSubMenu( menu )

	self.SubMenu = menu	
	
	if ( !self.SubMenuArrow ) then
	
		self.SubMenuArrow = vgui.Create( "DPanel", self )
		self.SubMenuArrow.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "MenuRightArrow", panel, w, h ) end
	
	end
	
end

--
-- AddSubMenu
--
function PANEL:AddSubMenu()

	local SubMenu = DermaMenu( self )
		SubMenu:SetVisible( false )
		SubMenu:SetParent( self )

	self:SetSubMenu( SubMenu )
	
	return SubMenu

end


--[[---------------------------------------------------------

-----------------------------------------------------------]]
function PANEL:OnCursorEntered()

	if ( self:GetDisabled() ) then return end
	
	if ( IsValid( self.ParentMenu ) ) then
		self.ParentMenu:OpenSubMenu( self, self.SubMenu )	
		return
	end
	
	self:GetParent():OpenSubMenu( self, self.SubMenu )	
	
end

--[[---------------------------------------------------------

-----------------------------------------------------------]]
function PANEL:OnCursorExited()

end



--[[---------------------------------------------------------

-----------------------------------------------------------]]
function PANEL:Paint( w, h )

	derma.SkinHook( "Paint", "MenuOption", self, w, h )
	
	--
	-- Draw the button text
	--
	return false

end

--[[---------------------------------------------------------
	OnMousePressed
-----------------------------------------------------------]]
function PANEL:OnMousePressed( mousecode )

	self.m_MenuClicking = true

	DButton.OnMousePressed( self, mousecode )

end

--[[---------------------------------------------------------
	SetDisabled
-----------------------------------------------------------]]
function PANEL:SetDisabled( bDisabled )
	
	self.m_bDisabled = bDisabled
	self:InvalidateLayout()
	
	local skin = self:GetSkin()
	self:SetTextColor( bDisabled and skin.Colours.Button.Disabled or skin.Colours.Label.Dark )

end

--[[---------------------------------------------------------
	OnMouseReleased
-----------------------------------------------------------]]
function PANEL:OnMouseReleased( mousecode )

	DButton.OnMouseReleased( self, mousecode )

	if ( self.m_MenuClicking && mousecode == MOUSE_LEFT && not self:GetDisabled() ) then
		
		self.m_MenuClicking = false
		CloseDermaMenus()
		
	end

end

--[[---------------------------------------------------------
	DoRightClick
-----------------------------------------------------------]]
function PANEL:DoRightClick()

	if ( self:GetIsCheckable() && not self:GetDisabled() ) then
		self:ToggleCheck()
	end

end

--[[---------------------------------------------------------
	DoClickInternal
-----------------------------------------------------------]]
function PANEL:DoClickInternal()
	
	if ( self:GetDisabled() ) then return end
	
	if ( self:GetIsCheckable() ) then
		self:ToggleCheck()
	end

	if ( self.m_pMenu ) then
	
		self.m_pMenu:OptionSelectedInternal( self )
	
	end

end

--[[---------------------------------------------------------
	ToggleCheck
-----------------------------------------------------------]]
function PANEL:ToggleCheck()

	self:SetChecked( !self:GetChecked() )
	self:OnChecked( self:GetChecked() )

end

--[[---------------------------------------------------------
	OnChecked
-----------------------------------------------------------]]
function PANEL:OnChecked( b )

end

--[[---------------------------------------------------------
   Name: PerformLayout
-----------------------------------------------------------]]
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

function PANEL:GenerateExample()

	// Do nothing!

end

derma.DefineControl( "DMenuOption", "Menu Option Line", PANEL, "DButton" )
