
if ( !IsMounted( "ep2" ) ) then return end

-- Variables that are used on both client and server

AddCSLuaFile()

SWEP.Author			= ""
SWEP.Instructions	= "Shoots flechettes"

SWEP.Spawnable			= true
SWEP.AdminOnly			= true
SWEP.UseHands			= true

SWEP.ViewModel			= "models/weapons/c_smg1.mdl"
SWEP.WorldModel			= "models/weapons/w_smg1.mdl"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.PrintName			= "Flechette Gun"
SWEP.Slot				= 1
SWEP.SlotPos			= 2
SWEP.DrawAmmo			= false

game.AddParticles( "particles/hunter_flechette.pcf" )
game.AddParticles( "particles/hunter_projectile.pcf" )

local ShootSound = Sound( "NPC_Hunter.FlechetteShoot" )

/*---------------------------------------------------------
	Initialize
---------------------------------------------------------*/
function SWEP:Initialize()

	self:SetHoldType( "smg" )

end

/*---------------------------------------------------------
	Reload does nothing
---------------------------------------------------------*/
function SWEP:Reload()
end

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()

	self:SetNextPrimaryFire( CurTime() + 0.1 )

	self:EmitSound( ShootSound )
	self:ShootEffects( self )
	
	-- The rest is only done on the server
	if (!SERVER) then return end
	
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

/*---------------------------------------------------------
	SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()

	-- Right click does nothing..
	
end

/*---------------------------------------------------------
   Name: ShouldDropOnDie
   Desc: Should this weapon be dropped when its owner dies?
---------------------------------------------------------*/
function SWEP:ShouldDropOnDie()
	return false
end
