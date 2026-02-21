
AddCSLuaFile()

SWEP.PrintName = "#weapon_medkit"
SWEP.Author = "robotboy655, MaxOfS2D, code_gs"
SWEP.Purpose = "Heal other people with primary attack, heal yourself with secondary attack."

SWEP.Slot = 5
SWEP.SlotPos = 3

SWEP.Spawnable = true

SWEP.ViewModel = Model( "models/weapons/c_medkit.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_medkit.mdl" )
SWEP.ViewModelFOV = 54
SWEP.UseHands = true

SWEP.Primary.ClipSize = 100
SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.HoldType = "slam"

SWEP.HealSound = Sound( "HealthKit.Touch" )
SWEP.DenySound = Sound( "WallHealth.Deny" )

SWEP.HealCooldown = 0.5 -- Time between successful heals
SWEP.DenyCooldown = 1 -- Time between unsuccessful heals

SWEP.HealAmount = 20 -- Maximum heal amount per use
SWEP.HealRange = 64 -- Range in units at which healing works

SWEP.AmmoRegenRate = 1 -- Number of seconds before each ammo regen
SWEP.AmmoRegenAmount = 2 -- Amount of ammo refilled every AmmoRegenRate seconds

function SWEP:Initialize()

	self:SetHoldType( self.HoldType )

	-- Prevent large ammo jumps on-creation
	-- if DefaultClip < ClipSize
	self:SetLastAmmoRegen( CurTime() )

	if ( CLIENT ) then
		self.AmmoDisplay = {
			Draw = true,
			PrimaryClip = 0
		}
	end

end

function SWEP:Deploy()

	-- Regen what we've gained since we've holstered
	-- and realign the timer
	self:Regen( false )

	return true

end

function SWEP:SetupDataTables()

	self:NetworkVar( "Float", 0, "LastAmmoRegen" )
	self:NetworkVar( "Float", 1, "NextIdle" )

end

function SWEP:PrimaryAttack()

	local owner = self:GetOwner()
	local dolagcomp = SERVER and owner:IsPlayer()

	if ( dolagcomp ) then
		owner:LagCompensation( true )
	end

	local startpos = owner:GetShootPos()
	local tr = util.TraceLine( {
		start = startpos,
		endpos = startpos + owner:GetAimVector() * self.HealRange,
		filter = owner
	} )

	if ( dolagcomp ) then
		owner:LagCompensation( false )
	end

	self:DoHeal( tr.Entity )

end

function SWEP:SecondaryAttack()

	self:DoHeal( self:GetOwner() )

end

function SWEP:Reload()
end

local DAMAGE_YES = 2

-- Basic black/whitelist function
-- Checking if the entity's health is below its max is done in SWEP:DoHeal
function SWEP:CanHeal( ent )

	-- ent may be NULL here, but these functions return false for it
	if ( ent:IsPlayer() or ent:IsNPC() ) then
		local takedamage = ent:GetInternalVariable( "m_takedamage" )

		-- Don't heal turrets and helicopters
		return takedamage == nil or takedamage == DAMAGE_YES
	end

	return false

end

function SWEP:DoHeal( ent )

	local amount = self.HealAmount

	if ( !self:CanHeal( ent ) ) then self:HealFail( ent ) return false end

	local health, maxhealth = ent:Health(), ent:GetMaxHealth()
	if ( health >= maxhealth ) then self:HealFail( ent ) return false end

	-- Check regen right before we access the clip
	-- to make sure we're up to date
	self:Regen( true )

	local healamount = self.HealAmount

	-- No support for "damage kits"
	if ( healamount > 0 ) then
		healamount = math.min( maxhealth - health, healamount )
		local ammo = self:Clip1()
		if ( ammo < healamount ) then self:HealFail( ent ) return false end

		-- Heal ent
		self:SetClip1( ammo - healamount )
		ent:SetHealth( health + healamount )
	else
		healamount = 0
	end

	self:HealSuccess( ent, healamount )

	return true

end

function SWEP:HealSuccess( ent, healamount )

	-- Do effects
	self:EmitSound( self.HealSound )
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )

	local owner = self:GetOwner()

	if ( owner:IsValid() ) then
		owner:SetAnimation( PLAYER_ATTACK1 )
	end

	local curtime = CurTime()

	-- Reset regen time
	self:SetLastAmmoRegen( curtime )

	-- Set next idle time
	local endtime = curtime + self:SequenceDuration()
	self:SetNextIdle( endtime )

	-- Set next firing time
	endtime = endtime + self.HealCooldown
	self:SetNextPrimaryFire( endtime )
	self:SetNextSecondaryFire( endtime )

end

function SWEP:HealFail( ent )

	-- Do effects
	self:EmitSound( self.DenySound )

	-- Setup next firing time
	local endtime = CurTime() + self.DenyCooldown
	self:SetNextPrimaryFire( endtime )
	self:SetNextSecondaryFire( endtime )

end

function SWEP:Think()

	-- Try ammo regen
	-- but keep it aligned to the last action time
	self:Regen( true )

	-- Do idle anim
	self:Idle()

end

function SWEP:Regen( keepaligned )

	local curtime = CurTime()
	local lastregen = self:GetLastAmmoRegen()
	local timepassed = curtime - lastregen
	local regenrate = self.AmmoRegenRate

	-- Not ready to regenerate
	if ( timepassed < regenrate ) then return false end

	local ammo = self:Clip1()
	local maxammo = self.Primary.ClipSize

	-- Already at/over max ammo
	if ( ammo >= maxammo ) then return false end

	if ( regenrate > 0 ) then
		self:SetClip1( math.min( ammo + math.floor( timepassed / regenrate ) * self.AmmoRegenAmount, maxammo ) )

		-- If we are setting the last regen time from the Think function,
		-- keep it aligned with the last action time to prevent late Thinks from
		-- creating hiccups in the rate
		self:SetLastAmmoRegen( keepaligned == true and curtime + timepassed % regenrate or curtime )
	else
		self:SetClip1( maxammo )
		self:SetLastAmmoRegen( curtime )
	end

	return true

end

function SWEP:Idle()

	-- Update idle anim
	local curtime = CurTime()

	if ( curtime < self:GetNextIdle() ) then return false end

	self:SendWeaponAnim( ACT_VM_IDLE )
	self:SetNextIdle( curtime + self:SequenceDuration() )

	return true

end

-- The following code does not need to exist on the server, so bail
if ( SERVER ) then return end

function SWEP:CustomAmmoDisplay()

	local display = self.AmmoDisplay
	display.PrimaryClip = self:Clip1()

	return display

end
