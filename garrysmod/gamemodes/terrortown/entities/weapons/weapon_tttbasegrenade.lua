-- common code for all types of grenade

AddCSLuaFile()

SWEP.HoldReady = "grenade"
SWEP.HoldNormal = "slam"

if CLIENT then

   SWEP.PrintName			= "Incendiary grenade"
   SWEP.Instructions		= "Burn."
   SWEP.Slot				= 3
   SWEP.SlotPos			= 0


   SWEP.Icon = "vgui/ttt/icon_nades"
end

SWEP.Base				= "weapon_tttbase"

SWEP.Kind = WEAPON_NADE

SWEP.ViewModel			= "models/weapons/v_eq_flashbang.mdl"
SWEP.WorldModel			= "models/weapons/w_eq_flashbang.mdl"
SWEP.Weight			= 5

SWEP.ViewModelFlip = true
SWEP.AutoSwitchFrom		= true

SWEP.DrawCrosshair		= false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Delay = 1.0
SWEP.Primary.Ammo		= "none"
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

SWEP.IsGrenade = true
SWEP.NoSights = true

SWEP.was_thrown = false

SWEP.detonate_timer = 5

SWEP.DeploySpeed = 1.5

AccessorFunc(SWEP, "det_time", "DetTime")

CreateConVar("ttt_no_nade_throw_during_prep", "0")

function SWEP:SetupDataTables()
   self:NetworkVar("Bool", 0, "Pin")
   self:NetworkVar("Int", 0, "ThrowTime")
end

function SWEP:PrimaryAttack()
   self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

   if GetRoundState() == ROUND_PREP and GetConVar("ttt_no_nade_throw_during_prep"):GetBool() then
      return
   end

   self:PullPin()
end

function SWEP:SecondaryAttack()
end

function SWEP:PullPin()
   if self:GetPin() then return end

   local ply = self.Owner
   if not IsValid(ply) then return end

   self:SendWeaponAnim(ACT_VM_PULLPIN)

   if self.SetHoldType then
      self:SetHoldType(self.HoldReady)
   end

   self:SetPin(true)

   self:SetDetTime(CurTime() + self.detonate_timer)
end


function SWEP:Think()
   local ply = self.Owner
   if not IsValid(ply) then return end

   -- pin pulled and attack loose = throw
   if self:GetPin() then
      -- we will throw now
      if not ply:KeyDown(IN_ATTACK) then
         self:StartThrow()

         self:SetPin(false)
         self:SendWeaponAnim(ACT_VM_THROW)

         if SERVER then
            self.Owner:SetAnimation( PLAYER_ATTACK1 )
         end
      else
         -- still cooking it, see if our time is up
         if SERVER and self:GetDetTime() < CurTime() then
            self:BlowInFace()
         end
      end
   elseif self:GetThrowTime() > 0 and self:GetThrowTime() < CurTime() then
      self:Throw()
   end
end


function SWEP:BlowInFace()
   local ply = self.Owner
   if not IsValid(ply) then return end

   if self.was_thrown then return end

   self.was_thrown = true

   -- drop the grenade so it can immediately explode

   local ang = ply:GetAngles()
   local src = ply:GetPos() + (ply:Crouching() and ply:GetViewOffsetDucked() or ply:GetViewOffset())
   src = src + (ang:Right() * 10)

   self:CreateGrenade(src, Angle(0,0,0), Vector(0,0,1), Vector(0,0,1), ply)

   self:SetThrowTime(0)
   self:Remove()
end

function SWEP:StartThrow()
   self:SetThrowTime(CurTime() + 0.1)
end

function SWEP:Throw()
   if CLIENT then
      self:SetThrowTime(0)
   elseif SERVER then
      local ply = self.Owner
      if not IsValid(ply) then return end

      if self.was_thrown then return end

      self.was_thrown = true

      local ang = ply:EyeAngles()

      -- don't even know what this bit is for, but SDK has it
      -- probably to make it throw upward a bit
      if ang.p < 90 then
         ang.p = -10 + ang.p * ((90 + 10) / 90)
      else
         ang.p = 360 - ang.p
         ang.p = -10 + ang.p * -((90 + 10) / 90)
      end

      local vel = math.min(800, (90 - ang.p) * 6)

      local vfw = ang:Forward()
      local vrt = ang:Right()
      --      local vup = ang:Up()

      local src = ply:GetPos() + (ply:Crouching() and ply:GetViewOffsetDucked() or ply:GetViewOffset())
      src = src + (vfw * 8) + (vrt * 10)

      local thr = vfw * vel + ply:GetVelocity()

      self:CreateGrenade(src, Angle(0,0,0), thr, Vector(600, math.random(-1200, 1200), 0), ply)

      self:SetThrowTime(0)
      self:Remove()
   end
end

-- subclasses must override with their own grenade ent
function SWEP:GetGrenadeName()
   ErrorNoHalt("SWEP BASEGRENADE ERROR: GetGrenadeName not overridden! This is probably wrong!\n")
   return "ttt_firegrenade_proj"
end


function SWEP:CreateGrenade(src, ang, vel, angimp, ply)
   local gren = ents.Create(self:GetGrenadeName())
   if not IsValid(gren) then return end

   gren:SetPos(src)
   gren:SetAngles(ang)

   --   gren:SetVelocity(vel)
   gren:SetOwner(ply)
   gren:SetThrower(ply)

   gren:SetGravity(0.4)
   gren:SetFriction(0.2)
   gren:SetElasticity(0.45)

   gren:Spawn()

   gren:PhysWake()

   local phys = gren:GetPhysicsObject()
   if IsValid(phys) then
      phys:SetVelocity(vel)
      phys:AddAngleVelocity(angimp)
   end

   -- This has to happen AFTER Spawn() calls gren's Initialize()
   gren:SetDetonateExact(self:GetDetTime())

   return gren
end

function SWEP:PreDrop()
   -- if owner dies or drops us while the pin has been pulled, create the armed
   -- grenade anyway
   if self:GetPin() then
      self:BlowInFace()
   end
end

function SWEP:Deploy()

   if self.SetHoldType then
      self:SetHoldType(self.HoldNormal)
   end

   self:SetThrowTime(0)
   self:SetPin(false)
   return true
end

function SWEP:Holster()
   if self:GetPin() then
      return false -- no switching after pulling pin
   end

   self:SetThrowTime(0)
   self:SetPin(false)
   return true
end

function SWEP:Reload()
   return false
end

function SWEP:Initialize()
   if self.SetHoldType then
      self:SetHoldType(self.HoldNormal)
   end

   self:SetDeploySpeed(self.DeploySpeed)

   self:SetDetTime(0)
   self:SetThrowTime(0)
   self:SetPin(false)

   self.was_thrown = false
end

function SWEP:OnRemove()
   if CLIENT and IsValid(self.Owner) and self.Owner == LocalPlayer() and self.Owner:Alive() then
      RunConsoleCommand("use", "weapon_ttt_unarmed")
   end
end
