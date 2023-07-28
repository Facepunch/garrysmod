
TOOL.Category = "Construction"
TOOL.Name = "#tool.emitter.name"

TOOL.ClientConVar[ "key" ] = "51"
TOOL.ClientConVar[ "delay" ] = "1"
TOOL.ClientConVar[ "toggle" ] = "1"
TOOL.ClientConVar[ "starton" ] = "0"
TOOL.ClientConVar[ "effect" ] = "sparks"
TOOL.ClientConVar[ "scale" ] = "1"

TOOL.Information = {
	{ name = "left" },
	{ name = "right" }
}

cleanup.Register( "emitters" )

function TOOL:LeftClick( trace, worldweld )

	if ( trace.Entity && trace.Entity:IsPlayer() ) then return false end

	-- If there's no physics object then we can't constraint it!
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end

	if ( CLIENT ) then return true end

	local ply = self:GetOwner()

	local key = self:GetClientNumber( "key" )
	local effect = self:GetClientInfo( "effect" )
	local toggle = self:GetClientNumber( "toggle" ) == 1
	local starton = self:GetClientNumber( "starton" ) == 1
	local scale = math.Clamp( self:GetClientNumber( "scale" ), 0.1, 6 )
	local delay = math.Clamp( self:GetClientNumber( "delay" ), 0.05, 20 )

	-- We shot an existing emitter - just change its values
	if ( IsValid( trace.Entity ) && trace.Entity:GetClass() == "gmod_emitter" && trace.Entity.pl == ply ) then

		trace.Entity:SetEffect( effect )
		trace.Entity:SetDelay( delay )
		trace.Entity:SetToggle( toggle )
		trace.Entity:SetScale( scale )

		numpad.Remove( trace.Entity.NumDown )
		numpad.Remove( trace.Entity.NumUp )

		trace.Entity.NumDown = numpad.OnDown( ply, key, "Emitter_On", trace.Entity )
		trace.Entity.NumUp = numpad.OnUp( ply, key, "Emitter_Off", trace.Entity )

		trace.Entity.key = key

		return true

	end

	if ( !self:GetSWEP():CheckLimit( "emitters" ) ) then return false end

	local pos = trace.HitPos
	if ( trace.Entity != NULL && ( !trace.Entity:IsWorld() || worldweld ) ) then else
		pos = pos + trace.HitNormal
	end

	local ang = trace.HitNormal:Angle()
	ang:RotateAroundAxis( trace.HitNormal, 0 )

	local emitter = MakeEmitter( ply, key, delay, toggle, effect, starton, nil, scale, { Pos = pos, Angle = ang } )
	if ( !IsValid( emitter ) ) then return false end

	undo.Create( "Emitter" )
		undo.AddEntity( emitter )

		-- Don't weld to world
		if ( trace.Entity != NULL && ( !trace.Entity:IsWorld() || worldweld ) ) then
			local weld = constraint.Weld( emitter, trace.Entity, 0, trace.PhysicsBone, 0, true, true )
			if ( IsValid( weld ) ) then
				ply:AddCleanup( "emitters", weld )
				undo.AddEntity( weld )
			end

			if ( IsValid( emitter:GetPhysicsObject() ) ) then emitter:GetPhysicsObject():EnableCollisions( false ) end
			emitter.nocollide = true
		end

		undo.SetPlayer( ply )
	undo.Finish()

	return true

end

function TOOL:RightClick( trace )

	return self:LeftClick( trace, true )

end

if ( SERVER ) then

	function MakeEmitter( ply, key, delay, toggle, effect, starton, nocollide, scale, Data )

		if ( IsValid( ply ) && !ply:CheckLimit( "emitters" ) ) then return nil end

		local emitter = ents.Create( "gmod_emitter" )
		if ( !IsValid( emitter ) ) then return false end

		duplicator.DoGeneric( emitter, Data )
		emitter:SetEffect( effect )
		emitter:SetPlayer( ply )
		emitter:SetDelay( delay )
		emitter:SetToggle( toggle )
		emitter:SetOn( starton )
		emitter:SetScale( scale or 1 )

		emitter:Spawn()

		DoPropSpawnedEffect( emitter )

		emitter.NumDown = numpad.OnDown( ply, key, "Emitter_On", emitter )
		emitter.NumUp = numpad.OnUp( ply, key, "Emitter_Off", emitter )

		if ( nocollide && IsValid( emitter:GetPhysicsObject() ) ) then
			emitter:GetPhysicsObject():EnableCollisions( false )
		end

		local ttable = {
			key = key,
			delay = delay,
			toggle = toggle,
			effect = effect,
			pl = ply,
			nocollide = nocollide,
			starton = starton,
			scale = scale
		}

		table.Merge( emitter:GetTable(), ttable )

		if ( IsValid( ply ) ) then
			ply:AddCount( "emitters", emitter )
			ply:AddCleanup( "emitters", emitter )
		end

		return emitter

	end

	duplicator.RegisterEntityClass( "gmod_emitter", MakeEmitter, "key", "delay", "toggle", "effect", "starton", "nocollide", "scale", "Data" )

end

function TOOL:UpdateGhostEmitter( ent, pl )

	if ( !IsValid( ent ) ) then return end

	local trace = pl:GetEyeTrace()
	if ( !trace.Hit || IsValid( trace.Entity ) && ( trace.Entity:GetClass() == "gmod_emitter" || trace.Entity:IsPlayer() ) ) then

		ent:SetNoDraw( true )
		return

	end

	ent:SetPos( trace.HitPos )
	ent:SetAngles( trace.HitNormal:Angle() )

	ent:SetNoDraw( false )

end

function TOOL:Think()

	if ( !IsValid( self.GhostEntity ) || self.GhostEntity:GetModel() != "models/props_lab/tpplug.mdl" ) then
		self:MakeGhostEntity( "models/props_lab/tpplug.mdl", vector_origin, angle_zero )
	end

	self:UpdateGhostEmitter( self.GhostEntity, self:GetOwner() )

end

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Description = "#tool.emitter.desc" } )

	CPanel:AddControl( "ComboBox", { MenuButton = 1, Folder = "emitter", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

	CPanel:AddControl( "Numpad", { Label = "#tool.emitter.key", Command = "emitter_key" } )

	CPanel:AddControl( "Slider", { Label = "#tool.emitter.delay", Command = "emitter_delay", Type = "Float", Min = 0.01, Max = 2 } )
	CPanel:AddControl( "Slider", { Label = "#tool.emitter.scale", Command = "emitter_scale", Type = "Float", Min = 0, Max = 6, Help = true } )

	CPanel:AddControl( "Checkbox", { Label = "#tool.emitter.toggle", Command = "emitter_toggle" } )
	CPanel:AddControl( "Checkbox", { Label = "#tool.emitter.starton", Command = "emitter_starton" } )

	local matselect = CPanel:MatSelect( "emitter_effect", nil, true, 0.25, 0.25 )
	for k, v in pairs( list.Get( "EffectType" ) ) do
		matselect:AddMaterialEx( v.print, v.material or "gui/effects/default.png", k, { emitter_effect = k } )
	end

	CPanel:AddItem( matselect )

end
