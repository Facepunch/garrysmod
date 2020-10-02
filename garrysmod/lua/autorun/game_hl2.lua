
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
ADD_ITEM( "AR2 Ammo", "item_ammo_ar2" )
ADD_ITEM( "AR2 Ammo (Large)", "item_ammo_ar2_large" )

ADD_ITEM( "Pistol Ammo", "item_ammo_pistol" )
ADD_ITEM( "Pistol Ammo (Large)", "item_ammo_pistol_large" )

ADD_ITEM( "357 Ammo", "item_ammo_357" )
ADD_ITEM( "357 Ammo (Large)", "item_ammo_357_large" )

ADD_ITEM( "SMG Ammo", "item_ammo_smg1" )
ADD_ITEM( "SMG Ammo (Large)", "item_ammo_smg1_large" )

ADD_ITEM( "SMG Grenade", "item_ammo_smg1_grenade" )
ADD_ITEM( "Crossbow Bolts", "item_ammo_crossbow" )
ADD_ITEM( "Shotgun Ammo", "item_box_buckshot" )
ADD_ITEM( "AR2 Orb", "item_ammo_ar2_altfire" )
ADD_ITEM( "RPG Rocket", "item_rpg_round" )

-- Dynamic materials; gives player what he needs most (health, shotgun ammo, suit energy, etc)
-- ADD_ITEM( "Dynamic Supplies", "item_dynamic_resupply" )

-- Items
ADD_ITEM( "Suit Battery", "item_battery" )
ADD_ITEM( "Health Kit", "item_healthkit" )
ADD_ITEM( "Health Vial", "item_healthvial" )
ADD_ITEM( "Suit Charger", "item_suitcharger" )
ADD_ITEM( "Health Charger", "item_healthcharger" )
ADD_ITEM( "HEV Suit", "item_suit" )

ADD_ITEM( "Thumper", "prop_thumper" )
ADD_ITEM( "Combine Mine", "combine_mine" )
ADD_ITEM( "Zombine Grenade", "npc_grenade_frag" )
ADD_ITEM( "Helicopter Grenade", "grenade_helicopter" )

if ( IsMounted( "ep2" ) ) then
	game.AddParticles( "particles/striderbuster.pcf" )
	ADD_ITEM( "Magnusson", "weapon_striderbuster" )
end

-- Weapons
ADD_WEAPON( "Gravity Gun", "weapon_physcannon" )
ADD_WEAPON( "Stunstick", "weapon_stunstick" )
ADD_WEAPON( "Frag Grenade", "weapon_frag" )
ADD_WEAPON( "Crossbow", "weapon_crossbow" )
ADD_WEAPON( "Bug Bait", "weapon_bugbait" )
ADD_WEAPON( "RPG Launcher", "weapon_rpg" )
ADD_WEAPON( "Crowbar", "weapon_crowbar" )
ADD_WEAPON( "Shotgun", "weapon_shotgun" )
ADD_WEAPON( "9mm Pistol", "weapon_pistol" )
ADD_WEAPON( "S.L.A.M", "weapon_slam" )
ADD_WEAPON( "SMG", "weapon_smg1" )
ADD_WEAPON( "Pulse-Rifle", "weapon_ar2" )
ADD_WEAPON( ".357 Magnum", "weapon_357" )
--ADD_WEAPON( "Alyx Gun", "weapon_alyxgun" )
--ADD_WEAPON( "Annabelle", "weapon_annabelle" )

-- NPC Weapons
list.Add( "NPCUsableWeapons", { class = "weapon_pistol", title = "#weapon_pistol" } )
list.Add( "NPCUsableWeapons", { class = "weapon_357", title = "#weapon_357" } )
list.Add( "NPCUsableWeapons", { class = "weapon_smg1", title = "#weapon_smg1" } )
list.Add( "NPCUsableWeapons", { class = "weapon_shotgun", title = "#weapon_shotgun" } )
list.Add( "NPCUsableWeapons", { class = "weapon_ar2", title = "#weapon_ar2" } )
list.Add( "NPCUsableWeapons", { class = "weapon_rpg", title = "#weapon_rpg" } )
list.Add( "NPCUsableWeapons", { class = "weapon_alyxgun", title = "#weapon_alyxgun" } )
list.Add( "NPCUsableWeapons", { class = "weapon_annabelle", title = "#weapon_annabelle" } )
list.Add( "NPCUsableWeapons", { class = "weapon_crossbow", title = "#weapon_crossbow" } )
list.Add( "NPCUsableWeapons", { class = "weapon_stunstick", title = "#weapon_stunstick" } )
list.Add( "NPCUsableWeapons", { class = "weapon_crowbar", title = "#weapon_crowbar" } )

if ( IsMounted( "hl1" ) || IsMounted( "hl1mp" ) ) then
	Category = "Half-Life: Source"

	ADD_WEAPON( "Snarks", "weapon_snark" )
	ADD_WEAPON( "Hand Grenade", "weapon_handgrenade" )
	ADD_WEAPON( "MP5", "weapon_mp5_hl1" )
	ADD_WEAPON( "Hornet Gun", "weapon_hornetgun" )
	ADD_WEAPON( "Satchel", "weapon_satchel" )
	ADD_WEAPON( "Tripmine", "weapon_tripmine" )
	ADD_WEAPON( "Crossbow", "weapon_crossbow_hl1" )
	ADD_WEAPON( ".357 Handgun", "weapon_357_hl1" )
	ADD_WEAPON( "RPG Launcher", "weapon_rpg_hl1" )
	ADD_WEAPON( "SPAS-12", "weapon_shotgun_hl1" )
	ADD_WEAPON( "Glock", "weapon_glock_hl1" )
	ADD_WEAPON( "Tau Cannon", "weapon_gauss" )
	ADD_WEAPON( "Gluon Gun", "weapon_egon" )
	ADD_WEAPON( "Crowbar", "weapon_crowbar_hl1" )

	ADD_ITEM( "Crossbow Bolts", "ammo_crossbow" )
	ADD_ITEM( "Uranium", "ammo_gaussclip" )
	ADD_ITEM( "Glock Clip", "ammo_glockclip" )
	ADD_ITEM( "MP5 Clip", "ammo_mp5clip" )
	ADD_ITEM( "MP5 Ammo Crate", "ammo_9mmbox" )
	ADD_ITEM( "MP5 Grenades", "ammo_mp5grenades" )
	ADD_ITEM( ".357 Ammo", "ammo_357" )
	ADD_ITEM( "RPG Rockets", "ammo_rpgclip" )
	ADD_ITEM( "SPAS-12 Ammo", "ammo_buckshot" )
	--ADD_ITEM( "Uranium (Egon)", "ammo_egonclip" )
	--ADD_ITEM( "MP5 Ammo", "ammo_9mmclip" )
	--ADD_ITEM( "MP5 Ammo", "ammo_9mmar" )
	--ADD_ITEM( "MP5 Grenade", "ammo_argrenades" )

	list.Add( "NPCUsableWeapons", { class = "weapon_glock_hl1", title = "#weapon_glock_hl1" } )
end

Category = "Other"
ADD_WEAPON( "Physics Gun", "weapon_physgun" )
