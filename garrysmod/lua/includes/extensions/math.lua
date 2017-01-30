
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

--[[---------------------------------------------------------
    Name: GetNumbersFromTbl( table, subtablecount )
    Desc: Loops through a table to retrieve any values that have the type of a number
    Usage: GetNumbersFromTbl({ 1, 2, 3, { 4 } }, 0 )) > 1, 2, 3 
    (Loop through 0 subtables)
    GetNumbersFromTbl({ 1, 2, 3, { 4 } }, 1 )) > 1, 2, 3, 4 
    (Loop through 1 subtable)
-----------------------------------------------------------]]
function math.GetNumbersFromTbl( tbl, sub )
    local numbers, subsdone = {}, 0
    local function TblLoop( tbl, subcount )
        for _, val in pairs( tbl ) do
            if type( val ) == 'number' then
                numbers[ #numbers + 1 ] = val
            elseif type( val ) == 'table' and subsdone < ( sub or 0 ) then
                TblLoop( val, sub )
                subsdone = subsdone + 1
            end
        end
    end
    TblLoop( tbl, sub )
    return numbers
end

--[[---------------------------------------------------------
    Name Mean(...)
    Desc: Finds the mean of any number of args.
    Usage: math.Mean( 1, 2, 3 ) > 2
       math.Mean( { 1, 2, 3 } ) > 2 (tables work as well)
-----------------------------------------------------------]]
function math.Mean(...)
    local total, count = 0, 0
    for _, v in ipairs(math.GetNumbersFromTbl({...}, 1)) do
        total = total + v
        count = count + 1
    end
    return total / count
end

--[[---------------------------------------------------------
    Name Median(...)
    Desc: Finds the median of any number of args.
    Usage: math.Median( 1, 2, 3, 4 ) > 2.5
       math.Median( { 1, 2, 3, 4 } ) > 2.5 (tables work as well)
-----------------------------------------------------------]]
function math.Median(...)
    local sorttbl = {}
    for _, v in ipairs(math.GetNumbersFromTbl({...}, 1)) do
        table.insert( sorttbl, v )
        sorttbl[ #sorttbl + 1 ] = v
    end
    table.sort( sorttbl )
    if math.fmod(#sorttbl,2) == 0 then
        return ( sorttbl[#sorttbl/2] + sorttbl[(#sorttbl/2)+1] ) / 2
    else
        return sorttbl[math.ceil(#sorttbl/2)]
    end
end

--[[---------------------------------------------------------
    Name Mode(...)
    Desc: Finds the mode of any number of args, which do not have to be numbers.
    Usage: math.Mode( 1, 2, 3, 2 ) > 2
         math.Mode( 1, 2, 3 ) > 1, 2, 3
         math.Mode( { 1, 2, 3 } ) > 1, 2, 3 (tables work as well)
-----------------------------------------------------------]]
function math.Mode(...)
    local counts, biggestcount = {}, 0
    for _, v in ipairs(math.GetNumbersFromTbl({...}, 1)) do
        if counts[v] == nil then
            counts[v] = 1
        else
            counts[v] = counts[v] + 1
        end
        if counts[v] > biggestcount then biggestcount = counts[v] end
    end
    return table.KeysFromValue( counts, biggestcount )
end
