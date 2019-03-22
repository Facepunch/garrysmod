
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

		if ( panel.strTooltipText || panel.pnlTooltipPanel ) then
			return panel.strTooltipText, panel.pnlTooltipPanel, panel
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

	local Text, Panel, PositionPanel = FindTooltip( panel )
	if ( !Text && !IsValid( Panel ) ) then return end

	Tooltip = vgui.Create( "DTooltip" )

	if ( Text ) then

		Tooltip:SetText( Text )

	else

		Tooltip:SetContents( Panel, false )

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
