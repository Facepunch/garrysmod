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
	Converts Color To CMYK - loss of precision / alpha lost
-----------------------------------------------------------]]
function COLOR:ToCMYK( )

	// Converts RGB to 0-1 range stemming from 1-255 ( clamps to min for higher values ); uses 0 if 0 and avoids division
	local r = ( self.r > 0 ) && ( math.min( self.r, 255 ) / 255 ) || 0
	local g = ( self.g > 0 ) && ( math.min( self.g, 255 ) / 255 ) || 0
	local b = ( self.b > 0 ) && ( math.min( self.b, 255 ) / 255 ) || 0

	// Calculate CMYK from RGB ( and K )
	local k = 1 - math.max( r, g, b )
	local c = ( 1 - r - k ) / ( 1 - k )
	local m = ( 1 - g - k ) / ( 1 - k )
	local y = ( 1 - b - k ) / ( 1 - k )

	// Prevents NaN when 0 division is attempted; correct it here instead of annoying checks above
	c = ( c >= 0 ) && c || 0
	m = ( m >= 0 ) && m || 0
	y = ( y >= 0 ) && y || 0

	// Return as: local c, m, y, k = Color( 255, 255, 255, 255 ):ToCMYK( ); == 0, 0, 0, 0
	return c, m, y, k

end

--[[---------------------------------------------------------
	Converts CMYK values to Color. ALTERS Color Object used to
	access function, also uses alpha from Color object.

	Example: local newcolor = Color( 0, 0, 0, 255 ):FromCMYK( 1, 0, 1, 0 ) -- Green
		Is the same same as: local newcolor = Color( 0, 255, 0, 255 ) -- Green
-----------------------------------------------------------]]
function COLOR:FromCMYK( c, m, y, k )

	// Ensure CMYK are number, and values are more than or equal to 0, less than or equal to 1
	local c = ( isnumber( c ) ) && math.Clamp( c, 0, 1 ) || 0
	local m = ( isnumber( m ) ) && math.Clamp( m, 0, 1 ) || 0
	local y = ( isnumber( y ) ) && math.Clamp( y, 0, 1 ) || 0
	local k = ( isnumber( k ) ) && math.Clamp( k, 0, 1 ) || 0

	// Calculate RGB from CMYK
	self.r = 255 * ( 1 - c ) * ( 1 - k )
	self.g = 255 * ( 1 - m ) * ( 1 - k )
	self.b = 255 * ( 1 - y ) * ( 1 - k )

	// Use what was populated in the color-object used, or set at 255 if nil
	self.a = ( self.a ) && self.a || 255

	// Return the Color in its' new form
	return self

end

--[[---------------------------------------------------------
	Converts Color to HEX. Some documentation allows ALPHA to
	be used as first 2, last 2 - 1 ( with a at end hence -1 ),
	or last 2... While I Initially added it, I left it out to
	keep it "clean" - loss of precision / alpha lost
-----------------------------------------------------------]]
function COLOR:ToHex( )

	return string.upper( string.format( "%02x%02x%02x", self.r, self.g, self.b ) )

end

--[[---------------------------------------------------------
	Converts HEX to Color. ALTERS Color Object used to
	access function, also uses alpha from Color object instead
	of annoying checks to see if we used Alpha first, with a at end
	or Alpha first without a at end or alpha last... Hex code
	can include # at beginning, or not, it is simply stripped.

	Example: local newcolor = Color( 0, 0, 0, 255 ):FromHex( "#FFFF00" ) -- Yellow
		Is the same same as: local newcolor = Color( 255, 255, 0, 255 ) -- Yellow
-----------------------------------------------------------]]
function COLOR:FromHex( hex )

	// Remove # from the string if added
	local hex = string.gsub( hex, "#", "" )

	// Convert RGB...
	local r = tonumber( string.sub( hex, 1, 2 ), 16 )
	local g = tonumber( string.sub( hex, 3, 4 ), 16 )
	local b = tonumber( string.sub( hex, 5, 6 ), 16 )

	// Update THIS color object so there is a way to get a Color object from HEX Strings...
	self.r = r
	self.g = g
	self.b = b
	self.a = self.a || 255

	return self

end

--[[---------------------------------------------------------
	Converts CMYK Color code to Color Object - loss of precision / alpha lost
-----------------------------------------------------------]]
function CMYKToColor( c, m, y, k )

	return Color( 0, 0, 0, 255 ):FromCMYK(  c, m, y, k );

end

--[[---------------------------------------------------------
	Converts Hex Color code to Color Object - loss of precision / alpha lost
-----------------------------------------------------------]]
function HexToColor( hex )

	return Color( 0, 0, 0, 255 ):FromHex( hex );

end