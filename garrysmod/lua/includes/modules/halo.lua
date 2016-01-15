
module( "halo", package.seeall )

local matColor	= Material( "model_color" )
local mat_Copy	= Material( "pp/copy" )
local mat_Add	= Material( "pp/add" )
local mat_Sub	= Material( "pp/sub" )
local rt_Stencil	= render.GetBloomTex0()
local rt_Store		= render.GetScreenEffectTexture( 0 )

local List = {}

function Add( ents, color, blurx, blury, passes, add, ignorez, suppresslighting )

	if ( add == nil ) then add = true end
	if ( ignorez == nil ) then ignorez = false end

	local t =
	{
		Ents = ents,
		Color = color,
		Hidden = when_hidden,
		BlurX = blurx or 2,
		BlurY = blury or 2,
		DrawPasses = passes or 1,
		Additive = add,
		IgnoreZ = ignorez,
		SuppressLighting = suppresslighting or true
	}

	table.insert( List, t )

end

function Render( entry )

	local OldRT = render.GetRenderTarget()

	-- Copy what's currently on the screen to another texture
	render.CopyRenderTargetToTexture( rt_Store )

	-- Clear the colour and the stencils, not the depth
	if ( entry.Additive ) then
		render.Clear( 0, 0, 0, 255, false, true )
	else
		render.Clear( 255, 255, 255, 255, false, true )
	end


	-- Write to the stencil
	render.SetStencilEnable( true )

		cam.IgnoreZ( entry.IgnoreZ )

			render.SetStencilWriteMask( 1 )
			render.SetStencilTestMask( 1 )
			render.SetStencilReferenceValue( 1 )

			render.SetStencilCompareFunction( STENCIL_ALWAYS )
			render.SetStencilPassOperation( STENCIL_REPLACE )
			render.SetStencilFailOperation( STENCIL_KEEP )
			render.SetStencilZFailOperation( STENCIL_KEEP )
			
			if v.SuppressLighting then
				render.SuppressEngineLighting(true)
			end
				for k, v in pairs( entry.Ents ) do
			
					if ( !IsValid( v ) ) then continue end
			
					RenderEnt = v
			
					v:DrawModel()
			
				end
				
					RenderEnt = NULL
			if v.SuppressLighting then
				render.SuppressEngineLighting(false)
			end
			
			render.SetStencilCompareFunction( STENCIL_EQUAL )
			render.SetStencilPassOperation( STENCIL_KEEP )
			render.SetStencilFailOperation( STENCIL_KEEP )
			render.SetStencilZFailOperation( STENCIL_KEEP )

				render.MaterialOverride( matColor )

				local r, g, b, a =	entry.Color.r / 255,
									entry.Color.g / 255,
									entry.Color.b / 255,
									entry.Color.a / 255

				for k, v in pairs( entry.Ents ) do

					if ( !IsValid( v ) ) then continue end

					render.SetColorModulation( r, g, b )
					render.SetBlend( a )

					v:DrawModel()

				end

				render.SetColorModulation( 1, 1, 1 )

				render.MaterialOverride( nil )

		cam.IgnoreZ( false )

	render.SetStencilEnable( false )


	-- Copy stencil to rt and blur it
	render.CopyRenderTargetToTexture( rt_Stencil )
	render.BlurRenderTarget( rt_Stencil, entry.BlurX, entry.BlurY, 1 )

	-- Re-render stored scene
	render.SetRenderTarget( OldRT )
	mat_Copy:SetTexture( "$basetexture", rt_Store )
	render.SetMaterial( mat_Copy )
	render.DrawScreenQuad()


	-- Draw halos to the screen!
	render.SetStencilEnable( true )

		render.SetStencilCompareFunction( STENCIL_NOTEQUAL )
		render.SetStencilPassOperation( STENCIL_KEEP )
		render.SetStencilFailOperation( STENCIL_KEEP )
		render.SetStencilZFailOperation( STENCIL_KEEP )

			if ( entry.Additive ) then

				mat_Add:SetTexture( "$basetexture", rt_Stencil )
				render.SetMaterial( mat_Add )

			else

				mat_Sub:SetTexture( "$basetexture", rt_Stencil )
				render.SetMaterial( mat_Sub )

			end

			for i = 0, entry.DrawPasses do

				render.DrawScreenQuad()

			end

	render.SetStencilEnable( false )


	render.SetStencilWriteMask( 0 )
	render.SetStencilReferenceValue( 0 )
	render.SetStencilTestMask( 0 )
end

hook.Add( "PostDrawEffects", "RenderHalos", function()

	hook.Run( "PreDrawHalos" )

	if ( #List == 0 ) then return end

	cam.Start3D()

		for k, v in pairs( List ) do
			Render( v )
		end

	cam.End3D()

	List = {}

end )
