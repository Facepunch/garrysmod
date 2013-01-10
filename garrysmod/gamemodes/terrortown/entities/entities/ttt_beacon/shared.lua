-- DISABLED: see weapon_ttt_beacon

if SERVER then
   -- DISABLED
   --AddCSLuaFile("shared.lua")
end

if CLIENT then
   -- this entity can be DNA-sampled so we need some display info
   ENT.Icon = "VGUI/ttt/icon_beacon"
   ENT.PrintName = "Beacon"
end

ENT.Type = "anim"
ENT.Model = Model("models/props_lab/reciever01b.mdl")
ENT.CanHavePrints = true
ENT.CanUseKey = true

function ENT:Initialize()
   self.Entity:SetModel(self.Model)

   if SERVER then
      self.Entity:PhysicsInit(SOLID_VPHYSICS)
   end

   self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
   self.Entity:SetSolid(SOLID_VPHYSICS)
   self.Entity:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)

   if SERVER then
      self.Entity:SetMaxHealth(100)
   end
   self.Entity:SetHealth(100)

   if SERVER then
      self.Entity:SetUseType(SIMPLE_USE)
   end

   if SERVER then
      self.Entity:NextThink(CurTime() + 1)
   end
end

function ENT:UseOverride(activator)
   if IsValid(activator) and self:GetOwner() == activator then
      local wep = activator:GetWeapon("weapon_ttt_beacon")

      if IsValid(wep) then
         local pickup = wep:PickupBeacon()
         if not pickup then
            return
         end
         -- else pickup successful, continue with print transfer and removal

      else
         wep = activator:Give("weapon_ttt_beacon")
      end

      local prints = self.fingerprints or {}
      self:Remove()

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
         TraitorMsg(self:GetOwner(), "ONE OF YOUR BEACONS HAS BEEN DESTROYED!")
      end
   end
end

if SERVER then
   --local beep = Sound("weapons/c4/c4_beep1.wav")
   function ENT:Think()
      if SERVER then
         --sound.Play(beep, self:GetPos(), 100, 80)
      else
         local dlight = DynamicLight(self:EntIndex())
         if dlight then
            dlight.Pos = self:GetPos()
            dlight.r = 0
            dlight.g = 0
            dlight.b = 255
            dlight.Brightness = 1
            dlight.Size = 128
            dlight.Decay = 500
            dlight.DieTime = CurTime() + 0.1
         end
      end

      self.Entity:NextThink(CurTime() + 5)
      return true
   end

   function ENT:UpdateTransmitState() return TRANSMIT_ALWAYS end
end

