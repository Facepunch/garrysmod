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

--[[---------------------------------------------------------
	Converts color to an integer/hex - loss of precision / alpha lost
-----------------------------------------------------------]]
function COLOR:ToInt( c )
	return bit.lshift( c.r,16 ) + bit.lshift( c.g, 8 ) + bit.lshift( c.b, 0 )
end

--[[---------------------------------------------------------
	Converts integer to color - no alpha
-----------------------------------------------------------]]
function IntToColor( int )
        return Color( 
        	bit.band( bit.rshift( int,16 ), 0xFF ), 
        	bit.band( bit.rshift( int,8 ), 0xFF ), 
        	bit.band( bit.rshift( int,0 ), 0xFF ) 
        )
end
