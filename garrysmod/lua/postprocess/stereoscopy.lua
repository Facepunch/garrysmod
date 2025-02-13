
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

cvars.AddChangeCallback( "pp_stereoscopy", function( _, _, newValue )

	if ( !GAMEMODE:PostProcessPermitted( "stereoscopy" ) ) then return end

	if ( newValue != "0" ) then
		hook.Add( "RenderScene", "RenderStereoscopy", function(ViewOrigin, ViewAngles)

			RenderStereoscopy( ViewOrigin, ViewAngles )

			-- Return true to override drawing the scene
			return true

		end)
	else
		hook.Remove( "RenderScene", "RenderStereoscopy" )
	end

end )

list.Set( "PostProcess", "#stereoscopy_pp", {

	icon = "gui/postprocess/stereoscopy.png",
	convar = "pp_stereoscopy",
	category = "#effects_pp",

	cpanel = function( CPanel )

		CPanel:Help( "#stereoscopy_pp.desc" )
		CPanel:CheckBox( "#stereoscopy_pp.enable", "pp_stereoscopy" )

		CPanel:ToolPresets( "stereoscopy", { pp_stereoscopy_size = "6" } )

		CPanel:NumSlider( "#stereoscopy_pp.size", "pp_stereoscopy_size", 0, 10 )

	end

} )
