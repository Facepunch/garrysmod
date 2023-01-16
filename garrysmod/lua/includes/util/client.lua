
--[[---------------------------------------------------------
	Get the real frame time, instead of the
		host_timescale linked frametime. This is for things
		like GUI effects. NOT FOR REAL IN GAME STUFF(!!!)
-----------------------------------------------------------]]
local FrameTime = 0
local LastQuery = 0

function RealFrameTime() return FrameTime end

local function RealFrameTimeThink()

	FrameTime = math.Clamp( SysTime() - LastQuery, 0, 0.1 )
	LastQuery = SysTime()

end

hook.Add( "Think", "RealFrameTime", RealFrameTimeThink ) -- Think is called after every frame on the client.

local function RenderSpawnIcon_Prop( model, pos, middle, size )

	if ( size < 900 ) then
		size = size * ( 1 - ( size / 900 ) )
	else
		size = size * ( 1 - ( size / 4096 ) )
	end

	size = math.Clamp( size, 5, 1000 )

	local ViewAngle = Angle( 25, 220, 0 )
	local ViewPos = pos + ViewAngle:Forward() * size * -15
	local view = {}

	view.fov		= 4 + size * 0.04
	view.origin		= ViewPos + middle
	view.znear		= 1
	view.zfar		= ViewPos:Distance( pos ) + size * 2
	view.angles		= ViewAngle

	return view

end

local function RenderSpawnIcon_Ragdoll( model, pos, middle, size )

	local at = model:GetAttachment( model:LookupAttachment( "eyes" ) )
	if ( !at ) then at = { Pos = model:GetPos(), Ang = model:GetAngles() } end

	local ViewAngle = at.Ang + Angle( -10, 160, 0 )
	local ViewPos = at.Pos + ViewAngle:Forward() * -60 + ViewAngle:Up() * -2
	local view = {}

	view.fov		= 10
	view.origin		= ViewPos
	view.znear		= 0.1
	view.zfar		= 100
	view.angles		= ViewAngle

	return view

end

--
-- For some TF2 ragdolls which do not have "eye" attachments
--
local function RenderSpawnIcon_Ragdoll_Head( model, pos, middle, size )

	local at = model:GetAttachment( model:LookupAttachment( "head" ) )
	if ( !at ) then at = { Pos = model:GetPos(), Ang = model:GetAngles() } end

	local ViewAngle = at.Ang + Angle( -10, 160, 0 )
	local ViewPos = at.Pos + ViewAngle:Forward() * -67 + ViewAngle:Up() * -7 + ViewAngle:Right() * 1.5
	local view = {}

	view.fov		= 10
	view.origin		= ViewPos
	view.znear		= 0.1
	view.zfar		= 100
	view.angles		= ViewAngle

	return view

end

local function RenderSpawnIcon_Ragdoll_Facemask( model, pos, middle, size )

	local at = model:GetAttachment( model:LookupAttachment( "facemask" ) )
	if ( !at ) then at = { Pos = model:GetPos(), Ang = model:GetAngles() } end

	local ViewAngle = at.Ang
	ViewAngle:RotateAroundAxis( ViewAngle:Right(), -10 )
	ViewAngle:RotateAroundAxis( ViewAngle:Up(), 160 )
	local ViewPos = at.Pos + ViewAngle:Forward() * -67 + ViewAngle:Up() * -2 + ViewAngle:Right() * -1
	local view = {}

	view.fov		= 10
	view.origin		= ViewPos
	view.znear		= 0.1
	view.zfar		= 100
	view.angles		= ViewAngle

	return view

end

local function RenderSpawnIcon_Ragdoll_Forward( model, pos, middle, size )

	local at = model:GetAttachment( model:LookupAttachment( "forward" ) )
	if ( !at ) then at = { Pos = model:GetPos(), Ang = model:GetAngles() } end

	local ViewAngle = at.Ang + Angle( 10, -20, 0 )
	local ViewPos = at.Pos + ViewAngle:Forward() * -67 + ViewAngle:Up() * -1 + ViewAngle:Right() * 2.5
	local view = {}

	view.fov		= 10
	view.origin		= ViewPos
	view.znear		= 0.1
	view.zfar		= 100
	view.angles		= ViewAngle

	return view

end

local function RenderSpawnIcon_DOD( model, pos, middle, size )

	local ViewAngle = Angle( 0, 160, 0 )
	local ViewPos = pos + ViewAngle:Forward() * -67 + ViewAngle:Up() * 30 + ViewAngle:Right() * 2.5
	local view = {}

	view.fov		= 10
	view.origin		= ViewPos + middle
	view.znear		= 1
	view.zfar		= ViewPos:Distance( pos ) + size * 2
	view.angles		= ViewAngle

	return view

end

local function RenderSpawnIcon_CS( model, pos, middle, size )

	local ViewAngle = Angle( 0, 160, 0 )
	local ViewPos = pos + ViewAngle:Forward() * -70 + ViewAngle:Up() * 32.4 + ViewAngle:Right() * 1.5
	local view = {}

	view.fov		= 10
	view.origin		= ViewPos + middle
	view.znear		= 1
	view.zfar		= ViewPos:Distance( pos ) + size * 2
	view.angles		= ViewAngle

	return view

end

local function RenderSpawnIcon_Special( model, pos, middle, size, x, y, z )

	local ViewAngle = Angle( 15, 140, 0 )
	local ViewPos = pos + ViewAngle:Forward() * x + ViewAngle:Up() * y + ViewAngle:Right() * z
	local view = {}

	view.fov		= 20
	view.origin		= ViewPos + middle
	view.znear		= 1
	view.zfar		= ViewPos:Distance( pos ) + size * 2
	view.angles		= ViewAngle

	return view

end

SpawniconGenFunctions = {}

function PositionSpawnIcon( model, pos, noAngles )

	local mn, mx = model:GetRenderBounds()
	local middle = ( mn + mx ) * 0.5
	local size = 0
	size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
	size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
	size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )

	model:SetPos( pos )
	if ( !noAngles ) then model:SetAngles( angle_zero ) end

	local ModelName = model:GetModel()
	ModelName = string.Replace( ModelName, "--", "/" )
	ModelName = string.Replace( ModelName, "\\", "/" )
	ModelName = string.Replace( ModelName, "//", "/" )
	ModelName = string.Replace( ModelName, "\\\\", "/" )

	local fnc = SpawniconGenFunctions[ ModelName ]
	if ( fnc ) then return fnc( model, pos, middle, size ) end

	if ( model:LookupAttachment( "eyes" ) > 0 ) then
		return RenderSpawnIcon_Ragdoll( model, pos, middle, size )
	end

	if ( model:LookupAttachment( "head" ) > 0 ) then
		return RenderSpawnIcon_Ragdoll_Head( model, pos, middle, size )
	end

	-- CS:GO Player Models
	if ( model:LookupAttachment( "facemask" ) > 0 ) then
		return RenderSpawnIcon_Ragdoll_Facemask( model, pos, middle, size )
	end

	-- CS:GO Hostages
	if ( model:LookupAttachment( "forward" ) > 0 ) then
		return RenderSpawnIcon_Ragdoll_Forward( model, pos, middle, size )
	end

	return RenderSpawnIcon_Prop( model, pos, middle, size )

end

-- DOD Player Models
SpawniconGenFunctions[ "models/player/american_assault.mdl" ] = RenderSpawnIcon_DOD
SpawniconGenFunctions[ "models/player/american_mg.mdl" ] = RenderSpawnIcon_DOD
SpawniconGenFunctions[ "models/player/american_rifleman.mdl" ] = RenderSpawnIcon_DOD
SpawniconGenFunctions[ "models/player/american_rocket.mdl" ] = RenderSpawnIcon_DOD
SpawniconGenFunctions[ "models/player/american_sniper.mdl" ] = RenderSpawnIcon_DOD
SpawniconGenFunctions[ "models/player/american_support.mdl" ] = RenderSpawnIcon_DOD
SpawniconGenFunctions[ "models/player/german_assault.mdl" ] = RenderSpawnIcon_DOD
SpawniconGenFunctions[ "models/player/german_mg.mdl" ] = RenderSpawnIcon_DOD
SpawniconGenFunctions[ "models/player/german_rifleman.mdl" ] = RenderSpawnIcon_DOD
SpawniconGenFunctions[ "models/player/german_rocket.mdl" ] = RenderSpawnIcon_DOD
SpawniconGenFunctions[ "models/player/german_sniper.mdl" ] = RenderSpawnIcon_DOD
SpawniconGenFunctions[ "models/player/german_support.mdl" ] = RenderSpawnIcon_DOD

-- CS Player Models
SpawniconGenFunctions[ "models/player/ct_gign.mdl" ] = RenderSpawnIcon_CS
SpawniconGenFunctions[ "models/player/ct_sas.mdl" ] = RenderSpawnIcon_CS
SpawniconGenFunctions[ "models/player/ct_urban.mdl" ] = RenderSpawnIcon_CS
SpawniconGenFunctions[ "models/player/ct_gsg9.mdl" ] = RenderSpawnIcon_CS
SpawniconGenFunctions[ "models/player/t_leet.mdl" ] = RenderSpawnIcon_CS
SpawniconGenFunctions[ "models/player/t_phoenix.mdl" ] = RenderSpawnIcon_CS
SpawniconGenFunctions[ "models/player/t_arctic.mdl" ] = RenderSpawnIcon_CS
SpawniconGenFunctions[ "models/player/t_guerilla.mdl" ] = RenderSpawnIcon_CS

-- L4D Models
SpawniconGenFunctions[ "models/infected/witch.mdl" ] = function( a, b, c, d ) return RenderSpawnIcon_Special( a, b, c, d, -40, 25, 0 ) end
SpawniconGenFunctions[ "models/infected/smoker.mdl" ] = function( a, b, c, d ) return RenderSpawnIcon_Special( a, b, c, d, -60, 33, 10 ) end
SpawniconGenFunctions[ "models/infected/hunter.mdl" ] = function( a, b, c, d ) return RenderSpawnIcon_Special( a, b, c, d, -50, 26, 2 ) end
SpawniconGenFunctions[ "models/infected/hulk.mdl" ] = function( a, b, c, d ) return RenderSpawnIcon_Special( a, b, c, d, -70, 30, 11 ) end
SpawniconGenFunctions[ "models/infected/boomer.mdl" ] = function( a, b, c, d ) return RenderSpawnIcon_Special( a, b, c, d, -50, 27, 0 ) end

SpawniconGenFunctions[ "models/infected/common_female01.mdl" ] = function ( model, pos, middle, size )

	local at = model:GetAttachment( model:LookupAttachment( "forward" ) )
	if ( !at ) then at = { Pos = model:GetPos(), Ang = model:GetAngles() } end

	local ViewAngle = at.Ang + Angle( 180, 180, 0 ) + Angle( 10, -85, -85 )
	local ViewPos = at.Pos + ViewAngle:Forward() * -76 + ViewAngle:Up() * -1.5 + ViewAngle:Right() * 0
	return { fov = 10, origin = ViewPos, znear = 0.1, zfar = 200, angles = ViewAngle }

end

SpawniconGenFunctions[ "models/infected/common_female_nurse01.mdl" ] = SpawniconGenFunctions[ "models/infected/common_female01.mdl" ]
SpawniconGenFunctions[ "models/infected/common_female_rural01.mdl" ] = SpawniconGenFunctions[ "models/infected/common_female01.mdl" ]

SpawniconGenFunctions[ "models/infected/common_male01.mdl" ] = SpawniconGenFunctions[ "models/infected/common_female01.mdl" ]
SpawniconGenFunctions[ "models/infected/common_test.mdl" ] = SpawniconGenFunctions[ "models/infected/common_female01.mdl" ]
SpawniconGenFunctions[ "models/infected/common_morph_test.mdl" ] = SpawniconGenFunctions[ "models/infected/common_female01.mdl" ] // Bad start animation
SpawniconGenFunctions[ "models/infected/common_male_fallen_survivor.mdl" ] = SpawniconGenFunctions[ "models/infected/common_female01.mdl" ] // Bad start animation

SpawniconGenFunctions[ "models/infected/common_male_baggagehandler_01.mdl" ] = SpawniconGenFunctions[ "models/infected/common_male01.mdl" ]
SpawniconGenFunctions[ "models/infected/common_male_pilot.mdl" ] = SpawniconGenFunctions[ "models/infected/common_male01.mdl" ]
SpawniconGenFunctions[ "models/infected/common_male_rural01.mdl" ] = SpawniconGenFunctions[ "models/infected/common_male01.mdl" ]
SpawniconGenFunctions[ "models/infected/common_male_suit.mdl" ] = SpawniconGenFunctions[ "models/infected/common_male01.mdl" ]
SpawniconGenFunctions[ "models/infected/common_military_male01.mdl" ] = SpawniconGenFunctions[ "models/infected/common_male01.mdl" ]
SpawniconGenFunctions[ "models/infected/common_police_male01.mdl" ] = SpawniconGenFunctions[ "models/infected/common_male01.mdl" ]
SpawniconGenFunctions[ "models/infected/common_patient_male01.mdl" ] = SpawniconGenFunctions[ "models/infected/common_male01.mdl" ]
SpawniconGenFunctions[ "models/infected/common_surgeon_male01.mdl" ] = SpawniconGenFunctions[ "models/infected/common_male01.mdl" ] // Bad start animation
SpawniconGenFunctions[ "models/infected/common_tsaagent_male01.mdl" ] = SpawniconGenFunctions[ "models/infected/common_male01.mdl" ]
SpawniconGenFunctions[ "models/infected/common_worker_male01.mdl" ] = SpawniconGenFunctions[ "models/infected/common_male01.mdl" ]

-- ZPS Zombies
SpawniconGenFunctions[ "models/zombies/zombie0/zombie0.mdl" ] = function( a, b, c, d ) return RenderSpawnIcon_Special( a, b, c, d, -100, 17, 10 ) end
SpawniconGenFunctions[ "models/zombies/zombie1/zombie1.mdl" ] = function( a, b, c, d ) return RenderSpawnIcon_Special( a, b, c, d, -100, 17, 10 ) end
SpawniconGenFunctions[ "models/zombies/zombie2/zombie2.mdl" ] = function( a, b, c, d ) return RenderSpawnIcon_Special( a, b, c, d, -100, 17, 10 ) end
SpawniconGenFunctions[ "models/zombies/zombie3/zombie3.mdl" ] = function( a, b, c, d ) return RenderSpawnIcon_Special( a, b, c, d, -100, 17, 10 ) end
SpawniconGenFunctions[ "models/zombies/zombie4/zombie4.mdl" ] = function( a, b, c, d ) return RenderSpawnIcon_Special( a, b, c, d, -100, 17, 10 ) end
SpawniconGenFunctions[ "models/zombies/zombie5/zombie5.mdl" ] = function( a, b, c, d ) return RenderSpawnIcon_Special( a, b, c, d, -100, 17, 10 ) end

-- L4D2
SpawniconGenFunctions[ "models/infected/boomette.mdl" ] = function( a, b, c, d ) return RenderSpawnIcon_Special( a, b, c, d, -50, 28, 0 ) end
SpawniconGenFunctions[ "models/infected/charger.mdl" ] = function( a, b, c, d ) return RenderSpawnIcon_Special( a, b, c, d, -70, 14, 20 ) end
SpawniconGenFunctions[ "models/infected/jockey.mdl" ] = function( a, b, c, d ) return RenderSpawnIcon_Special( a, b, c, d, -50, 0, 7 ) end
SpawniconGenFunctions[ "models/infected/spitter.mdl" ] = function( a, b, c, d ) return RenderSpawnIcon_Special( a, b, c, d, -1, 0, -70 ) end // as good as deleted
SpawniconGenFunctions[ "models/infected/hulk_dlc3.mdl" ] = SpawniconGenFunctions[ "models/infected/hulk.mdl" ]
