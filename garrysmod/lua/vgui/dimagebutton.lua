--[[   _
    ( )
   _| |   __   _ __   ___ ___     _ _
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_)

	DImageButton

--]]

PANEL = {}
AccessorFunc( PANEL, "m_bStretchToFit", 			"StretchToFit" )

--[[---------------------------------------------------------
   Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

	self:SetDrawBackground( false )
	self:SetDrawBorder( false )
	self:SetStretchToFit( true )

	self:SetCursor( "hand" )
	self.m_Image = vgui.Create( "DImage", self )

	self:SetText( "" )

	self:SetColor( Color( 255, 255, 255, 255 ) )

end

--[[---------------------------------------------------------
   Name: SetImageVisible
   Desc: Hide the button's image
-----------------------------------------------------------]]
function PANEL:SetImageVisible( bBool )

	self.m_Image:SetVisible( bBool )

end

--[[---------------------------------------------------------
   Name: SetImage
-----------------------------------------------------------]]
function PANEL:SetImage( strImage, strBackup )

	self.m_Image:SetImage( strImage, strBackup )

end

--[[---------------------------------------------------------
   Name: SetIcon / SetMaterial
   Desc: This makes it compatible with the older ImageButton
-----------------------------------------------------------]]
PANEL.SetIcon = PANEL.SetImage
PANEL.SetMaterial = PANEL.SetImage

--[[---------------------------------------------------------
   Name: SetColor
-----------------------------------------------------------]]
function PANEL:SetColor( col )

	self.m_Image:SetImageColor( col )
	self.ImageColor = col

end

--[[---------------------------------------------------------
   Name: GetImage
-----------------------------------------------------------]]
function PANEL:GetImage()

	return self.m_Image:GetImage()

end

--[[---------------------------------------------------------
   Name: SetKeepAspect
-----------------------------------------------------------]]
function PANEL:SetKeepAspect( bKeep )

	self.m_Image:SetKeepAspect( bKeep )

end


--[[---------------------------------------------------------
   Name: SizeToContents
-----------------------------------------------------------]]
function PANEL:SizeToContents( )

	self.m_Image:SizeToContents()
	self:SetSize( self.m_Image:GetWide(), self.m_Image:GetTall() )

end

--[[---------------------------------------------------------
   Name: OnMousePressed
-----------------------------------------------------------]]
function PANEL:OnMousePressed( mousecode )

	DButton.OnMousePressed( self, mousecode )


	if ( self.m_bStretchToFit ) then

		self.m_Image:SetPos( 2, 2 )
		self.m_Image:SetSize( self:GetWide() - 4, self:GetTall() - 4 )

	else

		self.m_Image:SizeToContents()
		self.m_Image:SetSize( self.m_Image:GetWide() * 0.8, self.m_Image:GetTall() * 0.8 )
		self.m_Image:Center()

	end

end

--[[---------------------------------------------------------
   Name: OnMouseReleased
-----------------------------------------------------------]]
function PANEL:OnMouseReleased( mousecode )

	DButton.OnMouseReleased( self, mousecode )

	if ( self.m_bStretchToFit ) then

		self.m_Image:SetPos( 0, 0 )
		self.m_Image:SetSize( self:GetSize() )

	else

		self.m_Image:SizeToContents()
		self.m_Image:Center()

	end

end

--[[---------------------------------------------------------
   Name: PerformLayout
-----------------------------------------------------------]]
function PANEL:PerformLayout()

	if ( self.m_bStretchToFit ) then

		self.m_Image:SetPos( 0, 0 )
		self.m_Image:SetSize( self:GetSize() )

	else

		self.m_Image:SizeToContents()
		self.m_Image:Center()

	end

end

--[[---------------------------------------------------------
   Name: SetDisabled
-----------------------------------------------------------]]
function PANEL:SetDisabled( bDisabled )

	DButton.SetDisabled( self, bDisabled )

	if ( bDisabled ) then
		self.m_Image:SetAlpha( self.ImageColor.a * 0.4 )
	else
		self.m_Image:SetAlpha( self.ImageColor.a )
	end

end

--[[---------------------------------------------------------
   Name: SetOnViewMaterial
-----------------------------------------------------------]]
function PANEL:SetOnViewMaterial( MatName, Backup )

	self.m_Image:SetOnViewMaterial( MatName, Backup )

end

--[[---------------------------------------------------------
   Name: GenerateExample
-----------------------------------------------------------]]
function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local ctrl = vgui.Create( ClassName )
		ctrl:SetImage( "brick/brick_model" )
		ctrl:SetSize( 200, 200 )

	PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )

end

derma.DefineControl( "DImageButton", "A button which uses an image instead of text", PANEL, "DButton" )