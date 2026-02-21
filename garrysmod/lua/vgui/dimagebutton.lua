
local PANEL = {}
AccessorFunc( PANEL, "m_bStretchToFit", "StretchToFit" )
AccessorFunc( PANEL, "m_bDepressImage", "DepressImage" )

function PANEL:Init()

	self:SetPaintBackground( false )
	self:SetDrawBorder( false )
	self:SetStretchToFit( true )
	self:SetDepressImage( true )

	self:SetCursor( "hand" )
	self.m_Image = vgui.Create( "DImage", self )

	self:SetText( "" )

	self:SetColor( color_white )

end

--
-- SetImageVisible
-- Hide the button's image
--
function PANEL:SetImageVisible( bBool )

	self.m_Image:SetVisible( bBool )

end

function PANEL:SetImage( strImage, strBackup )

	self.m_Image:SetImage( strImage, strBackup )

end
PANEL.SetIcon = PANEL.SetImage

function PANEL:SetColor( col )

	self.m_Image:SetImageColor( col )
	self.ImageColor = col

end

function PANEL:GetImage()

	return self.m_Image:GetImage()

end

function PANEL:SetKeepAspect( bKeep )

	self.m_Image:SetKeepAspect( bKeep )

end

-- SetMaterial should replace SetImage for cached materials
function PANEL:SetMaterial( Mat )

	self.m_Image:SetMaterial( Mat )

end

function PANEL:SizeToContents()

	self.m_Image:SizeToContents()
	self:SetSize( self.m_Image:GetWide(), self.m_Image:GetTall() )

end

function PANEL:DepressImage()

	if ( !self.m_bDepressImage ) then return end

	self.m_bImageDepressed = true

	if ( self.m_bStretchToFit ) then

		self.m_Image:SetPos( 2, 2 )
		self.m_Image:SetSize( self:GetWide() - 4, self:GetTall() - 4 )

	else

		self.m_Image:SizeToContents()
		self.m_Image:SetSize( self.m_Image:GetWide() * 0.8, self.m_Image:GetTall() * 0.8 )
		self.m_Image:Center()

	end

end

function PANEL:OnMousePressed( mousecode )

	DButton.OnMousePressed( self, mousecode )

	self:DepressImage()

end

function PANEL:OnMouseReleased( mousecode )

	DButton.OnMouseReleased( self, mousecode )

	self.m_bImageDepressed = nil
	self:InvalidateLayout()

end

function PANEL:PerformLayout()

	if ( self.m_bDepressImage && self.m_bImageDepressed ) then

		self:DepressImage()

	elseif ( self.m_bStretchToFit ) then

		self.m_Image:SetPos( 0, 0 )
		self.m_Image:SetSize( self:GetSize() )

	else

		self.m_Image:SizeToContents()
		self.m_Image:Center()

	end

end

function PANEL:SetDisabled( bDisabled )

	DButton.SetDisabled( self, bDisabled )

	if ( bDisabled ) then
		self.m_Image:SetAlpha( self.ImageColor.a * 0.4 )
	else
		self.m_Image:SetAlpha( self.ImageColor.a )
	end

end

function PANEL:SetOnViewMaterial( MatName, Backup )

	self.m_Image:SetOnViewMaterial( MatName, Backup )

end

function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local ctrl = vgui.Create( ClassName )
	ctrl:SetImage( "gui/dupe_bg.png" )
	ctrl:SetSize( 200, 200 )

	PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )

end

derma.DefineControl( "DImageButton", "A button which uses an image instead of text", PANEL, "DButton" )
