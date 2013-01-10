
TOOL.Category		= "Construction"
TOOL.Name			= "#tool.physprop.name"
TOOL.Command		= nil
TOOL.ConfigName		= nil


TOOL.ClientConVar[ "gravity_toggle" ] 	= "1"
TOOL.ClientConVar[ "material" ] 		= "metal_bouncy"

function TOOL:LeftClick( trace )

	if (!trace.Entity) then return false end
	if (!trace.Entity:IsValid() ) then return false end
	if (trace.Entity:IsPlayer()) then return false end
	if (trace.Entity:IsWorld()) then return false end

	-- Make sure there's a physics object to manipulate
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end

	-- Client can bail out here and assume we're going ahead
	if ( CLIENT ) then return true end

	-- Get the entity/bone from the trace
	local Ent  = trace.Entity
	local Bone = trace.PhysicsBone

	-- Get client's CVars
	local gravity		= util.tobool( self:GetClientNumber( "gravity_toggle" ) )
	local material		= self:GetClientInfo( "material" )

	-- Set the properties

	construct.SetPhysProp( self:GetOwner(), Ent, Bone, nil,  { GravityToggle = gravity, Material = material } ) 
	
	DoPropSpawnedEffect( Ent )

	return true
	
end

function TOOL:RightClick( trace )
	return false
end
