
ENT.Type = "point"
ENT.Base = "base_point"

function ENT:Initialize()
   -- Backwards compatibility: TTT maps compiled before the addition of the
   -- propspec setting may expect it to be off, so default it to off if a map
   -- settings entity exists (a reliable way of identifying a TTT map)
   GAMEMODE.propspec_allow_named = false

   timer.Simple(0, function() self:TriggerOutput("MapSettingsSpawned", self) end)
end

function ENT:KeyValue(k, v)
   if k == "cbar_doors" then
      Dev(2, "ttt_map_settings: crowbar door unlocking = " .. v)
      local opens = (v == "1")
      GAMEMODE.crowbar_unlocks[OPEN_DOOR] = opens
      GAMEMODE.crowbar_unlocks[OPEN_ROT] = opens
   elseif k == "cbar_buttons" then
      Dev(2, "ttt_map_settings: crowbar button unlocking = " .. v)
      GAMEMODE.crowbar_unlocks[OPEN_BUT] = (v == "1")
   elseif k == "cbar_other" then 
      Dev(2, "ttt_map_settings: crowbar movelinear unlocking = " .. v)
      GAMEMODE.crowbar_unlocks[OPEN_NOTOGGLE] = (v == "1")
   elseif k == "plymodel" and v != "" then -- can ignore if empty
      if util.IsValidModel(v) then
         util.PrecacheModel(v)
         GAMEMODE.force_plymodel = v

         Dev(2, "ttt_map_settings: set player model to be " .. v)
      else
         Dev(2, "ttt_map_settings: FAILED to set player model due to invalid path: " .. v)
      end
   elseif k == "propspec_named" then
      Dev(2, "ttt_map_settings: propspec possessing named props = " .. v)
      GAMEMODE.propspec_allow_named = (v == "1")
   elseif k == "MapSettingsSpawned" or k == "RoundEnd" or k == "RoundPreparation" or k == "RoundStart" then
      self:StoreOutput(k, v)
   end
end

function ENT:AcceptInput(name, activator, caller, data)
   if name == "SetPlayerModels" then
      local mdlname = tostring(data)

      if not mdlname then
         ErrorNoHalt("ttt_map_settings: Invalid parameter to SetPlayerModels input!\n")
         return false
      elseif not util.IsValidModel(mdlname) then
         ErrorNoHalt("ttt_map_settings: Invalid model given: " .. mdlname .. "\n")
         return false
      end

      GAMEMODE.force_plymodel = Model(mdlname)

      Dev(2, "ttt_map_settings: input set player model to be " .. mdlname)

      return true
   end
end

-- Fire an output when the round changes
function ENT:RoundStateTrigger(r, data)
   if r == ROUND_PREP then
      self:TriggerOutput("RoundPreparation", self)
   elseif r == ROUND_ACTIVE then
      self:TriggerOutput("RoundStart", self)
   elseif r == ROUND_POST then
      -- RoundEnd has the type of win condition as param
      self:TriggerOutput("RoundEnd", self, tostring(data))
   end
end
