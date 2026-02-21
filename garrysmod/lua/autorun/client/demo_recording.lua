
if ( !engine.IsPlayingDemo() ) then return end

local VideoSettings = engine.VideoSettings()
if ( !VideoSettings ) then return end

PrintTable( VideoSettings )

local SmoothedAng = nil
local SmoothedFOV = nil
local SmoothedPos = nil
local AutoFocusPoint = nil

hook.Add( "Initialize", "DemoRenderInit", function()

	if ( VideoSettings.frameblend < 2 ) then
		RunConsoleCommand( "pp_fb", "0" )
	else
		RunConsoleCommand( "pp_fb", "1" )
		RunConsoleCommand( "pp_fb_frames", VideoSettings.frameblend )
		RunConsoleCommand( "pp_fb_shutter", VideoSettings.fbshutter )
	end

end )

hook.Add( "RenderScene", "RenderForDemo", function( ViewOrigin, ViewAngles, ViewFOV )

	if ( !engine.IsPlayingDemo() ) then return false end

	render.Clear( 0, 0, 0, 255, true, true )

	local FramesPerFrame = 1

	if ( frame_blend.IsActive() ) then

		FramesPerFrame = frame_blend.RenderableFrames()
		frame_blend.AddFrame()

		if ( frame_blend.ShouldSkipFrame() ) then

			frame_blend.DrawPreview()
			return true

		end

	end

	if ( !SmoothedAng ) then SmoothedAng = ViewAngles * 1 end
	if ( !SmoothedFOV ) then SmoothedFOV = ViewFOV end
	if ( !SmoothedPos ) then SmoothedPos = ViewOrigin * 1 end
	if ( !AutoFocusPoint ) then AutoFocusPoint = SmoothedPos * 1 end

	if ( VideoSettings.viewsmooth > 0 ) then
		SmoothedAng = LerpAngle( ( 1 - VideoSettings.viewsmooth ) / FramesPerFrame, SmoothedAng, ViewAngles )
		SmoothedFOV = Lerp( ( 1 - VideoSettings.viewsmooth ) / FramesPerFrame, SmoothedFOV, ViewFOV )
	else
		SmoothedAng = ViewAngles * 1
		SmoothedFOV = ViewFOV
	end

	if ( VideoSettings.possmooth > 0 ) then
		SmoothedPos = LerpVector( ( 1 - VideoSettings.possmooth ) / FramesPerFrame, SmoothedPos, ViewOrigin )
	else
		SmoothedPos = ViewOrigin * 1
	end

	local view = {
		x				= 0,
		y				= 0,
		w				= math.Round( VideoSettings.width ),
		h				= math.Round( VideoSettings.height ),
		angles			= SmoothedAng,
		origin			= SmoothedPos,
		fov				= SmoothedFOV,
		drawhud			= false,
		drawviewmodel	= true,
		dopostprocess	= true,
		drawmonitors	= true
	}

	if ( VideoSettings.dofsteps && VideoSettings.dofpasses ) then

		local trace = util.TraceHull( {
			start	= view.origin,
			endpos	= view.origin + ( view.angles:Forward() * 8000 ),
			mins	= Vector( -2, -2, -2 ),
			maxs	= Vector( 2, 2, 2 ),
			filter	= { GetViewEntity() }
		} )

		local focuspeed = math.Clamp( ( VideoSettings.doffocusspeed / FramesPerFrame ) * 0.2, 0, 1 )
		AutoFocusPoint = LerpVector( focuspeed, AutoFocusPoint, trace.HitPos )
		local UsableFocusPoint = view.origin + view.angles:Forward() * AutoFocusPoint:Distance( view.origin )

		RenderDoF( view.origin, view.angles, UsableFocusPoint, VideoSettings.dofsize * 0.3, VideoSettings.dofsteps, VideoSettings.dofpasses, false, table.Copy( view ) )

	else

		render.RenderView( view )

	end

	-- TODO: IF RENDER HUD
	render.RenderHUD( 0, 0, view.w, view.h )

	local ShouldRecordThisFrme = frame_blend.IsLastFrame()

	if ( frame_blend.IsActive() ) then

		frame_blend.BlendFrame()
		frame_blend.DrawPreview()

	end

	if ( ShouldRecordThisFrme ) then
		menu.RecordFrame()
	end

	return true

end )
