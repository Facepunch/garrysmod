
local material = Material( "pp/bokehblur" )

local pp_bokeh_blur 		= CreateClientConVar( "pp_bokeh_blur", "5", false, false )
local pp_bokeh_distance		= CreateClientConVar( "pp_bokeh_distance", "0.1", false, false )
local pp_bokeh_focus		= CreateClientConVar( "pp_bokeh_focus", "1.0", false, false )
local pp_bokeh				= CreateClientConVar( "pp_bokeh", "0", false, false )

local function DrawBokehDOF()

	render.UpdateScreenEffectTexture()

	material:SetTexture( "$BASETEXTURE", render.GetScreenEffectTexture() )
	material:SetTexture( "$DEPTHTEXTURE", render.GetResolvedFullFrameDepth() )

	material:SetFloat( "$size", pp_bokeh_blur:GetFloat() )
	material:SetFloat( "$focus", pp_bokeh_distance:GetFloat() )
	material:SetFloat( "$focusradius", pp_bokeh_focus:GetFloat() )

	render.SetMaterial( material )
	render.DrawScreenQuad()

end

hook.Add( "RenderScreenspaceEffects", "RenderBokeh", function()

	if ( !pp_bokeh:GetBool() ) then return end
	if ( !GAMEMODE:PostProcessPermitted( "bokeh" ) ) then return end

	DrawBokehDOF()

end )

hook.Add( "NeedsDepthPass", "NeedsDepthPass_Bokeh", function()

	return pp_bokeh:GetBool()

end )

list.Set( "PostProcess", "Bokeh DOF", {

	icon		= "gui/postprocess/dof.png",
	convar		= "pp_bokeh",
	category	= "Effects",

	cpanel		= function( CPanel )

		CPanel:AddControl( "CheckBox", { Label = "#Enable", Command = "pp_bokeh" }  )

		local params = { Options = {}, CVars = { "pp_bokeh_blur", "pp_bokeh_distance", "pp_bokeh_focus" }, Label = "#tool.presets", MenuButton = "1", Folder = "bloom" }
		params.Options[ "#Default" ] = { pp_bokeh_blur = "5", pp_bokeh_distance = "0.1", pp_bokeh_focus = "1.0" }

		CPanel:AddControl( "ComboBox", params )

		CPanel:AddControl( "Slider", { Label = "#Blur", Command = "pp_bokeh_blur", Type = "Float", Min = "0", Max = "16" } )
		CPanel:AddControl( "Slider", { Label = "#Distance", Command = "pp_bokeh_distance", Type = "Float", Min = "0", Max = "1" } )
		CPanel:AddControl( "Slider", { Label = "#Focus", Command = "pp_bokeh_focus", Type = "Float", Min = "0", Max = "12" } )

	end

} )
