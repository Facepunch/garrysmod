
AddCSLuaFile()

SWEP.Author			= "robotboy655 & MaxOfS2D"
SWEP.Purpose    	= "Heal people with your primary attack, or yourself with the secondary."

SWEP.Spawnable			= true
SWEP.UseHands			= true

SWEP.ViewModel			= "models/weapons/c_medkit.mdl"
SWEP.WorldModel			= "models/weapons/w_medkit.mdl"

SWEP.ViewModelFOV		= 54

SWEP.Primary.ClipSize		= 100
SWEP.Primary.DefaultClip	= 100
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.PrintName			= "Medkit"
SWEP.Slot				= 5
SWEP.SlotPos			= 3

SWEP.HealAmount = 20

local HealSound = Sound( "items/smallmedkit1.wav" )
local DenySound = Sound( "items/medshotno1.wav" )

function SWEP:Initialize()

	self:SetWeaponHoldType( "slam" )

	timer.Create( "medkit_ammo" .. self:EntIndex(), 0.5, 0, function()
		if ( self:Clip1() < 100 ) then self:TakePrimaryAmmo( -1 ) end
	end )

end

function SWEP:PrimaryAttack()

	if ( !SERVER ) then return end

	local tr = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 64,
		filter = self.Owner
	} )

	local ent = tr.Entity

	if ( IsValid( ent ) && self:Clip1() >= self.HealAmount && ( ent:IsPlayer() || ent:IsNPC() ) && ent:Health() < ent:GetMaxHealth() ) then

		self:TakePrimaryAmmo( self.HealAmount )

		ent:SetHealth( math.min( ent:GetMaxHealth(), ent:Health() + self.HealAmount ) )
		ent:EmitSound( HealSound )

		self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )

		self:SetNextPrimaryFire( CurTime() + self:SequenceDuration() + 0.5 )
		self.Owner:SetAnimation( PLAYER_ATTACK1 )

	else

		self.Owner:EmitSound( DenySound )
		self:SetNextPrimaryFire( CurTime() + 1 )

	end

end

function SWEP:SecondaryAttack()

	if ( !SERVER ) then return end

	local ent = self.Owner

	if ( IsValid( ent ) && self:Clip1() >= self.HealAmount && ent:Health() < ent:GetMaxHealth() ) then

		self:TakePrimaryAmmo( self.HealAmount )

		ent:SetHealth( math.min( ent:GetMaxHealth(), ent:Health() + self.HealAmount ) )
		ent:EmitSound( HealSound )

		self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )

		self:SetNextPrimaryFire( CurTime() + self:SequenceDuration() + 1 )
		self.Owner:SetAnimation( PLAYER_ATTACK1 )

	else

		ent:EmitSound( DenySound )
		self:SetNextPrimaryFire( CurTime() + 1 )

	end

end

function SWEP:OnRemove()

	timer.Stop( "medkit_ammo" .. self:EntIndex() )

end

function SWEP:CustomAmmoDisplay()

	self.AmmoDisplay = self.AmmoDisplay or {} 
	self.AmmoDisplay.Draw = true
	self.AmmoDisplay.PrimaryClip = self:Clip1()

	return self.AmmoDisplay

end
