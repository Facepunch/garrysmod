
--
-- This works - but I'm not certain that it's the way to go about it.
-- better instead to use the right click properties?
--

TOOL.AddToMenu = false

TOOL.Category = "Construction"
TOOL.Name = "#tool.editentity.name"

function TOOL:LeftClick( trace )

	if ( !trace.Hit ) then return false end

	self.Weapon:SetTargetEntity1( trace.Entity )

	return true
	
end

function TOOL:RightClick( trace )

	return self:LeftClick( trace )
	
end

function TOOL:Think()

	local CurrentEditing = self.Weapon:GetTargetEntity1()

	if ( CLIENT && self.LastEditing != CurrentEditing ) then

		self.LastEditing = CurrentEditing

		local CPanel = controlpanel.Get( "editentity" )
		if ( !CPanel ) then return end

		CPanel:ClearControls()
		self.BuildCPanel( CPanel, CurrentEditing )

	end
	
end

function TOOL.BuildCPanel( CPanel, ent )

	local control = vgui.Create( "DEntityProperties" )
	control:SetEntity( ent )
	control:SetSize( 10, 500 )

	CPanel:AddPanel( control )

end
