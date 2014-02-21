
AddCSLuaFile()

ENT.Type = "anim"
ENT.Model = Model("models/Items/combine_rifle_ammo01.mdl")

ENT.Stuck = false
ENT.Weaponised = false

ENT.PunchMax = 6
ENT.PunchRemaining = 6


function ENT:Initialize()
   self:SetModel(self.Model)

   self:SetSolid(SOLID_NONE)

   if SERVER then
      self:SetGravity(0.4)
      self:SetFriction(1.0)
      self:SetElasticity(0.45)

      self:NextThink(CurTime() + 1)
   end

   self:SetColor(Color(55, 50, 250, 255))

   self.Stuck = false
   self.PunchMax = 6
   self.PunchRemaining = self.PunchMax
end

function ENT:StickTo(ent)
   if (not IsValid(ent)) or ent:IsPlayer() or ent:GetMoveType() != MOVETYPE_VPHYSICS then return false end

   local phys = ent:GetPhysicsObject()
   if (not IsValid(phys)) or (not phys:IsMoveable()) then return false end

--   local norm = self:GetAngles():Up()

   self:SetParent(ent)

   ent:SetPhysicsAttacker(self:GetOwner())
   ent:SetNWBool("punched", true)
   self.PunchEntity = ent

   self:StartEffects()

   self.Stuck = true

   return true
end

function ENT:OnRemove()
   if IsValid(self.BallSprite) then
      self.BallSprite:Remove()
   end

   if IsValid(self.PunchEntity) then
      self.PunchEntity:SetPhysicsAttacker(self.PunchEntity)
      self.PunchEntity:SetNWBool("punched", false)
   end
end

function ENT:StartEffects()
   -- MAKE IT PRETTY

   local sprite = ents.Create("env_sprite")
   if IsValid(sprite) then
--      local angpos = self:GetAttachment(ball)
      -- sometimes attachments don't work (Lua-side) on dedicated servers,
      -- so have to fudge it
      local ang = self:GetAngles()
      local pos = self:GetPos() + self:GetAngles():Up() * 6
      sprite:SetPos(pos)
      sprite:SetAngles(ang)
      sprite:SetParent(self)

      sprite:SetKeyValue("model", "sprites/combineball_glow_blue_1.vmt")
      sprite:SetKeyValue("spawnflags", "1")
      sprite:SetKeyValue("scale", "0.25")
      sprite:SetKeyValue("rendermode", "5")
      sprite:SetKeyValue("renderfx", "7")

      sprite:Spawn()
      sprite:Activate()

      self.BallSprite = sprite

   end

   local effect = EffectData()
   effect:SetStart(self:GetPos())
   effect:SetOrigin(self:GetPos())
   effect:SetNormal(self:GetAngles():Up())
   util.Effect("ManhackSparks", effect, true, true)

   if SERVER then
      local ball = self:LookupAttachment("attach_ball")
      util.SpriteTrail(self, ball, Color(250, 250, 250), false, 30, 0, 1, 0.07, "trails/physbeam.vmt")
   end
end

if SERVER then
   local diesound = Sound("weapons/physcannon/energy_disintegrate4.wav")
   local punchsound = Sound("weapons/ar2/ar2_altfire.wav")
   function ENT:Think()
      if not self.Stuck then return end

      if self.PunchRemaining <= 0 then
--         self:StopParticles()

         local pos = self:GetPos()

         util.BlastDamage(self, self:GetOwner(), pos, 300, 125)

         sound.Play(diesound, pos, 100, 100)
         self:Remove()


         local effect = EffectData()
         effect:SetStart(pos)
         effect:SetOrigin(pos)
         util.Effect("Explosion", effect, true, true)
      else
         self.PunchRemaining = self.PunchRemaining - 1

         if IsValid(self.PunchEntity) and IsValid(self.PunchEntity:GetPhysicsObject()) then
            local punchphys = self.PunchEntity:GetPhysicsObject()


            -- Make physexplosion
            local phexp = ents.Create("env_physexplosion")
            if IsValid(phexp) then
               phexp:SetPos(self:GetPos())
               phexp:SetKeyValue("magnitude", 100)
               phexp:SetKeyValue("radius", 128)
               phexp:SetKeyValue("spawnflags", 1 + 2)
               phexp:Spawn()
               phexp:Fire("Explode", "", 0)
            end

            local norm = self:GetAngles():Up() * -1

            -- Add speed to ourselves
            local base = 120
            local bonus = punchphys:GetMass() * 2

            local vel = math.max(base * 2, base + bonus)

            punchphys:AddVelocity(norm * vel)

            util.BlastDamage(self, self:GetOwner(), self:GetPos(), 200, 50)

            local effect = EffectData()
            effect:SetStart(self:GetPos())
            effect:SetOrigin(self:GetPos())
            effect:SetNormal(norm * -1)
            effect:SetRadius(16)
            effect:SetScale(1)
            util.Effect("ManhackSparks", effect, true, true)

            sound.Play(punchsound, self:GetPos(), 80, 100)
         end
      end

      local delay = math.max(0.1, self.PunchRemaining / self.PunchMax) * 3
      self:NextThink(CurTime() + delay)
      return true
   end
end

