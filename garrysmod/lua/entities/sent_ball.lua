
AddCSLuaFile()

local BounceSound = Sound( "garrysmod/balloon_pop_cute.wav" )

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName		= "Bouncy Ball"
ENT.Author			= "Garry Newman"
ENT.Information		= "An edible bouncy ball"
ENT.Category		= "Fun + Games"

ENT.Editable		= true
ENT.Spawnable		= true
ENT.AdminOnly		= false
ENT.RenderGroup		= RENDERGROUP_TRANSLUCENT

function ENT:SetupDataTables()

	self:NetworkVar( "Float", 0, "BallSize", { KeyName = "ballsize", Edit = { type = "Float", min = 4, max = 128, order = 1 } } )
	self:NetworkVar( "Vector", 0, "BallColor", { KeyName = "ballcolor", Edit = { type = "VectorColor", order = 2 } } )

end

-- This is the spawn function. It's called when a client calls the entity to be spawned.
-- If you want to make your SENT spawnable you need one of these functions to properly create the entity
--
-- ply is the name of the player that is spawning it
-- tr is the trace from the player's eyes 
--
function ENT:SpawnFunction( ply, tr, ClassName )

	if ( !tr.Hit ) then return end
	
	local size = math.random( 16, 48 )
	local SpawnPos = tr.HitPos + tr.HitNormal * size
	
	local ent = ents.Create( ClassName )
	ent:SetPos( SpawnPos )
	ent:SetBallSize( size )
	ent:Spawn()
	ent:Activate()
	
	return ent
	
end

--[[---------------------------------------------------------
   Name: Initialize
-----------------------------------------------------------]]
function ENT:Initialize()

	if ( SERVER ) then

		local size = self:GetBallSize() / 2
	
		-- Use the helibomb model just for the shadow (because it's about the same size)
		self:SetModel( "models/Combine_Helicopter/helicopter_bomb01.mdl" )
		
		-- Don't use the model's physics - create a sphere instead
		self:PhysicsInitSphere( size, "metal_bouncy" )
		
		-- Wake the physics object up. It's time to have fun!
		local phys = self:GetPhysicsObject()
		if ( IsValid( phys ) ) then
			phys:Wake()
		end
		
		-- Set collision bounds exactly
		self:SetCollisionBounds( Vector( -size, -size, -size ), Vector( size, size, size ) )

		local i = math.random( 0, 3 )
		
		if ( i == 0 ) then
			self:SetBallColor( Vector( 1, 0.3, 0.3 ) )
		elseif ( i == 1 ) then
			self:SetBallColor( Vector( 0.3, 1, 0.3 ) )
		elseif ( i == 2 ) then
			self:SetBallColor( Vector( 1, 1, 0.3 ) )
		else
			self:SetBallColor( Vector( 0.2, 0.3, 1 ) )
		end

		self:NetworkVarNotify( "BallSize", self.OnBallSizeChanged )
		
	else 
	
		self.LightColor = Vector( 0, 0, 0 )
	
	end
	
end

function ENT:OnBallSizeChanged( varname, oldvalue, newvalue )

	local delta = oldvalue - newvalue

	local size = self:GetBallSize() / 2.1
	self:PhysicsInitSphere( size, "metal_bouncy" )
	
	size = self:GetBallSize() / 2.6
	self:SetCollisionBounds( Vector( -size, -size, -size ), Vector( size, size, size ) )

	self:PhysWake()

end

if ( CLIENT ) then

local matBall = Material( "sprites/sent_ball" )

function ENT:Draw()
	
	local pos = self:GetPos()
	local vel = self:GetVelocity()

	render.SetMaterial( matBall )
	
	local lcolor = render.ComputeLighting( self:GetPos(), Vector( 0, 0, 1 ) )
	local c = self:GetBallColor()
	
	lcolor.x = c.r * ( math.Clamp( lcolor.x, 0, 1 ) + 0.5 ) * 255
	lcolor.y = c.g * ( math.Clamp( lcolor.y, 0, 1 ) + 0.5 ) * 255
	lcolor.z = c.b * ( math.Clamp( lcolor.z, 0, 1 ) + 0.5 ) * 255
	
	render.DrawSprite( pos, self:GetBallSize(), self:GetBallSize(), Color( lcolor.x, lcolor.y, lcolor.z, 255 ) )
	
end

end


--[[---------------------------------------------------------
   Name: PhysicsCollide
-----------------------------------------------------------]]
function ENT:PhysicsCollide( data, physobj )
	
	-- Play sound on bounce
	if ( data.Speed > 60 && data.DeltaTime > 0.2 ) then

		local pitch = 32 + 128 - self:GetBallSize()
		sound.Play( BounceSound, self:GetPos(), 75, math.random( pitch - 10, pitch + 10 ), math.Clamp( data.Speed / 150, 0, 1 ) )

	end
	
	-- Bounce like a crazy bitch
	local LastSpeed = math.max( data.OurOldVelocity:Length(), data.Speed )
	local NewVelocity = physobj:GetVelocity()
	NewVelocity:Normalize()
	
	LastSpeed = math.max( NewVelocity:Length(), LastSpeed )
	
	local TargetVelocity = NewVelocity * LastSpeed * 0.9
	
	physobj:SetVelocity( TargetVelocity )
	
end

--[[---------------------------------------------------------
   Name: OnTakeDamage
-----------------------------------------------------------]]
function ENT:OnTakeDamage( dmginfo )

	-- React physically when shot/getting blown
	self:TakePhysicsDamage( dmginfo )
	
end


--[[---------------------------------------------------------
   Name: Use
-----------------------------------------------------------]]
function ENT:Use( activator, caller )

	self:Remove()
	
	if ( activator:IsPlayer() ) then
	
		-- Give the collecting player some free health
		local health = activator:Health()
		activator:SetHealth( health + 5 )
		activator:SendLua( "achievements.EatBall()" )
		
	end

end
