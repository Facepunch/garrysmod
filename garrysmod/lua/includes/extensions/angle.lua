local meta = FindMetaTable( "Angle" )

--[[---------------------------------------------------------
	Angle unary operator
	- Allows -Angle( 90, 180, -270 )
-----------------------------------------------------------]]  
function meta:__unm()
	return -1 * self
end