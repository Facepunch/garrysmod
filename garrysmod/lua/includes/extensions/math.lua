local Vector = Vector
local tonumber = tonumber
local bit_band = bit.band
local math_abs = math.abs
local math_log = math.log
local math_max = math.max
local math_min = math.min
local math_ceil = math.ceil
local math_sqrt = math.sqrt
local math_floor = math.floor
local bit_lshift = bit.lshift
local bit_rshift = bit.rshift
local math_random = math.random
local string_format = string.format

function math.Distance( x1, y1, x2, y2 )
	local xd = x2 - x1
	local yd = y2 - y1

	return math_sqrt( xd * xd + yd * yd )
end
math.Dist = math.Distance -- Backwards compatibility

function math.DistanceSqr( x1, y1, x2, y2 )
	local xd = x2 - x1
	local yd = y2 - y1

	return xd * xd + yd * yd
end

--[[---------------------------------------------------------
	Name: Clamp( in, low, high )
	Desc: Clamp value between 2 values
------------------------------------------------------------]]
function math.Clamp( _in, low, high )
	return math_min( math_max( _in, low ), high )
end

function math.Rand( low, high )
	return low + ( high - low ) * math_random()
end

math.Max = math_max
math.Min = math_min

function math.EaseInOut( fProgress, fEaseIn, fEaseOut )
	if ( fProgress == 0 || fProgress == 1 ) then return fProgress end

	if ( fEaseIn == nil ) then fEaseIn = 0 end
	if ( fEaseOut == nil ) then fEaseOut = 1 end

	local fSumEase = fEaseIn + fEaseOut
	if ( fSumEase == 0 ) then return fProgress end

	if ( fSumEase > 1 ) then
		fEaseIn = fEaseIn / fSumEase
		fEaseOut = fEaseOut / fSumEase
	end

	local fProgressCalc = 1 / ( 2 - fEaseIn - fEaseOut )

	if( fProgress < fEaseIn ) then
		return fProgressCalc / fEaseIn * fProgress * fProgress
	end

	if( fProgress < 1 - fEaseOut ) then
		return fProgressCalc * ( 2 * fProgress - fEaseIn )
	end

	fProgress = 1 - fProgress

	return 1 - fProgressCalc / fEaseOut * fProgress * fProgress
end

local function math_calcBSplineN( i, k, t, tinc )
	local knot = ( i - 3 ) * tinc

	if ( k <= 1 ) then
		if ( knot <= t && t < knot + tinc ) then
			return 1
		end

		return 0
	end

	local count = i + k - 4
	local len = count * tinc
	local knots = len - knot

	local nknot = k - 1
	local ret = 0

	if ( knots > 0 ) then
		ret = ( t - knot ) * math_calcBSplineN( i, nknot, t, tinc ) / knots
	end

	local sb = nknot * tinc

	if ( sb > 0 ) then
		ret = ret + ( len + tinc - t ) * math_calcBSplineN( i + 1, nknot, t, tinc ) / sb
	end

	return ret
end
math.calcBSplineN = math_calcBSplineN

function math.BSplinePoint( tDiff, tPoints, tMax )
	local len = #tPoints
	local tinc = tMax / ( len - 3 )
	tDiff = tDiff + tinc

	local Q = Vector()
	local fAdd = Q.Add

	for i = 1, len do
		fAdd( Q, math_calcBSplineN( i, 4, tDiff, tinc ) * tPoints[ i ] )
	end

	return Q
end

-- Round to the nearest interger
function math.Round( num, idp --[[= 0]] )
	local mult = 10 ^ ( idp || 0 )

	return math_floor( num * mult + 0.5 ) / mult
end

-- Rounds towards zero
function math.Truncate( num, idp --[[= 0]] )
	local mult = 10 ^ ( idp || 0 )

	return ( num < 0 && math_ceil || math_floor )( num * mult ) / mult
end

local function math_Approach( cur, target, inc )
	if ( cur < target ) then
		return math_min( cur + math_abs( inc ), target )
	end

	if ( cur > target ) then
		return math_max( cur - math_abs( inc ), target )
	end

	return target
end
math.Approach = math_Approach

local function math_NormalizeAngle( a )
	return ( a + 180 ) % 360 - 180
end
math.NormalizeAngle = math_NormalizeAngle

local function math_AngleDifference( a, b )
	local diff = math_NormalizeAngle( a - b )

	if ( diff < 180 ) then
		return diff
	end

	return diff - 360
end
math.AngleDifference = math_AngleDifference

function math.ApproachAngle( cur, target, inc )
	return math_Approach( cur, cur + math_AngleDifference( target, cur ), inc )
end

function math.TimeFraction( Start, End, Current )
	return ( Current - Start ) / ( End - Start )
end

function math.Remap( value, inMin, inMax, outMin, outMax )
	return outMin + ( value - inMin ) / ( inMax - inMin ) * ( outMax - outMin )
end

function math.BitCount( num )
	return math_floor( math_log( tonumber( string_format( "%u", num ) ), 2 ) ) + 1
end

function math.BinToInt( bin )
	return tonumber( bin, 2 )
end

function math.IntToBin( num )
	num = tonumber( string_format( "%u", num ) )
	local ret = ""

	-- Iterate backward since the highest bit is at the beginning of the string
	-- i = #binary_string - 1
	for i = math_floor( math_log( num, 2 ) ), 0, -1 do
		-- Mask each bit and add it on to the string
		ret = ret .. bit_rshift( bit_band( num, bit_lshift( 1, i ) ), i )
	end

	return ret
end

local translate = {
	[0] = "0", "1", "2", "3", "4", "5", "6",
	"7", "8", "9", "a", "b", "c", "d", "e",
	"f", "g", "h", "i", "j", "k", "l", "m",
	"n", "o", "p", "q", "r", "s", "t", "u",
	"v", "w", "x", "y", "z"
}

local maxbase = #translate + 1
local translateUpper = {}

for i = 0, maxbase - 1 do
	translateUpper[ i ] = string.upper( translate[ i ] )
end

function math.IntToString( num, base, caps --[[= false]] )
	-- Make sure we're dealing with positive integers
	num = tonumber( string_format( "%u", num ) )
	base = math_floor( base )

	if ( base < 2 || base > maxbase ) then
		error( "bad argument #2 to 'IntToString' (base out of range)", 2 )
	end

	local tbl = caps && translateUpper || translate
	local ret = ""

	-- floor(log base b(num)) + 1 calculates
	-- the length of the base string of a number
	for i = math_floor( math_log( num, base ) ), 0, -1 do
		local testbase = base ^ i

		-- Find the digit for this spot
		-- This will be an integer [0, base)
		local digit = math_floor( num / testbase )

		-- Scale the digit to the proper power
		-- then subtract it from the total number
		num = num - digit * testbase

		-- Add on the digit
		ret = ret .. tbl[ digit ]
	end

	return ret
end
