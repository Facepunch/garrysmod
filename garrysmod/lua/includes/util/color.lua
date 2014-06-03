
local COLOR = {}
local COLOR_M = { __index = COLOR }

--[[---------------------------------------------------------
	Register our metatable to make it accessible using FindMetaTable
-----------------------------------------------------------]]

debug.getregistry().Color = COLOR_M

--[[---------------------------------------------------------
	To easily create a colour table
-----------------------------------------------------------]]
function Color( r, g, b, a )

	a = a or 255
	return setmetatable( { r = math.min( tonumber(r), 255 ), g =  math.min( tonumber(g), 255 ), b =  math.min( tonumber(b), 255 ), a =  math.min( tonumber(a), 255 ) }, COLOR_M )
	
end

--[[---------------------------------------------------------
	Change the alpha of a color
-----------------------------------------------------------]]
function ColorAlpha( c, a )

	return Color( c.r, c.g, c.b, a )
	
end

--[[---------------------------------------------------------
	Returns color as a string
-----------------------------------------------------------]]
function COLOR_M:__tostring()
	
	return string.format( "%d %d %d", self.r, self.g, self.b )
	
end

--[[---------------------------------------------------------
	Compares two colors
-----------------------------------------------------------]]
function COLOR_M:__eq( c )
	
	return self.r == c.r and self.g == c.g and self.b == c.b and self.a == c.a
	
end

--[[---------------------------------------------------------
	Converts a color to HSV
-----------------------------------------------------------]]
function COLOR:ToHSV()
	
	return ColorToHSV( self )
	
end
