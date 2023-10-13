
TOOL.Category = "Construction"
TOOL.Name = "#tool.nocollide.name"

TOOL.Information = {
	{ name = "left", stage = 0 },
	{ name = "left_1", stage = 1 },
	{ name = "right" },
	{ name = "reload" }
}

cleanup.Register( "nocollide" )

function TOOL:LeftClick( trace )

	if ( !IsValid( trace.Entity ) ) then return end
	if ( trace.Entity:IsPlayer() ) then return end

	-- If there's no physics object then we can't constraint it!
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end

	local iNum = self:NumObjects()

	local Phys = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone )
	self:SetObject( iNum + 1, trace.Entity, trace.HitPos, Phys, trace.PhysicsBone, trace.HitNormal )

	if ( CLIENT ) then

		if ( iNum > 0 ) then self:ClearObjects() end
		return true

	end

	if ( iNum > 0 ) then

		local Ent1, Ent2 = self:GetEnt( 1 ), self:GetEnt( 2 )
		local Bone1, Bone2 = self:GetBone( 1 ), self:GetBone( 2 )

		local constr = constraint.NoCollide( Ent1, Ent2, Bone1, Bone2 )
		if ( IsValid( constr ) ) then
			undo.Create( "NoCollide" )
				undo.AddEntity( constr )
				undo.SetPlayer( self:GetOwner() )
			undo.Finish()

			self:GetOwner():AddCleanup( "nocollide", constr )
		end

		self:ClearObjects()

	else
 
		self:SetStage( iNum + 1 )

	end

	return true

end

function TOOL:RightClick( trace )

	if ( !IsValid( trace.Entity ) ) then return end
	if ( trace.Entity:IsPlayer() ) then return end

	if ( CLIENT ) then return true end

	if ( trace.Entity:GetCollisionGroup() == COLLISION_GROUP_WORLD ) then

		trace.Entity:SetCollisionGroup( COLLISION_GROUP_NONE )

	else

		trace.Entity:SetCollisionGroup( COLLISION_GROUP_WORLD )

	end

	return true

end

function TOOL:Reload( trace )

	if ( !IsValid( trace.Entity ) || trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end

	return constraint.RemoveConstraints( trace.Entity, "NoCollide" )

end

function TOOL:Holster()

	self:ClearObjects()

end

-- This is unreliable
hook.Add( "EntityRemoved", "nocollide_fix", function( ent )
	if ( ent:GetClass() == "logic_collision_pair" ) then
		ent:Fire( "EnableCollisions" )
	end
end )

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Description = "#tool.nocollide.desc" } )

end
