
include( "math/ease.lua" )

--[[---------------------------------------------------------
	Name: DistanceSqr( low, high )
	Desc: Squared Distance between two 2d points, use this instead of math.Distance as it is more cpu efficient.
------------------------------------------------------------]]
function math.DistanceSqr( x1, y1, x2, y2 )
	local xd = x2 - x1
	local yd = y2 - y1
	return xd * xd + yd * yd
end

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
	return math.min( math.max( _in, low ), high )
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
	Usage: math.EaseInOut(0.1, 0.5, 0.5) - all parameters should be between 0 and 1
-----------------------------------------------------------]]
function math.EaseInOut( fProgress, fEaseIn, fEaseOut )

	if ( fEaseIn == nil ) then fEaseIn = 0 end
	if ( fEaseOut == nil ) then fEaseOut = 1 end

	if ( fProgress == 0 or fProgress == 1 ) then return fProgress end

	local fSumEase = fEaseIn + fEaseOut

	if ( fSumEase == 0 ) then return fProgress end
	if ( fSumEase > 1 ) then
		fEaseIn = fEaseIn / fSumEase
		fEaseOut = fEaseOut / fSumEase
	end

	local fProgressCalc = 1 / ( 2 - fEaseIn - fEaseOut )

	if ( fProgress < fEaseIn ) then
		return ( ( fProgressCalc / fEaseIn ) * fProgress * fProgress )
	elseif ( fProgress < 1 - fEaseOut ) then
		return ( fProgressCalc * ( 2 * fProgress - fEaseIn ) )
	else
		fProgress = 1 - fProgress
		return ( 1 - ( fProgressCalc / fEaseOut ) * fProgress * fProgress )
	end
end


local function KNOT( i, tinc ) return ( i - 3 ) * tinc end

function math.calcBSplineN( i, k, t, tinc )

	if ( k == 1 ) then

		if ( ( KNOT( i, tinc ) <= t ) and ( t < KNOT( i + 1, tinc ) ) ) then

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

--[[---------------------------------------------------------
	Cubic hermite spline
	p0, p1 - points; m0, m1 - tangets; t - fraction along the curve (0-1)
-----------------------------------------------------------]]
function math.CHSpline( t, p0, m0, p1, m1 )

	if ( t >= 1 ) then return p1 end
	if ( t <= 0 ) then return p0 end

	local t2 = t * t
	local t3 = t * t2

	return p0 * ( 2 * t3 - 3 * t2 + 1 ) +
		m0 * ( t3 - 2 * t2 + t ) +
		p1 * ( -2 * t3 + 3 * t2 ) +
		m1 * ( t3 - t2 )

end

-- Round to the nearest integer
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

-- Snaps the provided number to the nearest multiple
function math.SnapTo( num, multiple )
	return math.floor( num / multiple + 0.5 ) * multiple
end

--[[---------------------------------------------------------
	Name: CubicBezier( frac, p0, p1, p2, p3 )
	Desc: Lerp point between points with cubic bezier
-----------------------------------------------------------]]
function math.CubicBezier( frac, p0, p1, p2, p3 )
	local frac2 = frac * frac
	local inv = 1 - frac
	local inv2 = inv * inv

	return inv2 * inv * p0 + 3 * inv2 * frac * p1 + 3 * inv * frac2 * p2 + frac2 * frac * p3
end

--[[---------------------------------------------------------
	Name: QuadraticBezier( frac, p0, p1, p2 )
	Desc: Lerp point between points with quadratic bezier
-----------------------------------------------------------]]
function math.QuadraticBezier( frac, p0, p1, p2 )
	local frac2 = frac * frac
	local inv = 1 - frac
	local inv2 = inv * inv

	return inv2 * p0 + 2 * inv * frac * p1 + frac2 * p2
end
