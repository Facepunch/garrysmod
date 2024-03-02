
if ( !IsMounted( "ep2" ) ) then return end

AddCSLuaFile()

SWEP.PrintName = "#GMOD_FlechetteGun"
SWEP.Author = "garry"
SWEP.Purpose = "Shoot flechettes with primary attack."

SWEP.Slot = 1
SWEP.SlotPos = 2

SWEP.Spawnable = true

SWEP.ViewModel = Model( "models/weapons/c_smg1.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_smg1.mdl" )
SWEP.ViewModelFOV = 54
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = false
SWEP.AdminOnly = true

game.AddParticles( "particles/hunter_flechette.pcf" )
game.AddParticles( "particles/hunter_projectile.pcf" )

local ShootSound = Sound( "NPC_Hunter.FlechetteShoot" )

function SWEP:Initialize()

	self:SetHoldType( "smg" )

end

function SWEP:Reload()
end

function SWEP:CanBePickedUpByNPCs()
	return true
end

function SWEP:PrimaryAttack()

	self:SetNextPrimaryFire( CurTime() + 0.1 )

	self:EmitSound( ShootSound )
	self:ShootEffects()

	if ( CLIENT ) then return end

	SuppressHostEvents( NULL ) -- Do not suppress the flechette effects

	local ent = ents.Create( "hunter_flechette" )
	if ( !IsValid( ent ) ) then return end

	local owner = self:GetOwner()

	local Forward = owner:GetAimVector()

	ent:SetPos( owner:GetShootPos() + Forward * 32 )
	ent:SetAngles( owner:EyeAngles() )
	ent:SetOwner( owner )
	ent:Spawn()
	ent:Activate()

	ent:SetVelocity( Forward * 2000 )

end

function SWEP:SecondaryAttack()

	-- TODO: Reimplement the old rollermine secondary attack?

end

function SWEP:ShouldDropOnDie()

	return false

end

function SWEP:GetNPCRestTimes()

	-- Handles the time between bursts
	-- Min rest time in seconds, max rest time in seconds

	return 0.3, 0.6

end

function SWEP:GetNPCBurstSettings()

	-- Handles the burst settings
	-- Minimum amount of shots, maximum amount of shots, and the delay between each shot
	-- The amount of shots can end up lower than specificed

	return 1, 6, 0.1

end

function SWEP:GetNPCBulletSpread( proficiency )

	-- Handles the bullet spread based on the given proficiency
	-- return value is in degrees

	return 1

end
