
--[[---------------------------------------------------------
   Name: gamemode:PlayerSpawnObject( ply )
   Desc: Called to ask whether player is allowed to spawn any objects
-----------------------------------------------------------]]
function GM:PlayerSpawnObject( ply )
	return true
end

--[[---------------------------------------------------------
   Name: gamemode:CanPlayerUnfreeze( )
   Desc: Can the player unfreeze this entity & physobject
-----------------------------------------------------------]]
function GM:CanPlayerUnfreeze( ply, entity, physobject )

	if ( entity:GetPersistent() && GetConVarString( "sbox_persist" ):Trim() != "" ) then return false end

	return true
end

--[[---------------------------------------------------------
   Name: LimitReachedProcess
-----------------------------------------------------------]]
local function LimitReachedProcess( ply, str )

	if ( !IsValid( ply ) ) then return true end

	return ply:CheckLimit( str )

end


--[[---------------------------------------------------------
   Name: gamemode:PlayerSpawnRagdoll( ply, model )
   Desc: Return true if it's allowed 
-----------------------------------------------------------]]
function GM:PlayerSpawnRagdoll( ply, model )

	return LimitReachedProcess( ply, "ragdolls" )

end


--[[---------------------------------------------------------
   Name: gamemode:PlayerSpawnProp( ply, model )
   Desc: Return true if it's allowed 
-----------------------------------------------------------]]
function GM:PlayerSpawnProp( ply, model )

	return LimitReachedProcess( ply, "props" )

end

--[[---------------------------------------------------------
   Name: gamemode:PlayerSpawnEffect( ply, model )
   Desc: Return true if it's allowed 
-----------------------------------------------------------]]
function GM:PlayerSpawnEffect( ply, model )

	return LimitReachedProcess( ply, "effects" )

end

--[[---------------------------------------------------------
   Name: gamemode:PlayerSpawnVehicle( ply, model, vname, vtable )
   Desc: Return true if it's allowed 
-----------------------------------------------------------]]
function GM:PlayerSpawnVehicle( ply, model, vname, vtable )

	return LimitReachedProcess( ply, "vehicles" )

end


--[[---------------------------------------------------------
   Name: gamemode:PlayerSpawnSWEP( ply, wname, wtable )
   Desc: Return true if it's allowed 
-----------------------------------------------------------]]
function GM:PlayerSpawnSWEP( ply, wname, wtable )

	return LimitReachedProcess( ply, "sents" )
	
end


--[[---------------------------------------------------------
   Name: gamemode:PlayerGiveSWEP( ply, wname, wtable )
   Desc: Return true if it's allowed 
-----------------------------------------------------------]]
function GM:PlayerGiveSWEP( ply, wname, wtable )

	return true

end


--[[---------------------------------------------------------
   Name: gamemode:PlayerSpawnSENT( ply, name )
   Desc: Return true if player is allowed to spawn the SENT
-----------------------------------------------------------]]
function GM:PlayerSpawnSENT( ply, name )

	return LimitReachedProcess( ply, "sents" )

end

--[[---------------------------------------------------------
   Name: gamemode:PlayerSpawnNPC( ply, npc_type )
   Desc: Return true if player is allowed to spawn the NPC
-----------------------------------------------------------]]
function GM:PlayerSpawnNPC( ply, npc_type, equipment )

	return LimitReachedProcess( ply, "npcs" )

end

--[[---------------------------------------------------------
   Name: gamemode:PlayerSpawnedRagdoll( ply, model, ent )
   Desc: Called after the player spawned a ragdoll
-----------------------------------------------------------]]
function GM:PlayerSpawnedRagdoll( ply, model, ent )

	ply:AddCount( "ragdolls", ent )

end

--[[---------------------------------------------------------
   Name: gamemode:PlayerSpawnedProp( ply, model, ent )
   Desc: Called after the player spawned a prop
-----------------------------------------------------------]]
function GM:PlayerSpawnedProp( ply, model, ent )

	ply:AddCount( "props", ent )

end

--[[---------------------------------------------------------
   Name: gamemode:PlayerSpawnedEffect( ply, model, ent )
   Desc: Called after the player spawned an effect
-----------------------------------------------------------]]
function GM:PlayerSpawnedEffect( ply, model, ent )

	ply:AddCount( "effects", ent )

end

--[[---------------------------------------------------------
   Name: gamemode:PlayerSpawnedVehicle( ply, ent )
   Desc: Called after the player spawned a vehicle
-----------------------------------------------------------]]
function GM:PlayerSpawnedVehicle( ply, ent )

	ply:AddCount( "vehicles", ent )

end

--[[---------------------------------------------------------
   Name: gamemode:PlayerSpawnedNPC( ply, ent )
   Desc: Called after the player spawned an NPC
-----------------------------------------------------------]]
function GM:PlayerSpawnedNPC( ply, ent )

	ply:AddCount( "npcs", ent )

end


--[[---------------------------------------------------------
   Name: gamemode:PlayerSpawnedSENT( ply, ent )
   Desc: Called after the player has spawned a SENT
-----------------------------------------------------------]]
function GM:PlayerSpawnedSENT( ply, ent )

	ply:AddCount( "sents", ent )

end

--[[---------------------------------------------------------
   Name: gamemode:PlayerSpawnedWeapon( ply, ent )
   Desc: Called after the player has spawned a Weapon
-----------------------------------------------------------]]
function GM:PlayerSpawnedSWEP( ply, ent )

	-- This is on purpose..
	ply:AddCount( "sents", ent )

end

--[[---------------------------------------------------------
   Name: gamemode:PlayerEnteredVehicle( player, vehicle, role )
   Desc: Player entered the vehicle fine
-----------------------------------------------------------]]
function GM:PlayerEnteredVehicle( player, vehicle, role )

	player:SendHint( "VehicleView", 2 )

end

--[[---------------------------------------------------------
	These are buttons that the client is pressing. They're used
	in Sandbox mode to control things like wheels, thrusters etc.
-----------------------------------------------------------]]
function GM:PlayerButtonDown( ply, btn ) 

	numpad.Activate( ply, btn )

end

--[[---------------------------------------------------------
	These are buttons that the client is pressing. They're used
	in Sandbox mode to control things like wheels, thrusters etc.
-----------------------------------------------------------]]
function GM:PlayerButtonUp( ply, btn ) 

	numpad.Deactivate( ply, btn )

end
