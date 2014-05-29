
TOOL.Category = "Construction"
TOOL.Name = "#tool.remover.name"

local function DoRemoveEntity( ent )

	if ( !IsValid( ent ) || ent:IsPlayer() ) then return false end

	-- Nothing for the client to do here
	if ( CLIENT ) then return true end

	-- Remove all constraints (this stops ropes from hanging around)
	constraint.RemoveAll( ent )
	
	-- Remove it properly in 1 second
	timer.Simple( 1, function() if ( IsValid( ent ) ) then ent:Remove() end end )
	
	-- Make it non solid
	ent:SetNotSolid( true )
	ent:SetMoveType( MOVETYPE_NONE )
	ent:SetNoDraw( true )
	
	-- Send Effect
	local ed = EffectData()
	ed:SetEntity( ent )
	util.Effect( "entity_remove", ed, true, true )
	
	return true

end

--
-- Remove a single entity
--
function TOOL:LeftClick( trace )

	if ( DoRemoveEntity( trace.Entity ) ) then
	
		if ( !CLIENT ) then
			self:GetOwner():SendLua( "achievements.Remover()" )
		end
		
		return true
	
	end
	
	return false

end

--
-- Remove this entity and everything constrained
--
function TOOL:RightClick( trace )

	local Entity = trace.Entity

	if ( !IsValid( Entity ) || Entity:IsPlayer() ) then return false end
	
	-- Client can bail out now.
	if ( CLIENT ) then return true end
	
	local ConstrainedEntities = constraint.GetAllConstrainedEntities( trace.Entity )
	local Count = 0
	
	-- Loop through all the entities in the system
	for _, Entity in pairs( ConstrainedEntities ) do
	
		if ( DoRemoveEntity( Entity ) ) then
			Count = Count + 1
		end

	end
	
	return true

end

--
-- Reload removes all constraints on the targetted entity
--
function TOOL:Reload( trace )

	if ( !IsValid( trace.Entity ) || trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end

	return constraint.RemoveAll( trace.Entity )

end

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Description = "#tool.remover.desc" } )

end
