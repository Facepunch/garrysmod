
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

		local ply = self:GetOwner()
		if ( !ply:CheckLimit( "ropeconstraints" ) ) then
			self:ClearObjects()
			return false
		end

		-- Get client's CVars
		local material = self:GetClientInfo( "rope_material" )
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

		local constr, rope, controller = constraint.Winch( ply, Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, width, fwd_bind, bwd_bind, fwd_speed, bwd_speed, material, toggle, Color( colorR, colorG, colorB ) )
		if ( IsValid( constr ) ) then
			undo.Create( "Winch" )
				undo.AddEntity( constr )
				if ( IsValid( rope ) ) then undo.AddEntity( rope ) end
				if ( IsValid( controller ) ) then undo.AddEntity( controller ) end
				undo.SetPlayer( ply )
				undo.SetCustomUndoText( "Undone #tool.winch.name" )
			undo.Finish( "#tool.winch.name" )

			ply:AddCount( "ropeconstraints", constr )
			ply:AddCleanup( "ropeconstraints", constr )
			if ( IsValid( rope ) ) then ply:AddCleanup( "ropeconstraints", rope ) end
			if ( IsValid( controller ) ) then ply:AddCleanup( "ropeconstraints", controller ) end
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

	local ply = self:GetOwner()

	local tr_new = {}
	tr_new.start = trace.HitPos
	tr_new.endpos = trace.HitPos + ( trace.HitNormal * 16384 )
	tr_new.filter = { ply }
	if ( IsValid( trace.Entity ) ) then
		table.insert( tr_new.filter, trace.Entity )
	end

	local tr = util.TraceLine( tr_new )
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
	if ( !hook.Run( "CanTool", ply, tr, "winch", self, 2 ) ) then
		self:ClearObjects()
		return false
	end

	local Phys2 = tr.Entity:GetPhysicsObjectNum( tr.PhysicsBone )
	self:SetObject( 2, tr.Entity, tr.HitPos, Phys2, tr.PhysicsBone, trace.HitNormal )

	if ( CLIENT ) then
		self:ClearObjects()
		return true
	end

	if ( !ply:CheckLimit( "ropeconstraints" ) ) then
		self:ClearObjects()
		return false
	end

	-- Get client's CVars
	local material = self:GetClientInfo( "rope_material" )
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

	local constr, rope, controller = constraint.Winch( self:GetOwner(), Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, width, fwd_bind, bwd_bind, fwd_speed, bwd_speed, material, toggle, Color( colorR, colorG, colorB ) )
	if ( IsValid( constr ) ) then
		undo.Create( "Winch" )
			undo.AddEntity( constr )
			if ( IsValid( rope ) ) then undo.AddEntity( rope ) end
			if ( IsValid( controller ) ) then undo.AddEntity( controller ) end
			undo.SetPlayer( ply )
			undo.SetCustomUndoText( "Undone #tool.winch.name" )
		undo.Finish( "#tool.winch.name" )

		ply:AddCount( "ropeconstraints", constr )
		ply:AddCleanup( "ropeconstraints", constr )
		if ( IsValid( rope ) ) then ply:AddCleanup( "ropeconstraints", rope ) end
		if ( IsValid( controller ) ) then ply:AddCleanup( "ropeconstraints", controller ) end
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

	CPanel:Help( "#tool.winch.help" )
	CPanel:ToolPresets( "winch", ConVarsDefault )

	CPanel:KeyBinder( "#tool.winch.forward", "winch_fwd_group", "#tool.winch.backward", "winch_bwd_group" )

	CPanel:NumSlider( "#tool.winch.fspeed", "winch_fwd_speed", 0, 1000 )
	CPanel:ControlHelp( "#tool.winch.fspeed.help" )

	CPanel:NumSlider( "#tool.winch.bspeed", "winch_bwd_speed", 0, 1000 )
	CPanel:ControlHelp( "#tool.winch.bspeed.help" )

	CPanel:NumSlider( "#tool.winch.width", "winch_rope_width", 0, 10 )

	CPanel:RopeSelect( "winch_rope_material" )

	CPanel:ColorPicker( "#tool.winch.color", "winch_color_r", "winch_color_g", "winch_color_b" )

end
