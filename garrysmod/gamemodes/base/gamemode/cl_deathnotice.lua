
local hud_deathnotice_time = CreateConVar( "hud_deathnotice_time", "6", FCVAR_REPLICATED, "Amount of time to show death notice" )

-- These are our kill icons
local Color_Icon = Color( 255, 80, 0, 255 )
local NPC_Color_Enemy = Color( 250, 50, 50, 255 )
local NPC_Color_Friendly = Color( 50, 200, 50, 255 )

killicon.AddFont( "prop_physics",		"HL2MPTypeDeath",	"9",	Color_Icon, 0.52 )
killicon.AddFont( "weapon_smg1",		"HL2MPTypeDeath",	"/",	Color_Icon, 0.55 )
killicon.AddFont( "weapon_357",			"HL2MPTypeDeath",	".",	Color_Icon, 0.55 )
killicon.AddFont( "weapon_ar2",			"HL2MPTypeDeath",	"2",	Color_Icon, 0.6 )
killicon.AddFont( "crossbow_bolt",		"HL2MPTypeDeath",	"1",	Color_Icon, 0.5 )
killicon.AddFont( "weapon_shotgun",		"HL2MPTypeDeath",	"0",	Color_Icon, 0.45 )
killicon.AddFont( "rpg_missile",		"HL2MPTypeDeath",	"3",	Color_Icon, 0.35 )
killicon.AddFont( "npc_grenade_frag",	"HL2MPTypeDeath",	"4",	Color_Icon, 0.56 )
killicon.AddFont( "weapon_pistol",		"HL2MPTypeDeath",	"-",	Color_Icon, 0.52 )
killicon.AddFont( "prop_combine_ball",	"HL2MPTypeDeath",	"8",	Color_Icon, 0.5 )
killicon.AddFont( "grenade_ar2",		"HL2MPTypeDeath",	"7",	Color_Icon, 0.35 )
killicon.AddFont( "weapon_stunstick",	"HL2MPTypeDeath",	"!",	Color_Icon, 0.6 )
killicon.AddFont( "npc_satchel",		"HL2MPTypeDeath",	"*",	Color_Icon, 0.53 )
killicon.AddAlias( "npc_tripmine", "npc_satchel" )
killicon.AddFont( "weapon_crowbar",		"HL2MPTypeDeath",	"6",	Color_Icon, 0.45 )
killicon.AddFont( "weapon_physcannon",	"HL2MPTypeDeath",	",",	Color_Icon, 0.55 )

-- Prop like objects get the prop kill icon
killicon.AddAlias( "prop_ragdoll", "prop_physics" )
killicon.AddAlias( "prop_physics_respawnable", "prop_physics" )
killicon.AddAlias( "func_physbox", "prop_physics" )
killicon.AddAlias( "func_physbox_multiplayer", "prop_physics" )
killicon.AddAlias( "trigger_vphysics_motion", "prop_physics" )
killicon.AddAlias( "func_movelinear", "prop_physics" )
killicon.AddAlias( "func_plat", "prop_physics" )
killicon.AddAlias( "func_platrot", "prop_physics" )
killicon.AddAlias( "func_pushable", "prop_physics" )
killicon.AddAlias( "func_rotating", "prop_physics" )
killicon.AddAlias( "func_rot_button", "prop_physics" )
killicon.AddAlias( "func_tracktrain", "prop_physics" )
killicon.AddAlias( "func_train", "prop_physics" )

-- Backwards compatiblity for addons
net.Receive( "PlayerKilledByPlayer", function()

	local victim	= net.ReadEntity()
	local inflictor	= net.ReadString()
	local attacker	= net.ReadEntity()

	if ( !IsValid( attacker ) ) then return end
	if ( !IsValid( victim ) ) then return end

	hook.Run( "AddDeathNotice", attacker:Name(), attacker:Team(), inflictor, victim:Name(), victim:Team(), 0 )

end )

net.Receive( "PlayerKilledSelf", function()

	local victim = net.ReadEntity()
	if ( !IsValid( victim ) ) then return end

	hook.Run( "AddDeathNotice", nil, 0, "suicide", victim:Name(), victim:Team(), 0 )

end )

net.Receive( "PlayerKilled", function()

	local victim = net.ReadEntity()
	if ( !IsValid( victim ) ) then return end

	local inflictor = net.ReadString()
	local attacker = net.ReadString()

	hook.Run( "AddDeathNotice", "#" .. attacker, -1, inflictor, victim:Name(), victim:Team(), 0 )

end )

net.Receive( "PlayerKilledNPC", function()

	local victimtype = net.ReadString()
	local inflictor = net.ReadString()
	local attacker = net.ReadEntity()

	--
	-- For some reason the killer isn't known to us, so don't proceed.
	--
	if ( !IsValid( attacker ) ) then return end

	hook.Run( "AddDeathNotice", attacker:Name(), attacker:Team(), inflictor, "#" .. victimtype, -1, 0 )

	local bIsLocalPlayer = ( IsValid( attacker ) && attacker == LocalPlayer() )

	local bIsEnemy = IsEnemyEntityName( victimtype )
	local bIsFriend = IsFriendEntityName( victimtype )

	if ( bIsLocalPlayer && bIsEnemy ) then
		achievements.IncBaddies()
	end

	if ( bIsLocalPlayer && bIsFriend ) then
		achievements.IncGoodies()
	end

	if ( bIsLocalPlayer && ( !bIsFriend && !bIsEnemy ) ) then
		achievements.IncBystander()
	end

end )

net.Receive( "NPCKilledNPC", function()

	local victim	= "#" .. net.ReadString()
	local inflictor	= net.ReadString()
	local attacker	= "#" .. net.ReadString()

	hook.Run( "AddDeathNotice", attacker, -1, inflictor, victim, -1, 0 )

end )

-- The new way
DEATH_NOTICE_FRIENDLY_VICTIM = 1
DEATH_NOTICE_FRIENDLY_ATTACKER = 2
--DEATH_NOTICE_HEADSHOT = 4
--DEATH_NOTICE_PENETRATION = 8
net.Receive( "DeathNoticeEvent", function()

	local attacker = nil
	local attackerType = net.ReadUInt( 2 )
	if ( attackerType == 1 ) then
		attacker = net.ReadString()
	elseif ( attackerType == 2 ) then
		attacker = net.ReadEntity()
	end

	local inflictor	= net.ReadString()

	local victim = nil
	local victimType = net.ReadUInt( 2 )
	if ( victimType == 1 ) then
		victim = net.ReadString()
	elseif ( victimType == 2 ) then
		victim = net.ReadEntity()
	end

	local flags = net.ReadUInt( 8 )

	local team_a = -1
	local team_v = -1
	if ( bit.band( flags, DEATH_NOTICE_FRIENDLY_VICTIM ) != 0 ) then team_v = -2 end
	if ( bit.band( flags, DEATH_NOTICE_FRIENDLY_ATTACKER ) != 0 ) then team_a = -2 end
	if ( isentity( attacker ) and attacker:IsValid() and attacker:IsPlayer() ) then team_a = attacker:Team() attacker = attacker:Name() end
	if ( isentity( victim ) and victim:IsValid() and victim:IsPlayer() ) then team_v = victim:Team() victim = victim:Name()  end

	hook.Run( "AddDeathNotice", attacker, team_a, inflictor, victim, team_v, flags )

end )

local Deaths = {}

local function getDeathColor( teamID, target )

	if ( teamID == -1 ) then
		return table.Copy( NPC_Color_Enemy )
	end

	if ( teamID == -2 ) then
		return table.Copy( NPC_Color_Friendly )
	end

	return table.Copy( team.GetColor( teamID ) )

end

--[[---------------------------------------------------------
	Name: gamemode:AddDeathNotice( Attacker, team1, Inflictor, Victim, team2, flags )
	Desc: Adds an death notice entry
-----------------------------------------------------------]]
function GM:AddDeathNotice( attacker, team1, inflictor, victim, team2, flags )

	if ( inflictor == "suicide" ) then attacker = nil end

	local Death = {}
	Death.time		= CurTime()

	Death.left		= attacker
	Death.right		= victim
	Death.icon		= inflictor
	Death.flags		= flags

	Death.color1	= getDeathColor( team1, Death.left )
	Death.color2	= getDeathColor( team2, Death.right )

	table.insert( Deaths, Death )

end

local function DrawDeath( x, y, death, time )

	local w, h = killicon.GetSize( death.icon )
	if ( !w or !h ) then return end

	local fadeout = ( death.time + time ) - CurTime()

	local alpha = math.Clamp( fadeout * 255, 0, 255 )
	death.color1.a = alpha
	death.color2.a = alpha

	-- Draw Icon
	killicon.Render( x - w / 2, y, death.icon, alpha )

	-- Draw KILLER
	if ( death.left ) then
		draw.SimpleText( death.left, "ChatFont", x - ( w / 2 ) - 16, y + h / 2, death.color1, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
	end

	-- Draw VICTIM
	draw.SimpleText( death.right, "ChatFont", x + ( w / 2 ) + 16, y + h / 2, death.color2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

	return math.ceil( y + h * 0.75 )

	-- Font killicons are too high when height corrected, and changing that is not backwards compatible
	--return math.ceil( y + math.max( h, 28 ) )

end


function GM:DrawDeathNotice( x, y )

	if ( GetConVarNumber( "cl_drawhud" ) == 0 ) then return end

	local time = hud_deathnotice_time:GetFloat()

	x = x * ScrW()
	y = y * ScrH()

	-- Draw
	for k, Death in ipairs( Deaths ) do

		if ( Death.time + time > CurTime() ) then

			if ( Death.lerp ) then
				x = x * 0.3 + Death.lerp.x * 0.7
				y = y * 0.3 + Death.lerp.y * 0.7
			end

			Death.lerp = Death.lerp or {}
			Death.lerp.x = x
			Death.lerp.y = y

			y = DrawDeath( math.floor( x ), math.floor( y ), Death, time )

		end

	end

	-- We want to maintain the order of the table so instead of removing
	-- expired entries one by one we will just clear the entire table
	-- once everything is expired.
	for k, Death in ipairs( Deaths ) do
		if ( Death.time + time > CurTime() ) then
			return
		end
	end

	Deaths = {}

end
