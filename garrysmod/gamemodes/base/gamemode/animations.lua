local GetTable = FindMetaTable( "Entity" ).GetTable
local GetMoveType = FindMetaTable( "Entity" ).GetMoveType
local OnGround = FindMetaTable( "Entity" ).OnGround
local IsOnGround = FindMetaTable( "Entity" ).IsOnGround
local WaterLevel = FindMetaTable( "Entity" ).WaterLevel
local Length2DSqr = FindMetaTable( "Vector" ).Length2DSqr
local LengthSqr = FindMetaTable( "Vector" ).LengthSqr
local GetModel = FindMetaTable( "Entity" ).GetModel
local InVehicle = FindMetaTable( "Player" ).InVehicle
local IsFlagSet = FindMetaTable( "Entity" ).IsFlagSet
local CurTime = CurTime


function GM:HandlePlayerJumping( ply, velocity, plyTable )

	if ( !plyTable ) then plyTable = GetTable( ply ) end

	if ( GetMoveType( ply ) == MOVETYPE_NOCLIP ) then
		plyTable.m_bJumping = false
		return
	end

	-- airwalk more like hl2mp, we airwalk until we have 0 velocity, then it's the jump animation
	-- underwater we're alright we airwalking
	if ( !plyTable.m_bJumping && !OnGround( ply ) && WaterLevel( ply ) <= 0 ) then

		if ( !plyTable.m_fGroundTime ) then

			plyTable.m_fGroundTime = CurTime()

		elseif ( ( CurTime() - plyTable.m_fGroundTime ) > 0 && Length2DSqr( velocity ) < 0.25 ) then

			plyTable.m_bJumping = true
			plyTable.m_bFirstJumpFrame = false
			plyTable.m_flJumpStartTime = 0

		end
	end

	if ( plyTable.m_bJumping ) then

		if ( plyTable.m_bFirstJumpFrame ) then

			plyTable.m_bFirstJumpFrame = false
			ply:AnimRestartMainSequence()

		end

		if ( ( WaterLevel( ply ) >= 2 ) || ( ( CurTime() - plyTable.m_flJumpStartTime ) > 0.2 && OnGround( ply ) ) ) then

			plyTable.m_bJumping = false
			plyTable.m_fGroundTime = nil
			ply:AnimRestartMainSequence()

		end

		if ( plyTable.m_bJumping ) then
			plyTable.CalcIdeal = ACT_MP_JUMP
			return true
		end
	end

	return false

end

function GM:HandlePlayerDucking( ply, velocity, plyTable )

	if ( !plyTable ) then plyTable = GetTable( ply ) end

	if ( !IsFlagSet( ply, FL_ANIMDUCKING ) ) then return false end

	if ( Length2DSqr( velocity ) > 0.25 ) then
		plyTable.CalcIdeal = ACT_MP_CROUCHWALK
	else
		plyTable.CalcIdeal = ACT_MP_CROUCH_IDLE
	end

	return true

end

function GM:HandlePlayerNoClipping( ply, velocity, plyTable )

	if ( !plyTable ) then plyTable = GetTable( ply ) end

	if ( GetMoveType( ply ) != MOVETYPE_NOCLIP || InVehicle( ply ) ) then

		if ( plyTable.m_bWasNoclipping ) then

			plyTable.m_bWasNoclipping = nil
			ply:AnimResetGestureSlot( GESTURE_SLOT_CUSTOM )
			if ( CLIENT ) then ply:SetIK( true ) end

		end

		return

	end

	if ( !plyTable.m_bWasNoclipping ) then

		ply:AnimRestartGesture( GESTURE_SLOT_CUSTOM, ACT_GMOD_NOCLIP_LAYER, false )
		if ( CLIENT ) then ply:SetIK( false ) end

	end

	return true

end

function GM:HandlePlayerVaulting( ply, velocity, plyTable )

	if ( !plyTable ) then plyTable = GetTable( ply ) end

	if ( LengthSqr( velocity ) < 1000000 ) then return end
	if ( IsOnGround( ply ) ) then return end

	plyTable.CalcIdeal = ACT_MP_SWIM

	return true

end

function GM:HandlePlayerSwimming( ply, velocity, plyTable )

	if ( !plyTable ) then plyTable = GetTable( ply ) end

	if ( WaterLevel( ply ) < 2 || IsOnGround( ply ) ) then
		plyTable.m_bInSwim = false
		return false
	end

	plyTable.CalcIdeal = ACT_MP_SWIM
	plyTable.m_bInSwim = true

	return true

end

function GM:HandlePlayerLanding( ply, velocity, WasOnGround )

	if ( GetMoveType( ply ) == MOVETYPE_NOCLIP ) then return end

	if ( IsOnGround( ply ) && !WasOnGround ) then
		ply:AnimRestartGesture( GESTURE_SLOT_JUMP, ACT_LAND, true )
	end

end

local function cacheLookupSequence( ply, plyTable, seq )
	if ( !plyTable.m_SeqCache || ( plyTable.m_ModelSeq && plyTable.m_ModelSeq != GetModel( ply ) ) ) then
		plyTable.m_SeqCache = {}
		plyTable.m_ModelSeq = GetModel( ply )
	end

	if ( !plyTable.m_SeqCache[ seq ] ) then
		plyTable.m_SeqCache[ seq ] = ply:LookupSequence( seq )
	end

	return plyTable.m_SeqCache[ seq ]
end

function GM:HandlePlayerDriving( ply, plyTable )

	if ( !plyTable ) then plyTable = GetTable( ply ) end

	-- The player must have a parent to be in a vehicle. If there's no parent, we are in the exit anim, so don't do sitting in 3rd person anymore
	if ( !InVehicle( ply ) || !IsValid( ply:GetParent() ) ) then return false end

	local pVehicle = ply:GetVehicle()

	if ( !pVehicle.HandleAnimation && pVehicle.GetVehicleClass ) then
		local listEntr = list.GetEntry( "Vehicles", pVehicle:GetVehicleClass() )
		if ( listEntr && listEntr.Members && listEntr.Members.HandleAnimation ) then
			pVehicle.HandleAnimation = listEntr.Members.HandleAnimation
		else
			pVehicle.HandleAnimation = true -- Prevent this if block from trying to assign HandleAnimation again.
		end
	end

	if ( isfunction( pVehicle.HandleAnimation ) ) then
		local seq = pVehicle:HandleAnimation( ply )
		if ( seq != nil ) then
			plyTable.CalcSeqOverride = seq
		end
	end

	if ( plyTable.CalcSeqOverride == -1 ) then -- pVehicle.HandleAnimation did not give us an animation
		local class = pVehicle:GetClass()
		if ( class == "prop_vehicle_jeep" ) then
			plyTable.CalcSeqOverride = cacheLookupSequence( ply, plyTable, "drive_jeep" )
		elseif ( class == "prop_vehicle_airboat" ) then
			plyTable.CalcSeqOverride = cacheLookupSequence( ply, plyTable, "drive_airboat" )
		elseif ( class == "prop_vehicle_prisoner_pod" && GetModel( pVehicle ) == "models/vehicles/prisoner_pod_inner.mdl" ) then
			-- HACK!!
			plyTable.CalcSeqOverride = cacheLookupSequence( ply, plyTable, "drive_pd" )
		else
			plyTable.CalcSeqOverride = cacheLookupSequence( ply, plyTable, "sit_rollercoaster" )
		end
	end

	local use_anims = ( plyTable.CalcSeqOverride == cacheLookupSequence( ply, plyTable, "sit_rollercoaster" ) || plyTable.CalcSeqOverride == cacheLookupSequence( ply, plyTable, "sit" ) )
	local wep = ply:GetActiveWeapon()
	if ( use_anims && ply:GetAllowWeaponsInVehicle() && IsValid( wep ) ) then
		local holdtype = wep:GetHoldType()
		if ( holdtype == "smg" ) then holdtype = "smg1" end

		local seqid = cacheLookupSequence( ply, plyTable, "sit_" .. holdtype )
		if ( seqid != -1 ) then
			plyTable.CalcSeqOverride = seqid
		end
	end

	return true

end

--[[---------------------------------------------------------
   Name: gamemode:UpdateAnimation()
   Desc: Animation updates (pose params etc) should be done here
-----------------------------------------------------------]]
local VectorUp = Vector( 0, 0, 1 )
function GM:UpdateAnimation( ply, velocity, maxseqgroundspeed )

	local lenSqr = LengthSqr( velocity )
	local movement = 1.0

	if ( lenSqr > 0.04 ) then
		movement = ( math.sqrt( lenSqr ) / maxseqgroundspeed )
	end

	local rate = math.min( movement, 2 )

	-- if we're under water we want to constantly be swimming..
	if ( WaterLevel( ply ) >= 2 ) then
		rate = math.max( rate, 0.5 )
	elseif ( !IsOnGround( ply ) && lenSqr >= 1000000 ) then
		rate = 0.1
	end

	ply:SetPlaybackRate( rate )

	if ( InVehicle( ply ) ) then
		--
		-- This is used for the 'rollercoaster' arms
		--
		local Vehicle = ply:GetVehicle()
		local Velocity = Vehicle:GetVelocity()
		local fwd = Vehicle:GetUp()
		local dp = fwd:Dot( VectorUp )
		local class = Vehicle:GetClass()
		ply:SetPoseParameter( "vertical_velocity", ( dp < 0 && dp || 0 ) + fwd:Dot( Velocity ) * 0.005 )

		-- Pass the vehicles steer param down to the player
		-- No steering in seats (when overridden to use jeep animations)
		-- So that it doesn't stick to random value it had before
		local steer = class == "prop_vehicle_prisoner_pod" && 0
					|| Vehicle:GetPoseParameter( "vehicle_steer" )

		if ( class == "prop_vehicle_prisoner_pod" ) then
			-- Fix weapon aiming poseparam in vehicle
			ply:SetPoseParameter( "aim_yaw", math.NormalizeAngle( ply:GetAimVector():Angle().y - Vehicle:GetAngles().y - 90 ) )
		end

		-- Gotta convert from 0..1 (network range) to -1..1 (pose param range) on client
		if ( CLIENT ) then steer = steer * 2 - 1 end
		ply:SetPoseParameter( "vehicle_steer", steer )

	end

	GAMEMODE:GrabEarAnimation( ply )

	-- We only need to do this clientside..
	if ( CLIENT ) then
		GAMEMODE:MouthMoveAnimation( ply )
	end

end

--
-- If you don't want the player to grab his ear in your gamemode then
-- just override this.
--
function GM:GrabEarAnimation( ply, plyTable )

	if ( !plyTable ) then plyTable = GetTable( ply ) end

	plyTable.ChatGestureWeight = plyTable.ChatGestureWeight || 0

	-- Don't show this when we're playing a taunt!
	if ( ply:IsPlayingTaunt() ) then return end

	if ( ply:IsTyping() ) then
		plyTable.ChatGestureWeight = math.Approach( plyTable.ChatGestureWeight, 1, FrameTime() * 5.0 )
	else
		plyTable.ChatGestureWeight = math.Approach( plyTable.ChatGestureWeight, 0, FrameTime() * 5.0 )
	end

	if ( plyTable.ChatGestureWeight > 0 ) then

		ply:AnimRestartGesture( GESTURE_SLOT_VCD, ACT_GMOD_IN_CHAT, true )
		ply:AnimSetGestureWeight( GESTURE_SLOT_VCD, plyTable.ChatGestureWeight )

	end

end

--
-- Moves the mouth when talking on voicecom
--
function GM:MouthMoveAnimation( ply )

	if ( !ply.m_MouthFlex || ply.m_MouthModelCache != GetModel( ply ) ) then
		ply.m_MouthFlex = {
			ply:GetFlexIDByName( "jaw_drop" ),
			ply:GetFlexIDByName( "left_part" ),
			ply:GetFlexIDByName( "right_part" ),
			ply:GetFlexIDByName( "left_mouth_drop" ),
			ply:GetFlexIDByName( "right_mouth_drop" )
		}

		ply.m_MouthModelCache = GetModel( ply )
	end

	-- If the model has no flex, there is no point in executing the rest.
	if ( #ply.m_MouthFlex == 0 ) then return end

	-- Experimental: Multiplying by 4 seems preferable to multiplying by 2, so that the mouth opens properly and a real difference is visible while remaining realistic.
	local weight = ply:IsSpeaking() && math.Clamp( ply:VoiceVolume() * 4, 0, 2 ) || 0

	if ( !ply.m_FlexWeight || ply.m_FlexWeight != weight ) then
		ply.m_FlexWeight = weight
		for k, v in ipairs( ply.m_MouthFlex ) do

			ply:SetFlexWeight( v, weight )

		end
	end

end

function GM:CalcMainActivity( ply, velocity )

	local plyTable = GetTable( ply )
	plyTable.CalcIdeal = ACT_MP_STAND_IDLE
	plyTable.CalcSeqOverride = -1

	self:HandlePlayerLanding( ply, velocity, plyTable.m_bWasOnGround )

	if !( self:HandlePlayerNoClipping( ply, velocity, plyTable ) ||
		self:HandlePlayerDriving( ply, plyTable ) ||
		self:HandlePlayerVaulting( ply, velocity, plyTable ) ||
		self:HandlePlayerJumping( ply, velocity, plyTable ) ||
		self:HandlePlayerSwimming( ply, velocity, plyTable ) ||
		self:HandlePlayerDucking( ply, velocity, plyTable ) ) then

		local len2d = Length2DSqr( velocity )
		if ( len2d > 22500 ) then plyTable.CalcIdeal = ACT_MP_RUN elseif ( len2d > 0.25 ) then plyTable.CalcIdeal = ACT_MP_WALK end

	end

	plyTable.m_bWasOnGround = IsOnGround( ply )
	plyTable.m_bWasNoclipping = ( GetMoveType( ply ) == MOVETYPE_NOCLIP && !InVehicle( ply ) )

	return plyTable.CalcIdeal, plyTable.CalcSeqOverride

end

local IdleActivity = ACT_HL2MP_IDLE
local IdleActivityTranslate = {}
IdleActivityTranslate[ ACT_MP_STAND_IDLE ]					= IdleActivity
IdleActivityTranslate[ ACT_MP_WALK ]						= IdleActivity + 1
IdleActivityTranslate[ ACT_MP_RUN ]							= IdleActivity + 2
IdleActivityTranslate[ ACT_MP_CROUCH_IDLE ]					= IdleActivity + 3
IdleActivityTranslate[ ACT_MP_CROUCHWALK ]					= IdleActivity + 4
IdleActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]	= IdleActivity + 5
IdleActivityTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= IdleActivity + 5
IdleActivityTranslate[ ACT_MP_RELOAD_STAND ]				= IdleActivity + 6
IdleActivityTranslate[ ACT_MP_RELOAD_CROUCH ]				= IdleActivity + 6
IdleActivityTranslate[ ACT_MP_JUMP ]						= ACT_HL2MP_JUMP_SLAM
IdleActivityTranslate[ ACT_MP_SWIM ]						= IdleActivity + 9
IdleActivityTranslate[ ACT_LAND ]							= ACT_LAND

-- it is preferred you return ACT_MP_* in CalcMainActivity, and if you have a specific need to not translate through the weapon do it here
function GM:TranslateActivity( ply, act )

	local newact = ply:TranslateWeaponActivity( act )

	-- select idle anims if the weapon didn't decide
	if ( act == newact ) then
		return IdleActivityTranslate[ act ]
	end

	return newact

end

function GM:DoAnimationEvent( ply, event, data )

	if ( event == PLAYERANIMEVENT_ATTACK_PRIMARY ) then

		if IsFlagSet( ply, FL_ANIMDUCKING ) then
			ply:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_ATTACK_CROUCH_PRIMARYFIRE, true )
		else
			ply:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_ATTACK_STAND_PRIMARYFIRE, true )
		end

		return ACT_VM_PRIMARYATTACK

	elseif ( event == PLAYERANIMEVENT_ATTACK_SECONDARY ) then

		-- there is no gesture, so just fire off the VM event
		return ACT_VM_SECONDARYATTACK

	elseif ( event == PLAYERANIMEVENT_RELOAD ) then

		if IsFlagSet( ply, FL_ANIMDUCKING ) then
			ply:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_RELOAD_CROUCH, true )
		else
			ply:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_RELOAD_STAND, true )
		end

		return ACT_INVALID

	elseif ( event == PLAYERANIMEVENT_JUMP ) then

		ply.m_bJumping = true
		ply.m_bFirstJumpFrame = true
		ply.m_flJumpStartTime = CurTime()

		ply:AnimRestartMainSequence()

		return ACT_INVALID

	elseif ( event == PLAYERANIMEVENT_CANCEL_RELOAD ) then

		ply:AnimResetGestureSlot( GESTURE_SLOT_ATTACK_AND_RELOAD )

		return ACT_INVALID
	end

end
