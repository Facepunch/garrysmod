-- This hook fixes a bug where entering a vehicle that is parented to you, or to an entity that is parented to you, will crash the server.

local nextPrint = {} -- used to prevent message spam
hook.Add( "CanPlayerEnterVehicle", "check vehicle parented to player", function( ply, veh )
	local parent = veh:GetParent()
	while IsValid( parent ) do
		if parent == ply then -- player detected! block this
			if not nextPrint[ply] or nextPrint[ply] < RealTime() then
				ply:ChatPrint( "You can't enter this vehicle because it is parented to you." )
				nextPrint[ply] = RealTime() + 0.3
			end
			return false
		end
		if parent == veh then return end -- parent loop? this should've crashed the server already but okay
		parent = parent:GetParent()
	end
end )
