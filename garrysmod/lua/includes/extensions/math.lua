
--[[---------------------------------------------------------
	Name: Distance( low, high )
	Desc: Distance between two 2d points
------------------------------------------------------------]]
function math.Distance( x1, y1, x2, y2 )
	local xd = x2 - x1
	local yd = y2 - y1
	return math.sqrt( xd * xd + yd * yd )
end
math.Dist = math.Distance -- Backwards compatibility

--[[---------------------------------------------------------
	Name: BinToInt( bin )
	Desc: Convert a binary string to an integer number
------------------------------------------------------------]]
function math.BinToInt( bin )
	return tonumber( bin, 2 )
end

--[[---------------------------------------------------------
	Name: IntToBin( int )
	Desc: Convert an integer number to a binary string (the string len will be a multiple of three)
------------------------------------------------------------]]
local intbin = {
	["0"] = "000", ["1"] = "001", ["2"] = "010", ["3"] = "011",
	["4"] = "100", ["5"] = "101", ["6"] = "110", ["7"] = "111"
}

function math.IntToBin( int )
	local str = string.gsub( string.format( "%o", int ), "(.)", function ( d ) return intbin[ d ] end )
	return str
end

--[[---------------------------------------------------------
	Name: Clamp( in, low, high )
	Desc: Clamp value between 2 values
------------------------------------------------------------]]
function math.Clamp( _in, low, high )
	if ( _in < low ) then return low end
	if ( _in > high ) then return high end
	return _in
end

--[[---------------------------------------------------------
	Name: Rand( low, high )
	Desc: Random number between low and high
-----------------------------------------------------------]]
function math.Rand( low, high )
	return low + ( high - low ) * math.random()
end

math.Max = math.max
math.Min = math.min

--[[---------------------------------------------------------
	Name: EaseInOut(fProgress, fEaseIn, fEaseOut)
	Desc: Provided by garry from the facewound source and converted
			to Lua by me :p
	Usage: math.EaseInOut(0.1, 0.5, 0.5) - all parameters shoule be between 0 and 1
-----------------------------------------------------------]]
function math.EaseInOut( fProgress, fEaseIn, fEaseOut )

	if ( fEaseIn == nil ) then fEaseIn = 0 end
	if ( fEaseOut == nil ) then fEaseOut = 1 end

	if ( fProgress == 0 || fProgress == 1 ) then return fProgress end

	local fSumEase = fEaseIn + fEaseOut

	if ( fSumEase == 0 ) then return fProgress end
	if ( fSumEase > 1 ) then
		fEaseIn = fEaseIn / fSumEase
		fEaseOut = fEaseOut / fSumEase
	end

	local fProgressCalc = 1 / ( 2 - fEaseIn - fEaseOut )

	if( fProgress < fEaseIn ) then
		return ( ( fProgressCalc / fEaseIn ) * fProgress * fProgress )
	elseif( fProgress < 1 - fEaseOut ) then
		return ( fProgressCalc * ( 2 * fProgress - fEaseIn ) )
	else
		fProgress = 1 - fProgress
		return ( 1 - ( fProgressCalc / fEaseOut ) * fProgress * fProgress )
	end
end


local function KNOT( i, tinc ) return ( i - 3 ) * tinc end

function math.calcBSplineN( i, k, t, tinc )

	if ( k == 1 ) then

		if ( ( KNOT( i, tinc ) <= t ) && ( t < KNOT( i + 1, tinc ) ) ) then

			return 1

		else

			return 0

		end

	else

		local ft = ( t - KNOT( i, tinc ) ) * math.calcBSplineN( i, k - 1, t, tinc )
		local fb = KNOT( i + k - 1, tinc ) - KNOT( i, tinc )

		local st = ( KNOT( i + k, tinc ) - t ) * math.calcBSplineN( i + 1, k - 1, t, tinc )
		local sb = KNOT( i + k, tinc ) - KNOT( i + 1, tinc )

		local first = 0
		local second = 0

		if ( fb > 0 ) then

			first = ft / fb

		end
		if ( sb > 0 ) then

			second = st / sb

		end

		return first + second

	end

end

function math.BSplinePoint( tDiff, tPoints, tMax )

	local Q = Vector( 0, 0, 0 )
	local tinc = tMax / ( #tPoints - 3 )

	tDiff = tDiff + tinc

	for idx, pt in pairs( tPoints ) do

		local n = math.calcBSplineN( idx, 4, tDiff, tinc )
		Q = Q + ( n * pt )

	end

	return Q

end

-- Round to the nearest interger
function math.Round( num, idp )

	local mult = 10 ^ ( idp or 0 )
	return math.floor( num * mult + 0.5 ) / mult

end

-- Rounds towards zero
function math.Truncate( num, idp )

	local mult = 10 ^ ( idp or 0 )
	local FloorOrCeil = num < 0 and math.ceil or math.floor

	return FloorOrCeil( num * mult ) / mult

end

function math.Approach( cur, target, inc )

	inc = math.abs( inc )

	if ( cur < target ) then

		return math.min( cur + inc, target )

	elseif ( cur > target ) then

		return math.max( cur - inc, target )

	end

	return target

end

function math.NormalizeAngle( a )
	return ( a + 180 ) % 360 - 180
end


function math.AngleDifference( a, b )

	local diff = math.NormalizeAngle( a - b )

	if ( diff < 180 ) then
		return diff
	end

	return diff - 360

end

function math.ApproachAngle( cur, target, inc )

	local diff = math.AngleDifference( target, cur )

	return math.Approach( cur, cur + diff, inc )

end

function math.TimeFraction( Start, End, Current )
	return ( Current - Start ) / ( End - Start )
end

function math.Remap( value, inMin, inMax, outMin, outMax )
	return outMin + ( ( ( value - inMin ) / ( inMax - inMin ) ) * ( outMax - outMin ) )
end

function math.DoubleToInt32s( double )
    local high, low = 0,0
    -- Sign
    if double < 0 or 1/double < 0 then
        high = 0x80000000
        double = -double
    end

    -- Spcial cases
    if double == 0 then -- Zero
        return high, 0
    elseif double == math.huge then -- Inf
        return high + 0x7FF00000, 0
    elseif double ~= double then -- NaN
        return 0x7FFFFFFF,0xFFFFFFFF
    end

    local mantissa, exponent = math.frexp( double )
    if exponent > -1022 then
        -- Normalized numbers
        mantissa = mantissa*(2^53)
        low = mantissa % 0x100000000
        return high + bit.lshift(exponent+1022,20) + (mantissa-low)*2^-32 - 0x00100000, low
    else
        -- Denormalized numbers
        mantissa = mantissa*(2^(exponent+1074))
        low = mantissa % 0x100000000
        return high + (mantissa-low)*2^-32, low
    end
end

function math.Int32sToDouble( high, low )
    local negative = bit.band(high,0x80000000) ~= 0
    local exponent = bit.rshift(bit.band(high,0x7FF00000),20)-1022
    high = bit.band(high,0x000FFFFF)

    -- Spcial cases
    if exponent == 1025 then
        if high == 0 and low == 0 then
            return negative and -math.huge or math.huge
        end
        return 0/0
    end

    if low < 0 then low = low + 0x100000000 end -- Fix sign for low bits

    if exponent ~= -1022 then
        -- Normalized
        return negative
            and -math.ldexp( (high*2^32+low)*(2^-53)+0.5, exponent ) 
            or   math.ldexp( (high*2^32+low)*(2^-53)+0.5, exponent )
    else 
        -- Denormalized
        return negative 
            and -math.ldexp( (high*2^32+low)*(2^-52), exponent ) 
            or   math.ldexp( (high*2^32+low)*(2^-52), exponent )
    end
end

function math.FloatToInt32( float )
    -- Sign
    local sign = 0
    if float < 0 or 1/float < 0 then
        sign = 0x80000000
        float = -float
    end

    -- Spcial cases
    if float == 0 then -- Zero
        return sign
    elseif float == math.huge then -- Inf
        return sign + 0x7F800000
    elseif float ~= float then -- NaN
        return 0x7fffffff
    end

    local mantissa, exponent = math.frexp( float )
    if exponent > -126 then -- Normalized
        return sign + bit.lshift(exponent+126,23) + math.floor(mantissa*(2^24)+0.5)-0x800000      
    else -- Denormalized
        return sign + math.floor(mantissa*(2^(exponent+149))+0.5)
    end
end

function math.Int32ToFloat( int )
    local negative = bit.band(int,0x80000000) ~= 0
    local exponent = bit.rshift(bit.band(int,0x7F800000),23)-126
    int = bit.band(int,0x007fffff)

    -- Spcial cases
    if exponent == 129 then
        if int == 0 then
            return negative and -math.huge or math.huge
        end
        return 0/0
    end

    if exponent ~= -126 then -- Normalized
        return negative and -math.ldexp( int*(2^-24)+0.5, exponent ) or math.ldexp( int*(2^-24)+0.5, exponent )
    else -- Denormalized
        return negative and -math.ldexp( int*(2^-23), exponent ) or math.ldexp( int*(2^-23), exponent )
    end
end
