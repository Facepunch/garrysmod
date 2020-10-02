
--[[---------------------------------------------------------
	Register the convars that will control this effect
-----------------------------------------------------------]]
local pp_stereoscopy = CreateClientConVar( "pp_stereoscopy", "0", false, false )
local pp_stereoscopy_size = CreateClientConVar( "pp_stereoscopy_size", "6", true, false, nil, -11.5, 11.5 )

--[[---------------------------------------------------------
	Can be called from engine or hooks using bloom.Draw
-----------------------------------------------------------]]
function RenderStereoscopy( ViewOrigin, ViewAngles )

	render.Clear( 0, 0, 0, 255 )

	local w = ScrW() / 2.2
	local h = ScrH() / 2.2

	local Right = ViewAngles:Right() * pp_stereoscopy_size:GetFloat()

	local view = {}

	view.y = ScrH() / 2 - h / 2
	view.w = w
	view.h = h
	view.angles = ViewAngles

	-- Left
	view.x = ScrW() / 2 - w - 10
	view.origin = ViewOrigin + Right
	render.RenderView( view )

	-- Right
	view.x = ScrW() / 2 + 10
	view.origin = ViewOrigin - Right
	render.RenderView( view )

end

--[[---------------------------------------------------------
	The function to draw the bloom (called from the hook)
-----------------------------------------------------------]]
hook.Add( "RenderScene", "RenderStereoscopy", function( ViewOrigin, ViewAngles, ViewFOV )

	if ( !pp_stereoscopy:GetBool() ) then return end

	RenderStereoscopy( ViewOrigin, ViewAngles )

	-- Return true to override drawing the scene
	return true

end )

list.Set( "PostProcess", "#stereoscopy_pp", {

	icon = "gui/postprocess/stereoscopy.png",
	convar = "pp_stereoscopy",
	category = "#effects_pp",

	cpanel = function( CPanel )

		CPanel:AddControl( "Header", { Description = "#stereoscopy_pp.desc" } )
		CPanel:AddControl( "CheckBox", { Label = "#stereoscopy_pp.enable", Command = "pp_stereoscopy" } )

		local params = { Options = {}, CVars = {}, MenuButton = "1", Folder = "stereoscopy" }
		params.Options[ "#preset.default" ] = { pp_stereoscopy_size = "6" }
		params.CVars = table.GetKeys( params.Options[ "#preset.default" ] )
		CPanel:AddControl( "ComboBox", params )

		CPanel:AddControl( "Slider", { Label = "#stereoscopy_pp.size", Command = "pp_stereoscopy_size", Type = "Float", Min = "0", Max = "10" } )

	end

} )
