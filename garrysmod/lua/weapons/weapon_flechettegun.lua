
if ( !IsMounted( "ep2" ) ) then return end

AddCSLuaFile()

SWEP.PrintName = "Flechette Gun"
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

function SWEP:PrimaryAttack()

	self:SetNextPrimaryFire( CurTime() + 0.1 )

	self:EmitSound( ShootSound )
	self:ShootEffects( self )

	if ( !SERVER ) then return end

	local Forward = self.Owner:EyeAngles():Forward()

	local ent = ents.Create( "hunter_flechette" )
	if ( IsValid( ent ) ) then

		ent:SetPos( self.Owner:GetShootPos() + Forward * 32 )
		ent:SetAngles( self.Owner:EyeAngles() )
		ent:Spawn()

		ent:SetVelocity( Forward * 2000 )
		ent:SetOwner( self.Owner )

	end

end

function SWEP:SecondaryAttack()

	-- TODO: Reimplement the old rollermine secondary attack?

end

function SWEP:ShouldDropOnDie()

	return false

end
