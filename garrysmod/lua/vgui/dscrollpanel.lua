
local PANEL = {}

AccessorFunc( PANEL, "Padding", "Padding" )
AccessorFunc( PANEL, "pnlCanvas", "Canvas" )

function PANEL:Init()
	self.pnlCanvas = vgui.Create( "Panel", self )
	self.pnlCanvas.OnMousePressed = function( pnl, code )
		pnl:GetParent():OnMousePressed( code )
	end

	self.pnlCanvas:SetMouseInputEnabled( true )
	self.pnlCanvas.PerformLayout = function( pnl )
		self:PerformLayoutInternal()
		self:InvalidateParent()
	end

	-- Create the scroll bar
	local scrollBar = vgui.Create( "DVScrollBar", self )
	if IsValid( scrollBar ) then
		self.VBar = scrollBar
		scrollBar:Dock( RIGHT )
	end

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
	local canvas = self:GetCanvas()
	if IsValid( canvas ) then
		self:SetSize( canvas:GetSize() )
	end
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

function PANEL:OnMouseWheeled( dlta )
	local vbar = self:GetVBar()
	if IsValid( vbar ) then
		return vbar:OnMouseWheeled( dlta )
	end
end

function PANEL:OnVScroll( iOffset )
	local canvas = self:GetCanvas()
	if IsValid( canvas ) then
		canvas:SetPos( 0, iOffset )
	end
end

function PANEL:ScrollToChild( panel )
	self:InvalidateLayout( true )

	local canvas = self:GetCanvas()
	if IsValid( canvas ) then
		local vbar = self:GetVBar()
		if IsValid( vbar ) then
			local _, y = canvas:GetChildPosition( panel )
			vbar:AnimateTo( (y + panel:GetTall() / 2) - self:GetTall() / 2, 0.5, 0, 0.5 )
		end
	end
end

function PANEL:Rebuild()
	local canvas = self:GetCanvas()
	if IsValid( canvas ) then
		canvas:SizeToChildren( false, true )

		-- Although this behaviour isn't exactly implied, center vertically too
		local canvasHeight = canvas:GetTall()
		if self.m_bNoSizing and (canvasHeight < self:GetTall()) then
			canvas:SetPos( 0, (self:GetTall() - canvasHeight) / 2 )
		end
	end
end

function PANEL:PerformLayoutInternal()
	local canvas = self:GetCanvas()
	if IsValid( canvas ) then
		local canvasHeight = canvas:GetTall()
		local width = self:GetWide()

		self:Rebuild()

		local vbar = self:GetVBar()
		if IsValid( vbar ) then
			local height = self:GetTall()
			vbar:SetUp( height, canvasHeight )
			if vbar.Enabled and (canvasHeight < height) then
				canvas:SetPos( 0, vbar:GetOffset() )
				width = width - vbar:GetWide()
			end

			canvas:SetWide( width )
		end
	end
end

function PANEL:PerformLayout()
	self:PerformLayoutInternal()
end

function PANEL:Clear()
	local canvas = self:GetCanvas()
	if IsValid( canvas ) then
		return canvas:Clear()
	end
end

derma.DefineControl( "DScrollPanel", "", PANEL, "DPanel" )