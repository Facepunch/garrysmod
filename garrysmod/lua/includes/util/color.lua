
local COLOR = {}
COLOR.__index = COLOR

--[[---------------------------------------------------------
	Register our metatable to make it accessible using FindMetaTable
-----------------------------------------------------------]]
RegisterMetaTable( "Color", COLOR )

--[[---------------------------------------------------------
	To easily create a color table
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
	Returns unary color
-----------------------------------------------------------]]
function COLOR:__unm()

	return self:GetInverted()

end

--[[---------------------------------------------------------
	Returns colors summ
-----------------------------------------------------------]]

function COLOR:__add( other )

	return Color( self.r + other.r, self.g + other.g, self.b + other.b, self.a + other.a )

end

--[[---------------------------------------------------------
	Returns colors subtraction
-----------------------------------------------------------]]

function COLOR:__sub(other)

	return Color( self.r - other.r, self.g - other.g, self.b - other.b, self.a - other.a )

end

--[[---------------------------------------------------------
	Returns color multiplication with another color or number
-----------------------------------------------------------]]

function COLOR:__mul(other)

	if ( type( other ) == "number" ) then
		return Color( self.r * other, self.g * other, self.b * other, self.a * other )
	end

	return Color( self.r * other.r, self.g * other.g, self.b * other.b, self.a * other.a )

end

--[[---------------------------------------------------------
	Returns color division with another color or number
-----------------------------------------------------------]]

function COLOR:__div( other )

	if ( type( other ) == "number" ) then
		return Color( self.r / other, self.g / other, self.b / other, self.a / other )
	end

	return Color( self.r / other.r, self.g / other.g, self.b / other.b, self.a / other.a )

end

--[[---------------------------------------------------------
	Returns is color darker than other
-----------------------------------------------------------]]

function COLOR:__lt( other )

	return select( 3, self:ToHSL() ) < select( 3, other:ToHSL() )

end

--[[---------------------------------------------------------
	Returns is color darker than other or have the same lightness
-----------------------------------------------------------]]

function COLOR:__le( other )

	return select( 3, self:ToHSL() ) <= select( 3, other:ToHSL() )

end

--[[---------------------------------------------------------
	Compares two colors
-----------------------------------------------------------]]
function COLOR:__eq( c )

	return self.r == c.r and self.g == c.g and self.b == c.b and self.a == c.a

end

--[[---------------------------------------------------------
	Converts a color to HSL color space
-----------------------------------------------------------]]
function COLOR:ToHSL()

	return ColorToHSL( self )

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

--[[---------------------------------------------------------
	Unpacks the color into four variables
-----------------------------------------------------------]]
function COLOR:Unpack()

	return self.r, self.g, self.b, self.a

end

function COLOR:Lerp( target_clr, frac )

	return Color( Lerp( frac, self.r, target_clr.r ), Lerp( frac, self.g, target_clr.g ), Lerp( frac, self.b, target_clr.b ), Lerp( frac, self.a, target_clr.a ) )

end

function COLOR:SetUnpacked( r, g, b, a )

	self.r = r or 255
	self.g = g or 255
	self.b = b or 255
	self.a = a or 255

end

function COLOR:ToTable()

	return { self.r, self.g, self.b, self.a }

end

function COLOR:Copy()

	return Color( self.r, self.g, self.b, self.a )

end

function COLOR:Invert()

	self.r = 255 - self.r
	self.g = 255 - self.g
	self.b = 255 - self.b

end

function COLOR:GetInverted()

	local col = self:Copy()
	col:Invert()

	return col

end

function COLOR:Normalize()

	self.r = self.r / 255
	self.g = self.g / 255
	self.b = self.b / 255
	self.a = self.a / 255

end

function COLOR:GetNormalized()

	local col = self:Copy()
	col:Normalize()

	return col

end

function COLOR:Add( other )

	self.r = self.r + other.r
	self.g = self.g + other.g
	self.b = self.b + other.b
	self.a = self.a + other.a

end

function COLOR:Sub( other )

	self.r = self.r - other.r
	self.g = self.g - other.g
	self.b = self.b - other.b
	self.a = self.a - other.a

end

function COLOR:Mul( multiplier )

	self.r = self.r * multiplier
	self.g = self.g * multiplier
	self.b = self.b * multiplier
	self.a = self.a * multiplier

end

function COLOR:Div( divisor )

	self.r = self.r / divisor
	self.g = self.g / divisor
	self.b = self.b / divisor
	self.a = self.a / divisor

end
