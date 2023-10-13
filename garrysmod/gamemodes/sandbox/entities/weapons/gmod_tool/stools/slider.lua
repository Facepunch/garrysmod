
TOOL.Category = "Constraints"
TOOL.Name = "#tool.slider.name"

TOOL.ClientConVar[ "width" ] = "1.5"
TOOL.ClientConVar[ "material" ] = "cable/cable"
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
		local width = self:GetClientNumber( "width", 1.5 )
		local material = self:GetClientInfo( "material" )

		local colorR = self:GetClientNumber( "color_r" )
		local colorG = self:GetClientNumber( "color_g" )
		local colorB = self:GetClientNumber( "color_b" )

		-- Get information we're about to use
		local Ent1, Ent2 = self:GetEnt( 1 ), self:GetEnt( 2 )
		local Bone1, Bone2 = self:GetBone( 1 ), self:GetBone( 2 )
		local LPos1, LPos2 = self:GetLocalPos( 1 ), self:GetLocalPos( 2 )

		local constr, rope = constraint.Slider( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, width, material, Color( colorR, colorG, colorB, 255 ) )
		if ( IsValid( constr ) ) then
			undo.Create( "Slider" )
				undo.AddEntity( constr )
				if ( IsValid( rope ) ) then undo.AddEntity( rope ) end
				undo.SetPlayer( self:GetOwner() )
			undo.Finish()

			self:GetOwner():AddCleanup( "ropeconstraints", constr )
			if ( IsValid( rope ) ) then self:GetOwner():AddCleanup( "ropeconstraints", rope ) end
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
		return
	end

	-- Don't try to constrain world to world
	if ( trace.HitWorld && tr.HitWorld ) then
		self:ClearObjects()
		return
	end

	if ( IsValid( trace.Entity ) && trace.Entity:IsPlayer() ) then
		self:ClearObjects()
		return
	end
	if ( IsValid( tr.Entity ) && tr.Entity:IsPlayer() ) then
		self:ClearObjects()
		return
	end

	-- Check to see if the player can create a slider constraint with the entity in the trace
	if ( !hook.Run( "CanTool", self:GetOwner(), tr, "slider", self, 2 ) ) then
		self:ClearObjects()
		return
	end

	local Phys2 = tr.Entity:GetPhysicsObjectNum( tr.PhysicsBone )
	self:SetObject( 2, tr.Entity, tr.HitPos, Phys2, tr.PhysicsBone, trace.HitNormal )

	if ( CLIENT ) then
		self:ClearObjects()
		return true
	end

	local width = self:GetClientNumber( "width", 1.5 )
	local material = self:GetClientInfo( "material" )

	local colorR = self:GetClientNumber( "color_r" )
	local colorG = self:GetClientNumber( "color_g" )
	local colorB = self:GetClientNumber( "color_b" )

	-- Get information we're about to use
	local Ent1, Ent2 = self:GetEnt( 1 ), self:GetEnt( 2 )
	local Bone1, Bone2 = self:GetBone( 1 ), self:GetBone( 2 )
	local LPos1, LPos2 = self:GetLocalPos( 1 ),	self:GetLocalPos( 2 )

	local constr, rope = constraint.Slider( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, width, material, Color( colorR, colorG, colorB, 255 ) )
	if ( IsValid( constr ) ) then
		undo.Create( "Slider" )
			undo.AddEntity( constr )
			if ( IsValid( rope ) ) then undo.AddEntity( rope ) end
			undo.SetPlayer( self:GetOwner() )
		undo.Finish()

		self:GetOwner():AddCleanup( "ropeconstraints", constr )
		if ( IsValid( rope ) ) then self:GetOwner():AddCleanup( "ropeconstraints", rope ) end
	end

	-- Clear the objects so we're ready to go again
	self:ClearObjects()

	return true

end

function TOOL:Reload( trace )

	if ( !IsValid( trace.Entity ) || trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end

	return constraint.RemoveConstraints( trace.Entity, "Slider" )

end

function TOOL:Holster()

	self:ClearObjects()

end

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Description = "#tool.slider.help" } )

	CPanel:AddControl( "ComboBox", { MenuButton = 1, Folder = "slider", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

	CPanel:AddControl( "Slider", { Label = "#tool.slider.width", Command = "slider_width", Type = "Float", Min = 0, Max = 10 } )
	CPanel:AddControl( "RopeMaterial", { Label = "#tool.slider.material", ConVar = "slider_material" } )

	CPanel:AddControl( "Color", { Label = "#tool.slider.color", Red = "slider_color_r", Green = "slider_color_g", Blue = "slider_color_b" } )

end
