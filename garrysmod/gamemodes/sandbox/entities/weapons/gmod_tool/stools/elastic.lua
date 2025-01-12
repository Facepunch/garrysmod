
TOOL.Category = "Constraints"
TOOL.Name = "#tool.elastic.name"

TOOL.ClientConVar[ "constant" ] = "500"
TOOL.ClientConVar[ "damping" ] = "3"
TOOL.ClientConVar[ "rdamping" ] = "0.01"
TOOL.ClientConVar[ "material" ] = "cable/cable"
TOOL.ClientConVar[ "width" ] = "2"
TOOL.ClientConVar[ "stretch_only" ] = "1"
TOOL.ClientConVar[ "color_r" ] = "255"
TOOL.ClientConVar[ "color_g" ] = "255"
TOOL.ClientConVar[ "color_b" ] = "255"

TOOL.Information = {
	{ name = "left", stage = 0 },
	{ name = "left_1", stage = 1 },
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
		local width = self:GetClientNumber( "width" )
		local material = self:GetClientInfo( "material" )
		local damping = self:GetClientNumber( "damping" )
		local rdamping = self:GetClientNumber( "rdamping" )
		local constant = self:GetClientNumber( "constant" )
		local stretchonly = self:GetClientNumber( "stretch_only" )
		local colorR = self:GetClientNumber( "color_r" )
		local colorG = self:GetClientNumber( "color_g" )
		local colorB = self:GetClientNumber( "color_b" )

		-- Get information we're about to use
		local Ent1, Ent2 = self:GetEnt( 1 ), self:GetEnt( 2 )
		local Bone1, Bone2 = self:GetBone( 1 ), self:GetBone( 2 )
		local LPos1, LPos2 = self:GetLocalPos( 1 ),	self:GetLocalPos( 2 )

		-- Create the constraint
		local constr, rope = constraint.Elastic( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, constant, damping, rdamping, material, width, stretchonly, Color( colorR, colorG, colorB ) )

		-- Create an undo if the constraint was created
		if ( IsValid( constr ) ) then
			undo.Create( "Elastic" )
				undo.AddEntity( constr )
				if ( IsValid( rope ) ) then undo.AddEntity( rope ) end
				undo.SetPlayer( ply )
			undo.Finish()

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

function TOOL:Reload( trace )

	if ( !IsValid( trace.Entity ) || trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end

	return constraint.RemoveConstraints( trace.Entity, "Elastic" )

end

function TOOL:Holster()

	self:ClearObjects()

end

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel( CPanel )

	CPanel:Help( "#tool.elastic.help" )

	-- Presets
	local presets = vgui.Create( "ControlPresets", CPanel )
	presets:SetPreset( "elastic" )
	presets:AddOption( "#preset.default", ConVarsDefault )
	for k, v in pairs( table.GetKeys( ConVarsDefault ) ) do
		presets:AddConVar( v )
	end
	CPanel:AddPanel( presets )

	-- Constant
	local constant = CPanel:NumSlider( "#tool.elastic.constant", "elastic_constant", 0, 4000, 2 )
	local constantDefault = GetConVar( "elastic_constant" )
	CPanel:ControlHelp( "#tool.elastic.constant" .. ".help" )
	if ( constantDefault ) then
		constant:SetDefaultValue( constantDefault:GetDefault() )
	end

	-- Damping
	local damping = CPanel:NumSlider( "#tool.elastic.damping", "elastic_damping", 0, 50, 2 )
	local dampingDefault = GetConVar( "elastic_damping" )
	CPanel:ControlHelp( "#tool.elastic.damping" .. ".help" )
	if ( dampingDefault ) then
		damping:SetDefaultValue( dampingDefault:GetDefault() )
	end

	-- RDamping
	local rdamping = CPanel:NumSlider( "#tool.elastic.rdamping", "elastic_rdamping", 0, 1, 2 )
	local rdampingDefault = GetConVar( "elastic_rdamping" )
	CPanel:ControlHelp( "#tool.elastic.rdamping" .. ".help" )
	if ( rdampingDefault ) then
		rdamping:SetDefaultValue( rdampingDefault:GetDefault() )
	end

	-- Stretch only
	CPanel:CheckBox( "#tool.elastic.stretchonly", "elastic_stretch_only" )
	CPanel:ControlHelp( "#tool.elastic.stretchonly" .. ".help" )

	-- Width
	local width = CPanel:NumSlider( "#tool.elastic.width", "elastic_width", 0, 20, 2 )
	local widthDefault = GetConVar( "elastic_width" )
	if ( widthDefault ) then
		width:SetDefaultValue( widthDefault:GetDefault() )
	end

	-- Material
	local material = vgui.Create( "RopeMaterial", CPanel )
	material:SetConVar( "elastic_material" )
	CPanel:AddPanel( material )

	-- Color
	local color = vgui.Create( "CtrlColor", CPanel )
	color:SetLabel( "#tool.elastic.color" )
	color:SetConVarR( "elastic_color_r" )
	color:SetConVarG( "elastic_color_g" )
	color:SetConVarB( "elastic_color_b" )
	CPanel:AddPanel( color )

end
