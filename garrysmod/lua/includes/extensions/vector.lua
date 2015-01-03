local meta = FindMetaTable( "Vector" )

--[[---------------------------------------------------------
	Converts Vector To Color - alpha precision lost, must reset
-----------------------------------------------------------]]
function meta:ToColor( )

	return Vector( self.x * 255, self.y * 255, self.z * 255, 255 )

end
