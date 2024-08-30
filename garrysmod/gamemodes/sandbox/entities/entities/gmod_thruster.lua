
AddCSLuaFile()
DEFINE_BASECLASS( "base_gmodentity" )

ENT.PrintName = "Thruster"

if ( CLIENT ) then
	CreateConVar( "cl_drawthrusterseffects", "1", 0, "Should Sandbox Thruster effects be visible?" )
end

function ENT:SetEffect( name )
	self:SetNWString( "Effect", name )
end

function ENT:GetEffect()
	return self:GetNWString( "Effect", "" )
end

function ENT:SetOn( on )
	self:SetNWBool( "On", on )
end

function ENT:IsOn()
	return self:GetNWBool( "On", false )
end

function ENT:SetOffset( v )
	self:SetNWVector( "Offset", v )
end

function ENT:GetOffset()
	return self:GetNWVector( "Offset" )
end

function ENT:Initialize()

	if ( CLIENT ) then

		self.ShouldDraw = true

		-- Make the render bounds a bigger so the effect doesn't get snipped off
		local mx, mn = self:GetRenderBounds()
		self:SetRenderBounds( mn + Vector( 0, 0, 128 ), mx )

		self.Seed = math.Rand( 0, 10000 )

	else

		self:PhysicsInit( SOLID_VPHYSICS )

		local phys = self:GetPhysicsObject()
		if ( IsValid( phys ) ) then phys:Wake() end

		local max = self:OBBMaxs()
		local min = self:OBBMins()

		self.ThrustOffset = Vector( 0, 0, max.z )
		self.ThrustOffsetR = Vector( 0, 0, min.z )
		self.ForceAngle = self.ThrustOffset:GetNormalized() * -1

		self:SetForce( 2000 )

		self:SetEffect( "Fire" )

		self:SetOffset( self.ThrustOffset )
		self:StartMotionController()

		self:Switch( false )
		self.ActivateOnDamage = true

		self.SoundName = Sound( "PhysicsCannister.ThrusterLoop" )

	end

end

if ( CLIENT ) then
	function ENT:DrawEffects()

		if ( not self:IsOn() ) then return end
		if ( self.ShouldDraw == false ) then return end

		if ( self:GetEffect() == "" or self:GetEffect() == "none" ) then return end

		local EffectTable = list.GetForEdit( "ThrusterEffects" )[ self:GetEffect() ]

		local effectDraw = EffectTable.effectDraw
		if effectDraw then effectDraw( self ) end

	end

	ENT.WantsTranslucency = true -- If model is opaque, still call DrawTranslucent
	function ENT:DrawTranslucent( flags )

		BaseClass.DrawTranslucent( self, flags )

		self:DrawEffects()

	end
end

function ENT:Think()

	BaseClass.Think( self )

	if ( SERVER and self.SwitchOffTime and self.SwitchOffTime < CurTime() ) then
		self.SwitchOffTime = nil
		self:Switch( false )
	end

	if ( CLIENT ) then

		self.ShouldDraw = GetConVarNumber( "cl_drawthrusterseffects" ) ~= 0

		if ( not self:IsOn() ) then self.OnStart = nil return end
		self.OnStart = self.OnStart or CurTime()

		if ( self.ShouldDraw == false ) then return end
		if ( self:GetEffect() == "" or self:GetEffect() == "none" ) then return end

		local EffectTable = list.GetForEdit( "ThrusterEffects" )[ self:GetEffect() ]

		local effectThink = EffectTable.effectThink
		if effectThink then effectThink( self ) end

	end

end

if ( CLIENT ) then
	--[[---------------------------------------------------------
		Use the same emitter, but get a new one every 2 seconds
			This will fix any draw order issues
	-----------------------------------------------------------]]
	function ENT:GetEmitter( Pos, b3D )

		if ( self.Emitter and self.EmitterIs3D == b3D and self.EmitterTime > CurTime() ) then
			return self.Emitter
		end

		if ( IsValid( self.Emitter ) ) then
			self.Emitter:Finish()
		end

		self.Emitter = ParticleEmitter( Pos, b3D )
		self.EmitterIs3D = b3D
		self.EmitterTime = CurTime() + 2
		return self.Emitter

	end
end

function ENT:OnRemove()

	if ( IsValid( self.Emitter ) ) then
		self.Emitter:Finish()
	end

	if ( self.Sound ) then
		self.Sound:Stop()
	end

end

if ( SERVER ) then
	function ENT:SetForce( force, mul )

		if ( force ) then self.force = force end
		mul = mul or 1

		local phys = self:GetPhysicsObject()
		if ( !IsValid( phys ) ) then
			Msg( "Warning: [gmod_thruster] Physics object isn't valid!\n" )
			return
		end

		-- Get the data in worldspace
		local ThrusterWorldPos = phys:LocalToWorld( self.ThrustOffset )
		local ThrusterWorldForce = phys:LocalToWorldVector( self.ThrustOffset * -1 )

		-- Calculate the velocity
		ThrusterWorldForce = ThrusterWorldForce * self.force * mul * 50

		local motionEnabled = phys:IsMotionEnabled()
		phys:EnableMotion( true ) -- Dirty hack for PhysObj.CalculateVelocityOffset while frozen
		self.ForceLinear, self.ForceAngle = phys:CalculateVelocityOffset( ThrusterWorldForce, ThrusterWorldPos )
		phys:EnableMotion( motionEnabled )

		self.ForceLinear = phys:WorldToLocalVector( self.ForceLinear )

		if ( mul > 0 ) then
			self:SetOffset( self.ThrustOffset )
		else
			self:SetOffset( self.ThrustOffsetR )
		end

		self:SetNWVector( "1", self.ForceAngle )
		self:SetNWVector( "2", self.ForceLinear )

		self:SetOverlayText( "Force: " .. math.floor( self.force ) )

	end

	function ENT:AddMul( mul, bDown )

		if ( self:GetToggle() ) then

			if ( !bDown ) then return end

			if ( self.Multiply == mul ) then
				self.Multiply = 0
			else
				self.Multiply = mul
			end

		else

			self.Multiply = self.Multiply or 0
			self.Multiply = self.Multiply + mul

		end

		self:SetForce( nil, self.Multiply )
		self:Switch( self.Multiply != 0 )

	end

	function ENT:OnTakeDamage( dmginfo )

		self:TakePhysicsDamage( dmginfo )

		if ( !self.ActivateOnDamage ) then return end

		self:Switch( true )

		self.SwitchOffTime = CurTime() + 5

	end

	function ENT:Use( activator, caller )
	end

	function ENT:PhysicsSimulate( phys, deltatime )

		if ( !self:IsOn() ) then return SIM_NOTHING end

		return self.ForceAngle, self.ForceLinear, SIM_LOCAL_ACCELERATION

	end

	-- Switch thruster on or off
	function ENT:Switch( on )

		if ( !IsValid( self ) ) then return false end

		self:SetOn( on )

		if ( on ) then

			self:StartThrustSound()

		else

			self:StopThrustSound()

		end

		local phys = self:GetPhysicsObject()
		if ( IsValid( phys ) ) then phys:Wake() end

		return true

	end

	function ENT:SetSound( sound )

		-- No change, don't do shit
		if ( self.SoundName == sound ) then return end

		-- Gracefully shutdown
		if ( self:IsOn() ) then
			self:StopThrustSound()
		end

		self.SoundName = Sound( sound )
		self.Sound = nil

		-- Now start the new sound
		if ( self:IsOn() ) then
			self:StartThrustSound()
		end

	end

	-- Starts the looping sound
	function ENT:StartThrustSound()

		if ( !self.SoundName or self.SoundName == "" ) then return end

		local valid = false
		for _, v in pairs( list.Get( "ThrusterSounds" ) ) do
			if ( v.thruster_soundname == self.SoundName ) then valid = true break end
		end

		if ( !valid ) then return end

		if ( !self.Sound ) then
			 -- Make sure the fadeout gets to every player!
			local filter = RecipientFilter()
			filter:AddPAS( self:GetPos() )
			self.Sound = CreateSound( self, self.SoundName, filter )
		end

		self.Sound:PlayEx( 0.5, 100 )

	end

	-- Stop the looping sound
	function ENT:StopThrustSound()

		if ( self.Sound ) then
			self.Sound:ChangeVolume( 0.0, 0.25 )
		end

	end

	-- Sets whether this is a toggle thruster or not
	function ENT:SetToggle( tog )
		self.Toggle = tog
	end

	-- Returns true if this is a toggle thruster
	function ENT:GetToggle()
		return self.Toggle
	end

	numpad.Register( "Thruster_On", function( ply, ent, mul )

		if ( !IsValid( ent ) ) then return false end

		ent:AddMul( mul, true )
		return true

	end )

	numpad.Register( "Thruster_Off", function( ply, ent, mul )

		if ( !IsValid( ent ) ) then return false end

		ent:AddMul( mul * -1, false )
		return true

	end )

end

--[[---------------------------------------------------------
	Register the effects
-----------------------------------------------------------]]

list.Set( "ThrusterEffects", "none", { print = "#thrustereffect.none" } )

local matHeatWave = Material( "sprites/heatwave" )
local matFire = Material( "effects/fire_cloud1" )
local vecFire = Vector( 0, 0, 0 )
local colFire = {
	Color( 0, 0, 255, 128 ),
	Color( 255, 255, 255, 128 ),
	Color( 255, 255, 255, 0 ),
	Color( 0, 0, 0, 0 ),
}
list.Set( "ThrusterEffects", "fire", {
	print = "#thrustereffect.flames",
	effectDraw = function( self )

		local vOffset = self:LocalToWorld( self:GetOffset() )
		local vNormal = self:GetPos()
		vNormal:Negate()
		vNormal:Add( vOffset )
		vNormal:Normalize()

		local scroll = self.Seed + ( CurTime() * -10 )

		local size = self:OBBMaxs()
		size:Sub( self:OBBMins() )
		size = math.min( size.x, size.y, 50 )

		local Scale = math.Clamp( ( CurTime() - self.OnStart ) * 5, 0, 1 )

		render.SetMaterial( matFire )

		render.StartBeam( 3 )
			render.AddBeam( vOffset, size * Scale, scroll, colFire[1] )

			vecFire:Set( vNormal )
			vecFire:Mul( 60 * Scale )
			vecFire:Add( vOffset )

			render.AddBeam( vecFire, 32 * Scale, scroll + 1, colFire[2] )

			vecFire:Set( vNormal )
			vecFire:Mul( 148 * Scale )
			vecFire:Add( vOffset )

			render.AddBeam( vecFire, 32 * Scale, scroll + 3, colFire[3] )
		render.EndBeam()

		scroll = scroll * 0.5

		render.UpdateRefractTexture()
		render.SetMaterial( matHeatWave )
		render.StartBeam( 3 )
			render.AddBeam( vOffset, size * Scale, scroll, colFire[1] )

			vecFire:Set( vNormal )
			vecFire:Mul( 32 * Scale )
			vecFire:Add( vOffset )

			render.AddBeam( vecFire, 32 * Scale, scroll + 2, color_white )

			vecFire:Set( vNormal )
			vecFire:Mul( 128 * Scale )
			vecFire:Add( vOffset )

			render.AddBeam( vecFire, 48 * Scale, scroll + 5, colFire[4] )
		render.EndBeam()


		scroll = scroll * 1.3
		render.SetMaterial( matFire )
		render.StartBeam( 3 )
			render.AddBeam( vOffset, size * Scale, scroll, colFire[1] )

			vecFire:Set( vNormal )
			vecFire:Mul( 60 * Scale )
			vecFire:Add( vOffset )

			render.AddBeam( vecFire, 16 * Scale, scroll + 1, colFire[2] )

			vecFire:Set( vNormal )
			vecFire:Mul( 148 * Scale )
			vecFire:Add( vOffset )

			render.AddBeam( vecFire, 16 * Scale, scroll + 3, colFire[3] )
		render.EndBeam()

	end
} )

local matPlasma = Material( "effects/strider_muzzle" )
local vecPlasma = Vector( 0, 0, 0 )
local colPlasma = {
	Color( 0, 255, 255, 255 ),
	Color( 0, 255, 255, 0 ),
}
list.Set( "ThrusterEffects", "plasma", {
	print = "#thrustereffect.plasma",
	effectDraw = function( self )

		local vOffset = self:LocalToWorld( self:GetOffset() )
		local vNormal = self:GetPos()
		vNormal:Negate()
		vNormal:Add( vOffset )
		vNormal:Normalize()

		local scroll = self.Seed + ( CurTime() * -20 )

		local size = self:OBBMaxs()
		size:Sub( self:OBBMins() )
		size = math.min( size.x, size.y ) * 1.5

		render.SetMaterial( matPlasma )

		-- First vector
		vecFire:Set( vNormal )
		vecFire:Mul( 8 )
		vecFire:Add( vOffset )

		-- Second vector
		vecPlasma:Set( vNormal )
		vecPlasma:Mul( 64 )
		vecPlasma:Add( vOffset )

		scroll = scroll * 0.9

		render.StartBeam( 3 )
			render.AddBeam( vOffset, size, scroll, colPlasma[1] )
			render.AddBeam( vecFire, size, scroll + 0.01, color_white )
			render.AddBeam( vecPlasma, size, scroll + 0.02, colPlasma[2] )
		render.EndBeam()

		scroll = scroll * 0.9

		render.StartBeam( 3 )
			render.AddBeam( vOffset, size, scroll, colPlasma[1] )
			render.AddBeam( vecFire, size, scroll + 0.01, color_white )
			render.AddBeam( vecPlasma, size, scroll + 0.02, colPlasma[2] )
		render.EndBeam()

		scroll = scroll * 0.9

		render.StartBeam( 3 )
			render.AddBeam( vOffset, size, scroll, colPlasma[1] )
			render.AddBeam( vecFire, size, scroll + 0.01, color_white )
			render.AddBeam( vecPlasma, size, scroll + 0.02, colPlasma[2] )
		render.EndBeam()
	end
} )

local vecMagic = Vector()
list.Set( "ThrusterEffects", "magic", {
	print = "#thrustereffect.magic",
	effectThink = function( self )

		local tbl = self:GetTable()
		tbl.SmokeTimer = tbl.SmokeTimer or 0

		local curtime = CurTime()
		if ( tbl.SmokeTimer > curtime ) then return end
		tbl.SmokeTimer = curtime + 0.01

		local vOffset = self:LocalToWorld( self:GetOffset() )

		local size = self:OBBMaxs()
		size:Sub( self:OBBMins() )

		vecMagic:SetUnpacked( math.Rand( -1, 1 ), math.Rand( -1, 1 ), math.Rand( -1, 1 ) )
		vecMagic:Mul( math.min( size.x, size.y ) / 3 )
		vecMagic:Add( vOffset )

		local emitter = self:GetEmitter( vecMagic, false )
		if ( not IsValid( emitter ) ) then return end

		local particle = emitter:Add( "sprites/gmdm_pickups/light", vecMagic )
		if ( not particle ) then return end

		local vNormal = self:GetPos()
		vNormal:Negate()
		vNormal:Add( vOffset )
		vNormal:Normalize()
		vNormal:Mul( math.Rand( 80, 160 ) )

		particle:SetVelocity( vNormal )
		particle:SetDieTime( 0.5 )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 255 )
		particle:SetStartSize( math.Rand( 1, 3 ) )
		particle:SetEndSize( 0 )
		particle:SetRoll( math.Rand( -0.2, 0.2 ) )

	end
} )

list.Set( "ThrusterEffects", "rings", {
	print = "#thrustereffect.rings",
	effectThink = function( self )

		local tbl = self:GetTable()
		tbl.RingTimer = tbl.RingTimer or 0

		local curtime = CurTime()
		if ( tbl.RingTimer > curtime ) then return end
		tbl.RingTimer = curtime + 0.01

		local vOffset = self:LocalToWorld( self:GetOffset() )
		local vNormal = self:GetPos()
		vNormal:Negate()
		vNormal:Add( vOffset )
		vNormal:Normalize()

		local size = self:OBBMaxs()
		size:Sub( self:OBBMins() )

		vecMagic:Set( vNormal )
		vecMagic:Mul( 5 )
		vOffset:Add( vecMagic )

		local emitter = self:GetEmitter( vOffset, true )
		if ( not IsValid( emitter ) ) then return end

		local particle = emitter:Add( "effects/select_ring", vOffset )
		if ( not particle ) then return end

		vNormal:Mul( 300 )

		particle:SetVelocity( vNormal )
		particle:SetLifeTime( 0 )
		particle:SetDieTime( 0.2 )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.min( size.x, size.y ) / 2 )
		particle:SetEndSize( 10 )
		particle:SetAngles( vNormal:Angle() )
		particle:SetColor( math.Rand( 10, 100 ), math.Rand( 100, 220 ), math.Rand( 240, 255 ) )

	end
} )

local gravSmoke = Vector( 0, 0, 32 )
list.Set( "ThrusterEffects", "smoke", {
	print = "#thrustereffect.smoke",
	effectThink = function( self )

		local tbl = self:GetTable()
		tbl.SmokeTimer = tbl.SmokeTimer or 0

		local curtime = CurTime()
		if ( tbl.SmokeTimer > curtime ) then return end
		tbl.SmokeTimer = curtime + 0.015

		local size = self:OBBMaxs()
		size:Sub( self:OBBMins() )
		size = math.min( size.x, size.y ) / 2

		local vPos = self:GetPos()
		local vOffset = self:LocalToWorld( self:GetOffset() )
		local vNormal = vOffset - vPos
		vNormal:Normalize()
		vNormal:Mul( 32 )
		vNormal:Add( vOffset )

		vecMagic:SetUnpacked( math.Rand( -3, 3 ), math.Rand( -3, 3 ), math.Rand( -3, 3 ) )
		vNormal:Add( vecMagic )

		vNormal:Sub( vPos )
		vNormal:Normalize()

		local emitter = self:GetEmitter( vOffset, false )
		if ( not IsValid( emitter ) ) then return end

		vOffset:Add( vecMagic )
		local particle = emitter:Add( "particles/smokey", vOffset )
		if ( not particle ) then return end

		local vel_scale = math.Rand( 10, 30 ) * 10 / math.Clamp( self:GetVelocity():Length() / 200, 1, 10 )
		vNormal:Mul( vel_scale )

		particle:SetVelocity( vNormal )
		particle:SetDieTime( 2.0 )
		particle:SetGravity( gravSmoke )
		particle:SetStartAlpha( math.Rand( 50, 150 ) )
		particle:SetStartSize( size )
		particle:SetEndSize( math.Rand( 64, 128 ) )
		particle:SetRoll( math.Rand( -0.2, 0.2 ) )
		particle:SetColor( 200, 200, 210 )

	end
} )
