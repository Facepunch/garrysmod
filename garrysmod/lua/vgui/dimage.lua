
local PANEL = {}

AccessorFunc( PANEL, "m_Material",				"Material" )
AccessorFunc( PANEL, "m_Color",					"ImageColor" )
AccessorFunc( PANEL, "m_bKeepAspect",			"KeepAspect" )
AccessorFunc( PANEL, "m_strMatName",			"MatName" )
AccessorFunc( PANEL, "m_strMatNameFailsafe",	"FailsafeMatName" )

function PANEL:Init()

	self:SetImageColor( color_white )
	self:SetMouseInputEnabled( false )
	self:SetKeyboardInputEnabled( false )

	self:SetKeepAspect( false )

	self.ImageName = ""

	self.ActualWidth = 10
	self.ActualHeight = 10

end

function PANEL:SetOnViewMaterial( MatName, MatNameBackup )

	self:SetMatName( MatName )
	self:SetFailsafeMatName( MatNameBackup )
	self.ImageName = MatName

end

function PANEL:Unloaded()
	return self.m_strMatName != nil
end

function PANEL:LoadMaterial()

	if ( !self:Unloaded() ) then return end

	self:DoLoadMaterial()

	self:SetMatName( nil )

end

function PANEL:DoLoadMaterial()

	local mat = Material( self:GetMatName() )
	self:SetMaterial( mat )

	if ( self.m_Material:IsError() && self:GetFailsafeMatName() ) then
		self:SetMaterial( Material( self:GetFailsafeMatName() ) )
	end

	self:FixVertexLitMaterial()

	--
	-- This isn't ideal, but it will probably help you out of a jam
	-- in cases where you position the image according to the texture
	-- size and you want to load on view - instead of on load.
	--
	self:InvalidateParent()

end

function PANEL:SetMaterial( Mat )

	-- Everybody makes mistakes,
	-- that's why they put erasers on pencils.
	if ( isstring( Mat ) ) then
		self:SetImage( Mat )
		return
	end

	self.m_Material = Mat

	if ( !self.m_Material ) then return end

	local Texture = self.m_Material:GetTexture( "$basetexture" )
	if ( Texture ) then
		self.ActualWidth = Texture:Width()
		self.ActualHeight = Texture:Height()
	else
		self.ActualWidth = self.m_Material:Width()
		self.ActualHeight = self.m_Material:Height()
	end

end

function PANEL:SetImage( strImage, strBackup )

	if ( strBackup && !file.Exists( "materials/" .. strImage .. ".vmt", "GAME" ) && !file.Exists( "materials/" .. strImage, "GAME" ) ) then
		strImage = strBackup
	end

	self.ImageName = strImage

	local Mat = Material( strImage )
	self:SetMaterial( Mat )
	self:FixVertexLitMaterial()

end

function PANEL:GetImage()

	return self.ImageName

end

function PANEL:FixVertexLitMaterial()

	--
	-- If it's a vertexlitgeneric material we need to change it to be
	-- UnlitGeneric so it doesn't go dark when we enter a dark room
	-- and flicker all about
	--

	local Mat = self:GetMaterial()
	local strImage = Mat:GetName()

	if ( string.find( Mat:GetShader(), "VertexLitGeneric" ) || string.find( Mat:GetShader(), "Cable" ) ) then

		local t = Mat:GetString( "$basetexture" )

		if ( t ) then

			local params = {}
			params[ "$basetexture" ] = t
			params[ "$vertexcolor" ] = 1
			params[ "$vertexalpha" ] = 1

			Mat = CreateMaterial( strImage .. "_DImage", "UnlitGeneric", params )

		end

	end

	self:SetMaterial( Mat )

end

function PANEL:SizeToContents( strImage )

	self:SetSize( self.ActualWidth, self.ActualHeight )

end

function PANEL:Paint()

	self:PaintAt( 0, 0, self:GetWide(), self:GetTall() )

end

function PANEL:PaintAt( x, y, dw, dh )
	dw, dh = dw or self:GetWide(), dh or self:GetTall()
	self:LoadMaterial()

	if ( !self.m_Material ) then return true end

	surface.SetMaterial( self.m_Material )
	surface.SetDrawColor( self.m_Color.r, self.m_Color.g, self.m_Color.b, self.m_Color.a )

	if ( self:GetKeepAspect() ) then

		local w = self.ActualWidth
		local h = self.ActualHeight

		-- Image is bigger than panel, shrink to suitable size
		if ( w > dw && h > dh ) then

			if ( w > dw ) then

				local diff = dw / w
				w = w * diff
				h = h * diff

			end

			if ( h > dh ) then

				local diff = dh / h
				w = w * diff
				h = h * diff

			end

		end

		if ( w < dw ) then

			local diff = dw / w
			w = w * diff
			h = h * diff

		end

		if ( h < dh ) then

			local diff = dh / h
			w = w * diff
			h = h * diff

		end

		local OffX = ( dw - w ) * 0.5
		local OffY = ( dh - h ) * 0.5

		surface.DrawTexturedRect( OffX + x, OffY + y, w, h )

		return true

	end

	surface.DrawTexturedRect( x, y, dw, dh )
	return true

end

function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local ctrl = vgui.Create( ClassName )
	ctrl:SetImage( "brick/brick_model" )
	ctrl:SetSize( 200, 200 )

	PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )

end

derma.DefineControl( "DImage", "A simple image", PANEL, "DPanel" )
