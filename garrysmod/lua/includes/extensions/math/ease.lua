math.ease = {}

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
	Easing functions
-----------------------------------------------------------]]

function math.ease.InSine( x )
	return 1 - math.cos( ( x * math.pi ) / 2 )
end

function math.ease.OutSine( x )
	return math.sin( ( x * math.pi ) / 2 )
end

function math.ease.InOutSine( x )
	return -( math.cos( math.pi * x ) - 1 ) / 2
end

function math.ease.InQuad( x )
	return x ^ 2
end

function math.ease.OutQuad( x )
	return 1 - ( 1 - x ) * ( 1 - x )
end

function math.ease.InOutQuad( x )
	return x < 0.5 && 2 * x ^ 2 || 1 - ( ( -2 * x + 2 ) ^ 2 ) / 2
end

function math.ease.InCubic( x )
	return x ^ 3
end

function math.ease.OutCubic( x )
	return 1 - ( ( 1 - x ) ^ 3 )
end

function math.ease.InOutCubic( x )
	return x < 0.5 && 4 * x ^ 3 || 1 - ( ( -2 * x + 2 ) ^ 3 ) / 2
end

function math.ease.InQuart( x )
	return x ^ 4
end

function math.ease.OutQuart( x )
	return 1 - ( ( 1 - x ) ^ 4 )
end

function math.ease.InOutQuart( x )
	return x < 0.5 && 8 * x ^ 4 || 1 - ( ( -2 * x + 2 ) ^ 4 ) / 2
end

function math.ease.InQuint( x )
	return x ^ 5
end

function math.ease.OutQuint( x )
	return 1 - ( ( 1 - x ) ^ 5 )
end

function math.ease.InOutQuint( x )
	return x < 0.5 && 16 * x ^ 5 || 1 - ( ( -2 * x + 2 ) ^ 5 ) / 2
end

function math.ease.InExpo( x )
	return x == 0 && 0 || ( 2 ^ ( 10 * x - 10 ) )
end

function math.ease.OutExpo( x )
	return x == 1 && 1 || 1 - ( 2 ^ ( -10 * x ) )
end

function math.ease.InOutExpo( x )
	return x == 0
		&& 0
		|| x == 1
		&& 1
		|| x < 0.5 && ( 2 ^ ( 20 * x - 10 ) ) / 2
		|| ( 2 - ( 2 ^ ( -20 * x + 10 ) ) ) / 2
end

function math.ease.InCirc( x )
	return 1 - math.sqrt( 1 - ( x ^ 2 ) )
end

function math.ease.OutCirc( x )
	return math.sqrt( 1 - ( ( x - 1 ) ^ 2 ) )
end

function math.ease.InOutCirc( x )
	return x < 0.5
		&& ( 1 - math.sqrt( 1 - ( ( 2 * x ) ^ 2 ) ) ) / 2
		|| ( math.sqrt( 1 - ( ( -2 * x + 2 ) ^ 2 ) ) + 1 ) / 2
end

function math.ease.InBack( x )
	return c3 * x ^ 3 - c1 * x ^ 2
end

function math.ease.OutBack( x )
	return 1 + c3 * ( ( x - 1 ) ^ 3 ) + c1 * ( ( x - 1 ) ^ 2 )
end

function math.ease.InOutBack( x )
	return x < 0.5
		&& ( ( ( 2 * x ) ^ 2 ) * ( ( c2 + 1 ) * 2 * x - c2 ) ) / 2
		|| ( ( ( 2 * x - 2 ) ^ 2 ) * ( ( c2 + 1 ) * ( x * 2 - 2 ) + c2 ) + 2 ) / 2
end

function math.ease.InElastic( x )
	return x == 0
		&& 0
		|| x == 1
		&& 1
		|| -( 2 ^ ( 10 * x - 10 ) ) * math.sin( ( x * 10 - 10.75 ) * c4 )
end

function math.ease.OutElastic( x )
	return x == 0
		&& 0
		|| x == 1
		&& 1
		|| ( 2 ^ ( -10 * x ) ) * math.sin( ( x * 10 - 0.75 ) * c4 ) + 1
end

function math.ease.InOutElastic( x )
	return x == 0
		&& 0
		|| x == 1
		&& 1
		|| x < 0.5
		&& -( ( 2 ^ ( 20 * x - 10 ) ) * math.sin( ( 20 * x - 11.125 ) * c5 ) ) / 2
		|| ( ( 2 ^ ( -20 * x + 10 ) ) * math.sin( ( 20 * x - 11.125 ) * c5 ) ) / 2 + 1
end

function math.ease.InBounce( x )
	return 1 - math.ease.OutBounce( 1 - x )
end

function math.ease.OutBounce( x )
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

function math.ease.InOutBounce( x )
	return x < 0.5
		&& ( 1 - math.ease.OutBounce( 1 - 2 * x ) ) / 2
		|| ( 1 + math.ease.OutBounce( 2 * x - 1 ) ) / 2
end
