
TOOL.Category		= "Construction"
TOOL.Name			= "#tool.nocollide.name"


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
		
		local Ent1,  Ent2  = self:GetEnt(1),	self:GetEnt(2)
		local Bone1, Bone2 = self:GetBone(1),	self:GetBone(2)

		local constraint = constraint.NoCollide(Ent1, Ent2, Bone1, Bone2)
	
		undo.Create( "NoCollide" )
		undo.AddEntity( constraint )
		undo.SetPlayer( self:GetOwner() )
		undo.Finish()
		
		self:GetOwner():AddCleanup( "nocollide", constraint )
		
		self:ClearObjects()
	
	else
		
		self:SetStage( iNum+1 )
	
	end
		
	return true
	
end

function TOOL:RightClick( trace )

	if (!trace.Entity ) then return end
	if (!trace.Entity:IsValid()) then return end
	if (trace.Entity:IsPlayer()) then return end
	
	if ( CLIENT ) then return true end
	
	if ( trace.Entity:GetCollisionGroup() == COLLISION_GROUP_WORLD ) then
	
		trace.Entity:SetCollisionGroup( COLLISION_GROUP_NONE )
	
	else
	
		trace.Entity:SetCollisionGroup( COLLISION_GROUP_WORLD )
		
	end
	
	return true
	
end

function TOOL:Reload( trace )

	if (!trace.Entity:IsValid() || trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end
	
	local  bool = constraint.RemoveConstraints( trace.Entity, "NoCollide" )
	return bool
	
end
