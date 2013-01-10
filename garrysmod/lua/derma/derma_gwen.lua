--[[   _                                
	( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

--]]
local meta = FindMetaTable( "Panel" )

GWEN = {}

function GWEN.CreateTextureBorder( _x, _y, _w, _h, l, t, r, b )

	local mat = SKIN.GwenTexture;
	local tex = mat:GetTexture( "$basetexture" )
	
	_x = _x / tex:Width()
	_y = _y / tex:Height()
	_w = _w / tex:Width()
	_h = _h / tex:Height()
	
	local _l = l / tex:Width()
	local _t = t / tex:Height()
	local _r = r / tex:Width()
	local _b = b / tex:Height()
	
	return function( x, y, w, h, col )
		
		surface.SetMaterial( mat )
		if ( col ) then 
			surface.SetDrawColor( col )
		else
			surface.SetDrawColor( 255, 255, 255, 255 )
		end
		
		-- top 
		surface.DrawTexturedRectUV( x, y, l, t, _x, _y, _x+_l, _y+_t )
		surface.DrawTexturedRectUV( x+l, y, w-l-r, t, _x+_l, _y, _x+_w-_l-_r, _y+_t )
		surface.DrawTexturedRectUV( x+w-r, y, r, t, _x+_w-_r, _y, _x+_w, _y+_t )
	
		-- bottom 
		surface.DrawTexturedRectUV( x, y+h-b, l, b, _x, _y+_h-_b, _x+_l, _y+_h )
		surface.DrawTexturedRectUV( x+l, y+h-b, w-l-r, b, _x+_l, _y+_h-_b, _x+_w-_l-_r, _y+_h )
		surface.DrawTexturedRectUV( x+w-r, y+h-b, r, b, _x+_w-_r, _y+_h-_b, _x+_w, _y+_h )
		
		-- middle. 
		surface.DrawTexturedRectUV( x+l, y+t, w-l-r, h-t-b, _x+_l, _y+_t, _x+_w-_r, _y+_h-_b )
		surface.DrawTexturedRectUV( x, y+t, l, h-t-b, _x, _y+_t, _x+_l, _y+_h-_b )
		surface.DrawTexturedRectUV( x+w-r, y+t, r, h-t-b, _x+_w-_r, _y+_t, _x+_w, _y+_h-_b )
	
	end

end

function GWEN.CreateTextureNormal( _x, _y, _w, _h )

	local mat = SKIN.GwenTexture;
	local tex = mat:GetTexture( "$basetexture" )
	
	_x = _x / tex:Width()
	_y = _y / tex:Height()
	_w = _w / tex:Width()
	_h = _h / tex:Height()
		
	return function( x, y, w, h, col )
		
		surface.SetMaterial( mat )
		
		if ( col ) then 
			surface.SetDrawColor( col )
		else
			surface.SetDrawColor( 255, 255, 255, 255 )
		end
		
		surface.DrawTexturedRectUV( x, y, w, h, _x, _y, _x+_w, _y+_h )

	end

end

function GWEN.CreateTextureCentered( _x, _y, _w, _h )

	local mat = SKIN.GwenTexture;
	local tex = mat:GetTexture( "$basetexture" )
	
	local width = _w;
	local height = _h;
	
	_x = _x / tex:Width()
	_y = _y / tex:Height()
	_w = _w / tex:Width()
	_h = _h / tex:Height()
		
	return function( x, y, w, h, col )
		
		x = x + (w-width)*0.5;
		y = y + (h-height)*0.5;
		w = width;
		h = height;
		
		surface.SetMaterial( mat )
		
		if ( col ) then 
			surface.SetDrawColor( col )
		else
			surface.SetDrawColor( 255, 255, 255, 255 )
		end
		
		surface.DrawTexturedRectUV( x, y, w, h, _x, _y, _x+_w, _y+_h )

	end

end

function GWEN.TextureColor( x, y )

	local mat = SKIN.GwenTexture;
	return mat:GetColor( x, y )

end

--
-- Loads a .gwen file (created by GWEN Designer)
-- TODO: Cache - but check for file changes?
--
function meta:LoadGWENFile( filename, path )

	local contents = file.Read( filename, path or "GAME" )
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
local GwenTypes = 
{
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
function meta:GWEN_SetMin( min ) self:SetMin( tonumber(min) ) end
function meta:GWEN_SetMax( min ) self:SetMax( tonumber(max) ) end
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