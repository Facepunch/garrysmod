
TOOL.Category		= "Constraints"
TOOL.Name			= "#tool.rope.name"
TOOL.Command		= nil
TOOL.ConfigName		= nil


TOOL.ClientConVar[ "forcelimit" ] = "0"
TOOL.ClientConVar[ "addlength" ] = "0"
TOOL.ClientConVar[ "material" ] = "cable/rope"
TOOL.ClientConVar[ "width" ] = "2"
TOOL.ClientConVar[ "rigid" ] = "0"

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
		local forcelimit = self:GetClientNumber( "forcelimit" )
		local addlength	 = self:GetClientNumber( "addlength" )
		local material 	 = self:GetClientInfo( "material" )
		local width 	 = self:GetClientNumber( "width" ) 
		local rigid	 	= self:GetClientNumber( "rigid" ) == 1
		
		-- Get information we're about to use
		local Ent1,  Ent2  = self:GetEnt(1),	 self:GetEnt(2)
		local Bone1, Bone2 = self:GetBone(1),	 self:GetBone(2)
		local WPos1, WPos2 = self:GetPos(1),	 self:GetPos(2)
		local LPos1, LPos2 = self:GetLocalPos(1),self:GetLocalPos(2)
		local length = ( WPos1 - WPos2):Length()

		local constraint, rope = constraint.Rope( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, length, addlength, forcelimit, width, material, rigid )

		-- Clear the objects so we're ready to go again
		self:ClearObjects()

		-- Add The constraint to the players undo table

		undo.Create("Rope")
		undo.AddEntity( constraint )
		undo.AddEntity( rope )
		undo.SetPlayer( self:GetOwner() )
		undo.Finish()

		self:GetOwner():AddCleanup( "ropeconstraints", constraint )		
		self:GetOwner():AddCleanup( "ropeconstraints", rope )

	else
	
		self:SetStage( iNum+1 )
		
	end

	return true
	
end

function TOOL:RightClick( trace )

	if ( trace.Entity:IsValid() && trace.Entity:IsPlayer() ) then return end

	local iNum = self:NumObjects()

	local Phys = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone )
	self:SetObject( iNum + 1, trace.Entity, trace.HitPos, Phys, trace.PhysicsBone, trace.HitNormal )

	if ( iNum > 0 ) then
	
		if ( CLIENT ) then
		
			self:ClearObjects()
			return true
			
		end
	
		-- Get client's CVars
		local forcelimit = self:GetClientNumber( "forcelimit" )
		local addlength	 = self:GetClientNumber( "addlength" )
		local material 	 = self:GetClientInfo( "material" )
		local width 	 = self:GetClientNumber( "width" )
		local rigid	 = self:GetClientNumber( "rigid" ) == 1
		
		-- Get information we're about to use
		local Ent1,  Ent2  = self:GetEnt(1),	 self:GetEnt(2)
		local Bone1, Bone2 = self:GetBone(1),	 self:GetBone(2)
		local WPos1, WPos2 = self:GetPos(1),self:GetPos(2)
		local LPos1, LPos2 = self:GetLocalPos(1),self:GetLocalPos(2)
		local length = ( WPos1 - WPos2 ):Length()

		local constraint, rope = constraint.Rope( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, length, addlength, forcelimit, width, material, rigid )

		-- Clear the objects and set the last object as object 1
		self:ClearObjects()
		iNum = self:NumObjects()
		self:SetObject( iNum + 1, Ent2, trace.HitPos, Phys, Bone2, trace.HitNormal )
		self:SetStage( iNum+1 )

		-- Add The constraint to the players undo table

		undo.Create("Rope")
		undo.AddEntity( constraint )
		if rope then undo.AddEntity( rope ) end
		undo.SetPlayer( self:GetOwner() )
		undo.Finish()
		
		self:GetOwner():AddCleanup( "ropeconstraints", constraint )		
		self:GetOwner():AddCleanup( "ropeconstraints", rope )
		
	else
	
		self:SetStage( iNum+1 )
		
	end

	return true
	
end

function TOOL:Reload( trace )

	if (!trace.Entity:IsValid() || trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end

	local  bool = constraint.RemoveConstraints( trace.Entity, "Rope" )
	return bool

	
end

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Text = "#tool.rope.name", Description	= "#tool.rope.help" }  )
	
	CPanel:AddControl( "ComboBox", 
	{ 
		Label = "#tool.presets",
		MenuButton = 1,
		Folder = "rope",
		Options =	{ Default = {	rope_forcelimit = '0',			rope_addlength='0',		rope_width='1',		rope_material='cable/rope',		rope_rigid='0' } },
		CVars =		{				"rope_forcelimit",				"rope_addlength",		"rope_width",		"rope_material",				"rope_rigid" } 
	})

	CPanel:AddControl( "Slider", 		{ Label = "#tool.forcelimit",		Type = "Float", 	Command = "rope_forcelimit", 	Min = "0", 	Max = "1000", Help=true }  )
	CPanel:AddControl( "Slider", 		{ Label = "#tool.rope.addlength",	Type = "Float", 	Command = "rope_addlength", 	Min = "-500", 	Max = "500", Help=true }  )

	CPanel:AddControl( "CheckBox",		{ Label = "#tool.rope.rigid",		Command = "rope_rigid", Help=true }  )

	CPanel:AddControl( "Slider", 		{ Label = "#tool.rope.width",		Type = "Float", 	Command = "rope_width", 		Min = "0", 	Max = "10" }  )
	CPanel:AddControl( "RopeMaterial", 	{ Label = "#tool.rope.material",		convar	= "rope_material" }  )
									
end