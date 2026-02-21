
-- Globals that we need
local surface = surface
local Msg = Msg
local Color = Color
local Material = Material

--[[---------------------------------------------------------
   Name: killicon
   Desc: Stores and serves killicons for deathnotice
-----------------------------------------------------------]]
module( "killicon" )

local Icons = {}
local TYPE_FONT = 0
local TYPE_MATERIAL = 1
local TYPE_MATERIAL_UV = 2

function AddFont( name, font, character, color, heightScale )

	Icons[name] = {
		type		= TYPE_FONT,
		font		= font,
		character	= character,
		color		= color or Color( 255, 80, 0 ),

		-- Correct certain icons
		heightScale = heightScale
	}

end

function Add( name, material, color )

	Icons[name] = {
		type		= TYPE_MATERIAL,
		material	= Material( material ),
		color		= color or Color( 255, 255, 255 )
	}

end

function AddTexCoord( name, material, color, x, y, w, h )

	Icons[name] = {
		type		= TYPE_MATERIAL_UV,
		material	= Material( material ),
		color		= color,
		tex_x		= x,
		tex_y		= y,
		tex_w		= w,
		tex_h		= h
	}

end

function AddAlias( name, alias )

	Icons[name] = Icons[alias]

end

function Exists( name )

	return Icons[name] != nil

end

function GetSize( name, dontEqualizeHeight )

	if ( !Icons[name] ) then
		Msg( "Warning: killicon not found '" .. name .. "'\n" )
		Icons[name] = Icons["default"]
	end

	local t = Icons[name]

	-- Check the cache
	if ( t.size ) then

		-- Maintain the old behavior
		if ( !dontEqualizeHeight ) then return t.size.adj_w, t.size.adj_h end

		return t.size.w, t.size.h
	end

	local w, h = 0, 0

	if ( t.type == TYPE_FONT ) then

		surface.SetFont( t.font )
		w, h = surface.GetTextSize( t.character )

		if ( t.heightScale ) then h = h * t.heightScale end

	elseif ( t.type == TYPE_MATERIAL ) then

		w, h = t.material:Width(), t.material:Height()

	elseif ( t.type == TYPE_MATERIAL_UV ) then

		w = t.tex_w
		h = t.tex_h

	end

	t.size = {}
	t.size.w = w or 32
	t.size.h = h or 32

	-- Height adjusted behavior
	if ( t.type == TYPE_FONT ) then
		t.size.adj_w, t.size.adj_h = surface.GetTextSize( t.character )
		-- BUG: This is not same height as the texture icons, and we cannot change it beacuse backwards compability
	else
		surface.SetFont( "HL2MPTypeDeath" )
		local _, fh = surface.GetTextSize( "0" )
		fh = fh * 0.75 -- Fudge it slightly

		-- Resize, maintaining aspect ratio
		t.size.adj_w = w * ( fh / h )
		t.size.adj_h = fh
	end

	-- Maintain the old behavior
	if ( !dontEqualizeHeight ) then return t.size.adj_w, t.size.adj_h end

	return w, h

end

local function DrawInternal( x, y, name, alpha, noCorrections, dontEqualizeHeight )

	alpha = alpha or 255

	if ( !Icons[name] ) then
		Msg( "Warning: killicon not found '" .. name .. "'\n" )
		Icons[name] = Icons["default"]
	end

	local t = Icons[name]

	local w, h = GetSize( name, dontEqualizeHeight )

	if ( !noCorrections ) then x = x - w * 0.5 end

	if ( t.type == TYPE_FONT ) then

		-- HACK: Default font killicons are anchored to the top, so correct for it
		if ( noCorrections && !dontEqualizeHeight ) then
			local _, h2 = GetSize( name, !dontEqualizeHeight )
			y = y + ( h - h2 ) / 2
		end

		if ( !noCorrections ) then y = y - h * 0.1 end

		surface.SetTextPos( x, y )
		surface.SetFont( t.font )
		surface.SetTextColor( t.color.r, t.color.g, t.color.b, alpha )
		surface.DrawText( t.character )

	end

	if ( t.type == TYPE_MATERIAL ) then

		if ( !noCorrections ) then y = y - h * 0.3 end

		surface.SetMaterial( t.material )
		surface.SetDrawColor( t.color.r, t.color.g, t.color.b, alpha )
		surface.DrawTexturedRect( x, y, w, h )

	end

	if ( t.type == TYPE_MATERIAL_UV ) then

		if ( !noCorrections ) then y = y - h * 0.3 end

		local tw = t.material:Width()
		local th = t.material:Height()
		surface.SetMaterial( t.material )
		surface.SetDrawColor( t.color.r, t.color.g, t.color.b, alpha )
		surface.DrawTexturedRectUV( x, y, w, h, t.tex_x / tw, t.tex_y / th, ( t.tex_x + t.tex_w ) / tw, ( t.tex_y + t.tex_h ) / th )

	end

end

-- Old function with weird vertical adjustments
function Draw( x, y, name, alpha )

	DrawInternal( x, y, name, alpha )

end

-- The new function that doesn't have the weird vertical adjustments
function Render( x, y, name, alpha, dontEqualizeHeight )

	DrawInternal( x, y, name, alpha, true, dontEqualizeHeight )

end

local Color_Icon = Color( 255, 80, 0, 255 )

Add( "default", "HUD/killicons/default", Color_Icon )
AddAlias( "suicide", "default" )
