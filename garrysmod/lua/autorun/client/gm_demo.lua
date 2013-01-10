
concommand.Add( "gm_demo", function( ply, cmd, arg )

	if ( engine.IsRecordingDemo() ) then
		RunConsoleCommand( "stop" );
		return
	end

	local dynamic_name = "demos/" .. game.GetMap() .." ".. util.DateStamp()

	RunConsoleCommand( "record", dynamic_name .. ".dem" )
	RunConsoleCommand( "record_screenshot", dynamic_name .. ".jpg" )

end )


local matRecording = nil

hook.Add( "HUDPaint", "DrawRecordingIcon", function()
	
	if ( !engine.IsRecordingDemo() ) then return end

	if ( !matRecording ) then
		matRecording = Material( "gmod/recording.png" )
	end

	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( matRecording )
	surface.DrawTexturedRect( ScrW()-512, 0, 512, 256, 0 ) 

end )