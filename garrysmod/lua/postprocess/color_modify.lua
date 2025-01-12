
local mat_ColorMod = Material( "pp/colour" )
mat_ColorMod:SetTexture( "$fbtexture", render.GetScreenEffectTexture() )

--[[---------------------------------------------------------
	Register the convars that will control this effect
-----------------------------------------------------------]]
local pp_colormod = CreateClientConVar( "pp_colormod", "0", false, false )
local pp_colormod_addr = CreateClientConVar( "pp_colormod_addr", "0", true, false )
local pp_colormod_addg = CreateClientConVar( "pp_colormod_addg", "0", true, false )
local pp_colormod_addb = CreateClientConVar( "pp_colormod_addb", "0", true, false )
local pp_colormod_brightness = CreateClientConVar( "pp_colormod_brightness", "0", true, false )
local pp_colormod_contrast = CreateClientConVar( "pp_colormod_contrast", "1", true, false )
local pp_colormod_color = CreateClientConVar( "pp_colormod_color", "1", true, false )
local pp_colormod_mulr = CreateClientConVar( "pp_colormod_mulr", "0", true, false )
local pp_colormod_mulg = CreateClientConVar( "pp_colormod_mulg", "0", true, false )
local pp_colormod_mulb = CreateClientConVar( "pp_colormod_mulb", "0", true, false )
local pp_colormod_inv = CreateClientConVar( "pp_colormod_inv", "0", true, false )

function DrawColorModify( tab )

	render.CopyRenderTargetToTexture( render.GetScreenEffectTexture() )

	for k, v in pairs( tab ) do

		mat_ColorMod:SetFloat( k, v )

	end

	render.SetMaterial( mat_ColorMod )
	render.DrawScreenQuad()

end

hook.Add( "RenderScreenspaceEffects", "RenderColorModify", function()

	if ( !pp_colormod:GetBool() ) then return end
	if ( !GAMEMODE:PostProcessPermitted( "color mod" ) ) then return end

	local tab = {}

	tab[ "$pp_colour_addr" ] = pp_colormod_addr:GetFloat() * 0.02
	tab[ "$pp_colour_addg" ] = pp_colormod_addg:GetFloat() * 0.02
	tab[ "$pp_colour_addb" ] = pp_colormod_addb:GetFloat() * 0.02
	tab[ "$pp_colour_brightness" ] = pp_colormod_brightness:GetFloat()
	tab[ "$pp_colour_contrast" ] = pp_colormod_contrast:GetFloat()
	tab[ "$pp_colour_colour" ] = pp_colormod_color:GetFloat()
	tab[ "$pp_colour_mulr" ] = pp_colormod_mulr:GetFloat() * 0.1
	tab[ "$pp_colour_mulg" ] = pp_colormod_mulg:GetFloat() * 0.1
	tab[ "$pp_colour_mulb" ] = pp_colormod_mulb:GetFloat() * 0.1
	tab[ "$pp_colour_inv" ] = pp_colormod_inv:GetFloat()

	DrawColorModify( tab )

end )

list.Set( "PostProcess", "#colormod_pp", {

	icon = "gui/postprocess/colourmod.png",
	convar = "pp_colormod",
	category = "#shaders_pp",

	cpanel = function( CPanel )

		CPanel:Help( "#colormod_pp.desc" )
		CPanel:CheckBox( "#colormod_pp.enable", "pp_colormod" )

		local params = vgui.Create( "ControlPresets", CPanel )
		local options = {}
		options[ "#preset.default" ] = { 
			pp_colormod_addr = "0",
			pp_colormod_addg = "0",
			pp_colormod_addb = "0",
			pp_colormod_brightness = "0",
			pp_colormod_contrast = "1",
			pp_colormod_color = "1",
			pp_colormod_mulr = "0",
			pp_colormod_mulg = "0",
			pp_colormod_mulb = "0",
			pp_colormod_inv = "0"
		}
		params:SetPreset( "colormod" )
		params:AddOption( "#preset.default", options[ "#preset.default" ] )
		for k, v in pairs( table.GetKeys( options[ "#preset.default" ] ) ) do
			params:AddConVar( v )
		end
		CPanel:AddPanel( params )

		local brightness = CPanel:NumSlider( "#colormod_pp.brightness", "pp_colormod_brightness", -2, 2, 2 )
		local brightnessDefault = GetConVar( "pp_colormod_brightness" )
		if ( brightnessDefault ) then
			brightness:SetDefaultValue( brightnessDefault:GetDefault() )
		end
		local contrast = CPanel:NumSlider( "#colormod_pp.contrast", "pp_colormod_contrast", 0, 10, 2 )
		local contrastDefault = GetConVar( "pp_colormod_contrast" )
		if ( contrastDefault ) then
			contrast:SetDefaultValue( contrastDefault:GetDefault() )
		end
		local color = CPanel:NumSlider( "#colormod_pp.color", "pp_colormod_color", 0, 5, 2 )
		local colorDefault = GetConVar( "pp_colormod_color" )
		if ( colorDefault ) then
			color:SetDefaultValue( colorDefault:GetDefault() )
		end
		local invert = CPanel:NumSlider( "#colormod_pp.invert", "pp_colormod_inv", 0, 1, 2 )
		local invertDefault = GetConVar( "pp_colormod_inv" )
		if ( invertDefault ) then
			invert:SetDefaultValue( invertDefault:GetDefault() )
		end

		local colorAdd = vgui.Create( "CtrlColor", CPanel )
		colorAdd:SetLabel( "#colormod_pp.color_add" )
		colorAdd:SetConVarR( "pp_colormod_addr" )
		colorAdd:SetConVarG( "pp_colormod_addg" )
		colorAdd:SetConVarB( "pp_colormod_addb" )
		CPanel:AddPanel( colorAdd )

		local colorMult = vgui.Create( "CtrlColor", CPanel )
		colorMult:SetLabel( "#colormod_pp.color_multiply" )
		colorMult:SetConVarR( "pp_colormod_mulr" )
		colorMult:SetConVarG( "pp_colormod_mulg" )
		colorMult:SetConVarB( "pp_colormod_mulb" )
		CPanel:AddPanel( colorMult )

	end

} )
