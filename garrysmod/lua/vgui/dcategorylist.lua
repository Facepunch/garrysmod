--[[   _                                
	( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

	DPanelList
	
	A window.

--]]
local PANEL = {}

--[[---------------------------------------------------------
   Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

	self.pnlCanvas:DockPadding( 2, 2, 2, 2 )

end

--[[---------------------------------------------------------
   Name: AddItem
-----------------------------------------------------------]]
function PANEL:AddItem( item )

	item:Dock( TOP )
	DScrollPanel.AddItem( self, item )
	self:InvalidateLayout()
	
end

--[[---------------------------------------------------------
   Name: Add
-----------------------------------------------------------]]
function PANEL:Add( name )

	local Category = vgui.Create( "DCollapsibleCategory", self )
	Category:SetLabel( name )
	Category:SetList( self )
	
	self:AddItem( Category )
	
	return Category	

end

--[[---------------------------------------------------------
	Paint
-----------------------------------------------------------]]
function PANEL:Paint( w, h )

	derma.SkinHook( "Paint", "CategoryList", self, w, h )
	return false

end

function PANEL:UnselectAll()

	for k, v in pairs( self:GetChildren() ) do
	
		if ( v.UnselectAll ) then
			v:UnselectAll()
		end
	
	end

end

derma.DefineControl( "DCategoryList", "", PANEL, "DScrollPanel" )
