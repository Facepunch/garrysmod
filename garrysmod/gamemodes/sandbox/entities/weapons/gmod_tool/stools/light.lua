
TOOL.Category = "Construction"
TOOL.Name = "#tool.light.name"

TOOL.ClientConVar[ "ropelength" ] = "64"
TOOL.ClientConVar[ "ropematerial" ] = "cable/rope"
TOOL.ClientConVar[ "r" ] = "255"
TOOL.ClientConVar[ "g" ] = "255"
TOOL.ClientConVar[ "b" ] = "255"
TOOL.ClientConVar[ "brightness" ] = "2"
TOOL.ClientConVar[ "size" ] = "256"
TOOL.ClientConVar[ "key" ] = "37"
TOOL.ClientConVar[ "toggle" ] = "1"

TOOL.Information = {
	{ name = "left" },
	{ name = "right" }
}

cleanup.Register( "lights" )

function TOOL:LeftClick( trace, attach )

	if ( IsValid( trace.Entity ) && trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end
	if ( attach == nil ) then attach = true end

	-- If there's no physics object then we can't constraint it!
	if ( SERVER && attach && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end

	local ply = self:GetOwner()

	local pos, ang = trace.HitPos + trace.HitNormal * 8, trace.HitNormal:Angle() - Angle( 90, 0, 0 )

	local r = math.Clamp( self:GetClientNumber( "r" ), 0, 255 )
	local g = math.Clamp( self:GetClientNumber( "g" ), 0, 255 )
	local b = math.Clamp( self:GetClientNumber( "b" ), 0, 255 )
	local brght = math.Clamp( self:GetClientNumber( "brightness" ), -10, 20 )
	local size = self:GetClientNumber( "size" )
	local toggle = self:GetClientNumber( "toggle" ) != 1

	local key = self:GetClientNumber( "key" )

	if ( IsValid( trace.Entity ) && trace.Entity:GetClass() == "gmod_light" && trace.Entity:GetPlayer() == ply ) then

		trace.Entity:SetColor( Color( r, g, b, 255 ) )
		trace.Entity.r = r
		trace.Entity.g = g
		trace.Entity.b = b
		trace.Entity.Brightness = brght
		trace.Entity.Size = size

		trace.Entity:SetBrightness( brght )
		trace.Entity:SetLightSize( size )
		trace.Entity:SetToggle( !toggle )

		trace.Entity.KeyDown = key

		numpad.Remove( trace.Entity.NumDown )
		numpad.Remove( trace.Entity.NumUp )

		trace.Entity.NumDown = numpad.OnDown( ply, key, "LightToggle", trace.Entity, 1 )
		trace.Entity.NumUp = numpad.OnUp( ply, key, "LightToggle", trace.Entity, 0 )

		return true

	end

	if ( !self:GetSWEP():CheckLimit( "lights" ) ) then return false end

	local light = MakeLight( ply, r, g, b, brght, size, toggle, !toggle, key, { Pos = pos, Angle = ang } )
	if ( !IsValid( light ) ) then return false end

	undo.Create( "Light" )
		undo.AddEntity( light )

		if ( attach ) then

			local length = math.Clamp( self:GetClientNumber( "ropelength" ), 4, 1024 )
			local material = self:GetClientInfo( "ropematerial" )

			local LPos1 = Vector( 0, 0, 6.5 )
			local LPos2 = trace.Entity:WorldToLocal( trace.HitPos )

			if ( IsValid( trace.Entity ) ) then

				local phys = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone )
				if ( IsValid( phys ) ) then
					LPos2 = phys:WorldToLocal( trace.HitPos )
				end

			end

			local constr, rope = constraint.Rope( light, trace.Entity, 0, trace.PhysicsBone, LPos1, LPos2, 0, length, 0, 1, material )
			if ( IsValid( constr ) ) then
				undo.AddEntity( constr )
				ply:AddCleanup( "lights", constr )
			end
			if ( IsValid( rope ) ) then
				undo.AddEntity( rope )
				ply:AddCleanup( "lights", rope )
			end

		end

		undo.SetPlayer( ply )
	undo.Finish()

	return true

end

function TOOL:RightClick( trace )

	return self:LeftClick( trace, false )

end

if ( SERVER ) then

	function MakeLight( pl, r, g, b, brght, size, toggle, on, KeyDown, Data )

		if ( IsValid( pl ) && !pl:CheckLimit( "lights" ) ) then return false end

		local light = ents.Create( "gmod_light" )
		if ( !IsValid( light ) ) then return end

		duplicator.DoGeneric( light, Data )

		light:SetColor( Color( r, g, b, 255 ) )
		light:SetBrightness( brght )
		light:SetLightSize( size )
		light:SetToggle( !toggle )
		light:SetOn( on )

		light:Spawn()

		DoPropSpawnedEffect( light )

		duplicator.DoGenericPhysics( light, pl, Data )

		light:SetPlayer( pl )

		light.lightr = r
		light.lightg = g
		light.lightb = b
		light.Brightness = brght
		light.Size = size
		light.KeyDown = KeyDown
		light.on = on

		light.NumDown = numpad.OnDown( pl, KeyDown, "LightToggle", light, 1 )
		light.NumUp = numpad.OnUp( pl, KeyDown, "LightToggle", light, 0 )

		if ( IsValid( pl ) ) then
			pl:AddCount( "lights", light )
			pl:AddCleanup( "lights", light )
		end

		return light

	end
	duplicator.RegisterEntityClass( "gmod_light", MakeLight, "lightr", "lightg", "lightb", "Brightness", "Size", "Toggle", "on", "KeyDown", "Data" )

	local function Toggle( pl, ent, onoff )

		if ( !IsValid( ent ) ) then return false end
		if ( !ent:GetToggle() ) then ent:SetOn( onoff == 1 ) return end

		if ( numpad.FromButton() ) then

			ent:SetOn( onoff == 1 )
			return

		end

		if ( onoff == 0 ) then return end

		return ent:Toggle()

	end
	numpad.Register( "LightToggle", Toggle )

end

function TOOL:UpdateGhostLight( ent, pl )

	if ( !IsValid( ent ) ) then return end

	local trace = pl:GetEyeTrace()
	if ( !trace.Hit || IsValid( trace.Entity ) && ( trace.Entity:IsPlayer() || trace.Entity:GetClass() == "gmod_light" ) ) then

		ent:SetNoDraw( true )
		return

	end

	ent:SetPos( trace.HitPos + trace.HitNormal * 8 )
	ent:SetAngles( trace.HitNormal:Angle() - Angle( 90, 0, 0 ) )

	ent:SetNoDraw( false )

end

function TOOL:Think()

	if ( !IsValid( self.GhostEntity ) || self.GhostEntity:GetModel() != "models/maxofs2d/light_tubular.mdl" ) then
		self:MakeGhostEntity( "models/maxofs2d/light_tubular.mdl", vector_origin, angle_zero )
	end

	self:UpdateGhostLight( self.GhostEntity, self:GetOwner() )

end

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Description = "#tool.light.desc" } )

	CPanel:AddControl( "ComboBox", { MenuButton = 1, Folder = "light", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

	CPanel:AddControl( "Numpad", { Label = "#tool.light.key", Command = "light_key", ButtonSize = 22 } )

	CPanel:AddControl( "Slider", { Label = "#tool.light.ropelength", Command = "light_ropelength", Type = "Float", Min = 0, Max = 256 } )
	CPanel:AddControl( "Slider", { Label = "#tool.light.brightness", Command = "light_brightness", Type = "Int", Min = -6, Max = 6 } )
	CPanel:AddControl( "Slider", { Label = "#tool.light.size", Command = "light_size", Type = "Float", Min = 0, Max = 1024 } )

	CPanel:AddControl( "Checkbox", { Label = "#tool.light.toggle", Command = "light_toggle" } )

	CPanel:AddControl( "Color", { Label = "#tool.light.color", Red = "light_r", Green = "light_g", Blue = "light_b" } )

end
