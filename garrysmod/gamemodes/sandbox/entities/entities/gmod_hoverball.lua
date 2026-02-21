
AddCSLuaFile()
DEFINE_BASECLASS( "base_gmodentity" )

ENT.PrintName = "Hoverball"
ENT.Editable = true

function ENT:SetupDataTables()

	self:NetworkVar( "Bool", 0, "Enabled" )

	self:NetworkVar( "Float", 0, "TargetZ" )
	self:NetworkVar( "Float", 1, "SpeedVar", { KeyName = "speed", Edit = { type = "Float", order = 1, min = 0, max = 20, title = "#tool.hoverball.speed" } } )
	self:NetworkVar( "Float", 2, "AirResistanceVar", { KeyName = "resistance", Edit = { type = "Float", order = 2, min = 0, max = 10, title = "#tool.hoverball.resistance" } } )

end

function ENT:Initialize()

	if ( CLIENT ) then

		self.Glow = Material( "sprites/light_glow02_add" )

	end

	if ( SERVER ) then

		self:PhysicsInit( SOLID_VPHYSICS )

		-- Wake up our physics object so we don't start asleep
		local phys = self:GetPhysicsObject()
		if ( IsValid( phys ) ) then
			phys:EnableGravity( !self:GetEnabled() )
			phys:Wake()
		end

		-- Start the motion controller (so PhysicsSimulate gets called)
		self:StartMotionController()

		self.Fraction = 0
		self.ZVelocity = 0
		self:SetTargetZ( self:GetPos().z )
		self:SetSpeed( 1 )
		self:SetEnabled( true )

	end

end

function ENT:OnRestore()

	self.ZVelocity = 0

end

function ENT:GetSpeed()

	if ( !game.SinglePlayer() ) then return math.Clamp( self:GetSpeedVar(), 0, 10 ) end

	return self:GetSpeedVar()

end

function ENT:SetSpeed( s )

	self:SetSpeedVar( s )
	self:UpdateLabel()

end

function ENT:UpdateLabel()

	local strength = 0
	if ( self:GetPhysicsObject() ) then strength = self:GetPhysicsObject():GetMass() / 150 end

	self:SetOverlayText( string.format( "Speed: %g\nResistance: %g\nStrength: %g", self:GetSpeed(), self:GetAirResistance(), strength ) )

end

function ENT:DrawEffects()
	if ( !self:GetEnabled() ) then return end

	local vOffset = self:GetPos()
	local vPlayerEyes = LocalPlayer():EyePos()
	local vDiff = ( vOffset - vPlayerEyes ):GetNormalized()

	render.SetMaterial( self.Glow )
	local color = Color( 70, 180, 255, 255 )
	render.DrawSprite( vOffset - vDiff * 2, 22, 22, color )

	local Distance = math.abs( ( self:GetTargetZ() - self:GetPos().z ) * math.sin( CurTime() * 20 ) ) * 0.05
	color.r = color.r * math.Clamp( Distance, 0, 1 )
	color.b = color.b * math.Clamp( Distance, 0, 1 )
	color.g = color.g * math.Clamp( Distance, 0, 1 )

	render.DrawSprite( vOffset + vDiff * 4, 48, 48, color )
	render.DrawSprite( vOffset + vDiff * 4, 52, 52, color )
end

ENT.WantsTranslucency = true -- If model is opaque, still call DrawTranslucent
function ENT:DrawTranslucent( flags )
	self:DrawEffects()
	BaseClass.DrawTranslucent( self, flags )
end

function ENT:PhysicsSimulate( phys, deltatime )

	if ( !self:GetEnabled() ) then return end

	if ( self.ZVelocity != 0 ) then

		self:SetTargetZ( self:GetTargetZ() + ( self.ZVelocity * deltatime * self:GetSpeed() ) )
		self:GetPhysicsObject():Wake()

	end

	phys:Wake()

	local Pos = phys:GetPos()
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

	Exponent = Exponent - ( zVel * deltatime * 600 * ( AirResistance + 1 ) )
	-- The higher you make this 300 the less it will flop about
	-- I'm thinking it should actually be relative to any objects we're connected to
	-- Since it seems to flop more and more the heavier the object

	Exponent = math.Clamp( Exponent, -5000, 5000 )

	local Linear = Vector( 0, 0, Exponent )

	if ( AirResistance > 0 ) then

		Linear.y = physVel.y * -1 * AirResistance
		Linear.x = physVel.x * -1 * AirResistance

	end

	return vector_origin, Linear, SIM_GLOBAL_ACCELERATION

end

function ENT:SetZVelocity( z )

	if ( z != 0 ) then
		self:GetPhysicsObject():Wake()
	end

	self.ZVelocity = z * FrameTime() * 5000

end

function ENT:Toggle()

	self:SetEnabled( !self:GetEnabled() )

	if ( self:GetEnabled() ) then
		self:SetTargetZ( self:GetPos().z )
	end

	local phys = self:GetPhysicsObject()
	if ( IsValid( phys ) ) then
		phys:EnableGravity( !self:GetEnabled() )
		phys:Wake()

		-- Make the mass not insane when they are turned off
		if ( self.Strength ) then
			if ( self:GetEnabled() ) then
				phys:SetMass( 150 * self.Strength )
			else
				phys:SetMass( 15 )
			end
		end
	end

end

function ENT:GetAirResistance()
	return self:GetAirResistanceVar()
end

function ENT:SetAirResistance( num )
	self:SetAirResistanceVar( num )
	self:UpdateLabel()
end

function ENT:SetStrength( strength )

	self.Strength = strength

	local phys = self:GetPhysicsObject()
	if ( IsValid( phys ) ) then
		phys:SetMass( 150 * self.Strength )
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

	local phys = self:GetPhysicsObject()
	if ( IsValid( phys ) && !self:GetEnabled() ) then
		phys:SetMass( 15 )
	end

end

if ( SERVER ) then

	numpad.Register( "Hoverball_Up", function( ply, ent, keydown )

		if ( !IsValid( ent ) ) then return false end

		if ( keydown ) then ent:SetZVelocity( 1 ) else ent:SetZVelocity( 0 ) end
		return true

	end )

	numpad.Register( "Hoverball_Down", function( ply, ent, keydown )

		if ( !IsValid( ent ) ) then return false end

		if ( keydown ) then ent:SetZVelocity( -1 ) else ent:SetZVelocity( 0 ) end
		return true

	end )

	numpad.Register( "Hoverball_Toggle", function( ply, ent )

		if ( !IsValid( ent ) ) then return false end

		ent:Toggle()
		return true

	end )

end
