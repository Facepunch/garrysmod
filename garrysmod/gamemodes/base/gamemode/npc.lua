
-- Backwards compatibility with addons
util.AddNetworkString( "PlayerKilledNPC" )
util.AddNetworkString( "NPCKilledNPC" )
util.AddNetworkString( "PlayerKilled" )
util.AddNetworkString( "PlayerKilledSelf" )
util.AddNetworkString( "PlayerKilledByPlayer" )

-- New way
util.AddNetworkString( "DeathNoticeEvent" )

DEATH_NOTICE_FRIENDLY_VICTIM = 1
DEATH_NOTICE_FRIENDLY_ATTACKER = 2
--DEATH_NOTICE_HEADSHOT = 4
--DEATH_NOTICE_PENETRATION = 8
function GM:SendDeathNotice( attacker, inflictor, victim, flags )

	net.Start( "DeathNoticeEvent" )

		if ( isstring( attacker ) ) then
			net.WriteUInt( 1, 2 )
			net.WriteString( attacker:sub( 0, 512 ) )
		elseif ( IsValid( attacker ) ) then
			net.WriteUInt( 2, 2 )
			net.WriteEntity( attacker )
		else
			-- TODO: game.GetWorld will be "written" here, because its not IsValid. Make it write a separate type?
			net.WriteUInt( 0, 2 )
		end

		if ( isstring( inflictor ) ) then
			net.WriteString( inflictor:sub( 0, 512 ) )
		else
			-- Should never really reach here..
			net.WriteString( "" )
		end

		if ( isstring( victim ) ) then
			net.WriteUInt( 1, 2 )
			net.WriteString( victim:sub( 0, 512 ) )
		elseif ( IsValid( victim ) ) then
			net.WriteUInt( 2, 2 )
			net.WriteEntity( victim )
		else
			net.WriteUInt( 0, 2 )
		end

		net.WriteUInt( flags, 8 )

	net.Broadcast()

end

function GM:GetDeathNoticeEntityName( ent )

	if ( isstring( ent ) ) then return ent end
	if ( !IsValid( ent ) ) then return nil end

	-- Some specific HL2 NPCs, just for fun
	if ( ent:GetClass() == "npc_citizen" ) then
		if ( ent:GetName() == "griggs" ) then return "#npc_citizen_griggs" end
		if ( ent:GetName() == "sheckley" ) then return "#npc_citizen_sheckley" end
		if ( ent:GetName() == "tobias" ) then return "#npc_citizen_laszlo" end
		if ( ent:GetName() == "stanley" ) then return "#npc_citizen_sandy" end
	end
	if ( ent:GetClass() == "npc_sniper" and ( ent:GetName() == "alyx_sniper" || ent:GetName() == "sniper_alyx" ) ) then return "#npc_alyx" end

	-- Custom vehicle and NPC names from spawnmenu
	if ( ent:IsVehicle() ) then
		local vehTable = list.GetEntry( "Vehicles", ent.VehicleName )
		if ( vehTable and vehTable.Name ) then return vehTable.Name end
	elseif ( ent:IsNPC() ) then
		local npcTable = list.GetEntry( "NPC", ent.NPCName )
		if ( npcTable and npcTable.Name ) then return npcTable.Name end
	end

	if ( ent:GetClass() == "npc_antlion" and ent:GetModel() == "models/antlion_worker.mdl" ) then
		return list.GetEntry( "NPC", "npc_antlion_worker" ).Name
	end

	-- Fallback to old behavior
	return "#" .. ent:GetClass()

end

--[[---------------------------------------------------------
   Name: gamemode:OnNPCKilled( entity, attacker, inflictor )
   Desc: The NPC has died
-----------------------------------------------------------]]
function GM:OnNPCKilled( ent, attacker, inflictor )

	-- Don't spam the killfeed with scripted stuff
	if ( ent:GetClass() == "npc_bullseye" or ent:GetClass() == "npc_launcher" ) then return end

	-- If killed by trigger_hurt, act as if NPC killed itself
	if ( IsValid( attacker ) and attacker:GetClass() == "trigger_hurt" ) then attacker = ent end

	-- NPC got run over..
	if ( IsValid( attacker ) and attacker:IsVehicle() and IsValid( attacker:GetDriver() ) ) then
		attacker = attacker:GetDriver()
	end

	if ( !IsValid( inflictor ) and IsValid( attacker ) ) then
		inflictor = attacker
	end

	-- Convert the inflictor to the weapon that they're holding if we can.
	if ( IsValid( inflictor ) and attacker == inflictor and ( inflictor:IsPlayer() or inflictor:IsNPC() ) ) then

		inflictor = inflictor:GetActiveWeapon()
		if ( !IsValid( attacker ) ) then inflictor = attacker end

	end

	local InflictorClass = "worldspawn"
	local AttackerClass = game.GetWorld()

	if ( IsValid( inflictor ) ) then InflictorClass = inflictor:GetClass() end
	if ( IsValid( attacker ) ) then

		AttackerClass = attacker

		-- If there is no valid inflictor, use the attacker (i.e. manhacks)
		if ( !IsValid( inflictor ) ) then InflictorClass = attacker:GetClass() end

		if ( attacker:IsPlayer() ) then

			local flags = 0
			if ( ent:IsNPC() and ent:Disposition( attacker ) != D_HT ) then flags = flags + DEATH_NOTICE_FRIENDLY_VICTIM end

			self:SendDeathNotice( attacker, InflictorClass, self:GetDeathNoticeEntityName( ent ), flags )

			return
		end

	end

	-- Floor turret got knocked over
	if ( ent:GetClass() == "npc_turret_floor" ) then AttackerClass = ent end

	-- It was NPC suicide..
	if ( ent == AttackerClass ) then InflictorClass = "suicide" end

	local flags = 0
	if ( IsValid( Entity( 1 ) ) and ent:IsNPC() and ent:Disposition( Entity( 1 ) ) == D_LI ) then flags = flags + DEATH_NOTICE_FRIENDLY_VICTIM end
	if ( IsValid( Entity( 1 ) ) and AttackerClass:IsNPC() and AttackerClass:Disposition( Entity( 1 ) ) == D_LI ) then flags = flags + DEATH_NOTICE_FRIENDLY_ATTACKER end

	self:SendDeathNotice( self:GetDeathNoticeEntityName( AttackerClass ), InflictorClass, self:GetDeathNoticeEntityName( ent ), flags )

end

--[[---------------------------------------------------------
   Name: gamemode:ScaleNPCDamage( ply, hitgroup, dmginfo )
   Desc: Scale the damage based on being shot in a hitbox
-----------------------------------------------------------]]
function GM:ScaleNPCDamage( npc, hitgroup, dmginfo )

	-- More damage if we're shot in the head
	if ( hitgroup == HITGROUP_HEAD ) then

		dmginfo:ScaleDamage( 2 )

	end

	-- Less damage if we're shot in the arms or legs
	if ( hitgroup == HITGROUP_LEFTARM or
		 hitgroup == HITGROUP_RIGHTARM or
		 hitgroup == HITGROUP_LEFTLEG or
		 hitgroup == HITGROUP_RIGHTLEG or
		 hitgroup == HITGROUP_GEAR ) then

		dmginfo:ScaleDamage( 0.25 )

	end

end
