
-- Variables that are used on both client and server

SWEP.Instructions	= "Shoot a prop to attach a Manhack.\nRight click to attach a rollermine."

SWEP.Spawnable			= true
SWEP.AdminOnly			= true
SWEP.UseHands			= true

SWEP.ViewModel			= "models/weapons/c_pistol.mdl"
SWEP.WorldModel			= "models/weapons/w_pistol.mdl"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.PrintName			= "#GMOD_ManhackGun"
SWEP.Slot				= 3
SWEP.SlotPos			= 1
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true
SWEP.UseHands			= true

local ShootSound = Sound( "Metal.SawbladeStick" )

--[[---------------------------------------------------------
	Reload does nothing
-----------------------------------------------------------]]
function SWEP:Reload()
end

--[[---------------------------------------------------------
	Think does nothing
-----------------------------------------------------------]]
function SWEP:Think()
end

--[[---------------------------------------------------------
	PrimaryAttack
-----------------------------------------------------------]]
function SWEP:PrimaryAttack()

	local tr = util.TraceLine( util.GetPlayerTrace( self.Owner ) )
	--if ( tr.HitWorld ) then return end

	if ( IsFirstTimePredicted() ) then
		local effectdata = EffectData()
		effectdata:SetOrigin( tr.HitPos )
		effectdata:SetNormal( tr.HitNormal )
		effectdata:SetMagnitude( 8 )
		effectdata:SetScale( 1 )
		effectdata:SetRadius( 16 )
		util.Effect( "Sparks", effectdata )
	end

	self:EmitSound( ShootSound )

	self:ShootEffects( self )

	-- The rest is only done on the server
	if ( CLIENT ) then return end

	-- Make a manhack
	local ent = ents.Create( "npc_manhack" )
	ent:SetPos( tr.HitPos + self.Owner:GetAimVector() * -16 )
	ent:SetAngles( tr.HitNormal:Angle() )
	ent:Spawn()

	local weld = nil

	if ( tr.HitWorld ) then

		-- freeze it in place
		ent:GetPhysicsObject():EnableMotion( false )

	else

		-- Weld it to the object that we hit
		weld = constraint.Weld( tr.Entity, ent, tr.PhysicsBone, 0, 0 )

	end

	if ( self.Owner:IsPlayer() ) then
		undo.Create( "Manhack" )
			undo.AddEntity( weld )
			undo.AddEntity( nocl )
			undo.AddEntity( ent )
			undo.SetPlayer( self.Owner )
		undo.Finish()
	end

end

--[[---------------------------------------------------------
	SecondaryAttack
-----------------------------------------------------------]]
function SWEP:SecondaryAttack()

	local tr = util.TraceLine( util.GetPlayerTrace( self.Owner ) )
	--if ( tr.HitWorld ) then return end

	self:EmitSound( ShootSound )
	self:ShootEffects( self )

	if ( IsFirstTimePredicted() ) then
		local effectdata = EffectData()
		effectdata:SetOrigin( tr.HitPos )
		effectdata:SetNormal( tr.HitNormal )
		effectdata:SetMagnitude( 8 )
		effectdata:SetScale( 1 )
		effectdata:SetRadius( 16 )
		util.Effect( "Sparks", effectdata )
	end


	-- The rest is only done on the server
	if ( CLIENT ) then return end

	-- Make a manhack
	local ent = ents.Create( "npc_rollermine" )
	ent:SetPos( tr.HitPos + self.Owner:GetAimVector() * -16 )
	ent:SetAngles( tr.HitNormal:Angle() )
	ent:Spawn()

	local weld = nil

	if ( !tr.HitWorld ) then

		-- Weld it to the object that we hit
		weld = constraint.Weld( tr.Entity, ent, tr.PhysicsBone, 0, 0 )

	end

	if ( self.Owner:IsPlayer() ) then
		undo.Create( "Rollermine" )
			undo.AddEntity( weld )
			undo.AddEntity( nocl )
			undo.AddEntity( ent )
			undo.SetPlayer( self.Owner )
		undo.Finish()
	end

end


--[[---------------------------------------------------------
	Name: ShouldDropOnDie
	Desc: Should this weapon be dropped when its owner dies?
-----------------------------------------------------------]]
function SWEP:ShouldDropOnDie()
	return false
end
