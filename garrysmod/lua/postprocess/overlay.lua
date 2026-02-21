
--[[---------------------------------------------------------
	Register the convars that will control this effect
-----------------------------------------------------------]]
local pp_mat_overlay = CreateClientConVar( "pp_mat_overlay", "", false, false )
local pp_mat_overlay_refractamount = CreateClientConVar( "pp_mat_overlay_refractamount", "0.3", true, false )

local lastTexture = nil
local mat_Overlay = nil

function DrawMaterialOverlay( texture, refractamount )

	if ( texture ~= lastTexture or mat_Overlay == nil ) then
		mat_Overlay = Material( texture )
		lastTexture = texture
	end

	if ( mat_Overlay == nil || mat_Overlay:IsError() ) then return end

	render.UpdateScreenEffectTexture()

	// FIXME: Changing refract amount affects textures used in the map/models.
	mat_Overlay:SetFloat( "$envmap", 0 )
	mat_Overlay:SetFloat( "$envmaptint", 0 )
	mat_Overlay:SetFloat( "$refractamount", refractamount )
	mat_Overlay:SetInt( "$ignorez", 1 )

	render.SetMaterial( mat_Overlay )
	render.DrawScreenQuad( true )

end

hook.Add( "RenderScreenspaceEffects", "RenderMaterialOverlay", function()

	local overlay = pp_mat_overlay:GetString()

	if ( overlay == "" ) then return end
	if ( !GAMEMODE:PostProcessPermitted( "material overlay" ) ) then return end

	DrawMaterialOverlay( overlay, pp_mat_overlay_refractamount:GetFloat() )

end )

list.Set( "OverlayMaterials", "#overlay_pp.binocoverlay", { Material = "effects/combine_binocoverlay", Icon = "effects/combine_binocoverlay" } )
list.Set( "OverlayMaterials", "#overlay_pp.waterfall", { Material = "models/shadertest/shader3", Icon = "models/shadertest/shader3" } )
list.Set( "OverlayMaterials", "#overlay_pp.jelly", { Material = "models/shadertest/shader4", Icon = "models/shadertest/shader4" } )
list.Set( "OverlayMaterials", "#overlay_pp.stainedglass", { Material = "models/shadertest/shader5", Icon = "models/shadertest/shader5" } )
list.Set( "OverlayMaterials", "#overlay_pp.statis", { Material = "models/props_combine/stasisshield_sheet", Icon = "models/props_combine/stasisshield_sheet" } )
list.Set( "OverlayMaterials", "#overlay_pp.shield", { Material = "models/props_combine/com_shield001a", Icon = "models/props_combine/com_shield001a" } )
list.Set( "OverlayMaterials", "#overlay_pp.froested", { Material = "models/props_c17/frostedglass_01a", Icon = "models/props_c17/frostedglass_01a" } )
list.Set( "OverlayMaterials", "#overlay_pp.tankglass", { Material = "models/props_lab/tank_glass001", Icon = "models/props_lab/tank_glass001" } )
list.Set( "OverlayMaterials", "#overlay_pp.waves", { Material = "models/props_combine/tprings_globe", Icon = "models/props_combine/tprings_globe" } )
list.Set( "OverlayMaterials", "#overlay_pp.fisheye", { Material = "models/props_c17/fisheyelens", Icon = "models/props_c17/fisheyelens" } )
list.Set( "OverlayMaterials", "#overlay_pp.rendertarget", { Material = "models/overlay_rendertarget", Icon = "models/overlay_rendertarget" } )
list.Set( "OverlayMaterials", "#overlay_pp.strider_pinch_dudv", { Material = "effects/strider_pinch_dudv", Icon = "effects/strider_pinch_dudv" } )
list.Set( "OverlayMaterials", "#overlay_pp.teleport", { Material = "effects/tp_eyefx/tpeye", Icon = "effects/tp_eyefx/tpeye" } )
list.Set( "OverlayMaterials", "#overlay_pp.teleport2", { Material = "effects/tp_eyefx/tpeye2", Icon = "effects/tp_eyefx/tpeye2" } )
list.Set( "OverlayMaterials", "#overlay_pp.teleport3", { Material = "effects/tp_eyefx/tpeye3", Icon = "effects/tp_eyefx/tpeye3" } )
list.Set( "OverlayMaterials", "#overlay_pp.tvnoise", { Material = "effects/tvscreen_noise002a", Icon = "effects/tvscreen_noise002a" } )
list.Set( "OverlayMaterials", "#overlay_pp.water_warp01", { Material = "effects/water_warp01", Icon = "effects/water_warp01" } )

if ( IsMounted( "tf" ) ) then
	list.Set( "OverlayMaterials", "#overlay_pp.jarate", { Material = "effects/jarate_overlay", Icon = "effects/jarate_overlay" } )
	list.Set( "OverlayMaterials", "#overlay_pp.invuln_overlay_red", { Material = "effects/invuln_overlay_red", Icon = "effects/invuln_overlay_red" } )
	list.Set( "OverlayMaterials", "#overlay_pp.invuln_overlay_blu", { Material = "effects/invuln_overlay_blue", Icon = "effects/invuln_overlay_blue" } )
	list.Set( "OverlayMaterials", "#overlay_pp.water_warp", { Material = "effects/water_warp", Icon = "effects/water_warp" } )
	list.Set( "OverlayMaterials", "#overlay_pp.bleed_overlay", { Material = "effects/bleed_overlay", Icon = "effects/bleed_overlay" } )
	list.Set( "OverlayMaterials", "#overlay_pp.bombinomicon_distortion", { Material = "effects/bombinomicon_distortion", Icon = "effects/bombinomicon_distortion" } )
	list.Set( "OverlayMaterials", "#overlay_pp.dodge_overlay", { Material = "effects/dodge_overlay", Icon = "effects/dodge_overlay" } )
	list.Set( "OverlayMaterials", "#overlay_pp.distortion_normal", { Material = "effects/distortion_normal001", Icon = "effects/distortion_normal001" } )
end

list.Set( "PostProcess", "#overlay_pp", {

	category = "#overlay_pp",

	func = function( content )

		for k, overlay in pairs( list.Get( "OverlayMaterials" ) ) do

			spawnmenu.CreateContentIcon( "postprocess", content, {
				name = "#overlay_pp",
				label = k,
				icon = overlay.Icon,
				convars = {
					pp_mat_overlay = {
						on = overlay.Material,
						off = ""
					}
				}
			} )

		end

	end,

	cpanel = function( CPanel )

		CPanel:Help( "#overlay_pp.desc" )

		CPanel:ToolPresets( "overlay", { pp_mat_overlay_refractamount = "0.3" } )

		CPanel:NumSlider( "#overlay_pp.refract", "pp_mat_overlay_refractamount", -1, 1 )

	end

} )
