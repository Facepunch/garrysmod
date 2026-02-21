
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

	if ( !IsValid( self.m_Image ) ) then
		self.m_Image = vgui.Create( "DImage", self )
	end

	self.m_Image:SetImage( img )
	self.m_Image:SizeToContents()
	self:InvalidateLayout()

end
PANEL.SetIcon = PANEL.SetImage

function PANEL:SetMaterial( mat )

	if ( !mat ) then

		if ( IsValid( self.m_Image ) ) then
			self.m_Image:Remove()
		end

		return
	end

	if ( !IsValid( self.m_Image ) ) then
		self.m_Image = vgui.Create( "DImage", self )
	end

	self.m_Image:SetMaterial( mat )
	self.m_Image:SizeToContents()
	self:InvalidateLayout()

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

function PANEL:PerformLayoutImage()
	--
	-- If we have an image we have to place the image on the left
	-- and make the text align to the left, then set the inset
	-- so the text will be to the right of the icon.
	--
	if ( IsValid( self.m_Image ) ) then

		local targetSize = math.min( self:GetWide() - 4, self:GetTall() - 4 )

		local imgW, imgH = self.m_Image.ActualWidth, self.m_Image.ActualHeight
		local zoom = math.min( targetSize / imgW, targetSize / imgH, 1 )
		local newSizeX = math.ceil( imgW * zoom )
		local newSizeY = math.ceil( imgH * zoom )

		self.m_Image:SetWide( newSizeX )
		self.m_Image:SetTall( newSizeY )

		if ( self:GetWide() < self:GetTall() ) then
			self.m_Image:SetPos( 4, ( self:GetTall() - self.m_Image:GetTall() ) * 0.5 )
		else
			self.m_Image:SetPos( 2 + ( targetSize - self.m_Image:GetWide() ) * 0.5, ( self:GetTall() - self.m_Image:GetTall() ) * 0.5 )
		end

		-- For center alignments, reduce the inset of the image, so the text appears more centered visually
		local alignment = self:GetContentAlignment()
		if ( alignment == 8 || alignment == 5 || alignment == 2 ) then
			self:SetTextInset( self.m_Image:GetWide() + 4, 0 )
		else
			self:SetTextInset( self.m_Image:GetWide() + 8, 0 )
		end

	end
end

function PANEL:PerformLayout( w, h )

	self:PerformLayoutImage()

	DLabel.PerformLayout( self, w, h )

end

function PANEL:SetConsoleCommand( strName, strArg, ... )

	if ( select( "#", ... ) > 0 ) then
		local extraArgs = { ... }
		self.DoClick = function( slf, val )
			RunConsoleCommand( strName, strArg, unpack( extraArgs ) )
		end
		return
	end

	self.DoClick = function( slf, val )
		RunConsoleCommand( strName, strArg )
	end

end

function PANEL:SizeToContents()
	self:PerformLayoutImage() -- Set the text inset first.
	local w, h = self:GetContentSize()

	self:SetSize( w + 8, h + 4 )
end

function PANEL:SizeToContentsX( addVal )
	self:PerformLayoutImage() -- Set the text inset first.
	local w, h = self:GetContentSize()

	self:SetWide( w + 8 + ( addVal or 0 ) )
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

	self.DoClick = function( slf, val ) func( slf, "Command", 0, 0 ) end

end

-- No example for this control. Should we remove this completely?
function PANEL:GenerateExample( class, tabs, w, h )
end

derma.DefineControl( "Button", "Backwards Compatibility", PANEL, "DLabel" )
