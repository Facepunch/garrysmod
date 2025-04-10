AddCSLuaFile()

SWEP.HoldType              = "revolver"
SWEP.ReloadHoldType        = "pistol"

if CLIENT then
   SWEP.PrintName          = "sipistol_name"
   SWEP.Slot               = 6

   SWEP.ViewModelFlip      = false
   SWEP.ViewModelFOV       = 54

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "sipistol_desc"
   };

   SWEP.Icon               = "vgui/ttt/icon_silenced"
   SWEP.IconLetter         = "a"
end

SWEP.Base                  = "weapon_tttbase"

SWEP.Primary.Recoil        = 1.35
SWEP.Primary.Damage        = 28    --default 28
SWEP.Primary.Delay         = 0.15  --default 0.38
SWEP.Primary.Cone          = 0.02
SWEP.Primary.ClipSize      = 20
SWEP.Primary.Automatic     = false --default true
SWEP.Primary.DefaultClip   = 20
SWEP.Primary.ClipMax       = 60
SWEP.Primary.Ammo          = "Pistol"
SWEP.Primary.Sound         = Sound( "Weapon_USP.SilencedShot" )
SWEP.Primary.SoundLevel    = 50
--default does not have a headshot modifier; we handle similar to shotgun later


SWEP.Kind                  = WEAPON_EQUIP
SWEP.CanBuy                = {ROLE_TRAITOR} -- only traitors can buy
SWEP.WeaponID              = AMMO_SIPISTOL

SWEP.AmmoEnt               = "item_ammo_pistol_ttt"
SWEP.IsSilent              = true

SWEP.UseHands              = true
SWEP.ViewModel             = "models/weapons/cstrike/c_pist_usp.mdl"
SWEP.WorldModel            = "models/weapons/w_pist_usp_silencer.mdl"

SWEP.IronSightsPos         = Vector( -5.91, -4, 2.84 )
SWEP.IronSightsAng         = Vector(-0.5, 0, 0)

SWEP.PrimaryAnim           = ACT_VM_PRIMARYATTACK_SILENCED
SWEP.ReloadAnim            = ACT_VM_RELOAD_SILENCED

function SWEP:Deploy()
   self:SendWeaponAnim(ACT_VM_DRAW_SILENCED)
   return self.BaseClass.Deploy(self)
end

-- We were bought as special equipment, and we have an extra to give
function SWEP:WasBought(buyer)
   if IsValid(buyer) then -- probably already self:GetOwner()
      buyer:GiveAmmo( 20, "Pistol" )
   end
end

-- Code based on the default shotgun. The Silenced Pistol should be able to kill 
-- at close range to compete with the knife, but shouldn't be able to get cross-map
-- headshots. Use a graphing calculator to make sure it works: www.mathway.com/graph

function SWEP:GetHeadshotMultiplier(victim, dmginfo)
   local att = dmginfo:GetAttacker()
   if not IsValid(att) then return 3 end

   local dist = victim:GetPos():Distance(att:GetPos())
   local instakillrange = 120 -- 10 feet
   if dist < 120 then return 6 end -- if in instakillrange, 6x multiplier

   local d = math.max(0, dist - instakillrange) -- no falloff until past instakillrange

   -- decay from 4 at 120 units or less, to 2 at 240 units (20 feet) 
   return 2 + math.max(0, (2 - 0.005 * (d ^ 1.25)))
end
