
TOOL.Category = "Constraints"
TOOL.Name = "#tool.rope.name"

TOOL.ClientConVar[ "forcelimit" ] = "0"
TOOL.ClientConVar[ "addlength" ] = "0"
TOOL.ClientConVar[ "material" ] = "cable/rope"
TOOL.ClientConVar[ "width" ] = "2"
TOOL.ClientConVar[ "rigid" ] = "0"
TOOL.ClientConVar[ "color_r" ] = "255"
TOOL.ClientConVar[ "color_g" ] = "255"
TOOL.ClientConVar[ "color_b" ] = "255"

TOOL.Information = {
	{ name = "left", stage = 0 },
	{ name = "left_1", stage = 1 },
	{ name = "right", stage = 1 },
	{ name = "reload" }
}

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

		local ply = self:GetOwner()
		if ( !ply:CheckLimit( "ropeconstraints" ) ) then
			self:ClearObjects()
			return false
		end

		-- Get client's CVars
		local forcelimit = self:GetClientNumber( "forcelimit" )
		local addlength = self:GetClientNumber( "addlength" )
		local material = self:GetClientInfo( "material" )
		local width = self:GetClientNumber( "width" )
		local rigid = self:GetClientNumber( "rigid" ) == 1

		local colorR = self:GetClientNumber( "color_r" )
		local colorG = self:GetClientNumber( "color_g" )
		local colorB = self:GetClientNumber( "color_b" )

		-- Get information we're about to use
		local Ent1, Ent2 = self:GetEnt( 1 ), self:GetEnt( 2 )
		local Bone1, Bone2 = self:GetBone( 1 ), self:GetBone( 2 )
		local WPos1, WPos2 = self:GetPos( 1 ), self:GetPos( 2 )
		local LPos1, LPos2 = self:GetLocalPos( 1 ), self:GetLocalPos( 2 )
		local length = ( WPos1 - WPos2 ):Length()

		local constr, rope = constraint.Rope( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, length, addlength, forcelimit, width, material, rigid, Color( colorR, colorG, colorB ) )
		if ( IsValid( constr ) ) then
			-- Add the constraint to the players undo table
			undo.Create( "Rope" )
				undo.AddEntity( constr )
				if ( IsValid( rope ) ) then undo.AddEntity( rope ) end
				undo.SetPlayer( ply )
				undo.SetCustomUndoText( "Undone #tool.rope.name" )
			undo.Finish( "#tool.rope.name" )

			ply:AddCount( "ropeconstraints", constr )
			ply:AddCleanup( "ropeconstraints", constr )
			if ( IsValid( rope ) ) then ply:AddCleanup( "ropeconstraints", rope ) end
		end

		-- Clear the objects so we're ready to go again
		self:ClearObjects()

	else

		self:SetStage( iNum + 1 )

	end

	return true

end

function TOOL:RightClick( trace )

	if ( IsValid( trace.Entity ) && trace.Entity:IsPlayer() ) then return end

	local iNum = self:NumObjects()

	local Phys = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone )
	self:SetObject( iNum + 1, trace.Entity, trace.HitPos, Phys, trace.PhysicsBone, trace.HitNormal )

	if ( iNum > 0 ) then

		if ( CLIENT ) then
			self:ClearObjects()
			return true
		end

		local ply = self:GetOwner()
		if ( !ply:CheckLimit( "ropeconstraints" ) ) then
			self:ClearObjects()
			return false
		end

		-- Get client's CVars
		local forcelimit = self:GetClientNumber( "forcelimit" )
		local addlength = self:GetClientNumber( "addlength" )
		local material = self:GetClientInfo( "material" )
		local width = self:GetClientNumber( "width" )
		local rigid = self:GetClientNumber( "rigid" ) == 1

		local colorR = self:GetClientNumber( "color_r" )
		local colorG = self:GetClientNumber( "color_g" )
		local colorB = self:GetClientNumber( "color_b" )

		-- Get information we're about to use
		local Ent1, Ent2 = self:GetEnt( 1 ), self:GetEnt( 2 )
		local Bone1, Bone2 = self:GetBone( 1 ), self:GetBone( 2 )
		local WPos1, WPos2 = self:GetPos( 1 ), self:GetPos( 2 )
		local LPos1, LPos2 = self:GetLocalPos( 1 ), self:GetLocalPos( 2 )
		local length = ( WPos1 - WPos2 ):Length()

		local constr, rope = constraint.Rope( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, length, addlength, forcelimit, width, material, rigid, Color( colorR, colorG, colorB ) )
		if ( IsValid( constr ) ) then
			-- Add the constraint to the players undo table
			undo.Create( "Rope" )
				undo.AddEntity( constr )
				if ( IsValid( rope ) ) then undo.AddEntity( rope ) end
				undo.SetPlayer( ply )
				undo.SetCustomUndoText( "Undone #tool.rope.name" )
			undo.Finish( "#tool.rope.name" )

			ply:AddCount( "ropeconstraints", constr )
			ply:AddCleanup( "ropeconstraints", constr )
			if ( IsValid( rope ) ) then ply:AddCleanup( "ropeconstraints", rope ) end
		end

		-- Clear the objects and set the last object as object 1
		self:ClearObjects()

		iNum = self:NumObjects()
		self:SetObject( iNum + 1, Ent2, trace.HitPos, Phys, Bone2, trace.HitNormal )
		self:SetStage( iNum + 1 )

	else

		self:SetStage( iNum + 1 )

	end

	return true

end

function TOOL:Reload( trace )

	if ( !IsValid( trace.Entity ) || trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end

	return constraint.RemoveConstraints( trace.Entity, "Rope" )

end

function TOOL:Holster()

	self:ClearObjects()

end

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel( CPanel )

	CPanel:Help( "#tool.rope.help" )
	CPanel:ToolPresets( "rope", ConVarsDefault )

	CPanel:NumSlider( "#tool.forcelimit", "rope_forcelimit", 0, 1000 )
	CPanel:ControlHelp( "#tool.forcelimit.help" )

	CPanel:NumSlider( "#tool.rope.addlength", "rope_addlength", -500, 500 )
	CPanel:ControlHelp( "#tool.rope.addlength.help" )

	CPanel:CheckBox( "#tool.rope.rigid", "rope_rigid" )
	CPanel:ControlHelp( "#tool.rope.rigid.help" )

	CPanel:NumSlider( "#tool.rope.width", "rope_width", 0, 10 )

	CPanel:RopeSelect( "rope_material" )

	CPanel:ColorPicker( "#tool.rope.color", "rope_color_r", "rope_color_g", "rope_color_b" )

end
