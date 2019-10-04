
local COLOR = {}

local numerical_keys = { [1] = "r", [2] = "g", [3] = "b", [4] = "a" }
local allowed_keys = { r = true, g = true, b = true, a = true }

COLOR.__index = function( col, k )
	local comp = numerical_keys[ k ]

	if ( comp ) then
		return rawget( col, comp )
	end

	-- If these somehow become unset, don't index the Color metatable
	if ( allowed_keys[ k ] ) then return nil end

	return COLOR[ k ]
end

COLOR.__newindex = function( col, k, v )
	if ( allowed_keys[ k ] ) then
		-- If a valid component was set to nil, allow setting it back to a number
		if ( isnumber( v ) ) then
			rawset( col, k, v )
		else
			ErrorNoHaltStack( "attempted to set key \"" .. k .. "\" on Color to " .. type( v ) .. ", number expected", 2 )
		end
	else
		ErrorNoHaltStack( "attempted to alter invalid key \"" .. k .. "\" on Color", 2 )
	end
end

--[[---------------------------------------------------------
	Register our metatable to make it accessible using FindMetaTable
-----------------------------------------------------------]]

debug.getregistry().Color = COLOR

--[[---------------------------------------------------------
	To easily create a color table
-----------------------------------------------------------]]
function Color( r, g, b, a )
	return setmetatable( {
		r = r == nil && 255 || math.max( math.min( tonumber(r), 255 ), 0 ),
		g = g == nil && 255 || math.max( math.min( tonumber(g), 255 ), 0 ),
		b = b == nil && 255 || math.max( math.min( tonumber(b), 255 ), 0 ),
		a = a == nil && 255 || math.max( math.min( tonumber(a), 255 ), 0 )
	}, COLOR )
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

function COLOR:SetUnpacked( r, g, b, a )

	self.r = r or 255
	self.g = g or 255
	self.b = b or 255
	self.a = a or 255

end

function COLOR:ToTable()

	return { self.r, self.g, self.b, self.a }

end
