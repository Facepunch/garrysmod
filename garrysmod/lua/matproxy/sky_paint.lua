
matproxy.Add( {
	name = "SkyPaint",

	init = function( self, mat, values )
	end,

	bind = function( self, mat, ent )

		local skyPaint = g_SkyPaint
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

		else

			mat:SetInt( "$STARLAYERS", 0 )

		end

	end
} )
