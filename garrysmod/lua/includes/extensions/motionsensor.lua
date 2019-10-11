
--
-- Should never really happen.
--
motionsensor = motionsensor or {}



--
-- These bones are used to draw the debug 
-- kinect skeleton. You just need to loop through
-- and draw a line between each of these bones.
--
motionsensor.DebugBones = 
{
	-- Torso
	{ SENSORBONE.HEAD,				SENSORBONE.SHOULDER },
	{ SENSORBONE.SHOULDER,			SENSORBONE.SHOULDER_LEFT },
	{ SENSORBONE.SHOULDER,			SENSORBONE.SHOULDER_RIGHT },
	{ SENSORBONE.SHOULDER,			SENSORBONE.SPINE },
	{ SENSORBONE.SHOULDER,			SENSORBONE.HIP },
	{ SENSORBONE.HIP,				SENSORBONE.HIP_LEFT },
	{ SENSORBONE.HIP,				SENSORBONE.HIP_RIGHT },

	-- Left Arm
	{ SENSORBONE.SHOULDER_LEFT,		SENSORBONE.ELBOW_LEFT },
	{ SENSORBONE.ELBOW_LEFT,		SENSORBONE.WRIST_LEFT },
	{ SENSORBONE.WRIST_LEFT,		SENSORBONE.HAND_LEFT },

	-- Right Arm
	{ SENSORBONE.SHOULDER_RIGHT,	SENSORBONE.ELBOW_RIGHT },
	{ SENSORBONE.ELBOW_RIGHT,		SENSORBONE.WRIST_RIGHT },
	{ SENSORBONE.WRIST_RIGHT,		SENSORBONE.HAND_RIGHT },

	-- left leg
	{ SENSORBONE.HIP_LEFT,			SENSORBONE.KNEE_LEFT },
	{ SENSORBONE.KNEE_LEFT,			SENSORBONE.ANKLE_LEFT },
	{ SENSORBONE.ANKLE_LEFT,		SENSORBONE.FOOT_LEFT },

	-- right leg
	{ SENSORBONE.HIP_RIGHT,			SENSORBONE.KNEE_RIGHT },
	{ SENSORBONE.KNEE_RIGHT,		SENSORBONE.ANKLE_RIGHT },
	{ SENSORBONE.ANKLE_RIGHT,		SENSORBONE.FOOT_RIGHT },
}

motionsensor.ChooseBuilderFromEntity = function( ent )
	
	local builders = list.Get( "SkeletonConvertor" )

	for k, v in pairs( builders ) do

		if ( v:IsApplicable( ent ) ) then return k end

	end

	return 'ValveBiped'

end

motionsensor.ProcessAngle = function( translator, sensor, pos, ang, special_vectors, boneid, v )

	local a = nil
	local b = nil
	local up = special_vectors['up']

	--
	-- Using a vector from another angle.
	-- If the angle isn't processed yet return 
	-- we will be added to the list to process again.
	--
	if ( v.up_up ) then	
		if ( !ang[ v.up_up ] ) then return end			
		up = ang[ v.up_up ]:Up()			
	end

	if ( v.up_dn ) then	
		if ( !ang[ v.up_dn ] ) then return end			
		up = ang[ v.up_dn ]:Up() * -1			
	end

	if ( v.up_fwd ) then		
		if ( !ang[ v.up_fwd ] ) then return end		
		up = ang[ v.up_fwd ]:Forward()		
	end

	if ( v.up_lft ) then			
		if ( !ang[ v.up_lft ] ) then return end	
		up = ang[ v.up_lft ]:Right() * -1	
	end

	if ( v.up_rgt ) then	
		if ( !ang[ v.up_rgt ] ) then return end			
		up = ang[ v.up_rgt ]:Right()		
	end

	--
	-- From -> To vectors
	--
	if ( v.from_sensor ) then	a = sensor[ v.from_sensor ]		end
	if ( v.to_sensor ) then		b = sensor[ v.to_sensor ]		end
	if ( v.from ) then			a = pos[ v.from ]				end
	if ( v.to ) then			b = pos[ v.to ]					end

	--
	-- We can offer special vectors to define 'up'
	--
	if ( isstring( v.up ) ) then	
		up = special_vectors[ v.up ]		
	end

	if ( a == nil || b == nil || up == nil ) then return end

	ang[ boneid ]	= (a-b):GetNormal():AngleEx( up:GetNormal() );

	if ( v.adjust ) then
		ang[ boneid ] = ang[ boneid ] + v.adjust
	end

	return true

end

--
-- Processes the AnglesTable from a skeleton constructor
--
motionsensor.ProcessAnglesTable = function( translator, sensor, pos, rotation )

	if ( !translator.AnglesTable ) then return {} end

	local ang = {}

	local special_vectors = {}
	special_vectors['right']	= rotation:Right()
	special_vectors['left']		= special_vectors['right'] * -1
	special_vectors['up']		= rotation:Up()
	special_vectors['down']		= special_vectors['up'] * -1
	special_vectors['forward']	= special_vectors['down']:Cross( special_vectors['right'] )
	special_vectors['backward']	= special_vectors['forward'] * -1

	special_vectors['hips_left']	= (sensor[SENSORBONE.HIP_RIGHT]	- sensor[SENSORBONE.HIP_LEFT]):GetNormal()
	special_vectors['hips_up']		= (sensor[SENSORBONE.HIP]		- sensor[SENSORBONE.SHOULDER]):GetNormal()
	special_vectors['hips_back']	= special_vectors['hips_up']:Cross( special_vectors['hips_left'] )
	special_vectors['hips_fwd']		= special_vectors['hips_back'] * -1

	special_vectors['chest_lft']	= (sensor[SENSORBONE.SHOULDER_RIGHT]	- sensor[SENSORBONE.SHOULDER_LEFT]):GetNormal()
	special_vectors['chest_rgt']	= special_vectors['chest_lft'] * -1
	special_vectors['chest_up']		= (sensor[SENSORBONE.SPINE]		- sensor[SENSORBONE.SHOULDER]):GetNormal()
	special_vectors['chest_dn']		= special_vectors['chest_up'] * -1
	special_vectors['chest_bck']	= special_vectors['chest_up']:Cross( special_vectors['chest_lft'] )
	special_vectors['chest_fwd']	= special_vectors['chest_bck'] * -1

	special_vectors['head_up']		= (sensor[SENSORBONE.SHOULDER]		- sensor[SENSORBONE.HEAD]):GetNormal()
	special_vectors['head_back']	= special_vectors['head_up']:Cross( special_vectors['chest_lft'] )

	local reprocess = {}

	for k, v in pairs( translator.AnglesTable ) do

		table.insert( reprocess, k )

	end

	for iPasses = 1, 5 do

		local cur_process = reprocess;
		reprocess = {}

		for k, v in pairs( cur_process ) do

			if ( !motionsensor.ProcessAngle( translator, sensor, pos, ang, special_vectors, v, translator.AnglesTable[v] ) ) then
				table.insert( reprocess, v )
			end

		end

		if ( table.IsEmpty( reprocess ) ) then
			--DebugInfo( 0, iPasses .. " Passes" )
			return ang
		end

	end

	--
	-- If we got here then we're doing something wrong.
	-- It should have out'ed before completing 5 passes.
	--
	DebugInfo( 0, "motionsensor.ProcessAnglesTable: 4+ passes!" )
	return ang

end

--
-- Processes the PositionTable from a skeleton constructor
--
motionsensor.ProcessPositionTable = function( translator, sensor )

	if ( !translator.PositionTable ) then return {} end

	local pos = {}

	for k, v in pairs( translator.PositionTable ) do

		-- A number means get value straight from the sensor
		if ( isnumber( v ) ) then pos[ k ] = sensor[ v ] end

		if ( istable( v ) ) then

			if ( v.type == "lerp" ) then pos[ k ] = LerpVector( v.value, sensor[ v.from ], sensor[ v.to ] ) end

		end

	end

	return pos

end

--
-- Called to build the skeleton
--
motionsensor.BuildSkeleton = function( translator, player, rotation )

	--
	-- The kinect animations are recorded on the skunt, so rotate towards the player
	--
	rotation:RotateAroundAxis( rotation:Up(), -90 )

	--
	-- Pre-get and rotate all the player positions
	--
	local sensor = {}
	for i=0, 19 do
		sensor[ i ] = player:MotionSensorPos( i )
		sensor[ i ]:Rotate( rotation )
	end

	if ( translator.PrePosition ) then
		translator:PrePosition( sensor )
	end

	--
	-- Fill out the position table..
	--
	local pos = motionsensor.ProcessPositionTable( translator, sensor )

	
	--
	-- Fill out the angles
	--
	local ang = motionsensor.ProcessAnglesTable( translator, sensor, pos, rotation )

	--
	-- Allow the bone builder to make any last minute changes
	--
	translator:Complete( player, sensor, rotation, pos, ang )


	return pos, ang, sensor

end

