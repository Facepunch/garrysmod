local PANEL = {}

AccessorFunc( PANEL, "pnlCanvas", 	"Canvas" )

function PANEL:Init()
	
	self.pnlCanvas = vgui.Create( "Panel", self )
	self:GetCanvas().OnMousePressed = function( self, code ) self:GetParent():OnMousePressed( code ) end
	self:GetCanvas():SetMouseInputEnabled( true )
	self:GetCanvas().PerformLayout = function( pnl )
		
		self:PerformLayout()
		self:InvalidateParent()
		
	end
	
	function self.pnlCanvas:Think()
		
		local mousex = math.Clamp( gui.MouseX(), 1, ScrW()-1 )
		local mousey = math.Clamp( gui.MouseY(), 1, ScrH()-1 )
		
		if ( self.Dragging ) then
			
			local x = mousex - self.Dragging[1]
			local y = mousey - self.Dragging[2]
			self:SetPos( x, y )
			
		end
		
		if ( self.Hovered ) then
			self:SetCursor( "sizeall" )
			return
		end
		
		self:SetCursor( "arrow" )
	end
	
	function self.pnlCanvas:OnMousePressed()
		self.Dragging = { gui.MouseX() - self.x, gui.MouseY() - self.y }
		self:MouseCapture( true )
	end
	
	function self.pnlCanvas:OnMouseReleased()
		
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

function PANEL:AddItem( pnl )
	
	pnl:SetParent( self:GetCanvas() )
	
end

function PANEL:OnChildAdded( child )
	
	self:AddItem( child )
	
end

function PANEL:SizeToContents()
	
	self:SetSize( self:GetCanvas():GetSize() )
	
end

function PANEL:GetCanvas()
	
	return self.pnlCanvas
	
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
	
	self:OnScroll(x, y)
end

function PANEL:PerformLayout()
	if self:GetCanvas().Dragging then return end
	local can = self:GetCanvas()
	
	
	do --get it all top-left (so the children are snug)
		local mx, my
		for _, p in pairs(can:GetChildren()) do
			local x, y = p:GetPos()
			mx = mx or x
			my = my or y
			if x < mx then
				mx = x
			end
			if y < my then
				my = y
			end
		end
		if mx then
			for _, p in pairs(can:GetChildren()) do
				local x, y = p:GetPos()
				p:SetPos(x - mx, y - my)
			end
		end
		local x, y = can:GetPos()
		can:SetPos(x + mx, y + my)
	end
	can:SizeToChildren( true, true )
	
	do --restrict movement
		local x, y, w, h = can:GetBounds()
		if w > self:GetWide() then
			if x > 0 then --right
				can:SetPos(0, y)
				x = 0
			end
			if x + w < self:GetWide() then
				local nx = self:GetWide() - w
				can:SetPos(nx, y)
				x = nx
			end
		end
		if w < self:GetWide() then
			if x < 0 then --left
				can:SetPos(0, y)
				x = 0
			end
			if x + w > self:GetWide() then
				local nx = self:GetWide() - w
				can:SetPos(nx, y)
				x = nx
			end
		end
		if h > self:GetTall() then
			if y > 0 then --up
				can:SetPos(x, 0)
				y = 0
			end
			if y + h < self:GetTall() then
				local ny = self:GetTall() - h
				can:SetPos(x, ny)
				y = ny
			end
		end
		if h < self:GetTall() then
			if y < 0 then --down
				can:SetPos(x, 0)
				y = 0
			end
			if y + h > self:GetTall() then
				local ny = self:GetTall() - h
				can:SetPos(x, ny)
				y = ny
			end
		end
	end
	
	do --fill edges
		local x, y, w, h = can:GetBounds()
		if w < self:GetWide() then
			if x > 0 then
				for _, p in pairs(can:GetChildren()) do
					local px, py = p:GetPos()
					p:SetPos(px + x, py)
				end
				can:SetPos(0, y)
				can:SetWide(w + x)
				if self.Dragging then
					self.Dragging[1] = self.Dragging[1] + x
				end
				w = w + x
				x = 0
			end
			if x + w < self:GetWide() then
				can:SetWide(self:GetWide())
				w = self:GetWide()
			end
			if y > 0 then
				for _, p in pairs(can:GetChildren()) do
					local px, py = p:GetPos()
					p:SetPos(px, py + y)
				end
				can:SetPos(x, 0)
				can:SetTall(h + y)
				if self.Dragging then
					self.Dragging[2] = self.Dragging[2] + y
				end
				h = h + y
				y = 0
			end
			if y + h < self:GetTall() then
				can:SetTall(self:GetTall())
				h = self:GetTall()
			end
		end
	end
end

function PANEL:Clear()
	
	return self:GetCanvas():Clear()
	
end


derma.DefineControl( "DPanPanel", "", PANEL, "DPanel" )
