
TOOL.Category = "Constraints"
TOOL.Name = "#tool.weld.name"

TOOL.ClientConVar[ "forcelimit" ] = "0"

function TOOL:LeftClick( trace )

	if ( self:GetOperation() == 1 ) then return false end
	if ( IsValid( trace.Entity ) && trace.Entity:IsPlayer() ) then return false end
	
	-- If there's no physics object then we can't constraint it!
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end

	local iNum = self:NumObjects()
	local Phys = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone )
	self:SetObject( iNum + 1, trace.Entity, trace.HitPos, Phys, trace.PhysicsBone, trace.HitNormal )
	
	if ( CLIENT ) then
	
		if ( iNum > 0 ) then self:ClearObjects() end
		return true
	
	end
	
	self:SetOperation( 2 )
	
	if ( iNum == 0 ) then
	
		self:SetStage( 1 )
		return true
		
	end

	if ( iNum == 1 ) then
	
		-- Get client's CVars
		local forcelimit = self:GetClientNumber( "forcelimit" )
		local nocollide = false

		-- Get information we're about to use
		local Ent1, Ent2 = self:GetEnt( 1 ), self:GetEnt( 2 )
		local Bone1, Bone2 = self:GetBone( 1 ), self:GetBone( 2 )

		local constraint = constraint.Weld( Ent1, Ent2, Bone1, Bone2, forcelimit, nocollide )
		if ( constraint ) then
		
			undo.Create( "Weld" )
				undo.AddEntity( constraint )
				undo.SetPlayer( self:GetOwner() )
			undo.Finish()
			
			self:GetOwner():AddCleanup( "constraints", constraint )
		
		end

		-- Clear the objects so we're ready to go again
		self:ClearObjects()
	
	end
	
	return true

end

function TOOL:RightClick( trace )

	if ( self:GetOperation() == 2 ) then return false end

	-- Make sure the object we're about to use is valid
	local iNum = self:NumObjects()
	local Phys = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone )
	
	-- You can click anywhere on the 3rd pass
	if ( iNum < 2 ) then
	
		-- If there's no physics object then we can't constraint it!
		if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end
		
		-- Don't weld players, or to players
		if ( trace.Entity:IsPlayer() ) then return false end
	
		-- Don't do anything with stuff without any physics..
		if ( SERVER && !IsValid( Phys ) ) then return false end
		
	end

	if ( iNum == 0 ) then
	
		if ( !IsValid( trace.Entity ) ) then return false end
		if ( trace.Entity:GetClass() == "prop_vehicle_jeep" ) then return false end
		
	end

	self:SetObject( iNum + 1, trace.Entity, trace.HitPos, Phys, trace.PhysicsBone, trace.HitNormal )
	self:SetOperation( 1 )

	--
	-- Stage 0 - grab an object, make a ghost entity
	--
	if ( iNum == 0 ) then
	
		self:StartGhostEntity( trace.Entity )
		self:SetStage( 1 )
		return true
	
	end
	
	--
	-- Stage 1 - choose the spot and object to weld it to
	--
	if ( iNum == 1 ) then
	
		if ( CLIENT ) then
			self:ReleaseGhostEntity()
			return true
		end
		
		-- Get information we're about to use
		local Norm1, Norm2 = self:GetNormal( 1 ), self:GetNormal( 2 )
		local Phys1 = self:GetPhys( 1 )
		local WPos2 = self:GetPos( 2 )
		
		-- Note: To keep stuff ragdoll friendly try to treat things as physics objects rather than entities
		local Ang1, Ang2 = Norm1:Angle(), ( -Norm2 ):Angle()
		local TargetAngle = Phys1:AlignAngles( Ang1, Ang2 )
		
		Phys1:SetAngles( TargetAngle )
		
		-- Move the object so that the hitpos on our object is at the second hitpos
		local TargetPos = WPos2 + ( Phys1:GetPos() - self:GetPos( 1 ) )
		
		-- Set the position
		Phys1:SetPos( TargetPos )
		Phys1:EnableMotion( false )
		
		-- Wake up the physics object so that the entity updates
		Phys1:Wake()
			
		self.RotAxis = Norm2

		self:ReleaseGhostEntity()

		self:SetStage( 2 )
		
		return true
		
	end
	
	--
	-- Stage 2 - Weld it in place.
	--
	if ( iNum == 2 ) then
	
		if ( CLIENT ) then
		
			self:ClearObjects()
			return true
			
		end
		
		-- Get client's CVars
		local forcelimit = self:GetClientNumber( "forcelimit" )
		local nocollide = false
	
		-- Get information we're about to use
		local Ent1, Ent2 = self:GetEnt( 1 ), self:GetEnt( 2 )
		local Bone1, Bone2 = self:GetBone( 1 ),	self:GetBone( 2 )
		local Phys1 = self:GetPhys( 1 )

		-- The entity became invalid half way through
		if ( !IsValid( Ent1 ) ) then
		
			self:ClearObjects()
			return false
		
		end
	
		local constraint = constraint.Weld( Ent1, Ent2, Bone1, Bone2, forcelimit, nocollide )
		if ( constraint ) then
		
			Phys1:EnableMotion( true )
			
			undo.Create( "Weld" )
				undo.AddEntity( constraint )
				undo.SetPlayer( self:GetOwner() )
			undo.Finish()
			
			self:GetOwner():AddCleanup( "constraints", constraint )

		end
		
		-- Clear the objects so we're ready to go again
		self:ClearObjects()
		return true
		
	end

end

function TOOL:Think()

	if ( self:NumObjects() < 1 ) then return end
	
	if ( self:GetOperation() == 1 ) then
	
		if ( SERVER && !IsValid( self:GetEnt( 1 ) ) ) then
		
			self:ClearObjects()
			return
		
		end
		
		if ( self:NumObjects() == 1 ) then
		
			self:UpdateGhostEntity()
			return
		
		end
		
		if ( SERVER && self:NumObjects() == 2 ) then
		
			local Phys1 = self:GetPhys( 1 )

			local cmd = self:GetOwner():GetCurrentCommand()
			
			local degrees = cmd:GetMouseX() * 0.05
			
			local angle = Phys1:RotateAroundAxis( self.RotAxis, degrees )
			
			Phys1:SetAngles( angle )
			
			-- Move so spots join up
			local TargetPos = self:GetPos( 2 ) + ( Phys1:GetPos() - self:GetPos( 1 ) )
			Phys1:SetPos( TargetPos )
			Phys1:Wake()
		
		end
	
	end

end

function TOOL:Reload( trace )

	if ( !IsValid( trace.Entity ) || trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end

	self:ClearObjects()

	return constraint.RemoveConstraints( trace.Entity, "Weld" )

end

function TOOL:FreezeMovement()

	return self:GetOperation() == 1 && self:GetStage() == 2

end

function TOOL:Holster()

	self:ClearObjects()

end

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Description	= "#tool.weld.help" } )
	CPanel:AddControl( "Slider", { Label = "#tool.forcelimit", Command = "weld_forcelimit", Type = "Float", Min = 0, Max = 1000, Help = true } )

end
