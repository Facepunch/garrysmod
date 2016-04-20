
AddCSLuaFile()

SWEP.PrintName = "Medkit"
SWEP.Author = "robotboy655 & MaxOfS2D"
SWEP.Purpose = "Heal people with your primary attack, or yourself with the secondary."
SWEP.Slot = 5
SWEP.SlotPos = 3

SWEP.Spawnable = true

SWEP.ViewModel = Model( "models/weapons/c_medkit.mdl" )
SWEP.WorldModel	= Model( "models/weapons/w_medkit.mdl" )
SWEP.ViewModelFOV = 54
SWEP.UseHands = true
SWEP.HoldType = "slam"

SWEP.Primary = 
{
	ClipSize = 100,
	DefaultClip	= 100,
	Automatic = false,
	Ammo = "none",
	Delay = 0.5
}

SWEP.Secondary = 
{
	ClipSize = -1,
	DefaultClip = -1,
	Automatic = false,
	Ammo = "none"
}

local HealAmount	= 20	-- Maximum heal amount per use
local HealSound 	= Sound( "HealthKit.Touch" )
local DenySound 	= Sound( "WallHealth.Deny" )

function SWEP:Initialize()

	self:SetHoldType( self.HoldType )

	if ( CLIENT ) then return end

	timer.Create( "medkit_ammo" .. self:EntIndex(), 1, 0, function()
		if ( self:Clip1() < self.Primary.ClipSize ) then self:SetClip1( math.min( self:Clip1() + 2, self.Primary.ClipSize ) ) end
	end )

end

function SWEP:PrimaryAttack( HealSelf )

	if ( CLIENT ) then return end

	if ( HealSelf ) then

		local tr = util.TraceLine( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 64,
			filter = self.Owner
		} )

		local ent = tr.Entity

	else

		local ent = self.Owner

	end
	
	local need = HealAmount
	if ( IsValid( ent ) ) then need = math.min( ent:GetMaxHealth() - ent:Health(), need ) end

	if ( IsValid( ent ) && self:Clip1() >= need && ( HealSelf || ( ent:IsPlayer() || ent:IsNPC() ) ) && ent:Health() < ent:GetMaxHealth() ) then

		self:TakePrimaryAmmo( need )

		ent:SetHealth( math.min( ent:GetMaxHealth(), ent:Health() + need ) )
		ent:EmitSound( HealSound )

		self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		
		if ( HealSelf ) then
			self:SetNextSecondaryFire( CurTime() + self:SequenceDuration() + self.Primary.Delay )
		else
			self:SetNextPrimaryFire( CurTime() + self:SequenceDuration() + self.Primary.Delay )
		end
		
		self.Owner:SetAnimation( PLAYER_ATTACK1 )

		-- Even though the viewmodel has looping IDLE anim at all times, we need this to make fire animation work in multiplayer
		timer.Create( "weapon_idle" .. self:EntIndex(), self:SequenceDuration(), 1, function() if ( IsValid( self ) ) then self:SendWeaponAnim( ACT_VM_IDLE ) end end )

	else

		self.Owner:EmitSound( DenySound )

		if ( HealSelf ) then
			self:SetNextSecondaryFire( CurTime() + 1 )
		else
			self:SetNextPrimaryFire( CurTime() + 1 )
		end

	end

end

function SWEP:SecondaryAttack() 

	self:PrimaryAttack( true )

end

function SWEP:OnRemove()

	timer.Stop( "medkit_ammo" .. self:EntIndex() )
	timer.Stop( "weapon_idle" .. self:EntIndex() )

end

function SWEP:Holster()

	timer.Stop( "weapon_idle" .. self:EntIndex() )
	
	return true

end

function SWEP:CustomAmmoDisplay()

	self.AmmoDisplay = self.AmmoDisplay or {} 
	self.AmmoDisplay.Draw = true
	self.AmmoDisplay.PrimaryClip = self:Clip1()

	return self.AmmoDisplay

end
