
function GM:HandlePlayerJumping( ply, velocity )

	if ( ply:GetMoveType() == MOVETYPE_NOCLIP ) then
		ply.m_bJumping = false
		return
	end

	-- airwalk more like hl2mp, we airwalk until we have 0 velocity, then it's the jump animation
	-- underwater we're alright we airwalking
	if ( !ply.m_bJumping && !ply:OnGround() && ply:WaterLevel() <= 0 ) then

		if ( !ply.m_fGroundTime ) then

			ply.m_fGroundTime = CurTime()
			
		elseif ( CurTime() - ply.m_fGroundTime ) > 0 && velocity:Length2D() < 0.5 then

			ply.m_bJumping = true
			ply.m_bFirstJumpFrame = false
			ply.m_flJumpStartTime = 0

		end
	end

	if ply.m_bJumping then
	
		if ply.m_bFirstJumpFrame then

			ply.m_bFirstJumpFrame = false
			ply:AnimRestartMainSequence()

		end
		
		if ( ply:WaterLevel() >= 2 ) || ( ( CurTime() - ply.m_flJumpStartTime ) > 0.2 && ply:OnGround() ) then

			ply.m_bJumping = false
			ply.m_fGroundTime = nil
			ply:AnimRestartMainSequence()

		end
		
		if ply.m_bJumping then
			ply.CalcIdeal = ACT_MP_JUMP
			return true
		end
	end

	return false

end

function GM:HandlePlayerDucking( ply, velocity )

	if ( !ply:Crouching() ) then return false end

	if ( velocity:Length2D() > 0.5 ) then
		ply.CalcIdeal = ACT_MP_CROUCHWALK
	else
		ply.CalcIdeal = ACT_MP_CROUCH_IDLE
	end

	return true

end

function GM:HandlePlayerNoClipping( ply, velocity )

	if ( ply:GetMoveType() != MOVETYPE_NOCLIP || ply:InVehicle() ) then

		if ( ply.m_bWasNoclipping ) then

			ply.m_bWasNoclipping = nil
			ply:AnimResetGestureSlot( GESTURE_SLOT_CUSTOM )
			if ( CLIENT ) then ply:SetIK( true ) end

		end

		return

	end

	if ( !ply.m_bWasNoclipping ) then

		ply:AnimRestartGesture( GESTURE_SLOT_CUSTOM, ACT_GMOD_NOCLIP_LAYER, false )
		if ( CLIENT ) then ply:SetIK( false ) end

	end

	return true

end

function GM:HandlePlayerVaulting( ply, velocity )

	if ( velocity:Length() < 1000 ) then return end
	if ( ply:IsOnGround() ) then return end

	ply.CalcIdeal = ACT_MP_SWIM

	return true

end

function GM:HandlePlayerSwimming( ply, velocity )

	if ( ply:WaterLevel() < 2 or ply:IsOnGround() ) then
		ply.m_bInSwim = false
		return false
	end

	ply.CalcIdeal = ACT_MP_SWIM
	ply.m_bInSwim = true

	return true

end

function GM:HandlePlayerLanding( ply, velocity, WasOnGround )

	if ( ply:GetMoveType() == MOVETYPE_NOCLIP ) then return end

	if ( ply:IsOnGround() && !WasOnGround ) then
		ply:AnimRestartGesture( GESTURE_SLOT_JUMP, ACT_LAND, true )
	end

end

function GM:HandlePlayerDriving( ply )

	if ( !ply:InVehicle() ) then return false end

	local pVehicle = ply:GetVehicle()

	if ( !pVehicle.HandleAnimation && pVehicle.GetVehicleClass ) then
		local c = pVehicle:GetVehicleClass()
		local t = list.Get( "Vehicles" )[ c ]
		if ( t && t.Members && t.Members.HandleAnimation ) then
			pVehicle.HandleAnimation = t.Members.HandleAnimation
		else
			pVehicle.HandleAnimation = true -- Prevent this if block from trying to assign HandleAnimation again.
		end
	end

	local class = pVehicle:GetClass()

	if ( isfunction( pVehicle.HandleAnimation ) ) then
		local seq = pVehicle:HandleAnimation( ply )
		if ( seq != nil ) then
			ply.CalcSeqOverride = seq
		end
	end

	if ( ply.CalcSeqOverride == -1 ) then -- pVehicle.HandleAnimation did not give us an animation
		if ( class == "prop_vehicle_jeep" ) then
			ply.CalcSeqOverride = ply:LookupSequence( "drive_jeep" )
		elseif ( class == "prop_vehicle_airboat" ) then
			ply.CalcSeqOverride = ply:LookupSequence( "drive_airboat" )
		elseif ( class == "prop_vehicle_prisoner_pod" && pVehicle:GetModel() == "models/vehicles/prisoner_pod_inner.mdl" ) then
			-- HACK!!
			ply.CalcSeqOverride = ply:LookupSequence( "drive_pd" )
		else
			ply.CalcSeqOverride = ply:LookupSequence( "sit_rollercoaster" )
		end
	end
	
	local use_anims = ( ply.CalcSeqOverride == ply:LookupSequence( "sit_rollercoaster" ) || ply.CalcSeqOverride == ply:LookupSequence( "sit" ) )
	if ( use_anims && ply:GetAllowWeaponsInVehicle() && IsValid( ply:GetActiveWeapon() ) ) then
		local holdtype = ply:GetActiveWeapon():GetHoldType()
		if ( holdtype == "smg" ) then holdtype = "smg1" end

		local seqid = ply:LookupSequence( "sit_" .. holdtype )
		if ( seqid != -1 ) then
			ply.CalcSeqOverride = seqid
		end
	end

	return true
end

--[[---------------------------------------------------------
   Name: gamemode:UpdateAnimation()
   Desc: Animation updates (pose params etc) should be done here
-----------------------------------------------------------]]
function GM:UpdateAnimation( ply, velocity, maxseqgroundspeed )

	local len = velocity:Length()
	local movement = 1.0

	if ( len > 0.2 ) then
		movement = ( len / maxseqgroundspeed )
	end

	local rate = math.min( movement, 2 )

	-- if we're under water we want to constantly be swimming..
	if ( ply:WaterLevel() >= 2 ) then
		rate = math.max( rate, 0.5 )
	elseif ( !ply:IsOnGround() && len >= 1000 ) then
		rate = 0.1
	end

	ply:SetPlaybackRate( rate )

	if ( ply:InVehicle() ) then

		local Vehicle = ply:GetVehicle()
		
		-- We only need to do this clientside..
		if ( CLIENT ) then
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
		
	end

	if ( CLIENT ) then
		GAMEMODE:GrabEarAnimation( ply )
		GAMEMODE:MouthMoveAnimation( ply )
	end

end

--
-- If you don't want the player to grab his ear in your gamemode then
-- just override this.
--
function GM:GrabEarAnimation( ply )

	ply.ChatGestureWeight = ply.ChatGestureWeight or 0

	-- Don't show this when we're playing a taunt!
	if ( ply:IsPlayingTaunt() ) then return end

	if ( ply:IsTyping() ) then
		ply.ChatGestureWeight = math.Approach( ply.ChatGestureWeight, 1, FrameTime() * 5.0 )
	else
		ply.ChatGestureWeight = math.Approach( ply.ChatGestureWeight, 0, FrameTime() * 5.0 )
	end

	if ( ply.ChatGestureWeight > 0 ) then
	
		ply:AnimRestartGesture( GESTURE_SLOT_VCD, ACT_GMOD_IN_CHAT, true )
		ply:AnimSetGestureWeight( GESTURE_SLOT_VCD, ply.ChatGestureWeight )
	
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

	ply.CalcIdeal = ACT_MP_STAND_IDLE
	ply.CalcSeqOverride = -1

	self:HandlePlayerLanding( ply, velocity, ply.m_bWasOnGround )

	if ( self:HandlePlayerNoClipping( ply, velocity ) ||
		self:HandlePlayerDriving( ply ) ||
		self:HandlePlayerVaulting( ply, velocity ) ||
		self:HandlePlayerJumping( ply, velocity ) ||
		self:HandlePlayerSwimming( ply, velocity ) ||
		self:HandlePlayerDucking( ply, velocity ) ) then

	else

		local len2d = velocity:Length2D()
		if ( len2d > 150 ) then ply.CalcIdeal = ACT_MP_RUN elseif ( len2d > 0.5 ) then ply.CalcIdeal = ACT_MP_WALK end

	end

	ply.m_bWasOnGround = ply:IsOnGround()
	ply.m_bWasNoclipping = ( ply:GetMoveType() == MOVETYPE_NOCLIP && !ply:InVehicle() )

	return ply.CalcIdeal, ply.CalcSeqOverride

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
	
		if ply:Crouching() then
			ply:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_ATTACK_CROUCH_PRIMARYFIRE, true )
		else
			ply:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_ATTACK_STAND_PRIMARYFIRE, true )
		end
		
		return ACT_VM_PRIMARYATTACK
	
	elseif ( event == PLAYERANIMEVENT_ATTACK_SECONDARY ) then
	
		-- there is no gesture, so just fire off the VM event
		return ACT_VM_SECONDARYATTACK
		
	elseif ( event == PLAYERANIMEVENT_RELOAD ) then
	
		if ply:Crouching() then
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
