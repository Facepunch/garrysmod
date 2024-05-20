
TOOL.Category = "Constraints"
TOOL.Name = "#tool.pulley.name"

TOOL.ClientConVar[ "width" ] = "3"
TOOL.ClientConVar[ "forcelimit" ] = "0"
TOOL.ClientConVar[ "rigid" ] = "0"
TOOL.ClientConVar[ "material" ] = "cable/cable"
TOOL.ClientConVar[ "color_r" ] = "255"
TOOL.ClientConVar[ "color_g" ] = "255"
TOOL.ClientConVar[ "color_b" ] = "255"

TOOL.Information = {
	{ name = "left", stage = 0 },
	{ name = "left_1", stage = 1 },
	{ name = "left_2", stage = 2 },
	{ name = "left_3", stage = 3 },
	{ name = "reload" }
}

function TOOL:LeftClick( trace )

	-- If there's no physics object then we can't constraint it!
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end

	local iNum = self:NumObjects()

	if ( IsValid( trace.Entity ) && trace.Entity:IsPlayer() ) then return false end
	if ( !IsValid( trace.Entity ) && ( iNum == nil || iNum == 0 || iNum > 2 ) ) then return false end

	local Phys = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone )
	self:SetObject( iNum + 1, trace.Entity, trace.HitPos, Phys, trace.PhysicsBone, trace.HitNormal )

	if ( iNum > 2 ) then

		if ( CLIENT ) then return true end

		local width = self:GetClientNumber( "width" )
		local forcelimit = self:GetClientNumber( "forcelimit" )
		local rigid = self:GetClientNumber( "rigid" ) == 1
		local material = self:GetClientInfo( "material" )
		local colorR = self:GetClientNumber( "color_r" )
		local colorG = self:GetClientNumber( "color_g" )
		local colorB = self:GetClientNumber( "color_b" )

		-- Get information we're about to use
		local Ent1 = self:GetEnt( 1 )
		local Ent4 = self:GetEnt( 4 )
		local Bone1 = self:GetBone( 1 )
		local Bone4 = self:GetBone( 4 )
		local LPos1 = self:GetLocalPos( 1 )
		local LPos4 = self:GetLocalPos( 4 )
		local WPos2 = self:GetPos( 2 )
		local WPos3 = self:GetPos( 3 )

		local constr, rope1, rope2, rope3 = constraint.Pulley( Ent1, Ent4, Bone1, Bone4, LPos1, LPos4, WPos2, WPos3, forcelimit, rigid, width, material, Color( colorR, colorG, colorB, 255 ) )
		if ( IsValid( constr ) ) then
			undo.Create( "Pulley" )
				undo.AddEntity( constr )
				if ( IsValid( rope1 ) ) then undo.AddEntity( rope1 ) end
				if ( IsValid( rope2 ) ) then undo.AddEntity( rope2 ) end
				if ( IsValid( rope3 ) ) then undo.AddEntity( rope3 ) end
				undo.SetPlayer( self:GetOwner() )
			undo.Finish()

			self:GetOwner():AddCleanup( "ropeconstraints", constr )
			if ( IsValid( rope1 ) ) then self:GetOwner():AddCleanup( "ropeconstraints", rope1 ) end
			if ( IsValid( rope2 ) ) then self:GetOwner():AddCleanup( "ropeconstraints", rope2 ) end
			if ( IsValid( rope3 ) ) then self:GetOwner():AddCleanup( "ropeconstraints", rope3 ) end
		end

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
	CPanel:AddControl( "Color", { Label = "#tool.pulley.color", Red = "pulley_color_r", Green = "pulley_color_g", Blue = "pulley_color_b" } )

end
