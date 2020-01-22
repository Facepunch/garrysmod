
local HTML				= nil
local DupeInClipboard	= false

spawnmenu.AddCreationTab( "#spawnmenu.category.dupes", function()

	HTML = vgui.Create( "DHTML" )
	JS_Language( HTML )
	JS_Workshop( HTML )

	ws_dupe = WorkshopFileBase( "dupe", { "dupe" } )
	ws_dupe.HTML = HTML

	HTML:OpenURL( "asset://garrysmod/html/dupes.html" )
	HTML:Call( "SetDupeSaveState( " .. tostring( DupeInClipboard ) .. " );" )

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
		HTML:Call( "dupe.ReceiveLocal( " .. json .. " )" )

	end

	function ws_dupe:Arm( filename )

		RunConsoleCommand( "dupe_arm", filename )

	end

	function ws_dupe:DownloadAndArm( id )

		MsgN( "Downloading Dupe..." )
		steamworks.DownloadUGC( id, function( name )

			MsgN( "Finished - arming!" )
			ws_dupe:Arm( name )

		end )

	end

	function ws_dupe:Publish( filename, imagename )

		RunConsoleCommand( "dupe_publish", filename, imagename )

	end

	return HTML

end, "icon16/control_repeat_blue.png", 200 )

hook.Add( "DupeSaveAvailable", "UpdateDupeSpawnmenuAvailable", function()

	DupeInClipboard = true

	if ( !IsValid( HTML ) ) then return end

	HTML:Call( "SetDupeSaveState( true );" )

end )

hook.Add( "DupeSaveUnavailable", "UpdateDupeSpawnmenuUnavailable", function()

	DupeInClipboard = false

	if ( !IsValid( HTML ) ) then return end

	HTML:Call( "SetDupeSaveState( false );" )

end )

hook.Add( "DupeSaved", "DuplicationSavedSpawnMenu", function()

	if ( !IsValid( HTML ) ) then return end

	HTML:Call( "ShowLocalDupes();" )

end )

concommand.Add( "dupe_show", function()

	g_SpawnMenu:OpenCreationMenuTab( "#spawnmenu.category.dupes" )

	timer.Simple( 1.0, function() if ( !IsValid( HTML ) ) then return end HTML:Call( "ShowLocalDupes();" ) end )

end, nil, "", { FCVAR_DONTRECORD } )
