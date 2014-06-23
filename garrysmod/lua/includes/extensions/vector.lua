local meta = FindMetaTable( "Vector" )

-- Nothing in here, still leaving this file here just in case

--[[---------------------------------------------------------
	Converts Vector To Color - loss of alpha precision
-----------------------------------------------------------]]
function meta:ToColor( )

	return Vector( self.x * 255, self.y * 255, self.z * 255, 255 )

end