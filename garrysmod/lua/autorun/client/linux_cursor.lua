
if ( SERVER ) then return end

if ( not system.IsLinux() ) then return end

local lastX = ScrW() / 2
local lastY = ScrH() / 2
local forceFrames = 3

hook.Add( "OnSpawnMenuClose", "SaveMenuCursorLinux", function()

	lastX, lastY = input.GetCursorPos()

end )

hook.Add( "OnSpawnMenuOpen", "RestoreMenuCursorLinux", function()

	local framesCount = 0

	hook.Add( "Think", "ForceCursorPosLinuxFix", function()

		if ( not g_SpawnMenu:IsVisible() ) then

			hook.Remove( "Think", "ForceCursorPosLinuxFix" )
			return

		end

		input.SetCursorPos( lastX, lastY )

		framesCount = forceFrames + 1

		if ( framesCount >= forceFrames ) then

			hook.Remove( "Think", "ForceCursorPosLinuxFix" )

		end

	end )

end )
