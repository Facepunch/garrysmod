
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

TOOL.Information = {
	{ name = "left", stage = 0 },
	{ name = "left_1", stage = 1 },
	{ name = "reload"}
}

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

		local ply = self:GetOwner()
		if ( !ply:CheckLimit( "constraints" ) ) then
			self:ClearObjects()
			self:ReleaseGhostEntity()
			return false
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

		local constr, axis = constraint.Motor( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, friction, torque, time, nocollide, toggle, ply, limit, forekey, backkey, 1 )
		if ( IsValid( constr ) ) then
			undo.Create( "Motor" )
				undo.AddEntity( constr )
				if ( IsValid( axis ) ) then undo.AddEntity( axis ) end
				undo.SetPlayer( ply )
			undo.Finish()

			ply:AddCount( "constraints", constr )
			ply:AddCleanup( "constraints", constr )
			if ( IsValid( axis ) ) then ply:AddCleanup( "constraints", axis ) end
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

	CPanel:Help( "#tool.motor.help" )

	-- Presets
	local presets = vgui.Create( "ControlPresets", CPanel )
	presets:SetPreset( "motor" )
	presets:AddOption( "#preset.default", ConVarsDefault )
	for k, v in pairs( table.GetKeys( ConVarsDefault ) ) do
		presets:AddConVar( v )
	end
	CPanel:AddPanel( presets )

	-- Key
	local numpad = vgui.Create( "CtrlNumPad", CPanel )
	numpad:SetConVar1( "motor_fwd" )
	numpad:SetConVar2( "motor_bwd" )
	numpad:SetLabel1( "#tool.motor.numpad1" )
	numpad:SetLabel2( "#tool.motor.numpad2" )
	CPanel:AddPanel( numpad )

	-- Torque
	local torque = CPanel:NumSlider( "#tool.motor.torque", "motor_torque", 0, 10000, 2 )
	local torqueDefault = GetConVar( "motor_torque" )
	if ( torqueDefault ) then
		torque:SetDefaultValue( torqueDefault:GetDefault() )
	end

	-- Force limit
	local forceLimit = CPanel:NumSlider( "#tool.forcelimit", "motor_forcelimit", 0, 50000, 2 )
	local forceLimitDefault = GetConVar( "motor_forcelimit" )
	CPanel:ControlHelp( "#tool.forcelimit" .. ".help" )
	if ( forceLimitDefault ) then
		forceLimit:SetDefaultValue( forceLimitDefault:GetDefault() )
	end

	-- Hinge friction
	local hingeFriction = CPanel:NumSlider( "#tool.hingefriction", "motor_friction", 0, 100, 2 )
	local hingeFrictionDefault = GetConVar( "motor_friction" )
	CPanel:ControlHelp( "#tool.hingefriction" .. ".help" )
	if ( hingeFrictionDefault ) then
		hingeFriction:SetDefaultValue( hingeFrictionDefault:GetDefault() )
	end

	-- Force time
	local forceTime = CPanel:NumSlider( "#tool.motor.forcetime", "motor_forcetime", 0, 120, 2 )
	local forceTimeDefault = GetConVar( "motor_forcetime" )
	CPanel:ControlHelp( "#tool.motor.forcetime" .. ".help" )
	if ( forceTimeDefault ) then
		forceTime:SetDefaultValue( forceTimeDefault:GetDefault() )
	end

	-- No collide
	CPanel:CheckBox( "#tool.nocollide", "motor_nocollide" )
	CPanel:ControlHelp( "#tool.nocollide" .. ".help" )

	-- Toggle
	CPanel:CheckBox( "#tool.toggle", "motor_toggle" )
	CPanel:ControlHelp( "#tool.toggle" .. ".help" )

end
