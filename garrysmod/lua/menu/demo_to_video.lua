
local ActiveVideo = nil

VideoSettings = nil

local stats = {
	reset = 0,
	encodetime = 0,

	starttime = 0,
	last_encodetime = 0
}

concommand.Add( "gm_demo_to_video", function( ply, cmd, args )

	local demoname = args[ 1 ]
	if ( !demoname ) then return end

	local settings = {
		name		= "filled_in_later",
		container	= "webm",
		video		= "vp8",
		audio		= "vorbis",
		bitrate		= 25000,
		quality		= 1,
		width		= 640,
		height		= 480,
		fps			= 25,
		frameblend	= 1,
		fbshutter	= 0.5,
		dofsteps	= 0,
		dofpasses	= 0,
		doffocusspeed	= 1.0,
		dofsize		= 1.0,
		viewsmooth	= 0.0,
		possmooth	= 0.0
	}

	local Window = vgui.Create( "DFrame" )
	Window:SetTitle( "Render Video" )
	Window:SetSize( 600, 400 )
	Window:LoadGWENFile( "resource/ui/DemoToVideo.gwen" )
	Window:Center()
	Window:MakePopup()

	local inCodec		= Window:Find( "inCodec" )
	local inQuality		= Window:Find( "inQuality" )
	local inSize		= Window:Find( "inSize" )
	local btnStart		= Window:Find( "btnStart" )
	local inBitRate		= Window:Find( "inBitRate" )
	local inFPS			= Window:Find( "inFPS" )
	local inFrameBlend	= Window:Find( "inFrameBlend" )
	local inFBShutter	= Window:Find( "inFBShutter" )
	local inDOF			= Window:Find( "inDepthOfField" )
	local inDOFSpeed	= Window:Find( "inDOFFocusSpeed" )
	local inDOFSize		= Window:Find( "inDOFBlurSize" )
	local inViewSmooth	= Window:Find( "inViewSmooth" )
	local inPosSmooth	= Window:Find( "inPosSmooth" )

	inFPS.OnChange = function() settings.fps = inFPS:GetInt() end
	inFPS:SetText( settings.fps )

	inBitRate.OnChange = function() settings.bitrate = inBitRate:GetInt() end
	inBitRate:SetText( settings.bitrate )

	-- TODO!!!
	inCodec.OnSelect = function( _, index, value, data ) settings.container = data[1]; settings.video = data[2]; settings.audio = data[3] end
	inCodec:AddChoice( "webm", { "webm", "vp8", "vorbis" }, true )
	inCodec:AddChoice( "ogg", { "ogg", "theora", "vorbis" } )

	inQuality.OnSelect = function( _, index, value, data ) settings.quality = data end
	inQuality:AddChoice( "0.0 - Low (but fast)", 0 )
	inQuality:AddChoice( "0.5 - Medium", 0.5 )
	inQuality:AddChoice( "1.0 - Highest (but slow)", 1, true )

	-- TODO!!!
	inSize.OnSelect = function( _, index, value, data ) settings.width = data[1] settings.height = data[2] end
	inSize:AddChoice( ScrW() .. " x " .. ScrH() .. " (highest)", { ScrW(), ScrH() }, true )
	inSize:AddChoice( math.ceil( ScrW() * 0.66666 ) .. " x " .. math.ceil( ScrH() * 0.66666 ), { ScrW() * 0.666666, ScrH() * 0.666666 } )
	inSize:AddChoice( math.ceil( ScrW() * 0.33333 ) .. " x " .. math.ceil( ScrH() * 0.33333 ), { ScrW() * 0.333333, ScrH() * 0.333333 } )

	inFrameBlend.OnSelect = function( _, index, value, data ) settings.frameblend = data end
	inFrameBlend:AddChoice( "Off", 1, true )
	inFrameBlend:AddChoice( "Draft (8 Samples)", 8 )
	inFrameBlend:AddChoice( "Good (16 Samples)", 16 )
	inFrameBlend:AddChoice( "Great (32 Samples)", 32 )
	inFrameBlend:AddChoice( "Overkill (64 Samples)", 64 )
	inFrameBlend:AddChoice( "OverOverKill (128 Samples)", 128 )

	inFBShutter.OnSelect = function( _, index, value, data ) settings.fbshutter = data end
	inFBShutter:AddChoice( "90", 0.75 )
	inFBShutter:AddChoice( "180", 0.5, true )
	inFBShutter:AddChoice( "240", 0.25 )
	inFBShutter:AddChoice( "360", 0.0 )

	--
	-- DOF
	--
	inDOF.OnSelect = function( _, index, value, data ) settings.dofsteps = data[1]; settings.dofpasses = data[2] end
	inDOF:AddChoice( "Off",	{ 0, 0 }, true )
	inDOF:AddChoice( "Draft (21 Samples)", { 6, 3 } )
	inDOF:AddChoice( "Good (72 Samples)", { 12, 6 } )
	inDOF:AddChoice( "Best (288 Samples)", { 24, 12 } )

	inDOFSpeed.OnChange = function() settings.doffocusspeed = inDOFSpeed:GetFloat() end
	inDOFSpeed:SetText( "1.0" )

	inDOFSize.OnChange = function() settings.dofsize = inDOFSize:GetFloat() end
	inDOFSize:SetText( "1.0" )

	--
	-- Smoothing
	--
	inViewSmooth.OnSelect = function( _, index, value, data ) settings.viewsmooth = data end
	inViewSmooth:AddChoice( "Off",			0.0, true )
	inViewSmooth:AddChoice( "Minimal",		0.2 )
	inViewSmooth:AddChoice( "Low",			0.4 )
	inViewSmooth:AddChoice( "Medium",		0.7 )
	inViewSmooth:AddChoice( "High",			0.8 )
	inViewSmooth:AddChoice( "Lots",			0.9 )
	inViewSmooth:AddChoice( "Too Smooth",	0.97 )

	inPosSmooth.OnSelect = function( _, index, value, data ) settings.possmooth = data end
	inPosSmooth:AddChoice( "Off",			0.0, true )
	inPosSmooth:AddChoice( "Minimal",		0.2 )
	inPosSmooth:AddChoice( "Low",			0.4 )
	inPosSmooth:AddChoice( "Medium",		0.7 )
	inPosSmooth:AddChoice( "High",			0.8 )
	inPosSmooth:AddChoice( "Lots",			0.9 )
	inPosSmooth:AddChoice( "Too Smooth",	0.97 )

	btnStart.DoClick = function()

		-- Fill in the name here, or we'll be overwriting the same video!
		local cleanname = string.GetFileFromFilename( demoname )
		cleanname = cleanname:Replace( ".", "_" )
		cleanname = cleanname .. " " .. util.DateStamp()
		settings.name = cleanname

		PrintTable( settings )
		ActiveVideo, error = video.Record( settings )

		if ( !ActiveVideo ) then
			MsgN( "Couldn't record video: ", error )
			return
		end

		RunConsoleCommand( "sv_cheats",			1 )
		RunConsoleCommand( "host_framerate",	settings.fps * settings.frameblend )
		RunConsoleCommand( "snd_fixed_rate",	1 )
		RunConsoleCommand( "progress_enable",	1 )
		RunConsoleCommand( "playdemo",			demoname )

		VideoSettings = table.Copy( settings )

		--Window:Remove()

	end

end, nil, "", { FCVAR_DONTRECORD } )

local function FinishRecording()

	VideoSettings = nil
	ActiveVideo:Finish()
	ActiveVideo = nil

	RunConsoleCommand( "host_framerate", 0 )
	RunConsoleCommand( "sv_cheats", 0 )
	RunConsoleCommand( "snd_fixed_rate", 0 )

	MsgN( "Rendering Finished - Took ", SysTime() - stats.starttime, " seconds" )

end



local function UpdateFrame()

	if ( !engine.IsPlayingDemo() ) then

		if ( !VideoSettings.started ) then return end
		FinishRecording()
		return

	end

	if ( !VideoSettings.started ) then

		if ( gui.IsGameUIVisible() ) then return end

		VideoSettings.started = true
		VideoSettings.framecount = 0
		stats.starttime = SysTime()

	end

end


local function DrawOverlay()

	if ( !VideoSettings ) then return end

	local complete = engine.GetDemoPlaybackTick() / engine.GetDemoPlaybackTotalTicks()

	local x = ScrW()*0.1
	local y = ScrH()*0.8
	local w = ScrW()*0.8
	local h = ScrH()*0.05

	surface.SetFont( "DermaDefault" )
	surface.SetTextColor( 255, 255, 255, 255 )

	surface.SetDrawColor( 0, 0, 0, 50 )
	surface.DrawRect( x-3, y-3, w+6, h+6 )

	surface.SetDrawColor( 255, 255, 255, 200 )
	surface.DrawRect( x-2, y-2, w+4, 2 )
	surface.DrawRect( x-2, y, 2, h )
	surface.DrawRect( x+w, y, 2, h )
	surface.DrawRect( x-2, y+h, w+4, 2 )

	surface.SetDrawColor( 255, 255, 100, 150 )
	surface.DrawRect( x+1, y+1, w * complete - 2, h - 2 )

	surface.SetTextPos( x, y + h + 10 )
	surface.DrawText( "Time Taken: " .. string.NiceTime( SysTime() - stats.starttime ) )

	local tw, th = surface.GetTextSize( "Time Left: " .. string.NiceTime( stats.timeremaining ) )
	surface.SetTextPos( x + w - tw, y + h + 10 )
	surface.DrawText( "Time Left: " .. string.NiceTime( stats.timeremaining ) )

	local demolength = "Demo Length: ".. string.FormattedTime( engine.GetDemoPlaybackTotalTicks() * engine.TickInterval(), "%2i:%02i" )
	local tw, th = surface.GetTextSize( demolength )
	surface.SetTextPos( x + w - tw, y - th - 10 )
	surface.DrawText( demolength )

	local info = "Rendering ".. math.floor( VideoSettings.width ) .. "x" .. math.floor( VideoSettings.height ) .. " at " .. math.floor( VideoSettings.fps ).. "fps "

	local with = {}
	if ( VideoSettings.dofsteps > 0 ) then table.insert( with, "DOF" ) end
	if ( VideoSettings.frameblend > 1 ) then table.insert( with, "Frame Blending" ) end
	if ( VideoSettings.viewsmooth > 0 ) then table.insert( with, "View Smoothing" ) end
	if ( VideoSettings.possmooth > 0 ) then table.insert( with, "Position Smoothing" ) end

	if ( #with > 0 ) then
		with = string.Implode( ", ", with )
		info = info .. "with " .. with
	end

	info = info .. " (rendering " .. (VideoSettings.frameblend*VideoSettings.dofsteps*VideoSettings.dofpasses) .. " frames per frame)"

	local tw, th = surface.GetTextSize( info )
	surface.SetTextPos( x, y - th - 10 )
	surface.DrawText( info )

	local demotime = string.FormattedTime( (engine.GetDemoPlaybackTick() * engine.TickInterval()), "%2i:%02i" )
	local tw, th = surface.GetTextSize( demotime )
	if ( w * complete > tw + 20 ) then
		surface.SetTextColor( 0, 0, 0, 200 )
		surface.SetTextPos( x + w * complete - tw - 10, y + h * 0.5 - th * 0.5 )
		surface.DrawText( demotime )
	end

	local demotime = string.FormattedTime( ((engine.GetDemoPlaybackTotalTicks()-engine.GetDemoPlaybackTick()) * engine.TickInterval()), "%2i:%02i" )
	local tw, th = surface.GetTextSize( demotime )
	if ( w - w * complete > tw + 20 ) then
		surface.SetTextColor( 255, 255, 255, 200 )
		surface.SetTextPos( x + w * complete + 10, y + h * 0.5 - th * 0.5 )
		surface.DrawText( demotime )
	end

end

hook.Add( "CaptureVideo", "CaptureDemoFrames", function()

	if ( !ActiveVideo ) then return end
	if ( !VideoSettings ) then return end

	UpdateFrame()

	DrawOverlay()

	if ( stats.reset < SysTime() ) then

		stats.reset = SysTime() + 1

		stats.last_encodetime = stats.encodetime
		stats.encodetime = 0

		local timetaken = SysTime() - stats.starttime
		local fractioncomplete = engine.GetDemoPlaybackTotalTicks() / engine.GetDemoPlaybackTick()

		stats.timeremaining = (timetaken * fractioncomplete) - timetaken
		if ( stats.timeremaining < 0 ) then stats.timeremaining = 0 end

	end

end )

function RecordDemoFrame()

	if ( !VideoSettings.started ) then return end

	ActiveVideo:AddFrame( 1 / VideoSettings.fps, true )
	VideoSettings.framecount = VideoSettings.framecount + 1

end