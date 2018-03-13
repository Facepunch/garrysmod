
local blur_mat = Material( "pp/bokehblur" )

local pp_bokeh = CreateClientConVar( "pp_bokeh", "0", false, false )
local pp_bokeh_blur = CreateClientConVar( "pp_bokeh_blur", "5", true, false )
local pp_bokeh_distance = CreateClientConVar( "pp_bokeh_distance", "0.1", true, false )
local pp_bokeh_focus = CreateClientConVar( "pp_bokeh_focus", "1.0", true, false )

local function DrawBokehDOF()

	render.UpdateScreenEffectTexture()

	blur_mat:SetTexture( "$BASETEXTURE", render.GetScreenEffectTexture() )
	blur_mat:SetTexture( "$DEPTHTEXTURE", render.GetResolvedFullFrameDepth() )

	blur_mat:SetFloat( "$size", pp_bokeh_blur:GetFloat() )
	blur_mat:SetFloat( "$focus", pp_bokeh_distance:GetFloat() )
	blur_mat:SetFloat( "$focusradius", pp_bokeh_focus:GetFloat() )

	render.SetMaterial( blur_mat )
	render.DrawScreenQuad()

end

local function OnChange( name, oldvalue, newvalue )

	if ( !GAMEMODE:PostProcessPermitted( "bokeh" ) ) then return end

	if ( newvalue != "0" ) then
		DOFModeHack( true )
	else
		DOFModeHack( false )
	end

end
cvars.AddChangeCallback( "pp_bokeh", OnChange )

hook.Add( "RenderScreenspaceEffects", "RenderBokeh", function()

	if ( !pp_bokeh:GetBool() ) then return end
	if ( !GAMEMODE:PostProcessPermitted( "bokeh" ) ) then return end

	DrawBokehDOF()

end )

hook.Add( "NeedsDepthPass", "NeedsDepthPass_Bokeh", function()

	if ( pp_bokeh:GetBool() ) then return true end

end )
