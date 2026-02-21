
function ToolObj:UpdateData()

	self:SetStage( self:NumObjects() )

end

function ToolObj:SetStage( i )

	if ( SERVER ) then
		self:GetWeapon():SetNWInt( "Stage", i )
	end

end

function ToolObj:GetStage()
	return self:GetWeapon():GetNWInt( "Stage", 0 )
end

function ToolObj:SetOperation( i )

	if ( SERVER ) then
		self:GetWeapon():SetNWInt( "Op", i )
	end

end

function ToolObj:GetOperation()
	return self:GetWeapon():GetNWInt( "Op", 0 )
end


-- Clear the selected objects
function ToolObj:ClearObjects()

	self:ReleaseGhostEntity()
	self.Objects = {}
	self:SetStage( 0 )
	self:SetOperation( 0 )

end

--[[---------------------------------------------------------
	Since we're going to be expanding this a lot I've tried
	to add accessors for all of this crap to make it harder
	for us to mess everything up.
-----------------------------------------------------------]]
function ToolObj:GetEnt( i )

	if ( !self.Objects[i] ) then return NULL end

	return self.Objects[i].Ent
end


--[[---------------------------------------------------------
	Returns the world position of the numbered object hit
	We store it as a local vector then convert it to world
	That way even if the object moves it's still valid
-----------------------------------------------------------]]
function ToolObj:GetPos( i )

	if ( self.Objects[i].Ent:EntIndex() == 0 ) then
		return self.Objects[i].Pos
	else
		if ( IsValid( self.Objects[i].Phys ) ) then
			return self.Objects[i].Phys:LocalToWorld( self.Objects[i].Pos )
		else
			return self.Objects[i].Ent:LocalToWorld( self.Objects[i].Pos )
		end
	end

end

-- Returns the local position of the numbered hit
function ToolObj:GetLocalPos( i )
	return self.Objects[i].Pos
end

-- Returns the physics bone number of the hit (ragdolls)
function ToolObj:GetBone( i )
	return self.Objects[i].Bone
end

function ToolObj:GetNormal( i )
	if ( self.Objects[i].Ent:EntIndex() == 0 ) then
		return self.Objects[i].Normal
	else
		local norm
		if ( IsValid( self.Objects[i].Phys ) ) then
			norm = self.Objects[i].Phys:LocalToWorld( self.Objects[i].Normal )
		else
			norm = self.Objects[i].Ent:LocalToWorld( self.Objects[i].Normal )
		end

		return norm - self:GetPos( i )
	end
end

-- Returns the physics object for the numbered hit
function ToolObj:GetPhys( i )

	if ( self.Objects[i].Phys == nil ) then
		return self:GetEnt( i ):GetPhysicsObject()
	end

	return self.Objects[i].Phys
end


-- Sets a selected object
function ToolObj:SetObject( i, ent, pos, phys, bone, norm )

	self.Objects[i] = {}
	self.Objects[i].Ent = ent
	self.Objects[i].Phys = phys
	self.Objects[i].Bone = bone
	self.Objects[i].Normal = norm

	-- Worldspawn is a special case
	if ( ent:EntIndex() == 0 ) then

		self.Objects[i].Phys = nil
		self.Objects[i].Pos = pos

	else

		norm = norm + pos

		-- Convert the position to a local position - so it's still valid when the object moves
		if ( IsValid( phys ) ) then
			self.Objects[i].Normal = self.Objects[i].Phys:WorldToLocal( norm )
			self.Objects[i].Pos = self.Objects[i].Phys:WorldToLocal( pos )
		else
			self.Objects[i].Normal = self.Objects[i].Ent:WorldToLocal( norm )
			self.Objects[i].Pos = self.Objects[i].Ent:WorldToLocal( pos )
		end

	end

	-- TODO: Make sure the client got the same info

end


-- Returns the number of objects in the list
function ToolObj:NumObjects()

	if ( CLIENT ) then

		return self:GetStage()

	end

	return #self.Objects

end


-- Returns the number of objects in the list
function ToolObj:GetHelpText()

	return "#tool." .. GetConVarString( "gmod_toolmode" ) .. "." .. self:GetStage()

end
