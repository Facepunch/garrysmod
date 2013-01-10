local meta = FindMetaTable( "Vector" )

--[[---------------------------------------------------------
	Vector unary operator
	- Allows -Vector( 1, 2, 3 )
-----------------------------------------------------------]]  
function meta:__unm()
	return -1 * self
end