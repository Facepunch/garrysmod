--[[   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

	DMenu

--]]

local PANEL = {}

AccessorFunc( PANEL, "m_bBorder", 			"DrawBorder" )
AccessorFunc( PANEL, "m_bDeleteSelf", 		"DeleteSelf" )
AccessorFunc( PANEL, "m_iMinimumWidth", 	"MinimumWidth" )
AccessorFunc( PANEL, "m_bDrawColumn", 		"DrawColumn" )
AccessorFunc( PANEL, "m_iMaxHeight", 		"MaxHeight" )

AccessorFunc( PANEL, "m_pOpenSubMenu", 		"OpenSubMenu" )


--[[---------------------------------------------------------
	Init
-----------------------------------------------------------]]
function PANEL:Init()

	self:SetIsMenu( true )
	self:SetDrawBorder( true )
	self:SetPaintBackground( true )
	self:SetMinimumWidth( 100 )
	self:SetDrawOnTop( true )
	self:SetMaxHeight( ScrH() * 0.9 )
	self:SetDeleteSelf( true )
		
	self:SetPadding( 0 )
	
	-- Automatically remove this panel when menus are to be closed
	RegisterDermaMenuForClose( self )

end

--[[---------------------------------------------------------
	AddPanel
-----------------------------------------------------------]]
function PANEL:AddPanel( pnl )

	self:AddItem( pnl )
	pnl.ParentMenu = self
	
end

--[[---------------------------------------------------------
	AddOption
-----------------------------------------------------------]]
function PANEL:AddOption( strText, funcFunction )

	local pnl = vgui.Create( "DMenuOption", self )
	pnl:SetMenu( self )
	pnl:SetText( strText )
	if ( funcFunction ) then pnl.DoClick = funcFunction end
	
	self:AddPanel( pnl )
	
	return pnl

end

--[[---------------------------------------------------------
	AddCVar
-----------------------------------------------------------]]
function PANEL:AddCVar( strText, convar, on, off, funcFunction )

	local pnl = vgui.Create( "DMenuOptionCVar", self )
	pnl:SetMenu( self )
	pnl:SetText( strText )
	if ( funcFunction ) then pnl.DoClick = funcFunction end
	
	pnl:SetConVar( convar )
	pnl:SetValueOn( on )
	pnl:SetValueOff( off )
	
	self:AddPanel( pnl )
	
	return pnl

end

--[[---------------------------------------------------------
	AddSpacer
-----------------------------------------------------------]]
function PANEL:AddSpacer( strText, funcFunction )

	local pnl = vgui.Create( "DPanel", self )
	pnl.Paint = function( p, w, h )
		surface.SetDrawColor( Color( 0, 0, 0, 100 ) )
		surface.DrawRect( 0, 0, w, h )
	end
	
	pnl:SetTall( 1 )	
	self:AddPanel( pnl )
	
	return pnl

end

--[[---------------------------------------------------------
	AddSubMenu
-----------------------------------------------------------]]
function PANEL:AddSubMenu( strText, funcFunction )

	local pnl = vgui.Create( "DMenuOption", self )
	local SubMenu = pnl:AddSubMenu( strText, funcFunction )

	pnl:SetText( strText )
	if ( funcFunction ) then pnl.DoClick = funcFunction end

	self:AddPanel( pnl )

	return SubMenu, pnl

end

--[[---------------------------------------------------------
	Hide
-----------------------------------------------------------]]
function PANEL:Hide()

	local openmenu = self:GetOpenSubMenu()
	if ( openmenu ) then
		openmenu:Hide()
	end
	
	self:SetVisible( false )
	self:SetOpenSubMenu( nil )
	
end

--[[---------------------------------------------------------
	OpenSubMenu
-----------------------------------------------------------]]
function PANEL:OpenSubMenu( item, menu )

	-- Do we already have a menu open?
	local openmenu = self:GetOpenSubMenu()
	if ( IsValid( openmenu ) ) then
	
		-- Don't open it again!
		if ( menu && openmenu == menu ) then return end
	
		-- Close it!
		self:CloseSubMenu( openmenu )
	
	end
	
	if ( !IsValid( menu ) ) then return end

	local x, y = item:LocalToScreen( self:GetWide(), 0 )
	menu:Open( x-3, y, false, item )
	
	self:SetOpenSubMenu( menu )

end


--[[---------------------------------------------------------
	CloseSubMenu
-----------------------------------------------------------]]
function PANEL:CloseSubMenu( menu )

	menu:Hide()
	self:SetOpenSubMenu( nil )

end

--[[---------------------------------------------------------
	Paint
-----------------------------------------------------------]]
function PANEL:Paint( w, h )

	if ( !self:GetPaintBackground() ) then return end

	derma.SkinHook( "Paint", "Menu", self, w, h )
	return true

end

function PANEL:ChildCount()
	return #self:GetCanvas():GetChildren()
end

function PANEL:GetChild( num )
	return self:GetCanvas():GetChildren()[ num ]
end

--[[---------------------------------------------------------
	PerformLayout
-----------------------------------------------------------]]
function PANEL:PerformLayout()

	local w = self:GetMinimumWidth()
	
	-- Find the widest one
	for k, pnl in pairs( self:GetCanvas():GetChildren() ) do
	
		pnl:PerformLayout()
		w = math.max( w, pnl:GetWide() )
	
	end

	self:SetWide( w )
	
	local y = 0 -- for padding
	
	for k, pnl in pairs( self:GetCanvas():GetChildren() ) do
	
		pnl:SetWide( w )
		pnl:SetPos( 0, y )
		pnl:InvalidateLayout( true )
		
		y = y + pnl:GetTall()
	
	end
	
	y = math.min( y, self:GetMaxHeight() )
	
	self:SetTall( y )

	derma.SkinHook( "Layout", "Menu", self )
	
	DScrollPanel.PerformLayout( self )

end


--[[---------------------------------------------------------
	Open - Opens the menu. 
	x and y are optional, if they're not provided the menu 
		will appear at the cursor.
-----------------------------------------------------------]]
function PANEL:Open( x, y, skipanimation, ownerpanel )

	RegisterDermaMenuForClose( self )
	
	local maunal = x and y

	x = x or gui.MouseX()
	y = y or gui.MouseY()
	
	local OwnerHeight = 0
	local OwnerWidth = 0
	
	if ( ownerpanel ) then
		OwnerWidth, OwnerHeight = ownerpanel:GetSize()
	end
		
	self:PerformLayout()
		
	local w = self:GetWide()
	local h = self:GetTall()
	
	self:SetSize( w, h )
	
	
	if ( y + h > ScrH() ) then y = ((maunal and ScrH()) or (y + OwnerHeight)) - h end
	if ( x + w > ScrW() ) then x = ((maunal and ScrW()) or x) - w end
	if ( y < 1 ) then y = 1 end
	if ( x < 1 ) then x = 1 end
	
	self:SetPos( x, y )
	
	-- Popup!
	self:MakePopup()
	
	-- Make sure it's visible!
	self:SetVisible( true )
	
	-- Keep the mouse active while the menu is visible.
	self:SetKeyboardInputEnabled( false )
	
end

--
-- Called by DMenuOption
--
function PANEL:OptionSelectedInternal( option )

	self:OptionSelected( option, option:GetText() )

end

function PANEL:OptionSelected( option, text )

	-- For override

end

function PANEL:ClearHighlights()

	for k, pnl in pairs( self:GetCanvas():GetChildren() ) do
		pnl.Highlight = nil
	end

end

function PANEL:HighlightItem( item )

	for k, pnl in pairs( self:GetCanvas():GetChildren() ) do
		if ( pnl == item ) then
			pnl.Highlight = true
		end
	end

end

--[[---------------------------------------------------------
   Name: GenerateExample
-----------------------------------------------------------]]
function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local MenuItemSelected = function()
		Derma_Message( "Choosing a menu item worked!" )
	end

	local ctrl = vgui.Create( "Button" )
		ctrl:SetText( "Test Me!" )
		ctrl.DoClick = function() 
						local menu = DermaMenu()
						
							menu:AddOption( "Option One", MenuItemSelected )
							menu:AddOption( "Option 2", MenuItemSelected )
							local submenu = menu:AddSubMenu( "Option Free" )
								submenu:AddOption( "Submenu 1", MenuItemSelected )
								submenu:AddOption( "Submenu 2", MenuItemSelected )
							menu:AddOption( "Option For", MenuItemSelected )
							
						menu:Open()
		
						end
		
	PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )

end

derma.DefineControl( "DMenu", "A Menu", PANEL, "DScrollPanel" )
