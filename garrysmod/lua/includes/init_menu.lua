
--[[---------------------------------------------------------
	Non-Module includes
-----------------------------------------------------------]]
include( "util.lua" )
include( "util/sql.lua" ) -- Include sql here so it's available at loadtime to modules.


--[[---------------------------------------------------------
	Modules
-----------------------------------------------------------]]
require( "concommand" )
require( "list" )
require( "hook" )
require( "draw" )
require( "http" )
require( "cvars" )
require( "cookie" )
require( "baseclass" )

--[[---------------------------------------------------------
	Extensions

	Load extensions that we specifically need for the menu,
	to reduce the chances of loading something that might
	cause errors.
-----------------------------------------------------------]]
include( "extensions/string.lua" )
include( "extensions/table.lua" )
include( "extensions/math.lua" )
include( "extensions/client/panel.lua" )
include( "extensions/util.lua" )
include( "extensions/file.lua" )
include( "extensions/debug.lua" )
include( "extensions/client/render.lua" )

include( "util/vgui_showlayout.lua" )
include( "util/workshop_files.lua" )
include( "util/javascript_util.lua" )
include( "util/tooltips.lua" )

require( "notification" )
