
TOOL.Category		= "Constraints"
TOOL.Name			= "#tool.pulley.name"
TOOL.Command		= nil
TOOL.ConfigName		= nil


TOOL.ClientConVar[ "width" ] = "3"
TOOL.ClientConVar[ "forcelimit" ] = "0"
TOOL.ClientConVar[ "rigid" ] = "0"
TOOL.ClientConVar[ "material" ] = "cable/cable"

function TOOL:LeftClick( trace )

	-- If there's no physics object then we can't constraint it!
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end

	local iNum = self:NumObjects()

	if ( trace.Entity:IsValid() && trace.Entity:IsPlayer() ) then return end
	if ( !trace.Entity:IsValid() && ( iNum == nil || iNum == 0 || iNum > 2 ) ) then return end

	local Phys = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone )
	self:SetObject( iNum + 1, trace.Entity, trace.HitPos, Phys, trace.PhysicsBone, trace.HitNormal )

	if ( iNum > 2 ) then
	
		if ( CLIENT ) then return true end
		
		local width			= self:GetClientNumber( "width" )
		local forcelimit	= self:GetClientNumber( "forcelimit" )
		local rigid			= util.tobool( self:GetClientNumber( "rigid" ) )
		local material		= self:GetClientInfo( "material" )
		
		-- Get information we're about to use
		local Ent1 = self:GetEnt(1)
		local Ent4 = self:GetEnt(4)
		local Bone1 = self:GetBone(1)
		local Bone4 = self:GetBone(4)
		local LPos1 = self:GetLocalPos(1)
		local LPos4 = self:GetLocalPos(4)
		local WPos2 = self:GetPos(2)
		local WPos3 = self:GetPos(3)

		local constraint = constraint.Pulley( Ent1, Ent4, Bone1, Bone4, LPos1, LPos4, WPos2, WPos3, forcelimit, rigid, width, material )

		undo.Create("Pulley")
		undo.AddEntity( constraint )
		undo.SetPlayer( self:GetOwner() )
		undo.Finish()
		
		self:GetOwner():AddCleanup( "ropeconstraints", constraint )

		self:ClearObjects()

	elseif ( iNum == 2 ) then

		self:SetStage( iNum+1 )
		
	elseif ( iNum == 1 ) then

		self:SetStage( iNum+1 )
		
	else

		self:SetStage( iNum+1 )
		
	end
	
	return true

end

function TOOL:Reload( trace )

	if (!trace.Entity:IsValid() || trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end
	
	local  bool = constraint.RemoveConstraints( trace.Entity, "Pulley" )
	return bool
	
end

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Text = "#tool.pulley.name", Description	= "#tool.pulley.help" }  )
	
	CPanel:AddControl( "ComboBox", { 

			Label = "#tool.presets",
			MenuButton = 1,
			Folder = "pulley",
			Options =	{ Default = {	pulley_forcelimit = '0',		pulley_width='2',		pulley_rigid='0',		pulley_material='cable/cable' } },
			CVars =		{				"pulley_forcelimit",			"pulley_width",			"pulley_rigid",			"pulley_material" } 
									})

	CPanel:AddControl( "Slider", 		{ Label = "#tool.forcelimit",		Type = "Float", 	Command = "pulley_forcelimit", 	Min = "0", 	Max = "1000", Help=true }  )
	CPanel:AddControl( "CheckBox",		{ Label = "#tool.pulley.rigid",		Command = "pulley_rigid", Help=true }  )

	CPanel:AddControl( "Slider", 		{ Label = "#tool.pulley.width",		Type = "Float", 	Command = "pulley_width", 		Min = "0", 	Max = "10" }  )
	CPanel:AddControl( "RopeMaterial", 	{ Label = "#tool.pulley.material",		convar	= "pulley_material" }  )
									
end