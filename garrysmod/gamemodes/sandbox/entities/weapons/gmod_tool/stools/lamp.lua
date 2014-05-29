
TOOL.Category = "Construction"
TOOL.Name = "#tool.lamp.name"

TOOL.ClientConVar[ "r" ] = "255"
TOOL.ClientConVar[ "g" ] = "255"
TOOL.ClientConVar[ "b" ] = "255"
TOOL.ClientConVar[ "key" ] = "-1"
TOOL.ClientConVar[ "fov" ] = "90"
TOOL.ClientConVar[ "distance" ] = "1024"
TOOL.ClientConVar[ "brightness" ] = "4"
TOOL.ClientConVar[ "texture" ] = "effects/flashlight001"
TOOL.ClientConVar[ "model" ] = "models/lamps/torch.mdl"
TOOL.ClientConVar[ "toggle" ] = "1"

cleanup.Register( "lamps" )

function TOOL:LeftClick( trace )

	if ( IsValid( trace.Entity ) && trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end

	local ply = self:GetOwner()
	local pos = trace.HitPos

	local r = math.Clamp( self:GetClientNumber( "r" ), 0, 255 )
	local g = math.Clamp( self:GetClientNumber( "g" ), 0, 255 )
	local b = math.Clamp( self:GetClientNumber( "b" ), 0, 255 )
	local key = self:GetClientNumber( "key" )
	local texture = self:GetClientInfo( "texture" )
	local mdl = self:GetClientInfo( "model" )
	local fov = self:GetClientNumber( "fov" )
	local distance = self:GetClientNumber( "distance" )
	local bright = self:GetClientNumber( "brightness" )
	local toggle = self:GetClientNumber( "toggle" ) != 1

	local mat = Material( texture )
	local texture = mat:GetString( "$basetexture" )

	if	( IsValid( trace.Entity ) && trace.Entity:GetClass() == "gmod_lamp" && trace.Entity:GetPlayer() == ply ) then
	
		trace.Entity:SetColor( Color( r, g, b, 255 ) )
		trace.Entity:SetFlashlightTexture( texture )
		trace.Entity:SetLightFOV( fov )
		trace.Entity:SetDistance( distance )
		trace.Entity:SetBrightness( bright )
		trace.Entity:SetToggle( !toggle )
		trace.Entity:UpdateLight()

		numpad.Remove( trace.Entity.NumDown )
		numpad.Remove( trace.Entity.NumUp )

		trace.Entity.NumDown = numpad.OnDown( ply, key, "LampToggle", trace.Entity, 1 )
		trace.Entity.NumUp = numpad.OnUp( ply, key, "LampToggle", trace.Entity, 0 )
		
		-- For duplicator
		trace.Entity.Texture = texture
		trace.Entity.fov = fov
		trace.Entity.distance = distance
		trace.Entity.r = r
		trace.Entity.g = g
		trace.Entity.b = b
		trace.Entity.brightness	= bright
		trace.Entity.KeyDown = key

		return true
		
	end
	
	if ( !self:GetSWEP():CheckLimit( "lamps" ) ) then return false end

	local lamp = MakeLamp( ply, r, g, b, key, toggle, texture, mdl, fov, distance, bright, !toggle, { Pos = pos, Angle = Angle( 0, 0, 0 ) } )
	
	local CurPos = lamp:GetPos()
	local NearestPoint = lamp:NearestPoint( CurPos - ( trace.HitNormal * 512 ) )
	local LampOffset = CurPos - NearestPoint
	
	lamp:SetPos( trace.HitPos + LampOffset )
	
	undo.Create( "Lamp" )
		undo.AddEntity( lamp )
		undo.SetPlayer( self:GetOwner() )
	undo.Finish()

	return true

end

function TOOL:RightClick( trace )

	if ( !IsValid( trace.Entity ) || trace.Entity:GetClass() != "gmod_lamp" ) then return false end
	if ( CLIENT ) then return true end
	
	local ent = trace.Entity
	local pl = self:GetOwner()

	pl:ConCommand( "lamp_fov " .. ent:GetLightFOV() )
	pl:ConCommand( "lamp_distance " .. ent:GetDistance() )
	pl:ConCommand( "lamp_brightness " .. ent:GetBrightness() )
	pl:ConCommand( "lamp_texture " .. ent:GetFlashlightTexture() )
	
	if ( ent:GetToggle() ) then
		pl:ConCommand( "lamp_toggle 1" )
	else
		pl:ConCommand( "lamp_toggle 0" )
	end
	
	local clr = ent:GetColor()
	pl:ConCommand( "lamp_r " .. clr.r )
	pl:ConCommand( "lamp_g " .. clr.g )
	pl:ConCommand( "lamp_b " .. clr.b )

	return true

end

if ( SERVER ) then

	function MakeLamp( pl, r, g, b, KeyDown, toggle, Texture, Model, fov, distance, brightness, on, Data )
	
		if ( IsValid( pl ) && !pl:CheckLimit( "lamps" ) ) then return false end
	
		local lamp = ents.Create( "gmod_lamp" )
		
		if ( !IsValid( lamp ) ) then return end

		lamp:SetModel( Model )
		lamp:SetFlashlightTexture( Texture )
		lamp:SetLightFOV( fov )
		lamp:SetColor( Color( r, g, b, 255 ) )
		lamp:SetDistance( distance )
		lamp:SetBrightness( brightness )
		lamp:Switch( on )
		lamp:SetToggle( !toggle )

		duplicator.DoGeneric( lamp, Data )
	
		lamp:Spawn()

		duplicator.DoGenericPhysics( lamp, pl, Data )
		
		lamp:SetPlayer( pl )
	
		if ( IsValid( pl ) ) then
			pl:AddCount( "lamps", lamp )
			pl:AddCleanup( "lamps", lamp )
		end
		
		lamp.Texture = Texture
		lamp.KeyDown = KeyDown
		lamp.fov = fov
		lamp.distance = distance
		lamp.r = r
		lamp.g = g
		lamp.b = b
		lamp.brightness	= brightness

		lamp.NumDown = numpad.OnDown( pl, KeyDown, "LampToggle", lamp, 1 )
		lamp.NumUp = numpad.OnUp( pl, KeyDown, "LampToggle", lamp, 0 )
		
		return lamp

	end
	duplicator.RegisterEntityClass( "gmod_lamp", MakeLamp, "r", "g", "b", "KeyDown", "Toggle", "Texture", "Model", "fov", "distance", "brightness", "on", "Data" )

	local function Toggle( pl, ent, onoff )
	
		if ( !IsValid( ent ) ) then return false end
		if ( !ent:GetToggle() ) then ent:Switch( onoff == 1 ) return end

		if ( numpad.FromButton() ) then

			ent:Toggle()
			return

		end

		if ( onoff == 0 ) then return end
		
		return ent:Toggle()
		
	end
	numpad.Register( "LampToggle", Toggle )
	
end

function TOOL:UpdateGhostLamp( ent, player )

	if ( !IsValid( ent ) ) then return end
	
	local tr = util.GetPlayerTrace( player )
	local trace	= util.TraceLine( tr )
	if ( !trace.Hit ) then return end
	
	if ( trace.Entity:IsPlayer() || trace.Entity:GetClass() == "gmod_lamp" ) then
	
		ent:SetNoDraw( true )
		return
		
	end

	local CurPos = ent:GetPos()
	local NearestPoint = ent:NearestPoint( CurPos - ( trace.HitNormal * 512 ) )
	local LampOffset = CurPos - NearestPoint
	
	ent:SetPos( trace.HitPos + LampOffset )
	
	ent:SetNoDraw( false )
	
end

function TOOL:Think()

	if ( !IsValid( self.GhostEntity ) || self.GhostEntity:GetModel() != self:GetClientInfo( "model" ) ) then
		self:MakeGhostEntity( self:GetClientInfo( "model" ), Vector( 0, 0, 0 ), Angle( 0, 0, 0 ) )
	end
	
	self:UpdateGhostLamp( self.GhostEntity, self:GetOwner() )
	
end

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Description = "#tool.lamp.desc" } )

	CPanel:AddControl( "ComboBox", { MenuButton = 1, Folder = "lamp", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

	CPanel:AddControl( "Numpad", { Label = "#tool.lamp.key", Command = "lamp_key" } )

	CPanel:AddControl( "Slider", { Label = "#tool.lamp.fov", Command = "lamp_fov", Type = "Float", Min = 10, Max = 170 } )
	CPanel:AddControl( "Slider", { Label = "#tool.lamp.distance", Command = "lamp_distance", Min = 64, Max = 2048 } )
	CPanel:AddControl( "Slider", { Label = "#tool.lamp.brightness", Command = "lamp_brightness", Type = "Float", Min = 0, Max = 8 } )

	CPanel:AddControl( "Checkbox", { Label = "#tool.lamp.toggle", Command = "lamp_toggle" } )

	local MatSelect = CPanel:MatSelect( "lamp_texture", nil, true, 0.33, 0.33 )
	
	for k, v in pairs( list.Get( "LampTextures" ) ) do
		MatSelect:AddMaterial( v.Name or k, k )
	end

	CPanel:AddControl( "Color", { Label = "#tool.lamp.color", Red = "lamp_r", Green = "lamp_g", Blue = "lamp_b" } )
	
	CPanel:AddControl( "PropSelect", { Label = "#tool.lamp.model", ConVar = "lamp_model", Height = 3, Models = list.Get( "LampModels" ) } )
end

list.Set( "LampTextures", "effects/flashlight001", { Name = "#lamptexture.default" } )
list.Set( "LampTextures", "effects/flashlight/slit", { Name = "#lamptexture.slit" } )
list.Set( "LampTextures", "effects/flashlight/circles", { Name = "#lamptexture.circles" } )
list.Set( "LampTextures", "effects/flashlight/window", { Name = "#lamptexture.window" } )
list.Set( "LampTextures", "effects/flashlight/logo", { Name = "#lamptexture.logo" } )
list.Set( "LampTextures", "effects/flashlight/gradient", { Name = "#lamptexture.gradient" } )
list.Set( "LampTextures", "effects/flashlight/bars", { Name = "#lamptexture.bars" } )
list.Set( "LampTextures", "effects/flashlight/tech", { Name = "#lamptexture.techdemo" } )
list.Set( "LampTextures", "effects/flashlight/soft", { Name = "#lamptexture.soft" } )
list.Set( "LampTextures", "effects/flashlight/hard", { Name = "#lamptexture.hard" } )
list.Set( "LampTextures", "effects/flashlight/caustics", { Name = "#lamptexture.caustics" } )
list.Set( "LampTextures", "effects/flashlight/square", { Name = "#lamptexture.square" } )
list.Set( "LampTextures", "effects/flashlight/camera", { Name = "#lamptexture.camera" } )
list.Set( "LampTextures", "effects/flashlight/view", { Name = "#lamptexture.view" } )

list.Set( "LampModels", "models/lamps/torch.mdl", {} )
list.Set( "LampModels", "models/maxofs2d/lamp_flashlight.mdl", {} )
list.Set( "LampModels", "models/maxofs2d/lamp_projector.mdl", {} )
