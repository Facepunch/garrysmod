
TOOL.Category = "Render"
TOOL.Name = "#tool.trails.name"

TOOL.ClientConVar[ "r" ] = 255
TOOL.ClientConVar[ "g" ] = 255
TOOL.ClientConVar[ "b" ] = 255
TOOL.ClientConVar[ "a" ] = 255

TOOL.ClientConVar[ "length" ] = 5
TOOL.ClientConVar[ "startsize" ] = 32
TOOL.ClientConVar[ "endsize" ] = 0

TOOL.ClientConVar[ "material" ] = "trails/lol"

TOOL.Information = {
	{ name = "left" },
	{ name = "right" }
}

cleanup.Register( "trails" )

local function SetTrails( ply, ent, data )

	if ( IsValid( ent.SToolTrail ) ) then

		ent.SToolTrail:Remove()
		ent.SToolTrail = nil

	end

	if ( !data ) then

		duplicator.ClearEntityModifier( ent, "trail" )
		return

	end

	-- Just don't even bother with invisible trails
	if ( data.StartSize <= 0 && data.EndSize <= 0 ) then return end

		-- This is here to fix crash exploits
	if ( !game.SinglePlayer() ) then

		-- Lock down the trail material - only allow what the server allows
		if ( !list.Contains( "trail_materials", data.Material ) ) then return end

		-- Clamp sizes in multiplayer
		data.Length = math.Clamp( data.Length, 0.1, 10 )
		data.EndSize = math.Clamp( data.EndSize, 0, 128 )
		data.StartSize = math.Clamp( data.StartSize, 0, 128 )

	end

	data.StartSize = math.max( 0.0001, data.StartSize )

	local trail_entity = util.SpriteTrail( ent, 0, data.Color, false, data.StartSize, data.EndSize, data.Length, 1 / ( ( data.StartSize + data.EndSize ) * 0.5 ), data.Material .. ".vmt" )

	ent.SToolTrail = trail_entity

	if ( IsValid( ply ) ) then
		ply:AddCleanup( "trails", trail_entity )
	end

	duplicator.StoreEntityModifier( ent, "trail", data )

	return trail_entity

end
duplicator.RegisterEntityModifier( "trail", SetTrails )

function TOOL:LeftClick( trace )

	if ( !IsValid( trace.Entity ) ) then return false end
	if ( !trace.Entity:EntIndex() == 0 ) then return false end
	if ( trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end

	local r = math.Clamp( self:GetClientNumber( "r", 255 ), 0, 255 )
	local g = math.Clamp( self:GetClientNumber( "g", 255 ), 0, 255 )
	local b = math.Clamp( self:GetClientNumber( "b", 255 ), 0, 255 )
	local a = math.Clamp( self:GetClientNumber( "a", 255 ), 0, 255 )

	local length = self:GetClientNumber( "length", 5 )
	local endsize = self:GetClientNumber( "endsize", 0 )
	local startsize = self:GetClientNumber( "startsize", 32 )
	local mat = self:GetClientInfo( "material", "sprites/obsolete" )

	local trail = SetTrails( self:GetOwner(), trace.Entity, {
		Color = Color( r, g, b, a ),
		Length = length,
		StartSize = startsize,
		EndSize = endsize,
		Material = mat
	} )

	if ( IsValid( trail ) ) then
		undo.Create( "Trail" )
			undo.AddEntity( trail )
			undo.SetPlayer( self:GetOwner() )
		undo.Finish()
	end

	return true

end

function TOOL:RightClick( trace )

	if ( !IsValid( trace.Entity ) ) then return false end
	if ( !trace.Entity:EntIndex() == 0 ) then return false end
	if ( trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end

	SetTrails( self:GetOwner(), trace.Entity, nil )
	return true

end

--
-- Add default materials to list
-- Note: Addons can easily add to this list in their -- own file placed in autorun or something.
--
list.Set( "trail_materials", "#trail.plasma", "trails/plasma" )
list.Set( "trail_materials", "#trail.tube", "trails/tube" )
list.Set( "trail_materials", "#trail.electric", "trails/electric" )
list.Set( "trail_materials", "#trail.smoke", "trails/smoke" )
list.Set( "trail_materials", "#trail.laser", "trails/laser" )
list.Set( "trail_materials", "#trail.physbeam", "trails/physbeam" )
list.Set( "trail_materials", "#trail.love", "trails/love" )
list.Set( "trail_materials", "#trail.lol", "trails/lol" )

if ( IsMounted( "tf" ) ) then
	list.Set( "trail_materials", "#trail.beam001_blu", "effects/beam001_blu" )
	list.Set( "trail_materials", "#trail.beam001_red", "effects/beam001_red" )
	list.Set( "trail_materials", "#trail.beam001_white", "effects/beam001_white" )
	list.Set( "trail_materials", "#trail.arrowtrail_blu", "effects/arrowtrail_blu" )
	list.Set( "trail_materials", "#trail.arrowtrail_red", "effects/arrowtrail_red" )
	list.Set( "trail_materials", "#trail.repair_claw_trail_blue", "effects/repair_claw_trail_blue" )
	list.Set( "trail_materials", "#trail.repair_claw_trail_red", "effects/repair_claw_trail_red" )
	list.Set( "trail_materials", "#trail.australiumtrail_red", "effects/australiumtrail_red" )
	list.Set( "trail_materials", "#trail.beam_generic01", "effects/beam_generic01" )
end

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Description = "#tool.trails.desc" } )

	CPanel:AddControl( "ComboBox", { MenuButton = 1, Folder = "trails", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

	CPanel:AddControl( "Color", { Label = "#tool.trails.color", Red = "trails_r", Green = "trails_g", Blue = "trails_b", Alpha = "trails_a" } )

	CPanel:NumSlider( "#tool.trails.length", "trails_length", 0, 10, 2 )
	CPanel:NumSlider( "#tool.trails.startsize", "trails_startsize", 0, 128, 2 )
	CPanel:NumSlider( "#tool.trails.endsize", "trails_endsize", 0, 128, 2 )

	CPanel:MatSelect( "trails_material", list.Get( "trail_materials" ), true, 0.25, 0.25 )

end
