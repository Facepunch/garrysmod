
module( "halo", package.seeall )

local matColor	= Material( "model_color" )
local mat_Copy	= Material( "pp/copy" )
local mat_Add	= Material( "pp/add" )
local mat_Sub	= Material( "pp/sub" )
local rt_Stencil	= render.GetBloomTex0()
local rt_Store		= render.GetScreenEffectTexture( 0 )

local List = {}

function Add( ents, color, blurx, blury, passes, add, ignorez )

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
		IgnoreZ = ignorez
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
		
	
	-- FILL STENCIL
	-- Write to the stencil..		
	cam.Start3D( EyePos(), EyeAngles() )
	
		cam.IgnoreZ( entry.IgnoreZ )
		render.OverrideDepthEnable( true, false )									-- Don't write depth
		
		render.SetStencilEnable( true )
		render.SetStencilFailOperation( STENCILOPERATION_KEEP )
		render.SetStencilZFailOperation( STENCILOPERATION_KEEP )
		render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
		render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS )
		render.SetStencilWriteMask( 1 )
		render.SetStencilReferenceValue( 1 )
		
		render.SetBlend( 0 ) -- don't render any colour
		
		for k, v in pairs( entry.Ents ) do
		
			if ( !IsValid( v ) ) then continue end
			
			v:DrawModel()

		end
			
	cam.End3D()	
	
	-- FILL COLOUR
	-- Write to the colour buffer
	cam.Start3D( EyePos(), EyeAngles() )

		render.MaterialOverride( matColor )
		cam.IgnoreZ( entry.IgnoreZ )
		
		render.SetStencilEnable( true )
		render.SetStencilWriteMask( 0 )
		render.SetStencilReferenceValue( 0 )
		render.SetStencilTestMask( 1 )
		render.SetStencilFailOperation( STENCILOPERATION_KEEP )
		render.SetStencilPassOperation( STENCILOPERATION_KEEP )
		render.SetStencilZFailOperation( STENCILOPERATION_KEEP )
		render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NOTEQUAL )
		
		for k, v in pairs( entry.Ents ) do
			
			if ( !IsValid( v ) ) then continue end
			
			render.SetColorModulation( entry.Color.r/255, entry.Color.g/255, entry.Color.b/255 )
			render.SetBlend( entry.Color.a/255 )

			v:DrawModel()
			
		end
			
		render.MaterialOverride( nil )
		render.SetStencilEnable( false )

	cam.End3D()
	
	-- BLUR IT
		render.CopyRenderTargetToTexture( rt_Stencil )
		render.OverrideDepthEnable( false, false )
		render.SetStencilEnable( false )
		render.BlurRenderTarget( rt_Stencil, entry.BlurX, entry.BlurY, 1 )
	
	-- Put our scene back
		render.SetRenderTarget( OldRT )
		render.SetColorModulation( 1, 1, 1 )
		render.SetStencilEnable( false )
		render.OverrideDepthEnable( true, false )
		render.SetBlend( 1 )
		mat_Copy:SetTexture( "$basetexture", rt_Store )
		render.SetMaterial( mat_Copy )
		render.DrawScreenQuad()
		
	
	-- DRAW IT TO THE SCEEN

		render.SetStencilEnable( true )
		render.SetStencilWriteMask( 0 )
		render.SetStencilReferenceValue( 0 )
		render.SetStencilTestMask( 1 )
		render.SetStencilFailOperation( STENCILOPERATION_KEEP )
		render.SetStencilPassOperation( STENCILOPERATION_KEEP )
		render.SetStencilZFailOperation( STENCILOPERATION_KEEP )
		render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
		    
		if ( entry.Additive ) then	
			mat_Add:SetTexture( "$basetexture", rt_Stencil )
			render.SetMaterial( mat_Add )
		else
			mat_Sub:SetTexture( "$basetexture", rt_Stencil )
			render.SetMaterial( mat_Sub )
		end
		
		for i=0, entry.DrawPasses do
			render.DrawScreenQuad()
		end
	
	-- PUT EVERYTHING BACK HOW WE FOUND IT

		render.SetStencilWriteMask( 0 )
		render.SetStencilReferenceValue( 0 )
		render.SetStencilTestMask( 0 )
		render.SetStencilEnable( false )
		render.OverrideDepthEnable( false )
		render.SetBlend( 1 )
		
		cam.IgnoreZ( false )

end

hook.Add( "PostDrawEffects", "RenderHalos", function()

	hook.Run( "PreDrawHalos" )

	if ( #List == 0 ) then return end
	
	for k, v in pairs( List ) do
		Render( v )
	end
		
	List = {}
	
end )
