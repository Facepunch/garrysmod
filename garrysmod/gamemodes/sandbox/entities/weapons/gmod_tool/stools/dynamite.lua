
TOOL.Category = "Construction"
TOOL.Name = "#tool.dynamite.name"

TOOL.ClientConVar[ "group" ] = 52
TOOL.ClientConVar[ "damage" ] = 200
TOOL.ClientConVar[ "delay" ] = 0
TOOL.ClientConVar[ "model" ] = "models/dav0r/tnt/tnt.mdl"
TOOL.ClientConVar[ "remove" ] = 0

cleanup.Register( "dynamite" )

function TOOL:LeftClick( trace )

	if ( !trace.HitPos || IsValid( trace.Entity ) && trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end

	local ply = self:GetOwner()

	-- Get client's CVars
	local group = self:GetClientNumber( "group" )
	local delay = self:GetClientNumber( "delay" )
	local damage = math.Clamp( self:GetClientNumber( "damage" ), 0, 1500 )
	local model = self:GetClientInfo( "model" )
	local remove = self:GetClientNumber( "remove" ) == 1

	-- If we shot a dynamite, change it's settings
	if ( IsValid( trace.Entity ) && trace.Entity:GetClass() == "gmod_dynamite" && trace.Entity:GetPlayer() == ply ) then

		trace.Entity:Setup( damage )
		trace.Entity:SetShouldRemove( remove )
		trace.Entity.delay = delay

		numpad.Remove( trace.Entity.NumDown )
		trace.Entity.key = group
		trace.Entity.NumDown = numpad.OnDown( ply, group, "DynamiteBlow", trace.Entity, delay )

		return true
	end

	if ( !util.IsValidModel( model ) || !util.IsValidProp( model ) ) then return false end
	if ( !self:GetSWEP():CheckLimit( "dynamite" ) ) then return false end

	local dynamite = MakeDynamite( ply, trace.HitPos, Angle( 0, 0, 0 ), group, damage, model, remove, delay )

	local CurPos = dynamite:GetPos()
	local NearestPoint = dynamite:NearestPoint( CurPos - ( trace.HitNormal * 512 ) )
	local Offset = CurPos - NearestPoint

	dynamite:SetPos( trace.HitPos + Offset )

	undo.Create( "Dynamite" )
		undo.AddEntity( dynamite )
		undo.SetPlayer( ply )
	undo.Finish()

	ply:AddCleanup( "dynamite", dynamite )

	return true

end

if ( SERVER ) then

	function MakeDynamite( pl, pos, ang, key, damage, model, remove, delay )

		if ( IsValid( pl ) && !pl:CheckLimit( "dynamite" ) ) then return nil end

		local dynamite = ents.Create( "gmod_dynamite" )
		dynamite:SetPos( pos )
		dynamite:SetAngles( ang )
		dynamite:SetModel( model )
		dynamite:SetShouldRemove( remove )
		dynamite:Spawn()
		dynamite:Activate()

		dynamite:Setup( damage )

		if ( IsValid( pl ) ) then
			dynamite:SetPlayer( pl )
		end

		local ttable = {
			key = key,
			pl = pl,
			nocollide = nocollide,
			description = description,
			Damage = damage,
			model = model,
			remove = remove,
			delay = delay
		}

		table.Merge( dynamite:GetTable(), ttable )
		dynamite.NumDown = numpad.OnDown( pl, key, "DynamiteBlow", dynamite, delay )

		if ( IsValid( pl ) ) then

			pl:AddCount( "dynamite", dynamite )

		end

		DoPropSpawnedEffect( dynamite )

		return dynamite

	end
	duplicator.RegisterEntityClass( "gmod_dynamite", MakeDynamite, "Pos", "Ang", "key", "Damage", "model", "remove", "delay" )

	local function BlowDynamite( pl, dynamite, delay )

		if ( !IsValid( dynamite ) ) then return end

		dynamite:Explode( delay, pl )

	end
	numpad.Register( "DynamiteBlow", BlowDynamite )

end

function TOOL:UpdateGhostDynamite( ent, ply )

	if ( !IsValid( ent ) ) then return end

	local trace = ply:GetEyeTrace()
	if ( !trace.Hit || IsValid( trace.Entity ) && ( trace.Entity:IsPlayer() || trace.Entity:GetClass() == "gmod_dynamite" ) ) then
		ent:SetNoDraw( true )
		return
	end

	ent:SetAngles( Angle( 0, 0, 0 ) )

	local CurPos = ent:GetPos()
	local NearestPoint = ent:NearestPoint( CurPos - ( trace.HitNormal * 512 ) )
	local Offset = CurPos - NearestPoint

	ent:SetPos( trace.HitPos + Offset )

	ent:SetNoDraw( false )

end

function TOOL:Think()

	local mdl = self:GetClientInfo( "model" )

	if ( !IsValid( self.GhostEntity ) || self.GhostEntity:GetModel() != mdl ) then
		self:MakeGhostEntity( mdl, Vector( 0, 0, 0 ), Angle( 0, 0, 0 ) )
	end

	self:UpdateGhostDynamite( self.GhostEntity, self:GetOwner() )

end

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Description	= "#tool.dynamite.help" } )

	CPanel:AddControl( "ComboBox", { MenuButton = 1, Folder = "dynamite", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

	CPanel:AddControl( "Numpad", { Label = "#tool.dynamite.explode", Command = "dynamite_group" } )
	CPanel:AddControl( "Slider", { Label = "#tool.dynamite.damage", Command = "dynamite_damage", Type = "Float", Min = 0, Max = 500, Help = true } )
	CPanel:AddControl( "Slider", { Label = "#tool.dynamite.delay", Command = "dynamite_delay", Type = "Float", Min = 0, Max = 10, Help = true } )
	CPanel:AddControl( "PropSelect", { Label = "#tool.dynamite.model", ConVar = "dynamite_model", Models = list.Get( "DynamiteModels" ) } )
	CPanel:AddControl( "CheckBox", { Label = "#tool.dynamite.remove", Command = "dynamite_remove" } )

end

list.Set( "DynamiteModels", "models/dav0r/tnt/tnt.mdl", {} )
list.Set( "DynamiteModels", "models/dav0r/tnt/tnttimed.mdl", {} )
list.Set( "DynamiteModels", "models/dynamite/dynamite.mdl", {} )
