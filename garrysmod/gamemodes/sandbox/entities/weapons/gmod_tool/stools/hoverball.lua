
TOOL.Category = "Construction"
TOOL.Name = "#tool.hoverball.name"

TOOL.ClientConVar[ "keyup" ] = "46"
TOOL.ClientConVar[ "keydn" ] = "43"
TOOL.ClientConVar[ "speed" ] = "1"
TOOL.ClientConVar[ "resistance" ] = "0"
TOOL.ClientConVar[ "strength" ] = "1"
TOOL.ClientConVar[ "model" ] = "models/dav0r/hoverball.mdl"

TOOL.Information = { { name = "left" } }

cleanup.Register( "hoverballs" )

local function IsValidHoverballModel( model )
	for mdl, _ in pairs( list.Get( "HoverballModels" ) ) do
		if ( mdl:lower() == model:lower() ) then return true end
	end
	return false
end

function TOOL:LeftClick( trace )

	if ( trace.Entity && trace.Entity:IsPlayer() ) then return false end

	-- If there's no physics object then we can't constraint it!
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end

	if ( CLIENT ) then return true end

	local ply = self:GetOwner()

	local model = self:GetClientInfo( "model" )
	local key_d = self:GetClientNumber( "keydn" )
	local key_u = self:GetClientNumber( "keyup" )
	local speed = self:GetClientNumber( "speed" )
	local strength = math.Clamp( self:GetClientNumber( "strength" ), 0.1, 20 )
	local resistance = math.Clamp( self:GetClientNumber( "resistance" ), 0, 20 )

	-- We shot an existing hoverball - just change its values
	if ( IsValid( trace.Entity ) && trace.Entity:GetClass() == "gmod_hoverball" && trace.Entity:GetPlayer() == ply ) then

		trace.Entity:SetSpeed( speed )
		trace.Entity:SetAirResistance( resistance )
		trace.Entity:SetStrength( strength )

		numpad.Remove( trace.Entity.NumDown )
		numpad.Remove( trace.Entity.NumUp )
		numpad.Remove( trace.Entity.NumBackDown )
		numpad.Remove( trace.Entity.NumBackUp )

		trace.Entity.NumDown = numpad.OnDown( ply, key_u, "Hoverball_Up", trace.Entity, true )
		trace.Entity.NumUp = numpad.OnUp( ply, key_u, "Hoverball_Up", trace.Entity, false )

		trace.Entity.NumBackDown = numpad.OnDown( ply, key_d, "Hoverball_Down", trace.Entity, true )
		trace.Entity.NumBackUp = numpad.OnUp( ply, key_d, "Hoverball_Down", trace.Entity, false )

		trace.Entity.key_u = key_u
		trace.Entity.key_d = key_d
		trace.Entity.speed = speed
		trace.Entity.strength = strength
		trace.Entity.resistance = resistance

		return true

	end

	if ( !util.IsValidModel( model ) || !util.IsValidProp( model ) || !IsValidHoverballModel( model ) ) then return false end
	if ( !self:GetSWEP():CheckLimit( "hoverballs" ) ) then return false end

	local ball = MakeHoverBall( ply, trace.HitPos, key_d, key_u, speed, resistance, strength, model )

	local CurPos = ball:GetPos()
	local NearestPoint = ball:NearestPoint( CurPos - ( trace.HitNormal * 512 ) )
	local Offset = CurPos - NearestPoint

	ball:SetPos( trace.HitPos + Offset )

	undo.Create( "HoverBall" )
		undo.AddEntity( ball )

		-- Don't weld to world
		if ( IsValid( trace.Entity ) ) then

			local const = constraint.Weld( ball, trace.Entity, 0, trace.PhysicsBone, 0, 0, true )

			if ( IsValid( ball:GetPhysicsObject() ) ) then ball:GetPhysicsObject():EnableCollisions( false ) end
			ball:SetCollisionGroup( COLLISION_GROUP_WORLD )
			ball.nocollide = true

			ply:AddCleanup( "hoverballs", const )
			undo.AddEntity( const )

		end

		undo.SetPlayer( ply )
	undo.Finish()

	return true

end

if ( SERVER ) then

	function MakeHoverBall( ply, Pos, key_d, key_u, speed, resistance, strength, model, Vel, aVel, frozen, nocollide )

		if ( IsValid( ply ) && !ply:CheckLimit( "hoverballs" ) ) then return false end
		if ( !IsValidHoverballModel( model ) ) then return false end

		local ball = ents.Create( "gmod_hoverball" )
		if ( !IsValid( ball ) ) then return false end

		ball:SetPos( Pos )
		ball:SetModel( Model( model ) )
		ball:Spawn()
		ball:SetSpeed( speed )
		ball:SetAirResistance( resistance )
		ball:SetStrength( strength )

		if ( IsValid( ply ) ) then
			ball:SetPlayer( ply )
		end

		ball.NumDown = numpad.OnDown( ply, key_u, "Hoverball_Up", ball, true )
		ball.NumUp = numpad.OnUp( ply, key_u, "Hoverball_Up", ball, false )

		ball.NumBackDown = numpad.OnDown( ply, key_d, "Hoverball_Down", ball, true )
		ball.NumBackUp = numpad.OnUp( ply, key_d, "Hoverball_Down", ball, false )

		if ( nocollide == true ) then
			if ( IsValid( ball:GetPhysicsObject() ) ) then ball:GetPhysicsObject():EnableCollisions( false ) end
			ball:SetCollisionGroup( COLLISION_GROUP_WORLD )
		end

		local ttable = {
			key_d = key_d,
			key_u = key_u,
			pl = ply,
			nocollide = nocollide,
			speed = speed,
			strength = strength,
			resistance = resistance,
			model = model
		}

		table.Merge( ball:GetTable(), ttable )

		if ( IsValid( ply ) ) then
			ply:AddCount( "hoverballs", ball )
			ply:AddCleanup( "hoverballs", ball )
		end

		DoPropSpawnedEffect( ball )

		return ball

	end
	duplicator.RegisterEntityClass( "gmod_hoverball", MakeHoverBall, "Pos", "key_d", "key_u", "speed", "resistance", "strength", "model", "Vel", "aVel", "frozen", "nocollide" )

end

function TOOL:UpdateGhostHoverball( ent, ply )

	if ( !IsValid( ent ) ) then return end

	local trace = ply:GetEyeTrace()
	if ( !trace.Hit || trace.Entity && ( trace.Entity:GetClass() == "gmod_hoverball" || trace.Entity:IsPlayer() ) ) then

		ent:SetNoDraw( true )
		return

	end

	local CurPos = ent:GetPos()
	local NearestPoint = ent:NearestPoint( CurPos - ( trace.HitNormal * 512 ) )
	local Offset = CurPos - NearestPoint

	ent:SetPos( trace.HitPos + Offset )

	ent:SetNoDraw( false )

end

function TOOL:Think()

	local mdl = self:GetClientInfo( "model" )
	if ( !IsValidHoverballModel( mdl ) ) then self:ReleaseGhostEntity() return end

	if ( !IsValid( self.GhostEntity ) || self.GhostEntity:GetModel() != mdl ) then
		self:MakeGhostEntity( mdl, Vector( 0, 0, 0 ), Angle( 0, 0, 0 ) )
	end

	self:UpdateGhostHoverball( self.GhostEntity, self:GetOwner() )

end

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Description = "#tool.hoverball.help" } )

	CPanel:AddControl( "ComboBox", { MenuButton = 1, Folder = "hoverball", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

	CPanel:AddControl( "Numpad", { Label = "#tool.hoverball.up", Command = "hoverball_keyup", Label2 = "#tool.hoverball.down", Command2 = "hoverball_keydn" } )
	CPanel:AddControl( "Slider", { Label = "#tool.hoverball.speed", Command = "hoverball_speed", Type = "Float", Min = 0, Max = 20, Help = true } )
	CPanel:AddControl( "Slider", { Label = "#tool.hoverball.resistance", Command = "hoverball_resistance", Type = "Float", Min = 0, Max = 10, Help = true } )
	CPanel:AddControl( "Slider", { Label = "#tool.hoverball.strength", Command = "hoverball_strength", Type = "Float", Min = 0.1, Max = 10, Help = true } )

	CPanel:AddControl( "PropSelect", { Label = "#tool.hoverball.model", ConVar = "hoverball_model", Models = list.Get( "HoverballModels" ), Height = 0 } )

end

list.Set( "HoverballModels", "models/dav0r/hoverball.mdl", {} )
list.Set( "HoverballModels", "models/maxofs2d/hover_basic.mdl", {} )
list.Set( "HoverballModels", "models/maxofs2d/hover_classic.mdl", {} )
list.Set( "HoverballModels", "models/maxofs2d/hover_plate.mdl", {} )
list.Set( "HoverballModels", "models/maxofs2d/hover_propeller.mdl", {} )
list.Set( "HoverballModels", "models/maxofs2d/hover_rings.mdl", {} )
