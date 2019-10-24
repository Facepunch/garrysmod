local meta = FindMetaTable( "Vector" )

-- Nothing in here, still leaving this file here just in case

--[[---------------------------------------------------------
Converts Vector to Color - alpha precision lost, must reset
-----------------------------------------------------------]]
function meta:ToColor()
	local x, y, z = self:Unpack()
	return Color(x * 255, y * 255, z * 255)
end

--[[---------------------------------------------------------
Converts Vector to Table - removes all metrods from the copy
-----------------------------------------------------------]]
function meta:ToTable(arr)
	local x, y, z = self:Unpack()
	return {x = x, y = y, z = z}
end

--[[---------------------------------------------------------
Converts Vector to Array - removes all metrods from the copy
-----------------------------------------------------------]]
function meta:ToArray()
	local x, y, z = self:Unpack()
	return {x, y, z}
end

--[[---------------------------------------------------------
Converts Vector to Angle - data is copied
-----------------------------------------------------------]]
function meta:ToAngle()
	local x, y, z = self:Unpack()
	return Angle(x, y, z)
end

--[[---------------------------------------------------------
Returns a copy of a rotated vector. Kind of like v:GetNormalized()
-----------------------------------------------------------]]
function meta:GetRotated(...)
	local v = Vector(self)
	v:Rotate(...)
	return v
end

--[[---------------------------------------------------------
Returns a copy of a multiplied vector
-----------------------------------------------------------]]
function meta:GetMul(...)
	local v = Vector(self)
	v:Mul(...)
	return v
end

--[[---------------------------------------------------------
Returns a copy of an added vector
-----------------------------------------------------------]]
function meta:GetAdd(...)
	local v = Vector(self)
	v:Add(...)
	return v
end

--[[---------------------------------------------------------
Adds a unpacked x, y and z to a vector
-----------------------------------------------------------]]
function meta:AddEx(x, y, z)
	self[1] = self[1] + x
	self[2] = self[2] + y
	self[3] = self[3] + z
	return self
end

--[[---------------------------------------------------------
Adds a unpacked x, y and z to a copy vector
-----------------------------------------------------------]]
function meta:GetAddEx(...)
	local v = Vector(self)
	v:AddEx(...)
	return self
end

--[[---------------------------------------------------------
Returns a copy of a subracted vector
-----------------------------------------------------------]]
function meta:GetSub(...)
	local v = Vector(self)
	v:Sub(...)
	return v
end

--[[---------------------------------------------------------
Subtracts a unpacked x, y and z from a vector
-----------------------------------------------------------]]
function meta:SubEx(x, y, z)
	self[1] = self[1] - x
	self[2] = self[2] - y
	self[3] = self[3] - z
	return self
end

--[[---------------------------------------------------------
Adds a unpacked x, y and z to a copy vector
-----------------------------------------------------------]]
function meta:GetSubEx(...)
	local v = Vector(self)
	v:SubEx(...)
	return self
end

--[[---------------------------------------------------------
Returns a copy of a divided vector
-----------------------------------------------------------]]
function meta:GetDiv(...)
	local v = Vector(self)
	v:Div(...)
	return v
end

--[[---------------------------------------------------------
Convets the vector to bisector of two vectors
-----------------------------------------------------------]]
function meta:Bisect(vec)
	local ns, nv = self:Length(), vec:Length()
	self:Mul(nv)
	self:Add(vec:GetMul(ns))
	return self
end

--[[---------------------------------------------------------
Returns a copy of bisector of two vectors
-----------------------------------------------------------]]
function meta:GetBisected(...)
	local v = Vector(self)
	v:Bisect(...)
	return v
end

--[[---------------------------------------------------------
Convets the vector to nagated version of itself
-----------------------------------------------------------]]
function meta:Negate(bx, by, bz)
	local vx, vy, vz = self:Unpack()
	self[1] = tobool(bx or (bx == nil)) and -vx or vx
	self[2] = tobool(by or (by == nil)) and -vy or vy
	self[3] = tobool(bz or (bz == nil)) and -vz or vz
	return self
end

--[[---------------------------------------------------------
Returns a copy of the nagated vector
-----------------------------------------------------------]]
function meta:GetNegated(...)
	local v = Vector(self)
	v:Negate(...)
	return v
end

--[[---------------------------------------------------------
Convets the vector to nagated version of itself
-----------------------------------------------------------]]
function meta:Nudge(n, v)
	self:Add(v:GetMul(n))
	return self
end

--[[---------------------------------------------------------
Returns a copy of the nagated vector
-----------------------------------------------------------]]
function meta:GetNudge(...)
	local v = Vector(self)
	v:Nudge(...)
	return v
end

--[[---------------------------------------------------------
Convets the vector to resized version of itself
-----------------------------------------------------------]]
function meta:Resize(num)
	self:Normalize()
	self:Mul(num)
	return self
end

--[[---------------------------------------------------------
Returns a copy of the resized vector
-----------------------------------------------------------]]
function meta:GetResized(...)
	local v = Vector(self)
	v:Resize(...)
	return v
end

--[[---------------------------------------------------------
Convets the vector to resized midpoint of itself
-----------------------------------------------------------]]
function meta:Midpoint(vec)
	self:Add(vec)
	self:Mul(0.5)
	return self
end

--[[---------------------------------------------------------
Returns a copy of the midpoint vector
-----------------------------------------------------------]]
function meta:GetMidpoint(...)
	local v = Vector(self)
	v:Midpoint(...)
	return v
end

--[[---------------------------------------------------------
Returns a copy of the zero point vector
-----------------------------------------------------------]]
function meta:GetZero(...)
	local v = Vector(self)
	v:Zero(...)
	return v
end

--[[---------------------------------------------------------
Applies new basis to a vector by the three axises of an angle
-----------------------------------------------------------]]
function meta:Basis(ang)
	local x = self:Dot(ang:Forward())
	local y = self:Dot(ang:Right())
	local z = self:Dot(ang:Up())
	self[1], self[2], self[3] = x, y, z
	return self
end

--[[---------------------------------------------------------
Applies new basis to a vector by the three axises of an angle
-----------------------------------------------------------]]
function meta:GetBasis(...)
	local v = Vector(self)
	v:Basis(...)
	return v
end

--[[---------------------------------------------------------
Calculates 3x3 determinant by using other two vectors as rows
-----------------------------------------------------------]]
function meta:GetDeterminant(vec2, vec3)
	local a, b, c = self:Unpack()
	local d, e, f = vec2:Unpack()
	local g, h, i = vec3:Unpack()
	return ((a*e*i)+(b*f*g)+(d*h*c)-(g*e*c)-(h*f*a)-(d*b*i))
end
