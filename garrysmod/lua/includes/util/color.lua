local colorMeta = {}
colorMeta.__index = colorMeta

local mathmin = math.min
local tonumber = tonumber
local setmetatable = setmetatable
local getmetatable = getmetatable
local Vector = Vector

--Register our metatable to make it accessible using FindMetaTable
debug.getregistry().Color = colorMeta

local callTable = {}
callTable.__index = callTable
callTable.__call = function(self, r, g, b, a)

	return setmetatable({
		r = mathmin( tonumber(r), 255 ),
		g = mathmin( tonumber(g), 255 ),
		b = mathmin( tonumber(b), 255 ),
		a = mathmin( tonumber(a or 255), 255 )
	}, colorMeta )

end

Color = setmetatable({}, callTable)

--file internal optimisation
local Color = Color
	
	
Color.AliceBlue = Color(240, 248, 255)
Color.AntiqueWhite = Color(250, 235, 215)
Color.Aqua = Color(0, 255, 255)
Color.Aquamarine = Color(127, 255, 212)
Color.Azure = Color(240, 255, 255)
Color.Beige = Color(245, 245, 220)
Color.Bisque = Color(255, 228, 196)
Color.Black = Color(0, 0, 0)
Color.BlanchedAlmond = Color(255, 235, 205)
Color.Blue = Color(0, 0, 255)
Color.BlueViolet = Color(138, 43, 226)
Color.Brown = Color(165, 42, 42)
Color.BurlyWood = Color(222, 184, 135)
Color.CadetBlue = Color(95, 158, 160)
Color.Chartreuse = Color(127, 255, 0)
Color.Chocolate = Color(210, 105, 30)
Color.Coral = Color(255, 127, 80)
Color.CornflowerBlue = Color(100, 149, 237)
Color.Cornsilk = Color(255, 248, 220)
Color.Crimson = Color(220, 20, 60)
Color.Cyan = Color(0, 255, 255)
Color.DarkBlue = Color(0, 0, 139)
Color.DarkCyan = Color(0, 139, 139)
Color.DarkGoldenRod = Color(184, 134, 11)
Color.DarkGray = Color(169, 169, 169)
Color.DarkGreen = Color(0, 100, 0)
Color.DarkKhaki = Color(189, 183, 107)
Color.DarkMagenta = Color(139, 0, 139)
Color.DarkOliveGreen = Color(85, 107, 47)
Color.DarkOrange = Color(255, 140, 0)
Color.DarkOrchid = Color(153, 50, 204)
Color.DarkRed = Color(139, 0, 0)
Color.DarkSalmon = Color(233, 150, 122)
Color.DarkSeaGreen = Color(143, 188, 143)
Color.DarkSlateBlue = Color(72, 61, 139)
Color.DarkSlateGray = Color(47, 79, 79)
Color.DarkTurquoise = Color(0, 206, 209)
Color.DarkViolet = Color(148, 0, 211)
Color.DeepPink = Color(255, 20, 147)
Color.DeepSkyBlue = Color(0, 191, 255)
Color.DimGray = Color(105, 105, 105)
Color.DodgerBlue = Color(30, 144, 255)
Color.FireBrick = Color(178, 34, 34)
Color.FloralWhite = Color(255, 250, 240)
Color.ForestGreen = Color(34, 139, 34)
Color.Fuchsia = Color(255, 0, 255)
Color.Gainsboro = Color(220, 220, 220)
Color.GhostWhite = Color(248, 248, 255)
Color.Gold = Color(255, 215, 0)
Color.GoldenRod = Color(218, 165, 32)
Color.Gray = Color(128, 128, 128)
Color.Green = Color(0, 128, 0)
Color.GreenYellow = Color(173, 255, 47)
Color.HoneyDew = Color(240, 255, 240)
Color.HotPink = Color(255, 105, 180)
Color.IndianRed = Color(205, 92, 92)
Color.Indigo = Color(75, 0, 130)
Color.Ivory = Color(255, 255, 240)
Color.Khaki = Color(240, 230, 140)
Color.Lavender = Color(230, 230, 250)
Color.LavenderBlush = Color(255, 240, 245)
Color.LawnGreen = Color(124, 252, 0)
Color.LemonChiffon = Color(255, 250, 205)
Color.LightBlue = Color(173, 216, 230)
Color.LightCoral = Color(240, 128, 128)
Color.LightCyan = Color(224, 255, 255)
Color.LightGoldenRodYellow = Color(250, 250, 210)
Color.LightGray = Color(211, 211, 211)
Color.LightGreen = Color(144, 238, 144)
Color.LightPink = Color(255, 182, 193)
Color.LightSalmon = Color(255, 160, 122)
Color.LightSeaGreen = Color(32, 178, 170)
Color.LightSkyBlue = Color(135, 206, 250)
Color.LightSlateGray = Color(119, 136, 153)
Color.LightSteelBlue = Color(176, 196, 222)
Color.LightYellow = Color(255, 255, 224)
Color.Lime = Color(0, 255, 0)
Color.LimeGreen = Color(50, 205, 50)
Color.Linen = Color(250, 240, 230)
Color.Magenta = Color(255, 0, 255)
Color.Maroon = Color(128, 0, 0)
Color.MediumAquaMarine = Color(102, 205, 170)
Color.MediumBlue = Color(0, 0, 205)
Color.MediumOrchid = Color(186, 85, 211)
Color.MediumPurple = Color(147, 112, 219)
Color.MediumSeaGreen = Color(60, 179, 113)
Color.MediumSlateBlue = Color(123, 104, 238)
Color.MediumSpringGreen = Color(0, 250, 154)
Color.MediumTurquoise = Color(72, 209, 204)
Color.MediumVioletRed = Color(199, 21, 133)
Color.MidnightBlue = Color(25, 25, 112)
Color.MintCream = Color(245, 255, 250)
Color.MistyRose = Color(255, 228, 225)
Color.Moccasin = Color(255, 228, 181)
Color.NavajoWhite = Color(255, 222, 173)
Color.Navy = Color(0, 0, 128)
Color.OldLace = Color(253, 245, 230)
Color.Olive = Color(128, 128, 0)
Color.OliveDrab = Color(107, 142, 35)
Color.Orange = Color(255, 165, 0)
Color.OrangeRed = Color(255, 69, 0)
Color.Orchid = Color(218, 112, 214)
Color.PaleGoldenRod = Color(238, 232, 170)
Color.PaleGreen = Color(152, 251, 152)
Color.PaleTurquoise = Color(175, 238, 238)
Color.PaleVioletRed = Color(219, 112, 147)
Color.PapayaWhip = Color(255, 239, 213)
Color.PeachPuff = Color(255, 218, 185)
Color.Peru = Color(205, 133, 63)
Color.Pink = Color(255, 192, 203)
Color.Plum = Color(221, 160, 221)
Color.PowderBlue = Color(176, 224, 230)
Color.Purple = Color(128, 0, 128)
Color.Red = Color(255, 0, 0)
Color.RosyBrown = Color(188, 143, 143)
Color.RoyalBlue = Color(65, 105, 225)
Color.SaddleBrown = Color(139, 69, 19)
Color.Salmon = Color(250, 128, 114)
Color.SandyBrown = Color(244, 164, 96)
Color.SeaGreen = Color(46, 139, 87)
Color.SeaShell = Color(255, 245, 238)
Color.Sienna = Color(160, 82, 45)
Color.Silver = Color(192, 192, 192)
Color.SkyBlue = Color(135, 206, 235)
Color.SlateBlue = Color(106, 90, 205)
Color.SlateGray = Color(112, 128, 144)
Color.Snow = Color(255, 250, 250)
Color.SpringGreen = Color(0, 255, 127)
Color.SteelBlue = Color(70, 130, 180)
Color.Tan = Color(210, 180, 140)
Color.Teal = Color(0, 128, 128)
Color.Thistle = Color(216, 191, 216)
Color.Tomato = Color(255, 99, 71)
Color.Turquoise = Color(64, 224, 208)
Color.Violet = Color(238, 130, 238)
Color.Wheat = Color(245, 222, 179)
Color.White = Color(255, 255, 255)
Color.WhiteSmoke = Color(245, 245, 245)
Color.Yellow = Color(255, 255, 0)
Color.YellowGreen = Color(154, 205, 50)

--Statics

Color.FromHSV = HSVToColor
function Color.FromHex(hexStr)
	
	local r, g, b = hexStr:match("^(%x%x)(%x%x)(%x%y)$")
	if not r then
		error("Invalid hex format")
	end
	return Color(r, g, b)
	
end

function Color.FromVector(vector)
	
	return Color(vector.r * 255, vector.g * 255, vector.b * 255)
	
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
function colorMeta:__tostring()
	
	return string.format( "%d %d %d %d", self.r, self.g, self.b, self.a )
	
end

--[[---------------------------------------------------------
	Compares two colors
-----------------------------------------------------------]]
function colorMeta:__eq( rhs )
	
	return self.r == rhs.r and self.g == rhs.g and self.b == rhs.b and self.a == rhs.a
	
end

--[[---------------------------------------------------------
	Converts a color to HSV
-----------------------------------------------------------]]
colorMeta.ToHSV = ColorToHSV

--[[---------------------------------------------------------
	Converts Color To Vector - loss of precision / alpha lost
-----------------------------------------------------------]]
function colorMeta:ToVector( )

	return Vector( self.r / 255, self.g / 255, self.b / 255 )

end

function colorMeta:Copy()
	
	return Color(self.r, self.g, self.b, self.a)
	
end

function colorMeta:GetRGB()
	
	return self.r, self.g, self.b
	
end

function colorMeta:GetRGBA()
	
	return self.r, self.g, self.b, self.a
	
end

colorMeta.CloneNewAlpha = ColorAlpha
