
AddCSLuaFile()
DEFINE_BASECLASS( "base_gmodentity" )

ENT.PrintName = "Lamp"
ENT.Editable = true

AccessorFunc( ENT, "Texture", "FlashlightTexture" )

-- Set up our data table
function ENT:SetupDataTables()

	self:NetworkVar( "Bool", 0, "On", { KeyName = "on", Edit = { type = "Boolean", order = 1, title = "#entedit.enabled" } } )
	self:NetworkVar( "Bool", 1, "Toggle", { KeyName = "toggle", Edit = { type = "Boolean", order = 2, title = "#tool.lamp.toggle" } } )
	self:NetworkVar( "Float", 0, "LightFOV", { KeyName = "fov", Edit = { type = "Float", order = 3, min = 10, max = 170, title = "#tool.lamp.fov" } } )
	self:NetworkVar( "Float", 1, "Distance", { KeyName = "dist", Edit = { type = "Float", order = 4, min = 64, max = 2048, title = "#tool.lamp.distance" } } )
	self:NetworkVar( "Float", 2, "Brightness", { KeyName = "bright", Edit = { type = "Float", order = 5, min = 0, max = 8, title = "#tool.lamp.brightness" } } )

	if ( SERVER ) then
		self:NetworkVarNotify( "On", self.OnUpdateLight )
		self:NetworkVarNotify( "LightFOV", self.OnUpdateLight )
		self:NetworkVarNotify( "Brightness", self.OnUpdateLight )
		self:NetworkVarNotify( "Distance", self.OnUpdateLight )
	end

end

-- Custom drive mode
function ENT:GetEntityDriveMode()

	return "drive_noclip"

end

function ENT:Initialize()

	if ( SERVER ) then

		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:DrawShadow( false )

		local phys = self:GetPhysicsObject()
		if ( IsValid( phys ) ) then phys:Wake() end

	end

	if ( CLIENT ) then

		self.PixVis = util.GetPixelVisibleHandle()

	end

end

if ( SERVER ) then

	function ENT:Think()

		self.BaseClass.Think( self )

		if ( !IsValid( self.flashlight ) ) then return end

		if ( string.FromColor( self.flashlight:GetColor() ) != string.FromColor( self:GetColor() ) ) then
			self.flashlight:SetColor( self:GetColor() )
			self:UpdateLight()
		end

	end

	function ENT:OnTakeDamage( dmginfo )

		self:TakePhysicsDamage( dmginfo )

	end

	function ENT:Use( activator, caller )
	end

	function ENT:Switch( bOn )
		self:SetOn( bOn )
	end

	function ENT:OnSwitch( bOn )

		if ( bOn && IsValid( self.flashlight ) ) then return end

		if ( !bOn ) then

			SafeRemoveEntity( self.flashlight )
			self.flashlight = nil
			return

		end

		self.flashlight = ents.Create( "env_projectedtexture" )
		self.flashlight:SetParent( self )

		-- The local positions are the offsets from parent..
		self.flashlight:SetLocalPos( vector_origin )
		self.flashlight:SetLocalAngles( angle_zero )

		self.flashlight:SetKeyValue( "enableshadows", 1 )
		self.flashlight:SetKeyValue( "nearz", 12 )
		self.flashlight:SetKeyValue( "lightfov", math.Clamp( self:GetLightFOV(), 10, 170 ) ) 

		local dist = self:GetDistance()
		if ( !game.SinglePlayer() ) then dist = math.Clamp( dist, 64, 2048 ) end
		self.flashlight:SetKeyValue( "farz", dist )

		local c = self:GetColor()
		local b = self:GetBrightness()
		if ( !game.SinglePlayer() ) then b = math.Clamp( b, 0, 8 ) end
		self.flashlight:SetKeyValue( "lightcolor", Format( "%i %i %i 255", c.r * b, c.g * b, c.b * b ) )

		self.flashlight:Spawn()

		self.flashlight:Input( "SpotlightTexture", NULL, NULL, self:GetFlashlightTexture() )

	end

	function ENT:Toggle()

		self:SetOn( !self:GetOn() )

	end

	function ENT:OnUpdateLight( name, old, new )

		if ( name == "On" ) then
			self:OnSwitch( new )
		end

		if ( !IsValid( self.flashlight ) ) then return end

		if ( name == "LightFOV" ) then
			self.flashlight:Input( "FOV", NULL, NULL, tostring( math.Clamp( new, 10, 170 ) ) )
		elseif ( name == "Distance" ) then
			if ( !game.SinglePlayer() ) then new = math.Clamp( new, 64, 2048 ) end
			self.flashlight:SetKeyValue( "farz", new )
		elseif ( name == "Brightness" ) then
			local c = self:GetColor()
			local b = new
			if ( !game.SinglePlayer() ) then b = math.Clamp( b, 0, 8 ) end
			self.flashlight:SetKeyValue( "lightcolor", Format( "%i %i %i 255", c.r * b, c.g * b, c.b * b ) )
		end

	end

	function ENT:UpdateLight()

		if ( !IsValid( self.flashlight ) ) then return end

		self.flashlight:Input( "SpotlightTexture", NULL, NULL, self:GetFlashlightTexture() )
		self.flashlight:Input( "FOV", NULL, NULL, tostring( math.Clamp( self:GetLightFOV(), 10, 170 ) ) )

		local dist = self:GetDistance()
		if ( !game.SinglePlayer() ) then dist = math.Clamp( dist, 64, 2048 ) end
		self.flashlight:SetKeyValue( "farz", dist )

		local c = self:GetColor()
		local b = self:GetBrightness()
		if ( !game.SinglePlayer() ) then b = math.Clamp( b, 0, 8 ) end
		self.flashlight:SetKeyValue( "lightcolor", Format( "%i %i %i 255", c.r * b, c.g * b, c.b * b ) )

	end

	-- The rest is for client only
	return
end

-- Show the name of the player that spawned it..
function ENT:GetOverlayText()
	return self:GetPlayerName()
end

local matLight = Material( "sprites/light_ignorez" )
--local matBeam = Material( "effects/lamp_beam" )
function ENT:DrawEffects()

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
		local Visibile = util.PixelVisible( LightPos, 16, self.PixVis )

		if ( !Visibile ) then return end

		local Size = math.Clamp( Distance * Visibile * ViewDot * 2, 64, 512 )

		Distance = math.Clamp( Distance, 32, 800 )
		local Alpha = math.Clamp( ( 1000 - Distance ) * Visibile * ViewDot, 0, 100 )
		local Col = self:GetColor()
		Col.a = Alpha

		render.DrawSprite( LightPos, Size, Size, Col )
		render.DrawSprite( LightPos, Size * 0.4, Size * 0.4, Color( 255, 255, 255, Alpha ) )

	end

end

-- We have to do this to ensure DrawTranslucent is called for Opaque only models to draw our effects
ENT.RenderGroup = RENDERGROUP_BOTH
function ENT:DrawTranslucent( flags )
	BaseClass.DrawTranslucent( self, flags )
	self:DrawEffects()
end

