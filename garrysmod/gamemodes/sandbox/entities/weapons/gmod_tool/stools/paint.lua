
TOOL.Category = "Render"
TOOL.Name = "#tool.paint.name"

TOOL.LeftClickAutomatic = true
TOOL.RightClickAutomatic = true
TOOL.RequiresTraceHit = true

TOOL.ClientConVar[ "decal" ] = "Blood"

TOOL.Information = {
	{ name = "left" },
	{ name = "right" },
	{ name = "reload" }
}

local function PlaceDecal( ply, ent, data )

	if ( !IsValid( ent ) && !ent:IsWorld() ) then return end

	local bone = ent:GetPhysicsObjectNum( data.bone or 0 )
	if ( !IsValid( bone ) ) then bone = ent end

	if ( SERVER ) then
		util.Decal( data.decal, bone:LocalToWorld( data.Pos1 ), bone:LocalToWorld( data.Pos2 ), ply )

		local i = ent.DecalCount or 0
		i = i + 1
		duplicator.StoreEntityModifier( ent, "decal" .. i, data )
		ent.DecalCount = i
	end

end

--
-- Register decal duplicator
--
for i = 1, 32 do

	duplicator.RegisterEntityModifier( "decal" .. i, function( ply, ent, data )
		timer.Simple( i * 0.05, function() PlaceDecal( ply, ent, data ) end )
	end )

end

function TOOL:Reload( trace )
	if ( !IsValid( trace.Entity ) ) then return false end

	trace.Entity:RemoveAllDecals()

	if ( SERVER ) then
		for i = 1, 32 do
			duplicator.ClearEntityModifier( trace.Entity, "decal" .. i )
		end
		trace.Entity.DecalCount = nil
	end

	return true
end

function TOOL:LeftClick( trace )

	return self:RightClick( trace, true )

end

function TOOL:RightClick( trace, bNoDelay )

	self:GetSWEP():EmitSound( "SprayCan.Paint" )
	local decal = self:GetClientInfo( "decal" )

	local Pos1 = trace.HitPos + trace.HitNormal
	local Pos2 = trace.HitPos - trace.HitNormal

	local Bone = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone or 0 )
	if ( !IsValid( Bone ) ) then Bone = trace.Entity end

	Pos1 = Bone:WorldToLocal( Pos1 )
	Pos2 = Bone:WorldToLocal( Pos2 )

	PlaceDecal( self:GetOwner(), trace.Entity, { Pos1 = Pos1, Pos2 = Pos2, bone = trace.PhysicsBone, decal = decal } )

	if ( bNoDelay ) then
		self:GetWeapon():SetNextPrimaryFire( CurTime() + 0.05 )
		self:GetWeapon():SetNextSecondaryFire( CurTime() + 0.05 )
	else
		self:GetWeapon():SetNextPrimaryFire( CurTime() + 0.2 )
		self:GetWeapon():SetNextSecondaryFire( CurTime() + 0.2 )
	end

	return false

end

game.AddDecal( "Eye", "decals/eye" )
game.AddDecal( "Dark", "decals/dark" )
game.AddDecal( "Smile", "decals/smile" )
game.AddDecal( "Light", "decals/light" )
game.AddDecal( "Cross", "decals/cross" )
game.AddDecal( "Nought", "decals/nought" )
game.AddDecal( "Noughtsncrosses", "decals/noughtsncrosses" )

list.Add( "PaintMaterials", "Eye" )
list.Add( "PaintMaterials", "Smile" )
list.Add( "PaintMaterials", "Light" )
list.Add( "PaintMaterials", "Dark" )
list.Add( "PaintMaterials", "Blood" )
list.Add( "PaintMaterials", "YellowBlood" )
list.Add( "PaintMaterials", "Impact.Metal" )
list.Add( "PaintMaterials", "Scorch" )
list.Add( "PaintMaterials", "BeerSplash" )
list.Add( "PaintMaterials", "ExplosiveGunshot" )
list.Add( "PaintMaterials", "BirdPoop" )
list.Add( "PaintMaterials", "PaintSplatPink" )
list.Add( "PaintMaterials", "PaintSplatGreen" )
list.Add( "PaintMaterials", "PaintSplatBlue" )
list.Add( "PaintMaterials", "ManhackCut" )
list.Add( "PaintMaterials", "FadingScorch" )
list.Add( "PaintMaterials", "Antlion.Splat" )
list.Add( "PaintMaterials", "Splash.Large" )
list.Add( "PaintMaterials", "BulletProof" )
list.Add( "PaintMaterials", "GlassBreak" )
list.Add( "PaintMaterials", "Impact.Sand" )
list.Add( "PaintMaterials", "Impact.BloodyFlesh" )
list.Add( "PaintMaterials", "Impact.Antlion" )
list.Add( "PaintMaterials", "Impact.Glass" )
list.Add( "PaintMaterials", "Impact.Wood" )
list.Add( "PaintMaterials", "Impact.Concrete" )
list.Add( "PaintMaterials", "Noughtsncrosses" )
list.Add( "PaintMaterials", "Nought" )
list.Add( "PaintMaterials", "Cross" )

function TOOL.BuildCPanel( CPanel )

	-- Remove duplicates.
	local Options = {}
	for id, str in pairs( list.Get( "PaintMaterials" ) ) do
		if ( !table.HasValue( Options, str ) ) then
			table.insert( Options, str )
		end
	end

	table.sort( Options )

	local listbox = CPanel:AddControl( "ListBox", { Label = "#tool.paint.texture", Height = 17 + table.Count( Options ) * 17 } )
	for k, decal in pairs( Options ) do
		local line = listbox:AddLine( decal )
		line.data = { paint_decal = decal }

		if ( GetConVarString( "paint_decal" ) == tostring( decal ) ) then line:SetSelected( true ) end
	end

end
