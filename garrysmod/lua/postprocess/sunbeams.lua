
local _Material			= Material( "pp/sunbeams" )
_Material:SetTexture( "$fbtexture", render.GetScreenEffectTexture() )

--[[---------------------------------------------------------
   Register the convars that will control this effect
-----------------------------------------------------------]]   
local pp_sunbeams 			= CreateClientConVar( "pp_sunbeams", 				"0", 		true, false )
local pp_sunbeams_darken	= CreateClientConVar( "pp_sunbeams_darken", 		"0.95", 	false, false )
local pp_sunbeams_multiply  = CreateClientConVar( "pp_sunbeams_multiply", 	"1.0", 		false, false )
local pp_sunbeams_sunsize	= CreateClientConVar( "pp_sunbeams_sunsize", 		"0.075", 	false, false )


function DrawSunbeams( darken, multiply, sunsize, sunx, suny )

	if ( !render.SupportsPixelShaders_2_0() ) then return end
	
	render.UpdateScreenEffectTexture()

	_Material:SetFloat( "$darken", darken )
	_Material:SetFloat( "$multiply", multiply )
	_Material:SetFloat( "$sunx", sunx )
	_Material:SetFloat( "$suny", suny )
	_Material:SetFloat( "$sunsize", sunsize )
	
	render.SetMaterial( _Material )
	render.DrawScreenQuad()
	
end

local function DrawInternal()

	if ( !pp_sunbeams:GetBool() ) then return end
	if ( !GAMEMODE:PostProcessPermitted( "sunbeams" ) ) then return end
	if ( !render.SupportsPixelShaders_2_0() ) then return end
	
	local sun = util.GetSunInfo()
	
	if (!sun) then return end
	if (sun.obstruction == 0) then return end
	
	local sunpos = EyePos() + sun.direction * 4096
	local scrpos = sunpos:ToScreen()
	
	local dot = (sun.direction:Dot( EyeVector() ) - 0.8) * 5
	if (dot <= 0) then return end
	
	DrawSunbeams( pp_sunbeams_darken:GetFloat(),
				  pp_sunbeams_multiply:GetFloat() * dot * sun.obstruction,
				  pp_sunbeams_sunsize:GetFloat(), 
				  scrpos.x / ScrW(), 
				  scrpos.y / ScrH()
				  );

end

hook.Add( "RenderScreenspaceEffects", "RenderSunbeams", DrawInternal )


list.Set( "PostProcess", "Sun Rays",
{
	icon		= "gui/postprocess/sunrays.png",
	
	convar		= "pp_sunbeams",
	
	category	= "Shaders",
	
	cpanel		= function( CPanel )

		CPanel:AddControl( "Header", { Text = "#Sun Beams", Description = "#Sun Beams" }  )
		CPanel:AddControl( "CheckBox", { Label = "#Enable", Command = "pp_sunbeams" }  )
		
		CPanel:AddControl( "Slider", { Label = "#Multiply", Command = "pp_sunbeams_multiply", Type = "Float", Min = "0", Max = "1" }  )
		CPanel:AddControl( "Slider", { Label = "#Darken", Command = "pp_sunbeams_darken", Type = "Float", Min = "0", Max = "1" }  )
		CPanel:AddControl( "Slider", { Label = "#Sun Size", Command = "pp_sunbeams_sunsize", Type = "Float", Min = "0.01", Max = "0.25" }  )
		
	end,
	
})