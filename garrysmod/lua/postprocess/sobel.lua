
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

hook.Add( "RenderScreenspaceEffects", "RenderSobel", function()

	if ( !pp_sobel:GetBool() ) then return end
	if ( !GAMEMODE:PostProcessPermitted( "sobel" ) ) then return end

	DrawSobel( pp_sobel_threshold:GetFloat() )

end )

list.Set( "PostProcess", "#sobel_pp", {

	icon = "gui/postprocess/sobel.png",
	convar = "pp_sobel",
	category = "#shaders_pp",

	cpanel = function( CPanel )

		CPanel:Help( "#sobel_pp.desc" )
		CPanel:CheckBox( "#sobel_pp.enable", "pp_sobel" )

		local params = vgui.Create( "ControlPresets", CPanel )
		local options = {}
		options[ "#preset.default" ] = { pp_sobel_threshold = "0.11" }
		params:SetPreset( "sobel" )
		params:AddOption( "#preset.default", options[ "#preset.default" ] )
		for k, v in pairs( table.GetKeys( options[ "#preset.default" ] ) ) do
			params:AddConVar( v )
		end
		CPanel:AddPanel( params )

		CPanel:NumSlider( "#sobel_pp.threshold", "pp_sobel_threshold", 0, 1, 2 )

	end

} )
