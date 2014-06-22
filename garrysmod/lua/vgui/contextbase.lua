
local PANEL = {}

local Padding = 5

--[[---------------------------------------------------------
   Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

	self.Label = vgui.Create( "DLabel", self )
	self.Label:SetText( "" )
	self.Label:SetDark( true )

end

--[[---------------------------------------------------------
   Name: SetConVar
-----------------------------------------------------------]]
function PANEL:SetConVar( cvar )
	self.ConVarValue = cvar
end

--[[---------------------------------------------------------
   Name: ConVar
-----------------------------------------------------------]]
function PANEL:ConVar()
	return self.ConVarValue
end

--[[---------------------------------------------------------
   Name: ControlValues
-----------------------------------------------------------]]
function PANEL:ControlValues( kv )

	self:SetConVar( kv.convar or "" )
	self.Label:SetText( kv.label or "" )

end

--[[---------------------------------------------------------
   Name: PerformLayout
-----------------------------------------------------------]]
function PANEL:PerformLayout()

	local y = 5
	self.Label:SetPos( 5, y )
	self.Label:SetWide( self:GetWide() )
	
	y = y + self.Label:GetTall()
	y = y + 5
	
	return y

end

--[[---------------------------------------------------------
   Name: TestForChanges
-----------------------------------------------------------]]
function PANEL:TestForChanges()

	-- You should override this function and use it to
	-- check whether your convar value changed

end

--[[---------------------------------------------------------
   Name: Think
-----------------------------------------------------------]]
function PANEL:Think()

	if ( self.NextPoll && self.NextPoll > CurTime() ) then return end
	
	self.NextPoll = CurTime() + 0.1
	
	self:TestForChanges()

end


vgui.Register( "ContextBase", PANEL, "Panel" )