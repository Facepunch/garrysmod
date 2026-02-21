
ENT.Type = "brush"
ENT.Base = "base_brush"

function ENT:KeyValue(key, value)
   if key == "TraitorsFound" then
      -- this is our output, so handle it as such
      self:StoreOutput(key, value)
   end
end

local function VectorInside(vec, mins, maxs)
   return (vec.x > mins.x and vec.x < maxs.x
           and vec.y > mins.y and vec.y < maxs.y
           and vec.z > mins.z and vec.z < maxs.z)
end

function ENT:CountTraitors()
   local mins = self:LocalToWorld(self:OBBMins())
   local maxs = self:LocalToWorld(self:OBBMaxs())

   local trs = 0
   for _,ply in player.Iterator() do
      if IsValid(ply) and ply:IsActiveTraitor() and ply:Alive() then
         local pos = ply:GetPos()
         if VectorInside(pos, mins, maxs) then
            trs = trs + 1
         end
      end
   end

   return trs
end

function ENT:AcceptInput(name, activator, caller)
   if name == "CheckForTraitor" then
      local traitors = self:CountTraitors()

      self:TriggerOutput("TraitorsFound", activator, traitors)

      return true
   end
end
