
AddCSLuaFile()
DEFINE_BASECLASS( "base_gmodentity" )

ENT.Spawnable = false
ENT.RenderGroup = RENDERGROUP_BOTH

local matLight = Material( "sprites/light_ignorez" )
local MODEL = Model( "models/maxofs2d/light_tubular.mdl" )

--
-- Set up our data table
--
function ENT:SetupDataTables()

	self:NetworkVar( "Bool", 0, "On" )
	self:NetworkVar( "Bool", 1, "Toggle" )
	self:NetworkVar( "Float", 1, "LightSize" )
	self:NetworkVar( "Float", 2, "Brightness" )

end

function ENT:Initialize()

	if ( CLIENT ) then

		self.PixVis = util.GetPixelVisibleHandle()

	end

	if ( SERVER ) then --lights are rolling around even though the model isn't round!!

		self:SetModel( MODEL )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:DrawShadow( false )

		local phys = self:GetPhysicsObject()

		if ( IsValid( phys ) ) then
			phys:Wake()
		end

	end

end

function ENT:Draw()

	BaseClass.Draw( self, true )

end

function ENT:Think()

	self.BaseClass.Think( self )

	if ( CLIENT ) then

		if ( !self:GetOn() ) then return end

		local dlight = DynamicLight( self:EntIndex() )

		if ( dlight ) then

			local c = self:GetColor()

			dlight.Pos = self:GetPos()
			dlight.r = c.r
			dlight.g = c.g
			dlight.b = c.b
			dlight.Brightness = self:GetBrightness()
			dlight.Decay = self:GetLightSize() * 5
			dlight.Size = self:GetLightSize()
			dlight.DieTime = CurTime() + 1

		end

	end

end

function ENT:DrawTranslucent()

	BaseClass.DrawTranslucent( self, true )

	local up = self:GetAngles():Up()

	local LightPos = self:GetPos()
	render.SetMaterial( matLight )

	local ViewNormal = self:GetPos() - EyePos()
	local Distance = ViewNormal:Length()
	ViewNormal:Normalize()

	local Visibile	= util.PixelVisible( LightPos, 4, self.PixVis )

	if ( !Visibile || Visibile < 0.1 ) then return end

	if ( !self:GetOn() ) then return end

	local c = self:GetColor()
	local Alpha = 255 * Visibile

	render.DrawSprite( LightPos - up * 2, 8, 8, Color(255, 255, 255, Alpha), Visibile )
	render.DrawSprite( LightPos - up * 4, 8, 8, Color(255, 255, 255, Alpha), Visibile )
	render.DrawSprite( LightPos - up * 6, 8, 8, Color(255, 255, 255, Alpha), Visibile )
	render.DrawSprite( LightPos - up * 5, 64, 64, Color( c.r, c.g, c.b, 64 ), Visibile )

end

function ENT:GetOverlayText()

	return self:GetPlayerName()

end

function ENT:OnTakeDamage( dmginfo )
	self:TakePhysicsDamage( dmginfo )
end

function ENT:Toggle()

	self:SetOn( !self:GetOn() )

end
