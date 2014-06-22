--[[   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

	DHorizontalScroller
	
	Made to scroll the tabson PropertySheet, but may have other uses.
	
--]]

PANEL = {}

AccessorFunc( PANEL, "m_iOverlap", 					"Overlap" )

--[[---------------------------------------------------------

-----------------------------------------------------------]]
function PANEL:Init()

	self.Panels = {}
	self.OffsetX = 0
	self.FrameTime = 0
	
	self.pnlCanvas 	= vgui.Create( "Panel", self )
	
	self:SetOverlap( 0 )
	
	self.btnLeft = vgui.Create( "DButton", self )
	self.btnLeft:SetText( "" )
	self.btnLeft.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "ButtonLeft", panel, w, h ) end
	
	self.btnRight = vgui.Create( "DButton", self )
	self.btnRight:SetText( "" )
	self.btnRight.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "ButtonRight", panel, w, h ) end

end

--[[---------------------------------------------------------

-----------------------------------------------------------]]
function PANEL:AddPanel( pnl )

	table.insert( self.Panels, pnl )
	
	pnl:SetParent( self.pnlCanvas )
	self:InvalidateLayout(true)

end

--[[---------------------------------------------------------
   Name: OnMouseWheeled
-----------------------------------------------------------]]
function PANEL:OnMouseWheeled( dlta )
	
	self.OffsetX = self.OffsetX + dlta * -30
	self:InvalidateLayout( true )
	
	return true
	
end

--[[---------------------------------------------------------

-----------------------------------------------------------]]
function PANEL:Think()

	-- Hmm.. This needs to really just be done in one place
	-- and made available to everyone.
	local FrameRate = VGUIFrameTime() - self.FrameTime
	self.FrameTime = VGUIFrameTime()

	if ( self.btnRight:IsDown() ) then
		self.OffsetX = self.OffsetX + (500 * FrameRate)
		self:InvalidateLayout( true )
	end
	
	if ( self.btnLeft:IsDown() ) then
		self.OffsetX = self.OffsetX - (500 * FrameRate)
		self:InvalidateLayout( true )
	end

end 

--[[---------------------------------------------------------
	PerformLayout
-----------------------------------------------------------]]
function PANEL:PerformLayout()

	local w, h = self:GetSize()
	
	self.pnlCanvas:SetTall( h )
	
	local x = 0
	
	for k, v in pairs( self.Panels ) do
	
		v:SetPos( x, 0 )
		v:SetTall( h )
		v:ApplySchemeSettings()
		
		x = x + v:GetWide() - self.m_iOverlap
	
	end
	
	self.pnlCanvas:SetWide( x + self.m_iOverlap )
	
	if ( w < self.pnlCanvas:GetWide() ) then
		self.OffsetX = math.Clamp( self.OffsetX, 0, self.pnlCanvas:GetWide() - self:GetWide() )
	else
		self.OffsetX = 0
	end
	
	self.pnlCanvas.x = self.OffsetX * -1
	
	self.btnLeft:SetSize( 15, 15 )
	self.btnLeft:AlignLeft( 4 )
	self.btnLeft.y = 5;
	
	self.btnRight:SetSize( 15, 15 )
	self.btnRight:AlignRight( 4 )
	self.btnRight.y = 5;
	
	self.btnLeft:SetVisible( self.pnlCanvas.x < 0 )
	self.btnRight:SetVisible( self.pnlCanvas.x + self.pnlCanvas:GetWide() > self:GetWide() )

end

derma.DefineControl( "DHorizontalScroller", "", PANEL, "Panel" )
