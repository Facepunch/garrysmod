
local PANEL = {}

function PANEL:Init()

	self:SetEnabled( true )
	self:SetScroll( 0 )
	self:SetBarScale( 4 )

	self.Velocity = 0
	self.HasChanged = true

end

function PANEL:SetEnabled( b )

	self.Enabled = b

	if ( !b ) then

		self:SetScroll( 0 )
		self.HasChanged = true

	end

	self:SetMouseInputEnabled( b )

end

function PANEL:SetScroll( _float_ )

	self.Pos = math.Clamp( _float_, 0, 1 )
end

function PANEL:Value()

	return self.Pos

end

function PANEL:SetBarScale( _scale_ )

	self.BarScale = _scale_
	self:SetEnabled( self.BarScale > 1 )

end

function PANEL:Rebuild( item )

	local Offset = 0

	if ( self.Horizontal ) then

		local x, y = 0, 0
		for k, panel in pairs( self.Items ) do

			local w = panel:GetWide()
			local h = panel:GetTall()

			if ( x + w > self:GetWide() ) then

				x = 0
				y = y + h + self.Spacing

			end

			panel:SetPos( x, y )

			x = x + w + self.Spacing
			Offset = y + h + self.Spacing

		end

	else

		for k, panel in pairs( self.Items ) do

			panel:SetSize( self:GetCanvas():GetWide(), panel:GetTall() )
			panel:SetPos( 0, Offset )
			Offset = Offset + panel:GetTall() + self.Spacing

		end

	end

	self:GetCanvas():SetSize( self:GetCanvas():GetWide(), Offset + self.Padding * 2 - self.Spacing )

end

function PANEL:OnMouseWheeled( dlta )

	if ( !self.Enabled ) then return end

	self:AddVelocity( dlta )
	return true

end

function PANEL:AddVelocity( vel )

	self.Velocity = self.Velocity + vel * -2

end

function PANEL:Changed()

	if ( self.HasChanged ) then
		self.HasChanged = nil
		return true
	end

	return false

end

function PANEL:ScrollbarSize()

	return self:GetTall() / self.BarScale

end

function PANEL:Think()

	if ( self.Dragging ) then

		-- Accumulate Velocity
		local PixelDiff = ( gui.MouseY() - self.StartDraggingPos ) * self.DragDirection
		self.Velocity = ( self.Velocity + PixelDiff ) / 2

		-- Scroll
		local Span = self:GetTall() - self:ScrollbarSize()
		self.Pos = self.Pos * Span + PixelDiff
		self:SetScroll( self.Pos / Span )
		self.HasChanged = true

		self.StartDraggingPos = gui.MouseY()
		self.Dragging = 2

		return
	end

	if ( self.Velocity != 0 ) then

		self.HasChanged = true
		self.Pos = self.Pos + ( self.Velocity / self.BarScale ) * FrameTime()
		self.Velocity = math.Approach( self.Velocity, 0, FrameTime() * self.Velocity * 10 )

		if ( self.Pos < 0 || self.Pos > 1 ) then

			--self.Velocity = self.Velocity * -0.5
			self.Velocity = 0
			self.Pos = math.Clamp( self.Pos, 0, 1 )

		end

	end

end

function PANEL:Paint()

	if ( !self.Enabled || self.BarScale <= 0 ) then	return true	end

	draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 200, 200, 200, 100 ) )

	local Pos = ( self:GetTall() - self:ScrollbarSize() ) * self.Pos
	draw.RoundedBox( 4, 2, Pos + 2, self:GetWide() - 4, self:ScrollbarSize() - 4, Color( 0, 0, 0, 200 ) )

	return true

end

function PANEL:OnMousePressed()

	self:RequestFocus()
	self:Grip( 1 )

end

function PANEL:Grip( direction )

	if ( !self.Enabled ) then return end

	self:MouseCapture( true )
	self.DragDirection = direction || ( -1 / self.BarScale )
	self.Dragging = 1
	self.Velocity = 0
	self.StartDraggingPos = gui.MouseY()

end

function PANEL:OnMouseReleased()

	self:MouseCapture( false )
	self.Dragging = nil

end

vgui.Register( "SlideBar", PANEL, "Panel" )
