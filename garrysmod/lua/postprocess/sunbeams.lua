
local matSunbeams = Material( "pp/sunbeams" )
matSunbeams:SetTexture( "$fbtexture", render.GetScreenEffectTexture() )

--[[---------------------------------------------------------
	Register the convars that will control this effect
-----------------------------------------------------------]]
local pp_sunbeams = CreateClientConVar( "pp_sunbeams", "0", false, false )
local pp_sunbeams_darken = CreateClientConVar( "pp_sunbeams_darken", "0.95", true, false )
local pp_sunbeams_multiply = CreateClientConVar( "pp_sunbeams_multiply", "1.0", true, false )
local pp_sunbeams_sunsize = CreateClientConVar( "pp_sunbeams_sunsize", "0.075", true, false )


function DrawSunbeams( darken, multiply, sunsize, sunx, suny )

	if ( !render.SupportsPixelShaders_2_0() ) then return end

	render.CopyRenderTargetToTexture( render.GetScreenEffectTexture() )

	matSunbeams:SetFloat( "$darken", darken )
	matSunbeams:SetFloat( "$multiply", multiply )
	matSunbeams:SetFloat( "$sunx", sunx )
	matSunbeams:SetFloat( "$suny", suny )
	matSunbeams:SetFloat( "$sunsize", sunsize )

	render.SetMaterial( matSunbeams )
	render.DrawScreenQuad()

end

hook.Add( "RenderScreenspaceEffects", "RenderSunbeams", function()

	if ( !pp_sunbeams:GetBool() ) then return end
	if ( !GAMEMODE:PostProcessPermitted( "sunbeams" ) ) then return end
	if ( !render.SupportsPixelShaders_2_0() ) then return end

	local sun = util.GetSunInfo()

	if ( !sun ) then return end
	if ( sun.obstruction == 0 ) then return end

	local sunpos = EyePos() + sun.direction * 4096
	local scrpos = sunpos:ToScreen()

	local dot = ( sun.direction:Dot( EyeVector() ) - 0.8 ) * 5
	if ( dot <= 0 ) then return end

	DrawSunbeams( pp_sunbeams_darken:GetFloat(), pp_sunbeams_multiply:GetFloat() * dot * sun.obstruction, pp_sunbeams_sunsize:GetFloat(), scrpos.x / ScrW(), scrpos.y / ScrH() )

end )

list.Set( "PostProcess", "#sunbeams_pp", {

	icon = "gui/postprocess/sunrays.png",
	convar = "pp_sunbeams",
	category = "#shaders_pp",

	cpanel = function( CPanel )

		CPanel:Help( "#sunbeams_pp.desc" )
		CPanel:CheckBox( "#sunbeams_pp.enable", "pp_sunbeams" )

		local options = {
			pp_sunbeams = "0",
			pp_sunbeams_darken = "0.95",
			pp_sunbeams_multiply = "1",
			pp_sunbeams_sunsize = "0.075"
		}
		CPanel:ToolPresets( "sunbeams", options )

		CPanel:NumSlider( "#sunbeams_pp.multiply", "pp_sunbeams_multiply", 0, 1 )
		CPanel:NumSlider( "#sunbeams_pp.darken", "pp_sunbeams_darken", 0, 1 )
		CPanel:NumSlider( "#sunbeams_pp.size", "pp_sunbeams_sunsize", 0.01, 0.25 )

	end

} )
