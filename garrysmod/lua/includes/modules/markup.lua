
local string = string
local table = table
local surface = surface
local tostring = tostring
local ipairs = ipairs
local setmetatable = setmetatable
local math = math
local utf8 = utf8
local _Color = Color

local MarkupObject = {}
MarkupObject.__index = MarkupObject
debug.getregistry().MarkupObject = MarkupObject

module("markup")

--[[---------------------------------------------------------
	Name: Constants used for text alignment.
		  These must be the same values as in the draw module.
-----------------------------------------------------------]]
TEXT_ALIGN_LEFT		= 0
TEXT_ALIGN_CENTER	= 1
TEXT_ALIGN_RIGHT	= 2
TEXT_ALIGN_TOP		= 3
TEXT_ALIGN_BOTTOM	= 4

--[[---------------------------------------------------------
	Name: Color(Color(r, g, b, a))
	Desc: Convenience function which converts a Color object into a string
	      which can be used in the <color=r,g,b,a></color> tag

	      e.g. Color(255, 0, 0, 150) -> 255,0,0,150
	           Color(255, 0, 0)      -> 255,0,0
	           Color(255, 0, 0, 255) -> 255,0,0

	Usage: markup.Color(Color(r, g, b, a))
-----------------------------------------------------------]]
function Color( col )
	return
		col.r .. "," ..
		col.g .. "," ..
		col.b ..
		-- If the alpha value is 255, we don't need to include it in the <color> tag, so just omit it:
		( col.a == 255 and "" or ( "," .. col.a ) )
end

local Color = _Color

--[[---------------------------------------------------------
	Name: Temporary information used when building text frames.
-----------------------------------------------------------]]
local colour_stack = { Color( 255, 255, 255 ) }
local font_stack = { "DermaDefault" }
local blocks = {}

local colourmap = {

-- it's all black and white
	["black"] =		Color( 0, 0, 0 ),
	["white"] =		Color( 255, 255, 255 ),

-- it's greys
	["dkgrey"] =	Color( 64, 64, 64 ),
	["grey"] =		Color( 128, 128, 128 ),
	["ltgrey"] =	Color( 192, 192, 192 ),

-- account for speeling mistakes
	["dkgray"] =	Color( 64, 64, 64 ),
	["gray"] =		Color( 128, 128, 128 ),
	["ltgray"] =	Color( 192, 192, 192 ),

-- normal colours
	["red"] =		Color( 255, 0, 0 ),
	["green"] =		Color( 0, 255, 0 ),
	["blue"] =		Color( 0, 0, 255 ),
	["yellow"] =	Color( 255, 255, 0 ),
	["purple"] =	Color( 255, 0, 255 ),
	["cyan"] =		Color( 0, 255, 255 ),
	["turq"] =		Color( 0, 255, 255 ),

-- dark variations
	["dkred"] =		Color( 128, 0, 0 ),
	["dkgreen"] =	Color( 0, 128, 0 ),
	["dkblue"] =	Color( 0, 0, 128 ),
	["dkyellow"] =	Color( 128, 128, 0 ),
	["dkpurple"] =	Color( 128, 0, 128 ),
	["dkcyan"] =	Color( 0, 128, 128 ),
	["dkturq"] =	Color( 0, 128, 128 ),

-- light variations
	["ltred"] =		Color( 255, 128, 128 ),
	["ltgreen"] =	Color( 128, 255, 128 ),
	["ltblue"] =	Color( 128, 128, 255 ),
	["ltyellow"] =	Color( 255, 255, 128 ),
	["ltpurple"] =	Color( 255, 128, 255 ),
	["ltcyan"] =	Color( 128, 255, 255 ),
	["ltturq"] =	Color( 128, 255, 255 ),

}

--[[---------------------------------------------------------
	Name: colourMatch(c)
	Desc: Match a colour name to an rgb value.
	Usage: ** INTERNAL ** Do not use!
-----------------------------------------------------------]]
local function colourMatch( c )
	return colourmap[ string.lower( c ) ]
end

--[[---------------------------------------------------------
	Name: ExtractParams(p1,p2,p3)
	Desc: This function is used to extract the tag information.
	Usage: ** INTERNAL ** Do not use!
-----------------------------------------------------------]]
local function ExtractParams( p1, p2, p3 )

	if ( string.sub( p1, 1, 1 ) == "/" ) then

		local tag = string.sub( p1, 2 )

		if ( tag == "color" or tag == "colour" ) then
			table.remove( colour_stack )
		elseif ( tag == "font" or tag == "face" ) then
			table.remove( font_stack )
		end

	else

		if ( p1 == "color" or p1 == "colour" ) then

			local rgba = colourMatch( p2 )

			if ( rgba == nil ) then
				rgba = {}
				local x = { "r", "g", "b", "a" }
				local n = 1
				for k, v in string.gmatch( p2, "(%d+),?" ) do
					rgba[ x[ n ] ] = k
					n = n + 1
				end
			end

			table.insert( colour_stack, rgba )

		elseif ( p1 == "font" or p1 == "face" ) then

			table.insert( font_stack, tostring( p2 ) )

		end

	end
end

--[[---------------------------------------------------------
	Name: CheckTextOrTag(p)
	Desc: This function places data in the "blocks" table
		  depending of if p is a tag, or some text
	Usage: ** INTERNAL ** Do not use!
-----------------------------------------------------------]]
local function CheckTextOrTag( p )
	if ( p == "" ) then return end
	if ( p == nil ) then return end

	if ( string.sub( p, 1, 1 ) == "<" ) then
		string.gsub( p, "<([/%a]*)=?([^>]*)", ExtractParams )
	else

		local text_block = {}
		text_block.text = p
		text_block.colour = colour_stack[ #colour_stack ]
		text_block.font = font_stack[ #font_stack ]
		table.insert( blocks, text_block )

	end
end

--[[---------------------------------------------------------
	Name: ProcessMatches(p1,p2,p3)
	Desc: CheckTextOrTag for 3 parameters. Called by string.gsub
	Usage: ** INTERNAL ** Do not use!
-----------------------------------------------------------]]
local function ProcessMatches( p1, p2, p3 )
	if ( p1 ) then CheckTextOrTag( p1 ) end
	if ( p2 ) then CheckTextOrTag( p2 ) end
	if ( p3 ) then CheckTextOrTag( p3 ) end
end

--[[---------------------------------------------------------
	Name: MarkupObject:GetWidth()
	Desc: Returns the width of a markup block
	Usage: ml:GetWidth()
-----------------------------------------------------------]]
function MarkupObject:GetWidth()
	return self.totalWidth
end

--[[---------------------------------------------------------
	Name: MarkupObject:GetMaxWidth()
	Desc: Returns the maximum width of a markup block
	Usage: ml:GetMaxWidth()
-----------------------------------------------------------]]
function MarkupObject:GetMaxWidth()
	return self.maxWidth or self.totalWidth
end

--[[---------------------------------------------------------
	Name: MarkupObject:GetHeight()
	Desc: Returns the height of a markup block
	Usage: ml:GetHeight()
-----------------------------------------------------------]]
function MarkupObject:GetHeight()
	return self.totalHeight
end

function MarkupObject:Size()
	return self.totalWidth, self.totalHeight
end

--[[---------------------------------------------------------
	Name: MarkupObject:Draw(xOffset, yOffset, halign, valign, alphaoverride)
	Desc: Draw the markup text to the screen as position xOffset, yOffset.
		  Halign and Valign can be used to align the text relative to its offset.
		  Alphaoverride can be used to override the alpha value of the text-colour.
		  textAlign can be used to align the actual text inside of its bounds.
	Usage: MarkupObject:Draw(100, 100)
-----------------------------------------------------------]]
function MarkupObject:Draw( xOffset, yOffset, halign, valign, alphaoverride, textAlign )
	for i, blk in ipairs( self.blocks ) do
		local y = yOffset + ( blk.height - blk.thisY ) + blk.offset.y
		local x = xOffset

		if ( halign == TEXT_ALIGN_CENTER ) then		x = x - ( self.totalWidth / 2 )
		elseif ( halign == TEXT_ALIGN_RIGHT ) then	x = x - self.totalWidth
		end

		x = x + blk.offset.x

		if ( valign == TEXT_ALIGN_CENTER ) then		y = y - ( self.totalHeight / 2 )
		elseif ( valign == TEXT_ALIGN_BOTTOM ) then	y = y - self.totalHeight
		end

		local alpha = blk.colour.a
		if ( alphaoverride ) then alpha = alphaoverride end

		surface.SetFont( blk.font )
		surface.SetTextColor( blk.colour.r, blk.colour.g, blk.colour.b, alpha )

		surface.SetTextPos( x, y )
		if ( textAlign ~= TEXT_ALIGN_LEFT ) then
			local lineWidth = self.lineWidths[ blk.offset.y ]
			if ( lineWidth ) then
				if ( textAlign == TEXT_ALIGN_CENTER ) then
					surface.SetTextPos( x + ( ( self:GetMaxWidth() - lineWidth ) / 2 ), y )
				elseif ( textAlign == TEXT_ALIGN_RIGHT ) then
					surface.SetTextPos( x + ( self:GetMaxWidth() - lineWidth ), y )
				end
			end
		end

		surface.DrawText( blk.text )
	end
end

--[[---------------------------------------------------------
	Name: Escape(str)
	Desc: Converts a string to its escaped, markup-safe equivalent
	Usage: markup.Escape("<font=Default>The font will remain unchanged & these < > & symbols will also appear normally</font>")
-----------------------------------------------------------]]
local escapeEntities, unescapeEntities = {
	["&"] = "&amp;",
	["<"] = "&lt;",
	[">"] = "&gt;"
}, {
	["&amp;"] = "&",
	["&lt;"] = "<",
	["&gt;"] = ">"
}
function Escape( str )
	return ( string.gsub( tostring( str ), "[&<>]", escapeEntities ) )
end

--[[---------------------------------------------------------
	Name: Parse(ml, maxwidth)
	Desc: Parses the pseudo-html markup language, and creates a
		  MarkupObject, which can be used to the draw the
		  text to the screen. Valid tags are: font and colour.
		  \n and \t are also available to move to the next line,
		  or insert a tab character.
		  Maxwidth can be used to make the text wrap to a specific
		  width and allows for text alignment (e.g. centering) inside
		  the bounds.
	Usage: markup.Parse("<font=Default>changed font</font>\n<colour=255,0,255,255>changed colour</colour>")
-----------------------------------------------------------]]
function Parse( ml, maxwidth )

	ml = utf8.force( ml ) -- Ensure we have valid UTF-8 data

	colour_stack = { Color( 255, 255, 255 ) }
	font_stack = { "DermaDefault" }
	blocks = {}

	if ( !string.find( ml, "<" ) ) then
		ml = ml .. "<nop>"
	end

	string.gsub( ml, "([^<>]*)(<[^>]+.)([^<>]*)", ProcessMatches )

	local xOffset = 0
	local yOffset = 0
	local xSize = 0
	local xMax = 0
	local thisMaxY = 0
	local new_block_list = {}
	local ymaxes = {}
	local lineWidths = {}

	local lineHeight = 0
	for i, blk in ipairs( blocks ) do

		surface.SetFont( blk.font )
		
		blk.text = string.gsub( blk.text, "(&.-;)", unescapeEntities )

		local thisY = 0
		local curString = ""
		for j, c in utf8.codes( blk.text ) do

			local ch = utf8.char( c )

			if ( ch == "\n" ) then

				if ( thisY == 0 ) then
					thisY = lineHeight
					thisMaxY = lineHeight
				else
					lineHeight = thisY
				end

				if ( string.len( curString ) > 0 ) then
					local x1 = surface.GetTextSize( curString )

					local new_block = {
						text = curString,
						font = blk.font,
						colour = blk.colour,
						thisY = thisY,
						thisX = x1,
						offset = {
							x = xOffset,
							y = yOffset
						}
					}
					table.insert( new_block_list, new_block )
					if ( xOffset + x1 > xMax ) then
						xMax = xOffset + x1
					end
				end

				xOffset = 0
				xSize = 0
				yOffset = yOffset + thisMaxY
				thisY = 0
				curString = ""
				thisMaxY = 0

			elseif ( ch == "\t" ) then

				if ( string.len( curString ) > 0 ) then
					local x1 = surface.GetTextSize( curString )

					local new_block = {
						text = curString,
						font = blk.font,
						colour = blk.colour,
						thisY = thisY,
						thisX = x1,
						offset = {
							x = xOffset,
							y = yOffset
						}
					}
					table.insert( new_block_list, new_block )
					if ( xOffset + x1 > xMax ) then
						xMax = xOffset + x1
					end
				end
				
				curString = ""

				local xOldSize = xSize
				xSize = 0
				local xOldOffset = xOffset
				xOffset = math.ceil( ( xOffset + xOldSize ) / 50 ) * 50

				if ( xOffset == xOldOffset ) then
					xOffset = xOffset + 50
					
					if ( maxwidth and xOffset > maxwidth ) then
						-- Needs a new line
						if ( thisY == 0 ) then
							thisY = lineHeight
							thisMaxY = lineHeight
						else
							lineHeight = thisY
						end
						xOffset = 0
						yOffset = yOffset + thisMaxY
						thisY = 0
						thisMaxY = 0
					end
				end
			else
				local x, y = surface.GetTextSize( ch )

				if ( x == nil ) then return end

				if ( maxwidth and maxwidth > x ) then
					if ( xOffset + xSize + x >= maxwidth ) then

						-- need to: find the previous space in the curString
						--          if we can't find one, take off the last character
						--          and insert as a new block, incrementing the y etc

						local lastSpacePos = string.len( curString )
						for k = 1,string.len( curString ) do
							local chspace = string.sub( curString, k, k )
							if ( chspace == " " ) then
								lastSpacePos = k
							end
						end

						local previous_block = new_block_list[ #new_block_list ]
						local wrap = lastSpacePos == string.len( curString ) && lastSpacePos > 0
						if ( previous_block and previous_block.text:match(" $") and wrap and surface.GetTextSize( blk.text ) < maxwidth ) then
							-- If the block was preceded by a space, wrap the block onto the next line first, as we can probably fit it there
							local trimmed, trimCharNum = previous_block.text:gsub(" +$", "")
							if ( trimCharNum > 0 ) then
								previous_block.text = trimmed
								previous_block.thisX = surface.GetTextSize( previous_block.text )
							end
						else
							if ( wrap ) then
								-- If the block takes up multiple lines (and has no spaces), split it up
								local sequenceStartPos = utf8.offset( curString, 0, lastSpacePos )
								ch = string.match( curString, utf8.charpattern, sequenceStartPos ) .. ch
								j = utf8.offset( curString, 1, sequenceStartPos )
								curString = string.sub( curString, 1, sequenceStartPos - 1 )
							else
								-- Otherwise, strip the trailing space and start a new line
								ch = string.sub( curString, lastSpacePos + 1 ) .. ch
								j = lastSpacePos + 1
								curString = string.sub( curString, 1, math.max( lastSpacePos - 1, 0 ) )
							end

							local m = 1
							while string.sub( ch, m, m ) == " " do
								m = m + 1
							end
							ch = string.sub( ch, m )

							local x1,y1 = surface.GetTextSize( curString )

							if ( y1 > thisMaxY ) then
								thisMaxY = y1
								ymaxes[ yOffset ] = thisMaxY
								lineHeight = y1
							end

							local new_block = {
								text = curString,
								font = blk.font,
								colour = blk.colour,
								thisY = thisY,
								thisX = x1,
								offset = {
									x = xOffset,
									y = yOffset
								}
							}
							table.insert( new_block_list, new_block )

							if ( xOffset + x1 > xMax ) then
								xMax = xOffset + x1
							end

							curString = ""
						end

						xOffset = 0
						xSize = 0
						x, y = surface.GetTextSize( ch )
						yOffset = yOffset + thisMaxY
						thisY = 0
						thisMaxY = 0
					end
				end

				curString = curString .. ch

				thisY = y
				xSize = xSize + x

				if ( y > thisMaxY ) then
					thisMaxY = y
					ymaxes[ yOffset ] = thisMaxY
					lineHeight = y
				end
			end
		end

		if ( string.len( curString ) > 0 ) then

			local x1 = surface.GetTextSize( curString )

			local new_block = {
				text = curString,
				font = blk.font,
				colour = blk.colour,
				thisY = thisY,
				thisX = x1,
				offset = {
					x = xOffset,
					y = yOffset
				}
			}
			table.insert( new_block_list, new_block )

			lineHeight = thisY

			if ( xOffset + x1 > xMax ) then
				xMax = xOffset + x1
			end
			xOffset = xOffset + x1
		end
		xSize = 0
	end

	local totalHeight = 0
	for i, blk in ipairs( new_block_list ) do
		blk.height = ymaxes[ blk.offset.y ]

		if ( blk.offset.y + blk.height > totalHeight ) then
			totalHeight = blk.offset.y + blk.height
		end

		lineWidths[ blk.offset.y ] = math.max( lineWidths[ blk.offset.y ] or 0, blk.offset.x + blk.thisX )
	end

	return setmetatable( {
		totalHeight = totalHeight,
		totalWidth = xMax,
		maxWidth = maxwidth,
		lineWidths = lineWidths,
		blocks = new_block_list
	}, MarkupObject )
end
