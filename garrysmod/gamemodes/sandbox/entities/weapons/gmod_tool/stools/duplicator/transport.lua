
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
	local length = compressed:len()
	local send_size = 60000
	local parts = math.ceil( length / send_size )

	MsgN( "Compressed Dupe for sending: ", json:len(), " => ", length, " ( sending in ", parts , " parts )" );

	--
	-- And send it(!)
	--
	local start = 0
	for i = 1, parts do

		local endbyte = math.min( start + send_size, length )
		local size = endbyte - start

		//print( "S [ " .. i .. " / " .. parts .. " ] Size: " .. size .. " Start: " .. start .. " End: " .. endbyte )

		net.Start( "ReceiveDupe" )
			net.WriteUInt( i, 8 )
			net.WriteUInt( parts, 8 )

			net.WriteUInt( size, 32 )
			net.WriteData( compressed:sub( start + 1, endbyte + 1 ), size )
		net.Send( ply )

		start = endbyte
	end

end, nil, "Save the current dupe!", { FCVAR_DONTRECORD } )

end

if ( CLIENT ) then

	local buffer = ""
	net.Receive( "ReceiveDupe", function( len, client )

			local part = net.ReadUInt( 8 )
			local total = net.ReadUInt( 8 )

			local len = net.ReadUInt( 32 )
			local data = net.ReadData( len )

			buffer = buffer .. data

			//MsgN( "R [ " .. part .. " / " .. total .. " ] Size: " .. data:len() )

			if ( part != total ) then return end

			MsgN( "Received dupe. Size: " .. buffer:len() )

			local uncompressed = util.Decompress( buffer )
			buffer = ""

			if ( !uncompressed ) then
				MsgN( "Received dupe - but couldn't decompress!?" )
				return
			end

			--
			-- Set this global so we can pick it up when we're rendering a frame
			-- See icon.lua for this process
			--
			g_ClientSaveDupe = util.JSONToTable( uncompressed )

	end )

end
