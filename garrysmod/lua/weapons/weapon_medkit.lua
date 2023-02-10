
AddCSLuaFile()

SWEP.PrintName = "#GMOD_MedKit"
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
SWEP.Primary.DefaultClip = 100
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.HoldType = "slam"

SWEP.HealSound = Sound( "HealthKit.Touch" )
SWEP.DenySound = Sound( "WallHealth.Deny" )

SWEP.HealCooldown = 0.5
SWEP.DenyCooldown = 1

SWEP.HealAmount = 20 -- Maximum heal amount per use
SWEP.HealRange = 64

SWEP.AmmoRegenFrequency = 1 -- Number of seconds before each ammo regen
SWEP.AmmoRegenAmount = 2 -- Amount of ammo refilled every AmmoRegenFrequency seconds

function SWEP:Initialize()

	self:SetHoldType( self.HoldType )

	if ( CLIENT ) then
		self.AmmoDisplay = {
			Draw = true,
			PrimaryClip = 0
		}
	end

end

function SWEP:SetupDataTables()

	self:NetworkVar( "Float", 0, "NextAmmoRegen" )
	self:NetworkVar( "Float", 1, "NextIdle" )

end

function SWEP:PrimaryAttack()

	local owner = self:GetOwner()
	local isplayer = SERVER and owner:IsPlayer()

	if ( isplayer ) then
		owner:LagCompensation( true )
	end

	local startpos, endpos = owner:GetShootPos(), owner:GetAimVector()
	endpos:Mul( self.HealRange )
	endpos:Add( startpos )

	local tr = {
		start = startpos,
		endpos = endpos,
		filter = owner,
		output = nil
	}
	tr.output = tr -- Reuse our trace data table for our return data

	util.TraceLine( tr )

	if ( isplayer ) then
		owner:LagCompensation( false )
	end

	self:DoHeal( tr.Entity )

end

function SWEP:SecondaryAttack()

	self:DoHeal( self:GetOwner() )

end

-- Basic black/whitelist function
-- Checking if the entity's health is below its max is done in SWEP:DoHeal
function SWEP:CanHeal( ent )

	-- ent may be NULL here, but these functions return false for it
	return ent:IsPlayer() or ent:IsNPC()

end

function SWEP:HealEntity( ent, amount )

	-- Heal ent
	self:TakePrimaryAmmo( amount )
	ent:SetHealth( ent:GetHealth() + amount )

	-- Do effects
	self:EmitSound( self.HealSound )
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )

	local owner = self:GetOwner()

	if ( owner:IsValid() ) then
		owner:SetAnimation( PLAYER_ATTACK1 )
	end

	local endtime = CurTime() + self:SequenceDuration()
	self:SetNextIdle( endtime )

	-- Setup next firing time
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

function SWEP:DoHeal( ent )

	if ( !self:CanHeal( ent ) ) then self:HealFail( ent ) return false end

	local health, maxhealth = ent:Health(), ent:GetMaxHealth()
	if ( health >= maxhealth ) then self:HealFail( ent ) return false end

	local need = math.min( maxhealth - health, self.HealAmount )
	if ( self:Clip1() < need ) then self:HealFail( ent ) return false end

	self:HealEntity( ent, need )

	return true

end

function SWEP:Think()

	local curtime = CurTime()

	if ( curtime >= self:GetNextAmmoRegen() ) then
		local clip1 = self:Clip1()
		local maxammo = self.Primary.ClipSize

		if ( clip1 < maxammo ) then
			self:SetClip1( math.min( clip1 + self.AmmoRegenAmount, maxammo ) )
		end

		self:SetNextAmmoRegen( curtime + self.AmmoRegenFrequency )
	end

	if ( curtime >= self:GetNextIdle() ) then
		self:SendWeaponAnim( ACT_VM_IDLE )
		self:SetNextIdle( curtime + self:SequenceDuration() )
	end

end

if ( CLIENT ) then
	function SWEP:CustomAmmoDisplay()

		local display = self.AmmoDisplay
		display.PrimaryClip = self:Clip1()

		return self.AmmoDisplay

	end
end
