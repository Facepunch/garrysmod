
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.Model = Model("models/ttt/deerstalker.mdl")
ENT.CanHavePrints = false
ENT.CanUseKey = true

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
   local ttt_hats_reclaim = CreateConVar("ttt_detective_hats_reclaim", "1")
   local ttt_hats_innocent = CreateConVar("ttt_detective_hats_reclaim_any", "0")

   function ENT:OnRemove()
      self:SetBeingWorn(false)
   end

   function ENT:Drop(dir)
      local ply = self:GetParent()

      ply.hat = nil
      self:SetParent(nil)

      self:SetBeingWorn(false)
      self:SetUseType(SIMPLE_USE)

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

   local function CanEquipHat(ply)
      return not IsValid(ply.hat) and
         (ttt_hats_innocent:GetBool() or ply:GetRole() == ROLE_DETECTIVE)
   end

   function ENT:UseOverride(ply)
      if not ttt_hats_reclaim:GetBool() then return end
      
      if IsValid(ply) and not self:GetBeingWorn() then
         if GetRoundState() != ROUND_ACTIVE then
            SafeRemoveEntity(self)
            return
         elseif not CanEquipHat(ply) then
            return
         end
   
         sound.Play("weapon.ImpactSoft", self:GetPos(), 75, 100, 1)
   
         self:SetMoveType(MOVETYPE_NONE)
         self:SetSolid(SOLID_NONE)
         self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
   
         self:SetParent(ply)
         self.Wearer = ply
   
         ply.hat = self.Entity
   
         self:SetBeingWorn(true)
   
         LANG.Msg(ply, "hat_retrieve")
      end
   end

   local function TestHat(ply, cmd, args)
      local hat = ents.Create("ttt_hat_deerstalker")

      hat:SetPos(ply:GetPos() + Vector(0,0,70))
      hat:SetAngles(ply:GetAngles())

      hat:SetParent(ply)

      ply.hat = hat

      hat:Spawn()
   end
   concommand.Add("ttt_debug_testhat", TestHat, nil, nil, FCVAR_CHEAT)
end
