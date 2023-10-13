
TOOL.Category = "Constraints"
TOOL.Name = "#tool.winch.name"

TOOL.ClientConVar[ "rope_material" ] = "cable/rope"
TOOL.ClientConVar[ "rope_width" ] = "3"
TOOL.ClientConVar[ "fwd_speed" ] = "64"
TOOL.ClientConVar[ "bwd_speed" ] = "64"
TOOL.ClientConVar[ "fwd_group" ] = "44"
TOOL.ClientConVar[ "bwd_group" ] = "41"
TOOL.ClientConVar[ "color_r" ] = "255"
TOOL.ClientConVar[ "color_g" ] = "255"
TOOL.ClientConVar[ "color_b" ] = "255"

TOOL.Information = {
	{ name = "left", stage = 0 },
	{ name = "left_1", stage = 1, op = 1 },
	{ name = "right", stage = 0 },
	{ name = "reload" }
}

function TOOL:LeftClick( trace )

	if ( IsValid( trace.Entity ) && trace.Entity:IsPlayer() ) then return end

	-- If there's no physics object then we can't constraint it!
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end

	local iNum = self:NumObjects()

	local Phys = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone )
	self:SetObject( iNum + 1, trace.Entity, trace.HitPos, Phys, trace.PhysicsBone, trace.HitNormal )
	self:SetOperation( 1 )

	if ( iNum > 0 ) then

		if ( CLIENT ) then
			self:ClearObjects()
			return true
		end

		-- Get client's CVars
		local material = self:GetClientInfo( "rope_material", "cable/rope" )
		local width = self:GetClientNumber( "rope_width", 3 )
		local fwd_bind = self:GetClientNumber( "fwd_group", 44 )
		local bwd_bind = self:GetClientNumber( "bwd_group", 41 )
		local fwd_speed = self:GetClientNumber( "fwd_speed", 64 )
		local bwd_speed = self:GetClientNumber( "bwd_speed", 64 )
		local colorR = self:GetClientNumber( "color_r" )
		local colorG = self:GetClientNumber( "color_g" )
		local colorB = self:GetClientNumber( "color_b" )
		local toggle = false

		-- Get information we're about to use
		local Ent1, Ent2 = self:GetEnt( 1 ), self:GetEnt( 2 )
		local Bone1, Bone2 = self:GetBone( 1 ), self:GetBone( 2 )
		local LPos1, LPos2 = self:GetLocalPos( 1 ), self:GetLocalPos( 2 )

		local constr, rope, controller = constraint.Winch( self:GetOwner(), Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, width, fwd_bind, bwd_bind, fwd_speed, bwd_speed, material, toggle, Color( colorR, colorG, colorB, 255 ) )
		if ( IsValid( constr ) ) then
			undo.Create( "Winch" )
				undo.AddEntity( constr )
				if ( IsValid( rope ) ) then undo.AddEntity( rope ) end
				if ( IsValid( controller ) ) then undo.AddEntity( controller ) end
				undo.SetPlayer( self:GetOwner() )
			undo.Finish()

			self:GetOwner():AddCleanup( "ropeconstraints", constr )
			if ( IsValid( rope ) ) then self:GetOwner():AddCleanup( "ropeconstraints", rope ) end
			if ( IsValid( controller ) ) then self:GetOwner():AddCleanup( "ropeconstraints", controller ) end
		end

		-- Clear the objects so we're ready to go again
		self:ClearObjects()

	else

		self:SetStage( iNum + 1 )

	end

	return true

end

function TOOL:RightClick( trace )

	if ( self:GetOperation() == 1 ) then return false end

	-- If there's no physics object then we can't constraint it!
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end

	local Phys = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone )
	self:SetObject( 1, trace.Entity, trace.HitPos, Phys, trace.PhysicsBone, trace.HitNormal )

	local tr = {}
	tr.start = trace.HitPos
	tr.endpos = tr.start + ( trace.HitNormal * 16384 )
	tr.filter = {}
	tr.filter[ 1 ] = self:GetOwner()
	if ( IsValid( trace.Entity ) ) then
		tr.filter[ 2 ] = trace.Entity
	end

	local tr = util.TraceLine( tr )
	if ( !tr.Hit ) then
		self:ClearObjects()
		return false
	end

	-- Don't try to constrain world to world
	if ( trace.HitWorld && tr.HitWorld ) then
		self:ClearObjects()
		return false
	end

	if ( IsValid( trace.Entity ) && trace.Entity:IsPlayer() ) then
		self:ClearObjects()
		return false
	end
	if ( IsValid( tr.Entity ) && tr.Entity:IsPlayer() ) then
		self:ClearObjects()
		return false
	end

	-- Check to see if the player can create a winch constraint with the entity in the trace
	if ( !hook.Run( "CanTool", self:GetOwner(), tr, "winch", self, 2 ) ) then
		self:ClearObjects()
		return false
	end

	local Phys2 = tr.Entity:GetPhysicsObjectNum( tr.PhysicsBone )
	self:SetObject( 2, tr.Entity, tr.HitPos, Phys2, tr.PhysicsBone, trace.HitNormal )

	if ( CLIENT ) then
		self:ClearObjects()
		return true
	end

	-- Get client's CVars
	local material = self:GetClientInfo( "rope_material", "cable/rope" )
	local width = self:GetClientNumber( "rope_width", 3 )
	local fwd_bind = self:GetClientNumber( "fwd_group", 44 )
	local bwd_bind = self:GetClientNumber( "bwd_group", 41 )
	local fwd_speed = self:GetClientNumber( "fwd_speed", 64 )
	local bwd_speed = self:GetClientNumber( "bwd_speed", 64 )
	local colorR = self:GetClientNumber( "color_r" )
	local colorG = self:GetClientNumber( "color_g" )
	local colorB = self:GetClientNumber( "color_b" )

	-- Get information we're about to use
	local Ent1, Ent2 = self:GetEnt( 1 ), self:GetEnt( 2 )
	local Bone1, Bone2 = self:GetBone( 1 ), self:GetBone( 2 )
	local LPos1, LPos2 = self:GetLocalPos( 1 ), self:GetLocalPos( 2 )

	local constr, rope, controller = constraint.Winch( self:GetOwner(), Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, width, fwd_bind, bwd_bind, fwd_speed, bwd_speed, material, Color( colorR, colorG, colorB, 255 ) )
	if ( IsValid( constr ) ) then
		undo.Create( "Winch" )
			undo.AddEntity( constr )
			if ( IsValid( rope ) ) then undo.AddEntity( rope ) end
			if ( IsValid( controller ) ) then undo.AddEntity( controller ) end
			undo.SetPlayer( self:GetOwner() )
		undo.Finish()

		self:GetOwner():AddCleanup( "ropeconstraints", constr )
		if ( IsValid( rope ) ) then self:GetOwner():AddCleanup( "ropeconstraints", rope ) end
		if ( IsValid( controller ) ) then self:GetOwner():AddCleanup( "ropeconstraints", controller ) end
	end

	-- Clear the objects so we're ready to go again
	self:ClearObjects()

	return true

end

function TOOL:Reload( trace )

	if ( !IsValid( trace.Entity ) || trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end

	return constraint.RemoveConstraints( trace.Entity, "Winch" )

end

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Description = "#tool.winch.help" } )

	CPanel:AddControl( "ComboBox", { MenuButton = 1, Folder = "winch", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

	CPanel:AddControl( "Numpad", { Label = "#tool.winch.forward", Command = "winch_fwd_group", Label2 = "#tool.winch.backward", Command2 = "winch_bwd_group" } )

	CPanel:AddControl( "Slider", { Label = "#tool.winch.fspeed", Command = "winch_fwd_speed", Type = "Float", Min = 0, Max = 1000, Help = true } )
	CPanel:AddControl( "Slider", { Label = "#tool.winch.bspeed", Command = "winch_bwd_speed", Type = "Float", Min = 0, Max = 1000, Help = true } )
	CPanel:AddControl( "Slider", { Label = "#tool.winch.width", Command = "winch_rope_width", Type = "Float", Min = 0, Max = 10 } )

	CPanel:AddControl( "RopeMaterial", { Label = "#tool.winch.material", ConVar = "winch_rope_material" } )
	CPanel:AddControl( "Color", { Label = "#tool.winch.color", Red = "winch_color_r", Green = "winch_color_g", Blue = "winch_color_b" } )

end
