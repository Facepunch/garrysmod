
ENT.Type = "point"
ENT.Base = "base_point"

local ROLE_ANY = 3

ENT.Role = ROLE_ANY

function ENT:KeyValue(key, value)
   if key == "OnPass" or key == "OnFail" then
      -- this is our output, so handle it as such
      self:StoreOutput(key, value)
   elseif key == "Role" then
      self.Role = tonumber(value)

      if not self.Role then
         ErrorNoHalt("ttt_logic_role: bad value for Role key, not a number\n")
         self.Role = ROLE_ANY
      end
   end
end


function ENT:AcceptInput(name, activator)
   if name == "TestActivator" then

      if IsValid(activator) and activator:IsPlayer() and (self.Role == ROLE_ANY or activator:IsRole(self.Role)) then
         Dev(2, activator, "passed logic_role test of", self:GetName())
         self:TriggerOutput("OnPass", activator)
      else
         Dev(2, activator, "failed logic_role test of", self:GetName())
         self:TriggerOutput("OnFail", activator)
      end

      return true
   end
end

