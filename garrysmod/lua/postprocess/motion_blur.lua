


local mat_MotionBlur	= Material( "pp/motionblur" )
local mat_Screen		= Material( "pp/fb" )
local tex_MotionBlur	= render.GetMoBlurTex0()

--[[---------------------------------------------------------
   Register the convars that will control this effect
-----------------------------------------------------------]]   
local pp_motionblur 			= CreateConVar( "pp_motionblur", "0", { FCVAR_DONTRECORD }  )
local pp_motionblur_addalpha 	= CreateConVar( "pp_motionblur_addalpha", "0.2", { FCVAR_DONTRECORD } )
local pp_motionblur_drawalpha	= CreateConVar( "pp_motionblur_drawalpha", "0.99", { FCVAR_DONTRECORD } )
local pp_motionblur_delay		= CreateConVar( "pp_motionblur_delay", "0.0", { FCVAR_DONTRECORD } )

local NextDraw = 0
local LastDraw = 0

function DrawMotionBlur( addalpha, drawalpha, delay )

	if ( drawalpha == 0 ) then return end
	
	-- Copy the backbuffer to the screen effect texture
	render.UpdateScreenEffectTexture()
	
	-- If it's been a long time then the buffer is probably dirty, update it
	if ( CurTime() - LastDraw > 0.5 ) then
	
		mat_Screen:SetFloat( "$alpha", 1 )
		
		local OldRT = render.GetRenderTarget();
		render.SetRenderTarget( tex_MotionBlur )
			render.SetMaterial( mat_Screen )
			render.DrawScreenQuad()
		render.SetRenderTarget( OldRT )	
	
	end

	-- Set up out materials
	mat_MotionBlur:SetFloat( "$alpha", drawalpha )
	mat_MotionBlur:SetTexture( "$basetexture", tex_MotionBlur )
	
	if ( NextDraw < CurTime() && addalpha > 0 ) then

		NextDraw = CurTime() + delay

		mat_Screen:SetFloat( "$alpha", addalpha )
		local OldRT = render.GetRenderTarget();
		render.SetRenderTarget( tex_MotionBlur )

		render.SetMaterial( mat_Screen )
		render.DrawScreenQuad()

		render.SetRenderTarget( OldRT )

	end


	render.SetMaterial( mat_MotionBlur )
	render.DrawScreenQuad()
	
	LastDraw = CurTime()
	
end

local function DrawInternal()

	if ( !pp_motionblur:GetBool() ) then return end
	if ( !GAMEMODE:PostProcessPermitted( "motion blur" ) ) then return end

	DrawMotionBlur( pp_motionblur_addalpha:GetFloat(),
			pp_motionblur_drawalpha:GetFloat(),
			pp_motionblur_delay:GetFloat() );

end


hook.Add( "RenderScreenspaceEffects", "RenderMotionBlur", DrawInternal )


list.Set( "PostProcess", "Accumulation Motion Blur",
{
	icon		= "gui/postprocess/accummotionblur.png",
	
	convar		= "pp_motionblur",
	
	category	= "Effects",
	
	cpanel		= function( CPanel )

		CPanel:AddControl( "Header", { Text = "#MotionBlur", Description = "#MotionBlur_Information" }  )
		CPanel:AddControl( "CheckBox", { Label = "#MotionBlur_Toggle", Command = "pp_motionblur" }  )
		
		local params = { Options = {}, CVars = {}, Label = "#tool.presets", MenuButton = "1", Folder = "motionblur" }
		params.Options[ "#Default" ] = { pp_motionblur_addalpha = "0.2", pp_motionblur_delay = "0.05", pp_motionblur_drawalpha = "0.99" }
		params.CVars = { "pp_motionblur_addalpha", "pp_motionblur_drawalpha", "pp_motionblur_delay" }
		CPanel:AddControl( "ComboBox", 	params )
		
		CPanel:AddControl( "Slider", { Label = "#MotionBlur_Add_Alpha", Command = "pp_motionblur_addalpha", Type = "Float", Min = "0", Max = "1" }  )
		CPanel:AddControl( "Slider", { Label = "#MotionBlur_DrawAlpha", Command = "pp_motionblur_drawalpha", Type = "Float", Min = "0", Max = "1" }  )
		CPanel:AddControl( "Slider", { Label = "#MotionBlur_Delay", Command = "pp_motionblur_delay", Type = "Float", Min = "0", Max = "1" }  )	

	end,
	
})
