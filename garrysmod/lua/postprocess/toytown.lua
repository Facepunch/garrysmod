
local matToytown = Material( "pp/toytown-top" )
//matToytown:SetTexture( "$fbtexture", render.GetScreenEffectTexture() )

--[[---------------------------------------------------------
	Register the convars that will control this effect
-----------------------------------------------------------]]
local pp_toytown = CreateClientConVar( "pp_toytown", "0", false, false )
local pp_toytown_passes = CreateClientConVar( "pp_toytown_passes", "3", true, false )
local pp_toytown_size = CreateClientConVar( "pp_toytown_size", "0.4", true, false )

function DrawToyTown( NumPasses, H )
	cam.Start2D()

	surface.SetMaterial( matToytown )
	surface.SetDrawColor( 255, 255, 255, 255 )

	for i = 1, NumPasses do

		render.CopyRenderTargetToTexture( render.GetScreenEffectTexture() )

		surface.DrawTexturedRect( 0, 0, ScrW(), H )
		surface.DrawTexturedRectUV( 0, ScrH() - H, ScrW(), H, 0, 1, 1, 0 )

	end

	cam.End2D()
end

local function RenderToyTown()

	local NumPasses = pp_toytown_passes:GetInt()
	local H = math.floor( ScrH() * pp_toytown_size:GetFloat() )

	DrawToyTown( NumPasses, H )

end

cvars.AddChangeCallback( "pp_toytown", function( _, _, newValue )

	if ( !render.SupportsPixelShaders_2_0() ) then return end
	if ( !GAMEMODE:PostProcessPermitted( "toytown" ) ) then return end

	if ( newValue != "0" ) then
		hook.Add( "RenderScreenspaceEffects", "RenderToyTown", RenderToyTown )
	else
		hook.Remove( "RenderScreenspaceEffects", "RenderToyTown" )
	end

end )

list.Set( "PostProcess", "#toytown_pp", {

	icon = "gui/postprocess/toytown.png",
	convar = "pp_toytown",
	category = "#shaders_pp",

	cpanel = function( CPanel )

		CPanel:AddControl( "Header", { Description = "#toytown_pp.desc" } )
		CPanel:AddControl( "CheckBox", { Label = "#toytown_pp.enable", Command = "pp_toytown" } )

		local params = { Options = {}, CVars = {}, MenuButton = "1", Folder = "frame_blend" }
		params.Options[ "#preset.default" ] = { pp_toytown_passes = "3", pp_toytown_size = "0.5" }
		params.CVars = table.GetKeys( params.Options[ "#preset.default" ] )
		CPanel:AddControl( "ComboBox", params )

		CPanel:AddControl( "Slider", { Label = "#toytown_pp.passes", Command = "pp_toytown_passes", Type = "Int", Min = "1", Max = "100" } )
		CPanel:AddControl( "Slider", { Label = "#toytown_pp.height", Command = "pp_toytown_size", Type = "Float", Min = "0", Max = "1" } )

	end

} )
