-- fire handler that does owned damage

AddCSLuaFile()

ENT.Type = "anim"
ENT.Model = Model("models/weapons/w_eq_flashbang_thrown.mdl")

AccessorFunc(ENT, "dmgparent", "DamageParent")

AccessorFunc(ENT, "die_explode", "ExplodeOnDeath")
AccessorFunc(ENT, "dietime", "DieTime")

AccessorFuncDT(ENT, "burning", "Burning")

ENT.firechild = nil
ENT.fireparams = {size=120, growth=1}

ENT.dietime = 0
ENT.next_hurt = 0
ENT.hurt_interval = 1

CreateConVar("ttt_fire_fallback", "0", FCVAR_ARCHIVE)

function ENT:SetupDataTables()
   self:DTVar("Bool", 0, "burning")
end


function ENT:Initialize()
   self:SetModel(self.Model)
   self:DrawShadow(false)
   self:SetNoDraw(true)

   if CLIENT and GetConVar("ttt_fire_fallback"):GetBool() then
      self.Draw = self.BackupDraw
      self:SetNoDraw(false)
   end

   self:PhysicsInit(SOLID_VPHYSICS)
   self:SetMoveType(MOVETYPE_VPHYSICS)
   self:SetSolid(SOLID_VPHYSICS)
   self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
   self:SetHealth(99999)

   self.next_hurt = CurTime() + self.hurt_interval + math.Rand(0, 3)

   self:SetBurning(false)

   if self.dietime == 0 then self.dietime = CurTime() + 20 end
end

function StartFires(pos, tr, num, lifetime, explode, dmgowner)
   for i=1, num do
      local ang = Angle(-math.Rand(0, 180), math.Rand(0, 360), math.Rand(0, 360))

      local vstart = pos + tr.HitNormal * 64

      local flame = ents.Create("ttt_flame")
      flame:SetPos(pos)
      if IsValid(dmgowner) and dmgowner:IsPlayer() then
         flame:SetDamageParent(dmgowner)
         flame:SetOwner(dmgowner)
      end
      flame:SetDieTime(CurTime() + lifetime + math.Rand(-2, 2))
      flame:SetExplodeOnDeath(explode)

      flame:Spawn()
      flame:PhysWake()

      local phys = flame:GetPhysicsObject()
      if IsValid(phys) then
         -- the balance between mass and force is subtle, be careful adjusting
         phys:SetMass(2)
         phys:ApplyForceCenter(ang:Forward() * 500)
         phys:AddAngleVelocity(Vector(ang.p, ang.r, ang.y))
      end

   end

end

function SpawnFire(pos, size, attack, fuel, owner, parent)
   local fire = ents.Create("env_fire")
   if not IsValid(fire) then return end

   fire:SetParent(parent)
   fire:SetOwner(owner)
   fire:SetPos(pos)
   --no glow + delete when out + start on + last forever
   fire:SetKeyValue("spawnflags", tostring(128 + 32 + 4 + 2 + 1))
   fire:SetKeyValue("firesize", (size * math.Rand(0.7, 1.1)))
   fire:SetKeyValue("fireattack", attack)
   fire:SetKeyValue("health", fuel)
   fire:SetKeyValue("damagescale", "-10") -- only neg. value prevents dmg

   fire:Spawn()
   fire:Activate()

   return fire
end

-- greatly simplified version of SDK's game_shard/gamerules.cpp:RadiusDamage
-- does no block checking, radius should be very small
function RadiusDamage(dmginfo, pos, radius, inflictor)
   local tr = nil
   for k, vic in ipairs(ents.FindInSphere(pos, radius)) do
      if IsValid(vic) and inflictor:Visible(vic) then
         if vic:IsPlayer() and vic:Alive() and vic:Team() == TEAM_TERROR then
            vic:TakeDamageInfo(dmginfo)
         end
      end
   end
end

function ENT:OnRemove()
   if IsValid(self.firechild) then
      self.firechild:Remove()
   end
end

function ENT:OnTakeDamage()
end

function ENT:Explode()
   local pos = self:GetPos()

   local effect = EffectData()
   effect:SetStart(pos)
   effect:SetOrigin(pos)
   effect:SetScale(256)
   effect:SetRadius(256)
   effect:SetMagnitude(50)

   util.Effect("Explosion", effect, true, true)

   local dmgowner = self:GetDamageParent()
   if not IsValid(dmgowner) then
      dmgowner = self
   end
   util.BlastDamage(self, dmgowner, pos, 300, 40)
end

function ENT:Think()
   if CLIENT then return end

   if self.dietime < CurTime() then
      if self:GetExplodeOnDeath() then
         local success, err = pcall(self.Explode, self)

         if not success then
            ErrorNoHalt("ERROR CAUGHT: ttt_flame: " .. err .. "\n")
         end
      end

      if IsValid(self.firechild) then
         self.firechild:Remove()
      end

      self:Remove()
      return
   end

   if IsValid(self.firechild) then
      if self.next_hurt < CurTime() then
         if self:WaterLevel() > 0 then
            self.dietime = 0
            return
         end

         -- deal damage

         local dmg = DamageInfo()
         dmg:SetDamageType(DMG_BURN)
         dmg:SetDamage(math.random(4,6))
         if IsValid(self:GetDamageParent()) then
            dmg:SetAttacker(self:GetDamageParent())
         else
            dmg:SetAttacker(self)
         end
         dmg:SetInflictor(self.firechild)

         RadiusDamage(dmg, self:GetPos(), 132, self)

         self.next_hurt = CurTime() + self.hurt_interval
      end
      return
   elseif self:GetVelocity() == Vector(0,0,0) then
      if self:WaterLevel() > 0 then
         self.dietime = 0
         return
      end

      self.firechild = SpawnFire(self:GetPos(), self.fireparams.size, self.fireparams.growth, 999, self:GetDamageParent(), self)

      self:SetBurning(true)
   end

end

if CLIENT then
local fakefire = Material("cable/smoke")
local side = Angle(-90, 0, 0)
function ENT:BackupDraw()
   if not self:GetBurning() then return end

   local vstart = self:GetPos()
   local vend = vstart + Vector(0, 0, 90)

   side.r = side.r + 0.1

   cam.Start3D2D(vstart, side, 1)
   draw.DrawText("FIRE! IT BURNS!", "Default", 0, 0, COLOR_RED, ALIGN_CENTER)
   cam.End3D2D()

   render.SetMaterial(fakefire)
   render.DrawBeam(vstart, vend, 80, 0, 0, COLOR_RED)
end

function ENT:Draw()
end
end
