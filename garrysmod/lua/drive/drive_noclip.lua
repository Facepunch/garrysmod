
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
		local speed = 0.0005 * FrameTime()
		if ( mv:KeyDown( IN_SPEED ) ) then speed = 0.005 * FrameTime() end

		--
		-- Get information from the movedata
		--
		local ang = mv:GetMoveAngles()
		local pos = mv:GetOrigin()
		local vel = mv:GetVelocity()

		--
		-- Add velocities. This can seem complicated. On the first line
		-- we're basically saying get the forward vector, then multiply it
		-- by our forward speed (which will be > 0 if we're holding W, < 0 if we're
		-- holding S and 0 if we're holding neither) - and add that to velocity.
		-- We do that for right and up too, which gives us our free movement.
		--
		vel = vel + ang:Forward() * mv:GetForwardSpeed() * speed
		vel = vel + ang:Right() * mv:GetSideSpeed() * speed
		vel = vel + ang:Up() * mv:GetUpSpeed() * speed

		--
		-- We don't want our velocity to get out of hand so we apply
		-- a little bit of air resistance. If no keys are down we apply
		-- more resistance so we slow down more.
		--
		if ( math.abs( mv:GetForwardSpeed() ) + math.abs( mv:GetSideSpeed() ) + math.abs( mv:GetUpSpeed() ) < 0.1 ) then
			vel = vel * 0.90
		else
			vel = vel * 0.99
		end

		--
		-- Add the velocity to the position (this is the movement)
		--
		pos = pos + vel

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

	end,

	--
	-- Calculates the view when driving the entity
	--
	CalcView = function( self, view )

		--
		-- Use the utility method on drive_base.lua to give us a 3rd person view
		--
		local idealdist = math.max( 10, self.Entity:BoundingRadius() ) * 4

		self:CalcView_ThirdPerson( view, idealdist, 2, { self.Entity } )

	end,

}, "drive_base" )
