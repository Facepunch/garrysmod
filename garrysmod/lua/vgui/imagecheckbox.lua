
local PANEL = {}

function PANEL:SetMaterial( On )

	if ( self.MatOn ) then
		self.MatOn:Remove()
	end

	self.MatOn = vgui.Create( "Material", self )
	self.MatOn:SetSize( 16, 16 )
	self.MatOn:SetMaterial( On )

	self:PerformLayout()

end

function PANEL:Set( OnOff )

	if ( self.State == OnOff ) then return end
	self.MatOn:SetVisible( OnOff )
	self.State = OnOff

end

function PANEL:DoClick()

	self:Set( !self.State )

end

function PANEL:SizeToContents()

	if ( self.MatOn ) then
		self:SetSize( self.MatOn:GetWide(), self.MatOn:GetTall() )
	end

	self:InvalidateLayout()

end

function PANEL:Paint()

	draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 50 ) )
	return true

end

function PANEL:PerformLayout()

	self.MatOn:SetPos( ( self:GetWide() - self.MatOn:GetWide() ) / 2, ( self:GetTall() - self.MatOn:GetTall() ) / 2 )

end

vgui.Register( "ImageCheckBox", PANEL, "Button" )
