module("math.ease", package.seeall)

--[[---------------------------------------------------------
	Source code of functions
-----------------------------------------------------------]]

-- https://github.com/Facepunch/garrysmod/pull/1755
-- https://web.archive.org/web/20201212082306/https://easings.net/
-- https://web.archive.org/web/20201218211606/https://raw.githubusercontent.com/ai/easings.net/master/src/easings.yml

--[[---------------------------------------------------------
	Easing constants
-----------------------------------------------------------]]

local c1 = 1.70158
local c3 = c1 + 1
local c2 = c1 * 1.525
local c4 = ( 2 * math.pi ) / 3
local c5 = ( 2 * math.pi ) / 4.5
local n1 = 7.5625
local d1 = 2.75

--[[---------------------------------------------------------
	To reduce _G lookups, we'll localize some commonly
	used functions in this extension
-----------------------------------------------------------]]

local pi = math.pi
local cos = math.cos
local sin = math.sin
local sqrt = math.sqrt

--[[---------------------------------------------------------
	Easing functions
-----------------------------------------------------------]]

function InSine( x )
	return 1 - cos( ( x * pi ) / 2 )
end

function OutSine( x )
	return sin( ( x * pi ) / 2 )
end

function InOutSine( x )
	return -( cos( pi * x ) - 1 ) / 2
end

function InQuad( x )
	return x * x
end

function OutQuad( x )
	return 1 - ( 1 - x ) * ( 1 - x )
end

function InOutQuad( x )
	if x < 0.5 then
		return 2 * ( x * x )
	else
		local w = -2 * x + 2
		return 1 - ( w * w ) / 2
	end
end

function InCubic( x )
	return x * x * x
end

function OutCubic( x )
	local w = 1 - x
	return 1 - ( w * w * w )
end

function InOutCubic( x )
	if ( x < 0.5 ) then
		return 4 * ( x * x * x )
	else
		local w = -2 * x + 2
		return 1 - ( w * w * w ) / 2
	end
end

function InQuart( x )
	return x * x * x * x
end

function OutQuart( x )
	local w = 1 - x
	return 1 - ( w * w * w * w )
end

function InOutQuart( x )
	if ( x < 0.5 ) then
		return 8 * ( x * x * x * x )
	else
		local w = -2 * x + 2
		return 1 - ( w * w * w * w ) / 2
	end
end

function InQuint( x )
	return x * x * x * x * x
end

function OutQuint( x )
	local w = 1 - x
	return 1 - ( w * w * w * w * w )
end

function InOutQuint( x )
	if ( x < 0.5 ) then
		return 16 * ( x * x * x * x * x )
	else
		local w = -2 * x + 2
		return 1 - ( w * w * w * w * w ) / 2
	end
end

function InExpo( x )
	return x == 0 && 0 || ( 2 ^ ( 10 * x - 10 ) )
end

function OutExpo( x )
	return x == 1 && 1 || 1 - ( 2 ^ ( -10 * x ) )
end

function InOutExpo( x )
	return x == 0
		&& 0
		|| x == 1
		&& 1
		|| x < 0.5 && ( 2 ^ ( 20 * x - 10 ) ) / 2
		|| ( 2 - ( 2 ^ ( -20 * x + 10 ) ) ) / 2
end

function InCirc( x )
	return 1 - sqrt( 1 - ( x * x ) )
end

function OutCirc( x )
	local w = x - 1
	return sqrt( 1 - ( w * w ) )
end

function InOutCirc( x )
	if ( x < 0.5 ) then
		local w = 2 * x
		return ( 1 - sqrt( 1 - ( w * w ) ) ) / 2
	else
		local w = -2 * x + 2
		return ( sqrt( 1 - ( w * w ) ) + 1 ) / 2
	end
end

function InBack( x )
	local x2 = x * x
	return c3 * ( x2 * x ) - c1 * x2
end

function OutBack( x )
	local w = x - 1
	local w2 = w * w
	return 1 + c3 * ( w2 * w ) + c1 * w2
end

function InOutBack( x )
	if ( x < 0.5 ) then
		local w = 2 * x
		return ( ( w * w ) * ( ( c2 + 1 ) * 2 * x - c2 ) ) / 2
	else
		local w = 2 * x - 2
		return ( ( w * w ) * ( ( c2 + 1 ) * ( x * 2 - 2 ) + c2 ) + 2 ) / 2
	end
end

function InElastic( x )
	return x == 0
		&& 0
		|| x == 1
		&& 1
		|| -( 2 ^ ( 10 * x - 10 ) ) * sin( ( x * 10 - 10.75 ) * c4 )
end

function OutElastic( x )
	return x == 0
		&& 0
		|| x == 1
		&& 1
		|| ( 2 ^ ( -10 * x ) ) * sin( ( x * 10 - 0.75 ) * c4 ) + 1
end

function InOutElastic( x )
	return x == 0
		&& 0
		|| x == 1
		&& 1
		|| x < 0.5
		&& -( ( 2 ^ ( 20 * x - 10 ) ) * sin( ( 20 * x - 11.125 ) * c5 ) ) / 2
		|| ( ( 2 ^ ( -20 * x + 10 ) ) * sin( ( 20 * x - 11.125 ) * c5 ) ) / 2 + 1
end

function InBounce( x )
	return 1 - OutBounce( 1 - x )
end

function OutBounce( x )
	if ( x < 1 / d1 ) then
		return n1 * ( x * x )
	elseif ( x < 2 / d1 ) then
		x = x - ( 1.5 / d1 )
		return n1 * ( x * x ) + 0.75
	elseif ( x < 2.5 / d1 ) then
		x = x - ( 2.25 / d1 )
		return n1 * ( x * x ) + 0.9375
	else
		x = x - ( 2.625 / d1 )
		return n1 * ( x * x ) + 0.984375
	end
end

function InOutBounce( x )
	return x < 0.5
		&& ( 1 - OutBounce( 1 - 2 * x ) ) / 2
		|| ( 1 + OutBounce( 2 * x - 1 ) ) / 2
end
