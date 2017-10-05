AddCSLuaFile()

SWEP.HoldType               = "normal"

if CLIENT then
   SWEP.PrintName           = "vis_name"
   SWEP.Slot                = 6

   SWEP.ViewModelFOV        = 10
   SWEP.ViewModelFlip       = false
   SWEP.DrawCrosshair       = false

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "vis_desc"
   };

   SWEP.Icon                = "vgui/ttt/icon_cse"
end

SWEP.Base                   = "weapon_tttbase"

SWEP.ViewModel              = Model("models/weapons/v_crowbar.mdl")
SWEP.WorldModel             = Model("models/Items/battery.mdl")

SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = false
SWEP.Primary.Ammo           = "none"
SWEP.Primary.Delay          = 1.0

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = true
SWEP.Secondary.Ammo         = "none"
SWEP.Secondary.Delay        = 0.2

SWEP.Kind                   = WEAPON_EQUIP
SWEP.CanBuy                 = {ROLE_DETECTIVE} -- only detectives can buy
SWEP.WeaponID               = AMMO_CSE

SWEP.LimitedStock           = true -- only buyable once
SWEP.NoSights               = true
SWEP.AllowDrop              = false

SWEP.DeathScanDelay         = 15

function SWEP:PrimaryAttack()
   self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
   self:DropDevice()
end

function SWEP:SecondaryAttack()
   self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
   self:DropDevice()
end

function SWEP:DrawWorldModel()
end

function SWEP:OnDrop()
   self:Remove()
end

function SWEP:PreDrop(isdeath)
   if isdeath then
      local cse = self:DropDevice()
      if IsValid(cse) then
         cse:SetDetonateTimer(self.DeathScanDelay or 10)
      end
   end
end

function SWEP:Reload()
   return false
end

function SWEP:OnRemove()
   if CLIENT and IsValid(self:GetOwner()) and self:GetOwner() == LocalPlayer() and self:GetOwner():Alive() then
      RunConsoleCommand("lastinv")
   end
end

local throwsound = Sound( "Weapon_SLAM.SatchelThrow" )

function SWEP:DropDevice()
   local cse = nil

   if SERVER then
      local ply = self:GetOwner()
      if not IsValid(ply) then return end

      if self.Planted then return end

      local vsrc = ply:GetShootPos()
      local vang = ply:GetAimVector()
      local vvel = ply:GetVelocity()
      
      local vthrow = vvel + vang * 200

      cse = ents.Create("ttt_cse_proj")
      if IsValid(cse) then
         cse:SetPos(vsrc + vang * 10)
         cse:SetOwner(ply)
         cse:SetThrower(ply)
         cse:Spawn()

         cse:PhysWake()
         local phys = cse:GetPhysicsObject()
         if IsValid(phys) then
            phys:SetVelocity(vthrow)
         end

         self:Remove()

         self.Planted = true
      end
   end

   self:EmitSound(throwsound)

   return cse
end

if CLIENT then
   function SWEP:Initialize()
      self:AddHUDHelp("vis_help_pri", nil, true)

      return self.BaseClass.Initialize(self)
   end
end


