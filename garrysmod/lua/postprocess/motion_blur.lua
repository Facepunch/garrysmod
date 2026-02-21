
local mat_MotionBlur = Material( "pp/motionblur" )
local mat_Screen = Material( "pp/fb" )
local tex_MotionBlur = render.GetMoBlurTex0()

--[[---------------------------------------------------------
	Register the convars that will control this effect
-----------------------------------------------------------]]
local pp_motionblur = CreateClientConVar( "pp_motionblur", "0", false, false )
local pp_motionblur_addalpha = CreateClientConVar( "pp_motionblur_addalpha", "0.2", true, false )
local pp_motionblur_drawalpha = CreateClientConVar( "pp_motionblur_drawalpha", "0.99", true, false )
local pp_motionblur_delay = CreateClientConVar( "pp_motionblur_delay", "0.05", true, false )

local NextDraw = 0
local LastDraw = 0

function DrawMotionBlur( addalpha, drawalpha, delay )

	if ( drawalpha == 0 ) then return end

	-- Copy the backbuffer to the screen effect texture
	render.UpdateScreenEffectTexture()

	-- If it's been a long time then the buffer is probably dirty, update it
	if ( CurTime() - LastDraw > 0.5 ) then

		mat_Screen:SetFloat( "$alpha", 1 )

		render.PushRenderTarget( tex_MotionBlur )
			render.SetMaterial( mat_Screen )
			render.DrawScreenQuad()
		render.PopRenderTarget()

	end

	-- Set up out materials
	mat_MotionBlur:SetFloat( "$alpha", drawalpha )
	mat_MotionBlur:SetTexture( "$basetexture", tex_MotionBlur )

	if ( NextDraw < CurTime() && addalpha > 0 ) then

		NextDraw = CurTime() + delay

		mat_Screen:SetFloat( "$alpha", addalpha )
		render.PushRenderTarget( tex_MotionBlur )
			render.SetMaterial( mat_Screen )
			render.DrawScreenQuad()
		render.PopRenderTarget()

	end

	render.SetMaterial( mat_MotionBlur )
	render.DrawScreenQuad( true )

	LastDraw = CurTime()

end

hook.Add( "RenderScreenspaceEffects", "RenderMotionBlur", function()

	if ( !pp_motionblur:GetBool() ) then return end
	if ( !GAMEMODE:PostProcessPermitted( "motion blur" ) ) then return end

	DrawMotionBlur( pp_motionblur_addalpha:GetFloat(), pp_motionblur_drawalpha:GetFloat(), pp_motionblur_delay:GetFloat() )

end )

list.Set( "PostProcess", "#motion_blur_pp", {

	icon = "gui/postprocess/accummotionblur.png",
	convar = "pp_motionblur",
	category = "#effects_pp",

	cpanel = function( CPanel )

		CPanel:Help( "#motion_blur_pp.desc" )
		CPanel:CheckBox( "#motion_blur_pp.enable", "pp_motionblur" )

		local options = {
			pp_motionblur_addalpha = "0.2",
			pp_motionblur_delay = "0.05",
			pp_motionblur_drawalpha = "0.99"
		}
		CPanel:ToolPresets( "motionblur", options )

		CPanel:NumSlider( "#motion_blur_pp.add_alpha", "pp_motionblur_addalpha", 0, 1 )
		CPanel:NumSlider( "#motion_blur_pp.draw_alpha", "pp_motionblur_drawalpha", 0, 1 )
		CPanel:NumSlider( "#motion_blur_pp.delay", "pp_motionblur_delay", 0, 1 )

	end

} )
