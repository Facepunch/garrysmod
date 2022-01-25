AddCSLuaFile("shared.lua")
include("shared.lua")

-- serverside only
ENT.RemoveOnPress = false

ENT.Model = Model("models/weapons/w_bugbait.mdl")

function ENT:Initialize()
   self:SetModel(self.Model)

   self:SetNoDraw(true)
   self:DrawShadow(false)
   self:SetSolid(SOLID_NONE)
   self:SetMoveType(MOVETYPE_NONE)

   self:SetDelay(self.RawDelay or 1)

   if self:GetDelay() < 0 then
      -- func_button can be made single use by setting delay to be negative, so
      -- mimic that here
      self.RemoveOnPress = true
   end

   if self.RemoveOnPress then
      self:SetDelay(-1) -- tells client we're single use
   end

   if self:GetUsableRange() < 1 then
      self:SetUsableRange(1024)
   end

   self:SetNextUseTime(0)
   self:SetLocked(self:HasSpawnFlags(2048))

   self:SetDescription(self.RawDescription or "?")

   self.RawDelay = nil
   self.RawDescription = nil
end

function ENT:KeyValue(key, value)
   if key == "OnPressed" then
      self:StoreOutput(key, value)
   elseif key == "wait" then -- as Delay Before Reset in func_button
      self.RawDelay = tonumber(value)
   elseif key == "description" then
      self.RawDescription = tostring(value)

      if self.RawDescription and string.len(self.RawDescription) < 1 then
         self.RawDescription = nil
      end
   elseif key == "RemoveOnPress" then
      self[key] = tobool(value)
   else
      self:SetNetworkKeyValue(key, value)
   end
end


function ENT:AcceptInput(name, activator)
   if name == "Toggle" then
      self:SetLocked(not self:GetLocked())
      return true
   elseif name == "Hide" or name == "Lock" then
      self:SetLocked(true)
      return true
   elseif name == "Unhide" or name == "Unlock" then
      self:SetLocked(false)
      return true
   end
end

function GAMEMODE:TTTCanUseTraitorButton(ent, ply)
   -- Can be used to prevent players from using this button.
   -- Return a boolean and a message that can shows up if you can't use the button.
   -- Example: return false, "Not allowed".
   return true
end

function ENT:TraitorUse(ply)
   if not (IsValid(ply) and ply:IsActiveTraitor()) then return false end
   if not self:IsUsable() then return false end

   if self:GetPos():Distance(ply:GetPos()) > self:GetUsableRange() then return false end

   local use, message = hook.Run("TTTCanUseTraitorButton", self, ply)
   if not use then
      if message then TraitorMsg(ply, message) end
      return false
   end

   net.Start("TTT_ConfirmUseTButton") net.Send(ply)

   -- send output to all entities linked to us
   self:TriggerOutput("OnPressed", ply)

   if self.RemoveOnPress then
      self:SetLocked(true)
      self:Remove()
   else
      -- lock ourselves until we should be usable again
      self:SetNextUseTime(CurTime() + self:GetDelay())
   end

   hook.Run("TTTTraitorButtonActivated", self, ply)
   return true
end

-- Fix for traitor buttons having awkward init/render behavior, in the event that a map has been optimized with area portals.
function ENT:UpdateTransmitState()
   return TRANSMIT_ALWAYS
end

local function TraitorUseCmd(ply, cmd, args)
   if #args != 1 then return end

   if IsValid(ply) and ply:IsActiveTraitor() then
      local idx = tonumber(args[1])
      if idx then
         local ent = Entity(idx)
         if IsValid(ent) and ent:GetClass() == "ttt_traitor_button" and ent.TraitorUse then
            ent:TraitorUse(ply)
         end
      end
   end
end
concommand.Add("ttt_use_tbutton", TraitorUseCmd)
