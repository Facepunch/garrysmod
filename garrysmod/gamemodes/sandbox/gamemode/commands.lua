
include( "prop_tools.lua" )

--[[---------------------------------------------------------
	Name: CCSpawn
	Desc: Console Command for a player to spawn different items
-----------------------------------------------------------]]
function CCSpawn( ply, command, arguments )

	-- We don't support this command from dedicated server console
	if ( !IsValid( ply ) ) then return end

	if ( arguments[ 1 ] == nil ) then return end
	if ( arguments[ 1 ]:find( "%.[/\\]" ) ) then return end

	-- Clean up the path from attempted blacklist bypasses
	arguments[ 1 ] = arguments[ 1 ]:gsub( "\\\\+", "/" )
	arguments[ 1 ] = arguments[ 1 ]:gsub( "//+", "/" )
	arguments[ 1 ] = arguments[ 1 ]:gsub( "\\/+", "/" )
	arguments[ 1 ] = arguments[ 1 ]:gsub( "/\\+", "/" )

	if ( !gamemode.Call( "PlayerSpawnObject", ply, arguments[ 1 ], arguments[ 2 ] ) ) then return end
	if ( !util.IsValidModel( arguments[ 1 ] ) ) then return end

	local iSkin = tonumber( arguments[ 2 ] ) or 0
	local strBody = arguments[ 3 ] or nil

	if ( util.IsValidProp( arguments[ 1 ] ) ) then

		GMODSpawnProp( ply, arguments[ 1 ], iSkin, strBody )
		return

	end

	if ( util.IsValidRagdoll( arguments[ 1 ] ) ) then

		GMODSpawnRagdoll( ply, arguments[ 1 ], iSkin, strBody )
		return

	end

	-- Not a ragdoll or prop.. must be an 'effect' - spawn it as one
	GMODSpawnEffect( ply, arguments[ 1 ], iSkin, strBody )

end
concommand.Add( "gm_spawn", CCSpawn, nil, "Spawns props/ragdolls" )

local function MakeRagdoll( ply, _, _, model, _, Data )

	if ( !gamemode.Call( "PlayerSpawnRagdoll", ply, model ) ) then return end

	local Ent = ents.Create( "prop_ragdoll" )
	duplicator.DoGeneric( Ent, Data )
	Ent:Spawn()

	duplicator.DoGenericPhysics( Ent, ply, Data )

	Ent:Activate()

	if ( IsValid( ply ) ) then
		gamemode.Call( "PlayerSpawnedRagdoll", ply, model, Ent )
	end

	DoPropSpawnedEffect( Ent )

	return Ent

end

-- Register the "prop_ragdoll" class with the duplicator, (Args in brackets will be retreived for every bone)
duplicator.RegisterEntityClass( "prop_ragdoll", MakeRagdoll, "Pos", "Ang", "Model", "PhysicsObjects", "Data" )

--[[---------------------------------------------------------
	Name: GMODSpawnRagdoll - player spawns a ragdoll
-----------------------------------------------------------]]
function GMODSpawnRagdoll( ply, model, iSkin, strBody )

	if ( !gamemode.Call( "PlayerSpawnRagdoll", ply, model ) ) then return end
	local e = DoPlayerEntitySpawn( ply, "prop_ragdoll", model, iSkin, strBody )

	if ( IsValid( ply ) ) then
		gamemode.Call( "PlayerSpawnedRagdoll", ply, model, e )
	end

	DoPropSpawnedEffect( e )

	undo.Create( "Ragdoll" )
		undo.SetPlayer( ply )
		undo.AddEntity( e )
	undo.Finish( "Ragdoll (" .. tostring( model ) .. ")" )

	ply:AddCleanup( "ragdolls", e )

end

function MakeProp( ply, Pos, Ang, model, _, Data )

	-- Uck.
	Data.Pos = Pos
	Data.Angle = Ang
	Data.Model = model

	-- Make sure this is allowed
	if ( IsValid( ply ) && !gamemode.Call( "PlayerSpawnProp", ply, model ) ) then return end

	local Prop = ents.Create( "prop_physics" )
	duplicator.DoGeneric( Prop, Data )
	Prop:Spawn()

	duplicator.DoGenericPhysics( Prop, ply, Data )

	-- Tell the gamemode we just spawned something
	if ( IsValid( ply ) ) then
		gamemode.Call( "PlayerSpawnedProp", ply, model, Prop )
	end

	FixInvalidPhysicsObject( Prop )

	DoPropSpawnedEffect( Prop )

	return Prop

end

duplicator.RegisterEntityClass( "prop_physics", MakeProp, "Pos", "Ang", "Model", "PhysicsObjects", "Data" )
duplicator.RegisterEntityClass( "prop_physics_multiplayer", MakeProp, "Pos", "Ang", "Model", "PhysicsObjects", "Data" )

function MakeEffect( ply, model, Data )

	Data.Model = model

	-- Make sure this is allowed
	if ( IsValid( ply ) && !gamemode.Call( "PlayerSpawnEffect", ply, model ) ) then return end

	local Prop = ents.Create( "prop_effect" )
	duplicator.DoGeneric( Prop, Data )
	if ( Data.AttachedEntityInfo ) then
		Prop.AttachedEntityInfo = table.Copy( Data.AttachedEntityInfo ) -- This shouldn't be neccesary
	end
	Prop:Spawn()

	-- duplicator.DoGenericPhysics( Prop, ply, Data )

	-- Tell the gamemode we just spawned something
	if ( IsValid( ply ) ) then
		gamemode.Call( "PlayerSpawnedEffect", ply, model, Prop )
	end

	if ( IsValid( Prop.AttachedEntity ) ) then
		DoPropSpawnedEffect( Prop.AttachedEntity )
	end

	return Prop

end

duplicator.RegisterEntityClass( "prop_effect", MakeEffect, "Model", "Data" )

--[[---------------------------------------------------------
	Name: FixInvalidPhysicsObject
			Attempts to detect and correct the physics object
			on models such as the TF2 Turrets
-----------------------------------------------------------]]
function FixInvalidPhysicsObject( Prop )

	local PhysObj = Prop:GetPhysicsObject()
	if ( !IsValid( PhysObj ) ) then return end

	local min, max = PhysObj:GetAABB()
	if ( !min or !max ) then return end

	local PhysSize = ( min - max ):Length()
	if ( PhysSize > 5 ) then return end

	local min = Prop:OBBMins()
	local max = Prop:OBBMaxs()
	if ( !min or !max ) then return end

	local ModelSize = ( min - max ):Length()
	local Difference = math.abs( ModelSize - PhysSize )
	if ( Difference < 10 ) then return end

	-- This physics object is definitiely weird.
	-- Make a new one.

	Prop:PhysicsInitBox( min, max )
	Prop:SetCollisionGroup( COLLISION_GROUP_DEBRIS )

	local PhysObj = Prop:GetPhysicsObject()
	if ( !IsValid( PhysObj ) ) then return end

	PhysObj:SetMass( 100 )
	PhysObj:Wake()

end

--[[---------------------------------------------------------
	Name: CCSpawnProp - player spawns a prop
-----------------------------------------------------------]]
function GMODSpawnProp( ply, model, iSkin, strBody )

	if ( !gamemode.Call( "PlayerSpawnProp", ply, model ) ) then return end

	local e = DoPlayerEntitySpawn( ply, "prop_physics", model, iSkin, strBody )
	if ( !IsValid( e ) ) then return end

	if ( IsValid( ply ) ) then
		gamemode.Call( "PlayerSpawnedProp", ply, model, e )
	end

	-- This didn't work out - todo: Find a better way.
	--timer.Simple( 0.01, CheckPropSolid, e, COLLISION_GROUP_NONE, COLLISION_GROUP_WORLD )

	FixInvalidPhysicsObject( e )

	DoPropSpawnedEffect( e )

	undo.Create( "Prop" )
		undo.SetPlayer( ply )
		undo.AddEntity( e )
	undo.Finish( "Prop (" .. tostring( model ) .. ")" )

	ply:AddCleanup( "props", e )

end

--[[---------------------------------------------------------
	Name: GMODSpawnEffect
-----------------------------------------------------------]]
function GMODSpawnEffect( ply, model, iSkin, strBody )

	if ( !gamemode.Call( "PlayerSpawnEffect", ply, model ) ) then return end

	local e = DoPlayerEntitySpawn( ply, "prop_effect", model, iSkin, strBody )
	if ( !IsValid( e ) ) then return end

	if ( IsValid( ply ) ) then
		gamemode.Call( "PlayerSpawnedEffect", ply, model, e )
	end

	if ( IsValid( e.AttachedEntity ) ) then
		DoPropSpawnedEffect( e.AttachedEntity )
	end

	undo.Create( "Effect" )
		undo.SetPlayer( ply )
		undo.AddEntity( e )
	undo.Finish( "Effect (" .. tostring( model ) .. ")" )

	ply:AddCleanup( "effects", e )

end

--[[---------------------------------------------------------
	Name: DoPlayerEntitySpawn
	Desc: Utility function for player entity spawning functions
-----------------------------------------------------------]]
function DoPlayerEntitySpawn( ply, entity_name, model, iSkin, strBody )

	local vStart = ply:GetShootPos()
	local vForward = ply:GetAimVector()

	local trace = {}
	trace.start = vStart
	trace.endpos = vStart + ( vForward * 2048 )
	trace.filter = ply

	local tr = util.TraceLine( trace )

	-- Prevent spawning too close
	--[[if ( !tr.Hit || tr.Fraction < 0.05 ) then
		return
	end]]

	local ent = ents.Create( entity_name )
	if ( !IsValid( ent ) ) then return end

	local ang = ply:EyeAngles()
	ang.yaw = ang.yaw + 180 -- Rotate it 180 degrees in my favour
	ang.roll = 0
	ang.pitch = 0

	if ( entity_name == "prop_ragdoll" ) then
		ang.pitch = -90
		tr.HitPos = tr.HitPos
	end

	ent:SetModel( model )
	ent:SetSkin( iSkin )
	ent:SetAngles( ang )
	ent:SetBodyGroups( strBody )
	ent:SetPos( tr.HitPos )
	ent:Spawn()
	ent:Activate()

	-- Special case for effects
	if ( entity_name == "prop_effect" && IsValid( ent.AttachedEntity ) ) then
		ent.AttachedEntity:SetBodyGroups( strBody )
	end

	-- Attempt to move the object so it sits flush
	-- We could do a TraceEntity instead of doing all
	-- of this - but it feels off after the old way

	local vFlushPoint = tr.HitPos - ( tr.HitNormal * 512 )	-- Find a point that is definitely out of the object in the direction of the floor
	vFlushPoint = ent:NearestPoint( vFlushPoint )			-- Find the nearest point inside the object to that point
	vFlushPoint = ent:GetPos() - vFlushPoint				-- Get the difference
	vFlushPoint = tr.HitPos + vFlushPoint					-- Add it to our target pos

	if ( entity_name != "prop_ragdoll" ) then

		-- Set new position
		ent:SetPos( vFlushPoint )
		ply:SendLua( "achievements.SpawnedProp()" )

	else

		-- With ragdolls we need to move each physobject
		local VecOffset = vFlushPoint - ent:GetPos()
		for i = 0, ent:GetPhysicsObjectCount() - 1 do
			local phys = ent:GetPhysicsObjectNum( i )
			phys:SetPos( phys:GetPos() + VecOffset )
		end

		ply:SendLua( "achievements.SpawnedRagdoll()" )

	end

	return ent

end

local function InternalSpawnNPC( ply, Position, Normal, Class, Equipment, SpawnFlagsSaved, NoDropToFloor )

	local NPCList = list.Get( "NPC" )
	local NPCData = NPCList[ Class ]

	-- Don't let them spawn this entity if it isn't in our NPC Spawn list.
	-- We don't want them spawning any entity they like!
	if ( !NPCData ) then
		if ( IsValid( ply ) ) then
			ply:SendLua( "Derma_Message( \"Sorry! You can't spawn that NPC!\" )" )
		end
		return
	end

	if ( NPCData.AdminOnly && !ply:IsAdmin() ) then return end

	local bDropToFloor = false

	--
	-- This NPC has to be spawned on a ceiling ( Barnacle )
	--
	if ( NPCData.OnCeiling ) then
		if ( Vector( 0, 0, -1 ):Dot( Normal ) < 0.95 ) then
			return nil
		end

	--
	-- This NPC has to be spawned on a floor ( Turrets )
	--
	elseif ( NPCData.OnFloor && Vector( 0, 0, 1 ):Dot( Normal ) < 0.95 ) then
		return nil
	else
		bDropToFloor = true
	end

	if ( NPCData.NoDrop or NoDropToFloor ) then bDropToFloor = false end

	-- Create NPC
	local NPC = ents.Create( NPCData.Class )
	if ( !IsValid( NPC ) ) then return end

	--
	-- Offset the position
	--
	local Offset = NPCData.Offset or 32
	NPC:SetPos( Position + Normal * Offset )

	-- Rotate to face player (expected behaviour)
	local Angles = Angle( 0, 0, 0 )

	if ( IsValid( ply ) ) then
		Angles = ply:GetAngles()
	end

	Angles.pitch = 0
	Angles.roll = 0
	Angles.yaw = Angles.yaw + 180

	if ( NPCData.Rotate ) then Angles = Angles + NPCData.Rotate end

	NPC:SetAngles( Angles )

	--
	-- This NPC has a special model we want to define
	--
	if ( NPCData.Model ) then
		NPC:SetModel( NPCData.Model )
	end

	--
	-- This NPC has a special texture we want to define
	--
	if ( NPCData.Material ) then
		NPC:SetMaterial( NPCData.Material )
	end

	--
	-- Spawn Flags
	--
	local SpawnFlags = bit.bor( SF_NPC_FADE_CORPSE, SF_NPC_ALWAYSTHINK )
	if ( NPCData.SpawnFlags ) then SpawnFlags = bit.bor( SpawnFlags, NPCData.SpawnFlags ) end
	if ( NPCData.TotalSpawnFlags ) then SpawnFlags = NPCData.TotalSpawnFlags end
	if ( SpawnFlagsSaved ) then SpawnFlags = SpawnFlagsSaved end
	NPC:SetKeyValue( "spawnflags", SpawnFlags )
	NPC.SpawnFlags = SpawnFlags

	--
	-- Optional Key Values
	--
	if ( NPCData.KeyValues ) then
		for k, v in pairs( NPCData.KeyValues ) do
			NPC:SetKeyValue( k, v )
		end
	end

	--
	-- This NPC has a special skin we want to define
	--
	if ( NPCData.Skin ) then
		NPC:SetSkin( NPCData.Skin )
	end

	--
	-- What weapon should this mother be carrying
	--

	-- Check if this is a valid entity from the list, or the user is trying to fool us.
	local valid = false
	for _, v in pairs( list.Get( "NPCUsableWeapons" ) ) do
		if v.class == Equipment then valid = true break end
	end

	if ( Equipment && Equipment != "none" && valid ) then
		NPC:SetKeyValue( "additionalequipment", Equipment )
		NPC.Equipment = Equipment
	end

	DoPropSpawnedEffect( NPC )

	NPC:Spawn()
	NPC:Activate()

	if ( bDropToFloor ) then
		NPC:DropToFloor()
	end

	if ( NPCData.Health ) then
		NPC:SetHealth( NPCData.Health )
	end

	-- Body groups
	if ( NPCData.BodyGroups ) then
		for k, v in pairs( NPCData.BodyGroups ) do
			NPC:SetBodygroup( k, v )
		end
	end

	return NPC

end

function Spawn_NPC( ply, NPCClassName, WeaponName, tr )

	-- We don't support this command from dedicated server console
	if ( !IsValid( ply ) ) then return end

	if ( !NPCClassName ) then return end

	-- Give the gamemode an opportunity to deny spawning
	if ( !gamemode.Call( "PlayerSpawnNPC", ply, NPCClassName, WeaponName ) ) then return end

	if ( !tr ) then

		local vStart = ply:GetShootPos()
		local vForward = ply:GetAimVector()

		local trace = {}
		trace.start = vStart
		trace.endpos = vStart + vForward * 2048
		trace.filter = ply

		tr = util.TraceLine( trace )

	end

	-- Create the NPC is you can.
	local SpawnedNPC = InternalSpawnNPC( ply, tr.HitPos, tr.HitNormal, NPCClassName, WeaponName )
	if ( !IsValid( SpawnedNPC ) ) then return end

	-- Give the gamemode an opportunity to do whatever
	if ( IsValid( ply ) ) then
		gamemode.Call( "PlayerSpawnedNPC", ply, SpawnedNPC )
	end

	-- See if we can find a nice name for this NPC..
	local NPCList = list.Get( "NPC" )
	local NiceName = nil
	if ( NPCList[ NPCClassName ] ) then
		NiceName = NPCList[ NPCClassName ].Name
	end

	-- Add to undo list
	undo.Create( "NPC" )
		undo.SetPlayer( ply )
		undo.AddEntity( SpawnedNPC )
		if ( NiceName ) then
			undo.SetCustomUndoText( "Undone " .. NiceName )
		end
	undo.Finish( "NPC (" .. tostring( NPCClassName ) .. ")" )

	-- And cleanup
	ply:AddCleanup( "npcs", SpawnedNPC )

	ply:SendLua( "achievements.SpawnedNPC()" )

end
concommand.Add( "gmod_spawnnpc", function( ply, cmd, args ) Spawn_NPC( ply, args[ 1 ], args[ 2 ] ) end )

-- This should be in base_npcs.lua really
local function GenericNPCDuplicator( ply, mdl, class, equipment, spawnflags, data )

	if ( !gamemode.Call( "PlayerSpawnNPC", ply, class, equipment ) ) then return end

	local normal = Vector( 0, 0, 1 )

	local NPCList = list.Get( "NPC" )
	local NPCData = NPCList[ class ]
	if ( NPCData && NPCData.OnCeiling ) then normal = Vector( 0, 0, -1 ) end

	local ent = InternalSpawnNPC( ply, data.Pos, normal, class, equipment, spawnflags, true )

	if ( IsValid( ent ) ) then
		local pos = ent:GetPos() -- Hack! Prevnets the NPCs from falling through the floor

		duplicator.DoGeneric( ent, data )

		if ( !NPCData.OnCeiling && !NPCData.NoDrop ) then
			ent:SetPos( pos )
			ent:DropToFloor()
		end

		if ( IsValid( ply ) ) then
			gamemode.Call( "PlayerSpawnedNPC", ply, ent )
			ply:AddCleanup( "npcs", ent )
		end

		table.Add( ent:GetTable(), data )

	end

	return ent

end

-- Huuuuuuuuhhhh
local function AddNPCToDuplicator( class ) duplicator.RegisterEntityClass( class, GenericNPCDuplicator, "Model", "Class", "Equipment", "SpawnFlags", "Data" ) end

-- HL2
AddNPCToDuplicator( "npc_alyx" )
AddNPCToDuplicator( "npc_magnusson" )
AddNPCToDuplicator( "npc_breen" )
AddNPCToDuplicator( "npc_kleiner" )
AddNPCToDuplicator( "npc_antlion" )
AddNPCToDuplicator( "npc_antlion_worker" )
AddNPCToDuplicator( "npc_antlion_grub" )
AddNPCToDuplicator( "npc_antlionguard" )
AddNPCToDuplicator( "npc_barnacle" )
AddNPCToDuplicator( "npc_barney" )
AddNPCToDuplicator( "npc_combine_s" )
AddNPCToDuplicator( "npc_crow" )
AddNPCToDuplicator( "npc_cscanner" )
AddNPCToDuplicator( "npc_clawscanner" )
AddNPCToDuplicator( "npc_dog" )
AddNPCToDuplicator( "npc_eli" )
AddNPCToDuplicator( "npc_gman" )
AddNPCToDuplicator( "npc_headcrab" )
AddNPCToDuplicator( "npc_headcrab_black" )
AddNPCToDuplicator( "npc_headcrab_poison" )
AddNPCToDuplicator( "npc_headcrab_fast" )
AddNPCToDuplicator( "npc_manhack" )
AddNPCToDuplicator( "npc_metropolice" )
AddNPCToDuplicator( "npc_monk" )
AddNPCToDuplicator( "npc_mossman" )
AddNPCToDuplicator( "npc_pigeon" )
AddNPCToDuplicator( "npc_rollermine" )
AddNPCToDuplicator( "npc_strider" )
AddNPCToDuplicator( "npc_helicopter" )
AddNPCToDuplicator( "npc_combinegunship" )
AddNPCToDuplicator( "npc_combinedropship" )
AddNPCToDuplicator( "npc_turret_ceiling" )
AddNPCToDuplicator( "npc_combine_camera" )
AddNPCToDuplicator( "npc_turret_floor" )
AddNPCToDuplicator( "npc_vortigaunt" )
AddNPCToDuplicator( "npc_hunter" )
AddNPCToDuplicator( "npc_sniper" )
AddNPCToDuplicator( "npc_seagull" )
AddNPCToDuplicator( "npc_citizen" )
AddNPCToDuplicator( "npc_stalker" )
AddNPCToDuplicator( "npc_fisherman" )
AddNPCToDuplicator( "npc_zombie" )
AddNPCToDuplicator( "npc_zombie_torso" )
AddNPCToDuplicator( "npc_zombine" )
AddNPCToDuplicator( "npc_poisonzombie" )
AddNPCToDuplicator( "npc_fastzombie" )
AddNPCToDuplicator( "npc_fastzombie_torso" )

-- HL1
AddNPCToDuplicator( "monster_alien_grunt" )
AddNPCToDuplicator( "monster_alien_slave" )
AddNPCToDuplicator( "monster_alien_controller" )
AddNPCToDuplicator( "monster_barney" )
AddNPCToDuplicator( "monster_bigmomma" )
AddNPCToDuplicator( "monster_bullchicken" )
AddNPCToDuplicator( "monster_babycrab" )
AddNPCToDuplicator( "monster_cockroach" )
AddNPCToDuplicator( "monster_houndeye" )
AddNPCToDuplicator( "monster_headcrab" )
AddNPCToDuplicator( "monster_gargantua" )
AddNPCToDuplicator( "monster_human_assassin" )
AddNPCToDuplicator( "monster_human_grunt" )
AddNPCToDuplicator( "monster_scientist" )
AddNPCToDuplicator( "monster_snark" )
AddNPCToDuplicator( "monster_nihilanth" )
AddNPCToDuplicator( "monster_tentacle" )
AddNPCToDuplicator( "monster_zombie" )
AddNPCToDuplicator( "monster_turret" )
AddNPCToDuplicator( "monster_miniturret" )
AddNPCToDuplicator( "monster_sentry" )

--[[---------------------------------------------------------
	Name: CanPlayerSpawnSENT
-----------------------------------------------------------]]
local function CanPlayerSpawnSENT( ply, EntityName )

	-- Make sure this is a SWEP
	local sent = scripted_ents.GetStored( EntityName )
	if ( sent == nil ) then

		-- Is this in the SpawnableEntities list?
		local SpawnableEntities = list.Get( "SpawnableEntities" )
		if ( !SpawnableEntities ) then return false end
		local EntTable = SpawnableEntities[ EntityName ]
		if ( !EntTable ) then return false end
		if ( EntTable.AdminOnly && !ply:IsAdmin() ) then return false end
		return true

	end

	-- We need a spawn function. The SENT can then spawn itself properly
	local SpawnFunction = scripted_ents.GetMember( EntityName, "SpawnFunction" )
	if ( !isfunction( SpawnFunction ) ) then return false end

	-- You're not allowed to spawn this unless you're an admin!
	if ( !scripted_ents.GetMember( EntityName, "Spawnable" ) && !ply:IsAdmin() ) then return false end
	if ( scripted_ents.GetMember( EntityName, "AdminOnly" ) && !ply:IsAdmin() ) then return false end

	return true

end

--[[---------------------------------------------------------
	Name: Spawn_SENT
	Desc: Console Command for a player to spawn different items
-----------------------------------------------------------]]
function Spawn_SENT( ply, EntityName, tr )

	-- We don't support this command from dedicated server console
	if ( !IsValid( ply ) ) then return end

	if ( EntityName == nil ) then return end

	if ( !CanPlayerSpawnSENT( ply, EntityName ) ) then return end

	-- Ask the gamemode if it's ok to spawn this
	if ( !gamemode.Call( "PlayerSpawnSENT", ply, EntityName ) ) then return end

	local vStart = ply:EyePos()
	local vForward = ply:GetAimVector()

	if ( !tr ) then

		local trace = {}
		trace.start = vStart
		trace.endpos = vStart + ( vForward * 4096 )
		trace.filter = ply

		tr = util.TraceLine( trace )

	end

	local entity = nil
	local PrintName = nil
	local sent = scripted_ents.GetStored( EntityName )

	if ( sent ) then

		local sent = sent.t

		ClassName = EntityName

			local SpawnFunction = scripted_ents.GetMember( EntityName, "SpawnFunction" )
			if ( !SpawnFunction ) then return end
			entity = SpawnFunction( sent, ply, tr, EntityName )

			if ( IsValid( entity ) ) then
				entity:SetCreator( ply )
			end

		ClassName = nil

		PrintName = sent.PrintName

	else

		-- Spawn from list table
		local SpawnableEntities = list.Get( "SpawnableEntities" )
		if ( !SpawnableEntities ) then return end
		local EntTable = SpawnableEntities[ EntityName ]
		if ( !EntTable ) then return end

		PrintName = EntTable.PrintName

		local SpawnPos = tr.HitPos + tr.HitNormal * 16
		if ( EntTable.NormalOffset ) then SpawnPos = SpawnPos + tr.HitNormal * EntTable.NormalOffset end

		entity = ents.Create( EntTable.ClassName )
		entity:SetPos( SpawnPos )

		if ( EntTable.KeyValues ) then
			for k, v in pairs( EntTable.KeyValues ) do
				entity:SetKeyValue( k, v )
			end
		end

		if ( EntTable.Material ) then
			entity:SetMaterial( EntTable.Material )
		end

		entity:Spawn()
		entity:Activate()

		if ( EntTable.DropToFloor ) then
			entity:DropToFloor()
		end

	end

	if ( !IsValid( entity ) ) then return end

	if ( IsValid( ply ) ) then
		gamemode.Call( "PlayerSpawnedSENT", ply, entity )
	end

	undo.Create( "SENT" )
		undo.SetPlayer( ply )
		undo.AddEntity( entity )
		if ( PrintName ) then
			undo.SetCustomUndoText( "Undone " .. PrintName )
		end
	undo.Finish( "Scripted Entity (" .. tostring( EntityName ) .. ")" )

	ply:AddCleanup( "sents", entity )
	entity:SetVar( "Player", ply )

end
concommand.Add( "gm_spawnsent", function( ply, cmd, args ) Spawn_SENT( ply, args[ 1 ] ) end )

--[[---------------------------------------------------------
	-- Give a swep.. duh.
-----------------------------------------------------------]]
function CCGiveSWEP( ply, command, arguments )

	-- We don't support this command from dedicated server console
	if ( !IsValid( ply ) ) then return end

	if ( arguments[1] == nil ) then return end
	if ( !ply:Alive() ) then return end

	-- Make sure this is a SWEP
	local swep = list.Get( "Weapon" )[ arguments[1] ]
	if ( swep == nil ) then return end

	-- You're not allowed to spawn this!
	if ( ( !swep.Spawnable && !ply:IsAdmin() ) or ( swep.AdminOnly && !ply:IsAdmin() ) ) then
		return
	end

	if ( !gamemode.Call( "PlayerGiveSWEP", ply, arguments[1], swep ) ) then return end

	if ( !ply:HasWeapon( swep.ClassName ) ) then
		MsgAll( "Giving " .. ply:Nick() .. " a " .. swep.ClassName .. "\n" )
		ply:Give( swep.ClassName )
	end

	-- And switch to it
	ply:SelectWeapon( swep.ClassName )

end
concommand.Add( "gm_giveswep", CCGiveSWEP )

--[[---------------------------------------------------------
	-- Give a swep.. duh.
-----------------------------------------------------------]]
function Spawn_Weapon( ply, wepname, tr )

	-- We don't support this command from dedicated server console
	if ( !IsValid( ply ) ) then return end

	if ( wepname == nil ) then return end

	local swep = list.Get( "Weapon" )[ wepname ]

	-- Make sure this is a SWEP
	if ( swep == nil ) then return end

	-- You're not allowed to spawn this!
	if ( ( !swep.Spawnable && !ply:IsAdmin() ) or ( swep.AdminOnly && !ply:IsAdmin() ) ) then
		return
	end

	if ( !gamemode.Call( "PlayerSpawnSWEP", ply, wepname, swep ) ) then return end

	if ( !tr ) then
		tr = ply:GetEyeTraceNoCursor()
	end

	if ( !tr.Hit ) then return end

	local entity = ents.Create( swep.ClassName )

	if ( !IsValid( entity ) ) then return end

	DoPropSpawnedEffect( entity )

	entity:SetPos( tr.HitPos + tr.HitNormal * 32 )
	entity:Spawn()

	gamemode.Call( "PlayerSpawnedSWEP", ply, entity )

end
concommand.Add( "gm_spawnswep", function( ply, cmd, args ) Spawn_Weapon( ply, args[1] ) end )

local function MakeVehicle( ply, Pos, Ang, model, Class, VName, VTable, data )

	-- We don't support this command from dedicated server console
	if ( !IsValid( ply ) ) then return end

	if ( !gamemode.Call( "PlayerSpawnVehicle", ply, model, VName, VTable ) ) then return end

	local Ent = ents.Create( Class )
	if ( !IsValid( Ent ) ) then return NULL end

	duplicator.DoGeneric( Ent, data )

	Ent:SetModel( model )

	-- Fallback vehiclescripts for HL2 maps ( dupe support )
	if ( model == "models/buggy.mdl" ) then Ent:SetKeyValue( "vehiclescript", "scripts/vehicles/jeep_test.txt" ) end
	if ( model == "models/vehicle.mdl" ) then Ent:SetKeyValue( "vehiclescript", "scripts/vehicles/jalopy.txt" ) end

	-- Fill in the keyvalues if we have them
	if ( VTable && VTable.KeyValues ) then
		for k, v in pairs( VTable.KeyValues ) do

			local kLower = string.lower( k )

			if ( kLower == "vehiclescript" or
				 kLower == "limitview"     or
				 kLower == "vehiclelocked" or
				 kLower == "cargovisible"  or
				 kLower == "enablegun" )
			then
				Ent:SetKeyValue( k, v )
			end

		end
	end

	Ent:SetAngles( Ang )
	Ent:SetPos( Pos )

	DoPropSpawnedEffect( Ent )

	Ent:Spawn()
	Ent:Activate()

	if ( Ent.SetVehicleClass && VName ) then Ent:SetVehicleClass( VName ) end
	Ent.VehicleName = VName
	Ent.VehicleTable = VTable

	-- We need to override the class in the case of the Jeep, because it
	-- actually uses a different class than is reported by GetClass
	Ent.ClassOverride = Class

	if ( IsValid( ply ) ) then
		gamemode.Call( "PlayerSpawnedVehicle", ply, Ent )
	end

	return Ent

end

duplicator.RegisterEntityClass( "prop_vehicle_jeep_old", MakeVehicle, "Pos", "Ang", "Model", "Class", "VehicleName", "VehicleTable", "Data" )
duplicator.RegisterEntityClass( "prop_vehicle_jeep", MakeVehicle, "Pos", "Ang", "Model", "Class", "VehicleName", "VehicleTable", "Data" )
duplicator.RegisterEntityClass( "prop_vehicle_airboat", MakeVehicle, "Pos", "Ang", "Model", "Class", "VehicleName", "VehicleTable", "Data" )
duplicator.RegisterEntityClass( "prop_vehicle_prisoner_pod", MakeVehicle, "Pos", "Ang", "Model", "Class", "VehicleName", "VehicleTable", "Data" )

--[[---------------------------------------------------------
	Name: CCSpawnVehicle
	Desc: Player attempts to spawn vehicle
-----------------------------------------------------------]]
function Spawn_Vehicle( ply, vname, tr )

	if ( !vname ) then return end

	local VehicleList = list.Get( "Vehicles" )
	local vehicle = VehicleList[ vname ]

	-- Not a valid vehicle to be spawning..
	if ( !vehicle ) then return end

	if ( !tr ) then
		tr = ply:GetEyeTraceNoCursor()
	end

	local Angles = ply:GetAngles()
	Angles.pitch = 0
	Angles.roll = 0
	Angles.yaw = Angles.yaw + 180

	local pos = tr.HitPos
	if ( vehicle.Offset ) then
		pos = pos + tr.HitNormal * vehicle.Offset
	end

	local Ent = MakeVehicle( ply, pos, Angles, vehicle.Model, vehicle.Class, vname, vehicle )
	if ( !IsValid( Ent ) ) then return end

	if ( vehicle.Members ) then
		table.Merge( Ent, vehicle.Members )
		duplicator.StoreEntityModifier( Ent, "VehicleMemDupe", vehicle.Members )
	end

	undo.Create( "Vehicle" )
		undo.SetPlayer( ply )
		undo.AddEntity( Ent )
		undo.SetCustomUndoText( "Undone " .. vehicle.Name )
	undo.Finish( "Vehicle (" .. tostring( vehicle.Name ) .. ")" )

	ply:AddCleanup( "vehicles", Ent )

end
concommand.Add( "gm_spawnvehicle", function( ply, cmd, args ) Spawn_Vehicle( ply, args[1] ) end )

local function VehicleMemDupe( ply, ent, Data )

	table.Merge( ent, Data )

end
duplicator.RegisterEntityModifier( "VehicleMemDupe", VehicleMemDupe )
