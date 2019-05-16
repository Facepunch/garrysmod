
AddCSLuaFile()

--
-- Note that this just controls what BaseClass provides.
-- If you're changing the base scroll to the bottom of the file too.
--
DEFINE_BASECLASS( "drive_base" );


drive.Register( "drive_noclip", 
{
	--
	-- Called before each move. You should use your entity and cmd to 
	-- fill mv with information you need for your move.
	--
        SetupControls = function( self, cmd )

		

		
		if ( cmd:KeyDown( IN_RELOAD ) ) then
		
		
	StartMove =  function( self, mv, cmd )

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
	FinishMove =  function( self, mv )

		--
		-- Update our entity!
		--
		


	end,

	--
	-- Calculates the view when driving the entity
	--
	CalcView =  function( self, view )

		--
		-- Use the utility method on drive_base.lua to give us a 3rd person view
		--
		local idealdist = math.max( 10, self.Entity:BoundingRadius() ) * 4

		self:CalcView_ThirdPerson( view, idealdist, 2, { self.Entity } )

	end,

}, "drive_base" );
