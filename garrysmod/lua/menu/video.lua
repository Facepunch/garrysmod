
local vid_width = CreateConVar( "vid_width", "640", { FCVAR_ARCHIVE + FCVAR_DONTRECORD }, "Specifies the width of the recorded video. The height will be adjusted automatically based on your aspect ratio" )
local vid_fps   = CreateConVar( "vid_fps",   "30",  { FCVAR_ARCHIVE + FCVAR_DONTRECORD }, "The FPS of the recorded video" )
local vid_sound = CreateConVar( "vid_sound", "1",   { FCVAR_ARCHIVE + FCVAR_DONTRECORD }, "Enable sound recording" )

local activeVideo
local videoStart

concommand.Add( "gm_video", function()
	if ( activeVideo ) then
		activeVideo:Finish()
		activeVideo = nil

		local time = SysTime() - videoStart
		MsgN( string.format( "Finished recording. Length: %.1fs", time ) )

		return
	end

	local dynamic_name = game.GetMap() .. " " .. util.DateStamp()

	local width = math.Round( vid_width:GetFloat() )
	local height = math.Round( ScrH() * ( width / ScrW() ) )
	local fps = math.Round( vid_fps:GetFloat() )

	local err

	activeVideo, err = video.Record( {
		name      = dynamic_name,
		container = "webm",
		video     = "vp8",
		audio     = "vorbis",
		quality   = 0,
		bitrate   = 1024 * 64,
		width     = width,
		height    = height,
		fps       = fps,
		lockfps   = true
	} )

	if ( !activeVideo ) then
		MsgN( "Couldn't record video: ", err )
		return
	end

	activeVideo:SetRecordSound( vid_sound:GetBool() )

	videoStart = SysTime()

	MsgN( string.format( "Recording %ix%i@%iFPS video to \"videos/%s.webm\"...", width, height, fps, dynamic_name ) )

end, nil, "Starts and stops the recording of a .webm (VP8/Vorbis) video. See vid_* convars for settings.", { FCVAR_DONTRECORD } )

hook.Add( "DrawOverlay", "CaptureFrames", function()

	if ( !activeVideo ) then return end

	activeVideo:AddFrame( FrameTime(), true )

end )
