
AddCSLuaFile()
DEFINE_BASECLASS( "base_gmodentity" )

ENT.PrintName = "Light"
ENT.Editable = true

local MODEL = Model( "models/maxofs2d/light_tubular.mdl" )

--
-- Set up our data table
--
function ENT:SetupDataTables()

	self:NetworkVar( "Bool", 0, "On", { KeyName = "on", Edit = { type = "Boolean", order = 1, title = "#entedit.enabled" } } )
	self:NetworkVar( "Bool", 1, "Toggle", { KeyName = "tg", Edit = { type = "Boolean", order = 2, title = "#tool.light.toggle" } } )
	self:NetworkVar( "Float", 1, "LightSize", { KeyName = "sz", Edit = { type = "Float", order = 3, min = 0, max = 1024, title = "#tool.light.size" } } )
	self:NetworkVar( "Float", 2, "Brightness", { KeyName = "br", Edit = { type = "Int", order = 4, min = 0, max = 6, title = "#tool.light.brightness" } } )

	self:NetworkVar( "Bool", 2, "LightWorld", { KeyName = "world", Edit = { type = "Boolean", order = 5, title = "#tool.light.noworld", category = "#entedit.advanced" } } )
	self:NetworkVar( "Bool", 3, "LightModels", { KeyName = "models", Edit = { type = "Boolean", order = 6, title = "#tool.light.nomodels", category = "#entedit.advanced" } } )

end

function ENT:Initialize()

	if ( CLIENT ) then

		self.dlight = DynamicLight( self:EntIndex() )
		self.PixVis = util.GetPixelVisibleHandle()

	end

	if ( SERVER ) then -- Lights are rolling around even though the model isn't round!!

		self:SetModel( MODEL )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:DrawShadow( false )

		local phys = self:GetPhysicsObject()
		if ( IsValid( phys ) ) then phys:Wake() end

	end

end

function ENT:OnTakeDamage( dmginfo )
	-- React to physics damage
	self:TakePhysicsDamage( dmginfo )
end

function ENT:Toggle()
	self:SetOn( !self:GetOn() )
end

function ENT:Think()

	self.BaseClass.Think( self )

	if ( CLIENT ) then

		if ( not self:GetOn() ) then return end

		local dlight = self.dlight
		if ( not dlight ) then return end

		dlight.pos = self:GetPos()
		dlight.r, dlight.g, dlight.b = self:GetColor4Part()

		local size = self:GetLightSize()
		local brght = self:GetBrightness()

		-- Clamp for multiplayer
		if ( not game.SinglePlayer() ) then
			size = math.Clamp( size, 0, 1024 )
			brght = math.Clamp( brght, 0, 6 )
		end

		dlight.size = size
		dlight.decay = size * 5
		dlight.brightness = brght

		dlight.dietime = CurTime() + 1
		dlight.noworld = self:GetLightWorld()
		dlight.nomodel = self:GetLightModels()
	end

end

function ENT:GetOverlayText()
	return self:GetPlayerName()
end

local matLight = Material( "sprites/light_ignorez" )
local colLight, vecLight = Color( 255, 255, 255, 255 ), Vector( 0, 0, 0 )
function ENT:DrawEffects()

	if ( not self:GetOn() ) then return end

	local LightPos = self:GetPos()

	local Visibile = util.PixelVisible( LightPos, 4, self.PixVis )
	if ( not Visibile or Visibile < 0.1 ) then return end

	render.SetMaterial( matLight )

	local Alpha = 255 * Visibile
	colLight:SetUnpacked( 255, 255, 255, Alpha )

	local up = self:GetUp()
	for shift = -6, -2, 2 do
		vecLight:Set( up )
		vecLight:Mul( shift )
		vecLight:Add( LightPos )
		
		render.DrawSprite( vecLight, 8, 8, colLight )
	end

	local r, g, b = self:GetColor4Part()
	colLight:SetUnpacked( r, g, b, 64 )

	vecLight:Set( up )
	vecLight:Mul( -5 )
	vecLight:Add( LightPos )

	render.DrawSprite( vecLight, 64, 64, colLight )

end

ENT.WantsTranslucency = true -- If model is opaque, still call DrawTranslucent
function ENT:DrawTranslucent( flags )
	BaseClass.DrawTranslucent( self, flags )
	self:DrawEffects()
end
