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
	return x ^ 2
end

function OutQuad( x )
	return 1 - ( 1 - x ) * ( 1 - x )
end

function InOutQuad( x )
	return x < 0.5 && 2 * x ^ 2 || 1 - ( ( -2 * x + 2 ) ^ 2 ) / 2
end

function InCubic( x )
	return x ^ 3
end

function OutCubic( x )
	return 1 - ( ( 1 - x ) ^ 3 )
end

function InOutCubic( x )
	return x < 0.5 && 4 * x ^ 3 || 1 - ( ( -2 * x + 2 ) ^ 3 ) / 2
end

function InQuart( x )
	return x ^ 4
end

function OutQuart( x )
	return 1 - ( ( 1 - x ) ^ 4 )
end

function InOutQuart( x )
	return x < 0.5 && 8 * x ^ 4 || 1 - ( ( -2 * x + 2 ) ^ 4 ) / 2
end

function InQuint( x )
	return x ^ 5
end

function OutQuint( x )
	return 1 - ( ( 1 - x ) ^ 5 )
end

function InOutQuint( x )
	return x < 0.5 && 16 * x ^ 5 || 1 - ( ( -2 * x + 2 ) ^ 5 ) / 2
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
	return 1 - sqrt( 1 - ( x ^ 2 ) )
end

function OutCirc( x )
	return sqrt( 1 - ( ( x - 1 ) ^ 2 ) )
end

function InOutCirc( x )
	return x < 0.5
		&& ( 1 - sqrt( 1 - ( ( 2 * x ) ^ 2 ) ) ) / 2
		|| ( sqrt( 1 - ( ( -2 * x + 2 ) ^ 2 ) ) + 1 ) / 2
end

function InBack( x )
	return c3 * x ^ 3 - c1 * x ^ 2
end

function OutBack( x )
	return 1 + c3 * ( ( x - 1 ) ^ 3 ) + c1 * ( ( x - 1 ) ^ 2 )
end

function InOutBack( x )
	return x < 0.5
		&& ( ( ( 2 * x ) ^ 2 ) * ( ( c2 + 1 ) * 2 * x - c2 ) ) / 2
		|| ( ( ( 2 * x - 2 ) ^ 2 ) * ( ( c2 + 1 ) * ( x * 2 - 2 ) + c2 ) + 2 ) / 2
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
		return n1 * x ^ 2
	elseif ( x < 2 / d1 ) then
		x = x - ( 1.5 / d1 )
		return n1 * x ^ 2 + 0.75
	elseif ( x < 2.5 / d1 ) then
		x = x - ( 2.25 / d1 )
		return n1 * x ^ 2 + 0.9375
	else
		x = x - ( 2.625 / d1 )
		return n1 * x ^ 2 + 0.984375
	end
end

function InOutBounce( x )
	return x < 0.5
		&& ( 1 - OutBounce( 1 - 2 * x ) ) / 2
		|| ( 1 + OutBounce( 2 * x - 1 ) ) / 2
end
