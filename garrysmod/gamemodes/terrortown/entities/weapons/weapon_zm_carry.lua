---- Carry weapon SWEP

AddCSLuaFile()

DEFINE_BASECLASS "weapon_tttbase"

SWEP.HoldType               = "pistol"

if CLIENT then
   SWEP.PrintName           = "magnet_name"
   SWEP.Slot                = 4

   SWEP.DrawCrosshair       = false
   SWEP.ViewModelFlip       = false
end

SWEP.Base                   = "weapon_tttbase"

SWEP.AutoSpawnable          = false

SWEP.ViewModel              = Model("models/weapons/v_stunbaton.mdl")
SWEP.WorldModel             = Model("models/weapons/w_stunbaton.mdl")

SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = true
SWEP.Primary.Ammo           = "none"
SWEP.Primary.Delay          = 0.1

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = true
SWEP.Secondary.Ammo         = "none"
SWEP.Secondary.Delay        = 0.1

SWEP.Kind                   = WEAPON_CARRY
SWEP.InLoadoutFor           = {ROLE_INNOCENT, ROLE_TRAITOR, ROLE_DETECTIVE}

SWEP.AllowDelete            = false
SWEP.AllowDrop              = false
SWEP.NoSights               = true

SWEP.EntHolding             = nil
SWEP.CarryHack              = nil
SWEP.Constr                 = nil
SWEP.PrevOwner              = nil

local allow_rag  = CreateConVar("ttt_ragdoll_carrying", "1")
local prop_force = CreateConVar("ttt_prop_carrying_force", "60000")
local no_throw   = CreateConVar("ttt_no_prop_throwing", "0")
local pin_rag    = CreateConVar("ttt_ragdoll_pinning", "1")
local pin_rag_inno = CreateConVar("ttt_ragdoll_pinning_innocents", "0")

-- Allowing weapon pickups can allow players to cause a crash in the physics
-- system (ie. not fixable). Tuning the range seems to make this more
-- difficult. Not sure why. It's that kind of crash.
local allow_wep = CreateConVar("ttt_weapon_carrying", "0")
local wep_range = CreateConVar("ttt_weapon_carrying_range", "50")

-- not customizable via convars as some objects rely on not being carryable for
-- gameplay purposes
CARRY_WEIGHT_LIMIT = 45

local PIN_RAG_RANGE = 90

local player = player
local IsValid = IsValid
local CurTime = CurTime


local function SetSubPhysMotionEnabled(ent, enable)
   if not IsValid(ent) then return end

   for i=0, ent:GetPhysicsObjectCount()-1 do
      local subphys = ent:GetPhysicsObjectNum(i)
      if IsValid(subphys) then
         subphys:EnableMotion(enable)
         if enable then
            subphys:Wake()
         end
      end
   end
end

local function KillVelocity(ent)
   ent:SetVelocity(vector_origin)

   -- The only truly effective way to prevent all kinds of velocity and
   -- inertia is motion disabling the entire ragdoll for a tick
   -- for non-ragdolls this will do the same for their single physobj
   SetSubPhysMotionEnabled(ent, false)

   timer.Simple(0, function() SetSubPhysMotionEnabled(ent, true) end)
end

function SWEP:Reset(keep_velocity)
   if IsValid(self.CarryHack) then
      self.CarryHack:Remove()
   end

   if IsValid(self.Constr) then
      self.Constr:Remove()
   end

   if IsValid(self.EntHolding) then
      -- it is possible for weapons to be already equipped at this point
      -- changing the owner in such a case would cause problems
      if not self.EntHolding:IsWeapon() then
         if not IsValid(self.PrevOwner) then
            self.EntHolding:SetOwner(nil)
         else
            self.EntHolding:SetOwner(self.PrevOwner)
         end
      end

      -- the below ought to be unified with self:Drop()
      local phys = self.EntHolding:GetPhysicsObject()
      if IsValid(phys) then
         phys:ClearGameFlag(FVPHYSICS_PLAYER_HELD)
         phys:AddGameFlag(FVPHYSICS_WAS_THROWN)
         phys:EnableCollisions(true)
         phys:EnableGravity(true)
         phys:EnableDrag(true)
         phys:EnableMotion(true)
      end

      if (not keep_velocity) and (no_throw:GetBool() or self.EntHolding:GetClass() == "prop_ragdoll") then
         KillVelocity(self.EntHolding)
      end
   end

   self.dt.carried_rag = nil

   self.EntHolding = nil
   self.CarryHack = nil
   self.Constr = nil
end
SWEP.reset = SWEP.Reset

function SWEP:CheckValidity()

   if (not IsValid(self.EntHolding)) or (not IsValid(self.CarryHack)) or (not IsValid(self.Constr)) then

      -- if one of them is not valid but another is non-nil...
      if (self.EntHolding or self.CarryHack or self.Constr) then
         self:Reset()
      end

      return false
   else
      return true
   end
end

local function PlayerStandsOn(ent)
   for _, ply in pairs(player.GetAll()) do
      if ply:GetGroundEntity() == ent and ply:IsTerror() then
         return true
      end
   end

   return false
end

if SERVER then

local ent_diff = vector_origin
local ent_diff_time = CurTime()

local stand_time = 0
function SWEP:Think()
   BaseClass.Think(self)
   if not self:CheckValidity() then return end

   -- If we are too far from our object, force a drop. To avoid doing this
   -- vector math extremely often (esp. when everyone is carrying something)
   -- even though the occurrence is very rare, limited to once per
   -- second. This should be plenty to catch the rare glitcher.
   if CurTime() > ent_diff_time then
      ent_diff = self:GetPos() - self.EntHolding:GetPos()
      if ent_diff:Dot(ent_diff) > 40000 then
         self:Reset()
         return
      end

      ent_diff_time = CurTime() + 1
   end

   if CurTime() > stand_time then

      if PlayerStandsOn(self.EntHolding) then
         self:Reset()
         return
      end

      stand_time = CurTime() + 0.1
   end

   self.CarryHack:SetPos(self:GetOwner():EyePos() + self:GetOwner():GetAimVector() * 70)

   self.CarryHack:SetAngles(self:GetOwner():GetAngles())

   self.EntHolding:PhysWake()
end

end

function SWEP:PrimaryAttack()
   self:DoAttack(false)
end

function SWEP:SecondaryAttack()
   self:DoAttack(true)
end

function SWEP:MoveObject(phys, pdir, maxforce, is_ragdoll)
   if not IsValid(phys) then return end
   local speed = phys:GetVelocity():Length()

   -- remap speed from 0 -> 125 to force 1 -> 4000
   local force = maxforce + (1 - maxforce) * (speed / 125)

   if is_ragdoll then
      force = force * 2
   end

   pdir = pdir * force

   local mass = phys:GetMass()
   -- scale more for light objects
   if mass < 50 then
      pdir = pdir * (mass + 0.5) * (1 / 50)
   end

   phys:ApplyForceCenter(pdir)
end

function SWEP:GetRange(target)
   if IsValid(target) and target:IsWeapon() and allow_wep:GetBool() then
      return wep_range:GetFloat()
   elseif IsValid(target) and target:GetClass() == "prop_ragdoll" then
      return 75
   else
      return 100
   end
end

function SWEP:AllowPickup(target)
   local phys = target:GetPhysicsObject()
   local ply = self:GetOwner()

   return (IsValid(phys) and IsValid(ply) and
           (not phys:HasGameFlag(FVPHYSICS_NO_PLAYER_PICKUP)) and
           phys:GetMass() < CARRY_WEIGHT_LIMIT and
           (not PlayerStandsOn(target)) and
           (target.CanPickup != false) and
           (target:GetClass() != "prop_ragdoll" or allow_rag:GetBool()) and
           ((not target:IsWeapon()) or allow_wep:GetBool()))
end

function SWEP:DoAttack(pickup)
   self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
   self.Weapon:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )

   if IsValid(self.EntHolding) then
      self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )

      if (not pickup) and self.EntHolding:GetClass() == "prop_ragdoll" then
         -- see if we can pin this ragdoll to a wall in front of us
         if not self:PinRagdoll() then
            -- else just drop it as usual
            self:Drop()
         end
      else
         self:Drop()
      end

      self.Weapon:SetNextSecondaryFire(CurTime() + 0.3)
      return
   end

   local ply = self:GetOwner()

   local trace = ply:GetEyeTrace(MASK_SHOT)
   if IsValid(trace.Entity) then
      local ent = trace.Entity
      local phys = trace.Entity:GetPhysicsObject()

      if not IsValid(phys) or not phys:IsMoveable() or phys:HasGameFlag(FVPHYSICS_PLAYER_HELD) then
         return
      end

      -- if we let the client mess with physics, desync ensues
      if CLIENT then return end

      if pickup then
         if (ply:EyePos() - trace.HitPos):Length() < self:GetRange(ent) then

            if self:AllowPickup(ent) then
               self:Pickup()
               self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )

               -- make the refire slower to avoid immediately dropping
               local delay = (ent:GetClass() == "prop_ragdoll") and 0.8 or 0.5

               self.Weapon:SetNextSecondaryFire(CurTime() + delay)
               return
            else
               local is_ragdoll = trace.Entity:GetClass() == "prop_ragdoll"

               -- pull heavy stuff
               local ent = trace.Entity
               local phys = ent:GetPhysicsObject()
               local pdir = trace.Normal * -1

               if is_ragdoll then

                  phys = ent:GetPhysicsObjectNum(trace.PhysicsBone)

                  -- increase refire to make rags easier to drag
                  --self.Weapon:SetNextSecondaryFire(CurTime() + 0.04)
               end

               if IsValid(phys) then
                  self:MoveObject(phys, pdir, 6000, is_ragdoll)
                  return
               end
            end
         end
      else
         if (ply:EyePos() - trace.HitPos):Length() < 100 then
            local phys = trace.Entity:GetPhysicsObject()
            if IsValid(phys) then
               if IsValid(phys) then
                  local pdir = trace.Normal
                  self:MoveObject(phys, pdir, 6000, (trace.Entity:GetClass() == "prop_ragdoll"))

                  self.Weapon:SetNextPrimaryFire(CurTime() + 0.03)
               end
            end
         end
      end
   end
end

-- Perform a pickup
function SWEP:Pickup()
   if CLIENT or IsValid(self.EntHolding) then return end

   local ply = self:GetOwner()
   local trace = ply:GetEyeTrace(MASK_SHOT)
   local ent = trace.Entity
   self.EntHolding = ent
   local entphys = ent:GetPhysicsObject()


   if IsValid(ent) and IsValid(entphys) then

      self.CarryHack = ents.Create("prop_physics")
      if IsValid(self.CarryHack) then
         self.CarryHack:SetPos(self.EntHolding:GetPos())

         self.CarryHack:SetModel("models/weapons/w_bugbait.mdl")

         self.CarryHack:SetColor(Color(50, 250, 50, 240))
         self.CarryHack:SetNoDraw(true)
         self.CarryHack:DrawShadow(false)

         self.CarryHack:SetHealth(999)
         self.CarryHack:SetOwner(ply)
         self.CarryHack:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
         self.CarryHack:SetSolid(SOLID_NONE)
         
         -- set the desired angles before adding the constraint
         self.CarryHack:SetAngles(self:GetOwner():GetAngles())

         self.CarryHack:Spawn()

         -- if we already are owner before pickup, we will not want to disown
         -- this entity when we drop it
         -- weapons should not have their owner changed in this way
         if not self.EntHolding:IsWeapon() then
            self.PrevOwner = self.EntHolding:GetOwner()

            self.EntHolding:SetOwner(ply)
         end

         local phys = self.CarryHack:GetPhysicsObject()
         if IsValid(phys) then
            phys:SetMass(200)
            phys:SetDamping(0, 1000)
            phys:EnableGravity(false)
            phys:EnableCollisions(false)
            phys:EnableMotion(false)
            phys:AddGameFlag(FVPHYSICS_PLAYER_HELD)
         end

         entphys:AddGameFlag(FVPHYSICS_PLAYER_HELD)
         local bone = math.Clamp(trace.PhysicsBone, 0, 1)
         local max_force = prop_force:GetInt()

         if ent:GetClass() == "prop_ragdoll" then
            self.dt.carried_rag = ent

            bone = trace.PhysicsBone
            max_force = 0
         else
            self.dt.carried_rag = nil
         end

         self.Constr = constraint.Weld(self.CarryHack, self.EntHolding, 0, bone, max_force, true)


      end
   end
end

local down = Vector(0, 0, -1)
function SWEP:AllowEntityDrop()
   local ply = self:GetOwner()
   local ent = self.CarryHack
   if (not IsValid(ply)) or (not IsValid(ent)) then return false end

   local ground = ply:GetGroundEntity()
   if ground and (ground:IsWorld() or IsValid(ground)) then return true end

   local diff = (ent:GetPos() - ply:GetShootPos()):GetNormalized()

   return down:Dot(diff) <= 0.75
end

function SWEP:Drop()
   if not self:CheckValidity() then return end
   if not self:AllowEntityDrop() then return end

   if SERVER then
      self.Constr:Remove()
      self.CarryHack:Remove()

      local ent = self.EntHolding

      local phys = ent:GetPhysicsObject()
      if IsValid(phys) then
         phys:EnableCollisions(true)
         phys:EnableGravity(true)
         phys:EnableDrag(true)
         phys:EnableMotion(true)
         phys:Wake()
         phys:ApplyForceCenter(self:GetOwner():GetAimVector() * 500)

         phys:ClearGameFlag(FVPHYSICS_PLAYER_HELD)
         phys:AddGameFlag(FVPHYSICS_WAS_THROWN)
      end

      -- Try to limit ragdoll slinging
      if no_throw:GetBool() or ent:GetClass() == "prop_ragdoll" then
         KillVelocity(ent)
      end

      ent:SetPhysicsAttacker(self:GetOwner())

   end

   self:Reset()
end

local CONSTRAINT_TYPE = "Rope"

local function RagdollPinnedTakeDamage(rag, dmginfo)
   local att = dmginfo:GetAttacker()
   if not IsValid(att) then return end

   -- drop from pinned position upon dmg
   constraint.RemoveConstraints(rag, CONSTRAINT_TYPE)
   rag:PhysWake()

   rag:SetHealth(0)
   rag.is_pinned = false
end

function SWEP:PinRagdoll()
   if not pin_rag:GetBool() then return end
   if (not self:GetOwner():IsTraitor()) and (not pin_rag_inno:GetBool()) then return end

   local rag = self.EntHolding
   local ply = self:GetOwner()

   local tr = util.TraceLine({start  = ply:EyePos(),
                              endpos = ply:EyePos() + (ply:GetAimVector() * PIN_RAG_RANGE),
                              filter = {ply, self, rag, self.CarryHack},
                              mask   = MASK_SOLID})

   if tr.HitWorld and (not tr.HitSky) then

      -- find bone we're holding the ragdoll by
      local bone = self.Constr.Bone2

      -- only allow one rope per bone
      for _, c in pairs(constraint.FindConstraints(rag, CONSTRAINT_TYPE)) do
         if c.Bone1 == bone then
            c.Constraint:Remove()
         end
      end

      local bonephys = rag:GetPhysicsObjectNum(bone)
      if not IsValid(bonephys) then return end

      local bonepos = bonephys:GetPos()
      local attachpos = tr.HitPos
      local length = (bonepos - attachpos):Length() * 0.9

      -- we need to convert using this particular physobj to get the right
      -- coordinates
      bonepos = bonephys:WorldToLocal(bonepos)

      constraint.Rope(rag, tr.Entity, bone, 0, bonepos, attachpos,
                      length, length * 0.1, 6000,
                      1, "cable/rope", false)

      rag.is_pinned = true
      rag.OnPinnedDamage = RagdollPinnedTakeDamage

      -- lets EntityTakeDamage run for the ragdoll
      rag:SetHealth(999999)

      self:Reset(true)
   end
end

function SWEP:SetupDataTables()
   -- we've got these dt slots anyway, might as well use them instead of a
   -- globalvar, probably cheaper
   self:DTVar("Bool", 0, "can_rag_pin")

   -- client actually has no idea what we're holding, and almost never needs to
   -- know
   self:DTVar("Entity", 0, "carried_rag")
   return self.BaseClass.SetupDataTables(self)
end

if SERVER then
   function SWEP:Initialize()
      self.dt.can_rag_pin = pin_rag:GetBool()
      self.dt.carried_rag = nil

      return self.BaseClass.Initialize(self)
   end
end

function SWEP:OnRemove()
   self:Reset()
end

function SWEP:Deploy()
   self:Reset()
   return true
end

function SWEP:Holster()
   self:Reset()
   return true
end


function SWEP:ShouldDropOnDie()
   return false
end

function SWEP:OnDrop()
   self:Remove()
end

if CLIENT then
   local draw = draw
   local util = util

   local PT = LANG.GetParamTranslation
   local key_params = {primaryfire = Key("+attack", "LEFT MOUSE")}
   function SWEP:DrawHUD()
      self.BaseClass.DrawHUD(self)

      if self.dt.can_rag_pin and IsValid(self.dt.carried_rag) then
         local client = LocalPlayer()

         if not client:IsSpec() and client:IsTraitor() then
            local tr = util.TraceLine({start  = client:EyePos(),
               endpos = client:EyePos() + (client:GetAimVector() * PIN_RAG_RANGE),
               filter = {client, self, self.dt.carried_rag},
               mask   = MASK_SOLID})

            if tr.HitWorld and (not tr.HitSky) then
               draw.SimpleText(PT("magnet_help", key_params), "TabLarge", ScrW() / 2, ScrH() / 2 - 50, COLOR_RED, TEXT_ALIGN_CENTER)
            end
         end
      end
   end
end
