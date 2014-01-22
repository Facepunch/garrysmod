
local _Material = Material( "pp/sharpen" )
_Material:SetTexture( "$fbtexture", render.GetScreenEffectTexture() )

--[[---------------------------------------------------------
   Register the convars that will control this effect
-----------------------------------------------------------]]   
local pp_sharpen_contrast 	= CreateClientConVar( "pp_sharpen_contrast", "1", false, false )
local pp_sharpen_distance	= CreateClientConVar( "pp_sharpen_distance", "1", false, false )
local pp_sharpen			= CreateClientConVar( "pp_sharpen", "0", false, false )


function DrawSharpen( contrast, distance )

	render.UpdateScreenEffectTexture()

	_Material:SetFloat( "$contrast", contrast )
	_Material:SetFloat( "$distance", distance / ScrW() )
	
	
	render.SetMaterial( _Material )
	render.DrawScreenQuad()
	
end

local function DrawInternal()

	if ( !pp_sharpen:GetBool() ) then return end
	if ( !GAMEMODE:PostProcessPermitted( "sharpen" ) ) then return end

	DrawSharpen( pp_sharpen_contrast:GetFloat(), pp_sharpen_distance:GetFloat() )

end
hook.Add( "RenderScreenspaceEffects", "RenderSharpen", DrawInternal )


list.Set( "PostProcess", "#sharpen_pp", {

	icon		= "gui/postprocess/sharpen.png",
	convar		= "pp_sharpen",
	category	= "#shaders_pp",
	
	cpanel		= function( CPanel )

		CPanel:AddControl( "Header", { Description = "#sharpen_pp.desc" } )
		CPanel:AddControl( "CheckBox", { Label = "#sharpen_pp.enable", Command = "pp_sharpen" } )
		
		CPanel:AddControl( "Slider", { Label = "#sharpen_pp.distance", Command = "pp_sharpen_distance", Type = "Float", Min = "-5", Max = "5" } )
		CPanel:AddControl( "Slider", { Label = "#sharpen_pp.contrast", Command = "pp_sharpen_contrast", Type = "Float", Min = "0", Max = "20" } )
		
	end
	
} )
