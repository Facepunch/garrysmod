
AddCSLuaFile()

ENT.Base 			= "base_nextbot"
ENT.Spawnable		= true

function ENT:Initialize()

	--self:SetModel( "models/props_halloween/ghost_no_hat.mdl" );
	--self:SetModel( "models/props_wasteland/controlroom_filecabinet002a.mdl" );
	self:SetModel( "models/mossman.mdl" );

end

function ENT:BehaveAct()

end

function ENT:RunBehaviour()

	local timerRepath	= util.Timer()
	local path			= Path( "Follow" )

	path:SetMinLookAheadDistance( 100 )

	while ( true ) do

		if ( timerRepath:Elapsed() ) then

			timerRepath:Start( 10 )	

			local spots = self:FindSpots( { radius = 5000, type = 'hiding' } )

			if ( #spots > 0 ) then

				table.SortByMember( spots, "distance", false )
				path:Compute( self, spots[1].vector, 1 );

			end

		end

		-- Walk along path
		path:Update( self )

		--for i=1,1000000 do
		--	local a = 10
		--	a = a+ 10
		--end

		coroutine.yield()

	end


end







--
-- List the NPC as spawnable
--
list.Set( "NPC", "npc_tf2_ghost", 	{	Name = "TF2 Ghost", 
										Class = "npc_tf2_ghost",
										Category = "TF2"	
									})