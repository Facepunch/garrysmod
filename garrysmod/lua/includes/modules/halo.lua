
module( "halo", package.seeall )

local mat_Copy		= Material( "pp/copy" )
local mat_Add		= Material( "pp/add" )
local mat_Sub		= Material( "pp/sub" )
local rt_Store		= render.GetScreenEffectTexture( 0 )
local rt_Blur		= render.GetScreenEffectTexture( 1 )

local List = {}
local RenderEnt = NULL

function Add( entities, color, blurx, blury, passes, add, ignorez )

	if ( table.IsEmpty( entities ) ) then return end
	if ( add == nil ) then add = true end
	if ( ignorez == nil ) then ignorez = false end

	local t =
	{
		Ents = entities,
		Color = color,
		Hidden = when_hidden,
		BlurX = blurx or 2,
		BlurY = blury or 2,
		DrawPasses = passes or 1,
		Additive = add,
		IgnoreZ = ignorez
	}

	table.insert( List, t )

end

function RenderedEntity()
	return RenderEnt
end

function Render( entry )

	local rt_Scene = render.GetRenderTarget()


	-- Store a copy of the original scene
	render.CopyRenderTargetToTexture( rt_Store )


	-- Clear our scene so that additive/subtractive rendering with it will work later
	if ( entry.Additive ) then
		render.Clear( 0, 0, 0, 255, false, true )
	else
		render.Clear( 255, 255, 255, 255, false, true )
	end


	-- Render colored props to the scene and set their pixels high
	cam.Start3D()
		render.SetStencilEnable( true )
			render.SuppressEngineLighting(true)
			cam.IgnoreZ( entry.IgnoreZ )

				render.SetStencilWriteMask( 1 )
				render.SetStencilTestMask( 1 )
				render.SetStencilReferenceValue( 1 )

				render.SetStencilCompareFunction( STENCIL_ALWAYS )
				render.SetStencilPassOperation( STENCIL_REPLACE )
				render.SetStencilFailOperation( STENCIL_KEEP )
				render.SetStencilZFailOperation( STENCIL_KEEP )

				
					for k, v in pairs( entry.Ents ) do

						if ( !IsValid( v ) ) then continue end

						RenderEnt = v

						v:DrawModel()

					end

					RenderEnt = NULL

				render.SetStencilCompareFunction( STENCIL_EQUAL )
				render.SetStencilPassOperation( STENCIL_KEEP )
				-- render.SetStencilFailOperation( STENCIL_KEEP )
				-- render.SetStencilZFailOperation( STENCIL_KEEP )

					cam.Start2D()
						surface.SetDrawColor( entry.Color )
						surface.DrawRect( 0, 0, ScrW(), ScrH() )
					cam.End2D()

			cam.IgnoreZ( false )
			render.SuppressEngineLighting(false)
		render.SetStencilEnable( false )
	cam.End3D()


	-- Store a blurred version of the colored props in an RT
	render.CopyRenderTargetToTexture( rt_Blur )
	render.BlurRenderTarget( rt_Blur, entry.BlurX, entry.BlurY, 1 )


	-- Restore the original scene
	render.SetRenderTarget( rt_Scene )
	mat_Copy:SetTexture( "$basetexture", rt_Store )
	render.SetMaterial( mat_Copy )
	render.DrawScreenQuad()


	-- Draw back our blured colored props additively/subtractively, ignoring the high bits
	render.SetStencilEnable( true )

		render.SetStencilCompareFunction( STENCIL_NOTEQUAL )
		-- render.SetStencilPassOperation( STENCIL_KEEP )
		-- render.SetStencilFailOperation( STENCIL_KEEP )
		-- render.SetStencilZFailOperation( STENCIL_KEEP )

			if ( entry.Additive ) then

				mat_Add:SetTexture( "$basetexture", rt_Blur )
				render.SetMaterial( mat_Add )

			else

				mat_Sub:SetTexture( "$basetexture", rt_Blur )
				render.SetMaterial( mat_Sub )

			end

			for i = 0, entry.DrawPasses do

				render.DrawScreenQuad()

			end

	render.SetStencilEnable( false )


	-- Return original values
	render.SetStencilTestMask( 0 )
	render.SetStencilWriteMask( 0 )
	render.SetStencilReferenceValue( 0 )
end

hook.Add( "PostDrawEffects", "RenderHalos", function()

	hook.Run( "PreDrawHalos" )

	if ( #List == 0 ) then return end

	for k, v in ipairs( List ) do
		Render( v )
	end

	List = {}

end )
