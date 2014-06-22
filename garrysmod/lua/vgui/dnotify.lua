--[[   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

--]]
local PANEL = {}

AccessorFunc( PANEL, "Spacing", 	"Spacing" )
AccessorFunc( PANEL, "Alignment", 	"Alignment" )
AccessorFunc( PANEL, "m_fLifeLength", 	"Life" )


--[[---------------------------------------------------------
   Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

	self.Items = {}
	
	self:SetSpacing( 4 )
	self:SetAlignment( 7 )
	self:SetLife( 5 )
	
	-- This turns off the engine drawing
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )

end

--[[---------------------------------------------------------
   Name: GetItems
-----------------------------------------------------------]]
function PANEL:GetItems()

	return self.Items
	
end

--[[---------------------------------------------------------
   Name: AddItem
-----------------------------------------------------------]]
function PANEL:AddItem( item, LifeLength )

	if (!item || !item:IsValid()) then return end
	LifeLength = LifeLength or self.m_fLifeLength

	item:SetVisible( true )
	item:SetParent( self )
	table.insert( self.Items, item )
	item:SetAlpha( 1 )
	
	item:SetTerm( LifeLength )
	item:AlphaTo( 0, 0.3, LifeLength-0.3 )
	
	self:Shuffle()

end

--[[---------------------------------------------------------
   Name: Think
-----------------------------------------------------------]]
function PANEL:Think( )

	local bChange = false
	for k, panel in pairs( self.Items ) do
	
		if ( !IsValid( panel ) ) then
		
			self.Items[ k ] = false
			bChange = true
			
		end
	
	end
	
	if ( bChange ) then
		self:Shuffle()
	end

end

--[[---------------------------------------------------------
   Name: Rebuild
-----------------------------------------------------------]]
function PANEL:Shuffle()

	local y = 0
	
	if ( self.Alignment == 1 || self.Alignment == 3 ) then
		y = self:GetTall()
	end
	
	local Count = 0
	for k, panel in pairs( self.Items ) do
	
		if ( IsValid( panel ) ) then
	
			local x = 0
			
			if ( self.Alignment == 8 || self.Alignment == 2 ) then
				x = (self:GetWide() + panel:GetWide()) / 2
			elseif ( self.Alignment == 9 || self.Alignment == 3 ) then
				x = self:GetWide() - panel:GetWide()
			end
			
			if ( self.Alignment == 1 || self.Alignment == 3 ) then
				y = y - panel:GetTall()
			end
		
			if ( panel.bHasEntered ) then
				panel:SetPos( x, y )
			else
				panel:SetPos( x, y )
				panel:LerpPositions( 1, true )
				panel:AlphaTo( 255, 0.3 )
				panel.bHasEntered = true
			end
			
			if ( self.Alignment == 1 || self.Alignment == 3 ) then
				y = y - self.Spacing
			else
				y = y + panel:GetTall() + self.Spacing
			end
	
			Count = Count + 1
	
		end
	
	end

	-- By only removing them when the list is empty 
	--  we keep the order.
	if ( Count == 0 && #self.Items > 0 ) then
		self.Items = {}
	end

end

--[[---------------------------------------------------------
   Name: PerformLayout
-----------------------------------------------------------]]
function PANEL:PerformLayout()

end

derma.DefineControl( "DNotify", "", PANEL, "Panel" )
