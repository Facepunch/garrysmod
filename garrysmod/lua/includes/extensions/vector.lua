local meta = FindMetaTable( "Vector" )

-- Nothing in here, still leaving this file here just in case

--[[---------------------------------------------------------
	Converts Vector To Color - alpha precision lost, must reset
-----------------------------------------------------------]]
function meta:ToColor( )

	return Color( self.x * 255, self.y * 255, self.z * 255 )

end
