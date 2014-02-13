
-- DISABLED: Beacons are meant to signal locations. In practice no one uses
-- them. I'm leaving the weapon in in case I think of a way to make it useful,
-- or if you want to experiment with it. Uncomment the two lines that say
-- "DISABLED" above them (ie. the AddCSLua and SWEP.CanBuy) and the weapon will
-- appear in the detective's equipment menu. Do the same for the ttt_beacon
-- entity to make it all work.

if SERVER then
   -- DISABLED
   --AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType = "normal"

if CLIENT then
   SWEP.PrintName			= "Beacon"
   SWEP.Slot				= 6
   SWEP.SlotPos			= 0

   SWEP.ViewModelFOV = 10

   SWEP.EquipMenuData = {
      type="Weapon",
      model="models/props_lab/reciever01b.mdl",
      desc="Broadcasts a location to everyone.\n\nUse to warn or group innocents."
   };

   SWEP.Icon = "VGUI/ttt/icon_beacon"
end

SWEP.Base = "weapon_tttbase"

SWEP.Spawnable          = true
SWEP.ViewModel          = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel         = "models/props_lab/reciever01b.mdl"
SWEP.AutoSwitchTo       = false
SWEP.AutoSwitchFrom     = false
SWEP.DrawCrosshair      = true
SWEP.ViewModelFlip      = false
SWEP.Primary.ClipSize       = 3
SWEP.Primary.DefaultClip    = 1
SWEP.Primary.Automatic      = true
SWEP.Primary.Ammo       = "slam"
SWEP.Primary.Delay = 1.0

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = true
SWEP.Secondary.Ammo     = "none"
SWEP.Secondary.Delay = 1.0

SWEP.Kind = WEAPON_EQUIP
-- DISABLED
--SWEP.CanBuy = {ROLE_DETECTIVE} -- only detectives can buy
SWEP.LimitedStock = true -- only buyable once
SWEP.WeaponID = AMMO_BEACON


SWEP.AllowDrop = false

SWEP.NoSights = true

function SWEP:OnDrop()
   self:Remove()
end

function SWEP:PrimaryAttack()
   self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

   if self:CanPrimaryAttack() then
      self:BeaconDrop()
   end
end
function SWEP:SecondaryAttack()
   self.Weapon:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )

   if self:CanPrimaryAttack() then
      self:BeaconStick()
   end
end

local throwsound = Sound( "Weapon_SLAM.SatchelThrow" )

-- might be able to move this drop/stick stuff into something more general now
-- that a number of weapons use it
function SWEP:BeaconDrop()
   if SERVER then
      local ply = self.Owner
      if not IsValid(ply) then return end

      if self.Planted then return end

      local vsrc = ply:GetShootPos()
      local vang = ply:GetAimVector()
      local vvel = ply:GetVelocity()
      
      local vthrow = vvel + vang * 200

      local beacon = ents.Create("ttt_beacon")
      if IsValid(beacon) then
         beacon:SetPos(vsrc + vang * 10)
         beacon:SetOwner(ply)
         beacon:Spawn()

         beacon.fingerprints = self.fingerprints

         beacon:PointAtEntity(ply)
         
         local ang = beacon:GetAngles()
         ang:RotateAroundAxis(ang:Right(), 90)
         beacon:SetAngles(ang)

         beacon:PhysWake()
         local phys = beacon:GetPhysicsObject()
         if IsValid(phys) then
            phys:SetVelocity(vthrow)
         end   

         self:PlacedBeacon()
      end
   end

   self.Weapon:EmitSound(throwsound)
end

function SWEP:BeaconStick()
   if SERVER then
      local ply = self.Owner
      if not IsValid(ply) then return end

      if self.Planted then return end

      local ignore = {ply, self.Weapon}
      local spos = ply:GetShootPos()
      local epos = spos + ply:GetAimVector() * 80
      local tr = util.TraceLine({start=spos, endpos=epos, filter=ignore, mask=MASK_SOLID})

      if tr.HitWorld then
         local beacon = ents.Create("ttt_beacon")
         if IsValid(beacon) then
            beacon:PointAtEntity(ply)

            local tr_ent = util.TraceEntity({start=spos, endpos=epos, filter=ignore, mask=MASK_SOLID}, beacon)

            if tr_ent.HitWorld then

               local ang = tr_ent.HitNormal:Angle()
               --ang:RotateAroundAxis(ang:Right(), -90)
               --ang:RotateAroundAxis(ang:Up(), -180)
               --ang:RotateAroundAxis(ang:Forward(), 90)

               beacon:SetPos(tr_ent.HitPos + ang:Forward() * 2.5)
               beacon:SetAngles(ang)
               beacon:SetOwner(ply)
               beacon:Spawn()
               
               local phys = beacon:GetPhysicsObject()
               if IsValid(phys) then
                  phys:EnableMotion(false)
               end

               beacon.IsOnWall = true

               self:PlacedBeacon()
            end
         end
      end
   end
end

function SWEP:PlacedBeacon()
   self:TakePrimaryAmmo(1)

   if not self:CanPrimaryAttack() then
      self:Remove()

      self.Planted = true
   end
end

function SWEP:PickupBeacon()
   if self.Weapon:Clip1() >= self.Primary.ClipSize then
      return false
   else
      self.Weapon:SetClip1(self.Weapon:Clip1() + 1)
      return true
   end
end

-- Ammo hackery after getting bought
function SWEP:WasBought(buyer)
   self.Weapon:SetClip1(self.Weapon:Clip1() + 2)
end

function SWEP:Reload()
   return false
end

function SWEP:OnRemove()
   if CLIENT and IsValid(self.Owner) and self.Owner == LocalPlayer() and self.Owner:Alive() then
      RunConsoleCommand("lastinv")
   end
end

if CLIENT then
   local hudtxt = {text="Click to place the beacon", font="TabLarge", xalign=TEXT_ALIGN_RIGHT}
   function SWEP:DrawHUD()
      hudtxt.pos = {ScrW() - 80, ScrH() - 80}
      draw.Text(hudtxt)
      draw.TextShadow(hudtxt, 2)
   end
end
-- Invisible, same hacks as holstered weapon

local hidden = false
function SWEP:Deploy()
   hidden = false
   return true
end

function SWEP:DrawWorldModel()
end

function SWEP:DrawWorldModelTranslucent()
end

-- not able to do DrawModel stuff in Deploy, so here's a hack
function SWEP:Think()
   if SERVER and not hidden and IsValid(self.Owner) and self.Owner:GetActiveWeapon() == self.Weapon then
      self.Owner:DrawViewModel(false)
      self.Owner:DrawWorldModel(false)
      hidden = true
   end
end
