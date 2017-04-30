-- Decoy sending out a radar blip and redirecting DNA scans. Based on old beacon
-- code.

AddCSLuaFile()

ENT.Type = "anim"
ENT.Model = Model("models/props_lab/reciever01b.mdl")
ENT.CanHavePrints = false
ENT.CanUseKey = true

function ENT:Initialize()
   self:SetModel(self.Model)

   if SERVER then
      self:PhysicsInit(SOLID_VPHYSICS)
   end

   self:SetMoveType(MOVETYPE_VPHYSICS)
   self:SetSolid(SOLID_VPHYSICS)
   self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)

   if SERVER then
      self:SetMaxHealth(100)
   end
   self:SetHealth(100)

   -- can pick this up if we own it
   if SERVER then
      self:SetUseType(SIMPLE_USE)

      local weptbl = util.WeaponForClass("weapon_ttt_decoy")
      if weptbl and weptbl.Kind then
         self.WeaponKind = weptbl.Kind
      else
         self.WeaponKind = WEAPON_EQUIP2
      end
   end
end

function ENT:UseOverride(activator)
   if IsValid(activator) and self:GetOwner() == activator then

      if not activator:CanCarryType(self.WeaponKind or WEAPON_EQUIP2) then
         LANG.Msg(activator, "decoy_no_room")
         return
      end

      activator:Give("weapon_ttt_decoy")

      self:Remove()
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
         LANG.Msg(self:GetOwner(), "decoy_broken")
      end
   end
end

function ENT:OnRemove()
   if IsValid(self:GetOwner()) then
      self:GetOwner().decoy = nil
   end
end

