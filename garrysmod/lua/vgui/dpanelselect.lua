--[[   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

	A list of panels, of which only one can be selected
	
--]]
local PANEL = {}

--[[---------------------------------------------------------
   Name: This function is used as the paint function for 
		   selected buttons.
-----------------------------------------------------------]]
local function DrawSelected( self )

	surface.SetDrawColor( 255, 200, 0, 255 )
	
	for i=2, 3 do
		surface.DrawOutlinedRect( i, i, self:GetWide()-i*2, self:GetTall()-i*2 )
	end

end

--[[---------------------------------------------------------
   Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

	self:EnableHorizontal( true )
	self:EnableVerticalScrollbar()
	self:SetSpacing( 2 )
	self:SetPadding( 2 )

end

--[[---------------------------------------------------------
   Name: AddPanel
-----------------------------------------------------------]]
function PANEL:AddPanel( pnl, tblConVars )

	pnl.tblConVars = tblConVars
	pnl.DoClick = function() self:SelectPanel( pnl ) end
	
	self:AddItem( pnl )
	
	self:FindBestActive()

end

--[[---------------------------------------------------------
   Name: OnActivePanelChanged
-----------------------------------------------------------]]
function PANEL:OnActivePanelChanged( pnlOld, pnlNew )

	-- For override

end

--[[---------------------------------------------------------
   Name: SelectPanel
-----------------------------------------------------------]]
function PANEL:SelectPanel( pnl )

	self:OnActivePanelChanged( self.SelectedPanel, pnl )

	if ( self.SelectedPanel ) then
		self.SelectedPanel.PaintOver = nil
		self.SelectedPanel = nil
	end
	
	-- Run all the convars, if it has any..
	if ( pnl.tblConVars ) then
		for k, v in pairs( pnl.tblConVars ) do RunConsoleCommand( k, v ) end
	end
	
	self.SelectedPanel = pnl
	
	if ( self.SelectedPanel ) then
		self.SelectedPanel.PaintOver = DrawSelected
	end

end

--[[---------------------------------------------------------
   Name: FindBestActive
-----------------------------------------------------------]]
function PANEL:FindBestActive()

	-- Select the item that resembles the chosen panel the closest
	local BestCandidate = nil
	local BestNumMatches = 0
	
	for id, panel in pairs( self:GetItems() ) do
	
		local ItemMatches = 0
		if ( panel.tblConVars ) then
			for key, value in pairs( panel.tblConVars ) do
				if ( GetConVarString( key ) == tostring(value) ) then ItemMatches = ItemMatches + 1 end
			end
		end
		
		if ( ItemMatches > BestNumMatches ) then
			BestCandidate = panel
			BestNumMatches = ItemMatches
		end
	
	end
	
	if ( BestCandidate ) then
		self:SelectPanel( BestCandidate )
	end

end


derma.DefineControl( "DPanelSelect", "", PANEL, "DPanelList" )