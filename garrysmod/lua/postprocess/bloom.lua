
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

	-- Store the render target so we can swap back at the end
	local OldRT = render.GetRenderTarget()

	-- The downsample material adjusts the contrast
	mat_Downsample:SetFloat( "$darken", darken )
	mat_Downsample:SetFloat( "$multiply", multiply )

	-- Downsample to BloomTexture0
	render.SetRenderTarget( tex_Bloom0 )

	render.SetMaterial( mat_Downsample )
	render.DrawScreenQuad()

	render.BlurRenderTarget( tex_Bloom0, sizex, sizey, passes )

	render.SetRenderTarget( OldRT )

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

		CPanel:AddControl( "Header", { Description = "#bloom_pp.desc" } )
		CPanel:AddControl( "CheckBox", { Label = "#bloom_pp.enable", Command = "pp_bloom" } )

		local params = { Options = {}, CVars = {}, MenuButton = "1", Folder = "bloom" }
		params.Options[ "#preset.default" ] = {
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
		params.CVars = table.GetKeys( params.Options[ "#preset.default" ] )
		CPanel:AddControl( "ComboBox", params )

		CPanel:AddControl( "Slider", { Label = "#bloom_pp.passes", Command = "pp_bloom_passes", Type = "Integer", Min = "0", Max = "30" } )
		CPanel:AddControl( "Slider", { Label = "#bloom_pp.darken", Command = "pp_bloom_darken", Type = "Float", Min = "0", Max = "1" } )
		CPanel:AddControl( "Slider", { Label = "#bloom_pp.multiply", Command = "pp_bloom_multiply", Type = "Float", Min = "0", Max = "5" } )
		CPanel:AddControl( "Slider", { Label = "#bloom_pp.blurx", Command = "pp_bloom_sizex", Type = "Float", Min = "0", Max = "50" } )
		CPanel:AddControl( "Slider", { Label = "#bloom_pp.blury", Command = "pp_bloom_sizey", Type = "Float", Min = "0", Max = "50" } )
		CPanel:AddControl( "Slider", { Label = "#bloom_pp.multiplier", Command = "pp_bloom_color", Type = "Float", Min = "0", Max = "20" } )

		CPanel:AddControl( "Color", { Label = "#bloom_pp.color", Red = "pp_bloom_color_r", Green = "pp_bloom_color_g", Blue = "pp_bloom_color_b", ShowAlpha = "0", ShowHSV = "1", ShowRGB = "1" } )

	end

} )
