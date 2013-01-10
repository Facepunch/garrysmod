
local mat = 
{
	blur = Material( "pp/bokehblur" ),
}

local pp_bokeh_blur 		= CreateClientConVar( "pp_bokeh_blur", "5", false, false )
local pp_bokeh_distance		= CreateClientConVar( "pp_bokeh_distance", "0.1", false, false )
local pp_bokeh_focus		= CreateClientConVar( "pp_bokeh_focus", "1.0", false, false )
local pp_bokeh				= CreateClientConVar( "pp_bokeh", "0", false, false )


local function DrawBokehDOF()

	render.UpdateScreenEffectTexture()

	mat.blur:SetTexture( "$BASETEXTURE", render.GetScreenEffectTexture() )
	mat.blur:SetTexture( "$DEPTHTEXTURE", render.GetResolvedFullFrameDepth() )

	mat.blur:SetFloat( "$size", pp_bokeh_blur:GetFloat() )
	mat.blur:SetFloat( "$focus", pp_bokeh_distance:GetFloat() )
	mat.blur:SetFloat( "$focusradius", pp_bokeh_focus:GetFloat() )

	render.SetMaterial( mat.blur )
	render.DrawScreenQuad()
	
end


hook.Add( "RenderScreenspaceEffects", "RenderBokeh", function()

	if ( !pp_bokeh:GetBool() ) then return end
	if ( !GAMEMODE:PostProcessPermitted( "bokeh" ) ) then return end

	DrawBokehDOF();

end )

hook.Add( "NeedsDepthPass", "NeedsDepthPass_Bokeh", function()

	return pp_bokeh:GetBool()

end )
