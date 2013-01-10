
if ( CLIENT ) then

	--
	-- Called by the client to save a dupe they're holding on the server
	-- into a file on their computer.
	--
	concommand.Add( "dupe_arm", function( ply, cmd, arg )

		if ( !arg[1] ) then return end
		--
		-- Load the dupe (engine takes care of making sure it's a dupe)
		--
		local dupe = engine.OpenDupe( arg[1] )
		if ( !dupe ) then
			MsgN( "Error loading dupe.. (", arg[1], ")" );
			return 
		end

		local uncompressed = util.Decompress( dupe.data )
		if ( !uncompressed ) then 
			MsgN( "Couldn't decompress dupe!" )
		return end

		--
		-- And send it to the server
		--
		net.Start( "ArmDupe" )
			net.WriteUInt( dupe.data:len(), 32 )		
			net.WriteData( dupe.data, dupe.data:len() )
		net.SendToServer()

	end, nil, "Arm a dupe", { FCVAR_DONTRECORD } )

end

if ( SERVER ) then

	--
	-- Add the name of the net message to the string table (or it won't be able to send!)
	--
	util.AddNetworkString( "ArmDupe" )

	net.Receive( "ArmDupe", function( len, client )
					
			local len		= net.ReadUInt( 32 )
			local data		= net.ReadData( len )

			if ( !IsValid( client ) ) then return end

			-- Hook.. can arn dupe..

			local uncompressed = util.Decompress( data )
			if ( !uncompressed ) then 
				MsgN( "Couldn't decompress dupe!" )
			return end

			local Dupe = util.JSONToTable( uncompressed )
			if ( !istable( Dupe ) ) then return end
			if ( !isvector( Dupe.Mins ) ) then return end
			if ( !isvector( Dupe.Maxs ) ) then return end

			client.CurrentDupe = Dupe;

			client:ConCommand( "gmod_tool duplicator" );

			--
			-- Disable the Spawn Button
			--
			net.Start( "CopiedDupe" )
				net.WriteUInt( 0, 1 );
			net.Send( client )
	end )

end

