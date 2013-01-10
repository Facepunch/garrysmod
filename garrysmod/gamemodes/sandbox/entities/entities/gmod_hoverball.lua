
AddCSLuaFile()
DEFINE_BASECLASS( "base_gmodentity" )

ENT.PrintName		= "Hover Ball"
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""
ENT.RenderGroup 	= RENDERGROUP_BOTH

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

function ENT:SetupDataTables()

	self:NetworkVar( "Float", 0, "TargetZ" );
	self:NetworkVar( "Float", 1, "SpeedVar" );
	self:NetworkVar( "Float", 2, "AirResistanceVar" )

end

--[[---------------------------------------------------------
   Name: Initialize
-----------------------------------------------------------]]
function ENT:Initialize()

	if ( CLIENT ) then

		self.Refraction = Material( "sprites/heatwave" )
		self.Glow		= Material( "sprites/light_glow02_add" )
	
		self.NextSmokeEffect = 0

	end

	if ( SERVER ) then

		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
	
		-- Wake up our physics object so we don't start asleep
		local phys = self:GetPhysicsObject()
		if ( IsValid( phys ) ) then 
			phys:EnableGravity( false )
			phys:Wake() 
		end
	
		-- Start the motion controller (so PhysicsSimulate gets called)
		self:StartMotionController()
	
		self.Fraction = 0
		self.ZVelocity = 0
		self:SetTargetZ( self:GetPos().z )
		self:SetSpeed( 1 )

	end

end

--[[---------------------------------------------------------
   Name: OnRestore
-----------------------------------------------------------]]
function ENT:OnRestore()

	self.ZVelocity = 0

end


--[[---------------------------------------------------------
   Name: GetSpeed
-----------------------------------------------------------]]
function ENT:GetSpeed()

	if ( !game.SinglePlayer() ) then return math.Clamp( self:GetSpeedVar(), 0, 10 ) end
	
	return self:GetSpeedVar()
	
end

--[[---------------------------------------------------------
   Name: SetSpeed
-----------------------------------------------------------]]
function ENT:SetSpeed( s )
	
	self:SetSpeedVar( s )
	self:UpdateLabel()
	
end

--[[---------------------------------------------------------
   Name: UpdateLabel
-----------------------------------------------------------]]
function ENT:UpdateLabel()

	self:SetOverlayText( string.format( "Speed: %i\nResistance: %.2f", self:GetSpeed(), self:GetAirResistance() ) )

end

--[[---------------------------------------------------------
   Name: DrawTranslucent
   Desc: Draw translucent
-----------------------------------------------------------]]
function ENT:DrawTranslucent()

	local vOffset = self:GetPos()
	local vPlayerEyes = LocalPlayer():EyePos()
	local vDiff = (vOffset - vPlayerEyes):GetNormalized()
	
	render.SetMaterial( self.Glow )	
	local color = Color( 70, 180, 255, 255 )
	render.DrawSprite( vOffset - vDiff * 2, 22, 22, color )
	
	local Distance = math.abs( ( self:GetTargetZ() - self:GetPos().z ) * math.sin( CurTime() * 20 )  ) * 0.05
	color.r = color.r * math.Clamp( Distance, 0, 1 )
	color.b = color.b * math.Clamp( Distance, 0, 1 )
	color.g = color.g * math.Clamp( Distance, 0, 1 )
	
	render.DrawSprite( vOffset + vDiff * 4, 48, 48, color )
	render.DrawSprite( vOffset + vDiff * 4, 52, 52, color )
	
	BaseClass.DrawTranslucent( self )
	
end

--[[---------------------------------------------------------
   Name: Simulate
-----------------------------------------------------------]]
function ENT:PhysicsSimulate( phys, deltatime )

	if ( self.ZVelocity != 0 ) then
	
		self:SetTargetZ( self:GetTargetZ() + (self.ZVelocity * deltatime * self:GetSpeed()) )
		self:GetPhysicsObject():Wake()
	
	end
	
	phys:Wake()
	
	local Pos = phys:GetPos()
	local Vel = phys:GetVelocity()
	local Distance = self:GetTargetZ() - Pos.z
	local AirResistance = self:GetAirResistance()
	
	if ( Distance == 0 ) then return end
	
	local Exponent = Distance^2
	
	if ( Distance < 0 ) then
		Exponent = Exponent * -1
	end
	
	Exponent = Exponent * deltatime * 300
	
	local physVel = phys:GetVelocity()
	local zVel = physVel.z
	
	Exponent = Exponent - (zVel * deltatime * 600 * ( AirResistance + 1 ) )
	-- The higher you make this 300 the less it will flop about
	-- I'm thinking it should actually be relative to any objects we're connected to
	-- Since it seems to flop more and more the heavier the object
	
	Exponent = math.Clamp( Exponent, -5000, 5000 )
	
	local Linear = Vector(0,0,0)
	local Angular = Vector(0,0,0)
	
	Linear.z = Exponent
	
	if ( AirResistance > 0 ) then
	
		Linear.y = physVel.y * -1 * AirResistance
		Linear.x = physVel.x * -1 * AirResistance
	
	end

	return Angular, Linear, SIM_GLOBAL_ACCELERATION
	
end


function ENT:SetZVelocity( z )

	if ( z != 0 ) then
		self:GetPhysicsObject():Wake()
	end

	self.ZVelocity = z * FrameTime() * 5000
end

--[[---------------------------------------------------------
   GetAirFriction
-----------------------------------------------------------]]
function ENT:GetAirResistance( )
	return self:GetAirResistanceVar()
end

--[[---------------------------------------------------------
   SetAirFriction
-----------------------------------------------------------]]
function ENT:SetAirResistance( num )
	self:SetAirResistanceVar( num )
	self:UpdateLabel()
end

--[[---------------------------------------------------------
   SetStrength
-----------------------------------------------------------]]
function ENT:SetStrength( strength )

	local phys = self:GetPhysicsObject()
	
	if ( phys:IsValid() ) then 
		phys:SetMass( 150 * strength )
	end

	self:UpdateLabel()
	
end

--
-- This gets called after the entity has been duplicated. 
-- We use it to set the target z to the spawned z.. because we want
-- to hover in place rather than zoom up to the saved level!
--
function ENT:OnDuplicated( v )

	self:SetTargetZ( v.Pos.z )

end


if ( SERVER ) then

	numpad.Register( "Hoverball_Up", function( pl, ent, keydown, idx )

		if ( !IsValid( ent ) ) then return false end
	
		if (keydown) then ent:SetZVelocity( 1 ) else ent:SetZVelocity( 0 ) end
		return true
	
	end )

	numpad.Register( "Hoverball_Down", function( pl, ent, keydown )

		if ( !IsValid( ent) ) then return false end
	
		if ( keydown ) then ent:SetZVelocity( -1 ) else ent:SetZVelocity( 0 ) end
		return true
	
	end )

end