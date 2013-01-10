
TOOL.Category		= "Constraints"
TOOL.Name			= "#tool.elastic.name"
TOOL.Command		= nil
TOOL.ConfigName		= nil


TOOL.ClientConVar[ "constant" ] = "500"
TOOL.ClientConVar[ "damping" ] = "3"
TOOL.ClientConVar[ "rdamping" ] = "0.01"
TOOL.ClientConVar[ "material" ] = "cable/cable"
TOOL.ClientConVar[ "width" ] = "2"
TOOL.ClientConVar[ "stretch_only" ] = "1"

function TOOL:LeftClick( trace )

	if ( trace.Entity:IsValid() && trace.Entity:IsPlayer() ) then return end
	
	-- If there's no physics object then we can't constraint it!
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end
	
	local iNum = self:NumObjects()

	local Phys = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone )
	self:SetObject( iNum + 1, trace.Entity, trace.HitPos, Phys, trace.PhysicsBone, trace.HitNormal )
	
	if ( iNum > 0 ) then
	
		if ( CLIENT ) then
		
			self:ClearObjects()
			return true
			
		end
		
		-- Get client's CVars
		local constant		= self:GetClientNumber( "constant" )
		local damping		= self:GetClientNumber( "damping" )
		local rdamping		= self:GetClientNumber( "rdamping" )
		local material 		= self:GetClientInfo( "material" )
		local width 		= self:GetClientNumber( "width" )
		local stretchonly	= self:GetClientNumber( "stretch_only" )
		
		-- Get information we're about to use
		local Ent1,  Ent2  = self:GetEnt(1),	 	self:GetEnt(2)
		local Bone1, Bone2 = self:GetBone(1),	 	self:GetBone(2)
		local LPos1, LPos2 = self:GetLocalPos(1),	self:GetLocalPos(2)
		local constraint, rope = constraint.Elastic( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, constant, damping, rdamping, material, width, stretchonly )

		-- Add The constraint to the players undo table

		undo.Create("Elastic")
		undo.AddEntity( constraint )
		if rope then undo.AddEntity( rope ) end
		undo.SetPlayer( self:GetOwner() )
		undo.Finish()
		
		self:GetOwner():AddCleanup( "ropeconstraints", constraint )
		if rope then self:GetOwner():AddCleanup( "ropeconstraints", rope ) end

		-- Clear the objects so we're ready to go again
		self:ClearObjects()
	
	else
	
		self:SetStage( iNum+1 )
	
	end
	
	return true

end

function TOOL:Reload( trace )

	if (!trace.Entity:IsValid() || trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end
	
	local  bool = constraint.RemoveConstraints( trace.Entity, "Elastic" )
	return bool
	
end

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Text = "#tool.elastic.name", Description	= "#tool.elastic.help" }  )
	
	CPanel:AddControl( "ComboBox", { Label = "#tool.presets",
									 MenuButton = 1,
									 Folder = "elastic",
									 Options = { Default = { elastic_constant = '500',	elastic_damping='3',	elastic_rdamping='0.01',		elastic_material='cable/cable',		elastic_width='2',		elastic_stretch_only="1" } },
									 CVars =				{ "elastic_constant",		"elastic_damping",		"elastic_rdamping",			"elastic_material",					"elastic_width",		"elastic_stretch_only" } } )

	CPanel:AddControl( "Slider", 		{ Label = "#tool.elastic.constant",		Type = "Float", 	Command = "elastic_constant", 	Min = "0", 	Max = "4000", Help=true }  )
	CPanel:AddControl( "Slider", 		{ Label = "#tool.elastic.damping",		Type = "Float", 	Command = "elastic_damping", 	Min = "0", 	Max = "50", Help=true }  )
	CPanel:AddControl( "Slider", 		{ Label = "#tool.elastic.rdamping",		Type = "Float", 	Command = "elastic_rdamping", 	Min = "0", 	Max = "1", Help=true }  )
	CPanel:AddControl( "CheckBox",		{ Label = "#tool.elastic.stretchonly",	Command = "elastic_stretch_only", Help=true }  )

	CPanel:AddControl( "Slider", 		{ Label = "#tool.elastic.width",		Type = "Float", 	Command = "elastic_width", 		Min = "0", 	Max = "20" }  )
	CPanel:AddControl( "RopeMaterial", 	{ Label = "#tool.elastic.material",		convar	= "elastic_material" }  )
	
									
end