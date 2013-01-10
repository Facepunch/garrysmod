--[[__                                       _     
 / _| __ _  ___ ___ _ __  _   _ _ __   ___| |__  
| |_ / _` |/ __/ _ \ '_ \| | | | '_ \ / __| '_ \ 
|  _| (_| | (_|  __/ |_) | |_| | | | | (__| | | |
|_|  \__,_|\___\___| .__/ \__,_|_| |_|\___|_| |_|
                   |_| 2012 --]]
                   
vid_width	= CreateConVar( "vid_width",	"640", { FCVAR_ARCHIVE } )
vid_fps		= CreateConVar( "vid_fps",		"30", { FCVAR_ARCHIVE } )

concommand.Add( "gm_video", function()

	if ( ActiveVideo ) then
	
		ActiveVideo:Finish()
		ActiveVideo = nil
		return 
		
	end

	local dynamic_name = game.GetMap() .." ".. util.DateStamp()

	ActiveVideo, error = video.Record( 
	{
		name		= dynamic_name,
		container	= "webm",
		video		= "vp8",
		audio		= "vorbis",
		quality		= 0,
		bitrate		= 1024 * 64,
		width		= vid_width:GetFloat(),
		height		= ScrH() * (vid_width:GetFloat() / ScrW()),
		fps			= vid_fps:GetFloat(),
		lockfps		= true
		
	});
	
	if ( !ActiveVideo ) then
	
		MsgN( "Couldn't record video: ", error )
		return
	
	end

end, nil, "", { FCVAR_DONTRECORD } )


hook.Add( "DrawOverlay", "CaptureFrames", function()

	if ( !ActiveVideo ) then return end
	
	ActiveVideo:AddFrame( FrameTime(), true );

end )
