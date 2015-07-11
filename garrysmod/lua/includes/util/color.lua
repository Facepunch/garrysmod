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
	Returns color as a string ( unlinks necessity of
	using tostring for functionality )

	delimiter = " ": allows you to set your own delimiter
	between the individual values.

	postfix = "": allows you to set your own postfix
	at the end of the output to make Exploding the
	data easy.
-----------------------------------------------------------]]
function COLOR:Serialize( delimiter, postfix )

	local delimiter = ( isstring( delimiter ) ) && delimiter || " "
	local postfix = ( isstring( postfix ) ) && postfix || ""
	return string.format( "%d%s%d%s%d%s%d%s", self.r, delimiter, self.g, delimiter, self.b, delimiter, self.a, postfix )

end

--[[---------------------------------------------------------
	Returns color as a string
-----------------------------------------------------------]]
function COLOR:__tostring()

	return self:Serialize( )

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
