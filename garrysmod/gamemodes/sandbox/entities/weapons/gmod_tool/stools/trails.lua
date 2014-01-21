
TOOL.Category		= "Render"
TOOL.Name			= "#tool.trails.name"

TOOL.ClientConVar[ "r" ] = 255
TOOL.ClientConVar[ "g" ] = 255
TOOL.ClientConVar[ "b" ] = 255
TOOL.ClientConVar[ "a" ] = 255

TOOL.ClientConVar[ "length" ] = 5
TOOL.ClientConVar[ "startsize" ] = 32
TOOL.ClientConVar[ "endsize" ] = 0

TOOL.ClientConVar[ "material" ] = "trails/lol"

cleanup.Register( "trails" )

local function SetTrails( Player, Entity, Data )

	if ( IsValid( Entity.SToolTrail ) ) then
	
		Entity.SToolTrail:Remove()
		Entity.SToolTrail = nil
	
	end
	
	if ( !Data ) then
	
		duplicator.ClearEntityModifier( Entity, "trail" );
		return
		
	end
	
	if ( Data.StartSize == 0 ) then
	
		Data.StartSize = 0.0001;
		
	end

	--
	-- Lock down the trail material - only allow what the server allows
	-- This is here to fix a crash exploit
	--
	if ( !game.SinglePlayer() && !list.Contains( "trail_materials", Data.Material ) ) then
		return 
	end

	
	local trail_entity = util.SpriteTrail( Entity,  --Entity
											0,  --iAttachmentID
											Data.Color,  --Color
											false, -- bAdditive
											Data.StartSize, --fStartWidth
											Data.EndSize, --fEndWidth
											Data.Length, --fLifetime
											1 / ((Data.StartSize+Data.EndSize) * 0.5), --fTextureRes
											Data.Material .. ".vmt" ) --strTexture
	
	Entity.SToolTrail = trail_entity

	if ( IsValid( Player ) ) then
		Player:AddCleanup( "trails", trail_entity )
	end

	duplicator.StoreEntityModifier( Entity, "trail", Data )
		
	return trail_entity
	
end
duplicator.RegisterEntityModifier( "trail", SetTrails )

function TOOL:LeftClick( trace )

	if (!trace.Entity) then return false end
	if (!trace.Entity:IsValid()) then return false end
	if (!trace.Entity:EntIndex() == 0) then return false end
	if ( trace.Entity:IsPlayer() ) then return false end
	if (CLIENT) then return true end
	
	local r		= math.Clamp( self:GetClientNumber( "r", 255 ), 0, 255 )
	local g		= math.Clamp( self:GetClientNumber( "g", 255 ), 0, 255 )
	local b		= math.Clamp( self:GetClientNumber( "b", 255 ), 0, 255 )
	local a		= math.Clamp( self:GetClientNumber( "a", 255 ), 0, 255 )
	
	local length	= self:GetClientNumber( "length", 5 )
	local startsize	= self:GetClientNumber( "startsize", 32 )
	local endsize	= self:GetClientNumber( "endsize", 0 )
	local Mat		= self:GetClientInfo( "material", "sprites/obsolete" )
	
	-- Clamp sizes in multiplayer
	if ( !game.SinglePlayer() ) then
	
		length 		= math.Clamp( length, 0.1, 10 )
		startsize 	= math.Clamp( startsize, 0, 128 )
		endsize 	= math.Clamp( endsize, 0, 128 )
	
	end

	local Trail = SetTrails( self:GetOwner(), trace.Entity, {
		Color = Color( r, g, b, a ), 
		Length = length, 
		StartSize = startsize, 
		EndSize = endsize,
		Material = Mat
	} )

	undo.Create("Trail")
		undo.AddEntity( Trail )
		undo.SetPlayer( self:GetOwner() )
	undo.Finish()

	return true
		
	
end

function TOOL:RightClick( trace )

	if (!trace.Entity) then return false end
	if (!trace.Entity:IsValid()) then return false end
	if (!trace.Entity:EntIndex() == 0) then return false end
	if ( trace.Entity:IsPlayer() ) then return false end
	if (CLIENT) then return true end

	SetTrails( self:GetOwner(), trace.Entity, nil )	
	return true
	
end

--
-- Add default materials to list
-- Note: Addons can easily add to this list in their 
-- own file placed in autorun or something.
--
list.Set( "trail_materials", "#trail.plasma", 	"trails/plasma" )
list.Set( "trail_materials", "#trail.tube", 		"trails/tube" )
list.Set( "trail_materials", "#trail.electric", 	"trails/electric" )
list.Set( "trail_materials", "#trail.smoke", 		"trails/smoke" )
list.Set( "trail_materials", "#trail.laser", 		"trails/laser" )
list.Set( "trail_materials", "#trail.physbeam", 	"trails/physbeam" )
list.Set( "trail_materials", "#trail.love", 		"trails/love" )
list.Set( "trail_materials", "#trail.lol", 		"trails/lol" )

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Description	= "#tool.trails.desc" }  )

	-- Presets
	local params = { Label = "#tool.presets", MenuButton = 1, Folder = "trails", Options = {}, CVars = {} }
		
		params.Options.default = {
			trails_r			= 		255,
			trails_g			=		255,
			trails_b			=		255,
			trails_a			=		255,
			trails_length		=		255,
			trails_startsize	=		16,
			trails_endsize		=		0
		}
			
		table.insert( params.CVars, "trails_r" )
		table.insert( params.CVars, "trails_g" )
		table.insert( params.CVars, "trails_b" )
		table.insert( params.CVars, "trails_a" )
		table.insert( params.CVars, "trails_length" )
		table.insert( params.CVars, "trails_startsize" )
		table.insert( params.CVars, "trails_endsize" )
		
	CPanel:AddControl( "ComboBox", params )
	
	CPanel:AddControl( "Color",  { Label	= "#tool.trails.color",
									Red			= "trails_r",
									Green		= "trails_g",
									Blue		= "trails_b",
									Alpha		= "trails_a",
									ShowAlpha	= 1,
									ShowHSV		= 1,
									ShowRGB 	= 1,
									Multiplier	= 255 } )	
									
	CPanel:NumSlider( "#tool.trails.length", "trails_length", 0, 10, 2 )
	CPanel:NumSlider( "#tool.trails.startsize", "trails_startsize", 0, 128, 2 )
	CPanel:NumSlider( "#tool.trails.endsize", "trails_endsize", 0, 128, 2 )
									
	CPanel:MatSelect( "trails_material", list.Get( "trail_materials" ), true, 0.25, 0.25 )
									
end
