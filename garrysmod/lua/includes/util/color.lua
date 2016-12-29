local COLOR = {}
COLOR.__index = COLOR

--[[---------------------------------------------------------
	Register our metatable to make it accessible using FindMetaTable
-----------------------------------------------------------]]
debug.getregistry().Color = COLOR

--[[---------------------------------------------------------
	HTML/CSS/X11 web colors
-----------------------------------------------------------]]
local WebColors = {
	aliceblue = 0xf0f8ff,
	antiquewhite = 0xfaebd7,
	aqua = 0x00ffff,
	aquamarine = 0x7fffd4,
	azure = 0xf0ffff,
	beige = 0xf5f5dc,
	bisque = 0xffe4c4,
	black = 0x000000,
	blanchedalmond = 0xffebcd,
	blue = 0x0000ff,
	blueviolet = 0x8a2be2,
	brown = 0xa52a2a,
	burlywood = 0xdeb887,
	cadetblue = 0x5f9ea0,
	chartreuse = 0x7fff00,
	chocolate = 0xd2691e,
	coral = 0xff7f50,
	cornflowerblue = 0x6495ed,
	cornsilk = 0xfff8dc,
	crimson = 0xdc143c,
	cyan = 0x00ffff,
	darkblue = 0x00008b,
	darkcyan = 0x008b8b,
	darkgoldenrod = 0xb8860b,
	darkgray = 0xa9a9a9,
	darkgrey = 0xa9a9a9,
	darkgreen = 0x006400,
	darkkhaki = 0xbdb76b,
	darkmagenta = 0x8b008b,
	darkolivegreen = 0x556b2f,
	darkorange = 0xff8c00,
	darkorchid = 0x9932cc,
	darkred = 0x8b0000,
	darksalmon = 0xe9967a,
	darkseagreen = 0x8fbc8f,
	darkslateblue = 0x483d8b,
	darkslategray = 0x2f4f4f,
	darkslategrey = 0x2f4f4f,
	darkturquoise = 0x00ced1,
	darkviolet = 0x9400d3,
	deeppink = 0xff1493,
	deepskyblue = 0x00bfff,
	dimgray = 0x696969,
	dimgrey = 0x696969,
	dodgerblue = 0x1e90ff,
	firebrick = 0xb22222,
	floralwhite = 0xfffaf0,
	forestgreen = 0x228b22,
	fuchsia = 0xff00ff,
	gainsboro = 0xdcdcdc,
	ghostwhite = 0xf8f8ff,
	gold = 0xffd700,
	goldenrod = 0xdaa520,
	gray = 0x808080,
	grey = 0x808080,
	green = 0x008000,
	greenyellow = 0xadff2f,
	honeydew = 0xf0fff0,
	hotpink = 0xff69b4,
	indianred = 0xcd5c5c,
	indigo = 0x4b0082,
	ivory = 0xfffff0,
	khaki = 0xf0e68c,
	lavender = 0xe6e6fa,
	lavenderblush = 0xfff0f5,
	lawngreen = 0x7cfc00,
	lemonchiffon = 0xfffacd,
	lightblue = 0xadd8e6,
	lightcoral = 0xf08080,
	lightcyan = 0xe0ffff,
	lightgoldenrodyellow = 0xfafad2,
	lightgray = 0xd3d3d3,
	lightgrey = 0xd3d3d3,
	lightgreen = 0x90ee90,
	lightpink = 0xffb6c1,
	lightsalmon = 0xffa07a,
	lightseagreen = 0x20b2aa,
	lightskyblue = 0x87cefa,
	lightslategray = 0x778899,
	lightslategrey = 0x778899,
	lightsteelblue = 0xb0c4de,
	lightyellow = 0xffffe0,
	lime = 0x00ff00,
	limegreen = 0x32cd32,
	linen = 0xfaf0e6,
	magenta = 0xff00ff,
	maroon = 0x800000,
	mediumaquamarine = 0x66cdaa,
	mediumblue = 0x0000cd,
	mediumorchid = 0xba55d3,
	mediumpurple = 0x9370d8,
	mediumseagreen = 0x3cb371,
	mediumslateblue = 0x7b68ee,
	mediumspringgreen = 0x00fa9a,
	mediumturquoise = 0x48d1cc,
	mediumvioletred = 0xc71585,
	midnightblue = 0x191970,
	mintcream = 0xf5fffa,
	mistyrose = 0xffe4e1,
	moccasin = 0xffe4b5,
	navajowhite = 0xffdead,
	navy = 0x000080,
	oldlace = 0xfdf5e6,
	olive = 0x808000,
	olivedrab = 0x6b8e23,
	orange = 0xffa500,
	orangered = 0xff4500,
	orchid = 0xda70d6,
	palegoldenrod = 0xeee8aa,
	palegreen = 0x98fb98,
	paleturquoise = 0xafeeee,
	palevioletred = 0xd87093,
	papayawhip = 0xffefd5,
	peachpuff = 0xffdab9,
	peru = 0xcd853f,
	pink = 0xffc0cb,
	plum = 0xdda0dd,
	powderblue = 0xb0e0e6,
	purple = 0x800080,
	red = 0xff0000,
	rosybrown = 0xbc8f8f,
	royalblue = 0x4169e1,
	saddlebrown = 0x8b4513,
	salmon = 0xfa8072,
	sandybrown = 0xf4a460,
	seagreen = 0x2e8b57,
	seashell = 0xfff5ee,
	sienna = 0xa0522d,
	silver = 0xc0c0c0,
	skyblue = 0x87ceeb,
	slateblue = 0x6a5acd,
	slategray = 0x708090,
	slategrey = 0x708090,
	snow = 0xfffafa,
	springgreen = 0x00ff7f,
	steelblue = 0x4682b4,
	tan = 0xd2b48c,
	teal = 0x008080,
	thistle = 0xd8bfd8,
	tomato = 0xff6347,
	transparent = 0x00000000,
	turquoise = 0x40e0d0,
	violet = 0xee82ee,
	wheat = 0xf5deb3,
	white = 0xffffff,
	whitesmoke = 0xf5f5f5,
	yellow = 0xffff00,
	yellowgreen = 0x9acd32
}

--[[---------------------------------------------------------
	Make Color into a constructor and calltable
-----------------------------------------------------------]]
Color = setmetatable( {}, {
	--[[---------------------------------------------------------
		Red, green, blue, (alpha) 8-bit ints to color
	-----------------------------------------------------------]]
	__call = function( _, r, g, b, a )

		return setmetatable( {
			r = math.min( tonumber(r), 255 ),
			g = math.min( tonumber(g), 255 ),
			b = math.min( tonumber(b), 255 ),
			a = a && math.min( tonumber(a), 255 ) || 255
		}, COLOR )

	end
} )

--[[---------------------------------------------------------
	32-bit integer to color
-----------------------------------------------------------]]
function Color.FromInt( num )

	local a = bit.band( bit.rshift( num, 24 ), 0xFF )	
	if (a == 0) then a = 255 end

	return setmetatable( {
		a = a,
		r = bit.band( bit.rshift( num, 16 ), 0xFF ),
		g = bit.band( bit.rshift( num, 8 ), 0xFF ),
		b = bit.band( num, 0xFF )
	}, COLOR )

end

--[[---------------------------------------------------------
	Hex string or triplet to color. Can be preceded by "0x", "#", or nothing
-----------------------------------------------------------]]
function Color.FromHexString( str )

	local num

	if ( str[1] == '#' ) then
		-- Hex-triplet
		if ( str:len() == 4 ) then
			num = tonumber( str[2] .. str[2] .. str[3] .. str[3] .. str[4] .. str[4], 16 )
		else
			num = tonumber( str:sub( 2 ), 16 )
		end
	else
		num = tonumber( str, 16 )
	end

	local a = bit.band( bit.rshift( num, 24 ), 0xFF )	
	if (a == 0) then a = 255 end

	if ( num ) then
		return setmetatable( {
			a = a,
			r = bit.band( bit.rshift( num, 16 ), 0xFF ),
			g = bit.band( bit.rshift( num, 8 ), 0xFF ),
			b = bit.band( num, 0xFF )
		}, COLOR )
	end

	error( "Invalid hex-string color declaration \"" .. str .. "\"!" )

end

--[[---------------------------------------------------------
	Web color names to color object
-----------------------------------------------------------]]
function Color.FromName( key )

	local num = WebColors[ key:lower() ]

	if ( num ) then
		local a = bit.band( bit.rshift( num, 24 ), 0xFF )	
		if (a == 0) then a = 255 end

		return setmetatable( {
			a = a,
			r = bit.band( bit.rshift( num, 16 ), 0xFF ),
			g = bit.band( bit.rshift( num, 8 ), 0xFF ),
			b = bit.band( num, 0xFF )
		}, COLOR )
	end

	error( "Invalid color name \"" .. key .. "\"!" )

end

--[[---------------------------------------------------------
	String of int(s) to color
-----------------------------------------------------------]]
function Color.FromString( str )

	local num = tonumber( str ) -- 32-bit int

	if ( num ) then
		return setmetatable( {
			a = bit.band( bit.rshift( num, 24 ), 0xFF ),
			r = bit.band( bit.rshift( num, 16 ), 0xFF ),
			g = bit.band( bit.rshift( num, 8 ), 0xFF ),
			b = bit.band( num, 0xFF )
		}, COLOR )
	end

	local tbl = {} -- Three to four 8-bit ints
	local index = 1
	local currpos = 1

	repeat
		local endpos = string.find( str, " ", currpos, true )

		if ( !endpos ) then
			endpos = #str + 1
		end

		local num = tonumber( string.sub( str, currpos, endpos - 1 ) )
		if ( !num ) then break end
		tbl[ index ] = num

		index = index + 1
		currpos = endpos + 1
	until ( false ) -- Loop until we break. Post-check loop is better for this

	if ( index > 3 ) then -- At least r, g, b is present
		return setmetatable( {
			r = math.min( tonumber( tbl[1] ), 255 ),
			g = math.min( tonumber( tbl[2] ), 255 ),
			b = math.min( tonumber( tbl[3] ), 255 ),
			a = tbl[4] && math.min( tonumber( tbl[4] ), 255 ) || 255
		}, COLOR )
	end

	return setmetatable( { r = 255, g = 255, b = 255, a = 255 }, COLOR )

end

--[[---------------------------------------------------------
	Vector whose values are between 0-1 to a color
-----------------------------------------------------------]]
function Color.FromVector( vec )

	return setmetatable( {
		r = math.min( math.floor( vec[1] * 255 ), 255 ),
		g = math.min( math.floor( vec[2] * 255 ), 255 ),
		b = math.min( math.floor( vec[3] * 255 ), 255 ),
		a = 255
	}, COLOR )

end

--[[---------------------------------------------------------
	Copy color
-----------------------------------------------------------]]
function Color.FromColor( col )

	return setmetatable( {
		r = col.r,
		g = col.g,
		b = col.b,
		a = col.a
	}, COLOR )

end

--[[---------------------------------------------------------
	Color from table. Table can have r, g, b, (a) keys or numerical
-----------------------------------------------------------]]
function Color.FromTable( tbl )

	if ( tbl.r ) then
		return setmetatable( {
			r = tbl.r,
			g = tbl.g,
			b = tbl.b,
			a = tbl.a || 255
		}, COLOR )
	end

	return setmetatable( {
		r = tbl[1],
		g = tbl[2],
		b = tbl[3],
		a = tbl[4] || 255
	}, COLOR )

end

--[[---------------------------------------------------------
	Change the alpha of a color
-----------------------------------------------------------]]
function ColorAlpha( c, a )

	return Color( c.r, c.g, c.b, a )
	
end

--[[---------------------------------------------------------
	Checks if the given varible is a color object
-----------------------------------------------------------]]
function IsColor( obj )

	return getmetatable(obj) == COLOR

end

--[[---------------------------------------------------------
	Returns color as a string
-----------------------------------------------------------]]
function COLOR:__tostring()
	
	return string.format( "%d %d %d %d", self.r, self.g, self.b, self.a )
	
end

--[[---------------------------------------------------------
	Compares two colors
-----------------------------------------------------------]]
function COLOR:__eq( c )
	
	return self.r == c.r and self.g == c.g and self.b == c.b and self.a == c.a
	
end

--[[---------------------------------------------------------
	Converts a color to HSV
-----------------------------------------------------------]]
function COLOR:ToHSV()
	
	return ColorToHSV( self )
	
end

--[[---------------------------------------------------------
	Converts Color To Vector - loss of precision / alpha lost
-----------------------------------------------------------]]
function COLOR:ToVector( )

	return Vector( self.r / 255, self.g / 255, self.b / 255 )

end
