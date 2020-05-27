
--[[---------------------------------------------------------
	Name: gamemode:OnPhysgunFreeze( weapon, phys, ent, player )
	Desc: The physgun wants to freeze a prop
-----------------------------------------------------------]]
function GM:OnPhysgunFreeze( weapon, phys, ent, ply )

	-- Object is already frozen (!?)
	if ( !phys:IsMoveable() ) then return false end
	if ( ent:GetUnFreezable() ) then return false end

	phys:EnableMotion( false )

	-- With the jeep we need to pause all of its physics objects
	-- to stop it spazzing out and killing the server.
	if ( ent:GetClass() == "prop_vehicle_jeep" ) then

		local objects = ent:GetPhysicsObjectCount()

		for i = 0, objects - 1 do

			local physobject = ent:GetPhysicsObjectNum( i )
			physobject:EnableMotion( false )

		end

	end

	-- Add it to the player's frozen props
	ply:AddFrozenPhysicsObject( ent, phys )

	return true

end

--[[---------------------------------------------------------
	Name: gamemode:OnPhysgunReload( weapon, player )
	Desc: The physgun wants to freeze a prop
-----------------------------------------------------------]]
function GM:OnPhysgunReload( weapon, ply )

	ply:PhysgunUnfreeze()

end

--[[---------------------------------------------------------
	Name: gamemode:PlayerAuthed()
	Desc: Player's STEAMID has been authed
-----------------------------------------------------------]]
function GM:PlayerAuthed( ply, SteamID, UniqueID )
end

--[[---------------------------------------------------------
	Name: gamemode:PlayerCanPickupWeapon()
	Desc: Called when a player tries to pickup a weapon.
		return true to allow the pickup.
-----------------------------------------------------------]]
function GM:PlayerCanPickupWeapon( ply, entity )

	return true

end

--[[---------------------------------------------------------
	Name: gamemode:PlayerCanPickupItem()
	Desc: Called when a player tries to pickup an item.
		 return true to allow the pickup.
-----------------------------------------------------------]]
function GM:PlayerCanPickupItem( ply, entity )

	return true

end

--[[---------------------------------------------------------
	Name: gamemode:CanPlayerUnfreeze()
	Desc: Can the player unfreeze this entity & physobject
-----------------------------------------------------------]]
function GM:CanPlayerUnfreeze( ply, entity, physobject )

	return true

end

--[[---------------------------------------------------------
	Name: gamemode:PlayerDisconnected()
	Desc: Player has disconnected from the server.
-----------------------------------------------------------]]
function GM:PlayerDisconnected( ply )
end

--[[---------------------------------------------------------
	Name: gamemode:PlayerSay()
	Desc: A player (or server) has used say. Return a string
		 for the player to say. Return an empty string if the
		 player should say nothing.
-----------------------------------------------------------]]
function GM:PlayerSay( ply, text, teamonly )

	return text

end


--[[---------------------------------------------------------
	Name: gamemode:PlayerDeathThink( player )
	Desc: Called when the player is waiting to respawn
-----------------------------------------------------------]]
function GM:PlayerDeathThink( pl )

	if ( pl.NextSpawnTime && pl.NextSpawnTime > CurTime() ) then return end

	if ( pl:IsBot() || pl:KeyPressed( IN_ATTACK ) || pl:KeyPressed( IN_ATTACK2 ) || pl:KeyPressed( IN_JUMP ) ) then

		pl:Spawn()

	end

end

--[[---------------------------------------------------------
	Name: gamemode:PlayerUse( player, entity )
	Desc: A player has attempted to use a specific entity
		Return true if the player can use it
------------------------------------------------------------]]
function GM:PlayerUse( ply, entity )

	return true

end

--[[---------------------------------------------------------
	Name: gamemode:PlayerSilentDeath()
	Desc: Called when a player dies silently
-----------------------------------------------------------]]
function GM:PlayerSilentDeath( Victim )

	Victim.NextSpawnTime = CurTime() + 2
	Victim.DeathTime = CurTime()

end

-- Pool network strings used for PlayerDeaths.
util.AddNetworkString( "PlayerKilled" )
util.AddNetworkString( "PlayerKilledSelf" )
util.AddNetworkString( "PlayerKilledByPlayer" )

--[[---------------------------------------------------------
	Name: gamemode:PlayerDeath()
	Desc: Called when a player dies.
-----------------------------------------------------------]]
function GM:PlayerDeath( ply, inflictor, attacker )

	-- Don't spawn for at least 2 seconds
	ply.NextSpawnTime = CurTime() + 2
	ply.DeathTime = CurTime()

	if ( IsValid( attacker ) && attacker:GetClass() == "trigger_hurt" ) then attacker = ply end

	if ( IsValid( attacker ) && attacker:IsVehicle() && IsValid( attacker:GetDriver() ) ) then
		attacker = attacker:GetDriver()
	end

	if ( !IsValid( inflictor ) && IsValid( attacker ) ) then
		inflictor = attacker
	end

	-- Convert the inflictor to the weapon that they're holding if we can.
	-- This can be right or wrong with NPCs since combine can be holding a
	-- pistol but kill you by hitting you with their arm.
	if ( IsValid( inflictor ) && inflictor == attacker && ( inflictor:IsPlayer() || inflictor:IsNPC() ) ) then

		inflictor = inflictor:GetActiveWeapon()
		if ( !IsValid( inflictor ) ) then inflictor = attacker end

	end

	player_manager.RunClass( ply, "Death", inflictor, attacker )

	if ( attacker == ply ) then

		net.Start( "PlayerKilledSelf" )
			net.WriteEntity( ply )
		net.Broadcast()

		MsgAll( attacker:Nick() .. " suicided!\n" )

	return end

	if ( attacker:IsPlayer() ) then

		net.Start( "PlayerKilledByPlayer" )

			net.WriteEntity( ply )
			net.WriteString( inflictor:GetClass() )
			net.WriteEntity( attacker )

		net.Broadcast()

		MsgAll( attacker:Nick() .. " killed " .. ply:Nick() .. " using " .. inflictor:GetClass() .. "\n" )

	return end

	net.Start( "PlayerKilled" )

		net.WriteEntity( ply )
		net.WriteString( inflictor:GetClass() )
		net.WriteString( attacker:GetClass() )

	net.Broadcast()

	MsgAll( ply:Nick() .. " was killed by " .. attacker:GetClass() .. "\n" )

end

--[[---------------------------------------------------------
	Name: gamemode:PlayerInitialSpawn()
	Desc: Called just before the player's first spawn
-----------------------------------------------------------]]
function GM:PlayerInitialSpawn( pl, transiton )

	pl:SetTeam( TEAM_UNASSIGNED )

	if ( GAMEMODE.TeamBased ) then
		pl:ConCommand( "gm_showteam" )
	end

end

--[[---------------------------------------------------------
	Name: gamemode:PlayerSpawnAsSpectator()
	Desc: Player spawns as a spectator
-----------------------------------------------------------]]
function GM:PlayerSpawnAsSpectator( pl )

	pl:StripWeapons()

	if ( pl:Team() == TEAM_UNASSIGNED ) then

		pl:Spectate( OBS_MODE_FIXED )
		return

	end

	pl:SetTeam( TEAM_SPECTATOR )
	pl:Spectate( OBS_MODE_ROAMING )

end

--[[---------------------------------------------------------
	Name: gamemode:PlayerSpawn()
	Desc: Called when a player spawns
-----------------------------------------------------------]]
function GM:PlayerSpawn( pl, transiton )

	--
	-- If the player doesn't have a team in a TeamBased game
	-- then spawn him as a spectator
	--
	if ( self.TeamBased && ( pl:Team() == TEAM_SPECTATOR || pl:Team() == TEAM_UNASSIGNED ) ) then

		self:PlayerSpawnAsSpectator( pl )
		return

	end

	-- Stop observer mode
	pl:UnSpectate()

	pl:SetupHands()

	player_manager.OnPlayerSpawn( pl, transiton )
	player_manager.RunClass( pl, "Spawn" )

	-- If we are in transition, do not touch player's weapons
	if ( !transiton ) then
		-- Call item loadout function
		hook.Call( "PlayerLoadout", GAMEMODE, pl )
	end

	-- Set player model
	hook.Call( "PlayerSetModel", GAMEMODE, pl )

end

--[[---------------------------------------------------------
	Name: gamemode:PlayerSetModel()
	Desc: Set the player's model
-----------------------------------------------------------]]
function GM:PlayerSetModel( pl )

	player_manager.RunClass( pl, "SetModel" )

end

--[[---------------------------------------------------------
	Name: gamemode:PlayerSetHandsModel()
	Desc: Sets the player's view model hands model
-----------------------------------------------------------]]
function GM:PlayerSetHandsModel( pl, ent )

	local info = player_manager.RunClass( pl, "GetHandsModel" )
	if ( !info ) then
		local playermodel = player_manager.TranslateToPlayerModelName( pl:GetModel() )
		info = player_manager.TranslatePlayerHands( playermodel )
	end

	if ( info ) then
		ent:SetModel( info.model )
		ent:SetSkin( info.skin )
		ent:SetBodyGroups( info.body )
	end

end

--[[---------------------------------------------------------
	Name: gamemode:PlayerLoadout()
	Desc: Give the player the default spawning weapons/ammo
-----------------------------------------------------------]]
function GM:PlayerLoadout( pl )

	player_manager.RunClass( pl, "Loadout" )

end

--[[---------------------------------------------------------
	Name: gamemode:PlayerSelectTeamSpawn( player )
	Desc: Find a spawn point entity for this player's team
-----------------------------------------------------------]]
function GM:PlayerSelectTeamSpawn( TeamID, pl )

	local SpawnPoints = team.GetSpawnPoints( TeamID )
	if ( !SpawnPoints || table.IsEmpty( SpawnPoints ) ) then return end

	local ChosenSpawnPoint = nil

	for i = 0, 6 do

		local ChosenSpawnPoint = table.Random( SpawnPoints )
		if ( hook.Call( "IsSpawnpointSuitable", GAMEMODE, pl, ChosenSpawnPoint, i == 6 ) ) then
			return ChosenSpawnPoint
		end

	end

	return ChosenSpawnPoint

end


--[[---------------------------------------------------------
	Name: gamemode:IsSpawnpointSuitable( player )
	Desc: Find out if the spawnpoint is suitable or not
-----------------------------------------------------------]]
function GM:IsSpawnpointSuitable( pl, spawnpointent, bMakeSuitable )

	local Pos = spawnpointent:GetPos()

	-- Note that we're searching the default hull size here for a player in the way of our spawning.
	-- This seems pretty rough, seeing as our player's hull could be different.. but it should do the job
	-- (HL2DM kills everything within a 128 unit radius)
	local Ents = ents.FindInBox( Pos + Vector( -16, -16, 0 ), Pos + Vector( 16, 16, 64 ) )

	if ( pl:Team() == TEAM_SPECTATOR ) then return true end

	local Blockers = 0

	for k, v in pairs( Ents ) do
		if ( IsValid( v ) && v != pl && v:GetClass() == "player" && v:Alive() ) then

			Blockers = Blockers + 1

			if ( bMakeSuitable ) then
				v:Kill()
			end

		end
	end

	if ( bMakeSuitable ) then return true end
	if ( Blockers > 0 ) then return false end
	return true

end

--[[---------------------------------------------------------
	Name: gamemode:PlayerSelectSpawn( player )
	Desc: Find a spawn point entity for this player
-----------------------------------------------------------]]
function GM:PlayerSelectSpawn( pl, transiton )

	-- If we are in transition, do not reset player's position
	if ( transiton ) then return end

	if ( self.TeamBased ) then

		local ent = self:PlayerSelectTeamSpawn( pl:Team(), pl )
		if ( IsValid( ent ) ) then return ent end

	end

	-- Save information about all of the spawn points
	-- in a team based game you'd split up the spawns
	if ( !IsTableOfEntitiesValid( self.SpawnPoints ) ) then

		self.LastSpawnPoint = 0
		self.SpawnPoints = ents.FindByClass( "info_player_start" )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_deathmatch" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_combine" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_rebel" ) )

		-- CS Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_counterterrorist" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_terrorist" ) )

		-- DOD Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_axis" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_allies" ) )

		-- (Old) GMod Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "gmod_player_start" ) )

		-- TF Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_teamspawn" ) )

		-- INS Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "ins_spawnpoint" ) )

		-- AOC Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "aoc_spawnpoint" ) )

		-- Dystopia Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "dys_spawn_point" ) )

		-- PVKII Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_pirate" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_viking" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_knight" ) )

		-- DIPRIP Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "diprip_start_team_blue" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "diprip_start_team_red" ) )

		-- OB Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_red" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_blue" ) )

		-- SYN Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_coop" ) )

		-- ZPS Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_human" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_zombie" ) )

		-- ZM Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_zombiemaster" ) )

		-- FOF Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_fof" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_desperado" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_vigilante" ) )

		-- L4D Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_survivor_rescue" ) )
		-- Removing this one for the time being, c1m4_atrium has one of these in a box under the map
		--self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_survivor_position" ) )

	end

	local Count = table.Count( self.SpawnPoints )

	if ( Count == 0 ) then
		Msg("[PlayerSelectSpawn] Error! No spawn points!\n")
		return nil
	end

	-- If any of the spawnpoints have a MASTER flag then only use that one.
	-- This is needed for single player maps.
	for k, v in pairs( self.SpawnPoints ) do

		if ( v:HasSpawnFlags( 1 ) && hook.Call( "IsSpawnpointSuitable", GAMEMODE, pl, v, true ) ) then
			return v
		end

	end

	local ChosenSpawnPoint = nil

	-- Try to work out the best, random spawnpoint
	for i = 1, Count do

		ChosenSpawnPoint = table.Random( self.SpawnPoints )

		if ( IsValid( ChosenSpawnPoint ) && ChosenSpawnPoint:IsInWorld() ) then
			if ( ( ChosenSpawnPoint == pl:GetVar( "LastSpawnpoint" ) || ChosenSpawnPoint == self.LastSpawnPoint ) && Count > 1 ) then continue end

			if ( hook.Call( "IsSpawnpointSuitable", GAMEMODE, pl, ChosenSpawnPoint, i == Count ) ) then

				self.LastSpawnPoint = ChosenSpawnPoint
				pl:SetVar( "LastSpawnpoint", ChosenSpawnPoint )
				return ChosenSpawnPoint

			end

		end

	end

	return ChosenSpawnPoint

end

--[[---------------------------------------------------------
	Name: gamemode:WeaponEquip( weapon )
	Desc: Player just picked up (or was given) weapon
-----------------------------------------------------------]]
function GM:WeaponEquip( weapon )
end

--[[---------------------------------------------------------
	Name: gamemode:ScalePlayerDamage( ply, hitgroup, dmginfo )
	Desc: Scale the damage based on being shot in a hitbox
		 Return true to not take damage
-----------------------------------------------------------]]
function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )

	-- More damage if we're shot in the head
	if ( hitgroup == HITGROUP_HEAD ) then

		dmginfo:ScaleDamage( 2 )

	end

	-- Less damage if we're shot in the arms or legs
	if ( hitgroup == HITGROUP_LEFTARM ||
		 hitgroup == HITGROUP_RIGHTARM ||
		 hitgroup == HITGROUP_LEFTLEG ||
		 hitgroup == HITGROUP_RIGHTLEG ||
		 hitgroup == HITGROUP_GEAR ) then

		dmginfo:ScaleDamage( 0.25 )

	end

end

--[[---------------------------------------------------------
	Name: gamemode:PlayerDeathSound()
	Desc: Return true to not play the default sounds
-----------------------------------------------------------]]
function GM:PlayerDeathSound()
	return false
end

--[[---------------------------------------------------------
	Name: gamemode:SetupPlayerVisibility()
	Desc: Add extra positions to the player's PVS
-----------------------------------------------------------]]
function GM:SetupPlayerVisibility( pPlayer, pViewEntity )
	--AddOriginToPVS( vector_position_here )
end

--[[---------------------------------------------------------
	Name: gamemode:OnDamagedByExplosion( ply, dmginfo)
	Desc: Player has been hurt by an explosion
-----------------------------------------------------------]]
function GM:OnDamagedByExplosion( ply, dmginfo )
	ply:SetDSP( 35, false )
end

--[[---------------------------------------------------------
	Name: gamemode:CanPlayerSuicide( ply )
	Desc: Player typed KILL in the console. Can they kill themselves?
-----------------------------------------------------------]]
function GM:CanPlayerSuicide( ply )
	return true
end

--[[---------------------------------------------------------
	Name: gamemode:CanPlayerEnterVehicle( player, vehicle, role )
	Desc: Return true if player can enter vehicle
-----------------------------------------------------------]]
function GM:CanPlayerEnterVehicle( ply, vehicle, role )
	return true
end

--[[---------------------------------------------------------
	Name: gamemode:PlayerEnteredVehicle( player, vehicle, role )
	Desc: Player entered the vehicle fine
-----------------------------------------------------------]]
function GM:PlayerEnteredVehicle( ply, vehicle, role )
end

--[[---------------------------------------------------------
	Name: gamemode:CanExitVehicle()
	Desc: If the player is allowed to leave the vehicle, return true
-----------------------------------------------------------]]
function GM:CanExitVehicle( vehicle, passenger )
	return true
end

--[[---------------------------------------------------------
	Name: gamemode:PlayerLeaveVehicle()
	Desc: Player left the vehicle
-----------------------------------------------------------]]
function GM:PlayerLeaveVehicle( ply, vehicle )
end

--[[---------------------------------------------------------
	Name: gamemode:PlayerSwitchFlashlight()
	Desc: Return true to allow action
-----------------------------------------------------------]]
function GM:PlayerSwitchFlashlight( ply, SwitchOn )
	return ply:CanUseFlashlight()
end

--[[---------------------------------------------------------
	Name: gamemode:PlayerCanJoinTeam( ply, teamid )
	Desc: Allow mods/addons to easily determine whether a player
		can join a team or not
-----------------------------------------------------------]]
function GM:PlayerCanJoinTeam( ply, teamid )

	local TimeBetweenSwitches = GAMEMODE.SecondsBetweenTeamSwitches or 10
	if ( ply.LastTeamSwitch && RealTime()-ply.LastTeamSwitch < TimeBetweenSwitches ) then
		ply.LastTeamSwitch = ply.LastTeamSwitch + 1
		ply:ChatPrint( Format( "Please wait %i more seconds before trying to change team again", ( TimeBetweenSwitches - ( RealTime() - ply.LastTeamSwitch ) ) + 1 ) )
		return false
	end

	-- Already on this team!
	if ( ply:Team() == teamid ) then
		ply:ChatPrint( "You're already on that team" )
		return false
	end

	return true

end

--[[---------------------------------------------------------
	Name: gamemode:PlayerRequestTeam()
	Desc: Player wants to change team
-----------------------------------------------------------]]
function GM:PlayerRequestTeam( ply, teamid )

	-- No changing teams if not teambased!
	if ( !GAMEMODE.TeamBased ) then return end

	-- This team isn't joinable
	if ( !team.Joinable( teamid ) ) then
		ply:ChatPrint( "You can't join that team" )
	return end

	-- This team isn't joinable
	if ( !GAMEMODE:PlayerCanJoinTeam( ply, teamid ) ) then
		-- Messages here should be outputted by this function
	return end

	GAMEMODE:PlayerJoinTeam( ply, teamid )

end

--[[---------------------------------------------------------
	Name: gamemode:PlayerJoinTeam()
	Desc: Make player join this team
-----------------------------------------------------------]]
function GM:PlayerJoinTeam( ply, teamid )

	local iOldTeam = ply:Team()

	if ( ply:Alive() ) then
		if ( iOldTeam == TEAM_SPECTATOR || iOldTeam == TEAM_UNASSIGNED ) then
			ply:KillSilent()
		else
			ply:Kill()
		end
	end

	ply:SetTeam( teamid )
	ply.LastTeamSwitch = RealTime()

	GAMEMODE:OnPlayerChangedTeam( ply, iOldTeam, teamid )

end

--[[---------------------------------------------------------
	Name: gamemode:OnPlayerChangedTeam( ply, oldteam, newteam )
-----------------------------------------------------------]]
function GM:OnPlayerChangedTeam( ply, oldteam, newteam )

	-- Here's an immediate respawn thing by default. If you want to
	-- re-create something more like CS or some shit you could probably
	-- change to a spectator or something while dead.
	if ( newteam == TEAM_SPECTATOR ) then

		-- If we changed to spectator mode, respawn where we are
		local Pos = ply:EyePos()
		ply:Spawn()
		ply:SetPos( Pos )

	elseif ( oldteam == TEAM_SPECTATOR ) then

		-- If we're changing from spectator, join the game
		ply:Spawn()

	else

		-- If we're straight up changing teams just hang
		-- around until we're ready to respawn onto the
		-- team that we chose

	end

	PrintMessage( HUD_PRINTTALK, Format( "%s joined '%s'", ply:Nick(), team.GetName( newteam ) ) )

end

--[[---------------------------------------------------------
	Name: gamemode:PlayerSpray()
	Desc: Return true to prevent player spraying
-----------------------------------------------------------]]
function GM:PlayerSpray( ply )

	return false

end

--[[---------------------------------------------------------
	Name: gamemode:OnPlayerHitGround()
	Desc: Return true to disable default action
-----------------------------------------------------------]]
function GM:OnPlayerHitGround( ply, bInWater, bOnFloater, flFallSpeed )

	-- Apply damage and play collision sound here
	-- then return true to disable the default action
	--MsgN( ply, bInWater, bOnFloater, flFallSpeed )
	--return true

end

--[[---------------------------------------------------------
	Name: gamemode:GetFallDamage()
	Desc: return amount of damage to do due to fall
-----------------------------------------------------------]]
local mp_falldamage = GetConVar( "mp_falldamage" )

function GM:GetFallDamage( ply, flFallSpeed )

	if ( mp_falldamage:GetBool() ) then -- realistic fall damage is on
		return ( flFallSpeed - 526.5 ) * ( 100 / 396 ) -- the Source SDK value
	end

	return 10

end

--[[---------------------------------------------------------
	Name: gamemode:PlayerCanSeePlayersChat()
	Desc: Can this player see the other player's chat?
-----------------------------------------------------------]]
function GM:PlayerCanSeePlayersChat( strText, bTeamOnly, pListener, pSpeaker )

	if ( bTeamOnly ) then
		if ( !IsValid( pSpeaker ) || !IsValid( pListener ) ) then return false end
		if ( pListener:Team() != pSpeaker:Team() ) then return false end
	end

	return true

end

local sv_alltalk = GetConVar( "sv_alltalk" )

--[[---------------------------------------------------------
	Name: gamemode:PlayerCanHearPlayersVoice()
	Desc: Can this player see the other player's voice?
		Returns 2 bools.
		1. Can the player hear the other player
		2. Can they hear them spacially
-----------------------------------------------------------]]
function GM:PlayerCanHearPlayersVoice( pListener, pTalker )

	local alltalk = sv_alltalk:GetInt()
	if ( alltalk >= 1 ) then return true, alltalk == 2 end

	return pListener:Team() == pTalker:Team(), false

end

--[[---------------------------------------------------------
	Name: gamemode:NetworkIDValidated()
	Desc: Called when Steam has validated this as a valid player
-----------------------------------------------------------]]
function GM:NetworkIDValidated( name, steamid )

	-- MsgN( "GM:NetworkIDValidated", name, steamid )

end

--[[---------------------------------------------------------
	Name: gamemode:PlayerShouldTaunt( ply, actid )
-----------------------------------------------------------]]
function GM:PlayerShouldTaunt( ply, actid )

	-- The default behaviour is to always let them act
	-- Some gamemodes will obviously want to stop this for certain players by returning false
	return true

end

--[[---------------------------------------------------------
	Name: gamemode:PlayerStartTaunt( ply, actid, length )
-----------------------------------------------------------]]
function GM:PlayerStartTaunt( ply, actid, length )
end

--[[---------------------------------------------------------
	Name: gamemode:AllowPlayerPickup( ply, object )
-----------------------------------------------------------]]
function GM:AllowPlayerPickup( ply, object )

	-- Should the player be allowed to pick this object up (using ENTER)?
	-- If no then return false. Default is HELL YEAH

	return true

end

--[[---------------------------------------------------------
	Name: gamemode:PlayerDroppedWeapon()
	Desc: Player has dropped a weapon
-----------------------------------------------------------]]
function GM:PlayerDroppedWeapon( ply, weapon )
end

--[[---------------------------------------------------------
	These are buttons that the client is pressing. They're used
	in Sandbox mode to control things like wheels, thrusters etc.
-----------------------------------------------------------]]
function GM:PlayerButtonDown( ply, btn ) end
function GM:PlayerButtonUp( ply, btn ) end

concommand.Add( "changeteam", function( pl, cmd, args ) hook.Call( "PlayerRequestTeam", GAMEMODE, pl, tonumber( args[ 1 ] ) ) end )
