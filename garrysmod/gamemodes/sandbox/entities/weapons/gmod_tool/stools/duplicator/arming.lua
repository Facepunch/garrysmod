
local DUPE_SEND_SIZE = 60000

if ( CLIENT ) then

	--
	-- Called by the client to save a dupe they're holding on the server
	-- into a file on their computer.
	--
	local LastDupeArm = 0
	concommand.Add( "dupe_arm", function( ply, cmd, arg )

		if ( !arg[ 1 ] ) then return end

		if ( LastDupeArm > CurTime() && !game.SinglePlayer() ) then ply:ChatPrint( "Please wait a second before trying to load another duplication!" ) return end
		LastDupeArm = CurTime() + 1

		-- Server doesn't allow us to do this, don't even try to send them data
		local res = hook.Run( "CanArmDupe", ply )
		if ( res == false ) then ply:ChatPrint( "Refusing to load dupe, server has blocked usage of the Duplicator tool!" ) return end

		-- Load the dupe (engine takes care of making sure it's a dupe)
		local dupe = engine.OpenDupe( arg[ 1 ] )
		if ( !dupe ) then ply:ChatPrint( "Error loading dupe.. (" .. tostring( arg[ 1 ] ) .. ")" ) return end

		local uncompressed = util.Decompress( dupe.data, 5242880 )
		if ( !uncompressed ) then ply:ChatPrint( "That dupe seems to be corrupted!" ) return end

		--
		-- And send it to the server
		--
		local length = dupe.data:len()
		local parts = math.ceil( length / DUPE_SEND_SIZE )

		local start = 0
		for i = 1, parts do
			local endbyte = math.min( start + DUPE_SEND_SIZE, length )
			local size = endbyte - start

			net.Start( "ArmDupe" )
				net.WriteUInt( i, 8 )
				net.WriteUInt( parts, 8 )

				net.WriteUInt( size, 32 )
				net.WriteData( dupe.data:sub( start + 1, endbyte + 1 ), size )
			net.SendToServer()

			start = endbyte
		end

	end, nil, "Arm a dupe", { FCVAR_DONTRECORD } )

end

if ( SERVER ) then

	--
	-- Add the name of the net message to the string table (or it won't be able to send!)
	--
	util.AddNetworkString( "ArmDupe" )

	net.Receive( "ArmDupe", function( size, client )

		if ( !IsValid( client ) || size < 48 ) then return end

		local res = hook.Run( "CanArmDupe", client )
		if ( res == false ) then client:ChatPrint( "Server has blocked usage of the Duplicator tool!" ) return end

		local part = net.ReadUInt( 8 )
		local total = net.ReadUInt( 8 )

		local length = net.ReadUInt( 32 )
		if ( length > DUPE_SEND_SIZE ) then return end

		local data = net.ReadData( length )

		client.CurrentDupeBuffer = client.CurrentDupeBuffer or {}
		client.CurrentDupeBuffer[ part ] = data

		if ( part != total ) then return end

		local data = table.concat( client.CurrentDupeBuffer )
		client.CurrentDupeBuffer = nil

		if ( ( client.LastDupeArm or 0 ) > CurTime() && !game.SinglePlayer() ) then ServerLog( tostring( client ) .. " tried to arm a dupe too quickly!\n" ) return end
		client.LastDupeArm = CurTime() + 1

		ServerLog( tostring( client ) .. " is arming a dupe, size: " .. data:len() .. "\n" )

		local uncompressed = util.Decompress( data, 5242880 )
		if ( !uncompressed ) then
			client:ChatPrint( "Server failed to decompress the duplication!" )
			MsgN( "Couldn't decompress dupe from " .. client:Nick() .. "!" )
			return
		end

		local Dupe = util.JSONToTable( uncompressed )
		if ( !istable( Dupe ) ) then return end
		if ( !istable( Dupe.Constraints ) ) then return end
		if ( !istable( Dupe.Entities ) ) then return end
		if ( !isvector( Dupe.Mins ) ) then return end
		if ( !isvector( Dupe.Maxs ) ) then return end

		client.CurrentDupeArmed = true
		client.CurrentDupe = Dupe

		client:ConCommand( "gmod_tool duplicator" )

		--
		-- Disable the Spawnmenu button
		--
		net.Start( "CopiedDupe" )
			net.WriteUInt( 0, 1 )
			net.WriteVector( Dupe.Mins )
			net.WriteVector( Dupe.Maxs )
		net.Send( client )

	end )

end
