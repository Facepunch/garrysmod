
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

		local ply = self:GetOwner()
		if ( !ply:CheckLimit( "ropeconstraints" ) ) then
			self:ClearObjects()
			return false
		end

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

		local constr, rope1, rope2, rope3 = constraint.Pulley( Ent1, Ent4, Bone1, Bone4, LPos1, LPos4, WPos2, WPos3, forcelimit, rigid, width, material, Color( colorR, colorG, colorB ) )
		if ( IsValid( constr ) ) then
			undo.Create( "Pulley" )
				undo.AddEntity( constr )
				if ( IsValid( rope1 ) ) then undo.AddEntity( rope1 ) end
				if ( IsValid( rope2 ) ) then undo.AddEntity( rope2 ) end
				if ( IsValid( rope3 ) ) then undo.AddEntity( rope3 ) end
				undo.SetPlayer( ply )
				undo.SetCustomUndoText( "Undone #tool.pulley.name" )
			undo.Finish( "#tool.pulley.name" )

			ply:AddCount( "ropeconstraints", constr )
			ply:AddCleanup( "ropeconstraints", constr )
			if ( IsValid( rope1 ) ) then ply:AddCleanup( "ropeconstraints", rope1 ) end
			if ( IsValid( rope2 ) ) then ply:AddCleanup( "ropeconstraints", rope2 ) end
			if ( IsValid( rope3 ) ) then ply:AddCleanup( "ropeconstraints", rope3 ) end
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

	CPanel:Help( "#tool.pulley.help" )
	CPanel:ToolPresets( "pulley", ConVarsDefault )

	CPanel:NumSlider( "#tool.forcelimit", "pulley_forcelimit", 0, 1000 )
	CPanel:ControlHelp( "#tool.forcelimit.help" )

	CPanel:CheckBox( "#tool.pulley.rigid", "pulley_rigid" )
	CPanel:ControlHelp( "#tool.pulley.rigid.help" )

	CPanel:NumSlider( "#tool.pulley.width", "pulley_width", 0, 10 )

	CPanel:RopeSelect( "pulley_material" )

	CPanel:ColorPicker( "#tool.pulley.color", "pulley_color_r", "pulley_color_g", "pulley_color_b" )

end
