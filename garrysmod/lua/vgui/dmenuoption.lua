--[[   _
    ( )
   _| |   __   _ __   ___ ___     _ _
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_)

	DMenuOption

--]]
PANEL = {}

AccessorFunc( PANEL, "m_pMenu", 		"Menu" )
AccessorFunc( PANEL, "m_bChecked", 		"Checked" )
AccessorFunc( PANEL, "m_bCheckable", 	"IsCheckable" )

--[[---------------------------------------------------------
   Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

	self:SetContentAlignment( 4 )
	self:SetTextInset( 30, 0 )			-- Room for icon on left
	self:SetTextColor( Color( 10, 10, 10 ) )
	self:SetChecked( false )

end

--[[---------------------------------------------------------
   Name: SetSubMenu
-----------------------------------------------------------]]
function PANEL:SetSubMenu( menu )

	self.SubMenu = menu

	if ( !self.SubMenuArrow ) then

		self.SubMenuArrow = vgui.Create( "DPanel", self )
		self.SubMenuArrow.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "MenuRightArrow", panel, w, h ) end

	end

end

--[[---------------------------------------------------------
   Name: AddSubMenu
-----------------------------------------------------------]]
function PANEL:AddSubMenu()

	local SubMenu = DermaMenu( self )
		SubMenu:SetVisible( false )
		SubMenu:SetParent( self )

	self:SetSubMenu( SubMenu )

	return SubMenu

end

--[[---------------------------------------------------------
   Name: OnCursorEntered
-----------------------------------------------------------]]
function PANEL:OnCursorEntered()

	if ( IsValid( self.ParentMenu ) ) then
		self.ParentMenu:OpenSubMenu( self, self.SubMenu )
		return
	end

	self:GetParent():OpenSubMenu( self, self.SubMenu )

end

--[[---------------------------------------------------------
   Name: OnCursorExited
-----------------------------------------------------------]]
function PANEL:OnCursorExited()

end


--[[---------------------------------------------------------
   Name: Paint
-----------------------------------------------------------]]
function PANEL:Paint( w, h )

	derma.SkinHook( "Paint", "MenuOption", self, w, h )

	--
	-- Draw the button text
	--
	return false

end

--[[---------------------------------------------------------
   Name: OnMousePressed
-----------------------------------------------------------]]
function PANEL:OnMousePressed( mousecode )

	self.m_MenuClicking = true

	DButton.OnMousePressed( self, mousecode )

end

--[[---------------------------------------------------------
   Name: OnMouseReleased
-----------------------------------------------------------]]
function PANEL:OnMouseReleased( mousecode )

	DButton.OnMouseReleased( self, mousecode )

	if ( self.m_MenuClicking && mousecode == MOUSE_LEFT ) then

		self.m_MenuClicking = false
		CloseDermaMenus()

	end

end

--[[---------------------------------------------------------
   Name: DoRightclick
-----------------------------------------------------------]]
function PANEL:DoRightClick()

	if ( self:GetIsCheckable() ) then
		self:ToggleCheck()
	end

end

--[[---------------------------------------------------------
   Name: DoClickInternal
-----------------------------------------------------------]]
function PANEL:DoClickInternal()

	if ( self:GetIsCheckable() ) then
		self:ToggleCheck()
	end

	if ( self.m_pMenu ) then

		self.m_pMenu:OptionSelectedInternal( self )

	end

end

--[[---------------------------------------------------------
   Name: ToggleCheck
-----------------------------------------------------------]]
function PANEL:ToggleCheck()

	self:SetChecked( !self:GetChecked() )
	self:OnChecked( self:GetChecked() )

end

--[[---------------------------------------------------------
   Name: OnChecked
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

--[[---------------------------------------------------------
   Name: GenerateExample
-----------------------------------------------------------]]
function PANEL:GenerateExample()

	// Do nothing!

end

derma.DefineControl( "DMenuOption", "Menu Option Line", PANEL, "DButton" )