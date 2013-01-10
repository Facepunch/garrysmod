
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
TOOL.ClientConVar[ "brightness" ]		= "10"
TOOL.ClientConVar[ "texture" ]			= "effects/flashlight001"

cleanup.Register( "lamps" )


function TOOL:LeftClick( trace )

	if ( IsValid( trace.Entity ) && trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end
	
	local ply = self:GetOwner()
	local pos, ang = trace.HitPos + trace.HitNormal * 10, trace.HitNormal:Angle()

	local r 		= math.Clamp( self:GetClientNumber( "r" ), 0, 255 )
	local g 		= math.Clamp( self:GetClientNumber( "g" ), 0, 255 )
	local b 		= math.Clamp( self:GetClientNumber( "b" ), 0, 255 )
	local key 		= self:GetClientNumber( "key" )
	local texture 	= self:GetClientInfo( "texture" )
	local fov 		= self:GetClientNumber( "fov" )
	local distance	= self:GetClientNumber( "distance" )
	local bright	= self:GetClientNumber( "brightness" )

	local mat		= Material( texture );
	local texture	= mat:GetString( "$basetexture" )

	if	( trace.Entity:IsValid() && trace.Entity:GetClass() == "gmod_lamp" && trace.Entity:GetPlayer() == ply ) then
	
		trace.Entity:SetColor( Color( r, g, b, 255 ) )
		trace.Entity:SetFlashlightTexture( texture )
		trace.Entity:SetLightFOV( fov )
		trace.Entity:SetDistance( distance )
		trace.Entity:SetBrightness( bright )
		trace.Entity:UpdateLight()

		-- For duplicator
		trace.Entity.Texture	= texture
		trace.Entity.fov		= fov
		trace.Entity.distance	= distance
		trace.Entity.r = r trace.Entity.g = g trace.Entity.b = b
		trace.Entity.brightness	= bright
		
		return true
		
	end
	
	if ( !self:GetSWEP():CheckLimit( "lamps" ) ) then return false end

	lamp = MakeLamp( ply, r, g, b, key, texture, fov, distance, bright, true, { Pos = pos, Angle = Angle(0, 0, 0) } )
	
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

	function MakeLamp( pl, r, g, b, KeyDown, Texture, fov, distance, brightness, on, Data )
	
		if ( IsValid( pl ) ) then
			if ( !pl:CheckLimit( "lamps" ) ) then return false end
		end
	
		local lamp = ents.Create( "gmod_lamp" )
		
			if ( !IsValid( lamp ) ) then return end
		
		-- todo: add model selection
			--lamp:SetModel( "models/props_wasteland/light_spotlight02_lamp.mdl" )
			--lamp:SetModel( "models/MaxOfS2D/lamp_projector.mdl" )
			lamp:SetModel( "models/MaxOfS2D/lamp_flashlight.mdl" )
			lamp:SetFlashlightTexture( Texture )
			lamp:SetLightFOV( fov )
			lamp:SetColor( Color( r, g, b, 255 ) )
			lamp:SetDistance( distance )
			lamp:SetBrightness( brightness )
			lamp:Switch( on )
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

		numpad.OnDown( pl, KeyDown, "LampToggle", lamp, 1 )
		numpad.OnUp( pl, KeyDown, "LampToggle", lamp, 0 )
		
		return lamp

	end
	
	duplicator.RegisterEntityClass( "gmod_lamp", MakeLamp, "r", "g", "b", "KeyDown", "Texture", "fov", "distance", "brightness", "on", "Data" )


	local function Toggle( pl, ent, onoff )
	
		if ( !IsValid( ent ) ) then return false end

		if ( numpad.FromButton() ) then

			ent:Switch( onoff == 1 )
			return;

		end

		if ( onoff == 0 ) then return end
		
		return ent:Toggle()
		
	end
	
	numpad.Register( "LampToggle", Toggle )
	
end


function TOOL.BuildCPanel( CPanel )

	-- HEADER
	CPanel:AddControl( "Header", { Text = "#tool.lamp.name", Description = "#tool.lamp.desc" }  )

	-- Presets
	local params = { Label = "#tool.presets", MenuButton = 1, Folder = "lamp", Options = {}, CVars = { "lamp_texture", "lamp_r", "lamp_g", "lamp_b", "lamp_key" } }
		
		params.Options.default = {
			lamp_ropelength		= 		64,
			lamp_ropematerial	=		"cable/rope",
			lamp_texture		=		"effects/flashlight001",
			lamp_r				=		255,
			lamp_g				=		255,
			lamp_b				=		255,
			lamp_key			=		-1
		}
					
	CPanel:AddControl( "ComboBox", params )

	CPanel:AddControl( "Numpad", { Label = "#tool.lamp.toggle", Command = "lamp_key" } )

	CPanel:NumSlider( "#tool.lamp.fov", "lamp_fov", 10, 170, 2 )
	CPanel:NumSlider( "#tool.lamp.distance", "lamp_distance", 64, 2048, 0 )
	CPanel:NumSlider( "#tool.lamp.brightness", "lamp_brightness", 0, 8, 2 )
									
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