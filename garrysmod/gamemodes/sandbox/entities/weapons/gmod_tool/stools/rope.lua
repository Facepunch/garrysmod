
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

		local constr, rope = constraint.Rope( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, length, addlength, forcelimit, width, material, rigid, Color( colorR, colorG, colorB, 255 ) )
		if ( IsValid( constr ) ) then
			-- Add the constraint to the players undo table
			undo.Create( "Rope" )
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

	if ( IsValid( trace.Entity ) && trace.Entity:IsPlayer() ) then return end

	local iNum = self:NumObjects()

	local Phys = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone )
	self:SetObject( iNum + 1, trace.Entity, trace.HitPos, Phys, trace.PhysicsBone, trace.HitNormal )

	if ( iNum > 0 ) then

		if ( CLIENT ) then

			self:ClearObjects()
			return true

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

		local constr, rope = constraint.Rope( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, length, addlength, forcelimit, width, material, rigid, Color( colorR, colorG, colorB, 255 ) )
		if ( IsValid( constr ) ) then
			-- Add the constraint to the players undo table
			undo.Create( "Rope" )
				undo.AddEntity( constr )
				if ( IsValid( rope ) ) then undo.AddEntity( rope ) end
				undo.SetPlayer( self:GetOwner() )
			undo.Finish()

			self:GetOwner():AddCleanup( "ropeconstraints", constr )
			if ( IsValid( rope ) ) then self:GetOwner():AddCleanup( "ropeconstraints", rope ) end
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

	CPanel:AddControl( "Header", { Description = "#tool.rope.help" } )

	CPanel:AddControl( "ComboBox", { MenuButton = 1, Folder = "rope", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

	CPanel:AddControl( "Slider", { Label = "#tool.forcelimit", Command = "rope_forcelimit", Type = "Float", Min = 0, Max = 1000, Help = true } )
	CPanel:AddControl( "Slider", { Label = "#tool.rope.addlength", Command = "rope_addlength", Type = "Float", Min = -500, Max = 500, Help = true } )

	CPanel:AddControl( "CheckBox", { Label = "#tool.rope.rigid", Command = "rope_rigid", Help = true } )

	CPanel:AddControl( "Slider", { Label = "#tool.rope.width", Command = "rope_width", Type = "Float", Min = 0, Max = 10 } )
	CPanel:AddControl( "RopeMaterial", { Label = "#tool.rope.material", ConVar = "rope_material" } )

	CPanel:AddControl( "Color", { Label = "#tool.rope.color", Red = "rope_color_r", Green = "rope_color_g", Blue = "rope_color_b" } )

end
