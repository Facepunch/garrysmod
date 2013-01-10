



--[[---------------------------------------------------------
   Register the convars that will control this effect
-----------------------------------------------------------]]   
local pp_mat_overlay 				= CreateClientConVar( "pp_mat_overlay", "", false, false )
local pp_mat_overlay_refractamount	= CreateClientConVar( "pp_mat_overlay_refractamount", "0.3", false, false )

local lastTexture = nil
local mat_Overlay = nil

function DrawMaterialOverlay( texture, refractamount )

	if (texture ~= lastTexture or mat_Overlay == nil) then
		mat_Overlay = Material( texture )
		lastTexture = texture
	end
	
	if (mat_Overlay == nil) then return end

	render.UpdateScreenEffectTexture()

	mat_Overlay:SetFloat("$envmap",			0)
	mat_Overlay:SetFloat("$envmaptint",		0)
	mat_Overlay:SetFloat("$refractamount",	refractamount)
	mat_Overlay:SetInt("$ignorez",		1)

	render.SetMaterial( mat_Overlay )
	render.DrawScreenQuad()
	
end

local function DrawInternal()

	local overlay = pp_mat_overlay:GetString()

	if ( overlay == "" ) then return end
	if ( !GAMEMODE:PostProcessPermitted( "material overlay" ) ) then return end

	DrawMaterialOverlay( 
			overlay, 
			pp_mat_overlay_refractamount:GetFloat()	);

end

hook.Add( "RenderScreenspaceEffects", "RenderMaterialOverlay", DrawInternal )


list.Set( "OverlayMaterials", "waterfall",		{ Material = "models/shadertest/shader3", Icon = "models/shadertest/shader3" } )
list.Set( "OverlayMaterials", "jelly",			{ Material = "models/shadertest/shader4", Icon = "models/shadertest/shader4" } )
list.Set( "OverlayMaterials", "stained glass",	{ Material = "models/shadertest/shader5", Icon = "models/shadertest/shader5" } )
list.Set( "OverlayMaterials", "statis",			{ Material = "models/props_combine/stasisshield_sheet", Icon = "models/props_combine/stasisshield_sheet" } )
list.Set( "OverlayMaterials", "shield",			{ Material = "models/props_combine/com_shield001a", Icon = "models/props_combine/com_shield001a" } )
list.Set( "OverlayMaterials", "froested",		{ Material = "models/props_c17/frostedglass_01a", Icon = "models/props_c17/frostedglass_01a" } )
list.Set( "OverlayMaterials", "tankglass",		{ Material = "models/props_lab/Tank_Glass001", Icon = "models/props_lab/Tank_Glass001" } )
list.Set( "OverlayMaterials", "globe",			{ Material = "models/props_combine/tprings_globe", Icon = "models/props_combine/tprings_globe" } )
list.Set( "OverlayMaterials", "fisheye",		{ Material = "models/props_c17/fisheyelens", Icon = "models/props_c17/fisheyelens" } )
list.Set( "OverlayMaterials", "rendertarget",	{ Material = "models/overlay_rendertarget", Icon = "models/overlay_rendertarget" } )

list.Set( "PostProcess", "Overlay",
{
	category = "Overlay",
	
	func = function( content )
	
		for k, overlay in pairs( list.Get( "OverlayMaterials" ) ) do
		
			spawnmenu.CreateContentIcon( "postprocess", content, 
			{ 
				name	= "Overlay",
				icon	= overlay.Icon,
				convars = 
				{
					pp_mat_overlay = 
					{
						on = overlay.Material,
						off = ""
					}
				}
			})	
			
		end 
	
	end,

	cpanel		= function( CPanel )

		CPanel:AddControl( "Header", { Text = "#Material_Overlay", Description = "#Material_Overlay_Information" }  )		
		CPanel:AddControl( "Slider", { Label = "#Material_Overlay_RefractAmount", Command = "pp_mat_overlay_refractamount", Type = "Float", Min = "-1", Max = "1" }  )	
		
	end,

	
})