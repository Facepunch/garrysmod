
AddCSLuaFile()

SWEP.HoldType = "grenade"


if CLIENT then
   SWEP.PrintName = "Discombobulator"
   SWEP.Slot = 3
   SWEP.SlotPos	= 0

   SWEP.Icon = "vgui/ttt/icon_nades"
   SWEP.IconLetter = "h"
end

SWEP.Base				= "weapon_tttbasegrenade"

SWEP.WeaponID = AMMO_DISCOMB
SWEP.Kind = WEAPON_NADE

SWEP.Spawnable = true


SWEP.AutoSpawnable      = true

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/cstrike/c_eq_fraggrenade.mdl"
SWEP.WorldModel			= "models/weapons/w_eq_fraggrenade.mdl"
SWEP.Weight			= 5

-- really the only difference between grenade weapons: the model and the thrown
-- ent.

function SWEP:GetGrenadeName()
   return "ttt_confgrenade_proj"
end
