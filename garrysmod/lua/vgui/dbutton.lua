--[[   _
	( )
   _| |   __   _ __   ___ ___     _ _
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_)

	DButton

--]]

local PANEL = {}

AccessorFunc( PANEL, "m_bBorder", "DrawBorder", FORCE_BOOL )

function PANEL:Init()

	self:SetContentAlignment( 5 )
	
	--
	-- These are Lua side commands
	-- Defined above using AccessorFunc
	--
	self:SetDrawBorder( true )
	self:SetDrawBackground( true )

	self:SetTall( 22 )
	self:SetMouseInputEnabled( true )
	self:SetKeyboardInputEnabled( true )

	self:SetCursor( "hand" )
	self:SetFont( "DermaDefault" )

end

--[[---------------------------------------------------------
	IsDown
-----------------------------------------------------------]]
function PANEL:IsDown()

	return self.Depressed

end

--[[---------------------------------------------------------
	SetImage
-----------------------------------------------------------]]
function PANEL:SetImage( img )

	if ( !img ) then
	
		if ( IsValid( self.m_Image ) ) then
			self.m_Image:Remove()
		end
	
		return
	end

	if ( !IsValid( self.m_Image ) ) then
		self.m_Image = vgui.Create( "DImage", self )
	end
	
	self.m_Image:SetImage( img )
	self.m_Image:SizeToContents()
	self:InvalidateLayout()

end

PANEL.SetIcon = PANEL.SetImage

function PANEL:Paint( w, h )

	derma.SkinHook( "Paint", "Button", self, w, h )

	--
	-- Draw the button text
	--
	return false

end

--[[---------------------------------------------------------
	UpdateColours
-----------------------------------------------------------]]
function PANEL:UpdateColours( skin )

	if ( self:GetDisabled() )					then return self:SetTextStyleColor( skin.Colours.Button.Disabled ) end
	if ( self.Depressed || self.m_bSelected )	then return self:SetTextStyleColor( skin.Colours.Button.Down ) end
	if ( self.Hovered )							then return self:SetTextStyleColor( skin.Colours.Button.Hover ) end

	return self:SetTextStyleColor( skin.Colours.Button.Normal )

end

--[[---------------------------------------------------------
   Name: PerformLayout
-----------------------------------------------------------]]
function PANEL:PerformLayout()
	
	--
	-- If we have an image we have to place the image on the left
	-- and make the text align to the left, then set the inset
	-- so the text will be to the right of the icon.
	--
	if ( IsValid( self.m_Image ) ) then
		
		self.m_Image:SetPos( 4, ( self:GetTall() - self.m_Image:GetTall() ) * 0.5 )
		
		self:SetTextInset( self.m_Image:GetWide() + 16, 0 )
	
	end

	DLabel.PerformLayout( self )

end

--[[---------------------------------------------------------
	SetDisabled
-----------------------------------------------------------]]
function PANEL:SetDisabled( bDisabled )

	self.m_bDisabled = bDisabled
	self:InvalidateLayout()

end

-- Override the default engine method, so it actually does something for DButton
function PANEL:SetEnabled( bEnabled )

	self.m_bDisabled = !bEnabled
	self:InvalidateLayout()

end

--[[---------------------------------------------------------
	Name: SetConsoleCommand
-----------------------------------------------------------]]
function PANEL:SetConsoleCommand( strName, strArgs )

	self.DoClick = function( self, val ) 
		RunConsoleCommand( strName, strArgs ) 
	end

end

--[[---------------------------------------------------------
	Name: GenerateExample
-----------------------------------------------------------]]
function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local ctrl = vgui.Create( ClassName )
	ctrl:SetText( "Example Button" )
	ctrl:SetWide( 200 )
	
	PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )

end

--[[---------------------------------------------------------
	OnMousePressed
-----------------------------------------------------------]]
function PANEL:OnMousePressed( mousecode )

	return DLabel.OnMousePressed( self, mousecode )

end

--[[---------------------------------------------------------
	OnMouseReleased
-----------------------------------------------------------]]
function PANEL:OnMouseReleased( mousecode )

	return DLabel.OnMouseReleased( self, mousecode )

end

local PANEL = derma.DefineControl( "DButton", "A standard Button", PANEL, "DLabel" )

PANEL = table.Copy( PANEL )

--[[---------------------------------------------------------
	Name: SetActionFunction
-----------------------------------------------------------]]
function PANEL:SetActionFunction( func )

	self.DoClick = function( self, val ) func( self, "Command", 0, 0 ) end

end

-- No example for this control. Should we remove this completely?
function PANEL:GenerateExample( class, tabs, w, h )
end

derma.DefineControl( "Button", "Backwards Compatibility", PANEL, "DLabel" )
