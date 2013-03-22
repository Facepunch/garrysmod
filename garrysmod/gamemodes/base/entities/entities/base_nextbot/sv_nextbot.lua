
--
-- Name: ENT:BehaveStart
-- Desc: Called to initialize the behaviour.\n\n You shouldn't override this - it's used to kick off the coroutine that runs the bot's behaviour. \n\nThis is called automatically when the NPC is created, there should be no need to call it manually.
-- Arg1: 
-- Ret1:
--
function ENT:BehaveStart()

	local s = self
	self.BehaveThread = coroutine.create( function() self:RunBehaviour() end )
	
end

--
-- Name: ENT:BehaveUpdate
-- Desc: Called to update the bot's behaviour
-- Arg1: number|interval|How long since the last update
-- Ret1:
--
function ENT:BehaveUpdate( fInterval )

	if ( !self.BehaveThread ) then return end

	local ok, message = coroutine.resume( self.BehaveThread )
	if ( ok == false ) then

		self.BehaveThread = nil
		Msg( self, "error: ", message, "\n" );

	end

end

--
-- Name: ENT:BodyUpdate
-- Desc: Called to update the bot's animation
-- Arg1:
-- Ret1:
--
function ENT:BodyUpdate()

	--MsgN( "BodyUpdate" )

end

--
-- Name: ENT:OnLeaveGround
-- Desc: Called when the bot's feet leave the ground - for whatever reason
-- Arg1:
-- Ret1:
--
function ENT:OnLeaveGround()

	MsgN( "OnLeaveGround" )

end

--
-- Name: ENT:OnLeaveGround
-- Desc: Called when the bot's feet return to the ground
-- Arg1:
-- Ret1:
--
function ENT:OnLandOnGround()

	MsgN( "OnLandOnGround" )

end

--
-- Name: ENT:OnStuck
-- Desc: Called when the bot thinks it is stuck
-- Arg1:
-- Ret1:
--
function ENT:OnStuck()

	MsgN( "OnStuck" )

end

--
-- Name: ENT:OnUnStuck
-- Desc: Called when the bot thinks it is un-stuck
-- Arg1:
-- Ret1:
--
function ENT:OnUnStuck()

	MsgN( "OnUnStuck" )

end

--
-- Name: ENT:OnInjured
-- Desc: Called when the bot gets hurt
-- Arg1:
-- Ret1:
--
function ENT:OnInjured()

	MsgN( "OnInjured" )

end

--
-- Name: ENT:OnKilled
-- Desc: Called when the bot gets killed
-- Arg1:
-- Ret1:
--
function ENT:OnKilled( damageinfo )

	self:BecomeRagdoll( damageinfo )

end

--
-- Name: ENT:OnOtherKilled
-- Desc: Called when someone else or something else has been killed
-- Arg1:
-- Ret1:
--
function ENT:OnOtherKilled()

	MsgN( "OnOtherKilled" )

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
	for _, area in pairs( areas ) do

		-- get the spots
		local spots 
		
		if ( tbl.type == 'hiding' ) then spots = area:GetHidingSpots() end

		for k, vec in pairs( spots ) do

			-- Work out the length, and add them to a table
			path:Invalidate()

			path:Compute( self, vec, 1 ) -- TODO: This is bullshit - it's using 'self.pos' not tbl.pos
				
			table.insert( found, { vector = vec, distance = path:GetLength() } )

		end

	end

	return found

end