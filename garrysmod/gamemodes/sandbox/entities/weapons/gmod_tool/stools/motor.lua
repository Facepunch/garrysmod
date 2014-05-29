
TOOL.Category = "Constraints"
TOOL.Name = "#tool.motor.name"

TOOL.ClientConVar[ "torque" ] = "500"
TOOL.ClientConVar[ "friction" ] = "1"
TOOL.ClientConVar[ "nocollide" ] = "1"
TOOL.ClientConVar[ "forcetime" ] = "0"
TOOL.ClientConVar[ "fwd" ] = "45"
TOOL.ClientConVar[ "bwd" ] = "42"
TOOL.ClientConVar[ "toggle" ] = "0"
TOOL.ClientConVar[ "forcelimit" ] = "0"

function TOOL:LeftClick( trace )

	if ( IsValid( trace.Entity ) && trace.Entity:IsPlayer() ) then return end

	-- If there's no physics object then we can't constraint it!
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end
	
	local iNum = self:NumObjects()

	local Phys = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone )
	
	-- Don't allow us to choose the world as the first object
	if ( iNum == 0 && !IsValid( trace.Entity ) ) then return end
	
	-- Don't allow us to choose the same object
	if ( iNum == 1 && trace.Entity == self:GetEnt( 1 ) ) then return end
	
	self:SetObject( iNum + 1, trace.Entity, trace.HitPos, Phys, trace.PhysicsBone, trace.HitNormal )
	
	if ( iNum > 0 ) then
	
		if ( CLIENT ) then
		
			self:ClearObjects()
			self:ReleaseGhostEntity()
			
			return true
			
		end
		
		-- Get client's CVars
		local torque = self:GetClientNumber( "torque" )
		local friction = self:GetClientNumber( "friction" )
		local nocollide = self:GetClientNumber( "nocollide" )
		local time = self:GetClientNumber( "forcetime" )
		local forekey = self:GetClientNumber( "fwd" )
		local backkey = self:GetClientNumber( "bwd" )
		local toggle = self:GetClientNumber( "toggle" )
		local limit = self:GetClientNumber( "forcelimit" )
		
		local Ent1, Ent2 = self:GetEnt( 1 ), self:GetEnt( 2 )
		local Bone1, Bone2 = self:GetBone( 1 ), self:GetBone( 2 )
		local LPos1, LPos2 = self:GetLocalPos( 1 ), self:GetLocalPos( 2 )
		local Norm1, Norm2 = self:GetNormal( 1 ), self:GetNormal( 2 )
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
		LPos1 = Phys1:WorldToLocal( WPos2 + Norm2 * 64 )

		local constraint, axis = constraint.Motor( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, friction, torque, time, nocollide, toggle, self:GetOwner(), limit, forekey, backkey, 1 )

		undo.Create( "Motor" )
			undo.AddEntity( axis )
			undo.AddEntity( constraint )
			undo.SetPlayer( self:GetOwner() )
		undo.Finish()
		
		self:GetOwner():AddCleanup( "constraints", axis )
		self:GetOwner():AddCleanup( "constraints", constraint )

		-- Clear the objects so we're ready to go again
		self:ClearObjects()
		self:ReleaseGhostEntity()

	else
	
		self:StartGhostEntity( trace.Entity )
		self:SetStage( iNum + 1 )
		
	end
	
	return true
	
end

function TOOL:Reload( trace )

	if ( !IsValid( trace.Entity ) || trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end

	return constraint.RemoveConstraints( trace.Entity, "Motor" )

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

	CPanel:AddControl( "Header", { Description = "#tool.motor.help" } )
	
	CPanel:AddControl( "ComboBox", { MenuButton = 1, Folder = "motor", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

	CPanel:AddControl( "Numpad", { Label = "#tool.motor.numpad1", Command = "motor_fwd", Label2 = "#tool.motor.numpad2", Command2 = "motor_bwd" } )
	CPanel:AddControl( "Slider", { Label = "#tool.motor.torque", Command = "motor_torque", Type = "Float", Min = 0, Max = 10000 } )
	CPanel:AddControl( "Slider", { Label = "#tool.forcelimit", Command = "motor_forcelimit", Type = "Float", Min = 0, Max = 50000, Help = true } )
	CPanel:AddControl( "Slider", { Label = "#tool.hingefriction", Command = "motor_friction", Type = "Float", Min = 0, Max = 100, Help = true } )
	CPanel:AddControl( "Slider", { Label = "#tool.motor.forcetime", Command = "motor_forcetime", Type = "Float", Min = 0, Max = 120, Help = true } )
	CPanel:AddControl( "CheckBox", { Label = "#tool.nocollide", Command = "motor_nocollide", Help = true } )
	CPanel:AddControl( "CheckBox", { Label = "#tool.toggle", Command = "motor_toggle", Help = true } )

end
