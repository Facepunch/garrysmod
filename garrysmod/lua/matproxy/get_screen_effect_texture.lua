
--[[---------------------------------------------------------
	GetScreenEffectTexture Material Proxy
		Returns `render.GetScreenEffectTexture()` via `resultVar`.

		In most cases this is only when the material with the
		proxy is currently visible on screen.

		Depending on when the material is getting rendered this may still
		cause problems, but that should be relatively easy to diagnose
		(model halos seem to be the only "breaking" issue worth a
		direct patch).

	Params:
		- `updateimmediately`
			- Set this to nothing (or `0`) to mark the screen effect texture as dirty,
				waiting for the next `GM:RenderScreenspaceEffects()` call to update
				it (asynchronous).
			- Set this to `1` to perform immediate screen effect texture updates
				for this material (synchronous). This is necessary for some screenspace
				overlays, such as `g_bokehblur`.
			- Set this to `2` for the same behavior as `1`, but when your material can
				and/or will be used for rendering model halos (such as being grabbed by
				the physgun) to avoid turning the entire screen black.
		- `resultvar`
			The VMT parameter to which the screen effect texture should
			be supplied
-----------------------------------------------------------]]

-- Update the screen effect texture in `GM:RenderScreenspaceEffects()` this frame (or next frame, depending on context)?
local NEED_SCREEN_TEXTURE_UPDATE = false
-- The screen will go totally black if an attempt is made to update the screen effect texture while drawing halos,
-- hence `updateimmediately` configuration `2`
local DRAWING_HALOS = false

matproxy.Add( {
	name = "GetScreenEffectTexture",

	init = function( self, mat, values )
		-- Update screen effect texture when the material is drawn, rather than later?
		-- Options are 0, 1 and 2
		self.UpdateImmediately = math.floor( math.Clamp( tonumber( values.updateimmediately ) || 0, 0, 2 ) )
		-- Store the name of the texture variable we want to set
		self.ScreenEffectTexVar = values.resultvar
	end,

	bind = function( self, mat, ent )
		-- If `UpdateImmediately` is `1`, update the screen effect texture;
		-- If `UpdateImmediately` is `2` and we're not drawing halos, update the screen effect texture;
		-- Else, mark the screen texture as dirty and update it later
		if ( self.UpdateImmediately == 0 ) then
			NEED_SCREEN_TEXTURE_UPDATE = true
		elseif ( self.UpdateImmediately == 1 || ( self.UpdateImmediately == 2 && !DRAWING_HALOS ) ) then
			render.UpdateScreenEffectTexture()
		end
		-- Set the parameter specified via `resultvar` to `render.GetScreenEffectTexture()`
		mat:SetTexture( self.ScreenEffectTexVar, render.GetScreenEffectTexture() )
	end
} )

hook.Add( "PreDrawHalos", "MatProxy.GetScreenEffectTexture.PreDrawHalos", function()
	DRAWING_HALOS = true
end )

hook.Add( "PreDrawHUD", "MatProxy.GetScreenEffectTexture.PreDrawHUD", function()
	DRAWING_HALOS = false
end )

hook.Add( "RenderScreenspaceEffects", "MatProxy.GetScreenEffectTexture.RenderScreenspaceEffects", function()
	-- If `true`, set `NEED_SCREEN_TEXTURE_UPDATE` back to `false` and perform a screen effect texture update
	if ( NEED_SCREEN_TEXTURE_UPDATE ) then
		render.UpdateScreenEffectTexture()
		NEED_SCREEN_TEXTURE_UPDATE = false
	end
end )
