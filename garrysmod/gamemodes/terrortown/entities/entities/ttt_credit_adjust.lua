
ENT.Type = "point"
ENT.Base = "base_point"

ENT.Credits = 0

function ENT:KeyValue(key, value)
   if key == "OnSuccess" or key == "OnFail" then
      self:StoreOutput(key, value)
   elseif key == "credits" then
      self.Credits = tonumber(value) or 0

      if not tonumber(value) then
         ErrorNoHalt(tostring(self) .. " has bad 'credits' setting.\n")
      end
   end
end


function ENT:AcceptInput(name, activator)
   if name == "TakeCredits" then

      if IsValid(activator) and activator:IsPlayer() then

         if activator:GetCredits() >= self.Credits then
            activator:SubtractCredits(self.Credits)

            self:TriggerOutput("OnSuccess", activator)
         else
            self:TriggerOutput("OnFail", activator)
         end
      end

      return true
   end
end
