
AddCSLuaFile()

SWEP.PrintName = "#weapon_fists"
SWEP.Author = "Kilburn, robotboy655, MaxOfS2D & Tenrys"
SWEP.Purpose = "Well we sure as hell didn't use guns! We would just wrestle Hunters to the ground with our bare hands! I used to kill ten, twenty a day, just using my fists."

SWEP.Slot = 0
SWEP.SlotPos = 4

SWEP.Spawnable = true

SWEP.ViewModel = Model( "models/weapons/c_arms.mdl" )
SWEP.WorldModel = ""
SWEP.ViewModelFOV = 54
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = ""

SWEP.DrawAmmo = false

SWEP.SwingSound = Sound( "WeaponFrag.Throw" ) -- Sound of the fists swinging
SWEP.HitSound = Sound( "Flesh.ImpactHard" ) -- Sound of the fists hitting an entity

SWEP.HitDistance = 48		-- Distance of the punch
SWEP.HitDelay = 0.2			-- Delay between the punch being thrown and hitting an object
SWEP.HitForceScale = 80		-- Scalar force of the punch
SWEP.SwingCooldown = 0.9	-- Cooldown between punches
SWEP.ComboCount = 2			-- Number of successive punches needed for a combo punch
SWEP.ComboResetTime = 0.1	-- Time between the next punch being available and the combo couner resetting

-- Bounds of the punch's hull trace
SWEP.HitSize = {
	Min = Vector( -10, -10, -8 ),
	Max = Vector( 10, 10, 8 )
}
SWEP.HitDamage = { 8, 12 } -- Normal punch damage
SWEP.ComboDamage = { 12, 24 } -- Combo punch damage

function SWEP:Initialize()

	self:SetHoldType( "fist" )

end

function SWEP:SetupDataTables()

	self:NetworkVar( "Float", 0, "NextMeleeAttack" )
	self:NetworkVar( "Float", 1, "NextIdle" )
	self:NetworkVar( "Int", 2, "Combo" )

end

function SWEP:UpdateNextIdle()

	local vm = self:GetOwner():GetViewModel()
	self:SetNextIdle( CurTime() + vm:SequenceDuration() / vm:GetPlaybackRate() )

end

function SWEP:PrimaryAttack( right )

	local owner = self:GetOwner()

	owner:SetAnimation( PLAYER_ATTACK1 )

	local anim = "fists_left"
	if ( right ) then anim = "fists_right" end
	if ( self:GetCombo() >= self.ComboCount ) then
		anim = "fists_uppercut"
	end

	local vm = owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( anim ) )

	self:EmitSound( self.SwingSound )

	self:UpdateNextIdle()
	self:SetNextMeleeAttack( CurTime() + self.HitDelay )

	self:SetNextPrimaryFire( CurTime() + self.SwingCooldown )
	self:SetNextSecondaryFire( CurTime() + self.SwingCooldown )

end

function SWEP:SecondaryAttack()

	self:PrimaryAttack( true )

end

local phys_pushscale = GetConVar( "phys_pushscale" )

function SWEP:DealDamage()

	local owner = self:GetOwner()

	local anim = self:GetSequenceName(owner:GetViewModel():GetSequence())

	owner:LagCompensation( true )

	local tr = util.TraceLine( {
		start = owner:GetShootPos(),
		endpos = owner:GetShootPos() + owner:GetAimVector() * self.HitDistance,
		filter = owner,
		mask = MASK_SHOT_HULL
	} )

	if ( !IsValid( tr.Entity ) ) then
		tr = util.TraceHull( {
			start = owner:GetShootPos(),
			endpos = owner:GetShootPos() + owner:GetAimVector() * self.HitDistance,
			filter = owner,
			mins = self.HitSize.Min,
			maxs = self.HitSize.Max,
			mask = MASK_SHOT_HULL
		} )
	end

	-- We need the second part for single player because SWEP:Think is ran shared in SP
	if ( tr.Hit and !( game.SinglePlayer() and CLIENT ) ) then
		self:EmitSound( self.HitSound )
	end

	local hit = false
	local scale = phys_pushscale:GetFloat()

	if ( SERVER and IsValid( tr.Entity ) and ( tr.Entity:IsNPC() or tr.Entity:IsPlayer() or tr.Entity:Health() > 0 ) ) then
		local dmginfo = DamageInfo()

		local attacker = owner
		if ( !IsValid( attacker ) ) then attacker = self end
		dmginfo:SetAttacker( attacker )

		dmginfo:SetInflictor( self )

		local dmg = self.HitDamage

		if ( anim == "fists_left" ) then
			dmginfo:SetDamageForce( owner:GetRight() * 4912 * scale + owner:GetForward() * 9998 * scale ) -- Yes we need those specific numbers
		elseif ( anim == "fists_right" ) then
			dmginfo:SetDamageForce( owner:GetRight() * -4912 * scale + owner:GetForward() * 9989 * scale )
		elseif ( anim == "fists_uppercut" ) then
			dmginfo:SetDamageForce( owner:GetUp() * 5158 * scale + owner:GetForward() * 10012 * scale )
			dmg = self.ComboDamage
		end

		dmginfo:SetDamage( istable( dmg ) and math.random( dmg[ 1 ], dmg[ 2 ] ) or dmg )

		SuppressHostEvents( NULL ) -- Let the breakable gibs spawn in multiplayer on client
		tr.Entity:TakeDamageInfo( dmginfo )
		SuppressHostEvents( owner )

		hit = true

	end

	if ( IsValid( tr.Entity ) ) then
		local phys = tr.Entity:GetPhysicsObject()
		if ( IsValid( phys ) ) then
			phys:ApplyForceOffset( owner:GetAimVector() * self.HitForceScale * phys:GetMass() * scale, tr.HitPos )
		end
	end

	if ( SERVER ) then
		if ( hit and anim != "fists_uppercut" ) then
			self:SetCombo( self:GetCombo() + 1 )
		else
			self:SetCombo( 0 )
		end
	end

	owner:LagCompensation( false )

end

function SWEP:OnDrop()

	self:Remove() -- You can't drop fists

end

local sv_deployspeed = GetConVar( "sv_defaultdeployspeed" )

function SWEP:Deploy()

	local speed = sv_deployspeed:GetFloat()

	local vm = self:GetOwner():GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "fists_draw" ) )
	vm:SetPlaybackRate( speed )

	self:SetNextPrimaryFire( CurTime() + vm:SequenceDuration() / speed )
	self:SetNextSecondaryFire( CurTime() + vm:SequenceDuration() / speed )
	self:UpdateNextIdle()

	if ( SERVER ) then
		self:SetCombo( 0 )
	end

	return true

end

function SWEP:Holster()

	self:SetNextMeleeAttack( 0 )

	return true

end

function SWEP:Think()

	local vm = self:GetOwner():GetViewModel()
	local curtime = CurTime()
	local idletime = self:GetNextIdle()

	if ( idletime > 0 and curtime > idletime ) then

		vm:SendViewModelMatchingSequence( vm:LookupSequence( "fists_idle_0" .. math.random( 1, 2 ) ) )

		self:UpdateNextIdle()

	end

	local meleetime = self:GetNextMeleeAttack()

	if ( meleetime > 0 and curtime > meleetime ) then

		self:DealDamage()

		self:SetNextMeleeAttack( 0 )

	end

	if ( SERVER and curtime > self:GetNextPrimaryFire() + self.ComboResetTime ) then

		self:SetCombo( 0 )

	end

end
