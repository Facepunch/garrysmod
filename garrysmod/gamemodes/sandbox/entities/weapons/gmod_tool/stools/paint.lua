
TOOL.Category = "Render"
TOOL.Name = "#tool.paint.name"

TOOL.LeftClickAutomatic = true
TOOL.RightClickAutomatic = true
TOOL.RequiresTraceHit = true

TOOL.ClientConVar[ "decal" ] = "Blood"

local function PlaceDecal( Player, Entity, Data )

	if ( Entity == nil ) then return end
	if ( !Entity:IsWorld() && !IsValid( Entity ) ) then return end

	local Bone = Entity:GetPhysicsObjectNum( Data.bone or 0 )
	if ( !IsValid( Bone ) ) then
		Bone = Entity
	end

	util.Decal( Data.decal, Bone:LocalToWorld( Data.Pos1 ), Bone:LocalToWorld( Data.Pos2 ) )
	
	if ( SERVER ) then
		local i = Entity.DecalCount or 0
		i = i + 1
		duplicator.StoreEntityModifier( Entity, "decal" .. i, Data )
		Entity.DecalCount = i
	end

end

--
-- Register decal duplicator
--
for i=1,32 do

	function PlaceDecal_delayed( Player, Entity, Data )
		timer.Simple( i * 0.05, function() PlaceDecal( Player, Entity, Data ) end )
	end

	duplicator.RegisterEntityModifier( "decal" .. i, PlaceDecal_delayed )

end

function TOOL:LeftClick( trace )

	return self:RightClick( trace, true )
	
end

function TOOL:RightClick( trace, bNoDelay )

	self:GetOwner():EmitSound( "SprayCan.Paint" )
	local decal	= self:GetClientInfo( "decal" )
	
	local Pos1 = trace.HitPos + trace.HitNormal
	local Pos2 = trace.HitPos - trace.HitNormal
	
	local Bone = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone or 0 )
	if ( !Bone ) then
		Bone = trace.Entity
	end
	
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

	local Options = list.Get( "PaintMaterials" )
	table.sort( Options )
	
	local RealOptions = {}

	for k, decal in pairs( Options ) do

		RealOptions[ decal ] = { paint_decal = decal }
	
	end
	
	CPanel:AddControl( "ListBox", { Label = "#tool.paint.texture", Height = "300", Options = RealOptions } )

end
