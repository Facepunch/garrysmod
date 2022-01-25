--
--
-- worldpicker is for picking an entity from the game while you have the GUI open.
-- Calling util.worldpicker.Start( func ) will hide all GUI and let you pick an entity from
-- the game world. Once selected it will call your passed function with the trace.
--
-- It's used in the icon editor
--
--

local bDoing = false
local fnAction = nil

util.worldpicker = {
	--
	-- Start world picking
	--
	Start = function( func )

		bDoing = true
		fnAction = func
		gui.EnableScreenClicker( true )

	end,

	--
	-- Finish world picking - you shouldn't have to call this (called from hook below)
	--
	Finish = function( tr )

		bDoing = false
		fnAction( tr )
		gui.EnableScreenClicker( false )

	end,

	Active = function() return bDoing end
}

hook.Add( "VGUIMousePressAllowed", "WorldPickerMouseDisable", function( code )

	if ( !bDoing ) then return false end

	local dir = gui.ScreenToVector( gui.MousePos() )
	local tr = util.TraceLine( {
		start = LocalPlayer():GetShootPos(),
		endpos = LocalPlayer():GetShootPos() + dir * 32768,
		filter = LocalPlayer()
	} )

	util.worldpicker.Finish( tr )

	-- Don't register this click
	return true

end )
