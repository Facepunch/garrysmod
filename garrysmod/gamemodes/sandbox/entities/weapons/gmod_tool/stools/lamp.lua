
TOOL.Category = "Construction"
TOOL.Name = "#tool.lamp.name"

TOOL.ClientConVar[ "r" ] = "255"
TOOL.ClientConVar[ "g" ] = "255"
TOOL.ClientConVar[ "b" ] = "255"
TOOL.ClientConVar[ "key" ] = "37"
TOOL.ClientConVar[ "fov" ] = "90"
TOOL.ClientConVar[ "distance" ] = "1024"
TOOL.ClientConVar[ "brightness" ] = "4"
TOOL.ClientConVar[ "texture" ] = "effects/flashlight001"
TOOL.ClientConVar[ "model" ] = "models/lamps/torch.mdl"
TOOL.ClientConVar[ "toggle" ] = "1"

TOOL.Information = {
	{ name = "left" },
	{ name = "right" },
}

cleanup.Register( "lamps" )

local function IsValidLampModel( model )
	for mdl, _ in pairs( list.Get( "LampModels" ) ) do
		if ( mdl:lower() == model:lower() ) then return true end
	end
	return false
end

function TOOL:LeftClick( trace )

	if ( IsValid( trace.Entity ) and trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end

	local ply = self:GetOwner()
	local pos = trace.HitPos

	local r = math.Clamp( self:GetClientNumber( "r" ), 0, 255 )
	local g = math.Clamp( self:GetClientNumber( "g" ), 0, 255 )
	local b = math.Clamp( self:GetClientNumber( "b" ), 0, 255 )
	local key = self:GetClientNumber( "key" )
	local mdl = self:GetClientInfo( "model" )
	local fov = self:GetClientNumber( "fov" )
	local distance = self:GetClientNumber( "distance" )
	local bright = self:GetClientNumber( "brightness" )
	local toggle = self:GetClientNumber( "toggle" ) != 1

	local tex = self:GetClientInfo( "texture" )
	local mat = Material( tex )
	local texture = mat:GetString( "$basetexture" )

	if ( IsValid( trace.Entity ) and trace.Entity:GetClass() == "gmod_lamp" and trace.Entity:GetPlayer() == ply ) then

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
		trace.Entity.brightness = bright
		trace.Entity.KeyDown = key

		return true

	end

	if ( !util.IsValidModel( mdl ) or !util.IsValidProp( mdl ) or !IsValidLampModel( mdl ) ) then return false end
	if ( !self:GetWeapon():CheckLimit( "lamps" ) ) then return false end

	local lamp = MakeLamp( ply, r, g, b, key, toggle, texture, mdl, fov, distance, bright, !toggle, { Pos = pos, Angle = angle_zero } )
	if ( !IsValid( lamp ) ) then return false end

	local CurPos = lamp:GetPos()
	local NearestPoint = lamp:NearestPoint( CurPos - ( trace.HitNormal * 512 ) )
	local LampOffset = CurPos - NearestPoint

	lamp:SetPos( trace.HitPos + LampOffset )

	undo.Create( "gmod_lamp" )
		undo.AddEntity( lamp )
		undo.SetPlayer( self:GetOwner() )
	undo.Finish()

	return true

end

function TOOL:RightClick( trace )

	if ( !IsValid( trace.Entity ) or trace.Entity:GetClass() != "gmod_lamp" ) then return false end
	if ( CLIENT ) then return true end

	local ent = trace.Entity
	local ply = self:GetOwner()

	ply:ConCommand( "lamp_fov " .. ent:GetLightFOV() )
	ply:ConCommand( "lamp_distance " .. ent:GetDistance() )
	ply:ConCommand( "lamp_brightness " .. ent:GetBrightness() )
	ply:ConCommand( "lamp_texture " .. ent:GetFlashlightTexture() )

	if ( ent:GetToggle() ) then
		ply:ConCommand( "lamp_toggle 1" )
	else
		ply:ConCommand( "lamp_toggle 0" )
	end

	local clr = ent:GetColor()
	ply:ConCommand( "lamp_r " .. clr.r )
	ply:ConCommand( "lamp_g " .. clr.g )
	ply:ConCommand( "lamp_b " .. clr.b )

	return true

end

if ( SERVER ) then

	function MakeLamp( ply, r, g, b, keyDown, toggle, texture, model, fov, distance, brightness, on, Data )

		if ( IsValid( ply ) and !ply:CheckLimit( "lamps" ) ) then return NULL end
		if ( !IsValidLampModel( model ) ) then return NULL end

		local lamp = ents.Create( "gmod_lamp" )
		if ( !IsValid( lamp ) ) then return NULL end

		duplicator.DoGeneric( lamp, Data )
		lamp:SetModel( model ) -- Backwards compatible for addons directly calling this function
		lamp:SetFlashlightTexture( texture )
		lamp:SetLightFOV( fov )
		lamp:SetColor( Color( r, g, b, 255 ) )
		lamp:SetDistance( distance )
		lamp:SetBrightness( brightness )
		lamp:Switch( on )
		lamp:SetToggle( !toggle )

		lamp:Spawn()

		DoPropSpawnedEffect( lamp )

		duplicator.DoGenericPhysics( lamp, ply, Data )

		lamp:SetPlayer( ply )

		if ( IsValid( ply ) ) then
			ply:AddCount( "lamps", lamp )
			ply:AddCleanup( "lamps", lamp )
		end

		lamp.Texture = texture
		lamp.KeyDown = keyDown
		lamp.fov = fov
		lamp.distance = distance
		lamp.r = r
		lamp.g = g
		lamp.b = b
		lamp.brightness = brightness

		lamp.NumDown = numpad.OnDown( ply, keyDown, "LampToggle", lamp, 1 )
		lamp.NumUp = numpad.OnUp( ply, keyDown, "LampToggle", lamp, 0 )

		return lamp

	end
	duplicator.RegisterEntityClass( "gmod_lamp", MakeLamp, "r", "g", "b", "KeyDown", "Toggle", "Texture", "Model", "fov", "distance", "brightness", "on", "Data" )

	numpad.Register( "LampToggle", function( ply, ent, onoff )

		if ( !IsValid( ent ) ) then return false end
		if ( !ent:GetToggle() ) then ent:Switch( onoff == 1 ) return end

		if ( numpad.FromButton() ) then

			ent:Switch( onoff == 1 )
			return

		end

		if ( onoff == 0 ) then return end

		return ent:Toggle()

	end )

end

function TOOL:UpdateGhostLamp( ent, ply )

	if ( !IsValid( ent ) ) then return end

	local trace = ply:GetEyeTrace()
	if ( !trace.Hit or IsValid( trace.Entity ) and ( trace.Entity:IsPlayer() or trace.Entity:GetClass() == "gmod_lamp" ) ) then

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

	local mdl = self:GetClientInfo( "model" )
	if ( !IsValidLampModel( mdl ) ) then self:ReleaseGhostEntity() return end

	if ( !IsValid( self.GhostEntity ) or self.GhostEntity:GetModel() != mdl:lower() ) then
		self:MakeGhostEntity( mdl, vector_origin, angle_zero )
	end

	self:UpdateGhostLamp( self.GhostEntity, self:GetOwner() )

end

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel( CPanel )

	CPanel:Help( "#tool.lamp.desc" )
	CPanel:ToolPresets( "lamp", ConVarsDefault )

	CPanel:KeyBinder( "#tool.lamp.key", "lamp_key" )

	CPanel:NumSlider( "#tool.lamp.fov", "lamp_fov", 10, 170 )
	CPanel:NumSlider( "#tool.lamp.distance", "lamp_distance", 64, 2048 )
	CPanel:NumSlider( "#tool.lamp.brightness", "lamp_brightness", 0, 8 )

	CPanel:CheckBox( "#tool.lamp.toggle", "lamp_toggle" )

	CPanel:ColorPicker( "#tool.lamp.color", "lamp_r", "lamp_g", "lamp_b" )

	local MatSelect = CPanel:MatSelect( "lamp_texture", nil, false, 0.33, 0.33 )
	MatSelect.Height = 4
	for k, v in pairs( list.Get( "LampTextures" ) ) do
		MatSelect:AddMaterial( v.Name or k, k )
	end

	CPanel:PropSelect( "#tool.lamp.model", "lamp_model", list.Get( "LampModels" ), 0 )

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
list.Set( "LampModels", "models/maxofs2d/lamp_flashlight.mdl", { Offset = Vector( 8.5, 0, 0 ) } )
list.Set( "LampModels", "models/maxofs2d/lamp_projector.mdl", { Offset = Vector( 8.5, 0, 0 ) } )
list.Set( "LampModels", "models/props_wasteland/light_spotlight01_lamp.mdl", { Offset = Vector( 9, 0, 4 ), Skin = 1, Scale = 3 } )
list.Set( "LampModels", "models/props_wasteland/light_spotlight02_lamp.mdl", { Offset = Vector( 5.5, 0, 0 ), Skin = 1 } )
list.Set( "LampModels", "models/props_c17/light_decklight01_off.mdl", { Offset = Vector( 3, 0, 0 ), Skin = 1, Scale = 3 } )
list.Set( "LampModels", "models/props_wasteland/prison_lamp001c.mdl", { Offset = Vector( 0, 0, -5 ), Angle = Angle( 90, 0, 0 ) } )

-- This works, but the ghost entity is invisible due to $alphatest...
--list.Set( "LampModels", "models/props_c17/lamp_standard_off01.mdl", { Offset = Vector( 5.20, 0.25, 8 ), Angle = Angle( 90, 0, 0 ), NearZ = 6 } )
