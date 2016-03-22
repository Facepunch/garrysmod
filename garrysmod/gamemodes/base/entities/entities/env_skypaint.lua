
AddCSLuaFile()

ENT.Type = "point"
ENT.DisableDuplicator = true

--
-- Make this entity always networked
--
function ENT:UpdateTransmitState() return TRANSMIT_ALWAYS end

--
-- Networked / Saved Data
--
function ENT:SetupDataTables()

	self:NetworkVar( "Vector", 0, "TopColor", { KeyName = "topcolor", Edit = { type = "VectorColor", category = "Main", order = 1 } } )
	self:NetworkVar( "Vector", 1, "BottomColor", { KeyName = "bottomcolor", Edit = { type = "VectorColor", category = "Main", title = "Color Bottom", order = 2 } } )
	self:NetworkVar( "Float", 0, "FadeBias", { KeyName = "fadebias", Edit = { type = "Float", category = "Main", min = 0, max = 1, order = 3 } } )

	self:NetworkVar( "Float", 4, "SunSize", { KeyName = "sunsize", Edit = { type = "Float", min = 0, max = 10, category = "Sun" } } )
	self:NetworkVar( "Vector", 2, "SunNormal", { KeyName = "sunnormal" } ) -- No editing this - it's for coders only
	self:NetworkVar( "Vector", 3, "SunColor", { KeyName = "suncolor", Edit = { type = "VectorColor", category = "Sun" } } )

	self:NetworkVar( "Float", 2, "DuskScale", { KeyName = "duskscale", Edit = { type = "Float", min = 0, max = 1, category = "Dusk" } } )
	self:NetworkVar( "Float", 3, "DuskIntensity", { KeyName = "duskintensity", Edit = { type = "Float", min = 0, max = 10, category = "Dusk" } } )
	self:NetworkVar( "Vector", 4, "DuskColor", { KeyName = "duskcolor", Edit = { type = "VectorColor", category = "Dusk" } } )

	self:NetworkVar( "Bool", 0, "DrawStars", { KeyName = "drawstars", Edit = { type = "Boolean", category = "Stars", order = 10 } } )
	self:NetworkVar( "String", 0, "StarTexture", { KeyName = "startexture", Edit = { type = "Texture", group = "Stars", category = "Stars", order = 11 } } )

	self:NetworkVarElement( "Angle", 0, 'p', "StarScale", { KeyName = "starscale", Edit = { type = "Float", min = 0, max = 5, category = "Stars", order = 12 } } )
	self:NetworkVarElement( "Angle", 0, 'y', "StarFade", { KeyName = "starfade", Edit = { type = "Float", min = 0, max = 5, category = "Stars", order = 13 } } )
	self:NetworkVarElement( "Angle", 0, 'r', "StarSpeed", { KeyName = "starspeed", Edit = { type = "Float", min = 0, max = 5, category = "Stars", order = 14 } } )

	self:NetworkVar( "Float", 1, "HDRScale", { KeyName = "hdrscale", Edit = { type = "Float", category = "Main", min = 0, max = 1, order = 4 } } )

	--
	-- Entity defaults
	--
	if ( SERVER ) then

		self:SetTopColor( Vector( 0.2, 0.5, 1.0 ) )
		self:SetBottomColor( Vector( 0.8, 1.0, 1.0 ) )
		self:SetFadeBias( 1 )


		self:SetSunNormal( Vector( 0.4, 0.0, 0.01 ) )
		self:SetSunColor( Vector( 0.2, 0.1, 0.0 ) )
		self:SetSunSize( 2.0 )

		self:SetDuskColor( Vector( 1.0, 0.2, 0.0 ) )
		self:SetDuskScale( 1 )
		self:SetDuskIntensity( 1 )

		self:SetDrawStars( true )
		self:SetStarSpeed( 0.01 )
		self:SetStarScale( 0.5 )
		self:SetStarFade( 1.5 )
		self:SetStarTexture( "skybox/starfield" )

		self:SetHDRScale( 0.66 )

	end

end

function ENT:Initialize()
end

function ENT:KeyValue( key, value )

	if ( self:SetNetworkKeyValue( key, value ) ) then
		return
	end

	-- TODO: sunposmethod
	-- 		0 : "Custom - Use the Sun Normal to position the sun"
	--		1 : "Automatic - Find a env_sun entity and use that"

end

function ENT:Think()

	--
	-- Find an env_sun - if we don't already have one.
	--
	if ( SERVER && self.EnvSun == nil ) then

		-- so this closure only gets called once - even if it fails
		self.EnvSun = false

		local list = ents.FindByClass( "env_sun" )
		if ( #list > 0 ) then
			self.EnvSun = list[1]
		end

	end

	--
	-- If we have a sun - force our sun normal to its value
	--
	if ( SERVER && IsValid( self.EnvSun ) ) then

		local vec = self.EnvSun:GetInternalVariable( "m_vDirection" )

		if ( isvector( vec ) ) then
			self:SetSunNormal( vec )
		end

	end

	--
	-- Become the active sky again if we're not already
	--
	if ( CLIENT && g_SkyPaint != self ) then

		if ( !IsValid( g_SkyPaint ) ) then
			g_SkyPaint = self
		end

	end

end

--
-- To prevent server insanity - only let admins edit the sky.
--
function ENT:CanEditVariables( ply )

	return ply:IsAdmin()

end
