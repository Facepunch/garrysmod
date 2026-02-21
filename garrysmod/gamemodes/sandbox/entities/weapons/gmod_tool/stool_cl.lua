
-- Tool should return true if freezing the view angles
function ToolObj:FreezeMovement()
	return false
end

-- The tool's opportunity to draw to the HUD
function ToolObj:DrawHUD()
end

-- Force rebuild the Control Panel
function ToolObj:RebuildControlPanel( ... )

	local cPanel = controlpanel.Get( self.Mode )
	if ( !cPanel ) then ErrorNoHalt( "Couldn't find control panel to rebuild!" ) return end

	cPanel:Clear()
	self.BuildCPanel( cPanel, ... )

end
