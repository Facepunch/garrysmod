
--
-- Name: NEXTBOT:BehaveStart
-- Desc: Called to initialize the behaviour.\n\n You shouldn't override this - it's used to kick off the coroutine that runs the bot's behaviour. \n\nThis is called automatically when the NPC is created, there should be no need to call it manually.
-- Arg1:
-- Ret1:
--
function ENT:BehaveStart()

	self.BehaveThread = coroutine.create( function() self:RunBehaviour() end )

end

function ENT:RunBehaviour()
end

--
-- Name: NEXTBOT:BehaveUpdate
-- Desc: Called to update the bot's behaviour
-- Arg1: number|interval|How long since the last update
-- Ret1:
--
function ENT:BehaveUpdate( fInterval )

	if ( !self.BehaveThread ) then return end

	--
	-- Give a silent warning to developers if RunBehaviour has returned
	--
	if ( coroutine.status( self.BehaveThread ) == "dead" ) then

		self.BehaveThread = nil
		Msg( self, " Warning: ENT:RunBehaviour() has finished executing\n" )

		return

	end

	--
	-- Continue RunBehaviour's execution
	--
	local ok, message = coroutine.resume( self.BehaveThread )
	if ( ok == false ) then

		self.BehaveThread = nil
		ErrorNoHalt( self, " Error: ", message, "\n" )

	end

end

--
-- Name: NEXTBOT:BodyUpdate
-- Desc: Called to update the bot's animation
-- Arg1:
-- Ret1:
--
function ENT:BodyUpdate()

	local act = self:GetActivity()

	--
	-- This helper function does a lot of useful stuff for us.
	-- It sets the bot's move_x move_y pose parameters, sets their animation speed relative to the ground speed, and calls FrameAdvance.
	--
	if ( act == ACT_RUN || act == ACT_WALK ) then

		self:BodyMoveXY()

		-- BodyMoveXY() already calls FrameAdvance, calling it twice will affect animation playback, specifically on layers
		return

	end

	--
	-- If we're not walking or running we probably just want to update the anim system
	--
	self:FrameAdvance()

end

--
-- Name: NEXTBOT:OnLeaveGround
-- Desc: Called when the bot's feet leave the ground - for whatever reason
-- Arg1: Entity|ent|Entity that the NextBot "jumped" from
-- Ret1:
--
function ENT:OnLeaveGround( ent )

	--MsgN( "OnLeaveGround", ent )

end

--
-- Name: NEXTBOT:OnLeaveGround
-- Desc: Called when the bot's feet return to the ground
-- Arg1: Entity|ent|Entity that the NextBot landed on
-- Ret1:
--
function ENT:OnLandOnGround( ent )

	--MsgN( "OnLandOnGround", ent )

end

--
-- Name: NEXTBOT:OnStuck
-- Desc: Called when the bot thinks it is stuck
-- Arg1:
-- Ret1:
--
function ENT:OnStuck()

	--MsgN( "OnStuck" )

end

--
-- Name: NEXTBOT:OnUnStuck
-- Desc: Called when the bot thinks it is un-stuck
-- Arg1:
-- Ret1:
--
function ENT:OnUnStuck()

	--MsgN( "OnUnStuck" )

end

--
-- Name: NEXTBOT:OnTakeDamage
-- Desc: Called when the bot is about to take damage
-- Arg1: CTakeDamageInfo|info|damage info
-- Ret1: number|how much damage was taken, prevents default damage code from running
--
function ENT:OnTakeDamage( damageinfo )

	-- return 0

end

--
-- Name: NEXTBOT:OnInjured
-- Desc: Called when the bot gets hurt
-- Arg1: CTakeDamageInfo|info|damage info
-- Ret1:
--
function ENT:OnInjured( damageinfo )

end

--
-- Name: NEXTBOT:OnKilled
-- Desc: Called when the bot gets killed
-- Arg1: CTakeDamageInfo|info|damage info
-- Ret1:
--
function ENT:OnKilled( dmginfo )

	hook.Run( "OnNPCKilled", self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )

	self:BecomeRagdoll( dmginfo )

end

--
-- Name: NEXTBOT:OnOtherKilled
-- Desc: Called when someone else or something else has been killed
-- Arg1: Entity|victim|entity that was killed
-- Arg2: CTakeDamageInfo|info|damage info
-- Ret1:
--
function ENT:OnOtherKilled( victim, info )

	--MsgN( "OnOtherKilled", victim, info )

end

function ENT:OnContact( ent )

	--MsgN( "OnContact", ent )

end

function ENT:OnIgnite()

	--MsgN( "OnIgnite" )

end

function ENT:OnNavAreaChanged( old, new )

	--MsgN( "OnNavAreaChanged", old, new )

end

--
-- Name: NextBot:FindSpots
-- Desc: Returns a table of hiding spots.
-- Arg1: table|specs|This table should contain the search info.\n\n * 'type' - the type (either 'hiding')\n * 'pos' - the position to search.\n * 'radius' - the radius to search.\n * 'stepup' - the highest step to step up.\n * 'stepdown' - the highest we can step down without being hurt.
-- Ret1: table|An unsorted table of tables containing\n * 'vector' - the position of the hiding spot\n * 'distance' - the distance to that position
--
function ENT:FindSpots( tbl )

	local tbl = tbl or {}

	tbl.pos			= tbl.pos			or self:WorldSpaceCenter()
	tbl.radius		= tbl.radius		or 1000
	tbl.stepdown	= tbl.stepdown		or 20
	tbl.stepup		= tbl.stepup		or 20
	tbl.type		= tbl.type			or 'hiding'

	-- Use a path to find the length
	local path = Path( "Follow" )

	-- Find a bunch of areas within this distance
	local areas = navmesh.Find( tbl.pos, tbl.radius, tbl.stepdown, tbl.stepup )

	local found = {}

	-- In each area
	for _, area in ipairs( areas ) do

		-- get the spots
		local spots

		if ( tbl.type == 'hiding' ) then spots = area:GetHidingSpots() end

		for k, vec in ipairs( spots ) do

			-- Work out the length, and add them to a table
			path:Invalidate()

			path:Compute( self, vec ) -- TODO: This is bullshit - it's using 'self.pos' not tbl.pos

			table.insert( found, { vector = vec, distance = path:GetLength() } )

		end

	end

	return found

end

--
-- Name: NextBot:FindSpot
-- Desc: Like FindSpots but only returns a vector
-- Arg1: string|type|Either "random", "near", "far"
-- Arg2: table|options|A table containing a bunch of tweakable options. See the function definition for more details
-- Ret1: vector|If it finds a spot it will return a vector. If not it will return nil.
--
function ENT:FindSpot( type, options )

	local spots = self:FindSpots( options )
	if ( !spots || #spots == 0 ) then return end

	if ( type == "near" ) then

		table.SortByMember( spots, "distance", true )
		return spots[1].vector

	end

	if ( type == "far" ) then

		table.SortByMember( spots, "distance", false )
		return spots[1].vector

	end

	-- random
	return spots[ math.random( 1, #spots ) ].vector

end

--
-- Name: NextBot:HandleStuck
-- Desc: Called from Lua when the NPC is stuck. This should only be called from the behaviour coroutine - so if you want to override this function and do something special that yields - then go for it.\n\nYou should always call self.loco:ClearStuck() in this function to reset the stuck status - so it knows it's unstuck.
-- Arg1:
-- Ret1:
--
function ENT:HandleStuck()

	--
	-- Clear the stuck status
	--
	self.loco:ClearStuck()

end

--
-- Name: NextBot:MoveToPos
-- Desc: To be called in the behaviour coroutine only! Will yield until the bot has reached the goal or is stuck
-- Arg1: Vector|pos|The position we want to get to
-- Arg2: table|options|A table containing a bunch of tweakable options. See the function definition for more details
-- Ret1: string|Either "failed", "stuck", "timeout" or "ok" - depending on how the NPC got on
--
function ENT:MoveToPos( pos, options )

	local options = options or {}

	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( options.lookahead or 300 )
	path:SetGoalTolerance( options.tolerance or 20 )
	path:Compute( self, pos )

	if ( !path:IsValid() ) then return "failed" end

	while ( path:IsValid() ) do

		path:Update( self )

		-- Draw the path (only visible on listen servers or single player)
		if ( options.draw ) then
			path:Draw()
		end

		-- If we're stuck then call the HandleStuck function and abandon
		if ( self.loco:IsStuck() ) then

			self:HandleStuck()

			return "stuck"

		end

		--
		-- If they set maxage on options then make sure the path is younger than it
		--
		if ( options.maxage ) then
			if ( path:GetAge() > options.maxage ) then return "timeout" end
		end

		--
		-- If they set repath then rebuild the path every x seconds
		--
		if ( options.repath ) then
			if ( path:GetAge() > options.repath ) then path:Compute( self, pos ) end
		end

		coroutine.yield()

	end

	return "ok"

end

--
-- Name: NextBot:PlaySequenceAndWait
-- Desc: To be called in the behaviour coroutine only! Plays an animation sequence and waits for it to end before returning.
-- Arg1: string|name|The sequence name
-- Arg2: number|the speed (default 1)
-- Ret1:
--
function ENT:PlaySequenceAndWait( name, speed )

	local len = self:SetSequence( name )
	speed = speed or 1

	self:ResetSequenceInfo()
	self:SetCycle( 0 )
	self:SetPlaybackRate( speed )

	-- wait for it to finish
	coroutine.wait( len / speed )

end

--
-- Name: NEXTBOT:Use
-- Desc: Called when a player 'uses' the entity
-- Arg1: entity|activator|The entity that activated the use
-- Arg2: entity|called|The entity that called the use
-- Arg3: number|type|The type of use (USE_ON, USE_OFF, USE_TOGGLE, USE_SET)
-- Arg4: number|value|Any passed value
-- Ret1:
--
function ENT:Use( activator, caller, type, value )
end

--
-- Name: NEXTBOT:Think
-- Desc: Called periodically
-- Arg1:
-- Ret1:
--
function ENT:Think()
end

--
-- Name: NEXTBOT:HandleAnimEvent
-- Desc: Called for serverside events
--
function ENT:HandleAnimEvent( event, eventtime, cycle, typee, options )
end

--
-- Name: NEXTBOT:OnTraceAttack
-- Desc: Called serverside when the nextbot is attacked
--
function ENT:OnTraceAttack( dmginfo, dir, trace )

	hook.Run( "ScaleNPCDamage", self, trace.HitGroup, dmginfo )

end

-- Called when we see a player or another nextbot
function ENT:OnEntitySight( subject )
end

-- Called when we see lose sight of a player or a nextbot we saw earlier
function ENT:OnEntitySightLost( subject )
end
