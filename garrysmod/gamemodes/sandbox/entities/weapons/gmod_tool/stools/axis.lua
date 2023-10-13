
TOOL.Category = "Constraints"
TOOL.Name = "#tool.axis.name"

TOOL.ClientConVar[ "forcelimit" ] = 0
TOOL.ClientConVar[ "torquelimit" ] = 0
TOOL.ClientConVar[ "hingefriction" ] = 0
TOOL.ClientConVar[ "nocollide" ] = 0

TOOL.Information = {
	{ name = "left", stage = 0 },
	{ name = "left_1", stage = 1, op = 1 },
	{ name = "right", stage = 0 },
	{ name = "right_1", stage = 1, op = 2 },
	{ name = "reload" }
}

function TOOL:LeftClick( trace )

	if ( self:GetOperation() == 2 ) then return false end

	if ( IsValid( trace.Entity ) && trace.Entity:IsPlayer() ) then return end

	-- todo: Don't attempt to constrain the first object if it's already constrained to a static object

	local iNum = self:NumObjects()

	-- Don't allow us to choose the world as the first object
	if ( iNum == 0 && !IsValid( trace.Entity ) ) then return false end

	-- Don't do jeeps (crash protection until we get it fixed)
	if ( iNum == 0 && trace.Entity:GetClass() == "prop_vehicle_jeep" ) then return false end

	-- If there's no physics object then we can't constraint it!
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end

	local Phys = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone )
	self:SetObject( iNum + 1, trace.Entity, trace.HitPos, Phys, trace.PhysicsBone, trace.HitNormal )
	self:SetOperation( 1 )

	if ( iNum > 0 ) then

		-- Clientside can bail out now
		if ( CLIENT ) then

			self:ClearObjects()
			self:ReleaseGhostEntity()

			return true

		end

		-- Get client's CVars
		local nocollide = self:GetClientNumber( "nocollide", 0 )
		local forcelimit = self:GetClientNumber( "forcelimit", 0 )
		local torquelimit = self:GetClientNumber( "torquelimit", 0 )
		local friction = self:GetClientNumber( "hingefriction", 0 )

		local Ent1, Ent2 = self:GetEnt( 1 ), self:GetEnt( 2 )
		local Bone1, Bone2 = self:GetBone( 1 ), self:GetBone( 2 )
		local Norm1, Norm2 = self:GetNormal( 1 ), self:GetNormal( 2 )
		local LPos1, LPos2 = self:GetLocalPos( 1 ), self:GetLocalPos( 2 )
		local Phys1 = self:GetPhys( 1 )
		local WPos2 = self:GetPos( 2 )

		-- Note: To keep stuff ragdoll friendly try to treat things as physics objects rather than entities
		local Ang1, Ang2 = Norm1:Angle(), ( -Norm2 ):Angle()
		local TargetAngle = Phys1:AlignAngles( Ang1, Ang2 )

		Phys1:SetAngles( TargetAngle )

		-- Move the object so that the hitpos on our object is at the second hitpos
		local TargetPos = WPos2 + ( Phys1:GetPos() - self:GetPos( 1 ) ) + ( Norm2 * 0.2 )

		-- Set the position
		Phys1:SetPos( TargetPos )

		-- Wake up the physics object so that the entity updates
		Phys1:Wake()

		-- Set the hinge Axis perpendicular to the trace hit surface
		LPos1 = Phys1:WorldToLocal( WPos2 + Norm2 )

		-- Create a constraint axis
		local constr = constraint.Axis( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, forcelimit, torquelimit, friction, nocollide )
		if ( IsValid( constr ) ) then
			undo.Create( "Axis" )
				undo.AddEntity( constr )
				undo.SetPlayer( self:GetOwner() )
			undo.Finish()

			self:GetOwner():AddCleanup( "constraints", constr )
		end

		-- Clear the objects so we're ready to go again
		self:ClearObjects()
		self:ReleaseGhostEntity()

	else

		self:StartGhostEntity( trace.Entity )
		self:SetStage( iNum + 1 )

	end

	return true

end

function TOOL:RightClick( trace )

	if ( self:GetOperation() == 1 ) then return false end

	if ( IsValid( trace.Entity ) && trace.Entity:IsPlayer() ) then return false end

	local iNum = self:NumObjects()

	-- Don't allow us to choose the world as the first object
	if ( iNum == 0 && !IsValid( trace.Entity ) ) then return false end

	local Phys = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone )
	self:SetObject( iNum + 1, trace.Entity, trace.HitPos, Phys, trace.PhysicsBone, trace.HitNormal )
	self:SetOperation( 2 )

	if ( iNum > 0 ) then

		-- Clientside can bail out now
		if ( CLIENT ) then

			self:ClearObjects()

			return true

		end

		-- Get client's CVars
		local nocollide = self:GetClientNumber( "nocollide", 0 )
		local forcelimit = self:GetClientNumber( "forcelimit", 0 )
		local torquelimit = self:GetClientNumber( "torquelimit", 0 )
		local friction = self:GetClientNumber( "hingefriction", 0 )

		local Ent1, Ent2 = self:GetEnt( 1 ), self:GetEnt( 2 )
		local Bone1, Bone2 = self:GetBone( 1 ), self:GetBone( 2 )
		local Norm1, Norm2 = self:GetNormal( 1 ), self:GetNormal( 2 )
		local LPos1, LPos2 = self:GetLocalPos( 1 ), self:GetLocalPos( 2 )
		local Phys1 = self:GetPhys( 1 )
		local WPos2 = self:GetPos( 2 )

		-- Note: To keep stuff ragdoll friendly try to treat things as physics objects rather than entities
		--local Ang1, Ang2 = Norm1:Angle(), ( -Norm2 ):Angle()
		--local TargetAngle = Phys1:AlignAngles( Ang1, Ang2 )

		--Phys1:SetAngles( TargetAngle )

		Phys1:Wake()

		-- Set the hinge Axis perpendicular to the trace hit surface
		LPos1 = Phys1:WorldToLocal( WPos2 + Norm2 )

		local constr = constraint.Axis( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, forcelimit, torquelimit, friction, nocollide )
		if ( IsValid( constr ) ) then
			undo.Create( "Axis" )
				undo.AddEntity( constr )
				undo.SetPlayer( self:GetOwner() )
			undo.Finish()

			self:GetOwner():AddCleanup( "constraints", constr )
		end

		-- Clear the objects so we're ready to go again
		self:ClearObjects()
		self:ReleaseGhostEntity()

	else

		self:SetStage( iNum + 1 )

	end

	return true

end

function TOOL:Reload( trace )

	if ( !IsValid( trace.Entity ) || trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end

	return constraint.RemoveConstraints( trace.Entity, "Axis" )

end

function TOOL:Think()

	if ( self:NumObjects() != 1 ) then return end

	self:UpdateGhostEntity()

end

function TOOL:Holster()

	self:ClearObjects()

end

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Description = "#tool.axis.help" } )

	CPanel:AddControl( "ComboBox", { MenuButton = 1, Folder = "axis", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

	CPanel:AddControl( "Slider", { Label = "#tool.forcelimit", Command = "axis_forcelimit", Type = "Float", Min = 0, Max = 50000, Help = true } )
	CPanel:AddControl( "Slider", { Label = "#tool.torquelimit", Command = "axis_torquelimit", Type = "Float", Min = 0, Max = 50000, Help = true } )
	CPanel:AddControl( "Slider", { Label = "#tool.hingefriction", Command = "axis_hingefriction", Type = "Float", Min = 0, Max = 200, Help = true } )
	CPanel:AddControl( "CheckBox", { Label = "#tool.nocollide", Command = "axis_nocollide", Help = true } )

end
