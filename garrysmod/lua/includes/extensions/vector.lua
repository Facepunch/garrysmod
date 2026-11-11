
local meta = FindMetaTable( "Vector" )

--[[---------------------------------------------------------
	Converts Vector To Color - alpha precision lost, must reset
-----------------------------------------------------------]]
function meta:ToColor()

	local x, y, z = meta.Unpack( self )
	return Color( x * 255, y * 255, z * 255 )

end

function meta:__index( k )

	local method = meta[ k ]
	if ( method ) then return method end

	local x, y, z = meta.Unpack( self )

	if ( k == 1 or k == "x" or k == "X" ) then
		return x
	elseif ( k == 2 or k == "y" or k == "Y" ) then
		return y
	elseif ( k == 3 or k == "z" or k == "Z" ) then
		return z
	end

end
