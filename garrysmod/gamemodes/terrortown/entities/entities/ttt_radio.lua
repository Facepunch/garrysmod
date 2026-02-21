---- Radio equipment playing distraction sounds

AddCSLuaFile()

if CLIENT then
   -- this entity can be DNA-sampled so we need some display info
   ENT.Icon = "vgui/ttt/icon_radio"
   ENT.PrintName = "radio_name"
end

ENT.Type = "anim"
ENT.Model = Model("models/props/cs_office/radio.mdl")

ENT.CanUseKey = true
ENT.CanHavePrints = false
ENT.SoundLimit = 5
ENT.SoundDelay = 0.5

function ENT:Initialize()
   self:SetModel(self.Model)

   self:PhysicsInit(SOLID_VPHYSICS)
   self:SetMoveType(MOVETYPE_VPHYSICS)
   self:SetSolid(SOLID_VPHYSICS)
   self:SetCollisionGroup(COLLISION_GROUP_NONE)
   if SERVER then
      self:SetMaxHealth(40)
   end
   self:SetHealth(40)

   if SERVER then
      self:SetUseType(SIMPLE_USE)
   end

   -- Register with owner
   if CLIENT then
      if LocalPlayer() == self:GetOwner() then
         LocalPlayer().radio = self
      end
   end

   self.SoundQueue = {}
   self.Playing = false
   self.fingerprints = {}
end

function ENT:UseOverride(activator)
   if IsValid(activator) and activator:IsPlayer() and activator:IsActiveTraitor() then
      local prints = self.fingerprints or {}
      self:Remove()

      local wep = activator:Give("weapon_ttt_radio")
      if IsValid(wep) then
         wep.fingerprints = wep.fingerprints or {}
         table.Add(wep.fingerprints, prints)
      end
   end
end

local zapsound = Sound("npc/assassin/ball_zap1.wav")
function ENT:OnTakeDamage(dmginfo)
   self:TakePhysicsDamage(dmginfo)

   self:SetHealth(self:Health() - dmginfo:GetDamage())
   if self:Health() < 0 then
      self:Remove()

      local effect = EffectData()
      effect:SetOrigin(self:GetPos())
      util.Effect("cball_explode", effect)
      sound.Play(zapsound, self:GetPos())

      if IsValid(self:GetOwner()) then
         LANG.Msg(self:GetOwner(), "radio_broken")
      end
   end
end

function ENT:OnRemove()
   if CLIENT then
      if LocalPlayer() == self:GetOwner() then
         LocalPlayer().radio = nil
      end
   end
end

function ENT:AddSound(snd)
   if #self.SoundQueue < self.SoundLimit then
      table.insert(self.SoundQueue, snd)
   end
end

function ENT:PlayDelayedSound(snd, ampl, last)
   if istable(snd) then
      snd = table.Random(snd)
   end

   self:BroadcastSound(snd, ampl)

   self.Playing = not last

   --print("Playing", snd, last)
end

function ENT:PlaySound(snd)
   local soundData = TRADIO.Sounds[snd]
   if not soundData then return end

   if hook.Run("TTTRadioPlaySound", self, snd, soundData) == true then return end

   local sndlist = soundData.sound
   local ampl = soundData.ampl

   local serial = soundData.serial
   local times = soundData.times
   if serial or times then
      local num = istable(sndlist) and #sndlist or 1

      if times then
         times = istable(times) and math.random(times[1], times[2]) or times
      else
         times = num
      end

      if times > 1 then
         local delay = soundData.delay
         local idx = 1

         local t = 0
         for i = 1, times do
            local sndpath = serial and sndlist[idx] or sndlist

            timer.Simple(t,
                        function()
                           -- maybe we can get destroyed while a timer is still up
                           if not IsValid(self) then return end

                           self:PlayDelayedSound(sndpath, ampl, i == times)
                        end)

            local d = istable(delay) and math.Rand(delay[1], delay[2]) or delay
            t = t + d

            if serial then
               idx = idx + 1
               if idx > num then idx = 1 end
            end
         end

         return
      end
   end

   self:PlayDelayedSound(sndlist, ampl, true)
end

local nextplay = 0
function ENT:Think()
   if CurTime() > nextplay and #self.SoundQueue > 0 then
      if not self.Playing then
         local snd = table.remove(self.SoundQueue, 1)
         self:PlaySound(snd)
      end

      -- always do this, makes timing work out a little better
      nextplay = CurTime() + self.SoundDelay
   end
end

if SERVER then
   local function RadioCmd(ply, cmd, args)
      if not IsValid(ply) or not ply:IsActiveTraitor() then return end
      if not (#args == 2) then return end

      local eidx = tonumber(args[1])
      local snd = tostring(args[2])
      if not eidx or not snd then return end

      local radio = Entity(eidx)
      if not IsValid(radio) then return end
      if radio:GetOwner() != ply then return end
      if radio:GetClass() != "ttt_radio" then return end

      if not TRADIO.Sounds[snd] then
         print("Received radio sound not in table from", ply)
         return
      end

      radio:AddSound(snd)
   end
   concommand.Add("ttt_radio_play", RadioCmd)
end


