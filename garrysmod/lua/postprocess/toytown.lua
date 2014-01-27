
local _Material			= Material( "pp/toytown-top" )
_Material:SetTexture( "$fbtexture", render.GetScreenEffectTexture() )

--[[---------------------------------------------------------
   Register the convars that will control this effect
-----------------------------------------------------------]]   
local pp_toytown 			= CreateClientConVar( "pp_toytown", 		"0",	true, false )
local pp_toytown_passes		= CreateClientConVar( "pp_toytown_passes", 	"3",	false, false )
local pp_toytown_size		= CreateClientConVar( "pp_toytown_size", 	"0.4",	false, false )

function DrawToyTown( NumPasses, H )
	cam.Start2D()
	
	surface.SetMaterial( _Material )
	surface.SetDrawColor( 255, 255, 255, 255 )
	
	for i=1, NumPasses do
	
		render.UpdateScreenEffectTexture()
		
		surface.DrawTexturedRect( 0, 0, ScrW(), H )
		surface.DrawTexturedRectRotated( ScrW() * 0.5, ScrH() - H * 0.5 + 1, ScrW(), H, 180 )
	
	end
	
	cam.End2D()
end

local function DrawInternal()

	if ( !pp_toytown:GetBool() ) then return end
	if ( !GAMEMODE:PostProcessPermitted( "toytown" ) ) then return end
	if ( !render.SupportsPixelShaders_2_0() ) then return end

	local NumPasses = pp_toytown_passes:GetInt()
	local H = ScrH() * pp_toytown_size:GetFloat()
	
	DrawToyTown( NumPasses, H )
	
end
hook.Add( "RenderScreenspaceEffects", "RenderToyTown", DrawInternal )

list.Set( "PostProcess", "#toytown_pp", {

	icon		= "gui/postprocess/toytown.png",
	convar		= "pp_toytown",
	category	= "#shaders_pp",
	
	cpanel		= function( CPanel )

		CPanel:AddControl( "Header", { Description = "#toytown_pp.desc" } )
		CPanel:AddControl( "CheckBox", { Label = "#toytown_pp.enable", Command = "pp_toytown" } )
		
		CPanel:AddControl( "Slider", { Label = "#toytown_pp.passes", Command = "pp_toytown_passes", Type = "Int", Min = "1", Max = "100" } )
		CPanel:AddControl( "Slider", { Label = "#toytown_pp.height", Command = "pp_toytown_size", Type = "Float", Min = "0", Max = "1" } )
		
	end
	
})
