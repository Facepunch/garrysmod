
if ( !kinect.IsAvailable() ) then return end

if ( !kinect.IsActive() ) then
	MsgN( "Stop Using.." )
	MsgN( kinect.Stop() )

	MsgN( "Start Using.." )
	MsgN( kinect.Start() )
end

local Bones = 
{
	-- Torso
	{ KINECT.HEAD, KINECT.SHOULDER },
	{ KINECT.SHOULDER, KINECT.SHOULDER_LEFT },
	{ KINECT.SHOULDER, KINECT.SHOULDER_RIGHT },
	{ KINECT.SHOULDER, KINECT.SPINE },
	{ KINECT.SHOULDER, KINECT.HIP },
	{ KINECT.HIP, KINECT.HIP_LEFT },
	{ KINECT.HIP, KINECT.HIP_RIGHT },

	-- Left Arm
	{ KINECT.SHOULDER_LEFT, KINECT.ELBOW_LEFT },
	{ KINECT.ELBOW_LEFT, KINECT.WRIST_LEFT },
	{ KINECT.WRIST_LEFT, KINECT.HAND_LEFT },

	-- Right Arm
	{ KINECT.SHOULDER_RIGHT, KINECT.ELBOW_RIGHT },
	{ KINECT.ELBOW_RIGHT, KINECT.WRIST_RIGHT },
	{ KINECT.WRIST_RIGHT, KINECT.HAND_RIGHT },

	-- left leg
	{ KINECT.HIP_LEFT, KINECT.KNEE_LEFT },
	{ KINECT.KNEE_LEFT, KINECT.ANKLE_LEFT },
	{ KINECT.ANKLE_LEFT, KINECT.FOOT_LEFT },

	-- right leg
	{ KINECT.HIP_RIGHT, KINECT.KNEE_RIGHT },
	{ KINECT.KNEE_RIGHT, KINECT.ANKLE_RIGHT },
	{ KINECT.ANKLE_RIGHT, KINECT.FOOT_RIGHT },
}



function kinect.DrawSkeleton( skel, func )

	for k, v in pairs( Bones ) do

		local a = skel.bones[ v[1] ]
		if ( !a ) then continue end
		local b = skel.bones[ v[2] ]
		if ( !b ) then continue end

		func( a.pos, b.pos )
	end

end

hook.Add( "DrawOverlay", "KinectDrawTest", function()

	if ( !kinect.IsActive() ) then return end

	local Sensor = kinect.GetSkeleton()
	--PrintTable( Skeleton )

	cam.Start3D( Vector( 0, -100, 0 ), Angle( 0, 90, 0 ) )


	for id, skeleton in pairs( Sensor ) do

		kinect.DrawSkeleton( skeleton, function( vA, vB )
		
			render.DrawLine( vA * 50, vB * 50, col, true )

		end )

	end

	local skel = { bones = {} }
	for k=0, 20 do 
		skel.bones[k] = LocalPlayer():GetKinectPos( k )
	end
	
	kinect.DrawSkeleton( skel, function( vA, vB )
		
			if ( !vA ) then return end

		render.DrawLine( vA * 50, vB * 50, Color( 255, 0, 0, 255 ), true )

	end )

		--render.DrawWireframeSphere( Vector( 0, 0, 0 ), 1, 10, 10, Color( 255, 255, 255, 255 ), true )

	cam.End3D()


end )