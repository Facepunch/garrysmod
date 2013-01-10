
-- Variables that are used on both client and server

SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= "Shoot a prop to attach a Manhack.\nRight click to attach a rollermine."

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_pistol.mdl"
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

SWEP.PrintName			= "Manhack Gun"			
SWEP.Slot				= 3
SWEP.SlotPos			= 1
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true




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

	local tr = self.Owner:GetEyeTrace()
	--if ( tr.HitWorld ) then return end
	
	local effectdata = EffectData()
		effectdata:SetOrigin( tr.HitPos )
		effectdata:SetNormal( tr.HitNormal )
		effectdata:SetMagnitude( 8 )
		effectdata:SetScale( 1 )
		effectdata:SetRadius( 16 )
	util.Effect( "Sparks", effectdata )
	
	self:EmitSound( ShootSound )

	self:ShootEffects( self )
	
	-- The rest is only done on the server
	if ( !SERVER ) then return end
	
	-- Make a manhack
	local ent = ents.Create( "npc_manhack" )
		ent:SetPos( tr.HitPos + self.Owner:GetAimVector() * -16 )
		ent:SetAngles( tr.HitNormal:Angle() )
	ent:Spawn()

	local weld = nil;

	if ( tr.HitWorld ) then

		-- freeze it in place
		ent:GetPhysicsObject():EnableMotion( false )

	else

		-- Weld it to the object that we hit
		local weld = constraint.Weld( tr.Entity, ent, tr.PhysicsBone, 0, 0 )

	end
	
	undo.Create("Manhack")
		undo.AddEntity( weld )
		undo.AddEntity( nocl )
		undo.AddEntity( ent )
		undo.SetPlayer( self.Owner )
	undo.Finish()
	
end

--[[---------------------------------------------------------
	SecondaryAttack
-----------------------------------------------------------]]
function SWEP:SecondaryAttack()

	local tr = self.Owner:GetEyeTrace()
	--if ( tr.HitWorld ) then return end
	
	self:EmitSound( ShootSound )
	self:ShootEffects( self )
	
	local effectdata = EffectData()
		effectdata:SetOrigin( tr.HitPos )
		effectdata:SetNormal( tr.HitNormal )
		effectdata:SetMagnitude( 8 )
		effectdata:SetScale( 1 )
		effectdata:SetRadius( 16 )
	util.Effect( "Sparks", effectdata )
	
	
	-- The rest is only done on the server
	if (!SERVER) then return end
	
	-- Make a manhack
	local ent = ents.Create( "npc_rollermine" )
		ent:SetPos( tr.HitPos + self.Owner:GetAimVector() * -16 )
		ent:SetAngles( tr.HitNormal:Angle() )
	ent:Spawn()

	local weld = nil;

	if ( tr.HitWorld ) then

		-- Don't do anything 

	else

		-- Weld it to the object that we hit
		local weld = constraint.Weld( tr.Entity, ent, tr.PhysicsBone, 0, 0 )

	end
	
	undo.Create("Rollermine")
		undo.AddEntity( weld )
		undo.AddEntity( nocl )
		undo.AddEntity( ent )
		undo.SetPlayer( self.Owner )
	undo.Finish()
	
end


--[[---------------------------------------------------------
   Name: ShouldDropOnDie
   Desc: Should this weapon be dropped when its owner dies?
-----------------------------------------------------------]]
function SWEP:ShouldDropOnDie()
	return false
end
