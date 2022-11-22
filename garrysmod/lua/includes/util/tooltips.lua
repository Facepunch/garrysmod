
local Tooltip = nil
local TooltippedPanel = nil

--[[---------------------------------------------------------
	Name: ChangeTooltip
	Called from engine on hovering over a panel
-----------------------------------------------------------]]
function RemoveTooltip()

	if ( !IsValid( Tooltip ) ) then return true end

	Tooltip:Close()
	Tooltip = nil

	return true

end

--[[---------------------------------------------------------
	Name: FindTooltip
-----------------------------------------------------------]]
function FindTooltip( panel )

	-- Look at the parent panel for tooltips.
	while ( IsValid( panel ) ) do

		if ( panel.strTooltipText || panel.pnlTooltipPanel || panel.pnlTooltipPanelOverride ) then
			return panel.strTooltipText, panel.pnlTooltipPanel, panel, panel.pnlTooltipPanelOverride
		end

		panel = panel:GetParent()

	end

end

--[[---------------------------------------------------------
	Name: ChangeTooltip
	Called from engine on hovering over a panel
-----------------------------------------------------------]]
function ChangeTooltip( panel )

	RemoveTooltip()

	local Text, ContentPanel, PositionPanel, PanelOverride = FindTooltip( panel )
	if ( !Text && !IsValid( ContentPanel ) && !PanelOverride ) then return end

	Tooltip = vgui.Create( PanelOverride or "DTooltip" )

	if ( Text ) then

		Tooltip:SetText( Text )

	elseif ( IsValid( ContentPanel ) ) then

		Tooltip:SetContents( ContentPanel, false )

	end

	Tooltip:OpenForPanel( PositionPanel )
	TooltippedPanel = panel

end

--[[---------------------------------------------------------
	Name: EndTooltip
	Called from engine on exiting from a panel
-----------------------------------------------------------]]
function EndTooltip( panel )

	-- Don't do these checks, the engine has a problem with determing
	-- which panel is currently being hovered in some very specific and unknown conditions

	--if ( !IsValid( TooltippedPanel ) ) then return end
	--if ( TooltippedPanel != panel ) then return end

	RemoveTooltip()

end
