--
-- These are the physics bone numbers
--
local PLVS		= 0

-- Coat 1-9
local RTHY		= 10
local RCLF		= 11

-- Coat 12
local LTHY		= 13
local LCLF		= 14
local LFOT		= 15
local SPNE		= 16
local RSLD		= 17
local RARM		= 18
local LSLD		= 19
local LARM		= 20
local HEAD		= 21
local RHND		= 22
local RFOT		= 23



local Builder =
{
	PrePosition = function( self, sensor )

		local spinestretch = ( sensor[SENSORBONE.SHOULDER] - sensor[SENSORBONE.SPINE] )  * 0.6

		local acrossshoulders = ( sensor[SENSORBONE.SHOULDER_RIGHT] - sensor[SENSORBONE.SHOULDER_LEFT] ):GetNormal() * 0.08

		sensor[SENSORBONE.SHOULDER]:Add( spinestretch * 0.6 )
		sensor[SENSORBONE.SHOULDER_RIGHT]:Add( spinestretch + acrossshoulders )
		sensor[SENSORBONE.SHOULDER_LEFT]:Add( spinestretch - acrossshoulders )
		sensor[SENSORBONE.ELBOW_LEFT]:Add( spinestretch - acrossshoulders )
		sensor[SENSORBONE.ELBOW_RIGHT]:Add( spinestretch + acrossshoulders )
		sensor[SENSORBONE.WRIST_LEFT]:Add( spinestretch  - acrossshoulders )
		sensor[SENSORBONE.WRIST_RIGHT]:Add( spinestretch + acrossshoulders )
		sensor[SENSORBONE.HAND_LEFT]:Add( spinestretch - acrossshoulders )
		sensor[SENSORBONE.HAND_RIGHT]:Add( spinestretch + acrossshoulders )
		sensor[SENSORBONE.HEAD]:Add( spinestretch * 0.9 )

		local acrosships = ( sensor[SENSORBONE.HIP_LEFT] - sensor[SENSORBONE.HIP_RIGHT] ):GetNormal() * 0.06

		sensor[SENSORBONE.HIP_LEFT]:Add( spinestretch * -0.1 + acrosships )
		sensor[SENSORBONE.HIP_RIGHT]:Add( spinestretch * -0.1 + acrosships * -1 )

		sensor[SENSORBONE.KNEE_LEFT]:Add( ( sensor[SENSORBONE.KNEE_LEFT]-sensor[SENSORBONE.HIP_LEFT] ) * 0.1 + acrosships )
		sensor[SENSORBONE.KNEE_RIGHT]:Add( ( sensor[SENSORBONE.KNEE_RIGHT] - sensor[SENSORBONE.HIP_RIGHT] ) * 0.1 - acrosships )

		sensor[SENSORBONE.FOOT_LEFT]:Add( ( sensor[SENSORBONE.ANKLE_LEFT] - sensor[SENSORBONE.KNEE_LEFT] ) * 1.0 + acrosships )
		sensor[SENSORBONE.FOOT_RIGHT]:Add( ( sensor[SENSORBONE.ANKLE_RIGHT] - sensor[SENSORBONE.KNEE_RIGHT] ) * 1.0 - acrosships )

		sensor[SENSORBONE.ANKLE_LEFT]:Add( ( sensor[SENSORBONE.ANKLE_LEFT] - sensor[SENSORBONE.KNEE_LEFT] ) * 1.0 + acrosships )
		sensor[SENSORBONE.ANKLE_RIGHT]:Add( ( sensor[SENSORBONE.ANKLE_RIGHT] - sensor[SENSORBONE.KNEE_RIGHT] ) * 1.0 - acrosships )

	end,

	--
	-- Which on the sensor should we use for which ones on our model
	--
	PositionTable =
	{
		[PLVS]	= SENSORBONE.HIP,
		[RSLD]	= SENSORBONE.SHOULDER_RIGHT,
		[LSLD]	= SENSORBONE.SHOULDER_LEFT,
		[LARM]	= SENSORBONE.ELBOW_LEFT,
		[RARM]	= SENSORBONE.ELBOW_RIGHT,
		[RHND]	= SENSORBONE.WRIST_RIGHT,
		[LTHY]	= SENSORBONE.HIP_LEFT,
		[RTHY]	= SENSORBONE.HIP_RIGHT,
		[RCLF]	= SENSORBONE.KNEE_RIGHT,
		[LCLF]	= SENSORBONE.KNEE_LEFT,
		[RFOT]	= SENSORBONE.ANKLE_RIGHT,
		[LFOT]	= SENSORBONE.ANKLE_LEFT,
		[HEAD]	= SENSORBONE.HEAD,
		[SPNE]	= { type = "lerp", value = 0.8, from = SENSORBONE.SHOULDER, to = SENSORBONE.SPINE }
	},

	--
	-- Which bones should we use to determine our bone angles
	--
	AnglesTable =
	{
		[PLVS]	= { from = PLVS, to = SPNE, up = "hips_back" },
		[SPNE]	= { from = PLVS, to = SPNE, up = "chest_bck" },
		[HEAD]	= { from = SPNE, to = HEAD, up = "head_back" },

		[RSLD]	= { from = RARM, to = RSLD, up_rgt = SPNE },
		[RARM]	= { from = RHND, to = RARM, up_rgt = RSLD },
		[RHND]	= { from_sensor = SENSORBONE.HAND_RIGHT, to_sensor = SENSORBONE.WRIST_RIGHT, up_fwd = RARM },

		[LSLD]	= { from = LARM, to = LSLD, up_lft = SPNE },
		[LARM]	= { from_sensor = SENSORBONE.HAND_LEFT, to_sensor = SENSORBONE.ELBOW_LEFT, up_up = LSLD },

		[RTHY]	= { from = RCLF, to = RTHY, up = "right" },
		[RCLF]	= { from = RFOT, to = RCLF, up_up = RTHY },

		[LTHY]	= { from = LCLF, to = LTHY, up = "forward" },
		[LCLF]	= { from = LFOT, to = LCLF, up_up = LTHY },
	},

	--
	-- Any polishing that can't be done with the above tables
	--
	Complete = function( self, player, sensor, rotation, pos, ang )

		--
		-- Feet are insanely spazzy, so we lock the feet to the angle of the calf
		--
		ang[RFOT]	= ang[RCLF]:Right():AngleEx( ang[RCLF]:Up() ) + Angle( 0, 180, -40 )
		ang[LFOT]	= ang[LCLF]:Right():AngleEx( ang[LCLF]:Up() ) + Angle( 0, -90, 130 )

		ang[PLVS]:RotateAroundAxis( ang[PLVS]:Up(), -90 )
		ang[SPNE]:RotateAroundAxis( ang[SPNE]:Up(), -90 )
		ang[HEAD]:RotateAroundAxis( ang[HEAD]:Up(), -90 )

		--
		-- AGH HANDS
		--
		ang[RHND] = ang[RARM] * 1
		ang[RHND]:RotateAroundAxis( ang[RHND]:Up(), -90 )

		ang[RHND]:RotateAroundAxis( ang[RHND]:Right(), 180 )

	end,

	IsApplicable = function( self, ent )

		local mdl = ent:GetModel()

		if ( mdl:EndsWith( "models/player/medic.mdl" ) ) then return true end
		if ( mdl:EndsWith( "models/player/hwm/medic.mdl" ) ) then return true end
		if ( mdl:EndsWith( "models/bots/medic/bot_medic.mdl" ) ) then return true end
		if ( mdl:EndsWith( "models/bots/medic_boss/bot_medic_boss.mdl" ) ) then return true end

		return false

	end,
}

list.Set( "SkeletonConvertor", "TF2_medic", Builder )
