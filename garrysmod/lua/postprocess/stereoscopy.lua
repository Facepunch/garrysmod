
--[[---------------------------------------------------------
   Register the convars that will control this effect
-----------------------------------------------------------]]   
local pp_stereoscopy			= CreateClientConVar( "pp_stereoscopy", "0", false, false )				-- On/Off
local pp_stereoscopy_size		= CreateClientConVar( "pp_stereoscopy_size", "6", false, false )


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
local function DrawInternal( ViewOrigin, ViewAngles, ViewFOV )

	if ( !pp_stereoscopy:GetBool() ) then return end

	RenderStereoscopy( ViewOrigin, ViewAngles )
				
	-- Return true to override drawing the scene
	return true

end



hook.Add( "RenderScene", "RenderStereoscopy", DrawInternal )

list.Set( "PostProcess", "Stereoscopy",
{
	icon		= "gui/postprocess/stereoscopy.png",
	
	convar		= "pp_stereoscopy",
	
	category	= "Effects"
	
})