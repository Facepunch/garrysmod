
TOOL.Category		= "Construction"
TOOL.Name			= "#tool.hoverball.name"
TOOL.Command		= nil
TOOL.ConfigName		= nil


TOOL.ClientConVar[ "keyup" ] = "9"
TOOL.ClientConVar[ "keydn" ] = "6"
TOOL.ClientConVar[ "speed" ] = "1"
TOOL.ClientConVar[ "resistance" ] = "0"
TOOL.ClientConVar[ "strength" ] = "1"
TOOL.ClientConVar[ "model" ] = "models/dav0r/hoverball.mdl"

cleanup.Register( "hoverballs" )

function TOOL:LeftClick( trace )

	if ( trace.Entity && trace.Entity:IsPlayer() ) then return false end
	
	-- If there's no physics object then we can't constraint it!
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end
	
	if ( CLIENT ) then return true end
	
	local ply = self:GetOwner()
	
	local key_d 		= self:GetClientNumber( "keydn" ) 
	local key_u 		= self:GetClientNumber( "keyup" ) 
	local speed 		= self:GetClientNumber( "speed" ) 
	local resistance 	= self:GetClientNumber( "resistance" ) 
	local strength	 	= self:GetClientNumber( "strength" )
	local model			= self:GetClientInfo( "model" ) 
	
	resistance 	= math.Clamp( resistance, 0, 20 )
	strength	= math.Clamp( strength, 0.1, 20 )
	
	-- We shot an existing hoverball - just change its values
	if ( trace.Entity:IsValid() && trace.Entity:GetClass() == "gmod_hoverball" && trace.Entity.pl == ply ) then
	
		trace.Entity:SetSpeed( speed )
		trace.Entity:SetAirResistance( resistance )
		trace.Entity:SetStrength( strength )

		trace.Entity.speed		= speed
		trace.Entity.strength	= strength
		trace.Entity.resistance	= resistance
	
		return true
	
	end
	
	if ( !self:GetSWEP():CheckLimit( "hoverballs" ) ) then return false end
	
	-- If we hit the world then offset the spawn position
	if ( trace.Entity:IsWorld() ) then
		trace.HitPos = trace.HitPos + trace.HitNormal * 8
	end

	local ball = MakeHoverBall( ply, trace.HitPos, key_d, key_u, speed, resistance, strength, model )
	
	local const, nocollide
	
	-- Don't weld to world
	if ( trace.Entity != NULL && !trace.Entity:IsWorld() ) then
	
					  -- Ent1, Ent2, Bone1, Bone2, forcelimit, nocollide, deleteonbreak
		const 		= constraint.Weld( ball, trace.Entity, 0, trace.PhysicsBone, 0, 0, true )
		
		ball:GetPhysicsObject():EnableCollisions( false )
		ball.nocollide = true
		
	end
	
	undo.Create( "HoverBall" )
		undo.AddEntity( ball )
		undo.AddEntity( const )
		undo.SetPlayer( ply )
	undo.Finish()
	
	ply:AddCleanup( "hoverballs", ball )
	ply:AddCleanup( "hoverballs", const )
	ply:AddCleanup( "hoverballs", nocollide )
	
	return true

end

function TOOL:RightClick( trace )

	return self:LeftClick( trace )
	
end

if (SERVER) then

	function MakeHoverBall( ply, Pos, key_d, key_u, speed, resistance, strength, model, Vel, aVel, frozen, nocollide )
	
		if ( IsValid( ply ) ) then
			if ( !ply:CheckLimit( "hoverballs" ) ) then return nil end
		end
	
		local ball = ents.Create( "gmod_hoverball" )
		if ( !ball:IsValid() ) then return false end

		ball:SetPos( Pos )
		ball:SetModel( Model( model ) )
		ball:Spawn()
		ball:SetSpeed( speed )
		ball:SetAirResistance( resistance )
		ball:SetStrength( strength )

		if ( IsValid( ply ) ) then
			ball:SetPlayer( ply )
		end

		numpad.OnDown( 	 ply, 	key_u, 	"Hoverball_Up", 	ball, true )
		numpad.OnUp( 	 ply, 	key_u, 	"Hoverball_Up", 	ball, false )

		numpad.OnDown( 	 ply, 	key_d, 	"Hoverball_Down", 	ball, true )
		numpad.OnUp( 	 ply, 	key_d, 	"Hoverball_Down", 	ball, false )

		if ( nocollide == true ) then ball:GetPhysicsObject():EnableCollisions( false ) end

		local ttable = 
		{
			key_d	= key_d,
			key_u 	= key_u,
			pl	= ply,
			nocollide = nocollide,
			speed = speed,
			strength = strength,
			resistance = resistance,
			model = model
		}

		table.Merge( ball:GetTable(), ttable )
		
		if ( IsValid( ply ) ) then
			ply:AddCount( "hoverballs", ball )
		end
		
		DoPropSpawnedEffect( ball )

		return ball
		
	end
	
	duplicator.RegisterEntityClass( "gmod_hoverball", MakeHoverBall, "Pos", "key_d", "key_u", "speed", "resistance", "strength", "model", "Vel", "aVel", "frozen", "nocollide" )

end


function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Text = "#tool.hoverball.name", Description	= "#tool.hoverball.help" }  )
	
	CPanel:AddControl( "ComboBox", { Label = "#tool.presets",
									 MenuButton = 1,
									 Folder = "hoverball",
									 CVars = { "hoverball_keydn", "hoverball_keyup", "hoverball_speed", "hoverball_resistance", "hoverball_strength", "hoverball_model" } } )

	CPanel:AddControl( "Numpad",	{ Label = "#tool.hoverball.up",	Command = "hoverball_keyup", Label2 = "#tool.hoverball.down", Command2 = "hoverball_keydn" } )
	CPanel:AddControl( "Slider", 	{ Label = "#tool.hoverball.speed", Type = "Float", 	Command = "hoverball_speed", 	Min = "0", 	Max = "20", Help = true }  )
	CPanel:AddControl( "Slider", 	{ Label = "#tool.hoverball.resistance", Type = "Float", 	Command = "hoverball_resistance", 	Min = "0", 	Max = "10", Help = true }  )
	CPanel:AddControl( "Slider", 	{ Label = "#tool.hoverball.strength", Type = "Float", 	Command = "hoverball_strength", 	Min = "0.1", 	Max = "10", Help = true }  )
	CPanel:AddControl( "PropSelect", { Label = "#tool.hoverball.model", ConVar = "hoverball_model", Models = list.Get( "HoverballModels" ), Height = 6 } )

									
end

-- This list is getting populated from right to left for some reason!

list.Set( "HoverballModels", "models/MaxOfS2D/hover_propeller.mdl", {} )
list.Set( "HoverballModels", "models/dav0r/hoverball.mdl", {} )
list.Set( "HoverballModels", "models/MaxOfS2D/hover_rings.mdl", {} )
list.Set( "HoverballModels", "models/MaxOfS2D/hover_classic.mdl", {} )
list.Set( "HoverballModels", "models/MaxOfS2D/hover_basic.mdl", {} )
list.Set( "HoverballModels", "models/MaxOfS2D/hover_basic.mdl", {} )
list.Set( "HoverballModels", "models/MaxOfS2D/hover_basic.mdl", {} )
list.Set( "HoverballModels", "models/MaxOfS2D/hover_basic.mdl", {} )