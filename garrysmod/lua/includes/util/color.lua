function unpackcolor( col ) -- Unpack a color
	return col.r, col.g, col.b, col.a
end

function ColorToVector( col )
	return Vector( col.r / 255, col.g / 255, col.b / 255 )
end

function HexToColor( hex )
	return Color( bit.band(bit.rshift(hex,16),0xFF), bit.band(bit.rshift(hex,8),0xFF), bit.band(bit.rshift(hex,0),0xFF) )
end

function ColorToHex( col )
	if(type(col)=="number") then return col end
	return bit.lshift(col.r,16) + bit.lshift(col.g,8) + bit.lshift(col.b,0)
end

local meta = {}
debug.getregistry().Color = meta
meta = {}
meta.__index = meta

function Color( r, g, b, a )
	return setmetatable( {
		r = math.min(tonumber(r or 255), 255 ),
		g = math.min(tonumber(g or 255), 255),
		b = math.min(tonumber(b or 255), 255),
		a = math.min(tonumber(a or 255), 255)
	}, meta )
end

function meta:__tostring()
	return string.format( "Color [%i, %i, %i, %i][#%X]", self.r, self.g, self.b, self.a, self:Hex() )
end

function meta:__add( col )
	return Color(math.Clamp(self.r + col.r, 0, 255), math.Clamp(self.g + col.g, 0, 255), math.Clamp(self.b + col.b, 0, 255))
end

function meta:__mul( col )
	return Color(((self.r / 255) * (col.r / 255)) * 255, ((self.g / 255) * (col.g / 255)) * 255, ((self.b / 255) * (col.b / 255)) * 255)
end

function meta:__eq( col )
	return self.r == col.r and self.g == col.g and self.b == col.b and self.a == col.a
end

function meta:Vector()
	return Vector( col.r / 255, col.g / 255, col.b / 255 )
end

function meta:FadeTo( col, frac )
	local faded = Color( 255, 255, 255 )
	faded.r = ( self.r * ( 1 - frac ) ) + col.r * frac
	faded.g = ( self.g * ( 1 - frac ) ) + col.g * frac
	faded.b = ( self.b * ( 1 - frac ) ) + col.b * frac
	faded.a = self.a
	return faded
end

function meta:Distance( other )
	local r, g, b = unpackcolor( self )
	local s, h, c = unpackcolor( other )
	r = r - s
	g = g - h
	b = b - c
	return r * r + g * g + b * b
end

function meta:Brighten( factor )
	factor = factor * 255
	local inverse = 255 - factor
	return Color( factor + inverse * self.r, factor + inverse * self.g, factor + inverse * self.b, self.a )
end

function meta:Hex()
	return ColorToHex( self )
end

color_blank = Color( 0, 0, 0, 0 )
color_white = Color( 255, 255, 255 )
color_black = Color( 0, 0, 0 )
color_red = Color( 237, 28, 36 )
color_green = Color( 34, 177, 76 )
color_blue = Color( 0, 162, 232 )
color_entity = Color( 151, 211, 255 )
color_pink = Color( 255, 128, 128 )
color_hotpink = Color( 255, 105, 180 )
color_orange = Color( 255, 126, 0 )
color_gray = Color( 126, 126, 126 )
color_lgray = Color( 200,200,200,255 )
