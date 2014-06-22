
TOOL.Category = "Constraints"
TOOL.Name = "#tool.pulley.name"

TOOL.ClientConVar[ "width" ] = "3"
TOOL.ClientConVar[ "forcelimit" ] = "0"
TOOL.ClientConVar[ "rigid" ] = "0"
TOOL.ClientConVar[ "material" ] = "cable/cable"

function TOOL:LeftClick( trace )

	-- If there's no physics object then we can't constraint it!
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end

	local iNum = self:NumObjects()

	if ( IsValid( trace.Entity ) && trace.Entity:IsPlayer() ) then return end
	if ( !IsValid( trace.Entity ) && ( iNum == nil || iNum == 0 || iNum > 2 ) ) then return end

	local Phys = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone )
	self:SetObject( iNum + 1, trace.Entity, trace.HitPos, Phys, trace.PhysicsBone, trace.HitNormal )

	if ( iNum > 2 ) then
	
		if ( CLIENT ) then return true end
		
		local width = self:GetClientNumber( "width" )
		local forcelimit = self:GetClientNumber( "forcelimit" )
		local rigid = self:GetClientNumber( "rigid" ) == 1
		local material = self:GetClientInfo( "material" )
		
		-- Get information we're about to use
		local Ent1 = self:GetEnt( 1 )
		local Ent4 = self:GetEnt( 4 )
		local Bone1 = self:GetBone( 1 )
		local Bone4 = self:GetBone( 4 )
		local LPos1 = self:GetLocalPos( 1 )
		local LPos4 = self:GetLocalPos( 4 )
		local WPos2 = self:GetPos( 2 )
		local WPos3 = self:GetPos( 3 )

		local constraint = constraint.Pulley( Ent1, Ent4, Bone1, Bone4, LPos1, LPos4, WPos2, WPos3, forcelimit, rigid, width, material )

		undo.Create( "Pulley" )
			undo.AddEntity( constraint )
			undo.SetPlayer( self:GetOwner() )
		undo.Finish()
		
		self:GetOwner():AddCleanup( "ropeconstraints", constraint )

		self:ClearObjects()

	else

		self:SetStage( iNum + 1 )
		
	end
	
	return true

end

function TOOL:Reload( trace )

	if ( !IsValid( trace.Entity ) || trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end

	return constraint.RemoveConstraints( trace.Entity, "Pulley" )
	
end

function TOOL:Holster()

	self:ClearObjects()

end

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Description = "#tool.pulley.help" } )

	CPanel:AddControl( "ComboBox", { MenuButton = 1, Folder = "pulley", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

	CPanel:AddControl( "Slider", { Label = "#tool.forcelimit", Command = "pulley_forcelimit", Type = "Float", Min = 0, Max = 1000, Help = true } )
	CPanel:AddControl( "CheckBox", { Label = "#tool.pulley.rigid", Command = "pulley_rigid", Help = true } )

	CPanel:AddControl( "Slider", { Label = "#tool.pulley.width", Command = "pulley_width", Type = "Float", Min = 0, Max = 10 } )
	CPanel:AddControl( "RopeMaterial", { Label = "#tool.pulley.material", ConVar = "pulley_material" } )

end
