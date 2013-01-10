

if ( SERVER ) then

	--
	-- Pool the shared network string
	--
	util.AddNetworkString( "GModSave" )

	--
	-- Console command to trigger the save serverside (and send the save to the client)
	--
	concommand.Add( "gm_save", function( ply, cmd, args )

		if ( !IsValid( ply ) ) then return end
		if ( ply.m_NextSave && ply.m_NextSave > CurTime() && !game.SinglePlayer() ) then
		
			ServerLog( "Player is saving too quickly! " .. tostring( ply ) .. "\n" )

		return end 

		ply.m_NextSave = CurTime() + 10;

		ServerLog( "Sending save to player " .. tostring( ply ) .. "\n" )


		local save = gmsave.SaveMap( ply )
		if ( !save ) then return end

		compressed_save = util.Compress( save )
		if ( !compressed_save ) then compressed_save = save end

		local len = string.len(compressed_save)

		local ShowSave = 0;
		if ( args[1] == 'spawnmenu' ) then ShowSave = 1 end

		net.Start( "GModSave" )
			net.WriteUInt( len, 32 )		
			net.WriteData( compressed_save, len )
			net.WriteUInt( ShowSave, 1 )
		net.Send( ply )

	end, nil, "", { FCVAR_DONTRECORD } )
	

	hook.Add( "LoadGModSave", "LoadGModSave", function( savedata, mapname, maptime )

		//MsgN( "SaveData: [", savedata, "]" );
		//MsgN( "mapname: [", mapname, "]" );
		//MsgN( "maptime: [", maptime, "]" );

		savedata = util.Decompress( savedata );

		if ( !isstring( savedata ) ) then 
			MsgN( "gm_load: Couldn't load save!" )
			return
		end

		gmsave.LoadMap( savedata, nil )

	end );

else

	net.Receive( "GModSave", function( len, client )
		
			local len = net.ReadUInt( 32 )
			local data = net.ReadData( len )
			local showsave = net.ReadUInt( 1 )

			--MsgN( "Received Data ", len )
			--MsgN( data )

			uncompressed = util.Decompress( data )
			if ( !uncompressed ) then 
				Msg( "Received save - but couldn't decompress!?\n" );
				return
			end

			engine.WriteSave( data, game.GetMap() .." ".. util.DateStamp(), CurTime(), game.GetMap() );

			if ( showsave ) then
				hook.Run( "PostGameSaved" );
			end

	end )

end