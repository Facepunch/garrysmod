-- shared extensions to player table

local plymeta = FindMetaTable( "Player" )
if not plymeta then return end

local math = math

function plymeta:IsTerror() return self:Team() == TEAM_TERROR end
function plymeta:IsSpec() return self:Team() == TEAM_SPEC end

AccessorFunc(plymeta, "role", "Role", FORCE_NUMBER)

-- Role access
function plymeta:GetTraitor() return self:GetRole() == ROLE_TRAITOR end
function plymeta:GetDetective() return self:GetRole() == ROLE_DETECTIVE end

plymeta.IsTraitor = plymeta.GetTraitor
plymeta.IsDetective = plymeta.GetDetective

function plymeta:IsSpecial() return self:GetRole() != ROLE_INNOCENT end

-- Player is alive and in an active round
function plymeta:IsActive()
   return self:IsTerror() and GetRoundState() == ROUND_ACTIVE
end

-- convenience functions for common patterns
function plymeta:IsRole(role) return self:GetRole() == role end
function plymeta:IsActiveRole(role) return self:IsRole(role) and self:IsActive() end
function plymeta:IsActiveTraitor() return self:IsActiveRole(ROLE_TRAITOR) end
function plymeta:IsActiveDetective() return self:IsActiveRole(ROLE_DETECTIVE) end
function plymeta:IsActiveSpecial() return self:IsSpecial() and self:IsActive() end

local role_strings = {
   [ROLE_TRAITOR]   = "traitor",
   [ROLE_INNOCENT]  = "innocent",
   [ROLE_DETECTIVE] = "detective"
};

local GetRTranslation = CLIENT and LANG.GetRawTranslation or util.passthrough

-- Returns printable role
function plymeta:GetRoleString()
   return GetRTranslation(role_strings[self:GetRole()]) or "???"
end


-- Returns role language string id, caller must translate if desired
function plymeta:GetRoleStringRaw()
   return role_strings[self:GetRole()]
end

function plymeta:GetBaseKarma() return self:GetNWFloat("karma", 1000) end

function plymeta:HasEquipmentWeapon()
   for _, wep in pairs(self:GetWeapons()) do
      if IsValid(wep) and wep:IsEquipment() then
         return true
      end
   end

   return false
end

function plymeta:CanCarryWeapon(wep)
   if (not wep) or (not wep.Kind) then return false end

   return self:CanCarryType(wep.Kind)
end

function plymeta:CanCarryType(t)
   if not t then return false end

   for _, w in pairs(self:GetWeapons()) do
      if w.Kind and w.Kind == t then
         return false
      end
   end
   return true
end

function plymeta:IsDeadTerror()
   return (self:IsSpec() and not self:Alive())
end


function plymeta:HasBought(id)
   return self.bought and table.HasValue(self.bought, id)
end

function plymeta:GetCredits() return self.equipment_credits or 0 end

function plymeta:GetEquipmentItems() return self.equipment_items or EQUIP_NONE end

-- Given an equipment id, returns if player owns this. Given nil, returns if
-- player has any equipment item.
function plymeta:HasEquipmentItem(id)
   if not id then
      return self:GetEquipmentItems() != EQUIP_NONE
   else
      return util.BitSet(self:GetEquipmentItems(), id)
   end
end

function plymeta:HasEquipment()
   return self:HasEquipmentItem() or self:HasEquipmentWeapon()
end

if CLIENT then
   -- Server has this, but isn't shared for some reason
   function plymeta:HasWeapon(cls)
      for _, wep in pairs(self:GetWeapons()) do
         if IsValid(wep) and wep:GetClass() == cls then
            return true
         end
      end

      return false
   end

   local gmod_GetWeapons = plymeta.GetWeapons
   function plymeta:GetWeapons()
      if self != LocalPlayer() then
         return {}
      else
         return gmod_GetWeapons(self)
      end
   end
end

-- Override GetEyeTrace for an optional trace mask param. Technically traces
-- like GetEyeTraceNoCursor but who wants to type that all the time, and we
-- never use cursor tracing anyway.
function plymeta:GetEyeTrace(mask)
   if self.LastPlayerTraceMask == mask and self.LastPlayerTrace == CurTime() then
      return self.PlayerTrace
   end

   local tr = util.GetPlayerTrace(self)
   tr.mask = mask

   self.PlayerTrace = util.TraceLine(tr)
   self.LastPlayerTrace = CurTime()
   self.LastPlayerTraceMask = mask

   return self.PlayerTrace
end


if CLIENT then

   function plymeta:AnimApplyGesture(act, weight)
      self:AnimRestartGesture(GESTURE_SLOT_CUSTOM, act, true) -- true = autokill
      self:AnimSetGestureWeight(GESTURE_SLOT_CUSTOM, weight)
   end

   local function MakeSimpleRunner(act)
      return function (ply, w)
                -- just let this gesture play itself and get out of its way
                if w == 0 then
                   ply:AnimApplyGesture(act, 1)
                   return 1
                else
                   return 0
                end
             end
   end

   -- act -> gesture runner fn
   local act_runner = {
      -- ear grab needs weight control
      -- sadly it's currently the only one
      [ACT_GMOD_IN_CHAT] =
         function (ply, w)
            local dest = ply:IsSpeaking() and 1 or 0
            w = math.Approach(w, dest, FrameTime() * 10)
            if w > 0 then
               ply:AnimApplyGesture(ACT_GMOD_IN_CHAT, w)
            end
            return w
         end
   };

   -- Insert all the "simple" gestures that do not need weight control
   for _, a in pairs{ACT_GMOD_GESTURE_AGREE, ACT_GMOD_GESTURE_DISAGREE,
                     ACT_GMOD_GESTURE_WAVE, ACT_GMOD_GESTURE_BECON,
                     ACT_GMOD_GESTURE_BOW, ACT_GMOD_GESTURE_SALUTE,
                     ACT_GMOD_CHEER, ACT_SIGNAL_FORWARD, ACT_SIGNAL_HALT,
                     ACT_SIGNAL_GROUP, ACT_ITEM_PLACE, ACT_ITEM_DROP,
                     ACT_ITEM_GIVE} do
      act_runner[a] = MakeSimpleRunner(a)
   end

   CreateConVar("ttt_show_gestures", "1", FCVAR_ARCHIVE)

   -- Perform the gesture using the GestureRunner system. If custom_runner is
   -- non-nil, it will be used instead of the default runner for the act.
   function plymeta:AnimPerformGesture(act, custom_runner)
      if GetConVarNumber("ttt_show_gestures") == 0 then return end

      local runner = custom_runner or act_runner[act]
      if not runner then return false end

      self.GestureWeight = 0
      self.GestureRunner = runner

      return true
   end

   -- Perform a gesture update
   function plymeta:AnimUpdateGesture()
      if self.GestureRunner then
         self.GestureWeight = self:GestureRunner(self.GestureWeight)

         if self.GestureWeight <= 0 then
            self.GestureRunner = nil
         end
      end
   end

   function GM:UpdateAnimation(ply, vel, maxseqgroundspeed)
      ply:AnimUpdateGesture()

      return self.BaseClass.UpdateAnimation(self, ply, vel, maxseqgroundspeed)
   end

   function GM:GrabEarAnimation(ply) end

   net.Receive("TTT_PerformGesture", function()
      local ply = net.ReadEntity()
      local act = net.ReadUInt(16)
      if IsValid(ply) and act then
         ply:AnimPerformGesture(act)
      end
   end)

else -- SERVER

   -- On the server, we just send the client a message that the player is
   -- performing a gesture. This allows the client to decide whether it should
   -- play, depending on eg. a cvar.
   function plymeta:AnimPerformGesture(act)

      if not act then return end

      net.Start("TTT_PerformGesture")
         net.WriteEntity(self)
         net.WriteUInt(act, 16)
      net.Broadcast()
   end
end
