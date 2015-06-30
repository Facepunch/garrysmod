
if ( !IsMounted( "ep2" ) ) then return end

AddCSLuaFile()

if ( CLIENT ) then
	SWEP.PrintName	= "Flechette Gun"
	SWEP.Author		= "garry"
	SWEP.Purpose	= "Shoot flechettes with primary attack."
	SWEP.Slot		= 1
	SWEP.SlotPos	= 2
	SWEP.DrawAmmo	= false

	game.AddParticles( "particles/hunter_flechette.pcf" )
	game.AddParticles( "particles/hunter_projectile.pcf" )
end

SWEP.ViewModel		= Model( "models/weapons/c_smg1.mdl" )
SWEP.WorldModel		= Model( "models/weapons/w_smg1.mdl" )
SWEP.ViewModelFOV	= 54
SWEP.UseHands		= true
SWEP.HoldType		= "smg"

SWEP.Spawnable		= true
SWEP.AdminOnly		= true

SWEP.Primary = 
{
	ClipSize		= -1,
	DefaultClip		= -1,
	Automatic		= true,
	Ammo			= "none",
	Delay			= 0.1
}

SWEP.Secondary = 
{
	ClipSize		= -1,
	DefaultClip		= -1,
	Automatic		= false,
	Ammo			= "none"
}

local ShootSound = Sound( "NPC_Hunter.FlechetteShoot" )

function SWEP:Reload()
end

function SWEP:PrimaryAttack()

	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	self:EmitSound( ShootSound )
	self:ShootEffects( self )
	
	if ( CLIENT ) then return end
	
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
end

function SWEP:ShouldDropOnDie()

	return false

end
