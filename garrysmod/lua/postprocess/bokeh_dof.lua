
local blur_mat = Material( "pp/bokehblur" )

local pp_bokeh = CreateClientConVar( "pp_bokeh", "0", false, false )
local pp_bokeh_blur = CreateClientConVar( "pp_bokeh_blur", "5", true, false )
local pp_bokeh_distance = CreateClientConVar( "pp_bokeh_distance", "0.1", true, false )
local pp_bokeh_focus = CreateClientConVar( "pp_bokeh_focus", "1.0", true, false )

function DrawBokehDOF( intensity, distance, focus )

	render.UpdateScreenEffectTexture()

	blur_mat:SetTexture( "$BASETEXTURE", render.GetScreenEffectTexture() )
	blur_mat:SetTexture( "$DEPTHTEXTURE", render.GetResolvedFullFrameDepth() )

	blur_mat:SetFloat( "$size", intensity )
	blur_mat:SetFloat( "$focus", distance )
	blur_mat:SetFloat( "$focusradius", focus )

	render.SetMaterial( blur_mat )
	render.DrawScreenQuad()

end

hook.Add( "RenderScreenspaceEffects", "RenderBokeh", function()

	if ( !pp_bokeh:GetBool() ) then return end
	if ( !GAMEMODE:PostProcessPermitted( "bokeh" ) ) then return end

	DrawBokehDOF( pp_bokeh_blur:GetFloat(), pp_bokeh_distance:GetFloat(), pp_bokeh_focus:GetFloat() )

end )

hook.Add( "NeedsDepthPass", "NeedsDepthPass_Bokeh", function()

	if ( pp_bokeh:GetBool() ) then return true end

end )
