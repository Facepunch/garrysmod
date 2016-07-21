
TOOL.Category = "Construction"
TOOL.Name = "#tool.button.name"

TOOL.ClientConVar[ "model" ] = "models/maxofs2d/button_05.mdl"
TOOL.ClientConVar[ "keygroup" ] = "37"
TOOL.ClientConVar[ "description" ] = ""
TOOL.ClientConVar[ "toggle" ] = "1"

cleanup.Register( "buttons" )

function TOOL:RightClick( trace )

	if ( IsValid( trace.Entity ) && trace.Entity:IsPlayer() ) then return false end
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end
	if ( CLIENT ) then return true end

	local model = self:GetClientInfo( "model" )
	local key = self:GetClientNumber( "keygroup" )
	local description = self:GetClientInfo( "description" )
	local toggle = self:GetClientNumber( "toggle" ) == 1
	local ply = self:GetOwner()

	-- If we shot a button change its settings
	if ( IsValid( trace.Entity ) && trace.Entity:GetClass() == "gmod_button" && trace.Entity:GetPlayer() == ply ) then

		trace.Entity:SetKey( key )
		trace.Entity:SetLabel( description )
		trace.Entity:SetIsToggle( toggle )

		return true, NULL, true

	end

	-- Check the model's validity
	if ( !util.IsValidModel( model ) || !util.IsValidProp( model ) ) then return false end
	if ( !self:GetSWEP():CheckLimit( "buttons" ) ) then return false end

	local Ang = trace.HitNormal:Angle()
	Ang.pitch = Ang.pitch + 90

	local button = MakeButton( ply, model, Ang, trace.HitPos, key, description, toggle )

	local min = button:OBBMins()
	button:SetPos( trace.HitPos - trace.HitNormal * min.z )

	undo.Create( "Button" )
		undo.AddEntity( button )
		undo.SetPlayer( ply )
	undo.Finish()

	ply:AddCleanup( "buttons", button )

	return true, button

end

function TOOL:LeftClick( trace )

	local bool, button, set_key = self:RightClick( trace, true )
	if ( CLIENT ) then return bool end

	if ( set_key ) then return true end
	if ( !IsValid( button ) ) then return false end
	if ( !IsValid( trace.Entity ) && !trace.Entity:IsWorld() ) then return false end

	local weld = constraint.Weld( button, trace.Entity, 0, trace.PhysicsBone, 0, 0, true )
	trace.Entity:DeleteOnRemove( weld )
	button:DeleteOnRemove( weld )

	button:GetPhysicsObject():EnableCollisions( false )
	button.nocollide = true

	return true

end

if ( SERVER ) then

	function MakeButton( pl, model, ang, pos, key, description, toggle )

		if ( IsValid( pl ) && !pl:CheckLimit( "buttons" ) ) then return false end

		local button = ents.Create( "gmod_button" )
		if ( !IsValid( button ) ) then return false end
		button:SetModel( model )

		button:SetAngles( ang )
		button:SetPos( pos )
		button:Spawn()

		button:SetPlayer( pl )
		button:SetKey( key )
		button:SetLabel( description )
		button:SetIsToggle( toggle )

		table.Merge( button:GetTable(), {
			key = key,
			pl = pl,
			toggle = toggle,
			description = description
		} )

		if ( IsValid( pl ) ) then
			pl:AddCount( "buttons", button )
		end

		DoPropSpawnedEffect( button )

		return button

	end

	duplicator.RegisterEntityClass( "gmod_button", MakeButton, "Model", "Ang", "Pos", "key", "description", "toggle" )

end

function TOOL:UpdateGhostButton( ent, ply )

	if ( !IsValid( ent ) ) then return end

	local trace = ply:GetEyeTrace()
	if ( !trace.Hit || IsValid( trace.Entity ) && ( trace.Entity:GetClass() == "gmod_button" || trace.Entity:IsPlayer() ) ) then
		ent:SetNoDraw( true )
		return
	end

	local ang = trace.HitNormal:Angle()
	ang.pitch = ang.pitch + 90

	local min = ent:OBBMins()
	ent:SetPos( trace.HitPos - trace.HitNormal * min.z )
	ent:SetAngles( ang )

	ent:SetNoDraw( false )

end

function TOOL:Think()

	local mdl = self:GetClientInfo( "model" )

	if ( !IsValid( self.GhostEntity ) || self.GhostEntity:GetModel() != mdl ) then
		self:MakeGhostEntity( mdl, Vector( 0, 0, 0 ), Angle( 0, 0, 0 ) )
	end

	self:UpdateGhostButton( self.GhostEntity, self:GetOwner() )

end

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Description = "#tool.button.desc" } )

	CPanel:AddControl( "ComboBox", { MenuButton = 1, Folder = "button", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

	CPanel:AddControl( "Numpad", { Label = "#tool.button.key", Command = "button_keygroup" } )

	CPanel:AddControl( "TextBox", { Label = "#tool.button.text", Command = "button_description", MaxLenth = "20" } )

	CPanel:AddControl( "CheckBox", { Label = "#tool.button.toggle", Command = "button_toggle", Help = true } )

	CPanel:AddControl( "PropSelect", { Label = "#tool.button.model", ConVar = "button_model", Height = 4, Models = list.Get( "ButtonModels" ) } )

end

list.Set( "ButtonModels", "models/maxofs2d/button_01.mdl", {} )
list.Set( "ButtonModels", "models/maxofs2d/button_02.mdl", {} )
list.Set( "ButtonModels", "models/maxofs2d/button_03.mdl", {} )
list.Set( "ButtonModels", "models/maxofs2d/button_04.mdl", {} )
list.Set( "ButtonModels", "models/maxofs2d/button_05.mdl", {} )
list.Set( "ButtonModels", "models/maxofs2d/button_06.mdl", {} )
list.Set( "ButtonModels", "models/maxofs2d/button_slider.mdl", {} )

--list.Set( "ButtonModels", "models/dav0r/buttons/button.mdl", {} )
--list.Set( "ButtonModels", "models/dav0r/buttons/switch.mdl", {} )
