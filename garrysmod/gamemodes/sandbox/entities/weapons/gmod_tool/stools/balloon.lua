
TOOL.Category = "Construction"
TOOL.Name = "#tool.balloon.name"

TOOL.ClientConVar[ "ropelength" ] = "64"
TOOL.ClientConVar[ "force" ] = "500"
TOOL.ClientConVar[ "r" ] = "255"
TOOL.ClientConVar[ "g" ] = "255"
TOOL.ClientConVar[ "b" ] = "0"
TOOL.ClientConVar[ "model" ] = "normal_skin1"

TOOL.Information = {
	{ name = "left" },
	{ name = "right" }
}

cleanup.Register( "balloons" )

function TOOL:LeftClick( trace, attach )

	if ( IsValid( trace.Entity ) && trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end

	--
	-- Right click calls this with attach = false
	--
	if ( attach == nil ) then
		attach = true
	end

	-- If there's no physics object then we can't constraint it!
	if ( SERVER && attach && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then
		return false
	end

	local ply = self:GetOwner()
	local material = "cable/rope"
	local r = self:GetClientNumber( "r", 255 )
	local g = self:GetClientNumber( "g", 0 )
	local b = self:GetClientNumber( "b", 0 )
	local model = self:GetClientInfo( "model" )
	local force = math.Clamp( self:GetClientNumber( "force", 500 ), -1E34, 1E34 )
	local length = self:GetClientNumber( "ropelength", 64 )

	--
	-- Model is a table index on BalloonModels
	-- If the model isn't defined then it can't be spawned.
	--
	local modeltable = list.GetEntry( "BalloonModels", model )
	if ( !modeltable ) then return false end

	--
	-- The model table can disable colouring for its model
	--
	if ( modeltable.nocolor ) then
		r = 255
		g = 255
		b = 255
	end

	--
	-- Clicked on a balloon - modify the force/color/whatever
	--
	if	( IsValid( trace.Entity ) && trace.Entity:GetClass() == "gmod_balloon" && trace.Entity.Player == ply ) then

		if ( IsValid( trace.Entity:GetPhysicsObject() ) ) then trace.Entity:GetPhysicsObject():Wake() end
		trace.Entity:SetColor( Color( r, g, b, 255 ) )
		trace.Entity:SetForce( force )
		trace.Entity.force = force
		return true

	end

	--
	-- Hit the balloon limit, bail
	--
	if ( !self:GetWeapon():CheckLimit( "balloons" ) ) then return false end

	local balloon = MakeBalloon( ply, r, g, b, force, { Pos = trace.HitPos, Model = modeltable.model, Skin = modeltable.skin } )
	if ( !IsValid( balloon ) ) then return false end

	local CurPos = balloon:GetPos()
	local NearestPoint = balloon:NearestPoint( CurPos - ( trace.HitNormal * 512 ) )
	local Offset = CurPos - NearestPoint

	local Pos = trace.HitPos + Offset

	balloon:SetPos( Pos )

	undo.Create( "gmod_balloon" )
		undo.AddEntity( balloon )

		if ( attach ) then

			-- The real model should have an attachment!
			local LPos1 = balloon:WorldToLocal( Pos )
			local LPos2 = trace.Entity:WorldToLocal( trace.HitPos )

			if ( IsValid( trace.Entity ) ) then

				local phys = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone )
				if ( IsValid( phys ) ) then LPos2 = phys:WorldToLocal( trace.HitPos ) end

			end

			local constr, rope = constraint.Rope( balloon, trace.Entity, 0, trace.PhysicsBone, LPos1, LPos2, 0, length, 0, 0.5, material )
			if ( IsValid( constr ) ) then
				undo.AddEntity( constr )
				ply:AddCleanup( "balloons", constr )
			end

			if ( IsValid( rope ) ) then
				undo.AddEntity( rope )
				ply:AddCleanup( "balloons", rope )
			end

		end

		undo.SetPlayer( ply )
	undo.Finish()

	return true

end

function TOOL:RightClick( trace )

	return self:LeftClick( trace, false )

end

if ( SERVER ) then

	function MakeBalloon( ply, r, g, b, force, Data )

		if ( IsValid( ply ) && !ply:CheckLimit( "balloons" ) ) then return NULL end

		if ( !isnumber( r ) ) then r = 255 end
		if ( !isnumber( g ) ) then g = 255 end
		if ( !isnumber( b ) ) then b = 255 end
		if ( !isnumber( force ) ) then force = 0 end

		local balloon = ents.Create( "gmod_balloon" )
		if ( !IsValid( balloon ) ) then return NULL end

		duplicator.DoGeneric( balloon, Data )

		balloon:Spawn()

		DoPropSpawnedEffect( balloon )

		duplicator.DoGenericPhysics( balloon, ply, Data )

		balloon:SetColor( Color( r, g, b, 255 ) )
		balloon:SetForce( force )
		balloon:SetPlayer( ply )

		balloon.Player = ply
		balloon.r = r
		balloon.g = g
		balloon.b = b
		balloon.force = force

		if ( IsValid( ply ) ) then
			ply:AddCount( "balloons", balloon )
			ply:AddCleanup( "balloons", balloon )
		end

		return balloon

	end

	duplicator.RegisterEntityClass( "gmod_balloon", MakeBalloon, "r", "g", "b", "force", "Data" )

end

function TOOL:UpdateGhostBalloon( ent, ply )

	if ( !IsValid( ent ) ) then return end

	local trace = ply:GetEyeTrace()
	if ( !trace.Hit || IsValid( trace.Entity ) && ( trace.Entity:IsPlayer() || trace.Entity:GetClass() == "gmod_balloon" ) ) then
		ent:SetNoDraw( true )
		return
	end

	local CurPos = ent:GetPos()
	local NearestPoint = ent:NearestPoint( CurPos - ( trace.HitNormal * 512 ) )
	local Offset = CurPos - NearestPoint

	local pos = trace.HitPos + Offset

	local modeltable = list.GetEntry( "BalloonModels", self:GetClientInfo( "model" ) )
	if ( modeltable && modeltable.skin ) then ent:SetSkin( modeltable.skin ) end

	ent:SetPos( pos )
	ent:SetAngles( angle_zero )

	ent:SetNoDraw( false )

end

function TOOL:Think()

	if ( !IsValid( self.GhostEntity ) || self.GhostEntity.model != self:GetClientInfo( "model" ) ) then

		local modeltable = list.GetEntry( "BalloonModels", self:GetClientInfo( "model" ) )
		if ( !modeltable ) then self:ReleaseGhostEntity() return end

		self:MakeGhostEntity( modeltable.model, vector_origin, angle_zero )
		if ( IsValid( self.GhostEntity ) ) then self.GhostEntity.model = self:GetClientInfo( "model" ) end

	end

	self:UpdateGhostBalloon( self.GhostEntity, self:GetOwner() )

end

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel( CPanel )

	CPanel:Help( "#tool.balloon.help" )
	CPanel:ToolPresets( "balloon", ConVarsDefault )

	CPanel:NumSlider( "#tool.balloon.ropelength", "balloon_ropelength", 5, 1000 )

	CPanel:NumSlider( "#tool.balloon.force", "balloon_force", -1000, 2000 )
	CPanel:ControlHelp( "#tool.balloon.force.help" )

	CPanel:ColorPicker( "#tool.balloon.color", "balloon_r", "balloon_g", "balloon_b" )

	CPanel:PropSelect( "#tool.balloon.model", "balloon_model", list.Get( "BalloonModels" ), 0 )

end

list.Set( "BalloonModels", "normal", { model = "models/maxofs2d/balloon_classic.mdl", skin = 0 } )
list.Set( "BalloonModels", "normal_skin1", { model = "models/maxofs2d/balloon_classic.mdl", skin = 1 } )
list.Set( "BalloonModels", "normal_skin2", { model = "models/maxofs2d/balloon_classic.mdl", skin = 2 } )
list.Set( "BalloonModels", "normal_skin3", { model = "models/maxofs2d/balloon_classic.mdl", skin = 3 } )

list.Set( "BalloonModels", "gman", { model = "models/maxofs2d/balloon_gman.mdl", nocolor = true } )
list.Set( "BalloonModels", "mossman", { model = "models/maxofs2d/balloon_mossman.mdl", nocolor = true } )

list.Set( "BalloonModels", "dog", { model = "models/balloons/balloon_dog.mdl" } )
list.Set( "BalloonModels", "heart", { model = "models/balloons/balloon_classicheart.mdl" } )
list.Set( "BalloonModels", "star", { model = "models/balloons/balloon_star.mdl" } )
