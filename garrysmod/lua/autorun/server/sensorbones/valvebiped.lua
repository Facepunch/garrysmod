--
-- These are the physics bone numbers
--
local PLVS		= 0
local SPNE		= 1
local RSLD		= 2
local LSLD		= 3
local LARM		= 4
local LHND		= 5
local RARM		= 6
local RHND		= 7
local RTHY		= 8
local RCLF		= 9
local HEAD		= 10
local LTHY		= 11
local LCLF		= 12
local LFOT		= 13
local RFOT		= 14

local Builder =
{
	PrePosition = function( self, sensor )

		local spinestretch = ( sensor[SENSORBONE.SHOULDER] - sensor[SENSORBONE.SPINE] )  * 0.7

		sensor[SENSORBONE.SHOULDER]:Add( spinestretch * 0.7 )
		sensor[SENSORBONE.SHOULDER_RIGHT]:Add( spinestretch )
		sensor[SENSORBONE.SHOULDER_LEFT]:Add( spinestretch )
		sensor[SENSORBONE.ELBOW_LEFT]:Add( spinestretch )
		sensor[SENSORBONE.ELBOW_RIGHT]:Add( spinestretch )
		sensor[SENSORBONE.WRIST_LEFT]:Add( spinestretch )
		sensor[SENSORBONE.WRIST_RIGHT]:Add( spinestretch )
		sensor[SENSORBONE.HAND_LEFT]:Add( spinestretch )
		sensor[SENSORBONE.HAND_RIGHT]:Add( spinestretch )
		sensor[SENSORBONE.HEAD]:Add( spinestretch * 0.5 )

		sensor[SENSORBONE.HIP_LEFT]:Add( spinestretch * 0.3 )
		sensor[SENSORBONE.HIP_RIGHT]:Add( spinestretch * 0.3 )

		sensor[SENSORBONE.KNEE_RIGHT]:Add( ( sensor[SENSORBONE.HIP_RIGHT] - sensor[SENSORBONE.KNEE_RIGHT] ) * 0.2 )
		sensor[SENSORBONE.KNEE_LEFT]:Add( ( sensor[SENSORBONE.HIP_LEFT] - sensor[SENSORBONE.KNEE_LEFT] ) * 0.2 )

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
		[LHND]	= SENSORBONE.WRIST_LEFT,
		[RARM]	= SENSORBONE.ELBOW_RIGHT,
		[RHND]	= SENSORBONE.WRIST_RIGHT,
		[LTHY]	= SENSORBONE.HIP_LEFT,
		[RTHY]	= SENSORBONE.HIP_RIGHT,
		[RCLF]	= SENSORBONE.KNEE_RIGHT,
		[LCLF]	= SENSORBONE.KNEE_LEFT,
		[RFOT]	= SENSORBONE.ANKLE_RIGHT,
		[LFOT]	= SENSORBONE.ANKLE_LEFT,
		[HEAD]	= SENSORBONE.HEAD,
		[SPNE]	= SENSORBONE.SPINE,
	},

	--
	-- Which bones should we use to determine our bone angles
	--
	AnglesTable =
	{
		[PLVS]	= { from = LTHY, to = RTHY, up = "hips_fwd" },
		[SPNE]	= { from_sensor = SENSORBONE.HEAD,	to_sensor = SENSORBONE.SPINE, up = "chest_rgt" },
		[HEAD]	= { from_sensor = SENSORBONE.HEAD,	to_sensor = SENSORBONE.SHOULDER, up = "chest_lft" },
		[RSLD]	= { from = RARM, to = RSLD, up = "chest_up" },
		[LSLD]	= { from = LARM, to = LSLD, up = "chest_dn" },
		[RARM]	= { from = RHND, to = RARM, up_up = RSLD },
		[LARM]	= { from = LHND, to = LARM, up_up = LSLD },
		[RTHY]	= { from = RCLF, to = RTHY, up_up = SPNE },
		[RCLF]	= { from = RFOT, to = RCLF, up_up = RTHY },
		[LTHY]	= { from = LCLF, to = LTHY, up_up = SPNE },
		[LCLF]	= { from = LFOT, to = LCLF, up_up = LTHY },
		[RHND]	= { from_sensor = SENSORBONE.HAND_RIGHT,	to_sensor = SENSORBONE.WRIST_RIGHT, up_lft = RARM },
		[LHND]	= { from_sensor = SENSORBONE.HAND_LEFT,		to_sensor = SENSORBONE.WRIST_LEFT, up_rgt = LARM }
	},

	--
	-- Any polishing that can't be done with the above tables
	--
	Complete = function( self, player, sensor, rotation, pos, ang )

		pos[SPNE] = LerpVector( 0.45, pos[SPNE], pos[HEAD] )

		-- Feet are insanely spazzy, so we lock the feet to the angle of the calf
		ang[LFOT]	= ang[LCLF]:Right():AngleEx( ang[LCLF]:Up() ) + Angle( 20, 0, 0 )
		ang[RFOT]	= ang[RCLF]:Right():AngleEx( ang[RCLF]:Up() ) + Angle( 20, 0, 0 )

	end,

	-- We're used as a default - no need to return true to anything here.
	IsApplicable = function( self, ent ) return false end,
}

list.Set( "SkeletonConvertor", "ValveBiped", Builder )
