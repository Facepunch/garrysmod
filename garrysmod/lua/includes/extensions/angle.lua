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
function meta:Round( decimals )

	return Angle( math.Round( self[1], decimals ), math.Round( self[2], decimals ), math.Round( self[3], decimals ) )
end

--[[---------------------------------------------------------
	Returns a rounded down angle
-----------------------------------------------------------]]
function meta:Floor()

	return Angle( math.floor( self[1] ), math.floor( self[2] ), math.floor( self[3] ) )

--[[---------------------------------------------------------
	Returns a rounded up angle
-----------------------------------------------------------]]
function meta:Ceil()

	return Angle( math.ceil( self[1] ), math.ceil( self[2] ), math.ceil( self[3] ) )

end
