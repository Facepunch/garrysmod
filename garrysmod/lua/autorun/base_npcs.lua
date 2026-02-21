
-- Don't try to edit this file if you're trying to add new NPCs.
-- Just make a new file and copy the format below.

local function AddNPC( t, class )
	if ( !t.Name ) then t.Name = "#" .. ( class or t.Class ) end
	t.Author = "VALVe"

	list.Set( "NPC", class or t.Class, t )
end



local Category = "#spawnmenu.category.humans_resistance"

AddNPC( {
	Class = "npc_alyx",
	Category = Category,
	Weapons = { "weapon_alyxgun", "weapon_smg1", "weapon_shotgun" },
	KeyValues = { SquadName = "resistance" }
} )

AddNPC( {
	Class = "npc_barney",
	Category = Category,
	Weapons = { "weapon_smg1", "weapon_shotgun", "weapon_ar2" },
	KeyValues = { SquadName = "resistance" }
} )

AddNPC( {
	Class = "npc_breen",
	Category = Category,
	SpawnFlags = 131072, -- SF_BREEN_GMOD_SPAWNMENU, makes him be a combine for NPC relationships
	Weapons = { "" }
} )

AddNPC( {
	Class = "npc_dog",
	Category = Category
} )

AddNPC( {
	Class = "npc_eli",
	Category = Category,
	Weapons = { "" }
} )

AddNPC( {
	Class = "npc_gman",
	Category = Category
} )

-- Did you know that this MAN can shoot annabelle like he's been doing it his whole life?
AddNPC( {
	Class = "npc_kleiner",
	Category = Category,
	Weapons = { "" }
} )

AddNPC( {
	Class = "npc_mossman",
	Category = Category,
	Weapons = { "" }
} )

-- I don't trust these Vorts, but I'll let em stay in this category until they mess up
AddNPC( {
	Class = "npc_vortigaunt",
	Category = Category,
	KeyValues = { SquadName = "resistance" }
} )

AddNPC( {
	Name = "#npc_vortigaunt_slave",
	Class = "npc_vortigaunt",
	Category = Category,
	Model = "models/vortigaunt_slave.mdl"
}, "VortigauntSlave" )

AddNPC( {
	Class = "npc_citizen",
	Category = Category,
	KeyValues = { citizentype = CT_DOWNTRODDEN, SquadName = "resistance" },
	Weapons = { "" } -- Tells the spawnmenu that this NPC can use weapons, but doesn't have any default ones
} )

AddNPC( {
	Name = "#npc_citizen_rebel",
	Class = "npc_citizen",
	Category = Category,
	SpawnFlags = SF_CITIZEN_RANDOM_HEAD,
	KeyValues = { citizentype = CT_REBEL, SquadName = "resistance" },
	Weapons = { "weapon_pistol", "weapon_smg1", "weapon_ar2", "weapon_shotgun", "weapon_rpg" }
}, "Rebel" )

AddNPC( {
	Class = "npc_citizen",
	Category = Category,
	Model = "models/odessa.mdl",
	KeyValues = { citizentype = CT_UNIQUE, SquadName = "resistance" },
	Weapons = { "" }
}, "npc_odessa" )

AddNPC( {
	Name = "#npc_citizen_medic",
	Class = "npc_citizen",
	Category = Category,
	SpawnFlags = SERVER and bit.bor( SF_NPC_DROP_HEALTHKIT, SF_CITIZEN_MEDIC ) or nil,
	KeyValues = { citizentype = CT_REBEL, SquadName = "resistance" },
	Weapons = { "weapon_pistol", "weapon_smg1", "weapon_ar2" }
}, "Medic" )

AddNPC( {
	Name = "#npc_citizen_refugee",
	Class = "npc_citizen",
	Category = Category,
	KeyValues = { citizentype = CT_REFUGEE, SquadName = "resistance" },
	Weapons = { "weapon_pistol", "weapon_smg1" }
}, "Refugee" )

AddNPC( {
	Name = "#npc_vortigaunt_uriah",
	Class = "npc_vortigaunt",
	Category = Category,
	Model = "models/vortigaunt_doctor.mdl",
	KeyValues = { SquadName = "resistance" }
}, "VortigauntUriah" )

AddNPC( {
	Class = "npc_magnusson",
	Category = Category,
	Weapons = { "" }
} )

if ( IsMounted( "lostcoast" ) ) then
	AddNPC( {
		Class = "npc_fisherman",
		Category = Category,
		Weapons = { "weapon_oldmanharpoon" }
	} ) -- Has no death sequence/ragdoll
end

AddNPC( {
	Class = "npc_turret_floor",
	Category = Category,
	OnFloor = true,
	TotalSpawnFlags = SF_FLOOR_TURRET_CITIZEN,
	Rotate = Angle( 0, 180, 0 ),
	Offset = 2,
	KeyValues = { SquadName = "resistance" }
}, "npc_turret_floor_resistance" )

AddNPC( {
	Class = "npc_rollermine",
	Category = Category,
	Offset = 20,
	KeyValues = { SquadName = "resistance" },
	SpawnFlags = 262144, -- SF_ROLLERMINE_HACKED
	NoDrop = true
}, "npc_rollermine_hacked" )

Category = "#spawnmenu.category.zombies_aliens"

AddNPC( {
	Class = "npc_zombie",
	Category = Category,
	KeyValues = { SquadName = "zombies" }
} )

AddNPC( {
	Class = "npc_zombie_torso",
	Category = Category,
	KeyValues = { SquadName = "zombies" }
} )

AddNPC( {
	Class = "npc_poisonzombie",
	Category = Category,
	KeyValues = { SquadName = "poison" }
} )

AddNPC( {
	Class = "npc_antlion",
	Category = Category,
	KeyValues = { SquadName = "antlions" }
} )

AddNPC( {
	Class = "npc_antlionguard",
	Category = Category,
	KeyValues = { SquadName = "antlions" }
} )

AddNPC( {
	Class = "npc_barnacle",
	Category = Category,
	OnCeiling = true,
	Offset = 2
} )

AddNPC( {
	Class = "npc_fastzombie",
	Category = Category,
	KeyValues = { SquadName = "zombies" }
} )

AddNPC( {
	Class = "npc_headcrab",
	Category = Category,
	KeyValues = { SquadName = "zombies" }
} )

AddNPC( {
	Class = "npc_headcrab_black",
	Category = Category,
	KeyValues = { SquadName = "poison" }
} )

AddNPC( {
	Class = "npc_headcrab_fast",
	Category = Category,
	KeyValues = { SquadName = "zombies" }
} )

AddNPC( {
	Class = "npc_fastzombie_torso",
	Category = Category,
	KeyValues = { SquadName = "zombies" }
} )

AddNPC( {
	Class = "npc_zombine",
	Category = Category,
	KeyValues = { SquadName = "zombies" }
} )

AddNPC( {
	Class = "npc_antlionguard",
	Category = Category,
	KeyValues = { cavernbreed = 1, incavern = 1, SquadName = "antlions" },
	Material = "Models/antlion_guard/antlionGuard2"
}, "npc_antlionguardian" )

AddNPC( {
	Class = "npc_antlion_grub",
	Category = Category,
	NoDrop = true,
	Offset = 1
} )

AddNPC( {
	Class = "npc_antlion_worker",
	Category = Category,
	KeyValues = { SquadName = "antlions" }
} )



Category = "#spawnmenu.category.animals"

AddNPC( {
	Class = "npc_monk",
	Category = Category,
	Weapons = { "weapon_annabelle" }
} )

AddNPC( {
	Class = "npc_crow",
	Category = Category,
	NoDrop = true
} )

AddNPC( {
	Class = "npc_pigeon",
	Category = Category,
	NoDrop = true
} )

AddNPC( {
	Class = "npc_seagull",
	Category = Category,
	NoDrop = true
} )



Category = "#spawnmenu.category.combine"

AddNPC( {
	Class = "npc_metropolice",
	Category = Category,
	Weapons = { "weapon_stunstick", "weapon_pistol", "weapon_smg1" },
	SpawnFlags = SF_NPC_DROP_HEALTHKIT,
	KeyValues = { SquadName = "overwatch" }
} )

AddNPC( {
	Class = "npc_rollermine",
	Category = Category,
	Offset = 20,
	KeyValues = { SquadName = "overwatch" },
	NoDrop = true
} )

-- It is still considered an enemy by friendly NPCs (so that it chases them)
AddNPC( {
	Class = "npc_rollermine",
	Category = Category,
	Offset = 20,
	KeyValues = { SquadName = "overwatch" },
	SpawnFlags = 65536, -- SF_ROLLERMINE_FRIENDLY
	NoDrop = true
}, "npc_rollermine_friendly" )

AddNPC( {
	Class = "npc_turret_floor",
	Category = Category,
	OnFloor = true,
	TotalSpawnFlags = 0,
	Rotate = Angle( 0, 180, 0 ),
	Offset = 2,
	KeyValues = { SquadName = "overwatch" }
} )

AddNPC( {
	Class = "npc_combine_s",
	Category = Category,
	Model = "models/combine_soldier.mdl",
	Skin = 0,
	Weapons = { "weapon_smg1", "weapon_ar2" },
	KeyValues = { SquadName = "overwatch", Numgrenades = 5 }
} )

AddNPC( {
	Name = "#npc_combine_s_shotgun",
	Class = "npc_combine_s",
	Category = Category,
	Model = "models/combine_soldier.mdl",
	Skin = 1,
	Weapons = { "weapon_shotgun" },
	KeyValues = { SquadName = "overwatch", Numgrenades = 5 }
}, "ShotgunSoldier" )

AddNPC( {
	Name = "#npc_combine_s_prison",
	Class = "npc_combine_s",
	Category = Category,
	Model = "models/combine_soldier_prisonguard.mdl",
	Skin = 0,
	Weapons = { "weapon_smg1", "weapon_ar2" },
	KeyValues = { SquadName = "novaprospekt", Numgrenades = 5 }
}, "CombinePrison" )

AddNPC( {
	Name = "#npc_combine_s_prison_shotgun",
	Class = "npc_combine_s",
	Category = Category,
	Model = "models/combine_soldier_prisonguard.mdl",
	Skin = 1,
	Weapons = { "weapon_shotgun" },
	KeyValues = { SquadName = "novaprospekt", Numgrenades = 5 }
}, "PrisonShotgunner" )

AddNPC( {
	Name = "#npc_combine_s_elite",
	Class = "npc_combine_s",
	Category = Category,
	Model = "models/combine_super_soldier.mdl",
	Skin = 0,
	Weapons = { "weapon_ar2" },
	KeyValues = { Numgrenades = 10, SquadName = "overwatch" },
	SpawnFlags = SF_NPC_NO_PLAYER_PUSHAWAY
}, "CombineElite" )

AddNPC( {
	Class = "npc_cscanner",
	Category = Category,
	Offset = 20,
	KeyValues = { SquadName = "overwatch", SpotlightLength = 500, SpotlightWidth = 100 },
	NoDrop = true
} )

AddNPC( {
	Class = "npc_clawscanner",
	Category = Category,
	Offset = 20,
	KeyValues = { SquadName = "overwatch", SpotlightLength = 500, SpotlightWidth = 100 },
	NoDrop = true
} )

AddNPC( {
	Class = "npc_combinegunship",
	Category = Category,
	Offset = 300,
	KeyValues = { SquadName = "overwatch" },
	NoDrop = true
} )

AddNPC( {
	Class = "npc_combinedropship",
	Category = Category,
	Offset = 300,
	KeyValues = { SquadName = "overwatch" },
	NoDrop = true
} )

AddNPC( {
	Class = "npc_helicopter",
	Category = Category,
	Offset = 300,
	Health = 600,
	KeyValues = { SquadName = "overwatch" },
	NoDrop = true
} )

AddNPC( {
	Class = "npc_combine_camera",
	Category = Category,
	OnCeiling = true,
	Offset = 2,
	KeyValues = { SquadName = "overwatch" },
	NoDrop = true
} )

AddNPC( {
	Class = "npc_turret_ceiling",
	Category = Category,
	SpawnFlags = 32, -- SF_NPC_TURRET_AUTOACTIVATE
	OnCeiling = true,
	Offset = 0,
	KeyValues = { SquadName = "overwatch" }
} )

AddNPC( {
	Class = "npc_strider",
	Category = Category,
	Offset = 100,
	KeyValues = { SquadName = "overwatch" }
} )

AddNPC( {
	Class = "npc_stalker",
	Category = Category,
	KeyValues = { SquadName = "npc_stalker_squad" },
	Offset = 10
} )

AddNPC( {
	Class = "npc_manhack",
	Category = Category,
	KeyValues = { SquadName = "overwatch" },
	NoDrop = true
} )

-- This is meant for NPC reskins, so humanoid NPC reskins don't sound like combine.
-- This is also just for fun, and exists here to let people know that the option exists and how to use it.
AddNPC( {
	Class = "npc_citizen",
	Category = Category,
	KeyValues = { citizentype = CT_REBEL, SquadName = "overwatch", Hostile = "1" },
	Weapons = { "weapon_pistol", "weapon_smg1", "weapon_ar2", "weapon_shotgun", "weapon_rpg" }
}, "npc_citizen_rebel_enemy" )

AddNPC( {
	Class = "npc_hunter",
	Category = Category,
	KeyValues = { SquadName = "overwatch" }
} )

if ( IsMounted( "hl1" ) or IsMounted( "hl1mp" ) ) then

	Category = "Half-Life: Source"

	AddNPC( { Class = "monster_alien_grunt", Category = Category } )
	AddNPC( { Class = "monster_nihilanth", Category = Category, Offset = 1200, SpawnFlags = 262144, NoDrop = true } )
	AddNPC( { Class = "monster_tentacle", Category = Category } )
	AddNPC( { Class = "monster_alien_slave", Category = Category } )
	AddNPC( { Class = "monster_bigmomma", Category = Category } )
	AddNPC( { Class = "monster_bullchicken", Category = Category } )
	AddNPC( { Class = "monster_gargantua", Category = Category } )
	AddNPC( { Class = "monster_human_assassin", Category = Category } )
	AddNPC( { Class = "monster_babycrab", Category = Category } )
	AddNPC( { Class = "monster_human_grunt", Category = Category } )
	AddNPC( { Class = "monster_cockroach", Category = Category } )
	AddNPC( { Class = "monster_houndeye", Category = Category } )
	AddNPC( { Class = "monster_scientist", Category = Category, KeyValues = { body = "-1" } } )
	AddNPC( { Class = "monster_snark", Category = Category, Offset = 6, NoDrop = true } )
	AddNPC( { Class = "monster_zombie", Category = Category } )
	AddNPC( { Class = "monster_headcrab", Category = Category } )
	AddNPC( { Class = "monster_alien_controller", Category = Category, NoDrop = true } )
	AddNPC( { Class = "monster_barney", Category = Category } )

	-- Hack to have it not invert angles again
	local turretOnDupe = function( npc, data ) npc:SetKeyValue( "spawnflags", bit.bor( npc.SpawnFlags, 2048 ) ) end
	local turretOnCeiling = function( npc ) npc:SetKeyValue( "orientation", 1 ) end
	AddNPC( { Class = "monster_turret", Category = Category, Offset = 0, OnCeiling = turretOnCeiling, OnFloor = true, SpawnFlags = 32, OnDuplicated = turretOnDupe } )
	AddNPC( { Class = "monster_miniturret", Category = Category, Offset = 0, OnCeiling = turretOnCeiling, OnFloor = true, SpawnFlags = 32, OnDuplicated = turretOnDupe } )
	AddNPC( { Class = "monster_sentry", Category = Category, Offset = 0, OnFloor = true, SpawnFlags = 32 } )

end

if ( IsMounted( "portal" ) ) then

	Category = "Portal"

	AddNPC( {
		Class = "npc_portal_turret_floor",
		Category = Category,
		OnFloor = true,
		Rotate = Angle( 0, 180, 0 ),
		Offset = 2,
		TotalSpawnFlags = 0,
	} )

	AddNPC( {
		Class = "npc_rocket_turret",
		Category = Category,
		OnFloor = true,
		SpawnFlags = 2, --SF_ROCKET_TURRET_SPAWNMENU, makes it target NPCs
		Offset = 0,
		Rotate = Angle( 0, 180, 0 ),
	} )

	AddNPC( {
		Class = "npc_security_camera",
		Category = Category,
		Offset = -1,
		SpawnFlags = 32, --SF_SECURITY_CAMERA_AUTOACTIVATE
		SnapToNormal = true,
		NoDrop = true
	} )

end
