
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

	return setmetatable( {
		r = math.min( tonumber( r ), 255 ),
		g = math.min( tonumber( g ), 255 ),
		b = math.min( tonumber( b ), 255 ),
		a = math.min( tonumber( a or 255 ), 255 )
	}, COLOR )

end

--[[---------------------------------------------------------
	Change the alpha of a color
-----------------------------------------------------------]]
function ColorAlpha( c, a )

	return Color( c.r, c.g, c.b, a )

end

--[[---------------------------------------------------------
	Checks if the given variable is a color object
-----------------------------------------------------------]]
function IsColor( obj )

	return getmetatable( obj ) == COLOR

end

--[[---------------------------------------------------------
	Different color represntations
-----------------------------------------------------------]]
function HSVToColor( h, s, v )

	h = h % 360

	local c = v * s
	local x = c * ( 1 - math.abs( ( h / 60 ) % 2 - 1 ) )
	local m = v - c

	local r, g, b
	if ( h < 60 ) then
		r, g, b = c, x, 0
	elseif ( h < 120 ) then
		r, g, b = x, c, 0
	elseif ( h < 180 ) then
		r, g, b = 0, c, x
	elseif ( h < 240 ) then
		r, g, b = 0, x, c
	elseif ( h < 300 ) then
		r, g, b = x, 0, c
	else
		r, g, b = c, 0, x
	end

	return Color(
		math.Clamp( math.floor( ( r + m ) * 255 ), 0, 255 ),
		math.Clamp( math.floor( ( g + m ) * 255 ), 0, 255 ),
		math.Clamp( math.floor( ( b + m ) * 255 ), 0, 255 )
	)

end

function HSLToColor( h, s, l )

	h = h % 360

	local c = ( 1 - math.abs( 2 * l - 1 ) ) * s
	local x = c * ( 1 - math.abs( ( h / 60 ) % 2 - 1 ) )
	local m = l - c / 2

	local r, g, b
	if ( h < 60 ) then
		r, g, b = c, x, 0
	elseif ( h < 120 ) then
		r, g, b = x, c, 0
	elseif ( h < 180 ) then
		r, g, b = 0, c, x
	elseif ( h < 240 ) then
		r, g, b = 0, x, c
	elseif ( h < 300 ) then
		r, g, b = x, 0, c
	else
		r, g, b = c, 0, x
	end

	return Color(
		math.Clamp( math.floor( ( r + m ) * 255 ), 0, 255 ),
		math.Clamp( math.floor( ( g + m ) * 255 ), 0, 255 ),
		math.Clamp( math.floor( ( b + m ) * 255 ), 0, 255 )
	)

end

function HWBToColor( h, w, b )

	local v = 1 - b
	local s = 0
	if ( v > 0 ) then
		s = 1 - w / v
	end

	return HSVToColor( h, s, v )

end

local hex_to_dec = {}
for code = 48, 57 do hex_to_dec[ code ] = code - 48 end  -- '0'–'9'
for code = 65, 70 do hex_to_dec[ code ] = code - 55 end  -- 'A'–'F'
for code = 97, 102 do hex_to_dec[ code ] = code - 87 end -- 'a'–'f'

function HexToColor( hex )

	local idx = string.byte( hex, 1 ) == 35 and 2 or 1 -- '#' check without allocation
	local len = #hex - ( idx - 1 )

	if ( len == 3 or len == 4 ) then

		local r, g, b, a = string.byte( hex, idx, idx + len - 1 )
		r = hex_to_dec[ r ]
		g = hex_to_dec[ g ]
		b = hex_to_dec[ b ]
		a = a and hex_to_dec[ a ] or 15

		if !( r and g and b and a ) then
			return error( "invalid hex input: " .. hex )
		end

		return Color( r * 16 + r, g * 16 + g, b * 16 + b, a * 16 + a )

	elseif ( len == 6 or len == 8 ) then

		local r1, r2, g1, g2, b1, b2, a1, a2 = string.byte( hex, idx, idx + len - 1 )
		r1, r2 = hex_to_dec[ r1 ], hex_to_dec[ r2 ]
		g1, g2 = hex_to_dec[ g1 ], hex_to_dec[ g2 ]
		b1, b2 = hex_to_dec[ b1 ], hex_to_dec[ b2 ]
		a1, a2 = a1 and hex_to_dec[ a1 ] or 15, a2 and hex_to_dec[ a2 ] or 15

		if !( r1 and r2 and g1 and g2 and b1 and b2 and a1 and a2 ) then
			return error( "invalid hex input: " .. hex )
		end

		return Color( r1 * 16 + r2, g1 * 16 + g2, b1 * 16 + b2, a1 * 16 + a2 )

	end

	return error( "invalid hex input: " .. hex )

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
	Converts a color to HSV color space
-----------------------------------------------------------]]
function COLOR:ToHSV()

	return ColorToHSV( self )

end

--[[---------------------------------------------------------
	Converts a color to HWB color space
-----------------------------------------------------------]]
function COLOR:ToHWB()

	local h, s, v = self:ToHSV()
	return h, ( 1 - s ) * v, 1 - v

end

--[[---------------------------------------------------------
	Converts color to a hex string
-----------------------------------------------------------]]
function COLOR:ToHex( omitAlpha )

	if ( omitAlpha or self.a == 255 ) then
		return string.format( "#%02x%02x%02x", self.r, self.g, self.b )
	end

	return string.format( "#%02x%02x%02x%02x", self.r, self.g, self.b, self.a )

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

function COLOR:Copy()

    return Color( self.r, self.g, self.b, self.a )

end

function COLOR:Lerp( target_clr, frac )

	return Color(
		Lerp( frac, self.r, target_clr.r ),
		Lerp( frac, self.g, target_clr.g ),
		Lerp( frac, self.b, target_clr.b ),
		Lerp( frac, self.a, target_clr.a )
	)

end

function COLOR:SetUnpacked( r, g, b, a )

	if ( r != nil and !isnumber( r ) ) then error( "bad argument #1 to 'SetUnpacked' (number expected, got " .. type( r ) .. ")", 2 ) end
	if ( g != nil and !isnumber( g ) ) then error( "bad argument #2 to 'SetUnpacked' (number expected, got " .. type( g ) .. ")", 2 ) end
	if ( b != nil and !isnumber( b ) ) then error( "bad argument #3 to 'SetUnpacked' (number expected, got " .. type( b ) .. ")", 2 ) end
	if ( a != nil and !isnumber( a ) ) then error( "bad argument #4 to 'SetUnpacked' (number expected, got " .. type( a ) .. ")", 2 ) end

	self.r = r or 255
	self.g = g or 255
	self.b = b or 255
	self.a = a or 255

end

function COLOR:ToTable()

	return { self.r, self.g, self.b, self.a }

end

local function ColorCopy( dest, origin )

	dest.r = origin.r
	dest.g = origin.g
	dest.b = origin.b

end

-- HSV hue
function COLOR:GetHue()

	local hue = self:ToHSV()
	return hue

end

function COLOR:SetHue( hue )

	local _, saturation, brightness = self:ToHSV()
	hue = hue % 360
	ColorCopy( self, HSVToColor( hue, saturation, brightness ) )

end

function COLOR:AddHue( hueAdd )

	local hue, saturation, brightness = self:ToHSV()
	hue = ( hue + hueAdd ) % 360
	ColorCopy( self, HSVToColor( hue, saturation, brightness ) )

end

-- HSV saturation
function COLOR:GetSaturation()

	local _, saturation = self:ToHSV()
	return saturation

end

function COLOR:SetSaturation( saturation )

	local hue, _, brightness = self:ToHSV()
	saturation = math.Clamp( saturation, 0, 1 )
	ColorCopy( self, HSVToColor( hue, saturation, brightness ) )

end

function COLOR:AddSaturation( saturationAdd )

	local hue, saturation, brightness = self:ToHSV()
	saturation = math.Clamp( saturation + saturationAdd, 0, 1 )
	ColorCopy( self, HSVToColor( hue, saturation, brightness ) )

end

-- HSV brightness
function COLOR:GetBrightness()

	local _, _, brightness = self:ToHSV()
	return brightness

end

function COLOR:SetBrightness( brightness )

	local hue, saturation = self:ToHSV()
	brightness = math.Clamp( brightness, 0, 1 )
	ColorCopy( self, HSVToColor( hue, saturation, brightness ) )

end

function COLOR:AddBrightness( brightnessAdd )

	local hue, saturation, brightness = self:ToHSV()
	brightness = math.Clamp( brightness + brightnessAdd, 0, 1 )
	ColorCopy( self, HSVToColor( hue, saturation, brightness ) )

end

-- HSL lightness
function COLOR:GetLightness()

	local _, _, lightness = self:ToHSL()
	return lightness

end

function COLOR:SetLightness( lightness )

	local hue, saturation = self:ToHSL()
	lightness = math.Clamp( lightness, 0, 1 )
	ColorCopy( self, HSLToColor( hue, saturation, lightness ) )

end

function COLOR:AddLightness( lightnessAdd )

	local hue, saturation, lightness = self:ToHSL()
	lightness = math.Clamp( lightness + lightnessAdd, 0, 1 )
	ColorCopy( self, HSLToColor( hue, saturation, lightness ) )

end

-- HWB whiteness
function COLOR:GetWhiteness()

	local _, whiteness = self:ToHWB()
	return whiteness

end

function COLOR:SetWhiteness( whiteness )

	local hue, _, blackness = self:ToHWB()
	whiteness = math.Clamp( whiteness, 0, 1 )
	ColorCopy( self, HWBToColor( hue, whiteness, blackness ) )

end

function COLOR:AddWhiteness( whitenessAdd )

	local hue, whiteness, blackness = self:ToHWB()
	whiteness = math.Clamp( whiteness + whitenessAdd, 0, 1 )
	ColorCopy( self, HWBToColor( hue, whiteness, blackness ) )

end

-- HWB blackness
function COLOR:GetBlackness()

	local _, _, blackness = self:ToHWB()
	return blackness

end

function COLOR:SetBlackness( blackness )

	local hue, whiteness = self:ToHWB()
	blackness = math.Clamp( blackness, 0, 1 )
	ColorCopy( self, HWBToColor( hue, whiteness, blackness ) )

end

function COLOR:AddBlackness( blacknessAdd )

	local hue, whiteness, blackness = self:ToHWB()
	blackness = math.Clamp( blackness + blacknessAdd, 0, 1 )
	ColorCopy( self, HWBToColor( hue, whiteness, blackness ) )

end
