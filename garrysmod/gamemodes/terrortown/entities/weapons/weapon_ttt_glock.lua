AddCSLuaFile()

SWEP.HoldType              = "pistol"

if CLIENT then
   SWEP.PrintName          = "Glock"
   SWEP.Slot               = 1

   SWEP.ViewModelFlip      = false
   SWEP.ViewModelFOV       = 54

   SWEP.Icon               = "vgui/ttt/icon_glock"
   SWEP.IconLetter         = "c"
end

SWEP.Base                  = "weapon_tttbase"

SWEP.Primary.Recoil        = 0.9
SWEP.Primary.Damage        = 12
SWEP.Primary.Delay         = 0.10
SWEP.Primary.Cone          = 0.028
SWEP.Primary.ClipSize      = 20
SWEP.Primary.Automatic     = true
SWEP.Primary.DefaultClip   = 20
SWEP.Primary.ClipMax       = 60
SWEP.Primary.Ammo          = "Pistol"
SWEP.Primary.Sound         = Sound( "Weapon_Glock.Single" )

SWEP.AutoSpawnable         = true

SWEP.AmmoEnt               = "item_ammo_pistol_ttt"
SWEP.Kind                  = WEAPON_PISTOL
SWEP.WeaponID              = AMMO_GLOCK

SWEP.HeadshotMultiplier    = 1.75

SWEP.UseHands              = true
SWEP.ViewModel             = "models/weapons/cstrike/c_pist_glock18.mdl"
SWEP.WorldModel            = "models/weapons/w_pist_glock18.mdl"

SWEP.IronSightsPos         = Vector( -5.79, -3.9982, 2.8289 )
