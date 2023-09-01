
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

		if ( !attacker ) then
			net.WriteUInt( 0, 2 )
		elseif ( isstring( attacker ) ) then
			net.WriteUInt( 1, 2 )
			net.WriteString( attacker )
		elseif ( IsValid( attacker ) ) then
			net.WriteUInt( 2, 2 )
			net.WriteEntity( attacker )
		end

		net.WriteString( inflictor )

		if ( !victim ) then
			net.WriteUInt( 0, 2 )
		elseif ( isstring( victim ) ) then
			net.WriteUInt( 1, 2 )
			net.WriteString( victim )
		elseif ( IsValid( victim ) ) then
			net.WriteUInt( 2, 2 )
			net.WriteEntity( victim )
		end

		net.WriteUInt( flags, 8 )

	net.Broadcast()

end

function GM:GetDeathNoticeEntityName( ent )

	-- Some specific HL2 NPCs, just for fun
	-- TODO: Localization strings?
	if ( ent:GetClass() == "npc_citizen" ) then
		if ( ent:GetName() == "griggs" ) then return "Griggs" end
		if ( ent:GetName() == "sheckley" ) then return "Sheckley" end
		if ( ent:GetName() == "tobias" ) then return "Laszlo" end
		if ( ent:GetName() == "stanley" ) then return "Sandy" end

		if ( ent:GetModel() == "models/odessa.mdl" ) then return "Odessa Cubbage" end
	end

	-- Custom vehicle and NPC names
	if ( ent:IsVehicle() and ent.VehicleTable and ent.VehicleTable.Name ) then
		return ent.VehicleTable.Name
	end
	if ( ent:IsNPC() and ent.NPCTable and ent.NPCTable.Name ) then
		return ent.NPCTable.Name
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
	if ( ent:GetClass() == "npc_bullseye" || ent:GetClass() == "npc_launcher" ) then return end

	-- If killed by trigger_hurt, act as if NPC killed itself
	if ( IsValid( attacker ) && attacker:GetClass() == "trigger_hurt" ) then attacker = ent end

	-- NPC got run over..
	if ( IsValid( attacker ) && attacker:IsVehicle() && IsValid( attacker:GetDriver() ) ) then
		attacker = attacker:GetDriver()
	end

	if ( !IsValid( inflictor ) && IsValid( attacker ) ) then
		inflictor = attacker
	end

	-- Convert the inflictor to the weapon that they're holding if we can.
	if ( IsValid( inflictor ) && attacker == inflictor && ( inflictor:IsPlayer() || inflictor:IsNPC() ) ) then

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
	if ( IsValid( Entity( 1 ) ) and ent:IsNPC() and ent:Disposition( Entity( 1 ) ) != D_HT ) then flags = flags + DEATH_NOTICE_FRIENDLY_VICTIM end
	if ( IsValid( Entity( 1 ) ) and AttackerClass:IsNPC() and AttackerClass:Disposition( Entity( 1 ) ) != D_HT ) then flags = flags + DEATH_NOTICE_FRIENDLY_ATTACKER end

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
	if ( hitgroup == HITGROUP_LEFTARM ||
		 hitgroup == HITGROUP_RIGHTARM ||
		 hitgroup == HITGROUP_LEFTLEG ||
		 hitgroup == HITGROUP_RIGHTLEG ||
		 hitgroup == HITGROUP_GEAR ) then

		dmginfo:ScaleDamage( 0.25 )

	end

end
