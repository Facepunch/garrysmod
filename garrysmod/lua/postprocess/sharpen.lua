
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

cvars.AddChangeCallback( "pp_sharpen", function( _, _, newValue )

	if ( !GAMEMODE:PostProcessPermitted( "sharpen" ) ) then return end

	if ( newValue != "0" ) then
		hook.Add( "RenderScreenspaceEffects", "RenderSharpen", function()

			DrawSharpen( pp_sharpen_contrast:GetFloat(), pp_sharpen_distance:GetFloat() )

		end )
	else
		hook.Remove( "RenderScreenspaceEffects", "RenderSharpen" )
	end

end )

list.Set( "PostProcess", "#sharpen_pp", {

	icon = "gui/postprocess/sharpen.png",
	convar = "pp_sharpen",
	category = "#shaders_pp",

	cpanel = function( CPanel )

		CPanel:AddControl( "Header", { Description = "#sharpen_pp.desc" } )
		CPanel:AddControl( "CheckBox", { Label = "#sharpen_pp.enable", Command = "pp_sharpen" } )

		local params = { Options = {}, CVars = {}, MenuButton = "1", Folder = "sharpen" }
		params.Options[ "#preset.default" ] = { pp_sharpen_distance = "1", pp_sharpen_contrast = "1" }
		params.CVars = table.GetKeys( params.Options[ "#preset.default" ] )
		CPanel:AddControl( "ComboBox", params )

		CPanel:AddControl( "Slider", { Label = "#sharpen_pp.distance", Command = "pp_sharpen_distance", Type = "Float", Min = "-5", Max = "5" } )
		CPanel:AddControl( "Slider", { Label = "#sharpen_pp.contrast", Command = "pp_sharpen_contrast", Type = "Float", Min = "0", Max = "20" } )

	end

} )
