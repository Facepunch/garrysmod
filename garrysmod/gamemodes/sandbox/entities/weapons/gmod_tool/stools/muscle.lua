
TOOL.Category = "Constraints"
TOOL.Name = "#tool.muscle.name"

TOOL.ClientConVar[ "group" ] = "37"
TOOL.ClientConVar[ "width" ] = "2"
TOOL.ClientConVar[ "addlength" ] = "100"
TOOL.ClientConVar[ "fixed" ] = "1"
TOOL.ClientConVar[ "period" ] = "1"
TOOL.ClientConVar[ "material" ] = "cable/rope"
TOOL.ClientConVar[ "starton" ] = "0"
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

		if ( ( !IsValid( self:GetEnt( 1 ) ) && !IsValid( self:GetEnt( 2 ) ) ) || iNum > 1 ) then

			self:ClearObjects()
			return true

		end

		-- Get client's CVars
		local width = self:GetClientNumber( "width", 3 )
		local bind = self:GetClientNumber( "group", 1 )
		local AddLength = self:GetClientNumber( "addlength", 0 )
		local fixed = self:GetClientNumber( "fixed", 1 )
		local period = self:GetClientNumber( "period", 1 )
		local starton = self:GetClientNumber( "starton" ) == 1
		local material = self:GetClientInfo( "material" )
		local colorR = self:GetClientNumber( "color_r" )
		local colorG = self:GetClientNumber( "color_g" )
		local colorB = self:GetClientNumber( "color_b" )

		-- If AddLength is 0 then what's the point.
		if ( AddLength == 0 ) then
			self:ClearObjects()
			return true
		end

		if ( period <= 0 ) then period = 0.1 end

		AddLength = math.Clamp( AddLength, -1000, 1000 )

		-- Get information we're about to use
		local Ent1, Ent2 = self:GetEnt( 1 ), self:GetEnt( 2 )
		local Bone1, Bone2 = self:GetBone( 1 ), self:GetBone( 2 )
		local LPos1, LPos2 = self:GetLocalPos( 1 ), self:GetLocalPos( 2 )
		local WPos1, WPos2 = self:GetPos( 1 ), self:GetPos( 2 )

		local Length1 = ( WPos1 - WPos2 ):Length()
		local Length2 = Length1 + AddLength

		local amp = Length2 - Length1

		local constr, rope, controller, slider = constraint.Muscle( self:GetOwner(), Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, Length1, Length2, width, bind, fixed, period, amp, starton, material, Color( colorR, colorG, colorB, 255 ) )
		if ( IsValid( constr ) ) then
			undo.Create( "Muscle" )
				undo.AddEntity( constr )
				if ( IsValid( rope ) ) then undo.AddEntity( rope ) end
				if ( IsValid( slider ) ) then undo.AddEntity( slider ) end
				if ( IsValid( controller ) ) then undo.AddEntity( controller ) end
				undo.SetPlayer( self:GetOwner() )
			undo.Finish()

			self:GetOwner():AddCleanup( "ropeconstraints", constr )
			if ( IsValid( rope ) ) then self:GetOwner():AddCleanup( "ropeconstraints", rope ) end
			if ( IsValid( slider ) ) then self:GetOwner():AddCleanup( "ropeconstraints", slider ) end
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

	-- Check to see if the player can create a muscle constraint with the entity in the trace
	if ( !hook.Run( "CanTool", self:GetOwner(), tr, "muscle", self, 2 ) ) then
		self:ClearObjects()
		return false
	end

	local Phys2 = tr.Entity:GetPhysicsObjectNum( tr.PhysicsBone )
	self:SetObject( 2, tr.Entity, tr.HitPos, Phys2, tr.PhysicsBone, tr.HitNormal )

	if ( CLIENT ) then
		self:ClearObjects()
		return true
	end

	-- Get client's CVars
	local width = self:GetClientNumber( "width", 3 )
	local bind = self:GetClientNumber( "group", 1 )
	local AddLength = self:GetClientNumber( "addlength", 0 )
	local fixed = self:GetClientNumber( "fixed", 1 )
	local period = self:GetClientNumber( "period", 64 )
	local starton = self:GetClientNumber( "starton" )
	local material = self:GetClientInfo( "material" )
	local colorR = self:GetClientNumber( "color_r" )
	local colorG = self:GetClientNumber( "color_g" )
	local colorB = self:GetClientNumber( "color_b" )

	-- Get information we're about to use
	local Ent1, Ent2 = self:GetEnt( 1 ), self:GetEnt( 2 )
	local Bone1, Bone2 = self:GetBone( 1 ), self:GetBone( 2 )
	local LPos1, LPos2 = self:GetLocalPos( 1 ), self:GetLocalPos( 2 )
	local WPos1, WPos2 = self:GetPos( 1 ), self:GetPos( 2 )

	local Length1 = ( WPos1 - WPos2 ):Length()
	local Length2 = Length1 + AddLength

	local amp = Length2 - Length1

	local constr, rope, controller, slider = constraint.Muscle( self:GetOwner(), Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, Length1, Length2, width, bind, fixed, period, amp, starton, material, Color( colorR, colorG, colorB, 255 ) )
	if ( IsValid( constr ) ) then
		undo.Create( "Muscle" )
			undo.AddEntity( constr )
			if ( IsValid( rope ) ) then undo.AddEntity( rope ) end
			if ( IsValid( slider ) ) then undo.AddEntity( slider ) end
			if ( IsValid( controller ) ) then undo.AddEntity( controller ) end
			undo.SetPlayer( self:GetOwner() )
		undo.Finish()

		self:GetOwner():AddCleanup( "ropeconstraints", constr )
		if ( IsValid( rope ) ) then self:GetOwner():AddCleanup( "ropeconstraints", rope ) end
		if ( IsValid( slider ) ) then self:GetOwner():AddCleanup( "ropeconstraints", slider ) end
		if ( IsValid( controller ) ) then self:GetOwner():AddCleanup( "ropeconstraints", controller ) end
	end

	-- Clear the objects so we're ready to go again
	self:ClearObjects()

	return true

end

function TOOL:Reload( trace )

	if ( !IsValid( trace.Entity ) || trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end

	return constraint.RemoveConstraints( trace.Entity, "Muscle" )

end

function TOOL:Holster()

	self:ClearObjects()

end

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Description = "#tool.muscle.help" } )

	CPanel:AddControl( "ComboBox", { MenuButton = 1, Folder = "muscle", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

	CPanel:AddControl( "Numpad", { Label = "#tool.muscle.numpad", Command = "muscle_group" } )
	CPanel:AddControl( "Slider", { Label = "#tool.muscle.length", Command = "muscle_addlength", Type = "Float", Min = -1000, Max = 1000, Help = true } )
	CPanel:AddControl( "Slider", { Label = "#tool.muscle.period", Command = "muscle_period", Type = "Float", Min = 0, Max = 10, Help = true } )
	CPanel:AddControl( "CheckBox", { Label = "#tool.muscle.fixed", Command = "muscle_fixed", Help = true } )
	CPanel:AddControl( "CheckBox", { Label = "#tool.muscle.starton", Command = "muscle_starton", Help = true } )

	CPanel:AddControl( "Slider", { Label = "#tool.muscle.width", Command = "muscle_width", Type = "Float", Min = 0, Max = 5 } )
	CPanel:AddControl( "RopeMaterial", { Label = "#tool.muscle.material", ConVar = "muscle_material" } )
	CPanel:AddControl( "Color", { Label = "#tool.muscle.color", Red = "muscle_color_r", Green = "muscle_color_g", Blue = "muscle_color_b" } )

end
