
local matSharpen = Material( "pp/sharpen" )
matSharpen:SetTexture( "$fbtexture", render.GetScreenEffectTexture() )

--[[---------------------------------------------------------
	Register the convars that will control this effect
-----------------------------------------------------------]]
local pp_sharpen = CreateClientConVar( "pp_sharpen", "0", false, false )
local pp_sharpen_contrast = CreateClientConVar( "pp_sharpen_contrast", "1", true, false )
local pp_sharpen_distance = CreateClientConVar( "pp_sharpen_distance", "1", true, false )

function DrawSharpen( contrast, distance )

	render.CopyRenderTargetToTexture( render.GetScreenEffectTexture() )

	matSharpen:SetFloat( "$contrast", contrast )
	matSharpen:SetFloat( "$distance", distance / ScrW() )

	render.SetMaterial( matSharpen )
	render.DrawScreenQuad()

end

hook.Add( "RenderScreenspaceEffects", "RenderSharpen", function()

	if ( !pp_sharpen:GetBool() ) then return end
	if ( !GAMEMODE:PostProcessPermitted( "sharpen" ) ) then return end

	DrawSharpen( pp_sharpen_contrast:GetFloat(), pp_sharpen_distance:GetFloat() )

end )

list.Set( "PostProcess", "#sharpen_pp", {

	icon = "gui/postprocess/sharpen.png",
	convar = "pp_sharpen",
	category = "#shaders_pp",

	cpanel = function( CPanel )

		CPanel:Help( "#sharpen_pp.desc" )
		CPanel:CheckBox( "#sharpen_pp.enable", "pp_sharpen" )

		CPanel:ToolPresets( "sharpen", { pp_sharpen_distance = "1", pp_sharpen_contrast = "1" } )

		CPanel:NumSlider( "#sharpen_pp.distance", "pp_sharpen_distance", -5, 5 )
		CPanel:NumSlider( "#sharpen_pp.contrast", "pp_sharpen_contrast", 0, 20 )

	end

} )
