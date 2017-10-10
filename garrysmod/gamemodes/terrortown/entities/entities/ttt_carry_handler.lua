
AddCSLuaFile()

ENT.Type = "anim"

ENT.Carried = nil
ENT.CarriedMass = 0
ENT.PrevThink = 0
ENT.TargetPos = Vector(0,0,0)
ENT.TargetAng = Angle(0,0,0)
ENT.Owner = nil

function ENT:Initialize()
   if SERVER and IsValid(self.Carried) then
      
--      self:SetModel("models/weapons/w_bugbait.mdl")
      self:SetModel(self.Carried:GetModel())
--      self:SetSkin(self.Carried:GetSkin())
--      self:SetColor(se.Carried:GetColor())
   end
   self:PhysicsInit( SOLID_VPHYSICS )
   self:SetMoveType( MOVETYPE_VPHYSICS )
   self:SetSolid( SOLID_VPHYSICS )
   self:SetCollisionGroup(COLLISION_GROUP_NONE)
--   self:SetSolid(SOLID_NONE)
   self:SetNoDraw(true)

--   self:SetHealth(9999)



--   local ply = self:GetOwner()
--   self.Owner = ply
--   if IsValid(ply) then
--      self.TargetPos = ply:GetShootPos() + (ply:GetAimVector() * 70)
--      self.TargetAng = ply:GetAimVector()
--   end


   if SERVER and IsValid(self.Carried) then

      local phys = self:GetPhysicsObject()
      local carphys = self.Carried:GetPhysicsObject()

      if IsValid(phys) and IsValid(carphys) then
         phys:Wake()
         carphys:Wake()

         phys:SetMass(9999)

         phys:SetDamping(0, 1000)
         carphys:SetDamping(0, 1000)

--         if not carphys:IsPenetrating() then
--            phys:SetPos(carphys:GetPos())
--            phys:SetAngle(carphys:GetAngle())
--            carphys:SetPos( phys:GetPos() )
--            carphys:SetAngle( phys:GetAngle() )
--         end

      end

      self.Carried:SetGravity(false)
      self.Carried:SetOwner(self:GetOwner())
--      self.Carried:SetNoDraw(true)
--      self.Carried:SetSolid(SOLID_NONE)
   end
end

function ENT:OnRemove()
   if IsValid(self.Carried) then
      self.Carried:SetGravity(true)
      self.Carried:SetOwner(nil)
--      self.Carried:SetNoDraw(false)
--      self.Carried:SetSolid(SOLID_VPHYSICS)
      self.Carried:SetMoveType(MOVETYPE_VPHYSICS)
      
      local carphys = self.Carried:GetPhysicsObject()
      if IsValid(carphys) then
         carphys:SetDamping(0,0)
      end

      self.Carried:PhysWake()

   end
end


--function ENT:Think()
--   if CLIENT then return end
--
--   -- Check on all entities involved
--
--   local obj = self.Carried
--   local ply = self:GetOwner()
--   if not IsValid(obj) or not IsValid(ply) or not ply:Alive() then
--      self:Remove()
--      return
--   end
--
--
--
--   -- Check some other requirements
--   local spos = ply:GetShootPos()
--   if ply:GetGroundEntity() == obj or obj:NearestPoint(spos):Distance(spos) > 150 then
--      self:Remove()
--      return
--   end
--
--
--   self.TargetPos = spos + (ply:GetAimVector() * 70)
--   self.TargetAng = ply:GetAimVector()
--
--   local phys = self:GetPhysicsObject()
--   local carryphys = obj:GetPhysicsObject()
--   if IsValid(phys) and IsValid(carryphys) then
--      if phys:IsPenetrating() then
--         self:Remove()
--         return
----         self.TargetPos = phys:GetPos() + Vector(0,0,5)
----         phys:SetPos(self.TargetPos)
--      end
--
--      carryphys:SetPos(phys:GetPos())
--      carryphys:SetAngle(phys:GetAngles())
--      carryphys:SetVelocity(phys:GetVelocity())
--   end
--
--end


--function ENT:PhysicsSimulate(phys, delta)
--   phys:Wake()
--
--   local p = {}
--   p.pos = self.TargetPos
--   p.angle = self.TargetAng
--   p.secondstoarrive = 0.05
--   p.maxangular = 100
--   p.maxangulardamp = 10000
--   p.maxspeed = 100
--   p.maxspeeddamp = 1000
--   p.dampfactor = 0.8
--   p.teleportdistance = 0
--   p.deltatime = delta
--
--   phys:ComputeShadowControl(p)
--end


function ENT:OnTakeDamage(dmg)
   -- do nothing
end