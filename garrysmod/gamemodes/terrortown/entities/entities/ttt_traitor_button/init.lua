
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

local range = 1024 -- mirror to client
function ENT:TraitorUse(ply)
   if not (IsValid(ply) and ply:IsActiveTraitor()) then return false end
   if not self:IsUsable() then return false end

   if self:GetPos():Distance(ply:GetPos()) > range then return false end

   -- confirm with an empty packet
   SendUserMessage("ttt_confirm_use_tbutton", ply)

   -- send output to all entities linked to us
   self:TriggerOutput("OnPressed", ply)

   --self:SetLocked(true)

   if self.RemoveOnPress then
      self:SetLocked(true)
      self:Remove()
   else
      -- lock ourselves until we should be usable again
      self:SetNextUseTime(CurTime() + self:GetDelay())
   end

   return true
end

local function TraitorUseCmd(ply, cmd, args)
   if #args != 1 then return end

   if IsValid(ply) and ply:IsActiveTraitor() then
      local idx = tonumber(args[1])
      if idx then
         local ent = Entity(idx)
         if IsValid(ent) and ent.TraitorUse then
            ent:TraitorUse(ply)
         end
      end
   end
end
concommand.Add("ttt_use_tbutton", TraitorUseCmd)
