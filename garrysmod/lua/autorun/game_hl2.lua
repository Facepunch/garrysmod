
local Category = ""

local function ADD_ITEM( name, class )

	list.Set( "SpawnableEntities", class, { PrintName = name, ClassName = class, Category = Category, NormalOffset = 32, DropToFloor = true, Author = "VALVe" } )
	duplicator.Allow( class )

end

local function ADD_WEAPON( name, class )

	list.Set( "Weapon", class, { ClassName = class, PrintName = name, Category = Category, Author = "VALVe", Spawnable = true } )
	duplicator.Allow( class )

end

Category = "Half-Life 2"

-- Ammo
ADD_ITEM( "AR2 Ammo",			"item_ammo_ar2" )
ADD_ITEM( "Pistol Ammo",		"item_ammo_pistol" )
ADD_ITEM( "Shotgun Ammo",		"item_box_buckshot" )
ADD_ITEM( "357 Ammo",			"item_ammo_357" )
ADD_ITEM( "SMG Ammo",			"item_ammo_smg1" )
ADD_ITEM( "Combine Balls",		"item_ammo_ar2_altfire" )
ADD_ITEM( "Crossbow Bolts",		"item_ammo_crossbow" )
ADD_ITEM( "SMG Grenade",		"item_ammo_smg1_grenade" )
ADD_ITEM( "RPG",				"item_rpg_round" )

-- Items
ADD_ITEM( "Suit Battery",		"item_battery" )
ADD_ITEM( "Health Vial",		"item_healthvial" )
ADD_ITEM( "Health Kit",			"item_healthkit" )
ADD_ITEM( "Suit Charger",		"item_suitcharger" )
ADD_ITEM( "Health Charger",		"item_healthcharger" )
ADD_ITEM( "Suit",				"item_suit" )

ADD_ITEM( "Thumper",			"prop_thumper" )
ADD_ITEM( "Combine Mine",		"combine_mine" )
ADD_ITEM( "Helicopter Grenade",	"grenade_helicopter" )
ADD_ITEM( "Zombine Grenade",	"npc_grenade_frag" )

if ( IsMounted( "ep2" ) ) then
	game.AddParticles( "particles/striderbuster.pcf" )
	ADD_ITEM( "Magnusson", "weapon_striderbuster" )
end

-- Weapons
ADD_WEAPON( "357",				"weapon_357" )
--ADD_WEAPON( "Alyx Gun",			"weapon_alyxgun" )
--ADD_WEAPON( "Annabelle",		"weapon_annabelle" )
ADD_WEAPON( "AR2",				"weapon_ar2" )
ADD_WEAPON( "Bug Bait",			"weapon_bugbait" )
ADD_WEAPON( "Crossbow",			"weapon_crossbow" )
ADD_WEAPON( "Crowbar",			"weapon_crowbar" )
ADD_WEAPON( "Gravity Gun",		"weapon_physcannon" )
ADD_WEAPON( "Frag Grenade",		"weapon_frag" )
ADD_WEAPON( "Pistol",			"weapon_pistol" )
ADD_WEAPON( "RPG Launcher",		"weapon_rpg" )
ADD_WEAPON( "Shotgun",			"weapon_shotgun" )
ADD_WEAPON( "SLAM",				"weapon_slam" )
ADD_WEAPON( "SMG",				"weapon_smg1" )
ADD_WEAPON( "Stunstick",		"weapon_stunstick" )

Category = "Other"
ADD_WEAPON( "Physics Gun",		"weapon_physgun" )

-- NPC Weapons
list.Add( "NPCUsableWeapons", { class = "weapon_stunstick",	title = "Stunstick" } )
list.Add( "NPCUsableWeapons", { class = "weapon_crowbar",	title = "Crowbar" } )
list.Add( "NPCUsableWeapons", { class = "weapon_pistol",	title = "Pistol" } )
list.Add( "NPCUsableWeapons", { class = "weapon_alyxgun",	title = "Alyx Gun" } )
list.Add( "NPCUsableWeapons", { class = "weapon_357",		title = "357" } )
list.Add( "NPCUsableWeapons", { class = "weapon_smg1",		title = "SMG" } )
list.Add( "NPCUsableWeapons", { class = "weapon_ar2",		title = "AR2" } )
list.Add( "NPCUsableWeapons", { class = "weapon_shotgun",	title = "Shotgun" } )
list.Add( "NPCUsableWeapons", { class = "weapon_annabelle",	title = "Annabelle" } )
list.Add( "NPCUsableWeapons", { class = "weapon_crossbow",	title = "Crossbow" } )
list.Add( "NPCUsableWeapons", { class = "weapon_rpg",		title = "RPG" } )
