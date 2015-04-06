--[[   _                                
	( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

	DGrid

--]]
local PANEL = {}

AccessorFunc( PANEL, "m_iCols", 		"Cols" )
AccessorFunc( PANEL, "m_iColWide", 		"ColWide" )
AccessorFunc( PANEL, "m_iRowHeight", 		"RowHeight" )

--[[---------------------------------------------------------
   Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

	self.Items = {}
	
	self:SetCols( 4 )
	self:SetColWide( 32 )
	self:SetRowHeight( 32 )
	
	self:SetMouseInputEnabled( true )

end

--[[---------------------------------------------------------
   Name: GetItems
-----------------------------------------------------------]]
function PANEL:GetItems()

	-- Should we return a copy of this to stop 
	-- people messing with it?
	return self.Items
	
end

--[[---------------------------------------------------------
   Name: AddItem
-----------------------------------------------------------]]
function PANEL:AddItem( item )

	if ( !IsValid( item ) ) then return end

	item:SetVisible( true )
	item:SetParent( self )
	
	table.insert( self.Items, item )
	
	self:InvalidateLayout()

end

--[[---------------------------------------------------------
   Name: RemoveItem
-----------------------------------------------------------]]
function PANEL:RemoveItem( item, bDontDelete )

	for k, panel in pairs( self.Items ) do
	
		if ( panel == item ) then
		
			table.remove(self.Items, k)
			
			if (!bDontDelete) then
				panel:Remove()
			end
		
			self:InvalidateLayout()
		
		end
	
	end

end

--[[---------------------------------------------------------
   Name: PerformLayout
-----------------------------------------------------------]]
function PANEL:PerformLayout()

	local i = 0
	
	self.m_iCols = math.floor( self.m_iCols )
	
	for k, panel in pairs( self.Items ) do
		
		local x = ( i%self.m_iCols ) * self.m_iColWide
		local y = math.floor( i / self.m_iCols )  * self.m_iRowHeight
		
		panel:SetPos( x, y )
		
		i = i + 1 
	end
	
	self:SetWide( self.m_iColWide * self.m_iCols )
	self:SetTall( math.ceil( i / self.m_iCols )  * self.m_iRowHeight )

end

--[[---------------------------------------------------------
   Name: SortByMember
-----------------------------------------------------------]]
function PANEL:SortByMember( key, desc )

	desc = desc or true

	table.sort( self.Items, function( a, b ) 

								if ( desc ) then
								
									local ta = a
									local tb = b
									
									a = tb
									b = ta
								
								end
	
								if ( a[ key ] == nil ) then return false end
								if ( b[ key ] == nil ) then return true end
								
								return a[ key ] > b[ key ]
								
							end )

end

derma.DefineControl( "DGrid", "A really simple grid layout panel", PANEL, "Panel" )
