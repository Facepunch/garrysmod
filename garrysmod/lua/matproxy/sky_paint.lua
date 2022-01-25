
matproxy.Add( {
	name = "SkyPaint",

	init = function( self, mat, values )
	end,

	bind = function( self, mat, ent )

		if ( !IsValid( g_SkyPaint ) ) then return end

		mat:SetVector( "$TOPCOLOR",		g_SkyPaint:GetTopColor() )
		mat:SetVector( "$BOTTOMCOLOR",	g_SkyPaint:GetBottomColor() )
		mat:SetVector( "$SUNNORMAL",	g_SkyPaint:GetSunNormal() )
		mat:SetVector( "$SUNCOLOR",		g_SkyPaint:GetSunColor() )
		mat:SetVector( "$DUSKCOLOR",	g_SkyPaint:GetDuskColor() )
		mat:SetFloat( "$FADEBIAS",		g_SkyPaint:GetFadeBias() )
		mat:SetFloat( "$HDRSCALE",		g_SkyPaint:GetHDRScale() )
		mat:SetFloat( "$DUSKSCALE",		g_SkyPaint:GetDuskScale() )
		mat:SetFloat( "$DUSKINTENSITY",	g_SkyPaint:GetDuskIntensity() )
		mat:SetFloat( "$SUNSIZE",		g_SkyPaint:GetSunSize() )

		if ( g_SkyPaint:GetDrawStars() ) then

			mat:SetInt( "$STARLAYERS",		g_SkyPaint:GetStarLayers() )
			mat:SetFloat( "$STARSCALE",		g_SkyPaint:GetStarScale() )
			mat:SetFloat( "$STARFADE",		g_SkyPaint:GetStarFade() )
			mat:SetFloat( "$STARPOS",		RealTime() * g_SkyPaint:GetStarSpeed() )
			mat:SetTexture( "$STARTEXTURE",	g_SkyPaint:GetStarTexture() )

		else

			mat:SetInt( "$STARLAYERS", 0 )

		end

	end
} )
