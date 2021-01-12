
ws_dupe = WorkshopFileBase( "dupe", { "dupe" } )

function ws_dupe:FetchLocal( offset, perpage )

	local f = file.Find( "dupes/*.dupe", "MOD", "datedesc" )

	local saves = {}

	for k, v in pairs( f ) do

		if ( k <= offset ) then continue end
		if ( k > offset + perpage ) then break end

		local entry = {
			file	= "dupes/" .. v,
			name	= v:StripExtension(),
			preview	= "dupes/" .. v:StripExtension() .. ".jpg"
		}

		table.insert( saves, entry )

	end

	local results = {
		totalresults	= #f,
		results			= saves
	}

	local json = util.TableToJSON( results, false )
	pnlMainMenu:Call( "dupe.ReceiveLocal( " .. json .. " )" )

end

function ws_dupe:FinishPublish( filename, imagename, name, desc, chosenTag, other )

	steamworks.Publish( filename, imagename, name, desc, { "dupe", chosenTag }, other.Callback, other.WorkshopID, other.ChangeNotes )

end

--
-- Called from the engine!
--
concommand.Add( "dupe_publish", function( ply, cmd, args )

	ws_dupe:Publish( args[1], args[2] )
	gui.ActivateGameUI()

end, nil, "", { FCVAR_DONTRECORD } )
