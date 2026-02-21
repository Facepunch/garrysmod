local meta = FindMetaTable( "Vector" )

-- Nothing in here, still leaving this file here just in case

--[[---------------------------------------------------------
Converts Vector to Color - alpha precision lost, must reset
-----------------------------------------------------------]]
function meta:ToColor( num )
	local x, y, z = self:Unpack()
	return Color( x * 255, y * 255, z * 255, ( num == nil && 1 || num ) * 255 )
end

--[[---------------------------------------------------------
Converts Vector to Table - removes all metrods from the copy
-----------------------------------------------------------]]
function meta:ToTable()
	local x, y, z = self:Unpack()
	return { x = x, y = y, z = z }
end

--[[---------------------------------------------------------
Converts Vector to Array - removes all metrods from the copy
-----------------------------------------------------------]]
function meta:ToArray()
	return { self:Unpack() }
end

--[[---------------------------------------------------------
Returns a copy of a rotated vector. Kind of like v:GetNormalized()
-----------------------------------------------------------]]
function meta:GetRotated( ... )
	local v = Vector( self )
	v:Rotate( ... )
	return v
end

--[[---------------------------------------------------------
Returns a copy of a multiplied vector
-----------------------------------------------------------]]
function meta:GetMul( ... )
	local v = Vector( self )
	v:Mul( ... )
	return v
end

--[[---------------------------------------------------------
Returns a copy of a multiplied vector
-----------------------------------------------------------]]
function meta:MulUnpacked( x, y, z )
	local vx, vy, vz = self:Unpack()
	self:SetUnpacked( vx * x, vy * y, vz * z )
end

--[[---------------------------------------------------------
Returns a copy of a multiplied vector
-----------------------------------------------------------]]
function meta:GetMulUnpacked( ... )
	local v = Vector( self )
	v:MulUnpacked( ... )
	return v
end

--[[---------------------------------------------------------
Returns a copy of an added vector
-----------------------------------------------------------]]
function meta:GetAdd( ... )
	local v = Vector( self )
	v:Add( ... )
	return v
end

--[[---------------------------------------------------------
Adds a unpacked x, y and z to a vector
-----------------------------------------------------------]]
function meta:AddUnpacked( x, y, z )
	local vx, vy, vz = self:Unpack()
	self:SetUnpacked( vx + x, vy + y, vz + z )
end

--[[---------------------------------------------------------
Adds a unpacked x, y and z to a copy vector
-----------------------------------------------------------]]
function meta:GetAddUnpacked( ... )
	local v = Vector( self )
	v:AddUnpacked( ... )
	return v
end

--[[---------------------------------------------------------
Returns a copy of a subracted vector
-----------------------------------------------------------]]
function meta:GetSub( ... )
	local v = Vector( self )
	v:Sub( ... )
	return v
end

--[[---------------------------------------------------------
Subtracts a unpacked x, y and z from a vector
-----------------------------------------------------------]]
function meta:SubUnpacked( x, y, z )
	local vx, vy, vz = self:Unpack()
	self:SetUnpacked( vx - x, vy - y, vz - z )
end

--[[---------------------------------------------------------
Adds a unpacked x, y and z to a copy vector
-----------------------------------------------------------]]
function meta:GetSubUnpacked( ... )
	local v = Vector( self )
	v:SubUnpacked( ... )
	return v
end

--[[---------------------------------------------------------
Returns a copy of a divided vector
-----------------------------------------------------------]]
function meta:GetDiv( ... )
	local v = Vector( self )
	v:Div( ... )
	return v
end

--[[---------------------------------------------------------
Returns a copy of a multiplied vector
-----------------------------------------------------------]]
function meta:DivUnpacked( x, y, z )
	local vx, vy, vz = self:Unpack()
	self:SetUnpacked( vx / x, vy / y, vz / z )
end

--[[---------------------------------------------------------
Returns a copy of a multiplied vector
-----------------------------------------------------------]]
function meta:GetDivUnpacked( ... )
	local v = Vector( self )
	v:DivUnpacked( ... )
	return v
end

--[[---------------------------------------------------------
Converts the vector to bisector of two vectors
Converts vector to result of a * |b| + b * |a|
-----------------------------------------------------------]]
function meta:Bisect( vec )
	local na, nb = self:Length(), vec:Length()
	self:Mul( nb )
	self:Add( vec:GetMul( na ) )
end

--[[---------------------------------------------------------
Returns a copy of bisector of two vectors
-----------------------------------------------------------]]
function meta:GetBisected( ... )
	local v = Vector( self )
	v:Bisect( ... )
	return v
end

--[[---------------------------------------------------------
Convets the vector to resized version of itself
-----------------------------------------------------------]]
function meta:Resize( num )
	self:Normalize()
	self:Mul( num )
end

--[[---------------------------------------------------------
Returns a copy of the resized vector
-----------------------------------------------------------]]
function meta:GetResized( ... )
	local v = Vector( self )
	v:Resize( ... )
	return v
end

--[[---------------------------------------------------------
Convets the vector to resized midpoint of itself
-----------------------------------------------------------]]
function meta:Midpoint( vec )
	self:Add( vec )
	self:Mul( 0.5 )
end

--[[---------------------------------------------------------
Returns a copy of the midpoint vector
-----------------------------------------------------------]]
function meta:GetMidpoint( ... )
	local v = Vector( self )
	v:Midpoint( ... )
	return v
end

--[[---------------------------------------------------------
Returns a copy of the zero point vector
-----------------------------------------------------------]]
function meta:GetZero( ... )
	local v = Vector( self )
	v:Zero( ... )
	return v
end

--[[---------------------------------------------------------
Calculates 3x3 determinant by using other two vectors as rows
-----------------------------------------------------------]]
function meta:Determinant( vec2, vec3 )
	local a, b, c = self:Unpack()
	local d, e, f = vec2:Unpack()
	local g, h, i = vec3:Unpack()
	return ( ( a * e * i ) + ( b * f * g ) + ( d * h * c ) -
	         ( g * e * c ) - ( h * f * a ) - ( d * b * i ) )
end

--[[---------------------------------------------------------
Applies new basis to a vector by the three axises of an angle
-----------------------------------------------------------]]
function meta:Basis( ang )
	local x = self:Dot( ang:Forward() )
	local y = self:Dot( ang:Right() )
	local z = self:Dot( ang:Up() )
	self:SetUnpacked( x, y, z )
end

--[[---------------------------------------------------------
Applies new basis to a vector by the three axises of an angle
-----------------------------------------------------------]]
function meta:GetBasis( ... )
	local v = Vector( self )
	v:Basis( ... )
	return v
end

--[[---------------------------------------------------------
Projects the vector in to an axis defined by the second vector
-----------------------------------------------------------]]
function meta:Project( vec )
	local vs = Vector( self )
	self:Set( vec )
	self:Normalize()
	self:Mul( vs:Dot( self ) )
end

--[[---------------------------------------------------------
Projects the vector in to an axis defined by the second vector
-----------------------------------------------------------]]
function meta:GetProjected( ... )
	local v = Vector( self )
	v:Project( ... )
	return v
end

--[[---------------------------------------------------------
Retrieves the angle between two vectors from 0 to math.pi
-----------------------------------------------------------]]
function meta:AngleBetween( vec, nrm )
	if ( nrm == nil ) then
		return math.acos( self:Dot( vec ) / math.sqrt( self:LengthSqr() * vec:LengthSqr() ) )
	end

	return math.atan2( self:Determinant( vec, nrm:GetNormalized() ), self:Dot( vec ) )
end
