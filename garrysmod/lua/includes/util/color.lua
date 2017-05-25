local COLOR = {}
COLOR.__index = COLOR

--[[---------------------------------------------------------
	Register our metatable to make it accessible using FindMetaTable
-----------------------------------------------------------]]

debug.getregistry().Color = COLOR

--[[---------------------------------------------------------
	To easily create a colour table
-----------------------------------------------------------]]
function Color( r, g, b, a )

	a = a or 255
	return setmetatable( { r = math.min( tonumber(r), 255 ), g =  math.min( tonumber(g), 255 ), b =  math.min( tonumber(b), 255 ), a =  math.min( tonumber(a), 255 ) }, COLOR )
	
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
	Add two colors
-----------------------------------------------------------]]
function COLOR:__add( c )

	return Color( self.r + c.r, self.g + c.g, self.b + c.b, self.a + c.a )

end

--[[---------------------------------------------------------
	Subtract two colors
-----------------------------------------------------------]]
function COLOR:__sub( c )

	return Color( self.r - c.r, self.g - c.g, self.b - c.b, self.a - c.a )

end

--[[---------------------------------------------------------
	Multiply two colors
-----------------------------------------------------------]]
function COLOR:__mul( c )

	if ( isnumber( self ) ) then
		return Color( self * c.r, self * c.g, self * c.b, self * c.a )
	elseif ( isnumber( c ) ) then
		return Color( self.r * c, self.g * c, self.b * c, self.a * c )
	end

	return Color( self.r * c.r, self.g * c.g, self.b * c.b, self.a * c.a )

end

--[[---------------------------------------------------------
	Divide two colors
-----------------------------------------------------------]]
function COLOR:__div( c )

	if ( isnumber( self ) ) then
		return Color( self / c.r, self / c.g, self / c.b, self / c.a )
	elseif ( isnumber( c ) ) then
		return Color( self.r / c, self.g / c, self.b / c, self.a / c )
	end

	return Color( self.r / c.r, self.g / c.g, self.b / c.b, self.a / c.a )

end

--[[---------------------------------------------------------
	Modulate two colors
-----------------------------------------------------------]]
function COLOR:__mod( c )

	if ( isnumber( c ) ) then
		return Color( self.r % c, self.g % c, self.b % c, self.a % c )
	end

	return Color( self.r % c.r, self.g % c.g, self.b % c.b, self.a % c.a )

end

--[[---------------------------------------------------------
	Power two colors
-----------------------------------------------------------]]
function COLOR:__pow( c )

	if ( isnumber( c ) ) then
		return Color( self.r ^ c, self.g ^ c, self.b ^ c, self.a ^ c )
	end

	return Color( self.r ^ c.r, self.g ^ c.g, self.b ^ c.b, self.a ^ c.a )

end

--[[---------------------------------------------------------
	Returns color object length
-----------------------------------------------------------]]
function COLOR:__len()

	return 4

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
