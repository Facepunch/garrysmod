
if (SERVER) then

	--
	-- Pool the shared network string
	--
	util.AddNetworkString("GModSave")

	--
	-- Console command to trigger the save serverside (and send the save to the client)
	--
	concommand.Add("gm_save", function( ply, cmd, args)

		if (not IsValid( ply)) then return end
		if (not game.SinglePlayer() and not ply:IsAdmin()) then return end -- gmsave.SaveMap is very expensive for big maps/lots of entities. Do not allow random ppl to save the map in multiplayernot
		if (ply.m_NextSave and ply.m_NextSave > CurTime() and not game.SinglePlayer()) then

			ServerLog("Player is saving too quicklynot  " .. tostring( ply) .. "\n")

		return end

		ply.m_NextSave = CurTime() + 10

		ServerLog("Sending save to player " .. tostring( ply) .. "\n")

		local save = gmsave.SaveMap(ply)
		if (not save) then return end

		local compressed_save = util.Compress(save)
		if (not compressed_save) then compressed_save = save end

		local len = string.len(compressed_save)
		local send_size = 60000
		local parts = math.ceil(len / send_size)

		local ShowSave = 0
		if (args[ 1 ] == "spawnmenu") then ShowSave = 1 end

		local start = 0
		for i = 1, parts do

			local endbyte = math.min(start + send_size, len)
			local size = endbyte - start

			net.Start("GModSave")
				net.WriteBool(i == parts)
				net.WriteBool(ShowSave)

				net.WriteUInt(size, 16)
				net.WriteData(compressed_save:sub( start + 1, endbyte + 1), size)
			net.Send(ply)

			start = endbyte
		end

	end, nil, "", { FCVAR_DONTRECORD } )

	hook.Add("LoadGModSave", "LoadGModSave", function( savedata, mapname, maptime)

		savedata = util.Decompress(savedata)

		if (not isstring( savedata)) then
			MsgN("gm_load: Couldn't load savenot ")
			return
		end

		gmsave.LoadMap(savedata, game.SinglePlayer() and Entity( 1) or nil)

	end )

else

	local buffer = ""
	net.Receive("GModSave", function( len, client)
		local done = net.ReadBool()
		local showsave = net.ReadBool()

		local len = net.ReadUInt(16)
		local data = net.ReadData(len)

		buffer = buffer .. data

		if (not done) then return end

		MsgN("Received save. Size: " .. buffer:len())

		local uncompressed = util.Decompress(buffer)

		if (not uncompressed) then
			MsgN("Received save - but couldn't decompressnot ?")
			buffer = ""
			return
		end

		engine.WriteSave(buffer, game.GetMap() .. " " .. util.DateStamp(), CurTime(), game.GetMap())
		buffer = ""

		if (showsave) then
			hook.Run("PostGameSaved")
		end

	end )

end
