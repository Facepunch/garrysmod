---- Dummy ent that just spawns a random TTT weapon and kills itself

ENT.Type = "point"
ENT.Base = "base_point"

ENT.AutoAmmo = 0

function ENT:KeyValue(key, value)
   if key == "auto_ammo" then
      self.AutoAmmo = tonumber(value)
   end
end

function ENT:Initialize()
   local weps = ents.TTT.GetSpawnableSWEPs()
   if weps then
      local w = weps[math.random(#weps)]
      local ent = ents.Create(WEPS.GetClass(w))
      if IsValid(ent) then
         local pos = self:GetPos()
         ent:SetPos(pos)
         ent:SetAngles(self:GetAngles())
         ent:Spawn()
         ent:PhysWake()

         if ent.AmmoEnt and self.AutoAmmo > 0 then
            for i=1, self.AutoAmmo do
               local ammo = ents.Create(ent.AmmoEnt)
               if IsValid(ammo) then
                  pos.z = pos.z + 3 -- shift every box up a bit
                  ammo:SetPos(pos)
                  ammo:SetAngles(VectorRand():Angle())
                  ammo:Spawn()
                  ammo:PhysWake()
               end
            end
         end
      end

      self:Remove()
   end
end
