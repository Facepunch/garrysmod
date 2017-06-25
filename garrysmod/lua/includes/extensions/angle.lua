local meta = FindMetaTable("Angle")

-- Nothing in here, still leaving this file here just in case

--[[---------------------------------------------------------
	Angle Snap to nearest interval of degrees
-----------------------------------------------------------]]
function meta:SnapTo(component, degrees)

	if (degrees == 0) then ErrorNoHalt( "The snap degrees must be non-zero.\n") return self; end
	if (not self[ component ] ) then ErrorNoHalt( "You must choose a valid component of Angle( p or pitch, y or yaw, r or roll) to snap such as Angle( 80, 40, 30):SnapTo( \"p\", 90):SnapTo( \"y\", 45):SnapTo( \"r\", 40); and yes, you can keep adding snaps.\n") return self; end

	self[ component ] = math.Round(self[ component ] / degrees) * degrees
	self[ component ] = math.NormalizeAngle(self[ component ])

	return self

end