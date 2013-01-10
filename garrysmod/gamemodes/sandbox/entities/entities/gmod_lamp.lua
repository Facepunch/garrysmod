
AddCSLuaFile()
DEFINE_BASECLASS( "base_gmodentity" )

ENT.Spawnable			= false
ENT.AdminSpawnable		= false
ENT.RenderGroup 		= RENDERGROUP_BOTH

local matLight 			= Material( "sprites/light_ignorez" )
local matBeam			= Material( "effects/lamp_beam" )

AccessorFunc( ENT, "Texture", "FlashlightTexture" )

--
-- Set up our data table
--
function ENT:SetupDataTables()

	self:NetworkVar( "Bool", 0, "On" );
	self:NetworkVar( "Float", 0, "LightFOV" );
	self:NetworkVar( "Float", 1, "Distance" );
	self:NetworkVar( "Float", 2, "Brightness" );

end

--
-- Custom drive mode
--
function ENT:GetEntityDriveMode()

	return "drive_noclip"
	
end

--[[---------------------------------------------------------
   Name: Initialize
-----------------------------------------------------------]]
function ENT:Initialize()

	if ( SERVER ) then

		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:DrawShadow( false )
	
		local phys = self:GetPhysicsObject()
	
		if ( IsValid( phys ) ) then
			phys:Wake()
		end

	end

	if ( CLIENT ) then

		self.PixVis = util.GetPixelVisibleHandle()

	end
	
end


--[[---------------------------------------------------------
   Name: OnTakeDamage
-----------------------------------------------------------]]
function ENT:OnTakeDamage( dmginfo )

	self:TakePhysicsDamage( dmginfo )

end


--[[---------------------------------------------------------
   Name: Use
-----------------------------------------------------------]]
function ENT:Use( activator, caller )

end

function ENT:Switch( bOn )

	if ( bOn == self:GetOn() ) then return end

	self.on = bOn;

	if ( !bOn ) then

		SafeRemoveEntity( self.flashlight )
		self.flashlight = nil
		self:SetOn( false )
		return

	end

	self:SetOn( true )
	
	local angForward = self:GetAngles()
	
	self.flashlight = ents.Create( "env_projectedtexture" )
	
		self.flashlight:SetParent( self.Entity )
		
		-- The local positions are the offsets from parent..
		self.flashlight:SetLocalPos( Vector( 0, 0, 0 ) )
		self.flashlight:SetLocalAngles( Angle(0,0,0) )
		
		-- Looks like only one flashlight can have shadows enabled!
		self.flashlight:SetKeyValue( "enableshadows", 1 )
		self.flashlight:SetKeyValue( "farz", self:GetDistance() )
		self.flashlight:SetKeyValue( "nearz", 12 )
		self.flashlight:SetKeyValue( "lightfov", self:GetLightFOV() )
		
		local c = self:GetColor()
		local b = self:GetBrightness()
		self.flashlight:SetKeyValue( "lightcolor", Format( "%i %i %i 255", c.r * b, c.g * b, c.b * b ) )
		
	self.flashlight:Spawn()
	
	self.flashlight:Input( "SpotlightTexture", NULL, NULL, self:GetFlashlightTexture() )

end

--[[---------------------------------------------------------
   Name: Toggle
-----------------------------------------------------------]]
function ENT:Toggle()

	self:Switch( !self:GetOn() );

end

function ENT:UpdateLight()

	if ( !IsValid( self.flashlight ) ) then return end

	self.flashlight:Input( "SpotlightTexture", NULL, NULL, self:GetFlashlightTexture() )
	self.flashlight:Input( "FOV", NULL, NULL, tostring( self:GetLightFOV() ) )
	self.flashlight:SetKeyValue( "farz", self:GetDistance() )

	local c = self:GetColor()
	local b = self:GetBrightness()
	self.flashlight:SetKeyValue( "lightcolor", Format( "%i %i %i 255", c.r*b, c.g*b, c.b*b ) )

end

--[[---------------------------------------------------------
   Name: Draw
-----------------------------------------------------------]]
function ENT:Draw()

	BaseClass.Draw( self )
	
end

--[[---------------------------------------------------------
   Name: DrawTranslucent
   Desc: Draw translucent
-----------------------------------------------------------]]
function ENT:DrawTranslucent()
	
	BaseClass.DrawTranslucent( self )
	
	-- No glow if we're not switched on!
	if ( !self:GetOn() ) then return end
	
	local LightNrm = self:GetAngles():Forward()
	local ViewNormal = self:GetPos() - EyePos()
	local Distance = ViewNormal:Length()
	ViewNormal:Normalize()
	local ViewDot = ViewNormal:Dot( LightNrm * -1 )
	local LightPos = self:GetPos() + LightNrm * 5
	
	-- glow sprite
	--[[
	render.SetMaterial( matBeam )
	
	local BeamDot = BeamDot = 0.25
	
	render.StartBeam( 3 )
		render.AddBeam( LightPos + LightNrm * 1, 128, 0.0, Color( r, g, b, 255 * BeamDot) )
		render.AddBeam( LightPos - LightNrm * 100, 128, 0.5, Color( r, g, b, 64 * BeamDot) )
		render.AddBeam( LightPos - LightNrm * 200, 128, 1, Color( r, g, b, 0) )
	render.EndBeam()
	--]]

	if ( ViewDot >= 0 ) then
	
		render.SetMaterial( matLight )
		local Visibile	= util.PixelVisible( LightPos, 16, self.PixVis )	
		
		if (!Visibile) then return end
		
		local Size = math.Clamp( Distance * Visibile * ViewDot * 2, 64, 512 )
		
		Distance = math.Clamp( Distance, 32, 800 )
		local Alpha = math.Clamp( (1000 - Distance) * Visibile * ViewDot, 0, 100 )
		local Col = self:GetColor()
		Col.a = Alpha
		
		render.DrawSprite( LightPos, Size, Size, Col, Visibile * ViewDot )
		render.DrawSprite( LightPos, Size*0.4, Size*0.4, Color(255, 255, 255, Alpha), Visibile * ViewDot )
		
	end
	
end

--[[---------------------------------------------------------
   Overridden because I want to show the name of the 
   player that spawned it..
-----------------------------------------------------------]]
function ENT:GetOverlayText()

	return self:GetPlayerName()	
	
end
