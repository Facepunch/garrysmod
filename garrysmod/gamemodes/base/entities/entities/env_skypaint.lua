
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

	self:NetworkVar( "Int", 0, "StarLayers", { KeyName = "starlayers", Edit = { type = "Int", min = 1, max = 3, category = "Stars", order = 12 } } )
	self:NetworkVarElement( "Angle", 0, 'p', "StarScale", { KeyName = "starscale", Edit = { type = "Float", min = 0, max = 5, category = "Stars", order = 13 } } )
	self:NetworkVarElement( "Angle", 0, 'y', "StarFade", { KeyName = "starfade", Edit = { type = "Float", min = 0, max = 5, category = "Stars", order = 14 } } )
	self:NetworkVarElement( "Angle", 0, 'r', "StarSpeed", { KeyName = "starspeed", Edit = { type = "Float", min = 0, max = 2, category = "Stars", order = 15 } } )

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
		self:SetStarLayers( 1 )
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

if ( SERVER ) then

	function ENT:AcceptInput( name, activator, caller, data )

		-- Ensure all inputs are prefixed with "Set"
		if ( name:sub(1, 3):lower() == "set" ) then

			name = name:sub(4, -1):lower()

			-- Tokenize on whitespace
			local tokens = {}

			for token in data:gmatch("%S+") do
				table.insert(tokens, token)
			end

			if ( #tokens == 3 ) then -- Three tokens: either three floats or three strings

				local s1, s2, s3 = tonumber(tokens[1]), tonumber(tokens[2]), tonumber(tokens[3])

				if ( isnumber(s1) && isnumber(s2) && isnumber(s3) ) then

					-- Interpreted as a Color/Vector
					local vec = Vector(tonumber(s1), tonumber(s2), tonumber(s3))

					if ( name:sub(-3) == "255" ) then -- Interpret Vector inputs suffixed with "255" as color255
						self:SetNetworkKeyValue(name:sub(1, -4), vec / 255)
					else -- Interpret as color1
						self:SetNetworkKeyValue(name, vec)
					end

				end

			--[[
			elseif ( #tokens == 1 ) then
				-- Single token: either float or string (does not necessitate conversion)
				local s = tokens[1]
				self:SetNetworkKeyValue(name, s)
			--]]

			else

				-- 0 tokens, 1 token, 2 tokens, 4+ tokens, etc.
				self:SetNetworkKeyValue(name, data)

			end

		end

	end

end

function ENT:Think()

	--
	-- Find an env_sun - if we don't already have one.
	--
	if ( SERVER && self.EnvSun == nil ) then

		-- so this closure only gets called once - even if it fails
		self.EnvSun = false

		local sunlist = ents.FindByClass( "env_sun" )
		if ( #sunlist > 0 ) then
			self.EnvSun = sunlist[1]
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
	if ( CLIENT && g_SkyPaint != self && !IsValid( g_SkyPaint ) ) then

		g_SkyPaint = self

	end

end

--
-- To prevent server insanity - only let admins edit the sky.
--
function ENT:CanEditVariables( ply )

	return ply:IsAdmin() || game.SinglePlayer()

end
