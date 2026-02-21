
--[[---------------------------------------------------------
   Name: gamemode:GravGunPunt()
   Desc: We're about to punt an entity (primary fire).
		 Return true if we're allowed to.
-----------------------------------------------------------]]
function GM:GravGunPunt( ply, ent )
	return true
end

--[[---------------------------------------------------------
	Name: gamemode:GravGunPickupAllowed()
	Desc: Return true if we're allowed to pickup entity
-----------------------------------------------------------]]
function GM:GravGunPickupAllowed( ply, ent )
	return true
end

if ( SERVER ) then

	--[[---------------------------------------------------------
	   Name: gamemode:GravGunOnPickedUp()
	   Desc: The entity has been picked up
	-----------------------------------------------------------]]
	function GM:GravGunOnPickedUp( ply, ent )
	end


	--[[---------------------------------------------------------
	   Name: gamemode:GravGunOnDropped()
	   Desc: The entity has been dropped
	-----------------------------------------------------------]]
	function GM:GravGunOnDropped( ply, ent )
	end

end
