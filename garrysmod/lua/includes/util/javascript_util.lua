
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
	html:AddFunction( "gmod", "SaveDupe", function( param ) RunConsoleCommand( "dupe_save", "spawnmenu" ) end )
	html:AddFunction( "gmod", "DeleteLocal", function( param ) file.Delete( param, "MOD" ) end )
	html:AddFunction( "gmod", "FetchItems", function( param )
		local params = string.Explode( " ", param )
		local namespace = params[ 1 ]
		local t = {}
		for i = 5, #params do
			table.insert( t, params[ i ] ) 
		end
		_G[ namespace ]:Fetch( params[ 2 ], tonumber( params[ 3 ] ), tonumber( params[ 4 ] ), t )
	end )
	html:AddFunction( "gmod", "Vote", function( param )
		local params = string.Explode( " ", param )
		steamworks.Vote( params[ 1 ], tobool( params[ 2 ] ) )
	end )
	html:AddFunction( "gmod", "Publish", function( param )
		local params = string.Explode( " ", param )
		local namespace = params[ 1 ]

		_G[ namespace ]:Publish( params[ 2 ], params[ 3 ] )
	end )

	// Dupes
	html:AddFunction( "gmod", "DownloadDupe", function( param ) ws_dupe:DownloadAndArm( param ) end )
	html:AddFunction( "gmod", "ArmDupe", function( param ) ws_dupe:Arm( param ) end )

	// Saves
	html:AddFunction( "gmod", "DownloadSave", function( param ) ws_save:DownloadAndLoad( param ) end )
	html:AddFunction( "gmod", "LoadSave", function( param ) ws_save:Load( param ) end )

end
