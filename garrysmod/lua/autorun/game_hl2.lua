
local Category = ""

-- This is basically dupliacator.GenericDuplicatorFunction, but calls the relevant hooks
-- Move this all to commands.lua?
local function ADD_ITEM_DUPEFUNC( ply, data )
	if ( IsValid( ply ) && !gamemode.Call( "PlayerSpawnSENT", ply, data.Class ) ) then return NULL end

	local ent = ents.Create( data.Class )
	if ( !IsValid( ent ) ) then return NULL end -- Must've hit edict limit

	-- Remove certain fields we do not want dupes to manipulate
	data.Model = nil

	-- Restore the keyvalues
	local entTable = list.GetEntry( "SpawnableEntities", data.EntityName )
	if ( entTable && entTable.ClassName == data.Class && entTable.KeyValues ) then
		for k, v in pairs( entTable.KeyValues ) do
			ent:SetKeyValue( k, v )
		end
	end

	duplicator.DoGeneric( ent, data )

	ent:Spawn()

	--duplicator.DoGenericPhysics( ent, ply, data )

	ent:Activate()

	ent.EntityName = data.EntityName

	-- For hacked combine mines, they reset their skin
	if ( data.Skin ) then ent:SetSkin( data.Skin ) end

	if ( IsValid( ply ) ) then
		ent:SetCreator( ply )
		gamemode.Call( "PlayerSpawnedSENT", ply, ent )
	end

	return ent
end

local function ADD_WEAPON_DUPEFUNC( ply, data )
	if ( IsValid( ply ) && !gamemode.Call( "PlayerSpawnSWEP", ply, data.Class, list.GetEntry( "Weapon", data.Class ) ) ) then return NULL end

	local ent = ents.Create( data.Class )
	if ( !IsValid( ent ) ) then return NULL end -- Must've hit edict limit

	-- Remove certain fields we do not want dupes to manipulate
	data.Model = nil

	duplicator.DoGeneric( ent, data )

	ent:Spawn()

	--duplicator.DoGenericPhysics( ent, ply, data )

	ent:Activate()

	ent.EntityName = data.EntityName

	if ( IsValid( ply ) ) then
		ent:SetCreator( ply )
		gamemode.Call( "PlayerSpawnedSWEP", ply, ent )
	end

	return ent
end

local function ADD_ITEM( class, offset, extras, classOverride )

	local base = { PrintName = "#" .. ( classOverride or class ), ClassName = class, Category = Category, NormalOffset = offset or 32, DropToFloor = true, Author = "VALVe" }
	list.Set( "SpawnableEntities", classOverride or class, table.Merge( base, extras or {} ) )
	duplicator.RegisterEntityClass( class, ADD_ITEM_DUPEFUNC, "Data" )

end

local function ADD_WEAPON( class )

	list.Set( "Weapon", class, { ClassName = class, PrintName = "#" .. ( class ), Category = Category, Author = "VALVe", Spawnable = true } )
	duplicator.RegisterEntityClass( class, ADD_WEAPON_DUPEFUNC, "Data" )

end

local function ADD_NPC_WEAPON( class )

	list.Add( "NPCUsableWeapons", { class = class, title = "#" .. class, category = Category } )

end

Category = "Half-Life 2"

-- Ammo
ADD_ITEM( "item_ammo_ar2", -8 )
ADD_ITEM( "item_ammo_ar2_large", -8 )

ADD_ITEM( "item_ammo_pistol", -4 )
ADD_ITEM( "item_ammo_pistol_large", -4 )

ADD_ITEM( "item_ammo_357", -4 )
ADD_ITEM( "item_ammo_357_large", -4 )

ADD_ITEM( "item_ammo_smg1", -2 )
ADD_ITEM( "item_ammo_smg1_large", -2 )

ADD_ITEM( "item_ammo_smg1_grenade", -10 )
ADD_ITEM( "item_ammo_crossbow", -10 )
ADD_ITEM( "item_box_buckshot", -10 )
ADD_ITEM( "item_ammo_ar2_altfire", -2 )
ADD_ITEM( "item_rpg_round", -10 )

-- Dynamic materials; gives player what he needs most (health, shotgun ammo, suit energy, etc)
-- ADD_ITEM( "item_dynamic_resupply" )

-- Items
ADD_ITEM( "item_battery", -4 )
ADD_ITEM( "item_healthkit", -8 )
ADD_ITEM( "item_healthvial", -4 )
ADD_ITEM( "item_suitcharger" )
ADD_ITEM( "item_healthcharger" )
ADD_ITEM( "item_suit", 0 )

ADD_ITEM( "prop_thumper" )
ADD_ITEM( "combine_mine", -8 )
ADD_ITEM( "combine_mine", -8, { KeyValues = { Modification = 1 } }, "combine_mine_resistance" )
ADD_ITEM( "npc_grenade_frag", -8 )
ADD_ITEM( "grenade_helicopter", 4 )

ADD_ITEM( "weapon_striderbuster" )

-- Weapons
ADD_WEAPON( "weapon_physcannon" )
ADD_WEAPON( "weapon_stunstick" )
ADD_WEAPON( "weapon_frag" )
ADD_WEAPON( "weapon_crossbow" )
ADD_WEAPON( "weapon_bugbait" )
ADD_WEAPON( "weapon_rpg" )
ADD_WEAPON( "weapon_crowbar" )
ADD_WEAPON( "weapon_shotgun" )
ADD_WEAPON( "weapon_pistol" )
ADD_WEAPON( "weapon_slam" )
ADD_WEAPON( "weapon_smg1" )
ADD_WEAPON( "weapon_ar2" )
ADD_WEAPON( "weapon_357" )
--ADD_WEAPON( "weapon_alyxgun" )
--ADD_WEAPON( "weapon_annabelle" )

-- NPC Weapons
ADD_NPC_WEAPON( "weapon_pistol" )
ADD_NPC_WEAPON( "weapon_357" )
ADD_NPC_WEAPON( "weapon_smg1" )
ADD_NPC_WEAPON( "weapon_shotgun" )
ADD_NPC_WEAPON( "weapon_ar2" )
ADD_NPC_WEAPON( "weapon_rpg" )
ADD_NPC_WEAPON( "weapon_alyxgun" )
ADD_NPC_WEAPON( "weapon_annabelle" )
ADD_NPC_WEAPON( "weapon_crossbow" )
ADD_NPC_WEAPON( "weapon_stunstick" )
ADD_NPC_WEAPON( "weapon_crowbar" )

if ( IsMounted( "hl1" ) or IsMounted( "hl1mp" ) ) then
	Category = "Half-Life: Source"

	ADD_WEAPON( "weapon_snark" )
	ADD_WEAPON( "weapon_handgrenade" )
	ADD_WEAPON( "weapon_mp5_hl1" )
	ADD_WEAPON( "weapon_hornetgun" )
	ADD_WEAPON( "weapon_satchel" )
	ADD_WEAPON( "weapon_tripmine" )
	ADD_WEAPON( "weapon_crossbow_hl1" )
	ADD_WEAPON( "weapon_357_hl1" )
	ADD_WEAPON( "weapon_rpg_hl1" )
	ADD_WEAPON( "weapon_shotgun_hl1" )
	ADD_WEAPON( "weapon_glock_hl1" )
	ADD_WEAPON( "weapon_gauss" )
	ADD_WEAPON( "weapon_egon" )
	ADD_WEAPON( "weapon_crowbar_hl1" )

	ADD_ITEM( "ammo_crossbow", 0 )
	ADD_ITEM( "ammo_gaussclip", 0 )
	ADD_ITEM( "ammo_glockclip", 0 )
	ADD_ITEM( "ammo_mp5clip", 0 )
	ADD_ITEM( "ammo_9mmbox", 0, { Information = "Gives ammo for the MP5 and Glock." } )
	ADD_ITEM( "ammo_mp5grenades", 0 )
	ADD_ITEM( "ammo_357", 0 )
	ADD_ITEM( "ammo_rpgclip", 0 )
	ADD_ITEM( "ammo_buckshot", 0 )

	-- Can't be physgunned
	--ADD_ITEM( "xen_plantlight", -16 )

	ADD_NPC_WEAPON( "weapon_357_hl1" )
	ADD_NPC_WEAPON( "weapon_mp5_hl1" )
	ADD_NPC_WEAPON( "weapon_glock_hl1" )
	ADD_NPC_WEAPON( "weapon_shotgun_hl1" )
end

if ( IsMounted( "portal" ) ) then
	Category = "Portal"

	ADD_ITEM( "prop_glados_core", 32, { KeyValues = { CoreType = 0, DelayBetweenLines = 0.4 }, PrintName = "#prop_glados_core_curiosity" } )
	ADD_ITEM( "prop_glados_core", 32, { KeyValues = { CoreType = 1, DelayBetweenLines = 0.1 } }, "prop_glados_core_anger" )
	ADD_ITEM( "prop_glados_core", 32, { KeyValues = { CoreType = 2, DelayBetweenLines = 0.1 } }, "prop_glados_core_crazy" )
	ADD_ITEM( "prop_glados_core", 32, { KeyValues = { CoreType = 3 } }, "prop_glados_core_morality" )
end

Category = "#spawnmenu.category.other"
ADD_WEAPON( "weapon_physgun" )
