local meta = FindMetaTable( "Vector" )

-- Nothing in here, still leaving this file here just in case

--[[---------------------------------------------------------
	Converts Vector To Color - alpha precision lost, must reset
-----------------------------------------------------------]]
function meta:ToColor( )

	return Color( self.x * 255, self.y * 255, self.z * 255 )

end

--[[---------------------------------------------------------
	Returns a rounded vector
-----------------------------------------------------------]]
function meta:Round( decimals )

	return Vector( math.Round( self[1], decimals ), math.Round( self[2], decimals ), math.Round( self[3], decimals ) )
end

--[[---------------------------------------------------------
	Returns a rounded down vector
-----------------------------------------------------------]]
function meta:Floor()

	return Vector( math.floor( self[1] ), math.floor( self[2] ), math.floor( self[3] ) )

--[[---------------------------------------------------------
	Returns a rounded up vector
-----------------------------------------------------------]]
function meta:Ceil()

	return Vector( math.ceil( self[1] ), math.ceil( self[2] ), math.ceil( self[3] ) )

end

--[[---------------------------------------------------------
	Returns a rotated vector
-----------------------------------------------------------]]
function meta:GetRotated( rotation )

	local result = Vector( self )
	result:Rotate( rotation )

	return result

end
