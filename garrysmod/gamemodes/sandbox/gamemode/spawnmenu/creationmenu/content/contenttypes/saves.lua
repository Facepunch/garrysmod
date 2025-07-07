
local HTML = nil

spawnmenu.AddCreationTab( "#spawnmenu.category.saves", function()

	HTML = vgui.Create( "DHTML" )
	JS_Language( HTML )
	JS_Workshop( HTML )

	ws_save = WorkshopFileBase( "save", { "save" } )
	ws_save.HTML = HTML

	function ws_save:FetchLocal( offset, perpage )

		local f = file.Find( "saves/*.gms", "MOD", "datedesc" )

		local saves = {}

		for k, v in ipairs( f ) do

			if ( k <= offset ) then continue end
			if ( k > offset + perpage ) then break end

			local entry = {
				file	= "saves/" .. v,
				name	= v:StripExtension(),
				preview	= "saves/" .. v:StripExtension() .. ".jpg",
				description	= "Local map saves stored on your computer. Local content can be deleted in the main menu."
			}

			table.insert( saves, entry )

		end

		local results = {
			totalresults	= #f,
			results			= saves
		}

		local json = util.TableToJSON( results, false )
		HTML:Call( "save.ReceiveLocal( " .. json .. " )" )

	end

	function ws_save:DownloadAndLoad( id )

		steamworks.DownloadUGC( id, function( name )

			ws_save:Load( name )

		end )

	end

	function ws_save:Load( filename )

		local saveFile = file.Open( filename, "rb", "GAME" )
		saveFile:Seek( 4 )
		local mapFile = saveFile:ReadLine():TrimRight( "\n" )

		if ( mapFile == game.GetMap() ) then
			RunConsoleCommand( "gm_load", filename )
		else
			local msg = string.format( "Loading this save will force a map change to %s. Do you wish to continue?", mapFile )

			Derma_Query( msg,
				"Please confirm loading this save",
				"Load", function() RunConsoleCommand( "gm_load", filename ) end,
				"Cancel" )
		end

	end

	function ws_save:Publish( filename, imagename ) RunConsoleCommand( "save_publish", filename, imagename ) end

	HTML:OpenURL( "asset://garrysmod/html/saves.html" )
	HTML:Call( "SetMap( '" .. game.GetMap() .. "' );" )

	return HTML

end, "icon16/disk_multiple.png", 200 )

hook.Add( "PostGameSaved", "OnCreationsSaved", function()

	if ( !HTML ) then return end

	HTML:Call( "OnGameSaved()" )

end )
