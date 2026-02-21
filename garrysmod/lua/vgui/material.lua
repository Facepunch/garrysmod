
local PANEL = {}

function PANEL:Init()

	self.Material = nil
	self.AutoSize = true
	self:SetAlpha( 255 )

	self:SetMouseInputEnabled( false )
	self:SetKeyboardInputEnabled( false )

end

function PANEL:Paint()

	if (!self.Material) then return true end

	surface.SetMaterial( self.Material )
	surface.SetDrawColor( 255, 255, 255, self.Alpha )
	surface.DrawTexturedRect( 0, 0, self:GetSize() )

	return true

end

function PANEL:SetAlpha( _alpha_ )

	self.Alpha = _alpha_

end

function PANEL:SetMaterial( _matname_ )

	--self.Material = surface.GetTextureID( _matname_ )

	self.Material = Material( _matname_ )
	local Texture = self.Material:GetTexture( "$basetexture" )
	if ( Texture ) then
		self.Width = Texture:Width()
		self.Height = Texture:Height()
	else
		self.Width = 32
		self.Height = 32
	end

	self:InvalidateLayout()

end

function PANEL:PerformLayout()

	if ( !self.Material ) then return end
	if ( !self.AutoSize ) then return end

	self:SetSize( self.Width, self.Height )

end

vgui.Register( "Material", PANEL, "Button" )
