local meta = FindMetaTable( "Vector" )

-- Nothing in here, still leaving this file here just in case

--[[---------------------------------------------------------
Converts Vector to Color - alpha precision lost, must reset
-----------------------------------------------------------]]
function meta:ToColor()
	return Color(self.x * 255, self.y * 255, self.z * 255)
end

--[[---------------------------------------------------------
Converts Vector to Table - removes all metrods from the copy
-----------------------------------------------------------]]
function meta:ToTable(arr)
	if(arr) then return {self.x, self.y, self.z} end
	return {x = self.x, y = self.y, z = self.z}
end

--[[---------------------------------------------------------
Converts Vector to Angle - data is copied
-----------------------------------------------------------]]
function meta:ToAngle()
	return Angle(self.x, self.y, self.z)
end

--[[---------------------------------------------------------
Returns a copy of a rotated vector. Kind of like v:GetNormalized()
-----------------------------------------------------------]]
function meta:GetRotated(ang)
	local v = Vector(self)
	v:Rotate(ang)
	return v
end

--[[---------------------------------------------------------
Returns a copy of an added vector
-----------------------------------------------------------]]
function meta:GetAdd(vec)
	local v = Vector(self)
	v:Add(vec)
	return v
end

--[[---------------------------------------------------------
Returns a copy of a subracted vector
-----------------------------------------------------------]]
function meta:GetSub(vec)
	local v = Vector(self)
	v:Sub(vec)
	return v
end

--[[---------------------------------------------------------
Returns a copy of a multiplied vector
-----------------------------------------------------------]]
function meta:GetMul(num)
	local v = Vector(self)
	v:Mul(num)
	return v
end

--[[---------------------------------------------------------
Returns a copy of a divided vector
-----------------------------------------------------------]]
function meta:GetDiv(num)
	local v = Vector(self)
	v:Div(num)
	return v
end

--[[---------------------------------------------------------
Convets the vector to bisector of two vectors
-----------------------------------------------------------]]
function meta:Bisect(vec)
	ns, nv = self:Length(), vec:Length()
	self:Mul(nv)
	self:Add(vec:GetMul(ns))
	return self
end

--[[---------------------------------------------------------
Returns a copy of bisector of two vectors
-----------------------------------------------------------]]
function meta:Bisect(vec)
	local v = Vector(self)
	return v:Bisect(vec)
end

--[[---------------------------------------------------------
Convets the vector to nagated version of itself
-----------------------------------------------------------]]
function meta:Negate()
	self.x = -self.x
	self.y = -self.y
	self.z = -self.z
	return self
end

--[[---------------------------------------------------------
Returns a copy of the nagated vector
-----------------------------------------------------------]]
function meta:GetNegate()
	local v = Vector(self)
	return v:GetNegate()
end

--[[---------------------------------------------------------
Returns a flag if the vector is a zero vector
-----------------------------------------------------------]]
function meta:IsZero()
	return (self.x == 0 and self.y == 0 and self.z == 0)
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
function meta:GetResize(vec)
	local v = Vector(self)
	return v:Resize()
end

--[[---------------------------------------------------------
Convets the vector to resized version of itself
-----------------------------------------------------------]]
function meta:Middle(vec)
	self:Add(vec)
	self:Mul(0.5)
	return self
end

--[[---------------------------------------------------------
Returns a copy of the resized vector
-----------------------------------------------------------]]
function meta:GetMiddle(vec)
	local v = Vector(self)
	return v:Middle()
end
