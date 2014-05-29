
TOOL.Category = "Construction"
TOOL.Name = "#tool.light.name"

TOOL.ClientConVar[ "ropelength" ] = "64"
TOOL.ClientConVar[ "ropematerial" ] = "cable/rope"
TOOL.ClientConVar[ "r" ] = "255"
TOOL.ClientConVar[ "g" ] = "255"
TOOL.ClientConVar[ "b" ] = "255"
TOOL.ClientConVar[ "brightness" ] = "2"
TOOL.ClientConVar[ "size" ] = "256"
TOOL.ClientConVar[ "key" ] = "-1"
TOOL.ClientConVar[ "toggle" ] = "1"

cleanup.Register( "lights" )

function TOOL:LeftClick( trace, attach )

	if trace.Entity && trace.Entity:IsPlayer() then return false end
	if ( CLIENT ) then return true end
	if ( attach == nil ) then attach = true end
	
	-- If there's no physics object then we can't constraint it!
	if ( SERVER && attach && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end
	
	local ply = self:GetOwner()
	
	local pos, ang = trace.HitPos + trace.HitNormal * 8, trace.HitNormal:Angle() - Angle( 90, 0, 0 )

	local r = math.Clamp( self:GetClientNumber( "r" ), 0, 255 )
	local g = math.Clamp( self:GetClientNumber( "g" ), 0, 255 )
	local b = math.Clamp( self:GetClientNumber( "b" ), 0, 255 )
	local brght = math.Clamp( self:GetClientNumber( "brightness" ), 0, 255 )
	local size = self:GetClientNumber( "size" )
	local toggle = self:GetClientNumber( "toggle" ) != 1
	
	local key = self:GetClientNumber( "key" )
	
	-- Clamp for multiplayer
	if ( !game.SinglePlayer() ) then
		size = math.Clamp( size, 0, 512 )
		brght = math.Clamp( brght, 0, 1 )
	end
	
	if	( IsValid( trace.Entity ) && trace.Entity:GetClass() == "gmod_light" && trace.Entity:GetPlayer() == ply ) then

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

	local lamp = MakeLight( ply, r, g, b, brght, size, toggle, !toggle, key, { Pos = pos, Angle = ang } )
	
	if ( !attach ) then

		undo.Create( "Light" )
			undo.AddEntity( lamp )
			undo.SetPlayer( self:GetOwner() )
		undo.Finish()
		
		return true
		
	end

	local length = math.Clamp( self:GetClientNumber( "ropelength" ), 4, 1024 )
	local material = self:GetClientInfo( "ropematerial" )
	
	local LPos1 = Vector( 0, 0, 5 )
	local LPos2 = trace.Entity:WorldToLocal( trace.HitPos )
	
	if ( IsValid( trace.Entity ) ) then
		
		local phys = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone )
		if ( IsValid( phys ) ) then
			LPos2 = phys:WorldToLocal( trace.HitPos )
		end
	
	end
	
	local constraint, rope = constraint.Rope( lamp, trace.Entity, 0, trace.PhysicsBone, LPos1, LPos2, 0, length, 0, 1, material )

	undo.Create( "Light" )
		undo.AddEntity( lamp )
		undo.AddEntity( rope )
		undo.AddEntity( constraint )
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
	
		local lamp = ents.Create( "gmod_light" )
		
		if ( !IsValid( lamp ) ) then return end
		
		duplicator.DoGeneric( lamp, Data )

		lamp:SetColor( Color( r, g, b, 255 ) )
		lamp:SetBrightness( brght )
		lamp:SetLightSize( size )
		lamp:SetToggle( !toggle )
		lamp:SetOn( on )

		lamp:Spawn()
		
		duplicator.DoGenericPhysics( lamp, pl, Data )
		
		lamp:SetPlayer( pl )
	
		if ( IsValid( pl ) ) then
			pl:AddCount( "lights", lamp )
			pl:AddCleanup( "lights", lamp )
		end
		
		lamp.lightr = r
		lamp.lightg = g
		lamp.lightb = b
		lamp.Brightness = brght
		lamp.Size = size
		lamp.KeyDown = KeyDown
		lamp.on = on
		
		lamp.NumDown = numpad.OnDown( pl, KeyDown, "LightToggle", lamp, 1 )
		lamp.NumUp = numpad.OnUp( pl, KeyDown, "LightToggle", lamp, 0 )

		return lamp
		
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

function TOOL:UpdateGhostLight( ent, player )

	if ( !IsValid( ent ) ) then return end
	
	local tr = util.GetPlayerTrace( player )
	local trace	= util.TraceLine( tr )
	if ( !trace.Hit ) then return end
	
	if ( trace.Entity:IsPlayer() || trace.Entity:GetClass() == "gmod_light" ) then
	
		ent:SetNoDraw( true )
		return
		
	end

	ent:SetPos( trace.HitPos + trace.HitNormal * 8 )
	ent:SetAngles( trace.HitNormal:Angle() - Angle( 90, 0, 0 ) )
	
	ent:SetNoDraw( false )
	
end

function TOOL:Think()

	if ( !IsValid( self.GhostEntity ) || self.GhostEntity:GetModel() != "models/MaxOfS2D/light_tubular.mdl" ) then
		self:MakeGhostEntity( "models/MaxOfS2D/light_tubular.mdl", Vector( 0, 0, 0 ), Angle( 0, 0, 0 ) )
	end
	
	self:UpdateGhostLight( self.GhostEntity, self:GetOwner() )
	
end

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Description = "#tool.light.desc" } )
	
	CPanel:AddControl( "ComboBox", { MenuButton = 1, Folder = "light", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )
	
	CPanel:AddControl( "Numpad", { Label = "#tool.light.key", Command = "light_key", ButtonSize = 22 } )
	
	CPanel:AddControl( "Slider", { Label = "#tool.light.ropelength", Command = "light_ropelength", Type = "Float", Min = 0, Max = 256 } )
	CPanel:AddControl( "Slider", { Label = "#tool.light.brightness", Command = "light_brightness", Type = "Float", Min = 0, Max = 10 } )
	CPanel:AddControl( "Slider", { Label = "#tool.light.size", Command = "light_size", Type = "Float", Min = 0, Max = 1024 } )

	CPanel:AddControl( "Checkbox", { Label = "#tool.light.toggle", Command = "light_toggle" } )
	
	CPanel:AddControl( "Color", { Label = "#tool.light.color", Red = "light_r", Green = "light_g", Blue = "light_b" } )

end
