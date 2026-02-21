
TOOL.Category = "Construction"
TOOL.Name = "#tool.button.name"

TOOL.ClientConVar[ "model" ] = "models/maxofs2d/button_05.mdl"
TOOL.ClientConVar[ "keygroup" ] = "37"
TOOL.ClientConVar[ "description" ] = ""
TOOL.ClientConVar[ "toggle" ] = "1"

TOOL.Information = {
	{ name = "left" },
	{ name = "right" }
}

cleanup.Register( "buttons" )

local function IsValidButtonModel( model )
	for mdl, _ in pairs( list.Get( "ButtonModels" ) ) do
		if ( mdl:lower() == model:lower() ) then return true end
	end
	return false
end

function TOOL:RightClick( trace, worldweld )

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

		return true
	end

	-- Check the model's validity
	if ( !util.IsValidModel( model ) || !util.IsValidProp( model ) || !IsValidButtonModel( model ) ) then return false end
	if ( !self:GetWeapon():CheckLimit( "buttons" ) ) then return false end

	local Ang = trace.HitNormal:Angle()
	Ang.pitch = Ang.pitch + 90

	local button = MakeButton( ply, model, Ang, trace.HitPos, key, description, toggle )
	if ( !IsValid( button ) ) then return false end

	local min = button:OBBMins()
	button:SetPos( trace.HitPos - trace.HitNormal * min.z )

	undo.Create( "gmod_button" )
		undo.AddEntity( button )

		if ( worldweld && trace.Entity != NULL ) then
			local weld = constraint.Weld( button, trace.Entity, 0, trace.PhysicsBone, 0, 0, true )
			if ( IsValid( weld ) ) then
				ply:AddCleanup( "buttons", weld )
				undo.AddEntity( weld )
			end

			if ( IsValid( button:GetPhysicsObject() ) ) then button:GetPhysicsObject():EnableCollisions( false ) end
			button:SetCollisionGroup( COLLISION_GROUP_WORLD )
			button.nocollide = true
		end

		undo.SetPlayer( ply )
	undo.Finish()

	return true

end

function TOOL:LeftClick( trace )

	return self:RightClick( trace, true )

end

if ( SERVER ) then

	function MakeButton( ply, model, ang, pos, key, description, toggle, nocollide, Data )

		if ( IsValid( ply ) && !ply:CheckLimit( "buttons" ) ) then return NULL end
		if ( !IsValidButtonModel( model ) ) then return NULL end

		local button = ents.Create( "gmod_button" )
		if ( !IsValid( button ) ) then return NULL end

		duplicator.DoGeneric( button, Data )
		button:SetModel( model ) -- Backwards compatible for addons directly calling this function
		button:SetAngles( ang )
		button:SetPos( pos )
		button:Spawn()

		DoPropSpawnedEffect( button )
		duplicator.DoGenericPhysics( button, ply, Data )

		button:SetPlayer( ply )
		button:SetKey( key )
		button:SetLabel( description )
		button:SetIsToggle( toggle )

		if ( nocollide == true ) then
			if ( IsValid( button:GetPhysicsObject() ) ) then button:GetPhysicsObject():EnableCollisions( false ) end
			button:SetCollisionGroup( COLLISION_GROUP_WORLD )
		end

		table.Merge( button:GetTable(), {
			key = key,
			pl = ply,
			toggle = toggle,
			nocollide = nocollide,
			description = description
		} )

		if ( IsValid( ply ) ) then
			ply:AddCount( "buttons", button )
			ply:AddCleanup( "buttons", button )
		end

		return button

	end

	duplicator.RegisterEntityClass( "gmod_button", MakeButton, "Model", "Ang", "Pos", "key", "description", "toggle", "nocollide", "Data" )

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
	if ( !IsValidButtonModel( mdl ) ) then self:ReleaseGhostEntity() return end

	if ( !IsValid( self.GhostEntity ) || self.GhostEntity:GetModel() != mdl:lower() ) then
		self:MakeGhostEntity( mdl, vector_origin, angle_zero )
	end

	self:UpdateGhostButton( self.GhostEntity, self:GetOwner() )

end

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel( CPanel )

	CPanel:Help( "#tool.button.desc" )
	CPanel:ToolPresets( "button", ConVarsDefault )

	CPanel:KeyBinder( "#tool.button.key", "button_keygroup" )

	CPanel:TextEntry( "#tool.button.text", "button_description" )

	CPanel:CheckBox( "#tool.button.toggle", "button_toggle" )
	CPanel:ControlHelp( "#tool.button.toggle.help" )

	CPanel:PropSelect( "#tool.button.model", "button_model", list.Get( "ButtonModels" ), 0 )

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
