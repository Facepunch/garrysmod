
local CurTime = CurTime
local pairs = pairs
local table = table
local string = string
local type = type
local surface = surface
local Msg = Msg
local math = math
local setmetatable = setmetatable
local ScrW = ScrW
local ScrH = ScrH
local Color = Color
local tostring = tostring
local color_white = color_white

module( "draw" )

--[[---------------------------------------------------------
	Constants used for text alignment.
	These must be the same values as in the markup module.
-----------------------------------------------------------]]
TEXT_ALIGN_LEFT		= 0
TEXT_ALIGN_CENTER	= 1
TEXT_ALIGN_RIGHT	= 2
TEXT_ALIGN_TOP		= 3
TEXT_ALIGN_BOTTOM	= 4

--[[---------------------------------------------------------
    Textures we use to get shit done
-----------------------------------------------------------]]
local Tex_Corner8	= surface.GetTextureID( "gui/corner8" )
local Tex_Corner16	= surface.GetTextureID( "gui/corner16" )
local Tex_white		= surface.GetTextureID( "vgui/white" )

local CachedFontHeights = {}

--[[---------------------------------------------------------
	Name: GetFontHeight( font )
	Desc: Returns the height of a single line
-----------------------------------------------------------]]
function GetFontHeight( font )

	if ( CachedFontHeights[ font ] != nil ) then
		return CachedFontHeights[ font ]
	end

	surface.SetFont( font )
	local w, h = surface.GetTextSize( "W" )
	CachedFontHeights[ font ] = h

	return h

end

--[[---------------------------------------------------------
	Name: SimpleText(text, font, x, y, colour)
	Desc: Simple "draw text at position function"
		  color is a table with r/g/b/a elements
-----------------------------------------------------------]]
function SimpleText( text, font, x, y, colour, xalign, yalign )

	text	= tostring( text )
	font	= font		or "DermaDefault"
	x		= x			or 0
	y		= y			or 0
	xalign	= xalign	or TEXT_ALIGN_LEFT
	yalign	= yalign	or TEXT_ALIGN_TOP

	surface.SetFont( font )
	local w, h = surface.GetTextSize( text )

	if ( xalign == TEXT_ALIGN_CENTER ) then
		x = x - w / 2
	elseif ( xalign == TEXT_ALIGN_RIGHT ) then
		x = x - w
	end

	if ( yalign == TEXT_ALIGN_CENTER ) then
		y = y - h / 2
	elseif ( yalign == TEXT_ALIGN_BOTTOM ) then
		y = y - h
	end

	surface.SetTextPos( math.ceil( x ), math.ceil( y ) )

	if ( colour != nil ) then
		local alpha = 255
		if ( colour.a ) then alpha = colour.a end
		surface.SetTextColor( colour.r, colour.g, colour.b, alpha )
	else
		surface.SetTextColor( 255, 255, 255, 255 )
	end

	surface.DrawText( text )

	return w, h

end

--[[---------------------------------------------------------
	Name: SimpleTextOutlined( text, font, x, y, colour, xalign, yalign, outlinewidth, outlinecolour )
	Desc: Simple draw text at position, but this will expand newlines and tabs.
		  color is a table with r/g/b/a elements
-----------------------------------------------------------]]
function SimpleTextOutlined(text, font, x, y, colour, xalign, yalign, outlinewidth, outlinecolour)

	local steps = ( outlinewidth * 2 ) / 3
	if ( steps < 1 ) then steps = 1 end

	for _x = -outlinewidth, outlinewidth, steps do
		for _y = -outlinewidth, outlinewidth, steps do
			SimpleText( text, font, x + _x, y + _y, outlinecolour, xalign, yalign )
		end
	end

	return SimpleText( text, font, x, y, colour, xalign, yalign )

end

--[[---------------------------------------------------------
	Name: DrawText(text, font, x, y, colour, align )
	Desc: Simple draw text at position, but this will expand newlines and tabs.
		  color is a table with r/g/b/a elements
-----------------------------------------------------------]]
local gmatch = string.gmatch
local find = string.find
local ceil = math.ceil
local GetTextSize = surface.GetTextSize
local max = math.max
function DrawText( text, font, x, y, colour, xalign )

	if ( font == nil ) then font = "DermaDefault" end
	if ( text != nil ) then text = tostring( text ) end
	if ( x == nil ) then x = 0 end
	if ( y == nil ) then y = 0 end

	local curX = x
	local curY = y
	local curString = ""

	surface.SetFont( font )
	local sizeX, lineHeight = GetTextSize( "\n" )
	local tabWidth = 50

	for str in gmatch( text, "[^\n]*" ) do
		if #str > 0 then
			if find( str, "\t" ) then -- there's tabs, some more calculations required
				for tabs, str2 in gmatch( str, "(\t*)([^\t]*)" ) do
					curX = ceil( ( curX + tabWidth * max( #tabs - 1, 0 ) ) / tabWidth ) * tabWidth

					if #str2 > 0 then
						SimpleText( str2, font, curX, curY, colour, xalign )

						local w, _ = GetTextSize( str2 )
						curX = curX + w
					end
				end
			else -- there's no tabs, this is easy
				SimpleText( str, font, curX, curY, colour, xalign )
			end
		else
			curX = x
			curY = curY + ( lineHeight / 2 )
		end
	end
end

--[[---------------------------------------------------------
	Name: RoundedBox( bordersize, x, y, w, h, color )
	Desc: Draws a rounded box - ideally bordersize will be 8 or 16
	Usage: color is a table with r/g/b/a elements
-----------------------------------------------------------]]
function RoundedBox( bordersize, x, y, w, h, color )

	return RoundedBoxEx( bordersize, x, y, w, h, color, true, true, true, true )

end

--[[---------------------------------------------------------
	Name: RoundedBox( bordersize, x, y, w, h, color )
	Desc: Draws a rounded box - ideally bordersize will be 8 or 16
	Usage: color is a table with r/g/b/a elements
-----------------------------------------------------------]]
function RoundedBoxEx( bordersize, x, y, w, h, color, a, b, c, d )

	x = math.Round( x )
	y = math.Round( y )
	w = math.Round( w )
	h = math.Round( h )

	surface.SetDrawColor( color.r, color.g, color.b, color.a )

	-- Draw as much of the rect as we can without textures
	surface.DrawRect( x + bordersize, y, w - bordersize * 2, h )
	surface.DrawRect( x, y + bordersize, bordersize, h - bordersize * 2 )
	surface.DrawRect( x + w - bordersize, y + bordersize, bordersize, h - bordersize * 2 )

	local tex = Tex_Corner8
	if ( bordersize > 8 ) then tex = Tex_Corner16 end

	surface.SetTexture( tex )

	if ( a ) then
		surface.DrawTexturedRectUV( x, y, bordersize, bordersize, 0, 0, 1, 1 )
	else
		surface.DrawRect( x, y, bordersize, bordersize )
	end

	if ( b ) then
		surface.DrawTexturedRectUV( x + w - bordersize, y, bordersize, bordersize, 1, 0, 0, 1 )
	else
		surface.DrawRect( x + w - bordersize, y, bordersize, bordersize )
	end

	if ( c ) then
		surface.DrawTexturedRectUV( x, y + h -bordersize, bordersize, bordersize, 0, 1, 1, 0 )
	else
		surface.DrawRect( x, y + h - bordersize, bordersize, bordersize )
	end

	if ( d ) then
		surface.DrawTexturedRectUV( x + w - bordersize, y + h - bordersize, bordersize, bordersize, 1, 1, 0, 0 )
	else
		surface.DrawRect( x + w - bordersize, y + h - bordersize, bordersize, bordersize )
	end

end

--[[---------------------------------------------------------
	Name: WordBox( bordersize, x, y, font, color )
	Desc: Draws a rounded box - ideally bordersize will be 8 or 16
	Usage: color is a table with r/g/b/a elements
-----------------------------------------------------------]]
function WordBox( bordersize, x, y, text, font, color, fontcolor )

	surface.SetFont( font )
	local w, h = surface.GetTextSize( text )

	RoundedBox( bordersize, x, y, w+bordersize * 2, h+bordersize * 2, color )

	surface.SetTextColor( fontcolor.r, fontcolor.g, fontcolor.b, fontcolor.a )
	surface.SetTextPos( x + bordersize, y + bordersize )
	surface.DrawText( text )

	return w + bordersize * 2, h + bordersize * 2

end

--[[---------------------------------------------------------
	Name: Text( table )
	Desc: Draws text from a table
-----------------------------------------------------------]]
function Text( tab )

	return SimpleText( tab.text, tab.font, tab.pos[ 1 ], tab.pos[ 2 ], tab.color, tab.xalign, tab.yalign )

end

--[[---------------------------------------------------------
	Name: TextShadow( table )
	Desc: Draws text from a table
-----------------------------------------------------------]]
function TextShadow( tab, distance, alpha )

	alpha = alpha or 200

	local color = tab.color
	local pos = tab.pos
	tab.color = Color( 0, 0, 0, alpha )
	tab.pos = { pos[ 1 ] + distance, pos[ 2 ] + distance }

	Text( tab )

	tab.color = color
	tab.pos = pos

	return Text( tab )

end


--[[---------------------------------------------------------
	Name: TexturedQuad( table )
	Desc: pawrapper
-----------------------------------------------------------]]
function TexturedQuad( tab )

	local color = tab.color or color_white

	surface.SetTexture( tab.texture )
	surface.SetDrawColor( color.r, color.g, color.b, color.a )
	surface.DrawTexturedRect( tab.x, tab.y, tab.w, tab.h )

end

function NoTexture()
	surface.SetTexture( Tex_white )
end
