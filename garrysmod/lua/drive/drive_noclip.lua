
AddCSLuaFile()

--
-- Note that this just controls what BaseClass provides.
-- If you're changing the base scroll to the bottom of the file too.
--
DEFINE_BASECLASS( "drive_base" )


drive.Register( "drive_noclip",
{
	--
	-- Called before each move. You should use your entity and cmd to
	-- fill mv with information you need for your move.
	--
	StartMove = function( self, mv, cmd )

		--
		-- Use (E) was pressed - stop it.
		--
		if ( mv:KeyReleased( IN_USE ) ) then
			self:Stop()
		end

		--
		-- Update move position and velocity from our entity
		--
		mv:SetOrigin( self.Entity:GetNetworkOrigin() )
		mv:SetVelocity( self.Entity:GetAbsVelocity() )

	end,

	--
	-- Runs the actual move. On the client when there's
	-- prediction errors this can be run multiple times.
	-- You should try to only change mv.
	--
	Move = function( self, mv )

		--
		-- Set up a speed, go faster if shift is held down
		--
		local speed = 1
		if ( mv:KeyDown( IN_SPEED ) ) then speed = 3 end
		if ( mv:KeyDown( IN_DUCK ) ) then speed = 0.1 end

		-- Simulate noclip's action when holding space
		if ( mv:KeyDown( IN_JUMP ) ) then mv:SetUpSpeed( 10000 ) end

		-- Doesn't work correctly
		--[[if ( mv:KeyDown( IN_RELOAD ) ) then
			local ang = mv:GetMoveAngles()
			ang.r = 0
			mv:SetMoveAngles( ang )
		end]]

		--
		-- Get information from the movedata
		--
		local ang = mv:GetMoveAngles()
		local pos = mv:GetOrigin()
		local vel = mv:GetVelocity()

		--
		-- Calculate our velocity
		--
		local accel = speed * FrameTime() * 0.3
		vel = vel + ang:Forward() * mv:GetForwardSpeed() * accel
		vel = vel + ang:Right() * mv:GetSideSpeed() * accel
		vel = vel + ang:Up() * mv:GetUpSpeed() * accel

		local maxSpeed = 400 * speed
		if ( vel:Length() > maxSpeed ) then
			vel = vel:GetNormalized() * maxSpeed
		end

		--
		-- Apply friction when we are not trying to move
		--
		if ( math.abs( mv:GetForwardSpeed() ) + math.abs( mv:GetSideSpeed() ) + math.abs( mv:GetUpSpeed() ) < 0.1 ) then
			vel = vel * 0.86
		end

		--
		-- Add the velocity to the position (this is the movement)
		--
		pos = pos + vel * FrameTime()

		--
		-- We don't set the newly calculated values on the entity itself
		-- we instead store them in the movedata. These get applied in FinishMove.
		--
		mv:SetVelocity( vel )
		mv:SetOrigin( pos )

	end,

	--
	-- The move is finished. Use mv to set the new positions
	-- on your entities/players.
	--
	FinishMove = function( self, mv )

		--
		-- Update our entity!
		--
		self.Entity:SetNetworkOrigin( mv:GetOrigin() )
		self.Entity:SetAbsVelocity( mv:GetVelocity() )
		self.Entity:SetAngles( mv:GetMoveAngles() )

		--
		-- If we have a physics object update that too. But only on the server.
		--
		if ( SERVER && IsValid( self.Entity:GetPhysicsObject() ) ) then

			self.Entity:GetPhysicsObject():EnableMotion( true )
			self.Entity:GetPhysicsObject():SetPos( mv:GetOrigin() )
			self.Entity:GetPhysicsObject():Wake()
			self.Entity:GetPhysicsObject():EnableMotion( false )

		end

	end

}, "drive_base" )
