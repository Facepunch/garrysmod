
PANEL.Base = "DPanel"

local matWorkshopRocket = Material( "gui/workshop_rocket.png", "nocull smooth" )

function PANEL:Init()

	self:SetSize( 64, 64 )
	self.Size = 64

end

--[[
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
]]

function PANEL:Paint( wide, tall )

	local matAddonIcon = self.Material
	if ( !matAddonIcon ) then return end

	local size = self.Size
	local sizeDouble = size * 2

	DisableClipping( true )

		wide = wide * 0.5
		tall = tall * 0.5

		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( matWorkshopRocket )
		surface.DrawTexturedRectRotated( wide, tall, sizeDouble, sizeDouble, 0 )

		surface.SetMaterial( matAddonIcon )
		surface.DrawTexturedRectRotated( wide, tall, size, size, 0 )

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
