local meta = FindMetaTable( "VMatrix" )

function meta:GetLeft()
	local vec = self:GetRight()
	vec:Mul( -1 )
	return vec
end

function meta:SetLeft( vec )
	if ( !isvector( vec ) ) then error( "bad argument #1 to 'SetLeft' (Vector expected, got " .. type( vec ) .. ")", 2 ) end
	self:SetRight( vec * -1 )
end