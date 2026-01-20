
demo = WorkshopFileBase( "demo", { "demo" } )

function demo:FetchLocal( offset, perpage )

	local f = file.Find( "demos/*.dem", "MOD", "datedesc" )

	local saves = {}

	for k, v in ipairs( f ) do

		if ( k <= offset ) then continue end
		if ( k > offset + perpage ) then break end

		local entry = {
			file	= "demos/" .. v,
			name	= v:StripExtension(),
			preview	= "demos/" .. v:StripExtension() .. ".jpg",
			description	= language.GetPhrase( "demos.local_demo_notice" )
		}

		table.insert( saves, entry )

	end

	local results = {
		totalresults	= #f,
		results			= saves
	}

	local json = util.TableToJSON( results, false )
	pnlMainMenu:Call( "demo.ReceiveLocal( " .. json .. " )" )

end

function demo:DownloadAndPlay( id )

	steamworks.DownloadUGC( id, function( name )
		if ( !name ) then hook.Call( "LoadGModSaveFailed", nil, language.GetPhrase( "demos.demo_download_failed_notice" ) ) return end

		self:Play( name )

	end )

end

function demo:Play( filename )

	RunConsoleCommand( "progress_enable", "1" )
	RunConsoleCommand( "playdemo", filename )

end

function demo:DownloadAndToVideo( id )

	steamworks.DownloadUGC( id, function( name )
		if ( !name ) then hook.Call( "LoadGModSaveFailed", nil, language.GetPhrase( "demos.demo_download_failed_notice" ) ) return end

		self:ToVideo( name )

	end )

end


function demo:ToVideo( filename )

	RunConsoleCommand( "gm_demo_to_video", filename )

end

function demo:FinishPublish( filename, imagename, name, desc, chosenTag, other )

	local info = GetDemoFileDetails( filename )
	if ( !info ) then return "Couldn't get demo information!" end

	steamworks.Publish( filename, imagename, name, desc, { "demo", info.mapname }, other.Callback, other.WorkshopID, other.ChangeNotes )

end
