
local mat_Downsample = Material( "pp/downsample" )
mat_Downsample:SetTexture( "$fbtexture", render.GetScreenEffectTexture() )

local mat_Bloom = Material( "pp/bloom" )
local tex_Bloom0 = render.GetBloomTex0()

--[[---------------------------------------------------------
	Register the convars that will control this effect
-----------------------------------------------------------]]
local pp_bloom = CreateClientConVar( "pp_bloom", "0", false, false ) -- On/Off
local pp_bloom_darken = CreateClientConVar( "pp_bloom_darken", "0.65", true, false ) -- Decides the strength of the bloom
local pp_bloom_multiply = CreateClientConVar( "pp_bloom_multiply", "1.0", true, false ) -- Decides the strength of the bloom
local pp_bloom_sizex = CreateClientConVar( "pp_bloom_sizex", "4.0", true, false ) -- Horizontal blur size
local pp_bloom_sizey = CreateClientConVar( "pp_bloom_sizey", "4.0", true, false ) -- Vertical blur size
local pp_bloom_color = CreateClientConVar( "pp_bloom_color", "2.0", true, false )
local pp_bloom_color_r = CreateClientConVar( "pp_bloom_color_r", "255", true, false )
local pp_bloom_color_g = CreateClientConVar( "pp_bloom_color_g", "255", true, false )
local pp_bloom_color_b = CreateClientConVar( "pp_bloom_color_b", "255", true, false )
local pp_bloom_passes = CreateClientConVar( "pp_bloom_passes", "4", true, false )

--[[---------------------------------------------------------
	Can be called from engine or hooks using bloom.Draw
-----------------------------------------------------------]]
function DrawBloom( darken, multiply, sizex, sizey, passes, color, colr, colg, colb )

	-- No bloom for crappy gpus
	if ( !render.SupportsPixelShaders_2_0() ) then return end

	-- Copy the backbuffer to the screen effect texture
	render.CopyRenderTargetToTexture( render.GetScreenEffectTexture() )

	-- The downsample material adjusts the contrast
	mat_Downsample:SetFloat( "$darken", darken )
	mat_Downsample:SetFloat( "$multiply", multiply )

	-- Downsample to BloomTexture0
	render.PushRenderTarget( tex_Bloom0 )

		render.SetMaterial( mat_Downsample )
		render.DrawScreenQuad()

		render.BlurRenderTarget( tex_Bloom0, sizex, sizey, passes )

	render.PopRenderTarget()

	mat_Bloom:SetFloat( "$levelr", colr )
	mat_Bloom:SetFloat( "$levelg", colg )
	mat_Bloom:SetFloat( "$levelb", colb )
	mat_Bloom:SetFloat( "$colormul", color )
	mat_Bloom:SetTexture( "$basetexture", tex_Bloom0 )

	render.SetMaterial( mat_Bloom )
	render.DrawScreenQuad()

end

--[[---------------------------------------------------------
	The function to draw the bloom (called from the hook)
-----------------------------------------------------------]]
hook.Add( "RenderScreenspaceEffects", "RenderBloom", function()

	-- No bloom for crappy gpus

	if ( !render.SupportsPixelShaders_2_0() ) then return end
	if ( !pp_bloom:GetBool() ) then return end
	if ( !GAMEMODE:PostProcessPermitted( "bloom" ) ) then return end

	DrawBloom( pp_bloom_darken:GetFloat(), pp_bloom_multiply:GetFloat(),
				pp_bloom_sizex:GetFloat(), pp_bloom_sizey:GetFloat(),
				pp_bloom_passes:GetFloat(), pp_bloom_color:GetFloat(),
				pp_bloom_color_r:GetFloat() / 255, pp_bloom_color_g:GetFloat() / 255, pp_bloom_color_b:GetFloat() / 255 )

end )

list.Set( "PostProcess", "#bloom_pp", {

	icon = "gui/postprocess/bloom.png",
	convar = "pp_bloom",
	category = "#shaders_pp",

	cpanel = function( CPanel )

		CPanel:Help( "#bloom_pp.desc" )
		CPanel:CheckBox( "#bloom_pp.enable", "pp_bloom" )

		local options = {
			pp_bloom_passes = "4",
			pp_bloom_darken = "0.65",
			pp_bloom_multiply = "1.0",
			pp_bloom_sizex = "4.0",
			pp_bloom_sizey = "4.0",
			pp_bloom_color = "2.0",
			pp_bloom_color_r = "255",
			pp_bloom_color_g = "255",
			pp_bloom_color_b = "255"
		}
		CPanel:ToolPresets( "bloom", options )

		CPanel:NumSlider( "#bloom_pp.passes", "pp_bloom_passes", 0, 30, 0 )
		CPanel:NumSlider( "#bloom_pp.darken", "pp_bloom_darken", 0, 1 )
		CPanel:NumSlider( "#bloom_pp.multiply", "pp_bloom_multiply", 0, 5 )
		CPanel:NumSlider( "#bloom_pp.blurx", "pp_bloom_sizex", 0, 50 )
		CPanel:NumSlider( "#bloom_pp.blury", "pp_bloom_sizey", 0, 50 )
		CPanel:NumSlider( "#bloom_pp.multiplier", "pp_bloom_color", 0, 20 )

		CPanel:ColorPicker( "#bloom_pp.color", "pp_bloom_color_r", "pp_bloom_color_g", "pp_bloom_color_b" )

	end

} )
