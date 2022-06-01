
matproxy.Add( {
	name = "SkyPaint",

	init = function( self, mat, values )
	end,

	bind = function( self, mat, ent )

		local skyPaint = g_SkyPaint
	
		if ( !IsValid( skyPaint ) ) then return end

		mat:SetVector( "$TOPCOLOR",		skyPaint:GetTopColor() )
		mat:SetVector( "$BOTTOMCOLOR",	skyPaint:GetBottomColor() )
		mat:SetVector( "$SUNNORMAL",	skyPaint:GetSunNormal() )
		mat:SetVector( "$SUNCOLOR",		skyPaint:GetSunColor() )
		mat:SetVector( "$DUSKCOLOR",	skyPaint:GetDuskColor() )
		mat:SetFloat( "$FADEBIAS",		skyPaint:GetFadeBias() )
		mat:SetFloat( "$HDRSCALE",		skyPaint:GetHDRScale() )
		mat:SetFloat( "$DUSKSCALE",		skyPaint:GetDuskScale() )
		mat:SetFloat( "$DUSKINTENSITY",	skyPaint:GetDuskIntensity() )
		mat:SetFloat( "$SUNSIZE",		skyPaint:GetSunSize() )

		if ( skyPaint:GetDrawStars() ) then

			mat:SetInt( "$STARLAYERS",		skyPaint:GetStarLayers() )
			mat:SetFloat( "$STARSCALE",		skyPaint:GetStarScale() )
			mat:SetFloat( "$STARFADE",		skyPaint:GetStarFade() )
			mat:SetFloat( "$STARPOS",		RealTime() * skyPaint:GetStarSpeed() )
			mat:SetTexture( "$STARTEXTURE",	skyPaint:GetStarTexture() )

		else

			mat:SetInt( "$STARLAYERS", 0 )

		end

	end
} )
