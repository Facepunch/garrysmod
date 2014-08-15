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

	// String Length for errorchecking
	local hexlen = string.len( hex )

	// Boolean vars to detect shorthand vs standard, if shorthand, set x to -1 to modify rgb string.sub values
	local bShorthand = ( hexlen == 3 )
	local bStandard = ( _hexlen == 6 )
	local x = ( bShorthand ) && -1 || 0

	// Error checking; if we're not using shorthand, and not standard, we won't know what to do other than error, nicely...
	if ( !bShorthand && !bStandard ) then

		ErrorNoHalt( "You must enter valid hex-code to convert hex-to-color.\nIf you're using shorthand, valid input is #FFF or FFF, alternatively, if using standard, valid input is #FFFFFF or FFFFFF.\nNOTE: The color is unchanged from default!" )

		return self

	end

	// Convert RGB... If shorthand is used, ensure 1,2,3 using value adjuster x.
	local r = tonumber( string.rep( string.sub( hex, 1, 2 + x ), ( bShorthand && 2 || 1 ) ), 16 )
	local g = tonumber( string.rep( string.sub( hex, 3 + x, 4 + x * 2 ), ( bShorthand && 2 || 1 ) ), 16 )
	local b = tonumber( string.rep( string.sub( hex, 5 + x * 2, 6 + x * 2 ), ( bShorthand && 2 || 1 ) ), 16 )

	// Update THIS color object so there is a way to get a Color object from HEX Strings...
	self.r = r
	self.g = g
	self.b = b
	self.a = self.a || 255

	return self

end

--[[---------------------------------------------------------
	Converts Hex Color code to Color Object - loss of precision / alpha lost
-----------------------------------------------------------]]
function HexToColor( hex )

	return Color( 0, 0, 0, 255 ):FromHex( hex );

end