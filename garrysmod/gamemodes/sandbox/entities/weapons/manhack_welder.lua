
AddCSLuaFile()

if ( CLIENT ) then

	SWEP.PrintName			= "Manhack Gun"
	SWEP.Instructions		= "Shoot a prop to attach a Manhack.\nRight click to attach a rollermine."
	SWEP.Slot				= 3
	SWEP.SlotPos			= 1
	SWEP.DrawAmmo			= false
	SWEP.DrawCrosshair		= true

else

	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false

end

SWEP.Spawnable	= true
SWEP.AdminOnly	= true

SWEP.ViewModel	= Model( "models/weapons/c_pistol.mdl" )
SWEP.WorldModel	= Model( "models/weapons/w_pistol.mdl" )
SWEP.UseHands	= true

SWEP.Primary = 
{
	ClipSize	= -1,
	DefaultClip	= -1,
	Automatic	= false,
	Ammo		= "none"
}

SWEP.Secondary = 
{
	ClipSize	= -1,
	DefaultClip	= -1,
	Automatic	= false,
	Ammo		= "none"
}

local ShootSound = Sound( "Metal.SawbladeStick" )

--[[---------------------------------------------------------
	Reload does nothing
-----------------------------------------------------------]]
function SWEP:Reload() 
end

--[[---------------------------------------------------------
	PrimaryAttack
-----------------------------------------------------------]]
function SWEP:PrimaryAttack( rollermine )

	local tr = self.Owner:GetEyeTrace()
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
	
	-- Make a manhack/rollermine
	local ent = ents.Create( rollermine && "npc_rollermine" || "npc_manhack" )
	ent:SetPos( tr.HitPos + self.Owner:GetAimVector() * -16 )
	ent:SetAngles( tr.HitNormal:Angle() )
	ent:Spawn()

	local weld = nil

	if ( rollermine && tr.HitWorld ) then

		-- freeze it in place
		ent:GetPhysicsObject():EnableMotion( false )

	else

		-- Weld it to the object that we hit
		local weld = constraint.Weld( tr.Entity, ent, tr.PhysicsBone, 0, 0 )

	end
	
	undo.Create( rollermine && "Rollermine" || "Manhack" )
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

	self:PrimaryAttack( true )
	
end

--[[---------------------------------------------------------
   Name: ShouldDropOnDie
   Desc: Should this weapon be dropped when its owner dies?
-----------------------------------------------------------]]
function SWEP:ShouldDropOnDie()

	return false

end
