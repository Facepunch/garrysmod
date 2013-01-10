
demo = WorkshopFileBase( "demo", { "demo" } )


function demo:FetchLocal( offset, perpage )

	local f = file.Find( "demos/*.dem", "MOD", "datedesc" )

	local saves = {}

	for k, v in pairs( f ) do

		if ( k <= offset ) then continue end
		if ( k > offset + perpage ) then break end

		local entry = 
		{
			file	= "demos/" .. v,
			name	= v:StripExtension(),
			preview	= "demos/" .. v:StripExtension() .. ".jpg"
		}

		table.insert( saves, entry );

	end

	local results = 
	{
		totalresults	= #f,
		results			= saves
	}

	local json = util.TableToJSON( results, false );
	pnlMainMenu:Call( "demo.ReceiveLocal( "..json.." )" );

end


function demo:DownloadAndPlay( id )

	steamworks.Download( id, true, function( name )

		self:Play( name ); 

	end )

end


function demo:Play( filename )

	RunConsoleCommand( "playdemo", filename ); 

end

function demo:DownloadAndToVideo( id )

	steamworks.Download( id, true, function( name )

		self:ToVideo( name ); 

	end )

end


function demo:ToVideo( filename )

	RunConsoleCommand( "gm_demo_to_video", filename ); 

end

function demo:FinishPublish( filename, imagename, name, desc )

	local info = GetDemoFileDetails( filename )
	if ( !info ) then return "Couldn't get demo information!" end

	steamworks.Publish( { "demo", info.mapname }, filename, imagename, name, desc );

end

