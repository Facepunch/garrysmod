local meta = FindMetaTable( "Vector" )

--
-- Normalizes this vector in-place and returns it.
--
function meta:AsNormalized( )

	self:Normalize( )
	
	return self
	
end

--[[---------------------------------------------------------
	Converts Vector To Color - alpha precision lost, must reset
-----------------------------------------------------------]]
function meta:ToColor( )

	return Color( self.x * 255, self.y * 255, self.z * 255 )

end
