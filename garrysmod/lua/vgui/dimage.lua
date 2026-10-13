
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

	local SubRectPos = self.m_Material:GetString( "$pos" )
	local SubRectSize = self.m_Material:GetString( "$size" )
	if ( SubRectPos && SubRectSize ) then
		self.SubRectPos = { string.match( SubRectPos, "([^%s]+)%s+([^%s]+)" ) }
		self.SubRectSize = { string.match( SubRectSize, "([^%s]+)%s+([^%s]+)" ) }

		-- HACK: try to avoid bordering texture areas leaking into ours
		self.SubRectPos[ 1 ] = self.SubRectPos[ 1 ] + 0.5
		self.SubRectPos[ 2 ] = self.SubRectPos[ 2 ] + 0.5
		self.SubRectSize[ 1 ] = self.SubRectSize[ 1 ] - 1
		self.SubRectSize[ 2 ] = self.SubRectSize[ 2 ] - 1
	else
		self.SubRectPos = nil
		self.SubRectSize = nil
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
	local strShader = Mat:GetShader():lower()
	if ( string.find( strShader, "vertexlitgeneric" ) or string.find( strShader, "lightmappedgeneric" ) or string.find( strShader, "cable" ) ) then

		local t = Mat:GetString( "$basetexture" )

		if ( t ) then

			local params = {}
			params[ "$basetexture" ] = t
			params[ "$vertexcolor" ] = 1
			params[ "$vertexalpha" ] = 1
			params[ "$pos" ] = Mat:GetString( "$pos" )
			params[ "$size" ] = Mat:GetString( "$size" )

			Mat = CreateMaterial( strImage .. "_DImage", "UnlitGeneric", params )

		end

	end

	self:SetMaterial( Mat )

end

function PANEL:SizeToContents()

	self:SetSize( self.ActualWidth, self.ActualHeight )

end

function PANEL:Paint( w, h )

	-- HACK: Gotta keep these "or"s for legacy addon code
	self:PaintAt( 0, 0, w or self:GetWide(), h or self:GetTall() )

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

		if ( self.SubRectSize ) then
			w = self.SubRectSize[1]
			h = self.SubRectSize[2]
		end

		if ( self.m_bKeepAspectFit ) then

			-- Fit the image within the panel while maintaining aspect ratio
			local scale = math.min( dw / w, dh / h )
			w = w * scale
			h = h * scale

		else

			-- Fill the image to the panel while maintaining aspect ratio
			local scale = math.max( dw / w, dh / h )
			w = w * scale
			h = h * scale

		end

		local OffX = ( dw - w ) * 0.5
		local OffY = ( dh - h ) * 0.5

		if ( self.SubRectPos && self.SubRectSize ) then

			-- Apply subrect offset and size
			local uS, vS, uE, vE =
				self.SubRectPos[1] / self.ActualWidth,
				self.SubRectPos[2] / self.ActualHeight,
				( self.SubRectPos[1] + self.SubRectSize[1] ) / self.ActualWidth,
				( self.SubRectPos[2] + self.SubRectSize[2] ) / self.ActualHeight
			surface.DrawTexturedRectUV( OffX + x, OffY + y, w, h, uS, vS, uE, vE )

		else
			surface.DrawTexturedRect( OffX + x, OffY + y, w, h )
		end

	else

		if ( self.SubRectPos && self.SubRectSize ) then

			-- Apply subrect offset and size
			local uS, vS, uE, vE =
				self.SubRectPos[1] / self.ActualWidth,
				self.SubRectPos[2] / self.ActualHeight,
				( self.SubRectPos[1] + self.SubRectSize[1] ) / self.ActualWidth,
				( self.SubRectPos[2] + self.SubRectSize[2] ) / self.ActualHeight
			surface.DrawTexturedRectUV( x, y, dw, dh, uS, vS, uE, vE )

		else
			surface.DrawTexturedRect( x, y, dw, dh )
		end

	end

	return true

end

function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local ctrl = vgui.Create( ClassName )
	ctrl:SetImage( "gui/tool.png" )
	ctrl:SetSize( 200, 200 )

	PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )

end

derma.DefineControl( "DImage", "A simple image", PANEL, "DPanel" )
