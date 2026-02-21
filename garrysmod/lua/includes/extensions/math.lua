
include( "math/ease.lua" )

math.tau = 2 * math.pi

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
function math.EaseInOut( frac, easeIn, easeOut )
	if ( frac == 0 or frac == 1 ) then return frac end

	if ( easeIn == nil ) then easeIn = 0 end
	if ( easeOut == nil ) then easeOut = 1 end

	local fSumEase = easeIn + easeOut

	if ( fSumEase == 0 ) then return frac end
	if ( fSumEase > 1 ) then
		easeIn = easeIn / fSumEase
		easeOut = easeOut / fSumEase
	end

	local fProgressCalc = 1 / ( 2 - easeIn - easeOut )

	if ( frac < easeIn ) then
		return ( ( fProgressCalc / easeIn ) * frac * frac )
	elseif ( frac < 1 - easeOut ) then
		return ( fProgressCalc * ( 2 * frac - easeIn ) )
	else
		frac = 1 - frac
		return ( 1 - ( fProgressCalc / easeOut ) * frac * frac )
	end
end

function math.calcBSplineN( i, k, t, tInc )
	local knot = ( i - 3 ) * tInc

	if ( k <= 1 ) then
		if ( knot <= t && t < knot + tInc ) then
			return 1
		end

		return 0
	end

	local count = i + k - 4
	local len = count * tInc
	local knots = len - knot

	local nknot = k - 1
	local ret = 0

	if ( knots > 0 ) then
		ret = ( t - knot ) * math.calcBSplineN( i, nknot, t, tInc ) / knots
	end

	local sb = nknot * tInc

	if ( sb > 0 ) then
		ret = ret + ( len + tInc - t ) * math.calcBSplineN( i + 1, nknot, t, tInc ) / sb
	end

	return ret
end

function math.BSplinePoint( frac, points, frac_max )
	local len = #points
	local tInc = frac_max / ( len - 3 )
	frac = frac + tInc

	local ret = Vector()
	for i = 1, len do
		ret:Add( math.calcBSplineN( i, 4, frac, tInc ) * points[ i ] )
	end

	return ret
end

--[[---------------------------------------------------------
	Cubic hermite spline
	p0, p1 - points; m0, m1 - tangets; frac - fraction along the curve (0-1)
-----------------------------------------------------------]]
function math.CHSpline( frac, p0, m0, p1, m1 )
	if ( frac >= 1 ) then return p1 end
	if ( frac <= 0 ) then return p0 end

	local t2 = frac * frac
	local t3 = frac * t2

	return p0 * ( 2 * t3 - 3 * t2 + 1 ) +
		m0 * ( t3 - 2 * t2 + frac ) +
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
	return ( num < 0 and math.ceil or math.floor )( num * mult ) / mult
end

function math.Approach( cur, target, inc )
	if ( cur < target ) then
		return math.min( cur + math.abs( inc ), target )
	end

	if ( cur > target ) then
		return math.max( cur - math.abs( inc ), target )
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
	return math.Approach( cur, cur + math.AngleDifference( target, cur ), inc )
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

--[[---------------------------------------------------------
	Name: Factorial( num )
	Desc: Calculate the factorial value of num
-----------------------------------------------------------]]
function math.Factorial( num )
	if ( num < 0 ) then
		return nil
	elseif ( num < 2 ) then
		return 1
	end

	local res = 1
	for i = 2, num do
		res = res * i
	end

	return res
end

--[[---------------------------------------------------------
	Name: IsNearlyEqual( a, b, tolerance )
	Desc: Checks if two floating point numbers are nearly equal
-----------------------------------------------------------]]
function math.IsNearlyEqual( a, b, tolerance )
	if ( tolerance == nil ) then
		tolerance = 1e-8
	end

	return math.abs( a - b ) <= tolerance
end
