
TOOL.Category = "Construction"
TOOL.Name = "#tool.physprop.name"

TOOL.ClientConVar[ "gravity_toggle" ] = "1"
TOOL.ClientConVar[ "material" ] = "metal_bouncy"

TOOL.Information = { { name = "left" } }

function TOOL:LeftClick( trace )

	if ( !IsValid( trace.Entity ) ) then return false end
	if ( trace.Entity:IsPlayer() || trace.Entity:IsWorld() ) then return false end

	-- Make sure there's a physics object to manipulate
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end

	-- Client can bail out here and assume we're going ahead
	if ( CLIENT ) then return true end

	-- Get the entity/bone from the trace
	local ent = trace.Entity
	local Bone = trace.PhysicsBone

	-- Get client's CVars
	local gravity = self:GetClientNumber( "gravity_toggle" ) == 1
	local material = self:GetClientInfo( "material" )

	-- Set the properties

	construct.SetPhysProp( self:GetOwner(), ent, Bone, nil, { GravityToggle = gravity, Material = material } )

	DoPropSpawnedEffect( ent )

	return true

end

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel( CPanel )

	CPanel:ToolPresets( "physprop", ConVarsDefault )

	CPanel:ComboBoxMulti( "#tool.physprop.material", list.Get( "PhysicsMaterials" ) )

	CPanel:CheckBox( "#tool.physprop.gravity", "physprop_gravity_toggle" )

end

list.Set( "PhysicsMaterials", "#physprop.metalbouncy", { physprop_material = "metal_bouncy" } )
list.Set( "PhysicsMaterials", "#physprop.metal", { physprop_material = "metal" } )
list.Set( "PhysicsMaterials", "#physprop.dirt", { physprop_material = "dirt" } )
list.Set( "PhysicsMaterials", "#physprop.slime", { physprop_material = "slipperyslime" } )
list.Set( "PhysicsMaterials", "#physprop.wood", { physprop_material = "wood" } )
list.Set( "PhysicsMaterials", "#physprop.glass", { physprop_material = "glass" } )
list.Set( "PhysicsMaterials", "#physprop.concrete", { physprop_material = "concrete_block" } )
list.Set( "PhysicsMaterials", "#physprop.ice", { physprop_material = "ice" } )
list.Set( "PhysicsMaterials", "#physprop.rubber", { physprop_material = "rubber" } )
list.Set( "PhysicsMaterials", "#physprop.paper", { physprop_material = "paper" } )
list.Set( "PhysicsMaterials", "#physprop.flesh", { physprop_material = "zombieflesh" } )
list.Set( "PhysicsMaterials", "#physprop.superice", { physprop_material = "gmod_ice" } )
list.Set( "PhysicsMaterials", "#physprop.superbouncy", { physprop_material = "gmod_bouncy" } )
