
local Category = ""

local function ADD_ITEM( name, class, offset, extras, classOverride )

	local base = { PrintName = name, ClassName = class, Category = Category, NormalOffset = offset or 32, DropToFloor = true, Author = "VALVe" }
	list.Set( "SpawnableEntities", classOverride or class, table.Merge( base, extras or {} ) )
	duplicator.Allow( class )

end

local function ADD_WEAPON( name, class, title )

	list.Set( "Weapon", class, { ClassName = class, PrintName = name, Category = Category, Author = "VALVe", Spawnable = true } )
	duplicator.Allow( class )

end

Category = "Half-Life 2"
-- Half-Life 2 (Ammo)
ADD_ITEM( "#AR2_ammo", "item_ammo_ar2", -8 )
ADD_ITEM( "#AR2_ammo_large", "item_ammo_ar2_large", -8 )

ADD_ITEM( "#Pistol_ammo", "item_ammo_pistol", -4 )
ADD_ITEM( "#Pistol_ammo_large", "item_ammo_pistol_large", -4 )

ADD_ITEM( "#357_ammo", "item_ammo_357", -4 )
ADD_ITEM( "#357_ammo_large", "item_ammo_357_large", -4 )

ADD_ITEM( "#SMG1_ammo", "item_ammo_smg1", -2 )
ADD_ITEM( "#SMG1_ammo_large", "item_ammo_smg1_large", -2 )

ADD_ITEM( "#SMG1_Grenade_ammo", "item_ammo_smg1_grenade", -10 )
ADD_ITEM( "#XBowBolt_ammo", "item_ammo_crossbow", -10 )
ADD_ITEM( "#Buckshot_ammo", "item_box_buckshot", -10 )
ADD_ITEM( "#AR2AltFire_ammo", "item_ammo_ar2_altfire", -2 )
ADD_ITEM( "#RPG_Round_ammo", "item_rpg_round", -10 )

-- Dynamic materials; gives player what he needs most ( health, shotgun ammo, suit energy, etc )
-- ADD_ITEM( "item_dynamic_resupply", "Dynamic Supplies", "Other" )

-- Half-Life 2 (Items)
ADD_ITEM( "#item_battery", "item_battery",  -4 )
ADD_ITEM( "#item_healthkit", "item_healthkit",  -8 )
ADD_ITEM( "#item_healthvial", "item_healthvial",  -4 )
ADD_ITEM( "#item_suitcharger", "item_suitcharger" )
ADD_ITEM( "#item_healthcharger", "item_healthcharger" )
ADD_ITEM( "#item_suit", "item_suit",  0 )

-- Half-Life 2 (Misc)
ADD_ITEM( "#prop_thumper", "prop_thumper" )
ADD_ITEM( "#combine_mine", "combine_mine",  -8 )
ADD_ITEM( "#npc_grenade_frag", "npc_grenade_frag",  -8 )
ADD_ITEM( "#grenade_helicopter", "grenade_helicopter",  4 )

-- Half-Life 2: Episode 2 (Misc)
if ( IsMounted( "ep2" ) ) then
	game.AddParticles( "particles/striderbuster.pcf" )
	ADD_ITEM( "#weapon_striderbuster", "weapon_striderbuster" )
end

-- Half-Life 2 (Weapons)
ADD_WEAPON( "#HL2_GravityGun", "weapon_physcannon" )
ADD_WEAPON( "#HL2_StunBaton", "weapon_stunstick" )
ADD_WEAPON( "#HL2_Grenade", "weapon_frag" )
ADD_WEAPON( "#HL2_Crossbow", "weapon_crossbow" )
ADD_WEAPON( "#HL2_Bugbait", "weapon_bugbait" )
ADD_WEAPON( "#HL2_RPG", "weapon_rpg" )
ADD_WEAPON( "#HL2_Crowbar", "weapon_crowbar" )
ADD_WEAPON( "#HL2_Shotgun", "weapon_shotgun" )
ADD_WEAPON( "#HL2_Pistol", "weapon_pistol" )
ADD_WEAPON( "#HL2_SLAM", "weapon_slam" )
ADD_WEAPON( "#HL2_SMG1", "weapon_smg1" )
ADD_WEAPON( "#HL2_Pulse_Rifle", "weapon_ar2" )
ADD_WEAPON( "#HL2_357Handgun", "weapon_357" )
ADD_WEAPON( "#HL2_AlyxGun", "weapon_alyxgun" )
ADD_WEAPON( "#HL2_Annabelle", "weapon_annabelle" )

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
	Category = "Half-Life: Source"

	-- Half-Life: Source (Weapons)
	ADD_WEAPON( "#HL1_Snarks", "weapon_snark", Category )
	ADD_WEAPON( "#HL1_HandGrenade", "weapon_handgrenade", Category )
	ADD_WEAPON( "#HL1_MP5", "weapon_mp5_hl1", Category )
	ADD_WEAPON( "#HL1_HornetGun", "weapon_hornetgun", Category )
	ADD_WEAPON( "#HL1_Satchel", "weapon_satchel", Category )
	ADD_WEAPON( "#HL1_Tripmines", "weapon_tripmine", Category )
	ADD_WEAPON( "#HL1_Crossbow", "weapon_crossbow_hl1", Category )
	ADD_WEAPON( "#HL1_357", "weapon_357_hl1",  true )
	ADD_WEAPON( "#HL1_RPGLauncher", "weapon_rpg_hl1", Category )
	ADD_WEAPON( "#HL1_Shotgun", "weapon_shotgun_hl1",  true )
	ADD_WEAPON( "#HL1_Glock", "weapon_glock_hl1",  true )
	ADD_WEAPON( "#HL1_TauCannon", "weapon_gauss", Category )
	ADD_WEAPON( "#HL1_GluonGun", "weapon_egon", Category )
	ADD_WEAPON( "#HL1_Crowbar", "weapon_crowbar_hl1", Category )

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
	ADD_ITEM( "#XBowBoltHL1_ammo", "ammo_crossbow",  0 )
	ADD_ITEM( "#Uranium_ammo", "ammo_gaussclip",  0 )
	ADD_ITEM( "#ammo_glockclip", "ammo_glockclip",  0 )
	ADD_ITEM( "#ammo_mp5clip", "ammo_mp5clip",  0 )
	ADD_ITEM( "#ammo_9mmbox", "ammo_9mmbox",  0 )
	ADD_ITEM( "#MP5_Grenade_ammo", "ammo_mp5grenades",  0 )
	ADD_ITEM( "#357Round_ammo", "ammo_357",  0 )
	ADD_ITEM( "#RPG_Rocket_ammo", "ammo_rpgclip",  0 )
	ADD_ITEM( "#ammo_buckshot", "ammo_buckshot",  0 )
	-- ADD_ITEM( "#MP5_Grenade_ammo", "ammo_argrenades",  0 )
	-- ADD_ITEM( "#ammo_mp5clip", "ammo_9mmclip",  0 )
	-- ADD_ITEM( "#ammo_mp5clip", "ammo_9mmar",  0 )
	-- ADD_ITEM( "#Uranium_ammo", "ammo_egonclip",  0 )
end

ADD_WEAPON( "#GMOD_Physgun", "weapon_physgun", "Other", false, true, "Facepunch" )
