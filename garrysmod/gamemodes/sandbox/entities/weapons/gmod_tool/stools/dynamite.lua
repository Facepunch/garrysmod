
TOOL.Category		= "Construction"
TOOL.Name			= "#tool.dynamite.name"

TOOL.ClientConVar[ "group" ]		= 65	-- Current group
TOOL.ClientConVar[ "damage" ]		= 200	-- Damage to inflict
TOOL.ClientConVar[ "delay" ]		= 0		-- Delay before explosions start
TOOL.ClientConVar[ "model" ]		= "models/dav0r/tnt/tnt.mdl"
TOOL.ClientConVar[ "remove" ]		= 0

cleanup.Register( "dynamite" )

function TOOL:LeftClick( trace )

	if ( !trace.HitPos ) then return false end
	if ( trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end
	
	local ply		= self:GetOwner()
	local eyeangles = ply:EyeAngles()

	-- Get client's CVars
	local _group		= self:GetClientNumber( "group" ) 
	local _delay		= self:GetClientNumber( "delay" ) 
	local _damage 		= math.Clamp( self:GetClientNumber( "damage" ), 0, 1500 )
	local _model 		= self:GetClientInfo( "model" )
	local _remove 		= self:GetClientNumber( "remove" ) == 1

	-- If we shot a button change its keygroup
	if	( IsValid( trace.Entity ) && trace.Entity:GetClass() == "gmod_dynamite" && trace.Entity:GetPlayer() == ply ) then
		trace.Entity:Setup( _damage )
		return true
	end
	

	if ( !self:GetSWEP():CheckLimit( "dynamite" ) ) then return false end

	local dynamite = MakeDynamite( ply, trace.HitPos, Angle( 0, eyeangles.yaw, 0 ), _group, _damage, _model, _remove, _delay )
	
	local min = dynamite:OBBMins()
	dynamite:SetPos( trace.HitPos - trace.HitNormal * min.z )

	undo.Create( "Dynamite" )
		undo.AddEntity( dynamite )
		undo.SetPlayer( ply )
	undo.Finish()
	
	
	ply:AddCleanup( "dynamite", dynamite )
	
	return true
	
end

function TOOL:RightClick( trace )

	return self:LeftClick( trace )
	
end

if ( SERVER ) then

	function MakeDynamite(pl, Pos, Ang, key, Damage, Model, Remove, delay, Vel, aVel, frozen )
	
		if ( IsValid( pl ) && !pl:CheckLimit( "dynamite" ) ) then return nil end

		local dynamite = ents.Create( "gmod_dynamite" )
			dynamite:SetPos( Pos )	
			dynamite:SetAngles( Ang )
			dynamite:SetModel( Model )
			dynamite:SetShouldRemove( Remove )
		dynamite:Spawn()
		dynamite:Activate()
		
		dynamite:Setup( Damage )

		if ( IsValid( pl ) ) then
			dynamite:SetPlayer( pl )
		end
		
		local ttable = 
		{
			key	= key,
			pl	= pl,
			nocollide = nocollide,
			description = description,
			Damage = Damage,
			model = Model,
			remove = Remove,
			delay = delay
		}
		
		table.Merge( dynamite:GetTable(), ttable )
		numpad.OnDown( pl, key, "DynamiteBlow", dynamite, delay )
		
		if ( IsValid( pl ) ) then

			pl:AddCount( "dynamite", dynamite )

		end
		
		DoPropSpawnedEffect( dynamite )
		
		return dynamite
		
	end
	
	duplicator.RegisterEntityClass( "gmod_dynamite", MakeDynamite, "Pos", "Ang", "key", "Damage", "model", "remove", "delay", "Vel", "aVel", "frozen" )
	
	local function BlowDynamite( pl, dynamite, delay )

		if ( !IsValid( dynamite ) ) then return end

		dynamite:Explode( delay, pl )
	
	end
	
	numpad.Register( "DynamiteBlow", BlowDynamite )
	
end

function TOOL:UpdateGhostDynamite( ent, player )

	if ( !IsValid( ent ) ) then return end

	local tr 		= util.GetPlayerTrace( player )
	local trace 	= util.TraceLine( tr )
	
	if ( !trace.Hit || trace.Entity:IsPlayer() || trace.Entity:GetClass() == "gmod_dynamite" ) then
		ent:SetNoDraw( true )
		return
	end
	
	local Ang = Angle( 0, player:EyeAngles().yaw, 0 )
	ent:SetAngles( Ang )	

	local min = ent:OBBMins()
	ent:SetPos( trace.HitPos - trace.HitNormal * min.z )
	
	ent:SetNoDraw( false )

end

function TOOL:Think()

	local mdl = self:GetClientInfo( "model" ) 

	if ( !IsValid( self.GhostEntity ) || self.GhostEntity:GetModel() != mdl ) then
		self:MakeGhostEntity( mdl, Vector(0,0,0), Angle(0,0,0) )
	end
	
	self:UpdateGhostDynamite( self.GhostEntity, self:GetOwner() )
	
end

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Text = "#tool.dynamite.name", Description	= "#tool.dynamite.help" }  )
	
	CPanel:AddControl( "ComboBox", { Label = "#tool.presets",
									 MenuButton = 1,
									 Folder = "dynamite",
									 CVars = { "dynamite_group", "dynamite_damage", "dynamite_delay", "dynamite_delay_add", "dynamite_model" } } )

	CPanel:AddControl( "Numpad",	{ Label = "#tool.dynamite.explode",	Command = "dynamite_group" } )
	CPanel:AddControl( "Slider", 	{ Label = "#tool.dynamite.damage", Type = "Float", 	Command = "dynamite_damage", 	Min = "0", 	Max = "500", Help = true }  )
	CPanel:AddControl( "Slider", 	{ Label = "#tool.dynamite.delay", Type = "Float", 	Command = "dynamite_delay", 	Min = "0", 	Max = "10", Help = true }  )
	CPanel:AddControl( "PropSelect", { Label = "#tool.dynamite.model", ConVar = "dynamite_model", Category = "Dynamite", Models = list.Get( "DynamiteModels" ) } )
	CPanel:AddControl( "CheckBox", 	{ Label = "#tool.dynamite.remove",	Command = "dynamite_remove" }  )	
									
end


list.Set( "DynamiteModels", "models/dav0r/tnt/tnt.mdl", {} )