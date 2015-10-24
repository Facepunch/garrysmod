local COLOR = {}
COLOR.__index = COLOR

--[[---------------------------------------------------------
	Register our metatable
-----------------------------------------------------------]]
debug.getregistry().Color = COLOR

--[[---------------------------------------------------------
	Local bitwise AND function to get precise values
-----------------------------------------------------------]]
local function bAND( x, y )

    local b, n, rx, ry = 1, 0

    while x > 0 and y > 0 do
        rx, ry = x % 2, y % 2
        if ( rx + ry > 1 ) then n = n + b end
        x, y, b = (x - rx) / 2, (y - ry) / 2 , b * 2
    end

    return n

end

--[[---------------------------------------------------------
	Creates color object
-----------------------------------------------------------]]
function Color( r, g, b, a )

	r = tonumber( r )

	if ( g != nil ) then
		g = tonumber( g )
		b = tonumber( b )
		a = tonumber( a ) or 255

		return setmetatable( {
			r = r < 0 and 0 or r > 255 and 255 or r,
			g = g < 0 and 0 or g > 255 and 255 or g,
			b = b < 0 and 0 or b > 255 and 255 or b,
			a = a < 0 and 0 or a > 255 and 255 or a
		}, COLOR )
	end

	if ( r <= 0xFFFFFF ) then
		a = 255
	else
		a = bAND( r / 2^24, 0xFF )
	end

	return setmetatable( {
		r = bAND( r / 2^16, 0xFF ),
		g = bAND( r / 2^8, 0xFF ),
		b = bAND( r, 0xFF ),
		a = a
	}, COLOR )

end

--[[---------------------------------------------------------
	Converts color to (AA)RRGGBB hex/int
-----------------------------------------------------------]]
function COLOR:ToInt( noalpha )

	local int = self.r * 2^16 + self.g * 2^8 + self.b

	if ( noalpha ) then
		return int
	end

	return self.a * 2^24 + int

end

--[[---------------------------------------------------------
	Change the alpha of a color
-----------------------------------------------------------]]
function ColorAlpha( c, a )

	c.a = a
	return c

end

--[[---------------------------------------------------------
	Checks if the given variable is a color object
-----------------------------------------------------------]]
function IsColor( obj )

	return getmetatable( obj ) == COLOR

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
	Converts color to vector - loss of precision / alpha lost
-----------------------------------------------------------]]
function COLOR:ToVector()

	return Vector( self.r / 255, self.g / 255, self.b / 255 )

end
