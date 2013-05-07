
AddCSLuaFile()

SWEP.Author			= "robotboy655"
SWEP.Purpose		= "Well we sure as heck didn't use guns! We would wrestle Hunters to the ground with our bare hands! I would get ten, twenty a day, just using my fists."

SWEP.Spawnable			= true
SWEP.UseHands			= true

SWEP.ViewModel			= "models/weapons/c_arms_citizen.mdl"
SWEP.WorldModel			= ""

SWEP.ViewModelFOV		= 52

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Damage			= 10
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.PrintName			= "Fists"
SWEP.Slot				= 0
SWEP.SlotPos			= 5
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true

local SwingSound = Sound( "weapons/slam/throw.wav" )
local HitSound = Sound( "Flesh.ImpactHard" )

function SWEP:Initialize()

	self:SetWeaponHoldType( "fist" )

end

function SWEP:PreDrawViewModel( vm, wep, ply )

	vm:SetMaterial( "engine/occlusionproxy" ) -- Hide that view model with hacky material

end

SWEP.Distance = 67
SWEP.AttackAnims = { "fists_left", "fists_right", "fists_uppercut" }
function SWEP:PrimaryAttack()
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	if ( !SERVER ) then return end

	-- We need this because attack sequences won't work otherwise in multiplayer
	local vm = self.Owner:GetViewModel()
	vm:ResetSequence( vm:LookupSequence( "fists_idle_01" ) )

	local anim = self.AttackAnims[ math.random( 1, #self.AttackAnims ) ]

	timer.Simple( 0, function()
		if ( !IsValid( self ) || !IsValid( self.Owner ) || !self.Owner:GetActiveWeapon() || self.Owner:GetActiveWeapon() != self ) then return end
	
		local vm = self.Owner:GetViewModel()
		vm:ResetSequence( vm:LookupSequence( anim ) )

		self:Idle()
	end )

	timer.Simple( 0.05, function()
		if ( !IsValid( self ) || !IsValid( self.Owner ) || !self.Owner:GetActiveWeapon() || self.Owner:GetActiveWeapon() != self ) then return end
		if ( anim == "fists_left" ) then
			self.Owner:ViewPunch( Angle( 0, 16, 0 ) )
		elseif ( anim == "fists_right" ) then
			self.Owner:ViewPunch( Angle( 0, -16, 0 ) )
		elseif ( anim == "fists_uppercut" ) then
			self.Owner:ViewPunch( Angle( 16, -8, 0 ) )
		end
	end )

	timer.Simple( 0.2, function()
		if ( !IsValid( self ) || !IsValid( self.Owner ) || !self.Owner:GetActiveWeapon() || self.Owner:GetActiveWeapon() != self ) then return end
		if ( anim == "fists_left" ) then
			self.Owner:ViewPunch( Angle( 4, -16, 0 ) )
		elseif ( anim == "fists_right" ) then
			self.Owner:ViewPunch( Angle( 4, 16, 0 ) )
		elseif ( anim == "fists_uppercut" ) then
			self.Owner:ViewPunch( Angle( -32, 0, 0 ) )
		end
		self.Owner:EmitSound( SwingSound )
		
	end )

	timer.Simple( 0.2, function()
		if ( !IsValid( self ) || !IsValid( self.Owner ) || !self.Owner:GetActiveWeapon() || self.Owner:GetActiveWeapon() != self ) then return end
		self:DealDamage( anim )
	end )

	self:SetNextPrimaryFire( CurTime() + 0.9 )

end

function SWEP:DealDamage( anim )
	local tr = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.Distance,
		filter = self.Owner
	} )

	if ( !IsValid( tr.Entity ) ) then 
		tr = util.TraceHull( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.Distance,
			filter = self.Owner,
			mins = self.Owner:OBBMins() / 3,
			maxs = self.Owner:OBBMaxs() / 3
		} )
	end

	if ( tr.Hit ) then self.Owner:EmitSound( HitSound ) end

	if ( IsValid( tr.Entity ) && ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() ) ) then
		local dmginfo = DamageInfo()
		dmginfo:SetDamage( self.Primary.Damage )
		if ( anim == "fists_left" ) then
			dmginfo:SetDamageForce( self.Owner:GetRight() * 49125 + self.Owner:GetForward() * 99984 ) -- Yes we need those specific numbers
		elseif ( anim == "fists_right" ) then
			dmginfo:SetDamageForce( self.Owner:GetRight() * -49124 + self.Owner:GetForward() * 99899 )
		elseif ( anim == "fists_uppercut" ) then
			dmginfo:SetDamageForce( self.Owner:GetUp() * 51589 + self.Owner:GetForward() * 100128 )
		end
		dmginfo:SetInflictor( self )
		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self end
		dmginfo:SetAttacker( attacker )

		tr.Entity:TakeDamageInfo( dmginfo )
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:Idle()

	local vm = self.Owner:GetViewModel()
	timer.Create( "fists_idle" .. self:EntIndex(), vm:SequenceDuration(), 1, function()
		vm:ResetSequence( vm:LookupSequence( "fists_idle_0" .. math.random( 1, 2 ) ) )
	end )

end

function SWEP:OnRemove()

	if ( IsValid( self.Owner ) ) then
		local vm = self.Owner:GetViewModel()
		vm:SetMaterial( "" )
	end

	timer.Stop( "fists_idle" .. self:EntIndex() )

end

function SWEP:Holster( wep )

	if ( IsValid( self.Owner ) ) then
		local vm = self.Owner:GetViewModel()
		vm:SetMaterial( "" )
	end

	timer.Stop( "fists_idle" .. self:EntIndex() )

	return true
end

function SWEP:Deploy()
	local vm = self.Owner:GetViewModel()
	vm:ResetSequence( vm:LookupSequence( "fists_draw" ) )

	self:Idle()

	return true
end
