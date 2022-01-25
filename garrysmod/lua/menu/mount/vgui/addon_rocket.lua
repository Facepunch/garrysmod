
PANEL.Base = "DPanel"

local matWorkshopRocket = Material( "gui/workshop_rocket.png", "nocull smooth" )

function PANEL:Init()

	self:SetSize( 64, 64 )
	self.Size = 64

end

function PANEL:Think()

	if ( self.Blasting ) then

		self.VelY = self.VelY - FrameTime()
		self.PosY = self.PosY + self.VelY * FrameTime() * 500

		self.VelX = self.VelX + FrameTime() * self.VelX
		self.PosX = self.PosX + self.VelX * FrameTime() * 500

		self:SetPos( self.PosX, self.PosY )

		if ( self.PosY < -70 ) then self:Remove() end

	end

end

function PANEL:Paint()

	if ( !self.Material ) then return end

	local angle = 0

	DisableClipping( true )

		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( matWorkshopRocket )
		surface.DrawTexturedRectRotated( self:GetWide() * 0.5, self:GetTall() * 0.5, self.Size * 2, self.Size * 2, angle )

		if ( self.Material ) then

			surface.SetMaterial( self.Material )
			surface.DrawTexturedRectRotated( self:GetWide() * 0.5, self:GetTall() * 0.5, self.Size, self.Size, angle )

		end

	DisableClipping( false )

end


function PANEL:Charging( id, iImageID )

	self.Material = nil

	steamworks.Download( iImageID, false, function( name )

		if ( name == nil ) then return end
		if ( !IsValid( self ) ) then return end

		self.Material = AddonMaterial( name )

	end)

end

function PANEL:Blast()

	self:Remove()

end
