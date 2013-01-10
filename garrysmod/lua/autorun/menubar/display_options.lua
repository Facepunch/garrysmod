
hook.Add( "PopulateMenuBar", "DisplayOptions_MenuBar", function( menubar )

	local m = menubar:AddOrGetMenu( "Drawing" )
	
	m:AddCVar( "Physgun Grab Halo", "physgun_halo", "1", "0" )
	m:AddCVar( "Physgun Beams", "physgun_drawbeams", "1", "0" )
	
	m:AddSpacer()
	
	m:AddCVar( "Draw Freeze", "effects_freeze", "1", "0" )
	m:AddCVar( "Draw Unfreeze", "effects_unfreeze", "1", "0" )
	m:AddCVar( "Draw Thrusters", "cl_drawthrusterseffects", "1", "0" )
	m:AddCVar( "Draw Cameras", "cl_drawcameras", "1", "0" )
	m:AddCVar( "Draw Spawn Effect", "cl_drawspawneffect", "1", "0" )
	m:AddCVar( "Draw World Tooltips", "cl_drawworldtooltips", "1", "0" )
	
	m:AddSpacer()
		
	m:AddCVar( "Draw Shadows", "r_shadows", "1", "0" )	
	m:AddCVar( "Detail Props", "r_drawdetailprops", "1", "0" )
	
	m:AddSpacer()
	
	m:AddCVar( "Show FPS", "cl_showfps", "1", "0" )
	m:AddCVar( "Minecraftify", "mat_showlowresimage", "1", "0", function() timer.Simple( 0.1, function() RunConsoleCommand( "mat_reloadallmaterials" ) end ) end )
	m:AddCVar( "Wireframe", "mat_wireframe", "1", "0" )
	
	m:AddSpacer()	
	
	m:AddCVar( "Hints", "cl_showhints", "1", "0" )
	
end )

