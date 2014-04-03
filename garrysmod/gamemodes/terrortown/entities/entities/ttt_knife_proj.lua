-- thrown knife

AddCSLuaFile()

if CLIENT then
   ENT.PrintName = "knife_thrown"
   ENT.Icon = "vgui/ttt/icon_knife"
end


ENT.Type = "anim"
ENT.Model = Model("models/weapons/w_knife_t.mdl")

-- When true, score code considers us a weapon
ENT.Projectile = true

ENT.Stuck = false
ENT.Weaponised = false
ENT.CanHavePrints = false
ENT.IsSilent = true
ENT.CanPickup = false

ENT.WeaponID = AMMO_KNIFE

ENT.Damage = 50

function ENT:Initialize()
   self:SetModel(self.Model)

   self:PhysicsInit(SOLID_VPHYSICS)

   if SERVER then
      self:SetGravity(0.4)
      self:SetFriction(1.0)
      self:SetElasticity(0.45)

      self.StartPos = self:GetPos()

      self:NextThink(CurTime())
   end

   self.Weaponised = false
   self.Stuck = false
end

function ENT:HitPlayer(other, tr)

   local range_dmg = math.max(self.Damage, self.StartPos:Distance(self:GetPos()) / 3)

   if other:Health() < range_dmg + 10 then
      self:KillPlayer(other, tr)
   elseif SERVER then
      local dmg = DamageInfo()
      dmg:SetDamage(range_dmg)
      dmg:SetAttacker(self:GetOwner())
      dmg:SetInflictor(self)
      dmg:SetDamageForce(self:EyeAngles():Forward())
      dmg:SetDamagePosition(self:GetPos())
      dmg:SetDamageType(DMG_SLASH)

      local ang = Angle(-28,0,0) + tr.Normal:Angle()
      ang:RotateAroundAxis(ang:Right(), -90)
      other:DispatchTraceAttack(dmg, self:GetPos() + ang:Forward() * 3, other:GetPos())

      if not self.Weaponised then
         self:BecomeWeaponDelayed()
      end
   end
   
   -- As a thrown knife, after we hit a target we can never hit one again.
   -- If we are picked up and re-thrown, a new knife_proj entity is created.
   -- To make sure we can never deal damage twice, make HitPlayer do nothing.
   self.HitPlayer = util.noop
end

function ENT:KillPlayer(other, tr)
   local dmg = DamageInfo()
   dmg:SetDamage(2000)
   dmg:SetAttacker(self:GetOwner())
   dmg:SetInflictor(self)
   dmg:SetDamageForce(self:EyeAngles():Forward())
   dmg:SetDamagePosition(self:GetPos())
   dmg:SetDamageType(DMG_SLASH)

   -- this bone is why we need the trace
   local bone = tr.PhysicsBone
   local pos = tr.HitPos
   local norm = tr.Normal
   local ang = Angle(-28,0,0) + norm:Angle()
   ang:RotateAroundAxis(ang:Right(), -90)
   pos = pos - (ang:Forward() * 8)

   local knife = self
   local prints = self.fingerprints

   other.effect_fn = function(rag)

                        if not IsValid(knife) or not IsValid(rag) then return end

                        knife:SetPos(pos)
                        knife:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
                        knife:SetAngles(ang)

                        knife:SetMoveCollide(MOVECOLLIDE_DEFAULT)
                        knife:SetMoveType(MOVETYPE_VPHYSICS)

                        knife.fingerprints = prints
                        knife:SetNWBool("HasPrints", true)

                        --knife:SetSolid(SOLID_NONE)
                        -- knife needs to be trace-able to get prints
                        local phys = knife:GetPhysicsObject()
                        if IsValid(phys) then
                           phys:EnableCollisions(false)
                        end

                        constraint.Weld(rag, knife, bone, 0, 0, true)

                        rag:CallOnRemove("ttt_knife_cleanup", function() SafeRemoveEntity(knife) end)
                     end


   other:DispatchTraceAttack(dmg, self:GetPos() + ang:Forward() * 3, other:GetPos())

   self.Stuck = true
end

if SERVER then
  function ENT:Think()
     if self.Stuck then return end

     local vel = self:GetVelocity()
     if vel == vector_origin then return end

     local tr = util.TraceLine({start=self:GetPos(), endpos=self:GetPos() + vel:GetNormal() * 20, filter={self, self:GetOwner()}, mask=MASK_SHOT_HULL})

     if tr.Hit and tr.HitNonWorld and IsValid(tr.Entity) then
        local other = tr.Entity
        if other:IsPlayer() then
           self:HitPlayer(other, tr)
        end
     end

     self:NextThink(CurTime())
     return true
  end
end

-- When this entity touches anything that is not a player, it should turn into a
-- weapon ent again. If it touches a player it sticks in it.
if SERVER then
   function ENT:BecomeWeapon()
      self.Weaponised = true

      local wep = ents.Create("weapon_ttt_knife")
      wep:SetPos(self:GetPos())
      wep:SetAngles(self:GetAngles())
      wep.IsDropped = true

      local prints = self.fingerprints or {}

      self:Remove()

      wep:Spawn()
      wep.fingerprints = wep.fingerprints or {}
      table.Add(wep.fingerprints, prints)

      return wep
   end

   function ENT:BecomeWeaponDelayed()
      -- delay the weapon-replacement a tick because Source gets very angry
      -- if you do fancy stuff in a physics callback
      local knife = self
      timer.Simple(0,
                   function()
                      if IsValid(knife) and not knife.Weaponised then
                         knife:BecomeWeapon()
                      end
                   end)
   end

   function ENT:PhysicsCollide(data, phys)
      if self.Stuck then return false end

      local other = data.HitEntity
      if not IsValid(other) and not other:IsWorld() then return end

      if other:IsPlayer() then
         local tr = util.TraceLine({start=self:GetPos(), endpos=other:LocalToWorld(other:OBBCenter()), filter={self, self:GetOwner()}, mask=MASK_SHOT_HULL})
         if tr.Hit and tr.Entity == other then
            self:HitPlayer(other, tr)
         end

         return true
      end

      if not self.Weaponised then
         self:BecomeWeaponDelayed()
      end
   end
end
