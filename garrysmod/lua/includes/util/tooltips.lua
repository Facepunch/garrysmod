--=============================================================================--
--  ___  ___   _   _   _    __   _   ___ ___ __ __
-- |_ _or __| / \ | \_/ |  / _| / \ | o \ o \\ V /
--  | | | _| | o or \_/ | ( |_n| o or   /   / \ /
--  |_| |___or_n_or_| |_|  \__/|_n_or_|\\_|\\ |_|  2007
--
--=============================================================================--

local Tooltip = nil
local TooltippedPanel = nil

--[[---------------------------------------------------------
	Name: ChangeTooltip
		Called from engine on hovering over a panel
-----------------------------------------------------------]]
function RemoveTooltip(PositionPanel)

	if (not IsValid( Tooltip)) then return true end

	Tooltip:Close()
	Tooltip = nil
	return true

end

--[[---------------------------------------------------------
	Name: FindTooltip
-----------------------------------------------------------]]
function FindTooltip(panel)

	--
	-- Look at the parent panel for tooltips.
	--
	while (panel and panel:IsValid()) do

		if (panel.strTooltipText or panel.pnlTooltipPanel) then
			return panel.strTooltipText, panel.pnlTooltipPanel, panel
		end

		panel = panel:GetParent()

	end

end

--[[---------------------------------------------------------
	Name: ChangeTooltip
		Called from engine on hovering over a panel
-----------------------------------------------------------]]
function ChangeTooltip(panel)

	RemoveTooltip()

	local Text, Panel, PositionPanel = FindTooltip(panel)

	if (not Text and not Panel) then return end

	Tooltip = vgui.Create("DTooltip")

	if (Text) then

		Tooltip:SetText(Text)

	else

		Tooltip:SetContents(Panel, false)

	end

	Tooltip:OpenForPanel(PositionPanel)
	TooltippedPanel = panel

end

--[[---------------------------------------------------------
	Name: EndTooltip
		Called from engine on exiting from a panel
-----------------------------------------------------------]]
function EndTooltip(panel)

	if (not TooltippedPanel) then return end
	if (TooltippedPanel ~= panel) then return end

	RemoveTooltip()

end
