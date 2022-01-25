
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

		CPanel:AddControl( "Header", { Description = "#sobel_pp.desc" } )
		CPanel:AddControl( "CheckBox", { Label = "#sobel_pp.enable", Command = "pp_sobel" } )

		local params = { Options = {}, CVars = {}, MenuButton = "1", Folder = "sobel" }
		params.Options[ "#preset.default" ] = { pp_sobel_threshold = "0.11" }
		params.CVars = table.GetKeys( params.Options[ "#preset.default" ] )
		CPanel:AddControl( "ComboBox", params )

		CPanel:AddControl( "Slider", { Label = "#sobel_pp.threshold", Command = "pp_sobel_threshold", Type = "Float", Min = "0", Max = "1" } )

	end

} )
