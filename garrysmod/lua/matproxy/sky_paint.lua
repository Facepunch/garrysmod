
matproxy.Add( {
	name = "SkyPaint",

	init = function( self, mat, values )
	end,

	bind = function( self, mat, ent )

		if ( !IsValid( g_SkyPaint ) ) then return end

		local eSkyPaint = g_SkyPaint
		mat:SetVector( "$TOPCOLOR",		eSkyPaint:GetTopColor() )
		mat:SetVector( "$BOTTOMCOLOR",	eSkyPaint:GetBottomColor() )
		mat:SetVector( "$SUNNORMAL",	eSkyPaint:GetSunNormal() )
		mat:SetVector( "$SUNCOLOR",		eSkyPaint:GetSunColor() )
		mat:SetVector( "$DUSKCOLOR",	eSkyPaint:GetDuskColor() )
		mat:SetFloat( "$FADEBIAS",		eSkyPaint:GetFadeBias() )
		mat:SetFloat( "$HDRSCALE",		eSkyPaint:GetHDRScale() )
		mat:SetFloat( "$DUSKSCALE",		eSkyPaint:GetDuskScale() )
		mat:SetFloat( "$DUSKINTENSITY",	eSkyPaint:GetDuskIntensity() )
		mat:SetFloat( "$SUNSIZE",		eSkyPaint:GetSunSize() )

		if ( eSkyPaint:GetDrawStars() ) then

			mat:SetInt( "$STARLAYERS",		eSkyPaint:GetStarLayers() )
			mat:SetFloat( "$STARSCALE",		eSkyPaint:GetStarScale() )
			mat:SetFloat( "$STARFADE",		eSkyPaint:GetStarFade() )
			mat:SetFloat( "$STARPOS",		RealTime() * eSkyPaint:GetStarSpeed() )
			mat:SetTexture( "$STARTEXTURE",	eSkyPaint:GetStarTexture() )

		else

			mat:SetInt( "$STARLAYERS", 0 )

		end

	end
} )
