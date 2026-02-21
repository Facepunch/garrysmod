
--[[---------------------------------------------------------
   Name: gamemode:ShowTeam()
   Desc:
-----------------------------------------------------------]]
function GM:ShowTeam()

	if ( IsValid( self.TeamSelectFrame ) ) then return end
	
	-- Simple team selection box
	self.TeamSelectFrame = vgui.Create( "DFrame" )
	self.TeamSelectFrame:SetTitle( "Pick Team" )
	
	local AllTeams = team.GetAllTeams()
	local y = 30
	for ID, TeamInfo in pairs ( AllTeams ) do
	
		if ( ID != TEAM_CONNECTING && ID != TEAM_UNASSIGNED ) then
	
			local Team = vgui.Create( "DButton", self.TeamSelectFrame )
			function Team.DoClick() self:HideTeam() RunConsoleCommand( "changeteam", ID ) end
			Team:SetPos( 10, y )
			Team:SetSize( 130, 20 )
			Team:SetText( TeamInfo.Name )
			
			if ( IsValid( LocalPlayer() ) && LocalPlayer():Team() == ID ) then
				Team:SetEnabled( false )
			end
			
			y = y + 30
		
		end
		
	end

	if ( GAMEMODE.AllowAutoTeam ) then
	
		local Team = vgui.Create( "DButton", self.TeamSelectFrame )
		function Team.DoClick() self:HideTeam() RunConsoleCommand( "autoteam" ) end
		Team:SetPos( 10, y )
		Team:SetSize( 130, 20 )
		Team:SetText( "Auto" )
		y = y + 30
	
	end
	
	self.TeamSelectFrame:SetSize( 150, y )
	self.TeamSelectFrame:Center()
	self.TeamSelectFrame:MakePopup()
	self.TeamSelectFrame:SetKeyboardInputEnabled( false )

end

--[[---------------------------------------------------------
   Name: gamemode:HideTeam()
   Desc:
-----------------------------------------------------------]]
function GM:HideTeam()

	if ( IsValid(self.TeamSelectFrame) ) then
		self.TeamSelectFrame:Remove()
		self.TeamSelectFrame = nil
	end

end
