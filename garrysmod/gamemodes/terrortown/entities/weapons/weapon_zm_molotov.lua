
AddCSLuaFile()

SWEP.HoldType			= "grenade"

if CLIENT then
   SWEP.PrintName	 = "grenade_fire"
   SWEP.Slot		 = 3

   SWEP.Icon = "vgui/ttt/icon_nades"
   SWEP.IconLetter = "P"
end

SWEP.Base				= "weapon_tttbasegrenade"
SWEP.Spawnable = true

SWEP.Kind = WEAPON_NADE
SWEP.WeaponID = AMMO_MOLOTOV

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/cstrike/c_eq_flashbang.mdl"
SWEP.WorldModel			= "models/weapons/w_eq_flashbang.mdl"
SWEP.Weight			= 5
SWEP.AutoSpawnable      = true
-- really the only difference between grenade weapons: the model and the thrown
-- ent.

function SWEP:GetGrenadeName()
   return "ttt_firegrenade_proj"
end
