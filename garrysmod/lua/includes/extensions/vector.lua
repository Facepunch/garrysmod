
local meta = FindMetaTable( "Vector" )

--[[---------------------------------------------------------
	Converts Vector To Color - alpha precision lost, must reset
-----------------------------------------------------------]]
function meta:ToColor()

	local x, y, z = meta.Unpack( self )
	return Color( x * 255, y * 255, z * 255 )

end
