
local HTML = nil

spawnmenu.AddCreationTab( "#spawnmenu.category.saves", function()

	HTML = vgui.Create( "DHTML" )
	JS_Language( HTML )
	JS_Workshop( HTML )

	ws_save = WorkshopFileBase( "save", { "save" } )
	ws_save.HTML = HTML

	HTML:OpenURL( "asset://garrysmod/html/saves.html" )
	HTML:Call( "SetMap( '" .. game.GetMap() .. "' );" )

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
		HTML:Call( "save.ReceiveLocal( " .. json .. " )" )

	end

	function ws_save:DownloadAndLoad( id )

		steamworks.DownloadUGC( id, function( name )

			ws_save:Load( name )

		end )

	end

	function ws_save:Load( filename ) RunConsoleCommand( "gm_load", filename ) end
	function ws_save:Publish( filename, imagename ) RunConsoleCommand( "save_publish", filename, imagename ) end

	return HTML

end, "icon16/disk_multiple.png", 200 )

hook.Add( "PostGameSaved", "OnCreationsSaved", function()

	if ( !HTML ) then return end

	HTML:Call( "OnGameSaved()" )

end )
