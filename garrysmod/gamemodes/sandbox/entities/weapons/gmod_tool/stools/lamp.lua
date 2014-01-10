
TOOL.Category		= "Construction"
TOOL.Name			= "#tool.lamp.name"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar[ "r" ]				= "255"
TOOL.ClientConVar[ "g" ]				= "255"
TOOL.ClientConVar[ "b" ]				= "255"
TOOL.ClientConVar[ "key" ]				= "-1"
TOOL.ClientConVar[ "fov" ]				= "90"
TOOL.ClientConVar[ "distance" ]			= "1024"
TOOL.ClientConVar[ "brightness" ]		= "7.5"
TOOL.ClientConVar[ "texture" ]			= "effects/flashlight001"
TOOL.ClientConVar[ "model" ]			= "models/lamps/torch.mdl"
TOOL.ClientConVar[ "toggle" ]			= "1"

cleanup.Register( "lamps" )

function TOOL:LeftClick( trace )

	if ( IsValid( trace.Entity ) && trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end

	local ply = self:GetOwner()
	local pos = trace.HitPos

	local r 		= math.Clamp( self:GetClientNumber( "r" ), 0, 255 )
	local g 		= math.Clamp( self:GetClientNumber( "g" ), 0, 255 )
	local b 		= math.Clamp( self:GetClientNumber( "b" ), 0, 255 )
	local key 		= self:GetClientNumber( "key" )
	local texture 	= self:GetClientInfo( "texture" )
	local mdl 		= self:GetClientInfo( "model" )
	local fov 		= self:GetClientNumber( "fov" )
	local distance	= self:GetClientNumber( "distance" )
	local bright	= self:GetClientNumber( "brightness" )
	local toggle	= self:GetClientNumber( "toggle" ) != 1

	local mat		= Material( texture )
	local texture	= mat:GetString( "$basetexture" )

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
		trace.Entity.Texture	= texture
		trace.Entity.fov		= fov
		trace.Entity.distance	= distance
		trace.Entity.r = r trace.Entity.g = g trace.Entity.b = b
		trace.Entity.brightness	= bright
		trace.Entity.KeyDown = key

		return true
		
	end
	
	if ( !self:GetSWEP():CheckLimit( "lamps" ) ) then return false end

	local lamp = MakeLamp( ply, r, g, b, key, toggle, texture, mdl, fov, distance, bright, !toggle, { Pos = pos, Angle = Angle(0, 0, 0) } )
	
	local CurPos = lamp:GetPos()
	local NearestPoint = lamp:NearestPoint( CurPos - ( trace.HitNormal * 512 ) )
	local LampOffset = CurPos - NearestPoint
	
	lamp:SetPos( trace.HitPos + LampOffset )
	
	undo.Create("Lamp")
		undo.AddEntity( lamp )
		undo.SetPlayer( self:GetOwner() )
	undo.Finish()

	return true

end

function TOOL:RightClick( trace )

	return false

end

if ( SERVER ) then

	function MakeLamp( pl, r, g, b, KeyDown, toggle, Texture, Model, fov, distance, brightness, on, Data )
	
		if ( IsValid( pl ) ) then
			if ( !pl:CheckLimit( "lamps" ) ) then return false end
		end
	
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
		
		lamp.Texture	= Texture
		lamp.KeyDown	= KeyDown
		lamp.fov		= fov
		lamp.distance	= distance
		lamp.r			= r
		lamp.g			= g
		lamp.b			= b
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
			return;

		end

		if ( onoff == 0 ) then return end
		
		return ent:Toggle()
		
	end
	
	numpad.Register( "LampToggle", Toggle )
	
end

function TOOL:UpdateGhostLamp( ent, player )

	if ( !IsValid( ent ) ) then return end
	
	local tr	= util.GetPlayerTrace( player )
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

function TOOL.BuildCPanel( CPanel )

	-- HEADER
	CPanel:AddControl( "Header", { Text = "#tool.lamp.name", Description = "#tool.lamp.desc" }  )

	-- Presets
	local params = { Label = "#tool.presets", MenuButton = 1, Folder = "lamp", Options = {}, CVars = { "lamp_texture", "lamp_r", "lamp_g", "lamp_b", "lamp_key", "lamp_model", "lamp_toggle" } }
		
		params.Options.default = {
			lamp_texture		=		"effects/flashlight001",
			lamp_r				=		255,
			lamp_g				=		255,
			lamp_b				=		255,
			lamp_key			=		-1,
			lamp_model			=		"models/MaxOfS2D/lamp_projector.mdl",
			lamp_toggle			=		0
		}
					
	CPanel:AddControl( "ComboBox", params )

	CPanel:AddControl( "Numpad", { Label = "#tool.lamp.toggle", Command = "lamp_key" } )

	CPanel:NumSlider( "#tool.lamp.fov", "lamp_fov", 10, 170, 2 )
	CPanel:NumSlider( "#tool.lamp.distance", "lamp_distance", 64, 2048, 0 )
	CPanel:NumSlider( "#tool.lamp.brightness", "lamp_brightness", 0, 8, 2 )

	CPanel:AddControl( "Checkbox", { Label = "#tool.lamp.toggle", Command = "lamp_toggle" } )

	CPanel:AddControl( "Color",  { Label	= "#tool.lamp.color",
									Red			= "lamp_r",
									Green		= "lamp_g",
									Blue		= "lamp_b",
									ShowAlpha	= 0,
									ShowHSV		= 1,
									ShowRGB 	= 1,
									Multiplier	= 255 } )	
	
	local MatSelect = CPanel:MatSelect( "lamp_texture", nil, true, 0.33, 0.33 )
	
	for k, v in pairs( list.Get( "LampTextures" ) ) do
		MatSelect:AddMaterial( v.Name or k, k )
	end

	CPanel:AddControl( "PropSelect", { Label = "#tool.lamp.model",
									 ConVar = "lamp_model",
									 Category = "Lamps",
									 Height = 3,
									 Models = list.Get( "LampModels" ) } )
end

list.Set( "LampTextures", "effects/flashlight001", { Name = "Default" } )
list.Set( "LampTextures", "effects/flashlight/slit", { Name = "Slit" } )
list.Set( "LampTextures", "effects/flashlight/circles", { Name = "Circles" } )
list.Set( "LampTextures", "effects/flashlight/window", { Name = "Window" } )
list.Set( "LampTextures", "effects/flashlight/logo", { Name = "Logo" } )
list.Set( "LampTextures", "effects/flashlight/gradient", { Name = "Gradient" } )
list.Set( "LampTextures", "effects/flashlight/bars", { Name = "Bars" } )
list.Set( "LampTextures", "effects/flashlight/tech", { Name = "Techdemo" } )
list.Set( "LampTextures", "effects/flashlight/soft", { Name = "Soft" } )
list.Set( "LampTextures", "effects/flashlight/hard", { Name = "Hard" } )
list.Set( "LampTextures", "effects/flashlight/caustics", { Name = "Caustics" } )
list.Set( "LampTextures", "effects/flashlight/square", { Name = "Square" } )
list.Set( "LampTextures", "effects/flashlight/camera", { Name = "Camera" } )
list.Set( "LampTextures", "effects/flashlight/view", { Name = "View" } )
--list.Set( "LampTextures", "effects/flashlight/spider", { Name = "Spider" } )
--list.Set( "LampTextures", "_rt_Camera", { Name = "RenderTarget" } )

list.Set( "LampModels", "models/lamps/torch.mdl", {} )
list.Set( "LampModels", "models/MaxOfS2D/lamp_flashlight.mdl", {} )
list.Set( "LampModels", "models/MaxOfS2D/lamp_projector.mdl", {} )
