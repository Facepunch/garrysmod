-- FIXME: https://github.com/Facepunch/garrysmod-issues/issues/3075
ACT_HL2MP_SIT_MELEE2 = 2016
ACT_HL2MP_SIT_KNIFE = 2017
ACT_HL2MP_IDLE_COWER = 2056
ACT_HL2MP_SIT_CAMERA = 2058
ACT_HL2MP_SIT_DUEL = 2059
ACT_HL2MP_SIT_PASSIVE = 2060
ACT_GMOD_DEATH = 2061
ACT_GMOD_SHOWOFF_STAND_01 = 2062
ACT_GMOD_SHOWOFF_STAND_02 = 2063
ACT_GMOD_SHOWOFF_STAND_03 = 2064
ACT_GMOD_SHOWOFF_STAND_04 = 2065
ACT_GMOD_SHOWOFF_DUCK_01 = 2066
ACT_GMOD_SHOWOFF_DUCK_02 = 2067
ACT_FLINCH = 2068
ACT_FLINCH_BACK = 2069
ACT_FLINCH_SHOULDER_LEFT = 2070
ACT_FLINCH_SHOULDER_RIGHT = 2071
ACT_DRIVE_POD = 2072
ACT_HL2MP_ZOMBIE_SLUMP_ALT_IDLE = 2073
ACT_HL2MP_ZOMBIE_SLUMP_ALT_RISE_FAST = 2074
ACT_HL2MP_ZOMBIE_SLUMP_ALT_RISE_SLOW = 2075
LAST_SHARED_ACTIVITY = 2076

local math_min = math.min
local list_Get = list.Get
local FrameTime = FrameTime
local math_sqrt = math.sqrt
local hook_Call = hook.Call
local isfunction = isfunction
local math_Clamp = math.Clamp
local math_Approach = math.Approach
local math_Truncate = math.Truncate

function GM:ToggleNoClipAnim( ply, noclip )
	-- Reset the layer
	if ( noclip ) then
		ply:AnimRestartGesture( GESTURE_SLOT_CUSTOM, ACT_GMOD_NOCLIP_LAYER, true )
	else
		ply:AnimResetGestureSlot( GESTURE_SLOT_CUSTOM )

		if ( !ply:OnGround() ) then
			-- Don't airwalk out of noclip
			ply.m_bJumping = true
		end
	end

	if ( CLIENT ) then
		ply:SetIK( noclip )
	end
end

local SeatActivities = {
	prop_vehicle_jeep = ACT_DRIVE_JEEP,
	prop_vehicle_airboat = ACT_DRIVE_AIRBOAT,
	prop_vehicle_prisoner_pod = ACT_DRIVE_POD
}

function GM:HandlePlayerDriving( ply )
	local vehicle = ply:GetVehicle()

	if ( !vehicle:IsValid() ) then
		return false
	end

	local fHandleAnimation = vehicle.HandleAnimation
	local usefunc = true

	if ( fHandleAnimation == nil ) then
		local t = list_Get( "Vehicles" )[ vehicle:GetVehicleClass() ]

		if ( t == nil ) then
			-- Prevent this if block from trying to assign HandleAnimation again
			vehicle.HandleAnimation = false
		else
			local members = t.Members

			if ( members == nil ) then
				vehicle.HandleAnimation = false
				usefunc = false
			else
				fHandleAnimation = members.HandleAnimation
				vehicle.HandleAnimation = fHandleAnimation
				usefunc = isfunction( fHandleAnimation )
			end
		end

	else
		usefunc = isfunction( fHandleAnimation )
	end

	if ( usefunc ) then
		local seq, act = fHandleAnimation( vehicle, ply )

		-- vehicle.HandleAnimation gave us a specific sequence
		if ( seq != nil && seq > -1 ) then
			ply.CalcSeqOverride = seq
			ply.CalcIdeal = act != nil && act > ACT_INVALID && act || ply:GetSequenceActivity( seq )
		else
			-- If an activity wasn't provided, fallback to default activities based on vehicle class
			ply.CalcIdeal = act != nil && act > ACT_INVALID && act || SeatActivities[ vehicle:GetClass() ] || ACT_BUSY_SIT_CHAIR
		end
	else
		ply.CalcIdeal = SeatActivities[ vehicle:GetClass() ] || ACT_BUSY_SIT_CHAIR
	end

	ply.m_bInSwim = false
	ply.m_bJumping = false

	return true
end

function GM:HandlePlayerNoClipping( ply, velocity )
	if ( ply:GetMoveType() == MOVETYPE_NOCLIP && !ply:InVehicle() ) then
		ply.m_bInSwim = false
		ply.m_bJumping = false

		return true
	end

	return false
end

function GM:HandlePlayerLanding( ply, velocity, wasonground, onground )
	if ( onground && !wasonground ) then
		ply:AnimRestartGesture( GESTURE_SLOT_JUMP, ACT_LAND, true )

		return true
	end

	return false
end

function GM:HandlePlayerSwimming( ply, velocity, onground )
	if ( !onground && ply:WaterLevel() >= 2 ) then
		ply.CalcIdeal = velocity:Length2DSqr() > 0.25 && ACT_MP_SWIM || ACT_MP_SWIM_IDLE

		ply.m_bInSwim = true
		ply.m_bJumping = false

		-- If this isn't done, the player is stuck in an unlooping walk activity
		if ( ply.m_bWasOnGround ) then
			ply:AnimRestartMainSequence()
		end

		return true
	end

	return false
end

function GM:HandlePlayerVaulting( ply, velocity, onground )
	if ( !onground && velocity:LengthSqr() >= 1000000 ) then
		ply.CalcIdeal = ACT_MP_SWIM

		ply.m_bInSwim = true
		ply.m_bJumping = true

		return true
	end

	return false
end

function GM:HandlePlayerAirWalking( ply, velocity, onground )
	-- Airwalk more like HL2MP, we airwalk until we have 0.25 velocity, then it's the jump animation
	if ( !( onground || ply.m_bJumping ) ) then
		local len2d = velocity:Length2DSqr()
		ply.m_bInSwim = false

		if ( len2d > 0.25 ) then
			ply.CalcIdeal = ply:IsFlagSet( FL_ANIMDUCKING ) && ACT_MP_CROUCHWALK || len2d > 22500 && ACT_MP_RUN || ACT_MP_WALK --ACT_MP_AIRWALK

			ply.m_bJumping = false

			return true
		end

		ply.m_bJumping = true
	end

	return false
end

function GM:HandlePlayerJumping( ply, velocity, onground )
	if ( !onground ) then
		ply.CalcIdeal = ACT_MP_JUMP

		ply.m_bInSwim = false
		ply.m_bJumping = true

		return true
	end

	return false
end

function GM:HandlePlayerDucking( ply, velocity, onground )
	if ( ply:IsFlagSet( FL_ANIMDUCKING ) ) then
		ply.CalcIdeal = velocity:Length2DSqr() > 0.25 && ACT_MP_CROUCHWALK || ACT_MP_CROUCH_IDLE

		ply.m_bInSwim = false
		ply.m_bJumping = false

		return true
	end

	return false
end

function GM:HandlePlayerMoving( ply, velocity )
	local len2d = velocity:Length2DSqr()

	if ( ply.m_bInSwim ) then
		ply:AnimRestartMainSequence()
	end

	ply.m_bInSwim = false
	ply.m_bJumping = false

	if ( len2d > 0.25 ) then
		ply.CalcIdeal = len2d > 22500 && ACT_MP_RUN || ACT_MP_WALK

		return true
	end

	return false
end

function GM:CalcMainActivity( ply, velocity )
	ply.CalcIdeal = ACT_MP_STAND_IDLE
	ply.CalcSeqOverride = -1

	local vehicle = self:HandlePlayerDriving( ply )

	if ( vehicle ) then
		if ( ply.m_bWasNoclipping ) then
			ply.m_bWasNoclipping = false
			hook_Call( "ToggleNoClipAnim", self, ply, false )
		end

		ply.m_bWasOnGround = false
	else
		local noclip = self:HandlePlayerNoClipping( ply, velocity )
		local onground = false

		if ( noclip != ply.m_bWasNoclipping ) then
			ply.m_bWasNoclipping = noclip
			hook_Call( "ToggleNoClipAnim", self, ply, noclip )
		elseif ( !noclip ) then
			onground = ply:OnGround()

			if ( ( self:HandlePlayerLanding( ply, velocity, ply.m_bWasOnGround, onground ) ||
				!( self:HandlePlayerSwimming( ply, velocity, onground ) ||
				self:HandlePlayerVaulting( ply, velocity, onground ) ||
				self:HandlePlayerAirWalking( ply, velocity, onground ) ||
				self:HandlePlayerJumping( ply, velocity, onground ) ) ) &&
				!self:HandlePlayerDucking( ply, velocity ) ) then
				self:HandlePlayerMoving( ply, velocity )
			end
		end

		ply.m_bWasOnGround = onground
	end

	-- All of the above operations should still be done regardless of the custom sequence
	-- to keep condition variables and layers updated
	local customact = ply.m_nSpecificMainActivity
	local customseq = ply.m_nSpecificMainSequence

	if ( customact == nil ) then
		ply.m_nSpecificMainActivity = ACT_INVALID

		if ( customseq == nil ) then
			ply.m_nSpecificMainSequence = -1
		elseif ( customseq > -1 ) then
			return ACT_INVALID, customseq
		end
	elseif ( customseq == nil ) then
		ply.m_nSpecificMainSequence = -1

		if ( customact > ACT_INVALID ) then
			return customact, -1
		end
	elseif ( customact > ACT_INVALID || customseq > -1 ) then
		-- FIXME: https://github.com/Facepunch/garrysmod-requests/issues/704
		if ( ply:GetCycle() < 1 ) then
			return customact, customseq
		end

		ply.m_nSpecificMainActivity = -1
		ply.m_nSpecificMainSequence = -1
	end

	return ply.CalcIdeal, ply.CalcSeqOverride
end

function GM:CalcPlaybackRate( ply, velocity, maxseqgroundspeed )
	-- If we're under water we want to constantly be swimming..
	if ( ply:WaterLevel() >= 2 ) then
		return math_Clamp( velocity:Length() / maxseqgroundspeed, 0.5, 2 )
	end

	-- Slow swim while vaulting
	if ( ply.m_bInSwim && ply.m_bJumping ) then
		return 0.1
	end

	local len = velocity:LengthSqr()

	if ( len > 0.04 ) then
		-- Scale walking/running animations by current speed
		return math_min( math_sqrt( len ) / maxseqgroundspeed, 2 )
	end

	return 1
end

function GM:UpdateAnimation( ply, velocity, maxseqgroundspeed )
	ply:SetPlaybackRate( hook_Call( "CalcPlaybackRate", self, ply, velocity, maxseqgroundspeed ) || 1 )

	if ( CLIENT ) then
		local vehicle = ply:GetVehicle()

		if ( vehicle:IsValid() ) then
			-- This is used for the 'rollercoaster' arms
			local fwd = vehicle:GetUp()
			local dp = math_min( fwd:Dot( vector_up ), 0 )
			local dp2 = fwd:Dot( vehicle:GetAbsVelocity() ) -- Actually equates to CBaseEntity::GetLocalVelocity

			local fSetPoseParameter = ply.SetPoseParameter
			fSetPoseParameter( ply, "vertical_velocity", ( dp < 0 && dp || 0 ) + dp2 * 0.005 )

			-- Pass the vehicles steer param down to the player
			if ( vehicle:GetClass() == "prop_vehicle_prisoner_pod" ) then
				-- Normalise the angle and rotate it -90 degrees
				fSetPoseParameter( ply, "aim_yaw", ( ply:GetAimVector():Angle().y - vehicle:GetAngles().y + 90 ) % 360 - 180 )
				fSetPoseParameter( ply, "vehicle_steer", 0 )
			else
				fSetPoseParameter( ply, "vehicle_steer", vehicle:GetPoseParameter( "vehicle_steer" ) * 2 - 1 ) -- convert from 0..1 to -1..1
			end
		end

		self:MouthMoveAnimation( ply )
	end

	self:GrabEarAnimation( ply )
end

local DefaultAnims = {
	[ ACT_LAND ]			= ACT_LAND,
	[ ACT_BUSY_SIT_GROUND ]	= ACT_HL2MP_SIT,
	[ ACT_BUSY_SIT_CHAIR ]	= ACT_HL2MP_SIT,
	[ ACT_MP_STAND_IDLE ]	= ACT_HL2MP_IDLE,
	[ ACT_MP_CROUCH_IDLE ]	= ACT_HL2MP_IDLE_CROUCH,
	[ ACT_MP_RUN ]			= ACT_HL2MP_RUN,
	[ ACT_MP_WALK ]			= ACT_HL2MP_WALK,
	--[ ACT_MP_AIRWALK ]		= ACT_HL2MP_WALK,
	[ ACT_MP_CROUCHWALK ]	= ACT_HL2MP_WALK_CROUCH,
	[ ACT_MP_SPRINT ]		= ACT_HL2MP_RUN,
	[ ACT_MP_JUMP ]			= ACT_HL2MP_JUMP_SLAM, -- ACT_HL2MP_JUMP isn't in m_anm
	[ ACT_MP_SWIM ]			= ACT_HL2MP_SWIM,
	[ ACT_MP_SWIM_IDLE ]	= ACT_HL2MP_SWIM_IDLE
}

-- It is preferred you return ACT_MP_* in CalcMainActivity, and if you have a specific need to not tranlsate through the weapon do it here
function GM:TranslateActivity( ply, act )
	local newact = ply:TranslateWeaponActivity( act )

	-- Select idle anims if the weapon didn't decide
	return newact != act && newact > -1 && newact || DefaultAnims[ act ]
end

local GestureTranslations = {}

local function RegisterStateActivity( stand, crouch, swim, airwalk, translatedact )
	local translation = { stand, crouch, swim }
	GestureTranslations[ stand ] = translation
	GestureTranslations[ crouch ] = translation
	GestureTranslations[ swim ] = translation

	-- Airwalking is just a layer for walking/running in the air
	-- in GMod and HL2:DM and thus unique anims aren't used
	-- but the airwalk enums still translate to the proper alternatives
	GestureTranslations[ airwalk ] = translation

	if ( translatedact != nil ) then
		DefaultAnims[ stand ] = translatedact
		DefaultAnims[ crouch ] = translatedact
		DefaultAnims[ swim ] = translatedact
		DefaultAnims[ airwalk ] = translatedact
	end
end

RegisterStateActivity( ACT_MP_ATTACK_STAND_PRIMARYFIRE, ACT_MP_ATTACK_CROUCH_PRIMARYFIRE, ACT_MP_ATTACK_SWIM_PRIMARYFIRE, ACT_MP_ATTACK_AIRWALK_PRIMARYFIRE, ACT_HL2MP_GESTURE_RANGE_ATTACK )
RegisterStateActivity( ACT_MP_ATTACK_STAND_SECONDARYFIRE, ACT_MP_ATTACK_CROUCH_SECONDARYFIRE, ACT_MP_ATTACK_SWIM_SECONDARYFIRE, ACT_MP_ATTACK_AIRWALK_SECONDARYFIRE, ACT_HL2MP_GESTURE_RANGE_ATTACK )
RegisterStateActivity( ACT_MP_ATTACK_STAND_GRENADE, ACT_MP_ATTACK_CROUCH_GRENADE, ACT_MP_ATTACK_SWIM_GRENADE, ACT_MP_ATTACK_AIRWALK_GRENADE, ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE )
RegisterStateActivity( ACT_MP_RELOAD_STAND, ACT_MP_RELOAD_CROUCH, ACT_MP_RELOAD_SWIM, ACT_MP_RELOAD_AIRWALK, ACT_HL2MP_GESTURE_RELOAD )

-- These aren't used in the default player anims but should still be translated by player state
RegisterStateActivity( ACT_MP_RELOAD_STAND_LOOP, ACT_MP_RELOAD_CROUCH_LOOP, ACT_MP_RELOAD_SWIM_LOOP, ACT_MP_RELOAD_AIRWALK_LOOP )
RegisterStateActivity( ACT_MP_RELOAD_STAND_END, ACT_MP_RELOAD_CROUCH_END, ACT_MP_RELOAD_SWIM_END, ACT_MP_RELOAD_AIRWALK_END )

local function GetEventActivity( ply, event )
	local translation = GestureTranslations[ event ]

	if ( translation == nil ) then
		return event
	end

	return translation[ ply.m_bInSwim && 3 || ply:IsFlagSet( FL_ANIMDUCKING ) && 2 || 1 ]
end

local FlinchAnims = {
	[ ACT_MP_GESTURE_FLINCH_CHEST ] = true,
	[ ACT_MP_GESTURE_FLINCH_HEAD ] = true,
	[ ACT_MP_GESTURE_FLINCH_LEFTARM ] = true,
	[ ACT_MP_GESTURE_FLINCH_RIGHTARM ] = true,
	[ ACT_MP_GESTURE_FLINCH_LEFTLEG ] = true,
	[ ACT_MP_GESTURE_FLINCH_RIGHTLEG ] = true
}

function GM:DoAnimationEvent( ply, event, data )
	if ( event == PLAYERANIMEVENT_ATTACK_PRIMARY ) then
		ply:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, GetEventActivity( ply, ACT_MP_ATTACK_STAND_PRIMARYFIRE ), true )
	elseif ( event == PLAYERANIMEVENT_ATTACK_SECONDARY ) then
		ply:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, GetEventActivity( ply, ACT_MP_ATTACK_STAND_SECONDARYFIRE ), true )
	elseif ( event == PLAYERANIMEVENT_ATTACK_GRENADE ) then
		ply:AnimRestartGesture( GESTURE_SLOT_GRENADE, GetEventActivity( ply, ACT_MP_ATTACK_STAND_GRENADE ), true )
	elseif ( event == PLAYERANIMEVENT_RELOAD ) then
		ply:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, GetEventActivity( ply, ACT_MP_RELOAD_STAND ), true )
	elseif ( event == PLAYERANIMEVENT_RELOAD_LOOP ) then
		ply:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, GetEventActivity( ply, ACT_MP_RELOAD_STAND_LOOP ), true )
	elseif ( event == PLAYERANIMEVENT_RELOAD_END ) then
		ply:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, GetEventActivity( ply, ACT_MP_RELOAD_STAND_END ), true )
	elseif ( event == PLAYERANIMEVENT_JUMP || event == PLAYERANIMEVENT_DOUBLEJUMP ) then
		ply.m_bJumping = true
		ply:AnimResetGestureSlot( GESTURE_SLOT_JUMP )
		ply:AnimRestartMainSequence()
	elseif ( event == PLAYERANIMEVENT_SWIM ) then
		ply.m_bInSwim = true
		ply:AnimResetGestureSlot( GESTURE_SLOT_SWIM )
		ply:AnimRestartMainSequence()
	elseif ( event == PLAYERANIMEVENT_DIE ) then
		ply.m_nSpecificMainActivity = ACT_INVALID
		ply.m_nSpecificMainSequence = -1

		ply:AnimRestartMainSequence()
	elseif ( FlinchAnims[ event ] ) then
		-- FIXME: https://github.com/Facepunch/garrysmod-requests/issues/1090
		ply:AnimRestartGesture( GESTURE_SLOT_FLINCH, event, true )
	elseif ( event == PLAYERANIMEVENT_CANCEL ) then
		ply.m_nSpecificMainActivity = ACT_INVALID
		ply.m_nSpecificMainSequence = -1
	elseif ( event == PLAYERANIMEVENT_SPAWN ) then
		ply.m_nSpecificMainActivity = ACT_INVALID
		ply.m_nSpecificMainSequence = -1
		ply.m_bWasOnGround = ply:OnGround()
		ply.m_bInSwim = false
		ply.m_bJumping = false

		ply:AnimResetGestureSlots()
	-- Can't set m_PoseParameterData.m_flLastAimTurnTime from Lua
	--elseif ( event == PLAYERANIMEVENT_SNAP_YAW ) then
	elseif ( event == PLAYERANIMEVENT_CUSTOM ) then
		data = math_Truncate( data )

		if ( data > ACT_INVALID ) then
			local act = hook_Call( "TranslateActivity", self, ply, data )

			if ( act == nil ) then
				act = data
			else
				act = math_Truncate( act )
			end

			if ( act > ACT_INVALID ) then
				ply.m_nSpecificMainActivity = act
				ply.m_nSpecificMainSequence = -1
				ply:AnimRestartMainSequence()
			end
		end
	elseif ( event == PLAYERANIMEVENT_CUSTOM_GESTURE ) then
		ply:AnimRestartGesture( GESTURE_SLOT_CUSTOM, data, true )
	elseif ( event == PLAYERANIMEVENT_CUSTOM_SEQUENCE ) then
		data = math_Truncate( data )

		if ( data >= 0 ) then
			ply.m_nSpecificMainActivity = ply:GetSequenceActivity( data )
			ply.m_nSpecificMainSequence = data
			ply:AnimRestartMainSequence()
		end
	elseif ( event == PLAYERANIMEVENT_CUSTOM_GESTURE_SEQUENCE ) then
		ply:AddVCDSequenceToGestureSlot( GESTURE_SLOT_CUSTOM, data, 0, true )
	elseif ( event == PLAYERANIMEVENT_CANCEL_RELOAD ) then
		ply:AnimResetGestureSlot( GESTURE_SLOT_ATTACK_AND_RELOAD )
	end

	return ACT_INVALID
end

-- If you don't want the player to grab his ear in your gamemode then just override this
function GM:GrabEarAnimation( ply )
	-- Don't show this when we're playing a taunt!
	if ( ply:IsPlayingTaunt() ) then return end

	local weight = ply.ChatGestureWeight || 0

	if ( weight == 0 ) then
		if ( !ply:IsTyping() ) then
			-- No slot work has to be done if no animation is in progress
			return
		end

		weight = math_Approach( 0, 1, FrameTime() * 5 )
		ply.ChatGestureWeight = weight
	elseif ( weight == 1 ) then
		if ( !ply:IsTyping() ) then
			weight = math_Approach( 1, 0, FrameTime() * 5 )
			ply.ChatGestureWeight = weight
		end
	else
		weight = math_Approach( weight, ply:IsTyping() && 1 || 0, FrameTime() * 5 )
		ply.ChatGestureWeight = weight
	end

	ply:AnimRestartGesture( GESTURE_SLOT_VCD, ACT_GMOD_IN_CHAT, true )
	ply:AnimSetGestureWeight( GESTURE_SLOT_VCD, weight )
end

-- Clientside only
if ( SERVER ) then return end

-- Skip a loop by calling SetFlexWeight for each flex manually
-- Localise player functions to save on __index calls
local function UpdateMouthFlexes( ply, weight )
	local fSetFlexWeight = ply.SetFlexWeight
	local fGetFlexIDByName = ply.GetFlexIDByName
	fSetFlexWeight( ply, fGetFlexIDByName( ply, "jaw_drop" ), weight )
	fSetFlexWeight( ply, fGetFlexIDByName( ply, "left_part" ), weight )
	fSetFlexWeight( ply, fGetFlexIDByName( ply, "right_part" ), weight )
	fSetFlexWeight( ply, fGetFlexIDByName( ply, "left_mouth_drop" ), weight )
	fSetFlexWeight( ply, fGetFlexIDByName( ply, "right_mouth_drop" ), weight )
end

-- Moves the mouth when talking on voicecom
function GM:MouthMoveAnimation( ply )
	if ( ply:IsSpeaking() ) then
		ply.m_bSpeaking = true
		UpdateMouthFlexes( ply, math_Clamp( ply:VoiceVolume() * 2, 0, 2 ) )
	elseif ( ply.m_bSpeaking ) then
		ply.m_bSpeaking = false
		UpdateMouthFlexes( ply, 0 )
	end
end
