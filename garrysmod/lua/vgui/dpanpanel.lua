
local PANEL = {}

AccessorFunc( PANEL, "pnlCanvas", "Canvas" )

function PANEL:Init()

	self.pnlCanvas = vgui.Create( "Panel", self )

	self:GetCanvas().OnMousePressed = function( s, code )
		s:GetParent():OnMousePressed( code )
	end

	self:GetCanvas():SetMouseInputEnabled( true )

	self:GetCanvas().PerformLayout = function( pnl )
		self:PerformLayout()
		self:InvalidateParent()
	end

	function self.pnlCanvas:Think()
		local mousex = math.Clamp( gui.MouseX(), 1, ScrW() - 1 )
		local mousey = math.Clamp( gui.MouseY(), 1, ScrH() - 1 )

		if ( self.Dragging ) then
			local x = mousex - self.Dragging[1]
			local y = mousey - self.Dragging[2]
			self:SetPos( x, y )
			self:PerformLayout()
		end

		if ( self.Hovered ) then
			self:SetCursor( "sizeall" )

			return
		end

		self:SetCursor( "arrow" )
	end

	function self.pnlCanvas:OnMousePressed( keyCode )
		self.Dragging = { gui.MouseX() - self.x, gui.MouseY() - self.y }
		self:MouseCapture( true )
	end

	function self.pnlCanvas:OnMouseReleased( keyCode )
		self.Dragging = nil
		self.Sizing = nil
		self:MouseCapture( false )
		self:InvalidateParent()
	end

	self:SetMouseInputEnabled( true )

	--This turns off the engine drawing
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )
	self:SetPaintBackground( false )

end

function PANEL:Think()

	if ( self.Hovered ) then
		self:SetCursor( "sizeall" )

		return
	end

	self:SetCursor( "arrow" )

end

function PANEL:OnMousePressed( ... )
	self.pnlCanvas:OnMousePressed( ... )
end

function PANEL:OnMouseReleased( ... )
	self.pnlCanvas:OnMouseReleased( ... )
end

function PANEL:AddItem( pnl )
	pnl:SetParent( self:GetCanvas() )
end

function PANEL:OnChildAdded( child )

	self:AddItem( child )

	-- Anchor all children to top-left (so they are all snug)
	local can = self:GetCanvas()
	local mx, my

	for _, p in pairs( can:GetChildren() ) do
		local x, y = p:GetPos()
		mx = mx or x
		my = my or y

		if ( x < mx ) then mx = x end
		if ( y < my ) then my = y end
	end

	if ( mx ) then
		for _, p in pairs( can:GetChildren() ) do
			local x, y = p:GetPos()
			p:SetPos( x - mx, y - my )
		end

		local x, y = can:GetPos()
		can:SetPos( x + mx, y + my )
	end

end

function PANEL:SizeToContents()
	self:SetSize( self:GetCanvas():GetSize() )
end

function PANEL:OnScroll( x, y )
	self:GetCanvas():SetPos( x, y )
end

function PANEL:ScrollToChild( panel )

	self:PerformLayout()

	local x, y = self:GetCanvas():GetChildPosition( panel )
	local w, h = panel:GetSize()
	y = y + h * 0.5
	x = x + w * 0.5
	y = y - self:GetTall() * 0.5
	x = x - self:GetWide() * 0.5
	self:OnScroll( x, y )

end

function PANEL:PerformLayout()

	local can = self:GetCanvas()

	can:SizeToChildren( true, true )

	-- Restrict movement to the size of this panel
	local x, y, w, h = can:GetBounds()

	if ( w > self:GetWide() ) then
		if ( x > 0 ) then
			can:SetPos( 0, y )
			x = 0
		end

		--right
		if ( x + w < self:GetWide() ) then
			local nx = self:GetWide() - w
			can:SetPos( nx, y )
			x = nx
		end
	end

	if ( w < self:GetWide() ) then
		if ( x < 0 ) then
			can:SetPos( 0, y )
			x = 0
		end

		--left
		if ( x + w > self:GetWide() ) then
			local nx = self:GetWide() - w
			can:SetPos( nx, y )
			x = nx
		end
	end

	if ( h > self:GetTall() ) then
		if ( y > 0 ) then
			can:SetPos( x, 0 )
			y = 0
		end

		--up
		if ( y + h < self:GetTall() ) then
			local ny = self:GetTall() - h
			can:SetPos( x, ny )
			y = ny
		end
	end

	if ( h < self:GetTall() ) then
		if ( y < 0 ) then
			can:SetPos( x, 0 )
			y = 0
		end

		--down
		if ( y + h > self:GetTall() ) then
			local ny = self:GetTall() - h
			can:SetPos( x, ny )
			y = ny
		end
	end

end

function PANEL:Clear() return self:GetCanvas():Clear() end

function PANEL:GenerateExample( class, propsheet, width, height )

	local dpan = vgui.Create( "Panel" )
	dpan:Dock( FILL )
	propsheet:AddSheet( class, dpan )

	local dpl = vgui.Create( "DPanel", dpan )
	dpl:SetSize( 200, 200 )
	dpl:SetPos( 100, 100 )

	local panl = vgui.Create( "DPanPanel", dpl )
	panl:Dock( FILL )

	local bl1 = panl:Add( "DButton" )
	bl1:SetText( "Small" )

	local bl2 = panl:Add( "DButton" )
	bl2:SetPos( 100, 100 )
	bl2:SetText( "Contents" )



	local dpr = vgui.Create( "DPanel", dpan )
	dpr:SetWide( width / 2 )
	dpr:SetSize( 200, 200 )
	dpr:SetPos( 310, 100 )

	local panr = vgui.Create( "DPanPanel", dpr )
	panr:Dock( FILL )

	local br1 = panr:Add( "DButton" )
	br1:SetText( "Big" )

	local br2 = panr:Add( "DButton" )
	br2:SetPos( 300, 300 )
	br2:SetText( "Contents" )

end

derma.DefineControl( "DPanPanel", "", PANEL, "DPanel" )
