
local meta = FindMetaTable( "Panel" )

GWEN = {}

function GWEN.CreateTextureBorder( _xo, _yo, _wo, _ho, l, t, r, b, material_override )

	local mat = SKIN && SKIN.GwenTexture || material_override
	if ( material_override && !material_override:IsError() ) then mat = material_override end

	return function( x, y, w, h, col )

		local tex = mat:GetTexture( "$basetexture" )
		local texW, texH = tex:Width(), tex:Height()

		local _x = _xo / texW
		local _y = _yo / texH
		local _w = _wo / texW
		local _h = _ho / texH

		surface.SetMaterial( mat )
		if ( col ) then
			surface.SetDrawColor( col.r, col.g, col.b, col.a )
		else
			surface.SetDrawColor( 255, 255, 255, 255 )
		end

		local halfW, halfH = w / 2, h / 2
		local left = math.min( l, math.ceil( halfW ) )
		local right = math.min( r, math.floor( halfW ) )
		local top = math.min( t, math.ceil( halfH ) )
		local bottom = math.min( b, math.floor( halfH ) )

		local _l = left / texW
		local _t = top / texH
		local _r = right / texW
		local _b = bottom / texH

		-- top
		surface.DrawTexturedRectUV( x, y, left, top, _x, _y, _x + _l, _y + _t )
		surface.DrawTexturedRectUV( x + left, y, w - left - right, top, _x + _l, _y, _x + _w - _r, _y + _t )
		surface.DrawTexturedRectUV( x + w - right, y, right, top, _x + _w - _r, _y, _x + _w, _y + _t )

		-- middle
		surface.DrawTexturedRectUV( x, y + top, left, h - top - bottom, _x, _y + _t, _x + _l, _y + _h - _b )
		surface.DrawTexturedRectUV( x + left, y + top, w - left - right, h - top - bottom, _x + _l, _y + _t, _x + _w - _r, _y + _h - _b )
		surface.DrawTexturedRectUV( x + w - right, y + top, right, h - top - bottom, _x + _w - _r, _y + _t, _x + _w, _y + _h - _b )

		-- bottom
		surface.DrawTexturedRectUV( x, y + h - bottom, left, bottom, _x, _y + _h - _b, _x + _l, _y + _h )
		surface.DrawTexturedRectUV( x + left, y + h - bottom, w - left - right, bottom, _x + _l, _y + _h - _b, _x + _w - _r, _y + _h )
		surface.DrawTexturedRectUV( x + w - right, y + h - bottom, right, bottom, _x + _w - _r, _y + _h - _b, _x + _w, _y + _h )

	end

end

function GWEN.CreateTextureNormal( _xo, _yo, _wo, _ho, material_override )

	local mat = SKIN && SKIN.GwenTexture || material_override
	if ( material_override && !material_override:IsError() ) then mat = material_override end

	return function( x, y, w, h, col )

		local tex = mat:GetTexture( "$basetexture" )
		local texW, texH = tex:Width(), tex:Height()

		local _x = _xo / texW
		local _y = _yo / texH
		local _w = _wo / texW
		local _h = _ho / texH

		surface.SetMaterial( mat )

		if ( col ) then
			surface.SetDrawColor( col.r, col.g, col.b, col.a )
		else
			surface.SetDrawColor( 255, 255, 255, 255 )
		end

		surface.DrawTexturedRectUV( x, y, w, h, _x, _y, _x + _w, _y + _h )

	end

end

function GWEN.CreateTextureCentered( _xo, _yo, _wo, _ho, material_override )

	local mat = SKIN && SKIN.GwenTexture || material_override
	if ( material_override && !material_override:IsError() ) then mat = material_override end

	return function( x, y, w, h, col )

		local tex = mat:GetTexture( "$basetexture" )
		local texW, texH = tex:Width(), tex:Height()

		local _x = _xo / texW
		local _y = _yo / texH
		local _w = _wo / texW
		local _h = _ho / texH

		x = x + ( w - _wo ) * 0.5
		y = y + ( h - _ho ) * 0.5
		w = _wo
		h = _ho

		surface.SetMaterial( mat )

		if ( col ) then
			surface.SetDrawColor( col.r, col.g, col.b, col.a )
		else
			surface.SetDrawColor( 255, 255, 255, 255 )
		end

		surface.DrawTexturedRectUV( x, y, w, h, _x, _y, _x + _w, _y + _h )

	end

end

function GWEN.TextureColor( x, y, material_override )

	local mat = SKIN && SKIN.GwenTexture || material_override
	if ( material_override && !material_override:IsError() ) then mat = material_override end
	return mat:GetColor( x, y )

end

--
-- Loads a .gwen file (created by GWEN Designer)
-- TODO: Cache - but check for file changes?
--
function meta:LoadGWENFile( filename, path )

	local contents = file.Read( filename, path || "GAME" )
	if ( !contents ) then return end

	self:LoadGWENString( contents )

end

--
-- Load from String
--
function meta:LoadGWENString( str )

	local tbl = util.JSONToTable( str )
	if ( !tbl ) then return end
	if ( !tbl.Controls ) then return end

	self:ApplyGWEN( tbl.Controls )

end

--
-- Convert GWEN types into Derma Types
--
local GwenTypes = {
	Base				= "Panel",
	Button				= "DButton",
	Label				= "DLabel",
	TextBox				= "DTextEntry",
	TextBoxMultiline	= "DTextEntry",
	ComboBox			= "DComboBox",
	HorizontalSlider	= "Slider",
	ImagePanel			= "DImage",
	CheckBoxWithLabel	= "DCheckBoxLabel"
}

--
-- Apply a GWEN table to the control (should contain Properties and (optionally) Children subtables)
--
function meta:ApplyGWEN( tbl )

	if ( tbl.Type == "TextBoxMultiline" ) then self:SetMultiline( true ) end

	for k, v in pairs( tbl.Properties ) do

		if ( self[ "GWEN_Set" .. k ] ) then
			self[ "GWEN_Set" .. k ]( self, v )
		end

	end

	if ( !tbl.Children ) then return end

	for k, v in pairs( tbl.Children ) do

		local type = GwenTypes[ v.Type ]
		if ( type ) then

			local pnl = self:Add( type )
			pnl:ApplyGWEN( v )
		else

			MsgN( "Warning: No GWEN Panel Type ", v.Type )

		end

	end


end

--
-- SET properties
--
function meta:GWEN_SetPosition( tbl ) self:SetPos( tbl.x, tbl.y ) end
function meta:GWEN_SetSize( tbl ) self:SetSize( tbl.w, tbl.h ) end
function meta:GWEN_SetText( tbl ) self:SetText( tbl ) end
function meta:GWEN_SetControlName( tbl ) self:SetName( tbl ) end
function meta:GWEN_SetMargin( tbl ) self:DockMargin( tbl.left, tbl.top, tbl.right, tbl.bottom ) end
function meta:GWEN_SetMin( min ) self:SetMin( tonumber( min ) ) end
function meta:GWEN_SetMax( max ) self:SetMax( tonumber( max ) ) end
function meta:GWEN_SetHorizontalAlign( txt )
	if ( txt == "Right" ) then self:SetContentAlignment( 6 ) end
	if ( txt == "Center" ) then self:SetContentAlignment( 5 ) end
	if ( txt == "Left" ) then self:SetContentAlignment( 4 ) end
end

function meta:GWEN_SetDock( tbl )
	if ( tbl == "Right" ) then self:Dock( RIGHT ) end
	if ( tbl == "Left" ) then self:Dock( LEFT ) end
	if ( tbl == "Bottom" ) then self:Dock( BOTTOM ) end
	if ( tbl == "Top" ) then self:Dock( TOP ) end
	if ( tbl == "Fill" ) then self:Dock( FILL ) end
end

function meta:GWEN_SetCheckboxText( tbl ) self:SetText( tbl ) end
