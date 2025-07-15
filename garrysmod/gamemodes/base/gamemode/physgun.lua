
--[[---------------------------------------------------------
   Name: gamemode:PhysgunDrop( )
   Desc: Dropped an entity
-----------------------------------------------------------]]
function GM:PhysgunDrop( ply, ent )
    if SERVER then
        ent.PickupPlayer = nil -- Clear the player who picked it up
    end
end

--[[---------------------------------------------------------
   Name: gamemode:PhysgunPickup( )
   Desc: Return true if player can pickup entity
-----------------------------------------------------------]]
function GM:PhysgunPickup( ply, ent )

	-- Don't pick up players
	if ( ent:GetClass() == "player" ) then return false end

	return true
end

if ( SERVER ) then

    --[[---------------------------------------------------------
    Name: gamemode:OnPhysgunPickup()
    Desc: Called to when a player has successfully picked up an entity with their Physics Gun.
    -----------------------------------------------------------]]
    function GM:OnPhysgunPickup( ply, ent )
        ent.PickupPlayer = ply -- Store the player who picked it up
        return true
    end

	--[[---------------------------------------------------------
	   Name: gamemode:OnPhysgunReload()
	   Desc: Called when a player reloads with the physgun
	-----------------------------------------------------------]]
	function GM:OnPhysgunReload( ply, ent )
		return true
	end

	--[[---------------------------------------------------------
	   Name: gamemode:OnPhysgunFreeze()
	   Desc: Called when a player freezes an entity with the physgun.
	-----------------------------------------------------------]]
	function GM:OnPhysgunFreeze( ply, ent )
		return true
	end
end
