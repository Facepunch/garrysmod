local COLOR = {}
COLOR.__index = COLOR

--[[---------------------------------------------------------
	Register our metatable to make it accessible using FindMetaTable
-----------------------------------------------------------]]

debug.getregistry().Color = COLOR

--[[---------------------------------------------------------
	To easily create a colour table
-----------------------------------------------------------]]
function Color( r, g, b, a )

	a = a or 255
	return setmetatable( { r = math.min( tonumber(r), 255 ), g =  math.min( tonumber(g), 255 ), b =  math.min( tonumber(b), 255 ), a =  math.min( tonumber(a), 255 ) }, COLOR )
	
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
	Converts a color to HSL
-----------------------------------------------------------]]
local clamp = math.Clamp
local abs = math.abs
local min,max = math.min,math.max
function ColorToHSL(_color)
	local R,G,B = _color.r/255,_color.g/255,_color.b/255
	local max,min = max(R,G,B),min(R,G,B)
	local del = max-min
	-- Hue
	local H = 0
	if del<=0 then H = 0 
	elseif max==R then 	H = 60*( ( (G-B)/del ) %6 )
	elseif max==G then 	H = 60*( ( (B-R)/del +2) %6 )
	else--[[max==B]]	H = 60*( ( (R-G)/del +4) %6 )
	end
	-- Lightness
	local L = (max+min)/2
	-- Saturation
	local S = 0
	if del!=0 then
		S = del/(1-abs(2*L-1))
	end
	return H,S,L
end

function COLOR:ToHSL()
	return ColorToHSL( self )
end

--[[---------------------------------------------------------
	Converts a HSL to color
-----------------------------------------------------------]]
function HSLToColor(H,S,L)
	H = clamp(H,0,360)
	S = clamp(S,0,1)
	L = clamp(L,0,1)
	local C = (1-abs(2*L-1)) * S
	local X = C*(1-abs((H/60)%2-1))

	local m = L-C/2
	local R1,G1,B1 = 0,0,0

	if H < 60 or H>=360 then R1,G1,B1 = C,X,0
	elseif H < 120 		then R1,G1,B1 = X,C,0
	elseif H < 180 		then R1,G1,B1 = 0,C,X
	elseif H < 240 		then R1,G1,B1 = 0,X,C
	elseif H < 300 		then R1,G1,B1 = X,0,C
	else  --[[ H<360 ]] 	 R1,G1,B1 = C,0,X 
	end
	return Color((R1+m)*255,(G1+m)*255,(B1+m)*255)
end

--[[---------------------------------------------------------
	Converts a color to HSV
-----------------------------------------------------------]]
function COLOR:ToHSV()
	
	return ColorToHSV( self )
	
end

--[[---------------------------------------------------------
	Converts Color To Vector - loss of precision / alpha lost
-----------------------------------------------------------]]
function COLOR:ToVector( )

	return Vector( self.r / 255, self.g / 255, self.b / 255 )

end
