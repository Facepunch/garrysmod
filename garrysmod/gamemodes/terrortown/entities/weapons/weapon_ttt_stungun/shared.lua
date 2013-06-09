if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType = "ar2"

if CLIENT then
   SWEP.PrintName = "UMP Prototype"
   SWEP.Slot      = 6

   SWEP.Icon = "VGUI/ttt/icon_ump"

   SWEP.ViewModelFOV = 72

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "ump_desc"
   };
end


SWEP.Base = "weapon_tttbase"

SWEP.Kind = WEAPON_EQUIP
SWEP.WeaponID = AMMO_STUN
SWEP.CanBuy = {ROLE_DETECTIVE}
SWEP.LimitedStock = false

SWEP.Primary.Damage = 9
SWEP.Primary.Delay = 0.1
SWEP.Primary.Cone = 0.02
SWEP.Primary.ClipSize = 30
SWEP.Primary.ClipMax = 60
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"
SWEP.AutoSpawnable      = false
SWEP.AmmoEnt = "item_ammo_smg1_ttt"
SWEP.Primary.Recoil		= 1.2
SWEP.Primary.Sound		= Sound( "Weapon_UMP45.Single" )

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/cstrike/c_smg_ump45.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_ump45.mdl"

SWEP.HeadshotMultiplier = 4.5 -- brain fizz

SWEP.IronSightsPos = Vector( -8.78, -4.2, 4.2 )
SWEP.IronSightsAng = Vector( -1.5, -0.2, -2 )

--SWEP.DeploySpeed = 3

function SWEP:ShootBullet( dmg, recoil, numbul, cone )
   local sights = self:GetIronsights()

   numbul = numbul or 1
   cone   = cone   or 0.01

   -- 10% accuracy bonus when sighting
   cone = sights and (cone * 0.9) or cone

   local bullet = {}
   bullet.Num    = numbul
   bullet.Src    = self.Owner:GetShootPos()
   bullet.Dir    = self.Owner:GetAimVector()
   bullet.Spread = Vector( cone, cone, 0 )
   bullet.Tracer = 4
   bullet.Force  = 5
   bullet.Damage = dmg

   bullet.Callback = function(att, tr, dmginfo)
                        if SERVER or (CLIENT and IsFirstTimePredicted()) then
                           local ent = tr.Entity
                           if (not tr.HitWorld) and IsValid(ent) then
                              local edata = EffectData()

                              edata:SetEntity(ent)
                              edata:SetMagnitude(3)
                              edata:SetScale(2)

                              util.Effect("TeslaHitBoxes", edata)

                              if SERVER and ent:IsPlayer() then
                                 local eyeang = ent:EyeAngles()

                                 local j = 10
                                 eyeang.pitch = math.Clamp(eyeang.pitch + math.Rand(-j, j), -90, 90)
                                 eyeang.yaw = math.Clamp(eyeang.yaw + math.Rand(-j, j), -90, 90)
                                 ent:SetEyeAngles(eyeang)
                              end
                           end
                        end
                     end


   self.Owner:FireBullets( bullet )
   self.Weapon:SendWeaponAnim(self.PrimaryAnim)

   -- Owner can die after firebullets, giving an error at muzzleflash
   if not IsValid(self.Owner) or not self.Owner:Alive() then return end

   self.Owner:MuzzleFlash()
   self.Owner:SetAnimation( PLAYER_ATTACK1 )

   if self.Owner:IsNPC() then return end

   if ((game.SinglePlayer() and SERVER) or
       ((not game.SinglePlayer()) and CLIENT and IsFirstTimePredicted() )) then

      -- reduce recoil if ironsighting
      recoil = sights and (recoil * 0.75) or recoil

      local eyeang = self.Owner:EyeAngles()
      eyeang.pitch = eyeang.pitch - recoil
      self.Owner:SetEyeAngles( eyeang )

   end
end
