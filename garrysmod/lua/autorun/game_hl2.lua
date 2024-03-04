local spawnableEntities = list.GetForEdit( "SpawnableEntities" )
local npcWeapons = list.GetForEdit( "NPCUsableWeapons" )
local playerWeapons = list.GetForEdit( "Weapon" )
local Allow = duplicator.Allow

local function AddWeapon( className, title, category, npcAllowed, spawnable, author )
	local weapon = playerWeapons[ className ]
	if ( weapon == nil ) then
		weapon = { ClassName = className }
		playerWeapons[ className ] = weapon
	end

	weapon.Spawnable = spawnable ~= false
	weapon.Author = author or "VALVe"
	weapon.Category = category
	weapon.PrintName = title
	Allow( className )

	if npcAllowed then
		for index = 1, #npcWeapons do
			local data = npcWeapons[ index ]
			if ( data and data.class == className ) then
				data.category = category
				data.title = title
				return
			end
		end

		npcWeapons[ #npcWeapons + 1 ] = {
			class = className,
			category = category,
			title = title
		}
	end
end

local function AddEntity( className, title, category, offset, author )
	local entity = spawnableEntities[ className ]
	if ( entity == nil ) then
		entity = { ClassName = className, DropToFloor = true }
		spawnableEntities[ className ] = entity
	end

	entity.NormalOffset = offset or 32
	entity.Author = author or "VALVe"
	entity.Category = category
	entity.PrintName = title
	Allow( className )
end

local category = "Half-Life 2"

-- Half-Life 2 (Ammo)
AddEntity( "item_ammo_ar2", "#AR2_ammo", category, -8 )
AddEntity( "item_ammo_ar2_large", "#AR2_ammo_large", category, -8 )

AddEntity( "item_ammo_pistol", "#Pistol_ammo", category, -4 )
AddEntity( "item_ammo_pistol_large", "#Pistol_ammo_large", category, -4 )

AddEntity( "item_ammo_357", "#357_ammo", category, -4 )
AddEntity( "item_ammo_357_large", "#357_ammo_large", category, -4 )

AddEntity( "item_ammo_smg1", "#SMG1_ammo", category, -2 )
AddEntity( "item_ammo_smg1_large", "#SMG1_ammo_large", category, -2 )

AddEntity( "item_ammo_smg1_grenade", "#SMG1_Grenade_ammo", category, -10 )
AddEntity( "item_ammo_crossbow", "#XBowBolt_ammo", category, -10 )
AddEntity( "item_box_buckshot", "#Buckshot_ammo", category, -10 )
AddEntity( "item_ammo_ar2_altfire", "#AR2AltFire_ammo", category, -2 )
AddEntity( "item_rpg_round", "#RPG_Round_ammo", category, -10 )

-- Dynamic materials; gives player what he needs most ( health, shotgun ammo, suit energy, etc )
-- AddEntity( "item_dynamic_resupply", "Dynamic Supplies", "Other" )

-- Half-Life 2 (Items)
AddEntity( "item_battery", "#item_battery", category, -4 )
AddEntity( "item_healthkit", "#item_healthkit", category, -8 )
AddEntity( "item_healthvial", "#item_healthvial", category, -4 )
AddEntity( "item_suitcharger", "#item_suitcharger", category )
AddEntity( "item_healthcharger", "#item_healthcharger", category )
AddEntity( "item_suit", "#item_suit", category, 0 )

-- Half-Life 2 (Misc)
AddEntity( "prop_thumper", "#prop_thumper", category )
AddEntity( "combine_mine", "#combine_mine", category, -8 )
AddEntity( "npc_grenade_frag", "#npc_grenade_frag", category, -8 )
AddEntity( "grenade_helicopter", "#grenade_helicopter", category, 4 )

-- Half-Life 2: Episode 2 (Misc)
if ( IsMounted( "ep2" ) ) then
	game.AddParticles( "particles/striderbuster.pcf" )
	AddEntity( "weapon_striderbuster", "#weapon_striderbuster", category )
end

-- Half-Life 2 (Weapons)
AddWeapon( "weapon_physcannon", "#HL2_GravityGun", category, false )
AddWeapon( "weapon_stunstick", "#HL2_StunBaton", category, true )
AddWeapon( "weapon_frag", "#HL2_Grenade", category, false )
AddWeapon( "weapon_crossbow", "#HL2_Crossbow", category, true )
AddWeapon( "weapon_bugbait", "#HL2_Bugbait", category, false )
AddWeapon( "weapon_rpg", "#HL2_RPG", category, true )
AddWeapon( "weapon_crowbar", "#HL2_Crowbar", category, true )
AddWeapon( "weapon_shotgun", "#HL2_Shotgun", category, true )
AddWeapon( "weapon_pistol", "#HL2_Pistol", category, true )
AddWeapon( "weapon_slam", "#HL2_SLAM", category, false )
AddWeapon( "weapon_smg1", "#HL2_SMG1", category, true )
AddWeapon( "weapon_ar2", "#HL2_Pulse_Rifle", category, true )
AddWeapon( "weapon_357", "#HL2_357Handgun", category, true )
AddWeapon( "weapon_alyxgun", "#HL2_AlyxGun", category, true, false )
AddWeapon( "weapon_annabelle", "#HL2_Annabelle", category, true, false )

if ( IsMounted( "hl1" ) or IsMounted( "hl1mp" ) ) then
	category = "Half-Life: Source"

	-- Half-Life: Source (Weapons)
	AddWeapon( "weapon_snark", "#HL1_Snarks", category )
	AddWeapon( "weapon_handgrenade", "#HL1_HandGrenade", category )
	AddWeapon( "weapon_mp5_hl1", "#HL1_MP5", category )
	AddWeapon( "weapon_hornetgun", "#HL1_HornetGun", category )
	AddWeapon( "weapon_satchel", "#HL1_Satchel", category )
	AddWeapon( "weapon_tripmine", "#HL1_Tripmines", category )
	AddWeapon( "weapon_crossbow_hl1", "#HL1_Crossbow", category )
	AddWeapon( "weapon_357_hl1", "#HL1_357", category, true )
	AddWeapon( "weapon_rpg_hl1", "#HL1_RPGLauncher", category )
	AddWeapon( "weapon_shotgun_hl1", "#HL1_Shotgun", category, true )
	AddWeapon( "weapon_glock_hl1", "#HL1_Glock", category, true )
	AddWeapon( "weapon_gauss", "#HL1_TauCannon", category )
	AddWeapon( "weapon_egon", "#HL1_GluonGun", category )
	AddWeapon( "weapon_crowbar_hl1", "#HL1_Crowbar", category )

	-- Half-Life: Source (Ammo)
	AddEntity( "ammo_crossbow", "#XBowBoltHL1_ammo", category, 0 )
	AddEntity( "ammo_gaussclip", "#Uranium_ammo", category, 0 )
	AddEntity( "ammo_glockclip", "#ammo_glockclip", category, 0 )
	AddEntity( "ammo_mp5clip", "#ammo_mp5clip", category, 0 )
	AddEntity( "ammo_9mmbox", "#ammo_9mmbox", category, 0 )
	AddEntity( "ammo_mp5grenades", "#MP5_Grenade_ammo", category, 0 )
	AddEntity( "ammo_357", "#357Round_ammo", category, 0 )
	AddEntity( "ammo_rpgclip", "#RPG_Rocket_ammo", category, 0 )
	AddEntity( "ammo_buckshot", "#ammo_buckshot", category, 0 )
	-- AddEntity( "ammo_argrenades", "#MP5_Grenade_ammo", category, 0 )
	-- AddEntity( "ammo_9mmclip", "#ammo_mp5clip", category, 0 )
	-- AddEntity( "ammo_9mmar", "#ammo_mp5clip", category, 0 )
	-- AddEntity( "ammo_egonclip", "#Uranium_ammo", category, 0 )
end

AddWeapon( "weapon_physgun", "#GMOD_Physgun", "Other", false, true, "Facepunch" )
