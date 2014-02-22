
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.Model = Model("models/ttt/deerstalker.mdl")

AccessorFuncDT(ENT, "worn", "BeingWorn")

function ENT:SetupDataTables()
   self:DTVar("Bool", 0, "worn")
end

function ENT:Initialize()
   self:SetBeingWorn(true)

   self:SetModel(self.Model)

   self:DrawShadow(false)

   -- don't physicsinit the ent here, because physicsing and then setting
   -- movetype none is 1) a waste of memory, 2) broken

   self:SetMoveType(MOVETYPE_NONE)
   self:SetSolid(SOLID_NONE)
   self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)

   if SERVER then
      self.Wearer = self:GetParent()
      self:AddEffects(bit.bor(EF_BONEMERGE, EF_BONEMERGE_FASTCULL, EF_PARENT_ANIMATES))
   end
end

if SERVER then
   function ENT:OnRemove()
      self:SetBeingWorn(false)
   end

   function ENT:Drop(dir)
      local ply = self:GetParent()

      ply.hat = nil
      self:SetParent(nil)

      self:SetBeingWorn(false)

      -- only now physics this entity
      self:PhysicsInit(SOLID_VPHYSICS)
      self:SetSolid(SOLID_VPHYSICS)
      self:SetMoveType(MOVETYPE_VPHYSICS)

      -- position at head
      if IsValid(ply) then
         local bone = ply:LookupBone("ValveBiped.Bip01_Head1")
         if bone then
            local pos, ang = ply:GetBonePosition(bone)
            self:SetPos(pos)
            self:SetAngles(ang)
         else
            local pos = ply:GetPos()
            pos.z = pos.z + 68

            self:SetPos(pos)
         end
      end

      -- physics push
      local phys = self:GetPhysicsObject()
      if IsValid(phys) then
         phys:SetMass(10)

         if IsValid(ply) then
            phys:SetVelocityInstantaneous(ply:GetVelocity())
         end

         if not dir then
            phys:ApplyForceCenter(Vector(0, 0, 1200))
         else
            phys:ApplyForceCenter(Vector(0, 0, 700) + dir * 500)
         end

         phys:AddAngleVelocity(VectorRand() * 200)

         phys:Wake()
      end
   end

   local function TestHat(ply, cmd, args)
      if cvars.Bool("sv_cheats", 0) then
         local hat = ents.Create("ttt_hat_deerstalker")

         hat:SetPos(ply:GetPos() + Vector(0,0,70))
         hat:SetAngles(ply:GetAngles())

         hat:SetParent(ply)

         ply.hat = hat

         hat:Spawn()
      end
   end
   concommand.Add("ttt_debug_testhat", TestHat)
end
