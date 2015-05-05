
AddCSLuaFile()


SWEP.HoldType			= "slam"

if CLIENT then
   SWEP.PrintName = "defuser_name"
   SWEP.Slot = 7

   SWEP.ViewModelFOV = 10

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "defuser_desc"
   };

   SWEP.Icon = "vgui/ttt/icon_defuser"
end

SWEP.Base = "weapon_tttbase"

SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_defuser.mdl"

SWEP.DrawCrosshair		= false
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Delay = 1
SWEP.Primary.Ammo		= "none"
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo		= "none"
SWEP.Secondary.Delay = 2

SWEP.Kind = WEAPON_EQUIP2
SWEP.CanBuy = {ROLE_DETECTIVE} -- only detectives can buy
SWEP.WeaponID = AMMO_DEFUSER


--SWEP.AllowDrop = false

local defuse = Sound("c4.disarmfinish")
function SWEP:PrimaryAttack()
   self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

   local spos = self.Owner:GetShootPos()
   local sdest = spos + (self.Owner:GetAimVector() * 80)

   local tr = util.TraceLine({start=spos, endpos=sdest, filter=self.Owner, mask=MASK_SHOT})

   if IsValid(tr.Entity) and tr.Entity.Defusable then
      local bomb = tr.Entity
      if bomb.Defusable==true or bomb:Defusable() then
         if SERVER and bomb.Disarm then
            bomb:Disarm(self.Owner)
            sound.Play(defuse, bomb:GetPos())
         end

         self:SetNextPrimaryFire( CurTime() + (self.Primary.Delay * 2) )
      end
   end
end

function SWEP:SecondaryAttack()
   self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
   self:SetNextSecondaryFire( CurTime() + 0.1 )
end


if CLIENT then
   function SWEP:Initialize()
      self:AddHUDHelp("defuser_help", nil, true)

      return self.BaseClass.Initialize(self)
   end

   function SWEP:DrawWorldModel()
      if not IsValid(self.Owner) then
         self:DrawModel()
      end
   end
end

function SWEP:Reload()
   return false
end

function SWEP:Deploy()
   if SERVER and IsValid(self.Owner) then
      self.Owner:DrawViewModel(false)
   end
   return true
end


function SWEP:OnDrop()
end
