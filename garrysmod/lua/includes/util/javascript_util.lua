
function JS_Language( html )

	html:AddFunction( "language", "Update", function( phrase )

		return language.GetPhrase( phrase );

	end )

end

function JS_Utility( html )

	html:AddFunction( "util", "MotionSensorAvailable", function()

		return motionsensor.IsAvailable()

	end )

end

function JS_Workshop( html )

	html:AddFunction( "gmod", "OpenWorkshopFile", function( param ) steamworks.ViewFile( param ) end )
	html:AddFunction( "gmod", "DeleteLocal", function( param ) file.Delete( param, "MOD" ) end )
	html:AddFunction( "gmod", "FetchItems", function( namespace, cat, offset, perpage, ... ) _G[ namespace ]:Fetch( cat, tonumber( offset ), tonumber( perpage ), { ... } ) end )
	html:AddFunction( "gmod", "Vote", function( id, vote ) steamworks.Vote( id, tobool( vote ) ) end )
	html:AddFunction( "gmod", "Publish", function( namespace, file, background ) _G[ namespace ]:Publish( file, background ) end )

	// Dupes
	html:AddFunction( "gmod", "DownloadDupe", function( param ) ws_dupe:DownloadAndArm( param ) end )
	html:AddFunction( "gmod", "ArmDupe", function( param ) ws_dupe:Arm( param ) end )
	html:AddFunction( "gmod", "SaveDupe", function( param ) RunConsoleCommand( "dupe_save", "spawnmenu" ) end )

	// Saves
	html:AddFunction( "gmod", "DownloadSave", function( param ) ws_save:DownloadAndLoad( param ) end )
	html:AddFunction( "gmod", "LoadSave", function( param ) ws_save:Load( param ) end )
	html:AddFunction( "gmod", "SaveSave", function( param ) RunConsoleCommand( "gm_save", "spawnmenu" ) end )

end
