
local PANEL = {}

function PANEL:Init()

	self.pnlCanvas = vgui.Create( "Panel", self )
	self.Items = {}
	self.YOffset = 0

	self:SetSpacing( 0 )
	self:SetPadding( 4 )
	self:EnableHorizontal( false )

	self.BackgroundColor = Color( 0, 0, 0, 200 )

end

function PANEL:EnableHorizontal( bHoriz )

	self.Horizontal = bHoriz

end

function PANEL:EnableVerticalScrollbar()

	if ( IsValid( self.VBar ) ) then return end

	self.VBar = vgui.Create( "SlideBar", self )
	self:InvalidateLayout()

end

function PANEL:GetCanvas()

	return self.pnlCanvas

end

function PANEL:Clear()

	for k, panel in pairs( self.Items ) do

		panel:Remove()

	end

	self.Items = {}

end

function PANEL:AddItem( item )

	item:SetParent( self:GetCanvas() )
	table.insert( self.Items, item )

	self:InvalidateLayout()

end

function PANEL:Rebuild()

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

	if ( IsValid( self.VBar ) ) then
		return self.VBar:AddVelocity( dlta )
	end

end

function PANEL:Paint()

	draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), self.BackgroundColor )
	return true

end

function PANEL:SetSpacing( _num_ )

	self.Spacing = _num_

end

function PANEL:SetPadding( _num_ )

	self.Padding = _num_

end

function PANEL:Think()

	if ( IsValid( self.VBar ) && self.VBar:Changed() ) then

		local MaxOffset = self.pnlCanvas:GetTall() - self:GetTall()
		self.YOffset = MaxOffset * self.VBar:Value()
		self:InvalidateLayout()

	end

end

function PANEL:PerformLayout()

	local Wide = self:GetWide()

	if ( IsValid( self.VBar ) ) then

		self.VBar:SetPos( self:GetWide() - 18, 2 )
		self.VBar:SetSize( 16, self:GetTall() - 4 )
		self.VBar:SetBarScale( self.pnlCanvas:GetTall() / self:GetTall() )

		if ( self.VBar.Enabled ) then Wide = Wide - 20 end

	end

	self.pnlCanvas:SetPos( self.Padding, self.YOffset * -1 + self.Padding )
	self.pnlCanvas:SetSize( Wide - self.Padding * 2, self.pnlCanvas:GetTall() )

	self:Rebuild()

end

function PANEL:OnMousePressed( mcode )

	if ( mcode == MOUSE_RIGHT && IsValid( self.VBar ) ) then
		self.VBar:Grip()
	end

end

vgui.Register( "PanelList", PANEL, "Panel" )
