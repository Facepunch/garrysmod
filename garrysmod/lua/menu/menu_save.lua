
ws_save = WorkshopFileBase( "save", { "save" } )

function ws_save:FetchLocal( offset, perpage )

	local f = file.Find( "saves/*.gms", "MOD", "datedesc" )

	local saves = {}

	for k, v in pairs( f ) do

		if ( k <= offset ) then continue end
		if ( k > offset + perpage ) then break end

		local entry = {
			file	= "saves/" .. v,
			name	= v:StripExtension(),
			preview	= "saves/" .. v:StripExtension() .. ".jpg"
		}

		table.insert( saves, entry )

	end

	local results = {
		totalresults	= #f,
		results			= saves
	}

	local json = util.TableToJSON( results, false )
	pnlMainMenu:Call( "save.ReceiveLocal( " .. json .. " )" )

end

function ws_save:DownloadAndLoad( id )

	steamworks.DownloadUGC( id, function( name )

		if ( !name ) then hook.Call( "LoadGModSaveFailed", nil, "Failed to download save from Steam Workshop!" ) return end

		ws_save:Load( name )

	end )

end

function ws_save:Load( filename )

	RunConsoleCommand( "gm_load", filename )

end

function ws_save:FinishPublish( filename, imagename, name, desc, chosenTag, other )

	local info = GetSaveFileDetails( filename )
	if ( !info ) then return "Couldn't get save information!" end

	steamworks.Publish( filename, imagename, name, desc, { "save", info.map, chosenTag }, other.Callback, other.WorkshopID, other.ChangeNotes )

end

--
-- Called from the engine!
--
concommand.Add( "save_publish", function( ply, cmd, args )

	ws_save:Publish( args[1], args[2] )
	gui.ActivateGameUI()

end, nil, "", { FCVAR_DONTRECORD } )
