--
-- These are the physics bone numbers
--
local PLVS		= 0
local RTHY		= 1
local RCLF		= 2
local LTHY		= 3
local LCLF		= 4
local LFOT		= 5
local SPNE		= 6
local TRSO		= 7
local RSLD		= 8
local LSLD		= 9
local LARM		= 10
local LHND		= 11
local RARM		= 12
local NECK		= 13
local RHND		= 14
local HEAD		= 15
local RFOT		= 16

local Builder =
{
	PrePosition = function( self, sensor )

		local spinestretch = ( sensor[SENSORBONE.SHOULDER] - sensor[SENSORBONE.SPINE] )  * 0.8

		local acrossshoulders = ( sensor[SENSORBONE.SHOULDER_RIGHT] - sensor[SENSORBONE.SHOULDER_LEFT] ):GetNormal() * 0.08

		sensor[SENSORBONE.SHOULDER]:Add( spinestretch * 0.7 )
		sensor[SENSORBONE.SHOULDER_RIGHT]:Add( spinestretch + acrossshoulders )
		sensor[SENSORBONE.SHOULDER_LEFT]:Add( spinestretch - acrossshoulders )
		sensor[SENSORBONE.ELBOW_LEFT]:Add( spinestretch - acrossshoulders )
		sensor[SENSORBONE.ELBOW_RIGHT]:Add( spinestretch + acrossshoulders )
		sensor[SENSORBONE.WRIST_LEFT]:Add( spinestretch  - acrossshoulders )
		sensor[SENSORBONE.WRIST_RIGHT]:Add( spinestretch + acrossshoulders )
		sensor[SENSORBONE.HAND_LEFT]:Add( spinestretch - acrossshoulders )
		sensor[SENSORBONE.HAND_RIGHT]:Add( spinestretch  + acrossshoulders )
		sensor[SENSORBONE.HEAD]:Add( spinestretch * 0.8 )

		local acrosships = ( sensor[SENSORBONE.HIP_LEFT] - sensor[SENSORBONE.HIP_RIGHT] ):GetNormal() * 0.08

		sensor[SENSORBONE.HIP_LEFT]:Add( spinestretch * -0.1 + acrosships )
		sensor[SENSORBONE.HIP_RIGHT]:Add( spinestretch * -0.1 + acrosships * -1 )

		sensor[SENSORBONE.KNEE_LEFT]:Add( ( sensor[SENSORBONE.KNEE_LEFT]-sensor[SENSORBONE.HIP_LEFT] ) * 0.3 + acrosships )
		sensor[SENSORBONE.KNEE_RIGHT]:Add( ( sensor[SENSORBONE.KNEE_RIGHT] - sensor[SENSORBONE.HIP_RIGHT] ) * 0.3 - acrosships )

		sensor[SENSORBONE.ANKLE_LEFT]:Add( ( sensor[SENSORBONE.ANKLE_LEFT] - sensor[SENSORBONE.KNEE_LEFT] ) * 0.8 + acrosships )
		sensor[SENSORBONE.ANKLE_RIGHT]:Add( ( sensor[SENSORBONE.ANKLE_RIGHT] - sensor[SENSORBONE.KNEE_RIGHT] ) * 0.8 - acrosships )

	end,

	--
	-- Which on the sensor should we use for which ones on our model
	--
	PositionTable =
	{
		[PLVS]	= SENSORBONE.HIP,
		[TRSO]	= { type = "lerp", value = 0.2, from = SENSORBONE.SHOULDER, to = SENSORBONE.SPINE },
		[NECK]	= { type = "lerp", value = 0.3, from = SENSORBONE.SHOULDER, to = SENSORBONE.HEAD },
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
		[SPNE]	= { type = "lerp", value = 0.8, from = SENSORBONE.SHOULDER, to = SENSORBONE.SPINE }
	},

	--
	-- Which bones should we use to determine our bone angles
	--
	AnglesTable =
	{
		[PLVS]	= { from = PLVS, to = SPNE, up = "hips_back" },
		[SPNE]	= { from = SPNE, to = TRSO, up = "chest_bck" },
		[TRSO]	= { from = TRSO, to = NECK, up = "head_back" },
		[HEAD]	= { from = NECK, to = HEAD, up = "head_back" },
		[NECK]	= { from = TRSO, to = NECK, up = "head_back" },

		[RSLD]	= { from = RARM, to = RSLD, up_rgt = TRSO },
		[RARM]	= { from = RHND, to = RARM, up_up = RSLD },
		[RHND]	= { from_sensor = SENSORBONE.HAND_RIGHT, to_sensor = SENSORBONE.WRIST_RIGHT, up_dn = RARM },

		[LSLD]	= { from = LARM, to = LSLD, up_lft = TRSO },
		[LARM]	= { from = LHND, to = LARM, up_up = LSLD },
		[LHND]	= { from_sensor = SENSORBONE.WRIST_LEFT, to_sensor = SENSORBONE.HAND_LEFT, up_up = LARM },

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
		ang[RFOT]	= ang[RCLF]:Right():AngleEx( ang[RCLF]:Up() ) + Angle( 0, 90, -70 )
		ang[LFOT]	= ang[LCLF]:Right():AngleEx( ang[LCLF]:Up() ) + Angle( 0, -90, 110 )

		--
		-- TODO: Get the hands working.
		--
		--ang[RHND]	= ( ang[RARM]:Up() ):AngleEx( ang[RARM]:Right() * -1 )
		--ang[LHND]	= ( ang[LARM]:Up() ):AngleEx( ang[LARM]:Right() )

		--
		-- Maya uses Y up for some bones. Because life isn't hard enough already.
		--
		ang[PLVS]:RotateAroundAxis( ang[PLVS]:Up(), -90 )
		ang[SPNE]:RotateAroundAxis( ang[SPNE]:Up(), -90 )
		ang[TRSO]:RotateAroundAxis( ang[TRSO]:Up(), -90 )
		ang[NECK]:RotateAroundAxis( ang[NECK]:Up(), -90 )
		ang[HEAD]:RotateAroundAxis( ang[HEAD]:Up(), -90 )

		ang[LHND]:RotateAroundAxis( ang[LHND]:Up(), -90 )
		ang[RHND]:RotateAroundAxis( ang[RHND]:Up(), -90 )

		--ang[LHND]:RotateAroundAxis( ang[LHND]:Right(), 180 )

	end,

	IsApplicable = function( self, ent )

		local mdl = ent:GetModel()

		if ( mdl:EndsWith( "models/player/hwm/soldier.mdl" ) ) then return true end
		if ( mdl:EndsWith( "models/player/soldier.mdl" ) ) then return true end
		if ( mdl:EndsWith( "models/player/spy.mdl" ) ) then return true end
		if ( mdl:EndsWith( "models/player/hwm/spy.mdl" ) ) then return true end
		if ( mdl:EndsWith( "models/bots/soldier/bot_soldier.mdl" ) ) then return true end
		if ( mdl:EndsWith( "models/bots/spy/bot_spy.mdl" ) ) then return true end
		if ( mdl:EndsWith( "models/bots/soldier_boss/bot_soldier_boss.mdl" ) ) then return true end

		return false

	end,
}

list.Set( "SkeletonConvertor", "TF2_soldier_spy", Builder )
