local meta = FindMetaTable( "Angle" )

-- Nothing in here, still leaving this file here just in case

--[[---------------------------------------------------------
	Angle Snap to nearest interval of degrees
-----------------------------------------------------------]]
function meta:SnapTo( component, degrees )

	if ( degrees == 0 ) then ErrorNoHalt( "The snap degrees must be non-zero.\n" ); return self; end
	if ( !self[ component ] ) then ErrorNoHalt( "You must choose a valid component of Angle( p || pitch, y || yaw, r || roll ) to snap such as Angle( 80, 40, 30 ):SnapTo( \"p\", 90 ):SnapTo( \"y\", 45 ):SnapTo( \"r\", 40 ); and yes, you can keep adding snaps.\n" ); return self; end

	self[ component ] = math.Round( self[ component ] / degrees ) * degrees
	self[ component ] = math.NormalizeAngle( self[ component ] )

	return self

end

--[[---------------------------------------------------------
	Returns a rounded angle
-----------------------------------------------------------]]
function meta:GetRound( decimals )

	return Angle( math.Round( self.p, decimals ), math.Round( self.y, decimals ), math.Round( self.r, decimals ) )
end

--[[---------------------------------------------------------
	Returns a rounded down angle
-----------------------------------------------------------]]
function meta:GetFloor()

	return Angle( math.floor( self.p ), math.floor( self.y ), math.floor( self.r ) )

--[[---------------------------------------------------------
	Returns a rounded up angle
-----------------------------------------------------------]]
function meta:GetCeil()

	return Angle( math.ceil( self.p ), math.ceil( self.y ), math.ceil( self.r ) )

end
