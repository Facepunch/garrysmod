
AddCSLuaFile()

SWEP.PrintName = "#GMOD_Fists"
SWEP.Author = "Kilburn, robotboy655, MaxOfS2D, Tenrys, code_gs"
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

SWEP.HoldType = "fist"

SWEP.SwingSound = Sound( "WeaponFrag.Throw" )	-- Sound of the fists swinging
SWEP.HitSound = Sound( "Flesh.ImpactHard" )		-- Sound of the fists hitting an entity

SWEP.PunchCooldown = 0.9	-- Cooldown between punches
SWEP.PunchDelay = 0.2		-- Delay between the punch being thrown and hitting an object
SWEP.PunchDistance = 48		-- Distance of the punch
SWEP.PunchForceScale = 80	-- Scalar force of the punch
SWEP.ComboCount = 2			-- Number of successive punches needed for a combo punch
SWEP.ComboResetTime = 0.1	-- Time between the next punch being available and the combo couner resetting

-- Bounds of the punch's hull trace
SWEP.PunchSize = {
	Min = Vector( -10, -10, -8 ),
	Max = Vector( 10, 10, 8 )
}

-- Bounds of the punch's random damage
SWEP.PunchDamage = {
	Min = 8,
	Max = 12
}

-- Bounds of the combo punch's random damage
SWEP.ComboDamage = {
	Min = 12,
	Max = 24
}

-- Directional scalars for the punch's force
-- Punches thrown with the right hand will have the Right scalar negated (-Right)
SWEP.PunchForce = {
	Forward = 9998,
	Right = 4192,
	Up = 0
}

-- Directional scalars of the combo punch's force
-- Punches thrown with the right hand will have the Right scalar negated (-Right)
SWEP.ComboForce = {
	Forward = 10012,
	Right = 0,
	Up = 5158
}

function SWEP:Initialize()

	self:SetHoldType( self.HoldType )

end

function SWEP:Deploy()

	self:SetCombo( 0 )
	self:SetPunchHitTime( 0 )

	return true

end

function SWEP:SetupDataTables()

	self:NetworkVar( "Bool", 0, "RightPunch" )
	self:NetworkVar( "Int", 0, "Combo" )
	self:NetworkVar( "Float", 0, "PunchHitTime" )
	self:NetworkVar( "Float", 1, "NextIdle" )

end

-- FIXME: Catch deploy anim?
function SWEP:Idle()

	-- Update idle anim
	local curtime = CurTime()
	if ( curtime < self:GetNextIdle() ) then return false end

	self:SendWeaponAnim( ACT_VM_IDLE )
	self:SetNextIdle( curtime + self:SequenceDuration() )

	return true

end

function SWEP:PrimaryAttack()

	self:StartPunch( false )

end

function SWEP:SecondaryAttack()

	self:StartPunch( true )

end

function SWEP:PlayAnim( act )

	local owner = self:GetOwner()
	if ( !owner:IsValid() ) then return false end

	local pViewModel = owner:GetViewModel()
	if ( !pViewModel:IsValid() ) then return false end
	if ( pViewModel:SelectWeightedSequence( act ) == -1 ) then return false end

	self:SendWeaponAnim( act )
	self:SetNextIdle( CurTime() + self:SequenceDuration() )

	return true
end

function SWEP:GetPunchActivity( right )

	if ( self:GetCombo() >= self.ComboCount ) then
		return right && ACT_VM_HITRIGHT2 || ACT_VM_HITLEFT2
	end

	return right && ACT_VM_HITRIGHT || ACT_VM_HITLEFT

end

function SWEP:StartPunch( right )

	local owner = self:GetOwner()
	if ( !owner:IsValid() ) then return end

	self:SetRightPunch( right )

	self:EmitSound( self.SwingSound )
	self:PlayAnim( self:GetPunchActivity( right ) )
	owner:SetAnimation( PLAYER_ATTACK1 )

	local curtime = CurTime()
	local cooldown = curtime + self.PunchCooldown
	self:SetNextPrimaryFire( cooldown )
	self:SetNextSecondaryFire( cooldown )

	local delay = self.PunchDelay

	if ( delay != 0 ) then
		self:SetPunchHitTime( curtime + delay )
	else
		self:PunchHit()
	end
end

function SWEP:CanHit( ent )

	return ent:IsValid()

end

function SWEP:CanDamage( ent )

	return ent:IsPlayer() || ent:IsNPC() || ( ent:IsValid() && ent:Health() > 0 )

end

local phys_pushscale = GetConVar( "phys_pushscale" )

function SWEP:PunchTrace()

	local owner = self:GetOwner()
	if ( !owner:IsValid() ) then return end

	local isplayer = owner:IsPlayer()

	if ( isplayer ) then
		owner:LagCompensation( true )
	end

	local startpos = owner:GetShootPos()
	local trdata = {
		start = startpos,
		endpos = startpos + owner:GetAimVector() * self.PunchDistance,
		filter = owner,
		mask = MASK_SHOT_HULL
	}
	local tr = util.TraceLine( trdata )

	if ( !tr.Entity:IsValid() ) then
		local size = self.PunchSize
		trdata.mins = size.Min
		trdata.maxs = size.Max
		trdata.output = tr

		util.TraceHull( trdata )
	end

	if ( isplayer ) then
		owner:LagCompensation( false )
	end

	return tr

end

function SWEP:PunchHit()

	local owner = self:GetOwner()
	if ( !owner:IsValid() ) then return end

	local tr = self:PunchTrace()
	local hitent = tr.Entity

	if ( !self:CanHit( hitent ) ) then
		self:SetCombo( 0 )
		return
	end

	self:EmitSound( self.HitSound )

	local phys = hitent:GetPhysicsObject()
	local physscale = phys_pushscale:GetFloat()
	local hitpos = tr.HitPos

	if ( phys:IsValid() ) then
		-- FIXME: This cannot be right
		phys:ApplyForceOffset( owner:GetAimVector() * ( phys:GetMass() * physscale * self.PunchForceScale ), hitpos )
	end

	if ( !self:CanDamage( hitent ) ) then
		self:SetCombo( 0 )
		return
	end

	local dmginfo = DamageInfo()
	dmginfo:SetAttacker( owner )
	dmginfo:SetInflictor( self )
	dmginfo:SetDamagePosition( hitpos )
	dmginfo:SetDamageType( DMG_CLUB )
	dmginfo:SetReportedPosition( tr.StartPos )

	local dmg, force
	local combo = self:GetCombo()

	if ( combo >= self.ComboCount ) then
		dmg = self.ComboDamage
		force = self.ComboForce
		self:SetCombo( 0 )
	else
		dmg = self.PunchDamage
		force = self.PunchForce
		self:SetCombo( combo + 1 )
	end

	dmginfo:SetDamage( util.SharedRandom( "GMOD_" .. self:GetClass() .. self:EntIndex(), dmg.Min, dmg.Max ) )
	dmginfo:SetDamageForce(
		owner:GetForward() * force.Forward * physscale +
		owner:GetRight() * force.Right * physscale * ( self:GetRightPunch() && -1 || 1 ) +
		owner:GetUp() * force.Up * physscale )

	-- FIXME: Is this still necessary?
	SuppressHostEvents( NULL ) -- Let the breakable gibs spawn in multiplayer on client
	hitent:DispatchTraceAttack( dmginfo, tr )
	SuppressHostEvents( owner )
end

function SWEP:OnDrop()

	self:Remove() -- You can't drop fists

end

function SWEP:Holster()

	self:SetCombo( 0 )
	self:SetPunchHitTime( 0 )

	return true

end

-- Punching should only be done on the server in single-player
if ( CLIENT && game.SinglePlayer() ) then return end

function SWEP:Think()

	local curtime = CurTime()
	local punchhit = self:GetPunchHitTime()

	if ( punchhit > 0 && punchhit <= curtime ) then
		self:PunchHit()
		self:SetPunchHitTime( 0 )
	end

	if ( math.min( self:GetNextPrimaryFire(), self:GetNextSecondaryFire() ) + self.ComboResetTime <= curtime ) then
		self:SetCombo( 0 )
	end

end
