--=============================================================================--
--  ___  ___   _   _   _    __   _   ___ ___ __ __
-- |_ _|| __| / \ | \_/ |  / _| / \ | o \ o \\ V /
--  | | | _| | o || \_/ | ( |_n| o ||   /   / \ / 
--  |_| |___||_n_||_| |_|  \__/|_n_||_|\\_|\\ |_|  2007
--										 
--=============================================================================--

local Tooltip = nil
local TooltippedPanel = nil

--[[---------------------------------------------------------
	Name: ChangeTooltip
		Called from engine on hovering over a panel
-----------------------------------------------------------]] 
function RemoveTooltip( PositionPanel )

	if ( !IsValid( Tooltip ) ) then return true end
		
	Tooltip:Close()
	Tooltip = nil
	return true

end

--[[---------------------------------------------------------
	Name: FindTooltip
-----------------------------------------------------------]] 
function FindTooltip( panel )

	--
	-- Look at the parent panel for tooltips.
	--
	while ( panel && panel:IsValid() ) do
	
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
	
	if ( !Text && !Panel ) then return end

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

	if ( !TooltippedPanel ) then return end
	if ( TooltippedPanel != panel ) then return end

	RemoveTooltip()

end
