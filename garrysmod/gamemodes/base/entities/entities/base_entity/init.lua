
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')
include('outputs.lua')


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
      to call the GetNetworked* functions to restore the script's values.
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

--[[---------------------------------------------------------
   Name: RemoveIfInvalidPhysics
   Desc: Deletes the entity and prints an error if it has no valid physobj
-----------------------------------------------------------]]
function ENT:RemoveIfInvalidPhysics()
   local PhysObj = self:GetPhysicsObject()
   if ( IsValid( PhysObj ) ) then
      return
   end
   local Model = self:GetModel()
   self:Remove()
   error( "No Physics Object available for entity '" .. self.ClassName .. "'! Do you have the model '" .. Model .. "' installed?", 2 )
end

--[[---------------------------------------------------------
   Name: WakeIfValidPhysics
   Desc: If the entity has a valid physics object, wake it.
-----------------------------------------------------------]]
function ENT:WakeIfValidPhysics()
   local PhysObj = self:GetPhysicsObject()
   if ( IsValid( PhysObj ) ) then
      PhysObj:Wake()
   end
end

--[[---------------------------------------------------------
   Name: WakePhysics
   Desc: Wake the entity's physobj without checking if it's valid first
-----------------------------------------------------------]]
function ENT:WakePhysics()
   self:GetPhysicsObject():Wake()
end
