
AddCSLuaFile()

SWEP.HoldType              = "normal"

if CLIENT then
   SWEP.PrintName          = "decoy_name"
   SWEP.Slot               = 7

   SWEP.ViewModelFOV       = 10
   SWEP.ViewModelFlip      = false
   SWEP.DrawCrosshair      = false

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "decoy_desc"
   };

   SWEP.Icon                = "vgui/ttt/icon_beacon"
end

SWEP.Base                   = "weapon_tttbase"

SWEP.ViewModel              = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel             = "models/props_lab/reciever01b.mdl"

SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = true
SWEP.Primary.Ammo           = "none"
SWEP.Primary.Delay          = 1.0

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = true
SWEP.Secondary.Ammo         = "none"
SWEP.Secondary.Delay        = 1.0

SWEP.Kind                  = WEAPON_EQUIP2
SWEP.CanBuy                = {ROLE_TRAITOR}
SWEP.LimitedStock          = true -- only buyable once
SWEP.WeaponID              = AMMO_DECOY

SWEP.AllowDrop             = false
SWEP.NoSights              = true

function SWEP:OnDrop()
   self:Remove()
end

function SWEP:PrimaryAttack()
   self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

   self:DecoyStick()
end
function SWEP:SecondaryAttack()
   self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )

   self:DecoyStick()
end

local throwsound = Sound( "Weapon_SLAM.SatchelThrow" )

-- Drop is disabled to prevent traitors from placing the decoy in unreachable
-- places.
function SWEP:DecoyDrop()
   if SERVER then
      local ply = self:GetOwner()
      if not IsValid(ply) then return end

      if self.Planted then return end

      local vsrc = ply:GetShootPos()
      local vang = ply:GetAimVector()
      local vvel = ply:GetVelocity()
      
      local vthrow = vvel + vang * 200

      local decoy = ents.Create("ttt_decoy")
      if IsValid(decoy) then
         decoy:SetPos(vsrc + vang * 10)
         decoy:SetOwner(ply)
         decoy:Spawn()

         decoy:PointAtEntity(ply)
         
         local ang = decoy:GetAngles()
         ang:RotateAroundAxis(ang:Right(), 90)
         decoy:SetAngles(ang)

         decoy:PhysWake()
         local phys = decoy:GetPhysicsObject()
         if IsValid(phys) then
            phys:SetVelocity(vthrow)
         end   

         self:PlacedDecoy(decoy)
      end
   end

   self:EmitSound(throwsound)
end

function SWEP:DecoyStick()
   if SERVER then
      local ply = self:GetOwner()
      if not IsValid(ply) then return end

      if self.Planted then return end

      local ignore = {ply, self}
      local spos = ply:GetShootPos()
      local epos = spos + ply:GetAimVector() * 80
      local tr = util.TraceLine({start=spos, endpos=epos, filter=ignore, mask=MASK_SOLID})

      if tr.HitWorld then
         local decoy = ents.Create("ttt_decoy")
         if IsValid(decoy) then
            decoy:PointAtEntity(ply)

            local tr_ent = util.TraceEntity({start=spos, endpos=epos, filter=ignore, mask=MASK_SOLID}, decoy)

            if tr_ent.HitWorld then

               local ang = tr_ent.HitNormal:Angle()

               decoy:SetPos(tr_ent.HitPos + ang:Forward() * 2.5)
               decoy:SetAngles(ang)
               decoy:SetOwner(ply)
               decoy:Spawn()
               
               local phys = decoy:GetPhysicsObject()
               if IsValid(phys) then
                  phys:EnableMotion(false)
               end

               decoy.IsOnWall = true

               self:PlacedDecoy(decoy)
            end
         end
      end
   end
end

function SWEP:PlacedDecoy(decoy)
   self:GetOwner().decoy = decoy

   self:TakePrimaryAmmo(1)

   if not self:CanPrimaryAttack() then
      self:Remove()

      self.Planted = true
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

if CLIENT then
   function SWEP:Initialize()
      self:AddHUDHelp("decoy_help_pri", nil, true)

      return self.BaseClass.Initialize(self)
   end
end

function SWEP:Deploy()
   self:GetOwner():DrawViewModel(false)
   return true
end

function SWEP:DrawWorldModel()
   if not IsValid(self:GetOwner()) then
      self:DrawModel()
   end
end

function SWEP:DrawWorldModelTranslucent()
end
