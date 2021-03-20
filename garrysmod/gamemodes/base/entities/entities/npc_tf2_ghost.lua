
AddCSLuaFile()

ENT.Base = "base_nextbot"
ENT.Spawnable = false

function ENT:Initialize()

	--self:SetModel( "models/props_halloween/ghost_no_hat.mdl" )
	--self:SetModel( "models/props_wasteland/controlroom_filecabinet002a.mdl" )
	self:SetModel( "models/mossman.mdl" )

end

function ENT:RunBehaviour()

	while ( true ) do

		self:StartActivity( ACT_WALK ) -- walk anims
		self.loco:SetDesiredSpeed( 100 ) -- walk speeds

		-- Choose a random location within 400 units of our position
		local targetPos = self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 400

		-- Search for walkable space there, or nearby
		local area = navmesh.GetNearestNavArea( targetPos )

		-- We found walkable space, get the closest point on that area to where we want to be
		if ( IsValid( area ) ) then targetPos = area:GetClosestPointOnArea( targetPos ) end

		-- walk to the target place (yielding)
		self:MoveToPos( targetPos )

		self:StartActivity( ACT_IDLE ) -- revert to idle activity

		self:PlaySequenceAndWait( "idle_to_sit_ground" ) -- Sit on the floor
		self:SetSequence( "sit_ground" ) -- Stay sitting
		coroutine.wait( self:PlayScene( "scenes/eli_lab/mo_gowithalyx01.vcd" ) ) -- play a scene and wait for it to finish before progressing
		self:PlaySequenceAndWait( "sit_ground_to_idle" ) -- Get up

		-- find the furthest away hiding spot
		local pos = self:FindSpot( "random", { type = 'hiding', radius = 5000 } )

		-- if the position is valid
		if ( pos ) then
			self:StartActivity( ACT_RUN ) -- run anim
			self.loco:SetDesiredSpeed( 200 ) -- run speed
			self:PlayScene( "scenes/npc/female01/watchout.vcd" ) -- shout something while we run just for a laugh
			self:MoveToPos( pos ) -- move to position (yielding)
			self:PlaySequenceAndWait( "fear_reaction" ) -- play a fear animation
			self:StartActivity( ACT_IDLE ) -- when we finished, go into the idle anim
		else

			-- some activity to signify that we didn't find shit

		end

		coroutine.yield()

	end


end

--
-- List the NPC as spawnable
--
list.Set( "NPC", "npc_tf2_ghost", {
	Name = "Example NPC",
	Class = "npc_tf2_ghost",
	Category = "Nextbot"
} )
