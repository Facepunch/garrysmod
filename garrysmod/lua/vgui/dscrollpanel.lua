
local PANEL = {}

AccessorFunc( PANEL, "Padding", "Padding" )
AccessorFunc( PANEL, "pnlCanvas", "Canvas" )

function PANEL:Init()

	self.pnlCanvas = vgui.Create( "Panel", self )
	self.pnlCanvas.OnMousePressed = function( slf, code ) slf:GetParent():OnMousePressed( code ) end
	self.pnlCanvas:SetMouseInputEnabled( true )
	self.pnlCanvas.PerformLayout = function( pnl )

		self:PerformLayoutInternal()
		self:InvalidateParent()

	end

	-- Create the scroll bar
	self.VBar = vgui.Create( "DVScrollBar", self )
	self.VBar:Dock( RIGHT )

	self:SetPadding( 0 )
	self:SetMouseInputEnabled( true )

	-- This turns off the engine drawing
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )
	self:SetPaintBackground( false )

end

function PANEL:AddItem( pnl )

	pnl:SetParent( self:GetCanvas() )

end

function PANEL:OnChildAdded( child )

	self:AddItem( child )

end

function PANEL:SizeToContents()

	self:SetSize( self.pnlCanvas:GetSize() )

end

function PANEL:GetVBar()

	return self.VBar

end

function PANEL:GetCanvas()

	return self.pnlCanvas

end

function PANEL:InnerWidth()

	return self:GetCanvas():GetWide()

end

function PANEL:Rebuild()

	self:GetCanvas():SizeToChildren( false, true )

	-- Although this behaviour isn't exactly implied, center vertically too
	if ( self.m_bNoSizing && self:GetCanvas():GetTall() < self:GetTall() ) then

		self:GetCanvas():SetPos( 0, ( self:GetTall() - self:GetCanvas():GetTall() ) * 0.5 )

	end

end

function PANEL:OnMouseWheeled( dlta )

	return self.VBar:OnMouseWheeled( dlta )

end

function PANEL:OnVScroll( iOffset )

	self.pnlCanvas:SetPos( 0, iOffset )

end

function PANEL:ScrollToChild( panel )

	self:InvalidateLayout( true )

	local x, y = self.pnlCanvas:GetChildPosition( panel )
	local w, h = panel:GetSize()

	y = y + h * 0.5
	y = y - self:GetTall() * 0.5

	self.VBar:AnimateTo( y, 0.5, 0, 0.5 )

end

-- Avoid an infinite loop
function PANEL:PerformLayoutInternal()

	local Tall = self.pnlCanvas:GetTall()
	local Wide = self:GetWide()
	local YPos = 0

	self:Rebuild()

	self.VBar:SetUp( self:GetTall(), self.pnlCanvas:GetTall() )
	YPos = self.VBar:GetOffset()

	if ( self.VBar.Enabled ) then Wide = Wide - self.VBar:GetWide() end

	self.pnlCanvas:SetPos( 0, YPos )
	self.pnlCanvas:SetWide( Wide )

	self:Rebuild()

	if ( Tall != self.pnlCanvas:GetTall() ) then
		self.VBar:SetScroll( self.VBar:GetScroll() ) -- Make sure we are not too far down!
	end

end

function PANEL:PerformLayout()

	self:PerformLayoutInternal()

end

function PANEL:Clear()

	return self.pnlCanvas:Clear()

end

derma.DefineControl( "DScrollPanel", "", PANEL, "DPanel" )
