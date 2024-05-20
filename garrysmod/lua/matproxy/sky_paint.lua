
matproxy.Add( {
	name = "SkyPaint",

	init = function( self, mat, values )
	end,

	bind = function( self, mat, ent )

		local skyPaint = g_SkyPaint
<<<<<<< HEAD
	
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
=======
		if ( !IsValid( skyPaint ) ) then return end

		local values = skyPaint:GetNetworkVars()

		mat:SetVector( "$TOPCOLOR",		values.TopColor )
		mat:SetVector( "$BOTTOMCOLOR",	values.BottomColor )
		mat:SetVector( "$DUSKCOLOR",	values.DuskColor )
		mat:SetFloat( "$DUSKSCALE",		values.DuskScale )
		mat:SetFloat( "$DUSKINTENSITY",	values.DuskIntensity )
		mat:SetFloat( "$FADEBIAS",		values.FadeBias )
		mat:SetFloat( "$HDRSCALE",		values.HDRScale )

		mat:SetVector( "$SUNNORMAL",	values.SunNormal )
		mat:SetVector( "$SUNCOLOR",		values.SunColor )
		mat:SetFloat( "$SUNSIZE",		values.SunSize )

		if ( values.DrawStars ) then

			mat:SetInt( "$STARLAYERS",		values.StarLayers )
			mat:SetFloat( "$STARSCALE",		values.StarScale )
			mat:SetFloat( "$STARFADE",		values.StarFade )
			mat:SetFloat( "$STARPOS",		values.StarSpeed * RealTime() )
			mat:SetTexture( "$STARTEXTURE",	values.StarTexture )
>>>>>>> upstream/master

		else

			mat:SetInt( "$STARLAYERS", 0 )

		end

	end
} )
