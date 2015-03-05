local VECTOR = FindMetaTable( "Vector" )

--[[---------------------------------------------------------
	Converts Vector To Color - alpha precision lost, must reset
-----------------------------------------------------------]]
function VECTOR:ToColor()

	return Vector( self.x * 255, self.y * 255, self.z * 255, 255 )

end

--[[---------------------------------------------------------
	Unpacks vector into three variables
-----------------------------------------------------------]]
function VECTOR:Unpack()
	
	return self.x, self.y, self.z
	
end
