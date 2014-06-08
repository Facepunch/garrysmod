
TOOL.Category = "Constraints"
TOOL.Name = "#tool.elastic.name"

TOOL.ClientConVar[ "constant" ] = "500"
TOOL.ClientConVar[ "damping" ] = "3"
TOOL.ClientConVar[ "rdamping" ] = "0.01"
TOOL.ClientConVar[ "material" ] = "cable/cable"
TOOL.ClientConVar[ "width" ] = "2"
TOOL.ClientConVar[ "stretch_only" ] = "1"

function TOOL:LeftClick( trace )

	if ( IsValid( trace.Entity ) && trace.Entity:IsPlayer() ) then return end
	
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
		local width = self:GetClientNumber( "width" )
		local material = self:GetClientInfo( "material" )
		local damping = self:GetClientNumber( "damping" )
		local rdamping = self:GetClientNumber( "rdamping" )
		local constant = self:GetClientNumber( "constant" )
		local stretchonly = self:GetClientNumber( "stretch_only" )
		
		-- Get information we're about to use
		local Ent1, Ent2 = self:GetEnt( 1 ), self:GetEnt( 2 )
		local Bone1, Bone2 = self:GetBone( 1 ), self:GetBone( 2 )
		local LPos1, LPos2 = self:GetLocalPos( 1 ),	self:GetLocalPos( 2 )
		local constraint, rope = constraint.Elastic( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, constant, damping, rdamping, material, width, stretchonly )

		-- Add The constraint to the players undo table

		undo.Create( "Elastic" )
			undo.AddEntity( constraint )
			if ( IsValid( rope ) ) then undo.AddEntity( rope ) end
			undo.SetPlayer( self:GetOwner() )
		undo.Finish()
		
		self:GetOwner():AddCleanup( "ropeconstraints", constraint )
		if ( IsValid( rope ) ) then self:GetOwner():AddCleanup( "ropeconstraints", rope ) end

		-- Clear the objects so we're ready to go again
		self:ClearObjects()
	
	else
	
		self:SetStage( iNum + 1 )
	
	end
	
	return true

end

function TOOL:Reload( trace )

	if ( !IsValid( trace.Entity ) || trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end

	return constraint.RemoveConstraints( trace.Entity, "Elastic" )
	
end

function TOOL:Holster()

	self:ClearObjects()

end

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Description = "#tool.elastic.help" } )
	
	CPanel:AddControl( "ComboBox", { MenuButton = 1, Folder = "elastic", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

	CPanel:AddControl( "Slider", { Label = "#tool.elastic.constant", Command = "elastic_constant", Type = "Float", Min = 0, Max = 4000, Help = true } )
	CPanel:AddControl( "Slider", { Label = "#tool.elastic.damping", Command = "elastic_damping", Type = "Float", Min = 0, Max = 50, Help = true } )
	CPanel:AddControl( "Slider", { Label = "#tool.elastic.rdamping", Command = "elastic_rdamping", Type = "Float", Min = 0, Max = 1, Help = true } )
	CPanel:AddControl( "CheckBox", { Label = "#tool.elastic.stretchonly", Command = "elastic_stretch_only", Help = true } )

	CPanel:AddControl( "Slider", { Label = "#tool.elastic.width", Command = "elastic_width", Type = "Float", Min = 0, Max = 20 } )
	CPanel:AddControl( "RopeMaterial", { Label = "#tool.elastic.material", ConVar = "elastic_material" } )

end
