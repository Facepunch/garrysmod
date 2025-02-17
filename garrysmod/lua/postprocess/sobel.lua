
local SobelMaterial = Material( "pp/sobel" )
SobelMaterial:SetTexture( "$fbtexture", render.GetScreenEffectTexture() )

local pp_sobel = CreateClientConVar( "pp_sobel", "0", false, false )
local pp_sobel_threshold = CreateClientConVar( "pp_sobel_threshold", "0.11", true, false )

function DrawSobel( threshold )

	render.CopyRenderTargetToTexture( render.GetScreenEffectTexture() )

	-- update threshold value
	SobelMaterial:SetFloat( "$threshold", threshold )

	render.SetMaterial( SobelMaterial )
	render.DrawScreenQuad()

end

cvars.AddChangeCallback( "pp_sobel", function( _, _, newValue )

	if ( !GAMEMODE:PostProcessPermitted( "sobel" ) ) then return end

	if ( newValue != "0" ) then
		hook.Add( "RenderScreenspaceEffects", "RenderSobel", function()

			DrawSobel( pp_sobel_threshold:GetFloat() )

		end )
	else
		hook.Remove( "RenderScreenspaceEffects", "RenderSobel" )
	end

end )

list.Set( "PostProcess", "#sobel_pp", {

	icon = "gui/postprocess/sobel.png",
	convar = "pp_sobel",
	category = "#shaders_pp",

	cpanel = function( CPanel )

		CPanel:Help( "#sobel_pp.desc" )
		CPanel:CheckBox( "#sobel_pp.enable", "pp_sobel" )

		CPanel:ToolPresets( "sobel", { pp_sobel_threshold = "0.11" } )

		CPanel:NumSlider( "#sobel_pp.threshold", "pp_sobel_threshold", 0, 1 )

	end

} )
