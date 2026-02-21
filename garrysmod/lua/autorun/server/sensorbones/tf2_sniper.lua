--
-- These are the physics bone numbers
--
local PLVS		= 0
local RTHY		= 1
local RCLF		= 2
local RFOT		= 3
local LTHY		= 4
local LCLF		= 5
local LFOT		= 6
local SPNE		= 7
local RSLD		= 8
local RARM		= 9
local LSLD		= 10
local LARM		= 11
local LHND		= 12
local NECK		= 13
local HEAD		= 14
local RHND		= 15

-- pouch



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
		sensor[SENSORBONE.HAND_RIGHT]:Add( spinestretch + acrossshoulders )
		sensor[SENSORBONE.HEAD]:Add( spinestretch * 0.9 )

		local acrosships = ( sensor[SENSORBONE.HIP_LEFT] - sensor[SENSORBONE.HIP_RIGHT] ):GetNormal() * 0.06

		sensor[SENSORBONE.HIP_LEFT]:Add( spinestretch * -0.1 + acrosships )
		sensor[SENSORBONE.HIP_RIGHT]:Add( spinestretch * -0.1 + acrosships * -1 )

		sensor[SENSORBONE.KNEE_LEFT]:Add( ( sensor[SENSORBONE.KNEE_LEFT]-sensor[SENSORBONE.HIP_LEFT] ) * 0.3 + acrosships )
		sensor[SENSORBONE.KNEE_RIGHT]:Add( ( sensor[SENSORBONE.KNEE_RIGHT] - sensor[SENSORBONE.HIP_RIGHT] ) * 0.3 - acrosships )

		sensor[SENSORBONE.FOOT_LEFT]:Add( ( sensor[SENSORBONE.ANKLE_LEFT] - sensor[SENSORBONE.KNEE_LEFT] ) * 0.6 + acrosships )
		sensor[SENSORBONE.FOOT_RIGHT]:Add( ( sensor[SENSORBONE.ANKLE_RIGHT] - sensor[SENSORBONE.KNEE_RIGHT] ) * 0.6 - acrosships )

		sensor[SENSORBONE.ANKLE_LEFT]:Add( ( sensor[SENSORBONE.ANKLE_LEFT] - sensor[SENSORBONE.KNEE_LEFT] ) * 0.6 + acrosships )
		sensor[SENSORBONE.ANKLE_RIGHT]:Add( ( sensor[SENSORBONE.ANKLE_RIGHT] - sensor[SENSORBONE.KNEE_RIGHT] ) * 0.6 - acrosships )

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
		[NECK]	= SENSORBONE.HEAD,
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
		[LARM]	= { from = LHND, to = LARM, up_up = LSLD },
		[LHND]	= { from_sensor = SENSORBONE.WRIST_LEFT, to_sensor = SENSORBONE.HAND_LEFT, up_bck = LARM },

		[RTHY]	= { from = RCLF, to = RTHY, up_dn = PLVS },
		[RCLF]	= { from = RFOT, to = RCLF, up_lft = RTHY },
		[RFOT]	= { from = RCLF, to = RFOT, up_up = RTHY },

		[LTHY]	= { from = LCLF, to = LTHY, up_dn = PLVS },
		[LCLF]	= { from = LFOT, to = LCLF, up_up = LTHY },
		[LFOT]	= { from = LFOT, to = LCLF, up_up = LTHY },
	},

	--
	-- Any polishing that can't be done with the above tables
	--
	Complete = function( self, player, sensor, rotation, pos, ang )

		--
		-- Feet are insanely spazzy, so we lock the feet to the angle of the calf
		--
		ang[RFOT]:RotateAroundAxis( ang[RFOT]:Up(), -90 )
		ang[RFOT]:RotateAroundAxis( ang[RFOT]:Forward(), 180 )
		ang[LFOT]:RotateAroundAxis( ang[LFOT]:Up(), 90 )

		ang[LFOT]:RotateAroundAxis( ang[LFOT]:Forward(), -45 )
		ang[RFOT]:RotateAroundAxis( ang[LFOT]:Forward(), -45 )

		ang[PLVS]:RotateAroundAxis( ang[PLVS]:Up(), -90 )
		ang[SPNE]:RotateAroundAxis( ang[SPNE]:Up(), -90 )
		ang[HEAD]:RotateAroundAxis( ang[HEAD]:Up(), -90 )

		ang[NECK] = ang[HEAD]

		pos[16] = pos[PLVS]
		ang[16] = ang[PLVS] * 1
		ang[16]:RotateAroundAxis( ang[1]:Right(), 180 )

		--
		-- AGH HANDS
		--
		ang[LHND] = ang[LARM] * 1
		ang[LHND]:RotateAroundAxis( ang[LHND]:Up(), 90 )
		ang[RHND] = ang[RARM] * 1
		ang[RHND]:RotateAroundAxis( ang[RHND]:Up(), -90 )

		ang[RHND]:RotateAroundAxis( ang[RHND]:Right(), 180 )

	end,

	IsApplicable = function( self, ent )

		local mdl = ent:GetModel()

		if ( mdl:EndsWith( "models/player/sniper.mdl" ) ) then return true end
		if ( mdl:EndsWith( "models/player/hwm/sniper.mdl" ) ) then return true end
		if ( mdl:EndsWith( "models/bots/sniper/bot_sniper.mdl" ) ) then return true end

		return false

	end,
}

list.Set( "SkeletonConvertor", "TF2_sniper", Builder )
