ENT.Type = "filter"
ENT.Base = "base_filter"

local ROLE_ANY = 3

ENT.Role = ROLE_ANY

function ENT:KeyValue(key, value)
   if key == "Role" then
      self.Role = tonumber(value)

      if not self.Role then
         ErrorNoHalt("ttt_filter_role: bad value for Role key, not a number\n")
         self.Role = ROLE_ANY
      end
   end
end

function ENT:PassesFilter(caller, activator)
   if not IsValid(activator) or not activator:IsPlayer() then return false end

   local activator_role = (GetRoundState() == ROUND_PREP) and ROLE_INNOCENT or activator:GetRole()
   if self.Role == activator_role or self.Role == ROLE_ANY then
      Dev(2, activator, "passed filter_role test of", self:GetName())
      return true
   end

   Dev(2, activator, "failed filter_role test of", self:GetName())
   return false
end