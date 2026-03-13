
--[[---------------------------------------------------------
	GetResolvedFullFrameDepth Material Proxy
		Returns `true` in `GM:NeedsDepthPass()` while any
		materials with this proxy are active (and returns
		`render.GetResolvedFullFrameDepth()` via `resultVar`).

		In most cases this is only when the material with the
		proxy is currently visible on screen.

	Params:
		- resultvar
			The VMT parameter to which the screen effect texture
			should be supplied
-----------------------------------------------------------]]

local NEED_DEPTH_PASS = false

matproxy.Add( {
	name = "GetResolvedFullFrameDepth",

	init = function( self, mat, values )
		-- Store the name of the texture variable we want to set
		self.DepthTexVar = values.resultvar
	end,

	bind = function( self, mat, ent )
		-- Mark depth as needing update
		NEED_DEPTH_PASS = true
		-- Set the parameter specified via `resultvar` to `render.GetResolvedFullFrameDepth()`
		mat:SetTexture( self.DepthTexVar, render.GetResolvedFullFrameDepth() )
	end
} )

hook.Add( "NeedsDepthPass", "MatProxy.GetResolvedFullFrameDepth.NeedsDepthPass", function()
	-- If `true`, set `NEED_DEPTH_PASS` back to `false` and perform depth pass
	if ( NEED_DEPTH_PASS ) then
		NEED_DEPTH_PASS = false
		return true
	end
end )
