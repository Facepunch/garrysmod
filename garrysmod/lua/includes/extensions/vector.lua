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
function meta:GetRound( decimals )

	return Vector( math.Round( self.x, decimals ), math.Round( self.y, decimals ), math.Round( self.z, decimals ) )
end

--[[---------------------------------------------------------
	Returns a rounded down vector
-----------------------------------------------------------]]
function meta:GetFloor()

	return Vector( math.floor( self.x ), math.floor( self.y ), math.floor( self.z ) )

--[[---------------------------------------------------------
	Returns a rounded up vector
-----------------------------------------------------------]]
function meta:GetCeil()

	return Vector( math.ceil( self.x ), math.ceil( self.y ), math.ceil( self.z ) )

end

--[[---------------------------------------------------------
	Returns a rotated vector
-----------------------------------------------------------]]
function meta:GetRotated( rotation )

	local result = Vector( self )
	result:Rotate( rotation )

	return result

end
