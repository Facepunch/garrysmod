--
-- These are the physics bone numbers
--
local PLVS		= 0
local LTHY		= 1
local SPNE		= 2
local RSLD		= 3
local RARM		= 4
local LSLD		= 5
local LARM		= 6
local LHND		= 7
local HEAD		= 8
local RHND		= 9
local RTHY		= 10
local RCLF		= 11
local LCLF		= 12
local RFOT		= 13

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
		[HEAD]	= SENSORBONE.HEAD,
		[SPNE]	= SENSORBONE.SPINE,
	},

	--
	-- Which bones should we use to determine our bone angles
	--
	AnglesTable =
	{
		[PLVS]	= { from = LTHY, to = RTHY, up = "hips_fwd" },
		[SPNE]	= { from = HEAD, to = SPNE, up = "chest_rgt" },
		[HEAD]	= { from_sensor = SENSORBONE.HEAD,	to_sensor = SENSORBONE.SPINE, up = "chest_lft" },
		[RSLD]	= { from = RARM, to = RSLD, up = "chest_up" },
		[RARM]	= { from = RHND, to = RARM, up_up = RSLD },
		[LSLD]	= { from = LARM, to = LSLD, up = "chest_dn" },
		[LARM]	= { from = LHND, to = LARM, up_up = LSLD },
		[RTHY]	= { from = RCLF, to = RTHY, up_up = SPNE },
		[RCLF]	= { from = RFOT, to = RCLF, up_up = RTHY },
		[LTHY]	= { from = LCLF, to = LTHY, up_up = SPNE },
		[LCLF]	= { from_sensor = SENSORBONE.ANKLE_LEFT, to = LCLF, up_up = LTHY },
		[RHND]	= { from_sensor = SENSORBONE.HAND_RIGHT,	to_sensor = SENSORBONE.WRIST_RIGHT, up_lft = RARM },
		[LHND]	= { from_sensor = SENSORBONE.HAND_LEFT,		to_sensor = SENSORBONE.WRIST_LEFT, up_rgt = LARM }
	},

	--
	-- Any polishing that can't be done with the above tables
	--
	Complete = function( self, player, sensor, rotation, pos, ang )

		pos[SPNE] = LerpVector( 0.4, pos[SPNE], pos[HEAD] )

		-- Feet are insanely spazzy, so we lock the feet to the angle of the calf
		ang[RFOT]	= ang[RCLF]:Right():AngleEx( ang[RCLF]:Up() ) + Angle( 20, 0, 0 )

	end,

	-- Should this entity use this builder?
	IsApplicable = function( self, ent )

		return ent:GetModel():EndsWith( "models/eli.mdl" )

	end,
}

list.Set( "SkeletonConvertor", "Eli", Builder )
