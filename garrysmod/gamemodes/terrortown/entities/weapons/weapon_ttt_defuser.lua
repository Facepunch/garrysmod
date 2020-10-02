AddCSLuaFile()

SWEP.HoldType                = "slam"

if CLIENT then
   SWEP.PrintName            = "defuser_name"
   SWEP.Slot                 = 7

   SWEP.DrawCrosshair        = false
   SWEP.ViewModelFOV         = 10

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "defuser_desc"
   };

   SWEP.Icon                 = "vgui/ttt/icon_defuser"
end

SWEP.Base                    = "weapon_tttbase"

SWEP.ViewModel               = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel              = "models/weapons/w_defuser.mdl"

SWEP.Primary.ClipSize        = -1
SWEP.Primary.DefaultClip     = -1
SWEP.Primary.Automatic       = true
SWEP.Primary.Delay           = 1
SWEP.Primary.Ammo            = "none"

SWEP.Secondary.ClipSize       = -1
SWEP.Secondary.DefaultClip    = -1
SWEP.Secondary.Automatic      = true
SWEP.Secondary.Ammo           = "none"
SWEP.Secondary.Delay          = 2

SWEP.Kind                     = WEAPON_EQUIP2
SWEP.CanBuy                   = {ROLE_DETECTIVE} -- only detectives can buy
SWEP.WeaponID                 = AMMO_DEFUSER

--SWEP.AllowDrop = false

local defuse = Sound("c4.disarmfinish")
function SWEP:PrimaryAttack()
   self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

   local spos = self:GetOwner():GetShootPos()
   local sdest = spos + (self:GetOwner():GetAimVector() * 80)

   local tr = util.TraceLine({start=spos, endpos=sdest, filter=self:GetOwner(), mask=MASK_SHOT})

   if IsValid(tr.Entity) and tr.Entity.Defusable then
      local bomb = tr.Entity
      if bomb.Defusable==true or bomb:Defusable() then
         if SERVER and bomb.Disarm then
            bomb:Disarm(self:GetOwner())
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
      if not IsValid(self:GetOwner()) then
         self:DrawModel()
      end
   end
end

function SWEP:Reload()
   return false
end

function SWEP:Deploy()
   if SERVER and IsValid(self:GetOwner()) then
      self:GetOwner():DrawViewModel(false)
   end
   return true
end


function SWEP:OnDrop()
end
