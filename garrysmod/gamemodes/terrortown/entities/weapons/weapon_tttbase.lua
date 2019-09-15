-- Custom weapon base, used to derive from CS one, still very similar

AddCSLuaFile()

---- TTT SPECIAL EQUIPMENT FIELDS

-- This must be set to one of the WEAPON_ types in TTT weapons for weapon
-- carrying limits to work properly. See /gamemode/shared.lua for all possible
-- weapon categories.
SWEP.Kind = WEAPON_NONE

-- If CanBuy is a table that contains ROLE_TRAITOR and/or ROLE_DETECTIVE, those
-- players are allowed to purchase it and it will appear in their Equipment Menu
-- for that purpose. If CanBuy is nil this weapon cannot be bought.
--   Example: SWEP.CanBuy = { ROLE_TRAITOR }
-- (just setting to nil here to document its existence, don't make this buyable)
SWEP.CanBuy = nil

if CLIENT then
   -- If this is a buyable weapon (ie. CanBuy is not nil) EquipMenuData must be
   -- a table containing some information to show in the Equipment Menu. See
   -- default equipment weapons for real-world examples.
   SWEP.EquipMenuData = nil

   -- Example data:
   -- SWEP.EquipMenuData = {
   --
   ---- Type tells players if it's a weapon or item
   --     type = "Weapon",
   --
   ---- Desc is the description in the menu. Needs manual linebreaks (via \n).
   --     desc = "Text."
   -- };

   -- This sets the icon shown for the weapon in the DNA sampler, search window,
   -- equipment menu (if buyable), etc.
   SWEP.Icon = "vgui/ttt/icon_nades" -- most generic icon I guess

   -- You can make your own weapon icon using the template in:
   --   /garrysmod/gamemodes/terrortown/template/

   -- Open one of TTT's icons with VTFEdit to see what kind of settings to use
   -- when exporting to VTF. Once you have a VTF and VMT, you can
   -- resource.AddFile("materials/vgui/...") them here. GIVE YOUR ICON A UNIQUE
   -- FILENAME, or it WILL be overwritten by other servers! Gmod does not check
   -- if the files are different, it only looks at the name. I recommend you
   -- create your own directory so that this does not happen,
   -- eg. /materials/vgui/ttt/mycoolserver/mygun.vmt
end

---- MISC TTT-SPECIFIC BEHAVIOUR CONFIGURATION

-- ALL weapons in TTT must have weapon_tttbase as their SWEP.Base. It provides
-- some functions that TTT expects, and you will get errors without them.
-- Of course this is weapon_tttbase itself, so I comment this out here.
--  SWEP.Base = "weapon_tttbase"

-- If true AND SWEP.Kind is not WEAPON_EQUIP, then this gun can be spawned as
-- random weapon by a ttt_random_weapon entity.
SWEP.AutoSpawnable = false

-- Set to true if weapon can be manually dropped by players (with Q)
SWEP.AllowDrop = true

-- Set to true if weapon kills silently (no death scream)
SWEP.IsSilent = false

-- If this weapon should be given to players upon spawning, set a table of the
-- roles this should happen for here
--  SWEP.InLoadoutFor = { ROLE_TRAITOR, ROLE_DETECTIVE, ROLE_INNOCENT }

-- DO NOT set SWEP.WeaponID. Only the standard TTT weapons can have it. Custom
-- SWEPs do not need it for anything.
--  SWEP.WeaponID = nil

---- YE OLDE SWEP STUFF

if CLIENT then
   SWEP.DrawCrosshair   = false
   SWEP.ViewModelFOV    = 82
   SWEP.ViewModelFlip   = true
   SWEP.CSMuzzleFlashes = true
end

SWEP.Base = "weapon_base"

SWEP.Category           = "TTT"
SWEP.Spawnable          = false

SWEP.IsGrenade = false

SWEP.Weight             = 5
SWEP.AutoSwitchTo       = false
SWEP.AutoSwitchFrom     = false

SWEP.Primary.Sound          = Sound( "Weapon_Pistol.Empty" )
SWEP.Primary.Recoil         = 1.5
SWEP.Primary.Damage         = 1
SWEP.Primary.NumShots       = 1
SWEP.Primary.Cone           = 0.02
SWEP.Primary.Delay          = 0.15

SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = false
SWEP.Primary.Ammo           = "none"
SWEP.Primary.ClipMax        = -1

SWEP.Secondary.ClipSize     = 1
SWEP.Secondary.DefaultClip  = 1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "none"
SWEP.Secondary.ClipMax      = -1

SWEP.HeadshotMultiplier = 2.7

SWEP.StoredAmmo = 0
SWEP.IsDropped = false

SWEP.DeploySpeed = 1.4

SWEP.PrimaryAnim = ACT_VM_PRIMARYATTACK
SWEP.ReloadAnim = ACT_VM_RELOAD

SWEP.fingerprints = {}

local sparkle = CLIENT and CreateConVar("ttt_crazy_sparks", "0", FCVAR_ARCHIVE)

-- crosshair
if CLIENT then
   local sights_opacity = CreateConVar("ttt_ironsights_crosshair_opacity", "0.8", FCVAR_ARCHIVE)
   local crosshair_brightness = CreateConVar("ttt_crosshair_brightness", "1.0", FCVAR_ARCHIVE)
   local crosshair_size = CreateConVar("ttt_crosshair_size", "1.0", FCVAR_ARCHIVE)
   local disable_crosshair = CreateConVar("ttt_disable_crosshair", "0", FCVAR_ARCHIVE)

   function SWEP:DrawHUD()
      if self.HUDHelp then
         self:DrawHelp()
      end

      local client = LocalPlayer()
      if disable_crosshair:GetBool() or (not IsValid(client)) then return end

      local sights = (not self.NoSights) and self:GetIronsights()

      local x = math.floor(ScrW() / 2.0)
      local y = math.floor(ScrH() / 2.0)
      local scale = math.max(0.2,  10 * self:GetPrimaryCone())

      local LastShootTime = self:LastShootTime()
      scale = scale * (2 - math.Clamp( (CurTime() - LastShootTime) * 5, 0.0, 1.0 ))

      local alpha = sights and sights_opacity:GetFloat() or 1
      local bright = crosshair_brightness:GetFloat() or 1

      -- somehow it seems this can be called before my player metatable
      -- additions have loaded
      if client.IsTraitor and client:IsTraitor() then
         surface.SetDrawColor(255 * bright,
                              50 * bright,
                              50 * bright,
                              255 * alpha)
      else
         surface.SetDrawColor(0,
                              255 * bright,
                              0,
                              255 * alpha)
      end

      local gap = math.floor(20 * scale * (sights and 0.8 or 1))
      local length = math.floor(gap + (25 * crosshair_size:GetFloat()) * scale)
      surface.DrawLine( x - length, y, x - gap, y )
      surface.DrawLine( x + length, y, x + gap, y )
      surface.DrawLine( x, y - length, x, y - gap )
      surface.DrawLine( x, y + length, x, y + gap )
   end

   local GetPTranslation = LANG.GetParamTranslation

   -- Many non-gun weapons benefit from some help
   local help_spec = {text = "", font = "TabLarge", xalign = TEXT_ALIGN_CENTER}
   function SWEP:DrawHelp()
      local data = self.HUDHelp

      local translate = data.translatable
      local primary   = data.primary
      local secondary = data.secondary

      if translate then
         primary   = primary   and GetPTranslation(primary,   data.translate_params)
         secondary = secondary and GetPTranslation(secondary, data.translate_params)
      end

      help_spec.pos  = {ScrW() / 2.0, ScrH() - 40}
      help_spec.text = secondary or primary
      draw.TextShadow(help_spec, 2)

      -- if no secondary exists, primary is drawn at the bottom and no top line
      -- is drawn
      if secondary then
         help_spec.pos[2] = ScrH() - 60
         help_spec.text = primary
         draw.TextShadow(help_spec, 2)
      end
   end

   -- mousebuttons are enough for most weapons
   local default_key_params = {
      primaryfire   = Key("+attack",  "LEFT MOUSE"),
      secondaryfire = Key("+attack2", "RIGHT MOUSE"),
      usekey        = Key("+use",     "USE")
   };

   function SWEP:AddHUDHelp(primary_text, secondary_text, translate, extra_params)
      extra_params = extra_params or {}

      self.HUDHelp = {
         primary = primary_text,
         secondary = secondary_text,
         translatable = translate,
         translate_params = table.Merge(extra_params, default_key_params)
      };
   end
end

-- Shooting functions largely copied from weapon_cs_base
function SWEP:PrimaryAttack(worldsnd)

   self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
   self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

   if not self:CanPrimaryAttack() then return end

   if not worldsnd then
      self:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
   elseif SERVER then
      sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
   end

   self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self:GetPrimaryCone() )

   self:TakePrimaryAmmo( 1 )

   local owner = self:GetOwner()
   if not IsValid(owner) or owner:IsNPC() or (not owner.ViewPunch) then return end

   owner:ViewPunch( Angle( util.SharedRandom(self:GetClass(),-0.2,-0.1,0) * self.Primary.Recoil, util.SharedRandom(self:GetClass(),-0.1,0.1,1) * self.Primary.Recoil, 0 ) )
end

function SWEP:DryFire(setnext)
   if CLIENT and LocalPlayer() == self:GetOwner() then
      self:EmitSound( "Weapon_Pistol.Empty" )
   end

   setnext(self, CurTime() + 0.2)

   self:Reload()
end

function SWEP:CanPrimaryAttack()
   if not IsValid(self:GetOwner()) then return end

   if self:Clip1() <= 0 then
      self:DryFire(self.SetNextPrimaryFire)
      return false
   end
   return true
end

function SWEP:CanSecondaryAttack()
   if not IsValid(self:GetOwner()) then return end

   if self:Clip2() <= 0 then
      self:DryFire(self.SetNextSecondaryFire)
      return false
   end
   return true
end

local function Sparklies(attacker, tr, dmginfo)
   if tr.HitWorld and tr.MatType == MAT_METAL then
      local eff = EffectData()
      eff:SetOrigin(tr.HitPos)
      eff:SetNormal(tr.HitNormal)
      util.Effect("cball_bounce", eff)
   end
end

function SWEP:ShootBullet( dmg, recoil, numbul, cone )

   self:SendWeaponAnim(self.PrimaryAnim)

   self:GetOwner():MuzzleFlash()
   self:GetOwner():SetAnimation( PLAYER_ATTACK1 )

   local sights = self:GetIronsights()

   numbul = numbul or 1
   cone   = cone   or 0.01

   local bullet = {}
   bullet.Num    = numbul
   bullet.Src    = self:GetOwner():GetShootPos()
   bullet.Dir    = self:GetOwner():GetAimVector()
   bullet.Spread = Vector( cone, cone, 0 )
   bullet.Tracer = 4
   bullet.TracerName = self.Tracer or "Tracer"
   bullet.Force  = 10
   bullet.Damage = dmg
   if CLIENT and sparkle:GetBool() then
      bullet.Callback = Sparklies
   end

   self:GetOwner():FireBullets( bullet )

   -- Owner can die after firebullets
   if (not IsValid(self:GetOwner())) or (not self:GetOwner():Alive()) or self:GetOwner():IsNPC() then return end

   if ((game.SinglePlayer() and SERVER) or
       ((not game.SinglePlayer()) and CLIENT and IsFirstTimePredicted())) then

      -- reduce recoil if ironsighting
      recoil = sights and (recoil * 0.6) or recoil

      local eyeang = self:GetOwner():EyeAngles()
      eyeang.pitch = eyeang.pitch - recoil
      self:GetOwner():SetEyeAngles( eyeang )
   end
end

function SWEP:GetPrimaryCone()
   local cone = self.Primary.Cone or 0.2
   -- 10% accuracy bonus when sighting
   return self:GetIronsights() and (cone * 0.85) or cone
end

function SWEP:GetHeadshotMultiplier(victim, dmginfo)
   return self.HeadshotMultiplier
end

function SWEP:IsEquipment()
   return WEPS.IsEquipment(self)
end

function SWEP:DrawWeaponSelection() end

function SWEP:SecondaryAttack()
   if self.NoSights or (not self.IronSightsPos) then return end

   self:SetIronsights(not self:GetIronsights())

   self:SetNextSecondaryFire(CurTime() + 0.3)
end

function SWEP:Deploy()
   self:SetIronsights(false)
   return true
end

function SWEP:Reload()
   if ( self:Clip1() == self.Primary.ClipSize or self:GetOwner():GetAmmoCount( self.Primary.Ammo ) <= 0 ) then return end
   self:DefaultReload(self.ReloadAnim)
   self:SetIronsights( false )
end


function SWEP:OnRestore()
   self.NextSecondaryAttack = 0
   self:SetIronsights( false )
end

function SWEP:Ammo1()
   return IsValid(self:GetOwner()) and self:GetOwner():GetAmmoCount(self.Primary.Ammo) or false
end

-- The OnDrop() hook is useless for this as it happens AFTER the drop. OwnerChange
-- does not occur when a drop happens for some reason. Hence this thing.
function SWEP:PreDrop()
   if SERVER and IsValid(self:GetOwner()) and self.Primary.Ammo != "none" then
      local ammo = self:Ammo1()

      -- Do not drop ammo if we have another gun that uses this type
      for _, w in pairs(self:GetOwner():GetWeapons()) do
         if IsValid(w) and w != self and w:GetPrimaryAmmoType() == self:GetPrimaryAmmoType() then
            ammo = 0
         end
      end

      self.StoredAmmo = ammo

      if ammo > 0 then
         self:GetOwner():RemoveAmmo(ammo, self.Primary.Ammo)
      end
   end
end

function SWEP:DampenDrop()
   -- For some reason gmod drops guns on death at a speed of 400 units, which
   -- catapults them away from the body. Here we want people to actually be able
   -- to find a given corpse's weapon, so we override the velocity here and call
   -- this when dropping guns on death.
   local phys = self:GetPhysicsObject()
   if IsValid(phys) then
      phys:SetVelocityInstantaneous(Vector(0,0,-75) + phys:GetVelocity() * 0.001)
      phys:AddAngleVelocity(phys:GetAngleVelocity() * -0.99)
   end
end

local SF_WEAPON_START_CONSTRAINED = 1

-- Picked up by player. Transfer of stored ammo and such.
function SWEP:Equip(newowner)
   if SERVER then
      if self:IsOnFire() then
         self:Extinguish()
      end

      self.fingerprints = self.fingerprints or {}

      if not table.HasValue(self.fingerprints, newowner) then
         table.insert(self.fingerprints, newowner)
      end

      if self:HasSpawnFlags(SF_WEAPON_START_CONSTRAINED) then
         -- If this weapon started constrained, unset that spawnflag, or the
         -- weapon will be re-constrained and float
         local flags = self:GetSpawnFlags()
         local newflags = bit.band(flags, bit.bnot(SF_WEAPON_START_CONSTRAINED))
         self:SetKeyValue("spawnflags", newflags)
      end
   end

   if SERVER and IsValid(newowner) and self.StoredAmmo > 0 and self.Primary.Ammo != "none" then
      local ammo = newowner:GetAmmoCount(self.Primary.Ammo)
      local given = math.min(self.StoredAmmo, self.Primary.ClipMax - ammo)

      newowner:GiveAmmo( given, self.Primary.Ammo)
      self.StoredAmmo = 0
   end
end

-- We were bought as special equipment, some weapons will want to do something
-- extra for their buyer
function SWEP:WasBought(buyer)
end

function SWEP:SetIronsights(b)
   if (b ~= self:GetIronsights()) then
      self:SetIronsightsPredicted(b)
      self:SetIronsightsTime(CurTime())
      if CLIENT then
         self:CalcViewModel()
      end
   end
end
function SWEP:GetIronsights()
   return self:GetIronsightsPredicted()
end

--- Dummy functions that will be replaced when SetupDataTables runs. These are
--- here for when that does not happen (due to e.g. stacking base classes)
function SWEP:GetIronsightsTime() return -1 end
function SWEP:SetIronsightsTime() end
function SWEP:GetIronsightsPredicted() return false end
function SWEP:SetIronsightsPredicted() end

-- Set up ironsights dt bool. Weapons using their own DT vars will have to make
-- sure they call this.
function SWEP:SetupDataTables()
   self:NetworkVar("Bool", 3, "IronsightsPredicted")
   self:NetworkVar("Float", 3, "IronsightsTime")
end

function SWEP:Initialize()
   if CLIENT and self:Clip1() == -1 then
      self:SetClip1(self.Primary.DefaultClip)
   elseif SERVER then
      self.fingerprints = {}

      self:SetIronsights(false)
   end

   self:SetDeploySpeed(self.DeploySpeed)

   -- compat for gmod update
   if self.SetHoldType then
      self:SetHoldType(self.HoldType or "pistol")
   end
end

function SWEP:CalcViewModel()
   if (not CLIENT) or (not IsFirstTimePredicted()) then return end
   self.bIron = self:GetIronsights()
   self.fIronTime = self:GetIronsightsTime()
   self.fCurrentTime = CurTime()
   self.fCurrentSysTime = SysTime()
end

-- Note that if you override Think in your SWEP, you should call
-- BaseClass.Think(self) so as not to break ironsights
function SWEP:Think()
   self:CalcViewModel()
end

function SWEP:DyingShot()
   local fired = false
   if self:GetIronsights() then
      self:SetIronsights(false)

      if self:GetNextPrimaryFire() > CurTime() then
         return fired
      end

      -- Owner should still be alive here
      if IsValid(self:GetOwner()) then
         local punch = self.Primary.Recoil or 5

         -- Punch view to disorient aim before firing dying shot
         local eyeang = self:GetOwner():EyeAngles()
         eyeang.pitch = eyeang.pitch - math.Rand(-punch, punch)
         eyeang.yaw = eyeang.yaw - math.Rand(-punch, punch)
         self:GetOwner():SetEyeAngles( eyeang )

         MsgN(self:GetOwner():Nick() .. " fired his DYING SHOT")

         self:GetOwner().dying_wep = self

         self:PrimaryAttack(true)

         fired = true
      end
   end

   return fired
end

local ttt_lowered = CreateConVar("ttt_ironsights_lowered", "1", FCVAR_ARCHIVE)
local host_timescale = GetConVar("host_timescale")

local LOWER_POS = Vector(0, 0, -2)

local IRONSIGHT_TIME = 0.25
function SWEP:GetViewModelPosition( pos, ang )
   if (not self.IronSightsPos) or (self.bIron == nil) then return pos, ang end

   local bIron = self.bIron
   local time = self.fCurrentTime + (SysTime() - self.fCurrentSysTime) * game.GetTimeScale() * host_timescale:GetFloat()

   if bIron then
      self.SwayScale = 0.3
      self.BobScale = 0.1
   else
      self.SwayScale = 1.0
      self.BobScale = 1.0
   end

   local fIronTime = self.fIronTime
   if (not bIron) and fIronTime < time - IRONSIGHT_TIME then
      return pos, ang
   end

   local mul = 1.0

   if fIronTime > time - IRONSIGHT_TIME then
      mul = math.Clamp( (time - fIronTime) / IRONSIGHT_TIME, 0, 1 )

      if not bIron then mul = 1 - mul end
   end

   local offset = self.IronSightsPos + (ttt_lowered:GetBool() and LOWER_POS or vector_origin)

   if self.IronSightsAng then
      ang = ang * 1
      ang:RotateAroundAxis( ang:Right(),    self.IronSightsAng.x * mul )
      ang:RotateAroundAxis( ang:Up(),       self.IronSightsAng.y * mul )
      ang:RotateAroundAxis( ang:Forward(),  self.IronSightsAng.z * mul )
   end

   pos = pos + offset.x * ang:Right() * mul
   pos = pos + offset.y * ang:Forward() * mul
   pos = pos + offset.z * ang:Up() * mul

   return pos, ang
end
