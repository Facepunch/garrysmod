
AddCSLuaFile()

local m_pitch = GetConVar( "m_pitch" )
local m_yaw = GetConVar( "m_yaw" )

--
-- This is designed so you can call it like
--
-- tauntcam = TauntCamera()
--
-- Then you have your own copy.
--
function TauntCamera()

	local CAM = {}

	local WasOn					= false

	local CustomAngles			= angle_zero
	local PlayerLockAngles		= nil

	local InLerp				= 0
	local OutLerp				= 1

	--
	-- Draw the local player if we're active in any way
	--
	CAM.ShouldDrawLocalPlayer = function( self, ply, on )

		return on || OutLerp < 1

	end

	--
	-- Implements the third person, rotation view (with lerping in/out)
	--
	CAM.CalcView = function( self, view, ply, on )

		if ( !ply:Alive() || !IsValid( ply:GetViewEntity() ) || ply:GetViewEntity() != ply ) then on = false end

		if ( WasOn != on ) then

			if ( on ) then InLerp = 0 end
			if ( !on ) then OutLerp = 0 end

			WasOn = on

		end

		if ( !on && OutLerp >= 1 ) then

			CustomAngles = view.angles * 1
			CustomAngles.r = 0
			PlayerLockAngles = nil
			InLerp = 0
			return

		end

		if ( PlayerLockAngles == nil ) then return end

		--
		-- Simple 3rd person camera
		--
		local TargetOrigin = view.origin - CustomAngles:Forward() * 100
		local tr = util.TraceHull( { start = view.origin, endpos = TargetOrigin, mask = MASK_SHOT, filter = player.GetAll(), mins = Vector( -8, -8, -8 ), maxs = Vector( 8, 8, 8 ) } )
		TargetOrigin = tr.HitPos + tr.HitNormal

		if ( InLerp < 1 ) then

			InLerp = InLerp + FrameTime() * 5.0
			view.origin = LerpVector( InLerp, view.origin, TargetOrigin )
			view.angles = LerpAngle( InLerp, PlayerLockAngles, CustomAngles )
			return true

		end

		if ( OutLerp < 1 ) then

			OutLerp = OutLerp + FrameTime() * 3.0
			view.origin = LerpVector( 1-OutLerp, view.origin, TargetOrigin )
			view.angles = LerpAngle( 1-OutLerp, PlayerLockAngles, CustomAngles )
			return true

		end

		view.angles = CustomAngles * 1
		view.origin = TargetOrigin
		return true

	end

	--
	-- Freezes the player in position and uses the input from the user command to
	-- rotate the custom third person camera
	--
	CAM.CreateMove = function( self, cmd, ply, on )

		if ( !ply:Alive() ) then on = false end
		if ( !on ) then return end

		if ( PlayerLockAngles == nil ) then
			PlayerLockAngles = CustomAngles * 1
		end

		--
		-- Rotate our view
		--
		CustomAngles.pitch	= CustomAngles.pitch	+ cmd:GetMouseY() * m_pitch:GetFloat()
		CustomAngles.yaw	= CustomAngles.yaw		- cmd:GetMouseX() * m_yaw:GetFloat()

		--
		-- Lock the player's controls and angles
		--
		cmd:SetViewAngles( PlayerLockAngles )
		cmd:ClearButtons()
		cmd:ClearMovement()

		return true

	end

	return CAM

end
