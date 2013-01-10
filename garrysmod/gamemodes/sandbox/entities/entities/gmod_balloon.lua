
AddCSLuaFile()
DEFINE_BASECLASS( "base_gmodentity" )

ENT.PrintName		= ""
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

--[[---------------------------------------------------------
   Name: Initialize
-----------------------------------------------------------]]
function ENT:Initialize()

	if ( CLIENT ) then return end
	
	self:PhysicsInit( SOLID_VPHYSICS )
	
	-- Set up our physics object here
	local phys = self:GetPhysicsObject()
	if ( IsValid( phys ) ) then
	
		phys:SetMass( 100 )
		phys:Wake()
		phys:EnableGravity( false )
		
	end
	
	self:SetForce( 1 )
	self:StartMotionController()
	
end

--[[---------------------------------------------------------
   Name: SetForce
-----------------------------------------------------------]]
function ENT:SetForce( force )

	self.Force = force * 5000
	self:SetOverlayText( "Force: " .. math.floor( force ) )

end


--[[---------------------------------------------------------
   Name: OnTakeDamage
-----------------------------------------------------------]]
function ENT:OnTakeDamage( dmginfo )

	if ( self.Indestructible ) then return end
	
	local c = self:GetColor()
	
	local effectdata = EffectData()
		effectdata:SetOrigin( self:GetPos() )
		effectdata:SetStart( Vector( c.r, c.g, c.b ) )
	util.Effect( "balloon_pop", effectdata )
	
	if ( self.Explosive ) then
	
		local effectdata = EffectData()
			effectdata:SetOrigin( self:GetPos() )
			effectdata:SetScale( 1 )
			effectdata:SetMagnitude( 25 )
		util.Effect( "Explosion", effectdata, true, true )
	
	end
	
	local attacker = dmginfo:GetAttacker()
	if ( IsValid(attacker) && attacker:IsPlayer() ) then
		attacker:SendLua( "achievements.BalloonPopped()" );
	end
	
	self:Remove()
	
end


--[[---------------------------------------------------------
   Name: Simulate
-----------------------------------------------------------]]
function ENT:PhysicsSimulate( phys, deltatime )

	local vLinear = Vector( 0, 0, self.Force ) * deltatime
	local vAngular = Vector( 0, 0, 0 )

	return vAngular, vLinear, SIM_GLOBAL_FORCE
	
end