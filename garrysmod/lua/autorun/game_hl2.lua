local spawnableEntities = list.GetForEdit( "SpawnableEntities" )
local npcWeapons = list.GetForEdit( "NPCUsableWeapons" )
local playerWeapons = list.GetForEdit( "Weapon" )
local Allow = duplicator.Allow

local function ADD_ITEM( className, title, category, npcAllowed, spawnable, author )
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

local function ADD_WEAPON( className, title, category, offset, author )
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

Category = "Half-Life 2"
-- Half-Life 2 (Ammo)
ADD_ITEM( "item_ammo_ar2", "#AR2_ammo", Category, -8 )
ADD_ITEM( "item_ammo_ar2_large", "#AR2_ammo_large", Category, -8 )

ADD_ITEM( "item_ammo_pistol", "#Pistol_ammo", Category, -4 )
ADD_ITEM( "item_ammo_pistol_large", "#Pistol_ammo_large", Category, -4 )

ADD_ITEM( "item_ammo_357", "#357_ammo", Category, -4 )
ADD_ITEM( "item_ammo_357_large", "#357_ammo_large", Category, -4 )

ADD_ITEM( "item_ammo_smg1", "#SMG1_ammo", Category, -2 )
ADD_ITEM( "item_ammo_smg1_large", "#SMG1_ammo_large", Category, -2 )

ADD_ITEM( "item_ammo_smg1_grenade", "#SMG1_Grenade_ammo", Category, -10 )
ADD_ITEM( "item_ammo_crossbow", "#XBowBolt_ammo", Category, -10 )
ADD_ITEM( "item_box_buckshot", "#Buckshot_ammo", Category, -10 )
ADD_ITEM( "item_ammo_ar2_altfire", "#AR2AltFire_ammo", Category, -2 )
ADD_ITEM( "item_rpg_round", "#RPG_Round_ammo", Category, -10 )

-- Dynamic materials; gives player what he needs most ( health, shotgun ammo, suit energy, etc )
-- ADD_ITEM( "item_dynamic_resupply", "Dynamic Supplies", "Other" )

-- Half-Life 2 (Items)
ADD_ITEM( "item_battery", "#item_battery", Category, -4 )
ADD_ITEM( "item_healthkit", "#item_healthkit", Category, -8 )
ADD_ITEM( "item_healthvial", "#item_healthvial", Category, -4 )
ADD_ITEM( "item_suitcharger", "#item_suitcharger", Category )
ADD_ITEM( "item_healthcharger", "#item_healthcharger", Category )
ADD_ITEM( "item_suit", "#item_suit", Category, 0 )

-- Half-Life 2 (Misc)
ADD_ITEM( "prop_thumper", "#prop_thumper", Category )
ADD_ITEM( "combine_mine", "#combine_mine", Category, -8 )
ADD_ITEM( "npc_grenade_frag", "#npc_grenade_frag", Category, -8 )
ADD_ITEM( "grenade_helicopter", "#grenade_helicopter", Category, 4 )

-- Half-Life 2: Episode 2 (Misc)
if ( IsMounted( "ep2" ) ) then
	game.AddParticles( "particles/striderbuster.pcf" )
	ADD_ITEM( "weapon_striderbuster", "#weapon_striderbuster", Category )
end

-- Half-Life 2 (Weapons)
ADD_WEAPON( "weapon_physcannon", "#HL2_GravityGun", Category, false )
ADD_WEAPON( "weapon_stunstick", "#HL2_StunBaton", Category, true )
ADD_WEAPON( "weapon_frag", "#HL2_Grenade", Category, false )
ADD_WEAPON( "weapon_crossbow", "#HL2_Crossbow", Category, true )
ADD_WEAPON( "weapon_bugbait", "#HL2_Bugbait", Category, false )
ADD_WEAPON( "weapon_rpg", "#HL2_RPG", Category, true )
ADD_WEAPON( "weapon_crowbar", "#HL2_Crowbar", Category, true )
ADD_WEAPON( "weapon_shotgun", "#HL2_Shotgun", Category, true )
ADD_WEAPON( "weapon_pistol", "#HL2_Pistol", Category, true )
ADD_WEAPON( "weapon_slam", "#HL2_SLAM", Category, false )
ADD_WEAPON( "weapon_smg1", "#HL2_SMG1", Category, true )
ADD_WEAPON( "weapon_ar2", "#HL2_Pulse_Rifle", Category, true )
ADD_WEAPON( "weapon_357", "#HL2_357Handgun", Category, true )
ADD_WEAPON( "weapon_alyxgun", "#HL2_AlyxGun", Category, true, false )
ADD_WEAPON( "weapon_annabelle", "#HL2_Annabelle", Category, true, false )

-- NPC Weapons
list.Add( "NPCUsableWeapons", { class = "weapon_pistol", title = "#weapon_pistol", category = Category } )
list.Add( "NPCUsableWeapons", { class = "weapon_357", title = "#weapon_357", category = Category } )
list.Add( "NPCUsableWeapons", { class = "weapon_smg1", title = "#weapon_smg1", category = Category } )
list.Add( "NPCUsableWeapons", { class = "weapon_shotgun", title = "#weapon_shotgun", category = Category } )
list.Add( "NPCUsableWeapons", { class = "weapon_ar2", title = "#weapon_ar2", category = Category } )
list.Add( "NPCUsableWeapons", { class = "weapon_rpg", title = "#weapon_rpg", category = Category } )
list.Add( "NPCUsableWeapons", { class = "weapon_alyxgun", title = "#weapon_alyxgun", category = Category } )
list.Add( "NPCUsableWeapons", { class = "weapon_annabelle", title = "#weapon_annabelle", category = Category } )
list.Add( "NPCUsableWeapons", { class = "weapon_crossbow", title = "#weapon_crossbow", category = Category } )
list.Add( "NPCUsableWeapons", { class = "weapon_stunstick", title = "#weapon_stunstick", category = Category } )
list.Add( "NPCUsableWeapons", { class = "weapon_crowbar", title = "#weapon_crowbar", category = Category } )

if ( IsMounted( "hl1" ) or IsMounted( "hl1mp" ) ) then
	category = "Half-Life: Source"

	-- Half-Life: Source (Weapons)
	ADD_WEAPON( "weapon_snark", "#HL1_Snarks", Category )
	ADD_WEAPON( "weapon_handgrenade", "#HL1_HandGrenade", Category )
	ADD_WEAPON( "weapon_mp5_hl1", "#HL1_MP5", Category )
	ADD_WEAPON( "weapon_hornetgun", "#HL1_HornetGun", Category )
	ADD_WEAPON( "weapon_satchel", "#HL1_Satchel", Category )
	ADD_WEAPON( "weapon_tripmine", "#HL1_Tripmines", Category )
	ADD_WEAPON( "weapon_crossbow_hl1", "#HL1_Crossbow", Category )
	ADD_WEAPON( "weapon_357_hl1", "#HL1_357", Category, true )
	ADD_WEAPON( "weapon_rpg_hl1", "#HL1_RPGLauncher", Category )
	ADD_WEAPON( "weapon_shotgun_hl1", "#HL1_Shotgun", Category, true )
	ADD_WEAPON( "weapon_glock_hl1", "#HL1_Glock", Category, true )
	ADD_WEAPON( "weapon_gauss", "#HL1_TauCannon", Category )
	ADD_WEAPON( "weapon_egon", "#HL1_GluonGun", Category )
	ADD_WEAPON( "weapon_crowbar_hl1", "#HL1_Crowbar", Category )

list.Add( "NPCUsableWeapons", { class = "weapon_357_hl1", title = "#weapon_357_hl1", category = Category } )
	list.Add( "NPCUsableWeapons", { class = "weapon_glock_hl1", title = "#weapon_glock_hl1", category = Category } )
	list.Add( "NPCUsableWeapons", { class = "weapon_shotgun_hl1", title = "#weapon_shotgun_hl1", category = Category } )
end

if ( IsMounted( "portal" ) ) then
	Category = "Portal"

	ADD_ITEM( "Curiosity Core", "prop_glados_core", 32, { KeyValues = { CoreType = 0, DelayBetweenLines = 0.4 } }, "prop_glados_core" )
	ADD_ITEM( "Anger Core", "prop_glados_core", 32, { KeyValues = { CoreType = 1, DelayBetweenLines = 0.1 } }, "prop_glados_core_anger" )
	ADD_ITEM( "Intelligence Core", "prop_glados_core", 32, { KeyValues = { CoreType = 2, DelayBetweenLines = 0.1 } }, "prop_glados_core_crazy" )
	ADD_ITEM( "Morality Core", "prop_glados_core", 32, { KeyValues = { CoreType = 3 } }, "prop_glados_core_morality" )

	-- Half-Life: Source (Ammo)
	ADD_ITEM( "ammo_crossbow", "#XBowBoltHL1_ammo", Category, 0 )
	ADD_ITEM( "ammo_gaussclip", "#Uranium_ammo", Category, 0 )
	ADD_ITEM( "ammo_glockclip", "#ammo_glockclip", Category, 0 )
	ADD_ITEM( "ammo_mp5clip", "#ammo_mp5clip", Category, 0 )
	ADD_ITEM( "ammo_9mmbox", "#ammo_9mmbox", Category, 0 )
	ADD_ITEM( "ammo_mp5grenades", "#MP5_Grenade_ammo", Category, 0 )
	ADD_ITEM( "ammo_357", "#357Round_ammo", Category, 0 )
	ADD_ITEM( "ammo_rpgclip", "#RPG_Rocket_ammo", Category, 0 )
	ADD_ITEM( "ammo_buckshot", "#ammo_buckshot", Category, 0 )
	-- ADD_ITEM( "ammo_argrenades", "#MP5_Grenade_ammo", Category, 0 )
	-- ADD_ITEM( "ammo_9mmclip", "#ammo_mp5clip", Category, 0 )
	-- ADD_ITEM( "ammo_9mmar", "#ammo_mp5clip", Category, 0 )
	-- ADD_ITEM( "ammo_egonclip", "#Uranium_ammo", Category, 0 )
end

ADD_WEAPON( "weapon_physgun", "#GMOD_Physgun", "Other", false, true, "Facepunch" )
