
-- This weird stuff speeds up the expensive animation calculations by about half!

-- entity.GetTable is only performed once per function rather than each time a field is indexed on a player

-- Also, most functions are called directly rather than being looked up in metatable

-- github.com/jackson-c

local playertable = FindMetaTable( "Player" )
local entity = FindMetaTable( "Entity" )

local A_GetMoveType = entity.GetMoveType
local A_GetTable = entity.GetTable
local A_LookupSequence = entity.LookupSequence
local A_OnGround = entity.OnGround
local A_WaterLevel = entity.WaterLevel
local A_AnimResetGestureSlot = playertable.AnimResetGestureSlot
local A_AnimRestartGesture = playertable.AnimRestartGesture
local A_AnimRestartMainSequence = playertable.AnimRestartMainSequence
local A_Crouching = playertable.Crouching
local A_GetAllowWeaponsInVehicle = playertable.GetAllowWeaponsInVehicle
local A_GetVehicle = playertable.GetVehicle
local A_InVehicle = playertable.InVehicle

function GM:HandlePlayerJumping( ply, velocity )
	local pt = A_GetTable(ply)

	if ( A_GetMoveType(ply) == MOVETYPE_NOCLIP ) then
		pt['m_bJumping'] = false
		return
	end

	-- airwalk more like hl2mp, we airwalk until we have 0 velocity, then it's the jump animation
	-- underwater we're alright we airwalking
	if ( !pt['m_bJumping'] && !A_OnGround(ply) && A_WaterLevel(ply) <= 0 ) then

		if ( !pt['m_fGroundTime'] ) then

			pt['m_fGroundTime'] = CurTime()
			
		elseif ( CurTime() - pt['m_fGroundTime'] ) > 0 && velocity:Length2DSqr() < 0.25 then

			pt['m_bJumping'] = true
			pt['m_bFirstJumpFrame'] = false
			pt['m_flJumpStartTime'] = 0

		end
	end

	if pt['m_bJumping'] then
	
		if pt['m_bFirstJumpFrame'] then

			pt['m_bFirstJumpFrame'] = false
			A_AnimRestartMainSequence(ply)

		end
		
		if ( A_WaterLevel(ply) >= 2 ) || ( ( CurTime() - pt['m_flJumpStartTime'] ) > 0.2 && A_OnGround(ply) ) then

			pt['m_bJumping'] = false
			pt['m_fGroundTime'] = nil
			A_AnimRestartMainSequence(ply)

		end
		
		if pt['m_bJumping'] then
			pt['CalcIdeal'] = ACT_MP_JUMP
			return true
		end
	end

	return false

end

function GM:HandlePlayerDucking( ply, velocity )

	if ( !A_Crouching(ply) ) then return false end

	local pt = A_GetTable(ply)

	if ( velocity:Length2DSqr() > 0.25 ) then
		pt['CalcIdeal'] = ACT_MP_CROUCHWALK
	else
		pt['CalcIdeal'] = ACT_MP_CROUCH_IDLE
	end

	return true

end

function GM:HandlePlayerNoClipping( ply, velocity )
	local pt = A_GetTable(ply)

	if ( A_GetMoveType(ply) != MOVETYPE_NOCLIP || A_InVehicle(ply) ) then

		if ( pt['m_bWasNoclipping'] ) then

			pt['m_bWasNoclipping'] = nil
			A_AnimResetGestureSlot( ply, GESTURE_SLOT_CUSTOM )
			if ( CLIENT ) then ply:SetIK( true ) end

		end

		return

	end

	if ( !pt['m_bWasNoclipping'] ) then

		A_AnimRestartGesture( ply, GESTURE_SLOT_CUSTOM, ACT_GMOD_NOCLIP_LAYER, false )
		if ( CLIENT ) then ply:SetIK( false ) end

	end

	return true

end

function GM:HandlePlayerVaulting( ply, velocity )

	if ( velocity:LengthSqr() < 1000000 ) then return end
	if ( A_OnGround(ply) ) then return end

	local pt = A_GetTable(ply)
	pt['CalcIdeal'] = ACT_MP_SWIM

	return true

end

function GM:HandlePlayerSwimming( ply, velocity )

	local pt = A_GetTable(ply)

	if ( A_WaterLevel(ply) < 2 or A_OnGround(ply) ) then
		pt['m_bInSwim'] = false
		return false
	end

	pt['CalcIdeal'] = ACT_MP_SWIM
	pt['m_bInSwim'] = true

	return true

end

function GM:HandlePlayerLanding( ply, velocity, WasOnGround )

	if ( A_GetMoveType(ply) == MOVETYPE_NOCLIP ) then return end

	if ( A_OnGround(ply) && !WasOnGround ) then
		A_AnimRestartGesture( ply, GESTURE_SLOT_JUMP, ACT_LAND, true )
	end

end

function GM:HandlePlayerDriving( ply )

	if ( !A_InVehicle(ply) ) then return false end

	local pt = A_GetTable(ply)

	local pVehicle = A_GetVehicle( ply )

	if ( !pVehicle.HandleAnimation && pVehicle.GetVehicleClass ) then
		local c = pVehicle:GetVehicleClass()
		local t = list.Get( "Vehicles" )[ c ]
		if ( t && t.Members && t.Members.HandleAnimation ) then
			pVehicle.HandleAnimation = t.Members.HandleAnimation
		else
			pVehicle.HandleAnimation = true -- Prevent this if block from trying to assign HandleAnimation again.
		end
	end

	if ( isfunction( pVehicle.HandleAnimation ) ) then
		local seq = pVehicle:HandleAnimation( ply )
		if ( seq != nil ) then
			pt['CalcSeqOverride'] = seq
		end
	end

	if ( pt['CalcSeqOverride'] == -1 ) then -- pVehicle.HandleAnimation did not give us an animation
		local class = pVehicle:GetClass()

		if ( class == "prop_vehicle_jeep" ) then
			pt['CalcSeqOverride'] = A_LookupSequence( ply, "drive_jeep" )
		elseif ( class == "prop_vehicle_airboat" ) then
			pt['CalcSeqOverride'] = A_LookupSequence( ply, "drive_airboat" )
		elseif ( class == "prop_vehicle_prisoner_pod" && pVehicle:GetModel() == "models/vehicles/prisoner_pod_inner.mdl" ) then
			-- HACK!!
			pt['CalcSeqOverride'] = A_LookupSequence( ply, "drive_pd" )
		else
			pt['CalcSeqOverride'] = A_LookupSequence( ply, "sit_rollercoaster" )
		end
	end
	
	if ( A_GetAllowWeaponsInVehicle( ply ) && IsValid( ply:GetActiveWeapon() ) ) then
		local use_anims = ( pt['CalcSeqOverride'] == A_LookupSequence( ply, "sit_rollercoaster" ) || pt['CalcSeqOverride'] == A_LookupSequence( ply, "sit" ) )
		if ( use_anims ) then
			local holdtype = ply:GetActiveWeapon():GetHoldType()
			if ( holdtype == "smg" ) then holdtype = "smg1" end

			local seqid = A_LookupSequence( ply, "sit_" .. holdtype )
			if ( seqid != -1 ) then
				pt['CalcSeqOverride'] = seqid
			end
		end
	end

	return true
end

--[[---------------------------------------------------------
   Name: gamemode:UpdateAnimation()
   Desc: Animation updates (pose params etc) should be done here
-----------------------------------------------------------]]
function GM:UpdateAnimation( ply, velocity, maxseqgroundspeed )

	local lensqr = velocity:LengthSqr()
	local movement = 1.0

	if ( lensqr > 0.04 ) then
		movement = ( math.sqrt(lensqr) / maxseqgroundspeed )
	end

	local rate = math.min( movement, 2 )

	-- if we're under water we want to constantly be swimming..
	if ( A_WaterLevel(ply) >= 2 ) then
		rate = math.max( rate, 0.5 )
	elseif ( !A_OnGround(ply) && lensqr >= 1000000 ) then
		rate = 0.1
	end

	ply:SetPlaybackRate( rate )

	if ( CLIENT ) then

		if ( A_InVehicle(ply) ) then

			local Vehicle = ply:GetVehicle()
			
			--
			-- This is used for the 'rollercoaster' arms
			--
			local Velocity = Vehicle:GetVelocity()
			local fwd = Vehicle:GetUp()
			local dp = fwd:Dot( Vector( 0, 0, 1 ) )
			local dp2 = fwd:Dot( Velocity )

			ply:SetPoseParameter( "vertical_velocity", ( dp < 0 and dp or 0 ) + dp2 * 0.005 )

			-- Pass the vehicles steer param down to the player
			local steer = Vehicle:GetPoseParameter( "vehicle_steer" )
			steer = steer * 2 - 1 -- convert from 0..1 to -1..1
			if ( Vehicle:GetClass() == "prop_vehicle_prisoner_pod" ) then steer = 0 ply:SetPoseParameter( "aim_yaw", math.NormalizeAngle( ply:GetAimVector():Angle().y - Vehicle:GetAngles().y - 90 ) ) end
			ply:SetPoseParameter( "vehicle_steer", steer )

		end

		GAMEMODE:GrabEarAnimation( ply )
		GAMEMODE:MouthMoveAnimation( ply )
	end

end

--
-- If you don't want the player to grab his ear in your gamemode then
-- just override this.
--
function GM:GrabEarAnimation( ply )

	local pt = A_GetTable(ply)

	pt['ChatGestureWeight'] = pt['ChatGestureWeight'] or 0

	-- Don't show this when we're playing a taunt!
	if ( ply:IsPlayingTaunt() ) then return end

	if ( ply:IsTyping() ) then
		pt['ChatGestureWeight'] = math.Approach( pt['ChatGestureWeight'], 1, FrameTime() * 5.0 )
	else
		pt['ChatGestureWeight'] = math.Approach( pt['ChatGestureWeight'], 0, FrameTime() * 5.0 )
	end

	if ( ply.ChatGestureWeight > 0 ) then
	
		A_AnimRestartGesture( ply, GESTURE_SLOT_VCD, ACT_GMOD_IN_CHAT, true )
		ply:AnimSetGestureWeight( GESTURE_SLOT_VCD, pt['ChatGestureWeight'] )
	
	end

end

--
-- Moves the mouth when talking on voicecom
--
function GM:MouthMoveAnimation( ply )

	local FlexNum = ply:GetFlexNum() - 1
	if ( FlexNum <= 0 ) then return end

	for i = 0, FlexNum - 1 do
	
		local Name = ply:GetFlexName( i )

		if ( Name == "jaw_drop" || Name == "right_part" || Name == "left_part" || Name == "right_mouth_drop" || Name == "left_mouth_drop" ) then

			if ( ply:IsSpeaking() ) then
				ply:SetFlexWeight( i, math.Clamp( ply:VoiceVolume() * 2, 0, 2 ) )
			else
				ply:SetFlexWeight( i, 0 )
			end
		end

	end

end

function GM:CalcMainActivity( ply, velocity )
	if !IsValid(ply) then
		return 0,0
	end

	local pt = A_GetTable(ply)

	pt['CalcIdeal'] = ACT_MP_STAND_IDLE
	pt['CalcSeqOverride'] = -1

	self:HandlePlayerLanding( ply, velocity, pt['m_bWasOnGround'] )

	if ( self:HandlePlayerDucking( ply, velocity ) ||
		self:HandlePlayerDriving( ply ) ||
		self:HandlePlayerJumping( ply, velocity ) ||
		self:HandlePlayerSwimming( ply, velocity ) ||
		self:HandlePlayerNoClipping( ply, velocity ) ||
		self:HandlePlayerVaulting( ply, velocity ) ) then

	else

		local len2dsqr = velocity:Length2DSqr()
		if ( len2dsqr > 22500 ) then pt['CalcIdeal'] = ACT_MP_RUN elseif ( len2dsqr > 0.25 ) then pt['CalcIdeal'] = ACT_MP_WALK end

	end

	pt['m_bWasOnGround'] = A_OnGround(ply)
	pt['m_bWasNoclipping'] = ( A_GetMoveType(ply) == MOVETYPE_NOCLIP && !A_InVehicle(ply) )

	return pt['CalcIdeal'], pt['CalcSeqOverride']

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

-- it is preferred you return ACT_MP_* in CalcMainActivity, and if you have a specific need to not tranlsate through the weapon do it here
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
	
		if A_Crouching(ply) then
			A_AnimRestartGesture( ply, GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_ATTACK_CROUCH_PRIMARYFIRE, true )
		else
			A_AnimRestartGesture( ply, GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_ATTACK_STAND_PRIMARYFIRE, true )
		end
		
		return ACT_VM_PRIMARYATTACK
	
	elseif ( event == PLAYERANIMEVENT_ATTACK_SECONDARY ) then
	
		-- there is no gesture, so just fire off the VM event
		return ACT_VM_SECONDARYATTACK
		
	elseif ( event == PLAYERANIMEVENT_RELOAD ) then
	
		if A_Crouching(ply) then
			A_AnimRestartGesture( ply, GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_RELOAD_CROUCH, true )
		else
			A_AnimRestartGesture( ply, GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_RELOAD_STAND, true )
		end
		
		return ACT_INVALID
		
	elseif ( event == PLAYERANIMEVENT_JUMP ) then

		local pt = A_GetTable(ply)

		pt['m_bJumping'] = true
		pt['m_bFirstJumpFrame'] = true
		pt['m_flJumpStartTime'] = CurTime()
	
		A_AnimRestartMainSequence(ply)
	
		return ACT_INVALID
	
	elseif ( event == PLAYERANIMEVENT_CANCEL_RELOAD ) then
	
		A_AnimResetGestureSlot( ply, GESTURE_SLOT_ATTACK_AND_RELOAD )
		
		return ACT_INVALID
	end

end
