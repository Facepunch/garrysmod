
TOOL.Category		= "Construction"
TOOL.Name			= "#tool.light.name"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar[ "ropelength" ]		= "64"
TOOL.ClientConVar[ "ropematerial" ]		= "cable/rope"
TOOL.ClientConVar[ "r" ]				= "255"
TOOL.ClientConVar[ "g" ]				= "255"
TOOL.ClientConVar[ "b" ]				= "255"
TOOL.ClientConVar[ "brightness" ]		= "2"
TOOL.ClientConVar[ "size" ]				= "256"
TOOL.ClientConVar[ "key" ]				= "-1"

cleanup.Register( "lights" )

function TOOL:LeftClick( trace, attach )

	if trace.Entity && trace.Entity:IsPlayer() then return false end
	if (CLIENT) then return true end
	if (attach == nil) then attach = true end
	
	-- If there's no physics object then we can't constraint it!
	if ( SERVER && attach && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end
	
	local ply = self:GetOwner()
	
	local pos, ang = trace.HitPos + trace.HitNormal * 10, trace.HitNormal:Angle() - Angle( 90, 0, 0 )

	local r 	= math.Clamp( self:GetClientNumber( "r" ), 0, 255 )
	local g 	= math.Clamp( self:GetClientNumber( "g" ), 0, 255 )
	local b 	= math.Clamp( self:GetClientNumber( "b" ), 0, 255 )
	local brght	= math.Clamp( self:GetClientNumber( "brightness" ), 0, 255 )
	local size 	= self:GetClientNumber( "size" )
	
	local key 	= self:GetClientNumber( "key" )
	
	-- Clamp for multiplayer
	if ( !game.SinglePlayer() ) then
		size = math.Clamp( size, 0, 512 )
		brght = math.Clamp( brght, 0, 1 )
	end
	
	if	( IsValid( trace.Entity ) && 
			trace.Entity:GetClass() == "gmod_light" &&
			trace.Entity:GetPlayer() == ply ) then
		
		
		trace.Entity:SetColor( Color( r, g, b, 255 ) )
		trace.Entity.r = r
		trace.Entity.g = g
		trace.Entity.b = b
		trace.Entity.Brightness = brght
		trace.Entity.Size = size
		
		trace.Entity:SetBrightness( brght )
		trace.Entity:SetLightSize( size )
		
		return true
		
	end
	
	if ( !self:GetSWEP():CheckLimit( "lights" ) ) then return false end
	lamp = MakeLight( ply, r, g, b, brght, size, true, key, { Pos = pos, Angle = ang } )
	
	if (!attach) then 
	
		undo.Create("Light")
			undo.AddEntity( lamp )
			undo.SetPlayer( self:GetOwner() )
		undo.Finish()
		
		return true
		
	end

	local length 	= math.Clamp( self:GetClientNumber( "ropelength" ), 4, 1024 )
	local material 	= self:GetClientInfo( "ropematerial" )
	
	local LPos1 = Vector( 0, 0, 5 )
	local LPos2 = trace.Entity:WorldToLocal( trace.HitPos )
	
	if (trace.Entity:IsValid()) then
		
		local phys = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone )
		if (phys:IsValid()) then
			LPos2 = phys:WorldToLocal( trace.HitPos )
		end
	
	end
	
	local constraint, rope = constraint.Rope( lamp, trace.Entity, 
											  0, trace.PhysicsBone, 
											  LPos1, LPos2, 
											  0, length,
											  0, 
											  1, 
											  material, 
											  nil )
	
	undo.Create("Light")
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

function TOOL.BuildCPanel( CPanel )

	-- HEADER
	CPanel:AddControl( "Header", { Text = "#tool.light.name", Description	= "#tool.light.desc" }  )
	
	-- Presets
	local params = { Label = "#tool.presets", MenuButton = 1, Folder = "light", Options = {}, CVars = {} }
		
		params.Options.default = {
			light_ropelength	= 		64,
			light_ropematerial	=		"cable/rope",
			light_r				=		255,
			light_g				=		255,
			light_b				=		255,
			light_brightness	=		2,
			light_size			=		256
		}
			
		table.insert( params.CVars, "light_ropelength" )
		table.insert( params.CVars, "light_ropematerial" )
		table.insert( params.CVars, "light_r" )
		table.insert( params.CVars, "light_g" )
		table.insert( params.CVars, "light_b" )
		table.insert( params.CVars, "light_brightness" )
		table.insert( params.CVars, "light_size" )
		
	CPanel:AddControl( "ComboBox", params )
	
	CPanel:AddControl( "Slider",  { Label	= "#tool.light.ropelength",
									Type	= "Float",
									Min		= 0,
									Max		= 256,
									Command = "light_ropelength" }	 )
	
	
	CPanel:AddControl( "Color",  { Label	= "#tool.light.color",
									Red			= "light_r",
									Green		= "light_g",
									Blue		= "light_b",
									ShowAlpha	= 0,
									ShowHSV		= 1,
									ShowRGB 	= 1,
									Multiplier	= 255 } )	
									
	CPanel:AddControl( "Slider",  { Label	= "#tool.light.brightness",
									Type	= "Float",
									Min		= 0,
									Max		= 10,
									Command = "light_brightness" }	 )
									
	CPanel:AddControl( "Slider",  { Label	= "#tool.light.size",
									Type	= "Float",
									Min		= 0,
									Max		= 1024,
									Command = "light_size" }	 )

	CPanel:AddControl( "Numpad", { Label = "#tool.light.toggle", Command = "light_key", ButtonSize = 22 } )

									
end

if ( SERVER ) then

	function MakeLight( pl, r, g, b, brght, size, on, KeyDown, Data )
	
		if ( IsValid( pl ) && !pl:CheckLimit( "lights" ) ) then return false end
	
		local lamp = ents.Create( "gmod_light" )
		
			if (!lamp:IsValid()) then return end
		
			duplicator.DoGeneric( lamp, Data )
			lamp:SetColor( Color( r, g, b, 255 ) )
			lamp:SetBrightness( brght )
			lamp:SetLightSize( size )
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
		lamp.Brightness  = brght
		lamp.Size = size
		lamp.KeyDown = KeyDown
		lamp.on = on
		
		numpad.OnDown( pl, KeyDown, "LightToggle", lamp, 1 )
		numpad.OnUp( pl, KeyDown, "LightToggle", lamp, 0 )

		return lamp
		
	end
	
	duplicator.RegisterEntityClass( "gmod_light", MakeLight, "lightr", "lightg", "lightb", "Brightness", "Size", "on", "KeyDown", "Data" )
	
	
	local function Toggle( pl, ent, onoff )
	
		if ( !IsValid( ent ) ) then return false end

		if ( numpad.FromButton() ) then

			ent:SetOn( onoff == 1 )
			return;

		end

		if ( onoff == 0 ) then return end
		
		return ent:Toggle()
		
	end
	
	numpad.Register( "LightToggle", Toggle )

end
