
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

SWEP.Weight				= 5			-- Decides whether we should switch from/to this
SWEP.AutoSwitchTo		= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom		= true		-- Auto switch from if you pick up a better weapon


--[[---------------------------------------------------------
   Name: SWEP:OnRestore( )
   Desc: The game has just been reloaded. This is usually the right place
		 to call the GetNetworked* functions to restore the script's values.
-----------------------------------------------------------]]
function SWEP:OnRestore()
end


--[[---------------------------------------------------------
   Name: SWEP:AcceptInput( )
   Desc: Accepts input, return true to override/accept input
-----------------------------------------------------------]]
function SWEP:AcceptInput( name, activator, caller, data )

	return false
	
end


--[[---------------------------------------------------------
   Name: SWEP:KeyValue( )
   Desc: Called when a keyvalue is added to us
-----------------------------------------------------------]]
function SWEP:KeyValue( key, value )
end


--[[---------------------------------------------------------
   Name: SWEP:OnRemove( )
   Desc: Called just before entity is deleted
-----------------------------------------------------------]]
function SWEP:OnRemove()
end


--[[---------------------------------------------------------
   Name: SWEP:Equip( )
   Desc: A player or NPC has picked the weapon up
-----------------------------------------------------------]]
function SWEP:Equip( NewOwner )
end


--[[---------------------------------------------------------
   Name: SWEP:EquipAmmo( )
   Desc: The player has picked up the weapon and has taken the ammo from it
		 The weapon will be removed immidiately after this call.
-----------------------------------------------------------]]
function SWEP:EquipAmmo( NewOwner )
end


--[[---------------------------------------------------------
   Name: SWEP:OnDrop( )
   Desc: Weapon was dropped
-----------------------------------------------------------]]
function SWEP:OnDrop()
end


--[[---------------------------------------------------------
   Name: SWEP:ShouldDropOnDie( )
   Desc: Should this weapon be dropped when its owner dies?
-----------------------------------------------------------]]
function SWEP:ShouldDropOnDie()

	return true
	
end


--[[---------------------------------------------------------
   Name: SWEP:GetCapabilities( )
   Desc: For NPCs, returns what they should try to do with it.
-----------------------------------------------------------]]
function SWEP:GetCapabilities()

	return bit.bor( CAP_WEAPON_RANGE_ATTACK1, CAP_INNATE_RANGE_ATTACK1 )

end


--[[---------------------------------------------------------
   Name: SWEP:NPCShoot_Secondary( )
   Desc: NPC tried to fire secondary attack
-----------------------------------------------------------]]
function SWEP:NPCShoot_Secondary( ShootPos, ShootDir )

	self:SecondaryAttack()

end


--[[---------------------------------------------------------
   Name: SWEP:NPCShoot_Secondary( )
   Desc: NPC tried to fire primary attack
-----------------------------------------------------------]]
function SWEP:NPCShoot_Primary( ShootPos, ShootDir )

	self:PrimaryAttack()

end


-- These tell the NPC how to use the weapon
AccessorFunc( SWEP, "fNPCMinBurst", "NPCMinBurst" )
AccessorFunc( SWEP, "fNPCMaxBurst", "NPCMaxBurst" )
AccessorFunc( SWEP, "fNPCFireRate", "NPCFireRate" )
AccessorFunc( SWEP, "fNPCMinRestTime", "NPCMinRest" )
AccessorFunc( SWEP, "fNPCMaxRestTime", "NPCMaxRest" )
