
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )
include( "outputs.lua" )

--[[---------------------------------------------------------
	Name: Initialize
	Desc: First function called. Use to set up your entity
-----------------------------------------------------------]]
function ENT:Initialize()
end

--[[---------------------------------------------------------
	Name: KeyValue
	Desc: Called when a keyvalue is added to us
-----------------------------------------------------------]]
function ENT:KeyValue( key, value )
end

--[[---------------------------------------------------------
	Name: OnRestore
	Desc: The game has just been reloaded. This is usually the right place
		to call the GetNW* functions to restore the script's values.
-----------------------------------------------------------]]
function ENT:OnRestore()
end

--[[---------------------------------------------------------
	Name: AcceptInput
	Desc: Accepts input, return true to override/accept input
-----------------------------------------------------------]]
function ENT:AcceptInput( name, activator, caller, data )
	return false
end

--[[---------------------------------------------------------
	Name: UpdateTransmitState
	Desc: Set the transmit state
-----------------------------------------------------------]]
function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end

--[[---------------------------------------------------------
	Name: Think
	Desc: Entity's think function.
-----------------------------------------------------------]]
function ENT:Think()
end

--
-- Default generic spawn function
-- So you don't have to add one your entitie unless you want to.
--
function ENT:SpawnFunction( ply, tr, ClassName )

	if ( !tr.Hit ) then return end

	local SpawnPos = tr.HitPos + tr.HitNormal * 10
	local SpawnAng = ply:EyeAngles()
	SpawnAng.p = 0
	SpawnAng.y = SpawnAng.y + 180

	local ent = ents.Create( ClassName )
	ent:SetCreator( ply )
	ent:SetPos( SpawnPos )
	ent:SetAngles( SpawnAng )
	ent:Spawn()
	ent:Activate()

	ent:DropToFloor()

	return ent

end
