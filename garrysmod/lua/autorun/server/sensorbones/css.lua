--
-- These are the physics bone numbers
--
local PLVS		= 0
local SPNE		= 1
local TRSO		= 2
local RSLD		= 3
local LSLD		= 4
local LARM		= 5
local LWST		= 6
local LHND		= 7
local RARM		= 8
local RWST		= 9
local RHND		= 10
local RTHY		= 11
local RCLF		= 12
local LTHY		= 13
local LCLF		= 14
local HEAD		= 15

local Builder =
{
	PrePosition = function( self, sensor )

		local spinestretch = ( sensor[SENSORBONE.SHOULDER] - sensor[SENSORBONE.SPINE] )  * 1.0

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

		sensor[SENSORBONE.HIP_LEFT]:Add( spinestretch * 0.2 )
		sensor[SENSORBONE.HIP_RIGHT]:Add( spinestretch * 0.2 )
	--	sensor[SENSORBONE.HIP_RIGHT]:Add( spinestretch * 0.3 )

	end,

	--
	-- Which on the sensor should we use for which ones on our model
	--
	PositionTable =
	{
		[PLVS]	= SENSORBONE.HIP,
		[TRSO]	= SENSORBONE.SPINE,
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
		[TRSO]	= { from_sensor = SENSORBONE.HEAD,	to_sensor = SENSORBONE.SPINE, up = "chest_rgt" },
		[HEAD]	= { from_sensor = SENSORBONE.HEAD,	to_sensor = SENSORBONE.SHOULDER, up = "chest_lft" },
		[RSLD]	= { from = RSLD, to = LSLD, up = "chest_bck" },
		[LSLD]	= { from = LSLD, to = RSLD, up = "chest_fwd" },
		[RARM]	= { from = RARM, to = RSLD, up = "chest_up" },
		[LARM]	= { from = LARM, to = LSLD, up = "chest_dn" },
		[RWST]	= { from = RHND, to = RARM, up = "chest_up" },
		[LWST]	= { from = LHND, to = LARM, up = "chest_dn" },
		[RTHY]	= { from = RCLF, to = RTHY, up_up = SPNE },
		[RCLF]	= { from_sensor = SENSORBONE.ANKLE_RIGHT,	to_sensor = SENSORBONE.KNEE_RIGHT, up_up = RTHY },
		[LTHY]	= { from = LCLF, to = LTHY, up_up = SPNE },
		[LCLF]	= { from_sensor = SENSORBONE.ANKLE_LEFT,	to_sensor = SENSORBONE.KNEE_LEFT, up_up = LTHY },
		[RHND]	= { from_sensor = SENSORBONE.HAND_RIGHT,	to_sensor = SENSORBONE.WRIST_RIGHT, up_lft = RARM },
		[LHND]	= { from_sensor = SENSORBONE.HAND_LEFT,		to_sensor = SENSORBONE.WRIST_LEFT, up_rgt = LARM },
		[LWST]	= { from = LHND, to = LARM, up = "chest_dn" },
	},

	--
	-- Any polishing that can't be done with the above tables
	--
	Complete = function( self, player, sensor, rotation, pos, ang )

		pos[SPNE] = LerpVector( 0.45, pos[SPNE], pos[HEAD] )
		pos[RWST] = pos[RARM]
		pos[LWST] = pos[LARM]

	end,

	-- We're used as a default - no need to return true to anything here.
	IsApplicable = function( self, ent )

		local mdl = ent:GetModel()

		if ( mdl:EndsWith( "models/player/ct_gign.mdl" ) ) then return true end
		if ( mdl:EndsWith( "models/player/ct_sas.mdl" ) ) then return true end
		if ( mdl:EndsWith( "models/player/ct_urban.mdl" ) ) then return true end
		if ( mdl:EndsWith( "models//player/ct_gsg9.mdl" ) ) then return true end
		if ( mdl:EndsWith( "models/player/t_guerilla.mdl" ) ) then return true end
		if ( mdl:EndsWith( "models/player/t_leet.mdl" ) ) then return true end
		if ( mdl:EndsWith( "models/player/t_phoenix.mdl" ) ) then return true end
		if ( mdl:EndsWith( "models//player/t_arctic.mdl" ) ) then return true end

		return false

	end,
}

list.Set( "SkeletonConvertor", "CounterStrikeSource", Builder )
