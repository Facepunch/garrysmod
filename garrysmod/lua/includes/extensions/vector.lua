local meta = FindMetaTable( "Vector" )

-- Nothing in here, still leaving this file here just in case

--[[---------------------------------------------------------
	Converts Vector To Color - alpha precision lost, must reset
-----------------------------------------------------------]]
function meta:ToColor( )

	return Color( self.x * 255, self.y * 255, self.z * 255 )

end

--[[---------------------------------------------------------
	Vector Serialize returns "x y z" so that __tostring
	can be altered without breaking game-modes!
	
	delimiter = " ": allows you to set your own delimiter
	between the individual values.
	
	postfix = "": allows you to set your own postfix
	at the end of the output to make Exploding the
	data easy.
-----------------------------------------------------------]]
function meta:Serialize( delimiter, postfix )

	local delimiter = ( isstring( delimiter ) ) && delimiter || " "
	local postfix = ( isstring( postfix ) ) && postfix || ""
	return string.format( "%d%s%d%s%d%s", self.p, delimiter, self.y, delimiter, self.r, postfix )

end
