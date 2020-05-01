
local PANEL = {}

AccessorFunc( PANEL, "m_bBorder", "DrawBorder", FORCE_BOOL )

function PANEL:Init()

	self:SetContentAlignment( 5 )

	--
	-- These are Lua side commands
	-- Defined above using AccessorFunc
	--
	self:SetDrawBorder( true )
	self:SetPaintBackground( true )

	self:SetTall( 22 )
	self:SetMouseInputEnabled( true )
	self:SetKeyboardInputEnabled( true )

	self:SetCursor( "hand" )
	self:SetFont( "DermaDefault" )

end

function PANEL:IsDown()

	return self.Depressed

end

function PANEL:SetImage( img )

	if ( !img ) then

		if ( IsValid( self.m_Image ) ) then
			self.m_Image:Remove()
		end

		return
	end

	self:SetColorIcon()
	self:SetAvatarIcon()

	if ( !IsValid( self.m_Image ) ) then
		self.m_Image = vgui.Create( "DImage", self )
	end

	self.m_Image:SetImage( img )
	self.m_Image:SizeToContents()
	self:InvalidateLayout()

end
PANEL.SetIcon = PANEL.SetImage

local function ColorIconPaint( self, w, h )

	if ( self.m_ColorIcon ) then

		surface.SetDrawColor( self.m_ColorIcon )
		surface.DrawRect( 0, 0, w, h )

	end

end

function PANEL:SetColorIcon( color )

	if ( !color ) then

		self:SetImage()

	else

		assert( IsColor( color ), "Expected a color but " .. type(color) .. " was passed" )
		
		self:SetAvatarIcon() -- Remove avatar icon first if it exists

		self:SetImage( "icon16/box.png" )

		self.m_Image.m_ColorIcon = color
		self.m_ColorIcon = self.m_Image.m_ColorIcon
		
		self.m_Image.PaintOver = ColorIconPaint

	end

end

function PANEL:SetAvatarIcon( steamid64 )

	if ( !steamid64 ) then

		self:SetImage()

	else

		local steamid64 = ( isentity( steamid64 ) && steamid64:IsPlayer() && steamid64:SteamID64() ) || steamid64 -- If the passed steamid64 is a player object, grab the steamid64 for convenience
		
		self:SetColorIcon() -- Remove color icon first if it exists

		self:SetImage( "icon16/user.png" )

		self.m_Image.m_AvatarImage = vgui.Create( "AvatarImage", self.m_Image )
		self.m_Image.m_AvatarImage:Dock( FILL )
		self.m_Image.m_AvatarImage:SetSteamID( steamid64, 16 )

		self.m_Image.m_AvatarImage.SteamID64 = steamid64

	end

end

function PANEL:Paint( w, h )

	derma.SkinHook( "Paint", "Button", self, w, h )

	--
	-- Draw the button text
	--
	return false

end

function PANEL:UpdateColours( skin )

	if ( !self:IsEnabled() )					then return self:SetTextStyleColor( skin.Colours.Button.Disabled ) end
	if ( self:IsDown() || self.m_bSelected )	then return self:SetTextStyleColor( skin.Colours.Button.Down ) end
	if ( self.Hovered )							then return self:SetTextStyleColor( skin.Colours.Button.Hover ) end

	return self:SetTextStyleColor( skin.Colours.Button.Normal )

end

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

function PANEL:SetConsoleCommand( strName, strArgs )

	self.DoClick = function( self, val )
		RunConsoleCommand( strName, strArgs )
	end

end

function PANEL:SizeToContents()
	local w, h = self:GetContentSize()
	self:SetSize( w + 8, h + 4 )
end

function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local ctrl = vgui.Create( ClassName )
	ctrl:SetText( "Example Button" )
	ctrl:SetWide( 200 )

	PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )

end

local PANEL = derma.DefineControl( "DButton", "A standard Button", PANEL, "DLabel" )

PANEL = table.Copy( PANEL )

function PANEL:SetActionFunction( func )

	self.DoClick = function( self, val ) func( self, "Command", 0, 0 ) end

end

-- No example for this control. Should we remove this completely?
function PANEL:GenerateExample( class, tabs, w, h )
end

derma.DefineControl( "Button", "Backwards Compatibility", PANEL, "DLabel" )
