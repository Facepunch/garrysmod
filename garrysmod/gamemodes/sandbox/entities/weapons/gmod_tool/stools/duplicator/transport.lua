
if ( SERVER ) then

--
-- Add the name of the net message to the string table (or it won't be able to send!)
--
util.AddNetworkString( "ReceiveDupe" )

--
-- Called by the client to save a dupe they're holding on the server
-- into a file on their computer.
--
concommand.Add( "dupe_save", function( ply, cmd, arg )

	if ( !IsValid( ply ) ) then return end

	--
	-- No dupe to save (!)
	--
	if ( !ply.CurrentDupe ) then return end

	--
	-- Convert dupe to JSON
	--
	local json = util.TableToJSON( ply.CurrentDupe )

	--
	-- Compress it
	--
	local compressed = util.Compress( json )

	MsgN( "Compressed Dupe for sending: ", json:len(), " => ", compressed:len() );

	--
	-- And send it(!)
	--
	net.Start( "ReceiveDupe" )
		net.WriteUInt( compressed:len(), 32 )		
		net.WriteData( compressed, compressed:len() )
	net.Send( ply )

end, nil, "Save the current dupe!", { FCVAR_DONTRECORD } )

end

if ( CLIENT ) then

	net.Receive( "ReceiveDupe", function( len, client )
		
			local len		= net.ReadUInt( 32 )
			local data		= net.ReadData( len )

			local uncompressed = util.Decompress( data )
			if ( !uncompressed ) then 
				Msg( "Received dupe - but couldn't decompress!?\n" );
				return
			end

			--
			-- Set this global so we can pick it up when we're rendering a frame
			-- See icon.lua for this process
			--
			g_ClientSaveDupe = util.JSONToTable( uncompressed )

	end )

end