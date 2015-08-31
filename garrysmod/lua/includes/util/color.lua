local COLOR = {}
COLOR.__index = COLOR

--[[---------------------------------------------------------
	Register our metatable to make it accessible using FindMetaTable
-----------------------------------------------------------]]
debug.getregistry().Color = COLOR

--[[---------------------------------------------------------
	Creates color object
-----------------------------------------------------------]]
function Color( r, g, b, a )

	r = tonumber( r )

	if ( g != nil ) then
		a = tonumber( a ) or 255

		return setmetatable( { r = math.min( r, 255 ), g =  math.min( tonumber( g ), 255 ), b =  math.min( tonumber( b ), 255 ), a =  math.min( a, 255 ) }, COLOR )	
	end

	if ( r <= 0xFFFFFF ) then
		a = 255
	else
		a = bit.band( bit.rshift( r, 24 ), 0xFF )
	end

	return setmetatable( { r = bit.band( bit.rshift( r, 16 ), 0xFF ), g = bit.band( bit.rshift( r, 8 ), 0xFF ), b = bit.band( bit.rshift( r, 0 ), 0xFF ), a = a }, COLOR )

end

--[[---------------------------------------------------------
	Converts color to AARRGGBB hex/int
-----------------------------------------------------------]]
function COLOR:ToInt()

	return bit.lshift( self.a, 24 ) + bit.lshift( self.r, 16 ) + bit.lshift( self.g, 8 ) + bit.lshift( self.b, 0 )

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
	Converts Color To Vector - loss of precision / alpha lost
-----------------------------------------------------------]]
function COLOR:ToVector( )

	return Vector( self.r / 255, self.g / 255, self.b / 255 )

end
