AddCSLuaFile()

SWEP.HoldType              = "revolver"
SWEP.ReloadHoldType        = "pistol"

if CLIENT then
   SWEP.PrintName          = "Desert Eagle"
   SWEP.Slot               = 1

   SWEP.ViewModelFlip      = false
   SWEP.ViewModelFOV       = 54

   SWEP.Icon               = "vgui/ttt/icon_deagle"
end

SWEP.Base                  = "weapon_tttbase"

SWEP.Kind                  = WEAPON_PISTOL
SWEP.WeaponID              = AMMO_DEAGLE

SWEP.Primary.Ammo          = "AlyxGun" -- hijack an ammo type we don't use otherwise
SWEP.Primary.Recoil        = 4     --default 6
SWEP.Primary.Damage        = 40    --default 37
SWEP.Primary.Delay         = 0.4   --default 0.6
SWEP.Primary.Cone          = 0.02
SWEP.Primary.ClipSize      = 8
SWEP.Primary.ClipMax       = 36
SWEP.Primary.DefaultClip   = 8
SWEP.Primary.Automatic     = false --default true
SWEP.Primary.Sound         = Sound( "Weapon_Deagle.Single" )

SWEP.HeadshotMultiplier    = 4     --instakill

SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true
SWEP.AmmoEnt               = "item_ammo_revolver_ttt"

SWEP.UseHands              = true
SWEP.ViewModel             = "models/weapons/cstrike/c_pist_deagle.mdl"
SWEP.WorldModel            = "models/weapons/w_pist_deagle.mdl"

SWEP.IronSightsPos         = Vector(-6.361, -3.701, 2.15)
SWEP.IronSightsAng         = Vector(0, 0, 0)
