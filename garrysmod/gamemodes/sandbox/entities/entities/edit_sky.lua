
AddCSLuaFile()
DEFINE_BASECLASS( "base_edit" )

ENT.Spawnable = true
ENT.AdminOnly = true

ENT.PrintName = "Sky Editor"
ENT.Category = "Editors"

function ENT:Initialize()

	BaseClass.Initialize( self )
	self:SetMaterial( "gmod/edit_sky" )

	--
	-- Over-ride the sky controller with this.
	--
	if ( CLIENT ) then

		if ( IsValid( g_SkyPaint ) ) then

			-- A bit of a hack
			self:EditValue( "topcolor", tostring( g_SkyPaint:GetTopColor() ) )
			self:EditValue( "bottomcolor", tostring( g_SkyPaint:GetBottomColor() ) )
			self:EditValue( "fadebias", tostring( g_SkyPaint:GetFadeBias() ) )
			self:EditValue( "hdrscale", tostring( g_SkyPaint:GetHDRScale() ) )

			self:EditValue( "starlayers", tostring( g_SkyPaint:GetStarLayers() ) )
			self:EditValue( "drawstars", tostring( g_SkyPaint:GetDrawStars() and 1 or 0 ) )
			self:EditValue( "startexture", g_SkyPaint:GetStarTexture() )
			self:EditValue( "starspeed", tostring( g_SkyPaint:GetStarSpeed() ) )
			self:EditValue( "starfade", tostring( g_SkyPaint:GetStarFade() ) )
			self:EditValue( "starscale", tostring( g_SkyPaint:GetStarScale() ) )

			self:EditValue( "duskintensity", tostring( g_SkyPaint:GetDuskIntensity() ) )
			self:EditValue( "duskscale", tostring( g_SkyPaint:GetDuskScale() ) )
			self:EditValue( "duskcolor", tostring( g_SkyPaint:GetDuskColor() ) )

			self:EditValue( "sunsize", tostring( g_SkyPaint:GetSunSize() ) )
			self:EditValue( "suncolor", tostring( g_SkyPaint:GetSunColor() ) )

		end

		g_SkyPaint = self

	end

end

function ENT:Think()

	--
	-- Find an env_sun - if we don't already have one.
	--
	if ( SERVER and self.EnvSun == nil ) then

		-- so this closure only gets called once - even if it fails
		self.EnvSun = false

		local list = ents.FindByClass( "env_sun" )
		if ( #list > 0 ) then
			self.EnvSun = list[ 1 ]
		end

	end

	--
	-- If we have a sun - force our sun normal to its value
	--
	if ( SERVER and IsValid( self.EnvSun ) ) then

		local vec = self.EnvSun:GetInternalVariable( "m_vDirection" )

		if ( isvector( vec ) ) then
			self:SetSunNormal( vec )
		end

	end

end

--
-- This needs to be a 1:1 copy of env_skypaint
--
function ENT:SetupDataTables()

	local SetupDataTables = scripted_ents.GetMember( "env_skypaint", "SetupDataTables" )
	SetupDataTables( self )

end

--
-- This edits something global - so always network - even when not in PVS
--
function ENT:UpdateTransmitState()

	return TRANSMIT_ALWAYS

end
