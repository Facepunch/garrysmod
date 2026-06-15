local meta = FindMetaTable( "VMatrix" )

function meta:GetLeft()
	local vec = self:GetRight()
	vec:Mul( -1 )
	return vec
end

function meta:GetBackward()
	local vec = self:GetForward()
	vec:Mul( -1 )
	return vec
end

function meta:GetDown()
	local vec = self:GetUp()
	vec:Mul( -1 )
	return vec
end

function meta:SetLeft( vec )
	if ( !isvector( vec ) ) then error( "bad argument #1 to 'SetLeft' (Vector expected, got " .. type( vec ) .. ")", 2 ) end
	self:SetRight( vec * -1 )
end

function meta:SetBackward( vec )
	if ( !isvector( vec ) ) then error( "bad argument #1 to 'SetBackward' (Vector expected, got " .. type( vec ) .. ")", 2 ) end
	self:SetForward( vec * -1 )
end

function meta:SetDown( vec )
	if ( !isvector( vec ) ) then error( "bad argument #1 to 'SetDown' (Vector expected, got " .. type( vec ) .. ")", 2 ) end
	self:SetUp( vec * -1 )
end