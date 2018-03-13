
include( "mount/mount.lua" )
include( "getmaps.lua" )
include( "loading.lua" )

// To uninstall, change the 1 to 0 below
local useNewMenu = 0

// Do not touch anything below
if ( useNewMenu == 1 ) then
	include( "custom/mainmenu.lua" )
else
	include( "mainmenu.lua" )
end

include( "video.lua" )
include( "demo_to_video.lua" )

include( "menu_save.lua" )
include( "menu_demo.lua" )
include( "menu_addon.lua" )
include( "menu_dupe.lua" )
include( "errors.lua" )

include( "motionsensor.lua" )
include( "util.lua" )

concommand.Add( "lua", function( ply, cmd, args, str )
	if ( IsInGame() ) then return end
	RunString( str )
end )
