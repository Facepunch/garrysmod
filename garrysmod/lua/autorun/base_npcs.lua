
-- Don't try to edit this file if you're trying to add new NPCs.
-- Just make a new file and copy the format below.

local function AddNPC( t, class, name )
	if ( !t.Name ) then t.Name = "#" .. ( class or t.Class ) end

	list.Set( "NPC", class or t.Class, t )
end



local Category = "Humans + Resistance"

AddNPC( {
	Name = "#npc_alyx",
	Class = "npc_alyx",
	Category = Category,
	Weapons = { "weapon_alyxgun", "weapon_smg1", "weapon_shotgun" },
	KeyValues = { SquadName = "resistance" }
} )

AddNPC( {
	Name = "#npc_barney",
	Class = "npc_barney",
	Category = Category,
	Weapons = { "weapon_smg1", "weapon_shotgun", "weapon_ar2" },
	KeyValues = { SquadName = "resistance" }
} )

AddNPC( {
	Name = "#npc_breen",
	Class = "npc_breen",
	Category = Category
} )

AddNPC( {
	Name = "#npc_dog",
	Class = "npc_dog",
	Category = Category
} )

AddNPC( {
	Name = "#npc_eli",
	Class = "npc_eli",
	Category = Category
} )

AddNPC( {
	Name = "#npc_gman",
	Class = "npc_gman",
	Category = Category
} )

-- Did you know that this MAN can shoot annabelle like he's been doing it his whole life?
AddNPC( {
	Name = "#npc_kleiner",
	Class = "npc_kleiner",
	Category = Category
} )

AddNPC( {
	Name = "#npc_mossman",
	Class = "npc_mossman",
	Category = Category
} )

-- I don't trust these Vorts, but I'll let em stay in this category until they mess up
AddNPC( {
	Name = "#npc_vortigaunt",
	Class = "npc_vortigaunt",
	Category = Category,
	KeyValues = { SquadName = "resistance" }
} )

AddNPC( {
	Name = "#VortigauntSlave",
	Class = "npc_vortigaunt",
	Category = Category,
	Model = "models/vortigaunt_slave.mdl"
}, "VortigauntSlave" )

AddNPC( {
	Name = "#npc_citizen",
	Class = "npc_citizen",
	Category = Category,
	KeyValues = { citizentype = CT_DOWNTRODDEN, SquadName = "resistance" },
	Weapons = { "" } -- Tells the spawnmenu that this NPC can use weapons
} )

AddNPC( {
	Name = "#Rebel",
	Class = "npc_citizen",
	Category = Category,
	SpawnFlags = SF_CITIZEN_RANDOM_HEAD,
	KeyValues = { citizentype = CT_REBEL, SquadName = "resistance" },
	Weapons = { "weapon_pistol", "weapon_ar2", "weapon_smg1", "weapon_ar2", "weapon_shotgun" }
}, "Rebel" )

AddNPC( {
	Name = "#npc_odessa",
	Class = "npc_citizen",
	Category = Category,
	Model = "models/odessa.mdl",
	KeyValues = { citizentype = CT_UNIQUE, SquadName = "resistance" },
	Weapons = { "" }
}, "npc_odessa" )

AddNPC( {
	Name = "#Medic",
	Class = "npc_citizen",
	Category = Category,
	SpawnFlags = SERVER and bit.bor( SF_NPC_DROP_HEALTHKIT, SF_CITIZEN_MEDIC ) or nil,
	KeyValues = { citizentype = CT_REBEL, SquadName = "resistance" },
	Weapons = { "weapon_pistol", "weapon_smg1", "weapon_ar2", "weapon_shotgun" }
}, "Medic" )

AddNPC( {
	Name = "#Refugee",
	Class = "npc_citizen",
	Category = Category,
	KeyValues = { citizentype = CT_REFUGEE, SquadName = "resistance" },
	Weapons = { "weapon_pistol", "weapon_smg1" }
}, "Refugee" )

if ( IsMounted( "ep2" ) ) then
	AddNPC( {
		Name = "#VortigauntUriah",
		Class = "npc_vortigaunt",
		Category = Category,
		Model = "models/vortigaunt_doctor.mdl",
		KeyValues = { SquadName = "resistance" }
	}, "VortigauntUriah" )

	AddNPC( {
		Name = "#npc_magnusson",
		Class = "npc_magnusson",
		Category = Category
	} )
end

if ( IsMounted( "lostcoast" ) ) then
	AddNPC( {
		Name = "#npc_fisherman",
		Class = "npc_fisherman",
		Category = Category,
		Weapons = { "weapon_oldmanharpoon" }
	} ) -- Has no death sequence
end



Category = "Zombies + Enemy Aliens"

AddNPC( {
	Name = "#npc_zombie",
	Class = "npc_zombie",
	Category = Category,
	KeyValues = { SquadName = "zombies" }
} )

AddNPC( {
	Name = "#npc_zombie_torso",
	Class = "npc_zombie_torso",
	Category = Category,
	KeyValues = { SquadName = "zombies" }
} )

AddNPC( {
	Name = "#npc_poisonzombie",
	Class = "npc_poisonzombie",
	Category = Category,
	KeyValues = { SquadName = "poison" }
} )

AddNPC( {
	Name = "#npc_antlion",
	Class = "npc_antlion",
	Category = Category,
	KeyValues = { SquadName = "antlions" }
} )

AddNPC( {
	Name = "#npc_antlionguard",
	Class = "npc_antlionguard",
	Category = Category,
	KeyValues = { SquadName = "antlions" }
} )

AddNPC( {
	Name = "#npc_barnacle",
	Class = "npc_barnacle",
	Category = Category,
	OnCeiling = true,
	Offset = 2
} )

AddNPC( {
	Name = "#npc_fastzombie",
	Class = "npc_fastzombie",
	Category = Category,
	KeyValues = { SquadName = "zombies" }
} )

AddNPC( {
	Name = "#npc_headcrab",
	Class = "npc_headcrab",
	Category = Category,
	KeyValues = { SquadName = "zombies" }
} )

AddNPC( {
	Name = "#npc_headcrab_black",
	Class = "npc_headcrab_black",
	Category = Category,
	KeyValues = { SquadName = "poison" }
} )

AddNPC( {
	Name = "#npc_headcrab_fast",
	Class = "npc_headcrab_fast",
	Category = Category,
	KeyValues = { SquadName = "zombies" }
} )

AddNPC( {
	Name = "#npc_fastzombie_torso",
	Class = "npc_fastzombie_torso",
	Category = Category,
	KeyValues = { SquadName = "zombies" }
} )

if ( IsMounted( "episodic" ) or IsMounted( "ep2" ) ) then
	AddNPC( {
		Name = "#npc_zombine",
		Class = "npc_zombine",
		Category = Category,
		KeyValues = { SquadName = "zombies" }
	} )
end

if ( IsMounted( "ep2" ) ) then
	game.AddParticles( "particles/grub_blood.pcf" )
	game.AddParticles( "particles/antlion_gib_02.pcf" )
	game.AddParticles( "particles/antlion_worker.pcf" )

	AddNPC( {
		Name = "#npc_antlionguardian",
		Class = "npc_antlionguard",
		Category = Category,
		KeyValues = { cavernbreed = 1, incavern = 1, SquadName = "antlions" },
		Material = "Models/antlion_guard/antlionGuard2"
	}, "npc_antlionguardian" )

	AddNPC( {
		Name = "#npc_antlion_grub",
		Class = "npc_antlion_grub",
		Category = Category,
		NoDrop = true,
		Offset = 1
	} )

	AddNPC( {
		Name = "#npc_antlion_worker",
		Class = "npc_antlion_worker",
		Category = Category,
		KeyValues = { SquadName = "antlions" }
	} )
end



Category = "Animals"

AddNPC( {
	Name = "#npc_monk",
	Class = "npc_monk",
	Category = Category,
	Weapons = { "weapon_annabelle" }
} )

AddNPC( {
	Name = "#npc_crow",
	Class = "npc_crow",
	Category = Category,
	NoDrop = true
} )

AddNPC( {
	Name = "#npc_pigeon",
	Class = "npc_pigeon",
	Category = Category,
	NoDrop = true
} )

AddNPC( {
	Name = "#npc_seagull",
	Class = "npc_seagull",
	Category = Category,
	NoDrop = true
} )



Category = "Combine"

AddNPC( {
	Name = "#npc_metropolice",
	Class = "npc_metropolice",
	Category = Category,
	Weapons = { "weapon_stunstick", "weapon_pistol", "weapon_smg1" },
	SpawnFlags = SF_NPC_DROP_HEALTHKIT,
	KeyValues = { SquadName = "overwatch" }
} )

AddNPC( {
	Name = "#npc_rollermine",
	Class = "npc_rollermine",
	Category = Category,
	Offset = 20,
	KeyValues = { SquadName = "overwatch" },
	NoDrop = true
} )

AddNPC( {
	Name = "#npc_turret_floor",
	Class = "npc_turret_floor",
	Category = Category,
	OnFloor = true,
	TotalSpawnFlags = 0,
	Rotate = Angle( 0, 180, 0 ),
	Offset = 2,
	KeyValues = { SquadName = "overwatch" }
} )

AddNPC( {
	Name = "#npc_combine_s",
	Class = "npc_combine_s",
	Category = Category,
	Model = "models/combine_soldier.mdl",
	Skin = 0,
	Weapons = { "weapon_smg1", "weapon_ar2" },
	KeyValues = { SquadName = "overwatch", Numgrenades = 5 }
} )

AddNPC( {
	Name = "#ShotgunSoldier",
	Class = "npc_combine_s",
	Category = Category,
	Model = "models/combine_soldier.mdl",
	Skin = 1,
	Weapons = { "weapon_shotgun" },
	KeyValues = { SquadName = "overwatch", Numgrenades = 5 }
}, "ShotgunSoldier" )

AddNPC( {
	Name = "#CombinePrison",
	Class = "npc_combine_s",
	Category = Category,
	Model = "models/combine_soldier_prisonguard.mdl",
	Skin = 0,
	Weapons = { "weapon_smg1", "weapon_ar2" },
	KeyValues = { SquadName = "novaprospekt", Numgrenades = 5 }
}, "CombinePrison" )

AddNPC( {
	Name = "#PrisonShotgunner",
	Class = "npc_combine_s",
	Category = Category,
	Model = "models/combine_soldier_prisonguard.mdl",
	Skin = 1,
	Weapons = { "weapon_shotgun" },
	KeyValues = { SquadName = "novaprospekt", Numgrenades = 5 }
}, "PrisonShotgunner" )

AddNPC( {
	Name = "#CombineElite",
	Class = "npc_combine_s",
	Category = Category,
	Model = "models/combine_super_soldier.mdl",
	Skin = 0,
	Weapons = { "weapon_ar2" },
	KeyValues = { Numgrenades = 10, SquadName = "overwatch" },
	SpawnFlags = SF_NPC_NO_PLAYER_PUSHAWAY
}, "CombineElite" )

AddNPC( {
	Name = "#npc_cscanner",
	Class = "npc_cscanner",
	Category = Category,
	Offset = 20,
	KeyValues = { SquadName = "overwatch" },
	NoDrop = true
} )

AddNPC( {
	Name = "#npc_clawscanner",
	Class = "npc_clawscanner",
	Category = Category,
	Offset = 20,
	KeyValues = { SquadName = "overwatch" },
	NoDrop = true
} )

AddNPC( {
	Name = "#npc_combinegunship",
	Class = "npc_combinegunship",
	Category = Category,
	Offset = 300,
	KeyValues = { SquadName = "overwatch" },
	NoDrop = true
} )

AddNPC( {
	Name = "#npc_combinedropship",
	Class = "npc_combinedropship",
	Category = Category,
	Offset = 300,
	KeyValues = { SquadName = "overwatch" },
	NoDrop = true
} )

AddNPC( {
	Name = "#npc_helicopter",
	Class = "npc_helicopter",
	Category = Category,
	Offset = 300,
	Health = 600,
	KeyValues = { SquadName = "overwatch" },
	NoDrop = true
} )

AddNPC( {
	Name = "#npc_combine_camera",
	Class = "npc_combine_camera",
	Category = Category,
	OnCeiling = true,
	Offset = 2,
	KeyValues = { SquadName = "overwatch" },
	NoDrop = true
} )

AddNPC( {
	Name = "#npc_turret_ceiling",
	Class = "npc_turret_ceiling",
	Category = Category,
	SpawnFlags = 32, -- SF_NPC_TURRET_AUTOACTIVATE
	OnCeiling = true,
	Offset = 0,
	KeyValues = { SquadName = "overwatch" }
} )

AddNPC( {
	Name = "#npc_strider",
	Class = "npc_strider",
	Category = Category,
	Offset = 100,
	KeyValues = { SquadName = "overwatch" }
} )

AddNPC( {
	Name = "#npc_stalker",
	Class = "npc_stalker",
	Category = Category,
	KeyValues = { squadname = "npc_stalker_squad" },
	Offset = 10
} )

AddNPC( {
	Name = "#npc_manhack",
	Class = "npc_manhack",
	Category = Category,
	KeyValues = { SquadName = "overwatch" },
	NoDrop = true
} )

if ( IsMounted( "ep2" ) ) then
	AddNPC( {
		Name = "#npc_hunter",
		Class = "npc_hunter",
		Category = Category,
		KeyValues = { SquadName = "overwatch" }
	} )
end


if ( IsMounted( "hl1" ) or IsMounted( "hl1mp" ) ) then

	Category = "Half-Life: Source"

	AddNPC( { Name = "#monster_alien_grunt", Class = "monster_alien_grunt", Category = Category } )
	AddNPC( { Name = "#monster_nihilanth", Class = "monster_nihilanth", Category = Category, Offset = 1200, SpawnFlags = 262144, NoDrop = true } )
	AddNPC( { Name = "#monster_tentacle", Class = "monster_tentacle", Category = Category } )
	AddNPC( { Name = "#monster_alien_slave", Class = "monster_alien_slave", Category = Category } )
	AddNPC( { Name = "#monster_bigmomma", Class = "monster_bigmomma", Category = Category } )
	AddNPC( { Name = "#monster_bullchicken", Class = "monster_bullchicken", Category = Category } )
	AddNPC( { Name = "#monster_gargantua", Class = "monster_gargantua", Category = Category } )
	AddNPC( { Name = "#monster_human_assassin", Class = "monster_human_assassin", Category = Category } )
	AddNPC( { Name = "#monster_babycrab", Class = "monster_babycrab", Category = Category } )
	AddNPC( { Name = "#monster_human_grunt", Class = "monster_human_grunt", Category = Category } )
	AddNPC( { Name = "#monster_cockroach", Class = "monster_cockroach", Category = Category } )
	AddNPC( { Name = "#monster_houndeye", Class = "monster_houndeye", Category = Category } )
	AddNPC( { Name = "#monster_scientist", Class = "monster_scientist", Category = Category, KeyValues = { body = "-1" } } )
	AddNPC( { Name = "#monster_snark", Class = "monster_snark", Category = Category, Offset = 6, NoDrop = true } )
	AddNPC( { Name = "#monster_zombie", Class = "monster_zombie", Category = Category } )
	AddNPC( { Name = "#monster_headcrab", Class = "monster_headcrab", Category = Category } )
	AddNPC( { Name = "#monster_alien_controller", Class = "monster_alien_controller", Category = Category, NoDrop = true } )
	AddNPC( { Name = "#monster_barney", Class = "monster_barney", Category = Category } )

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
		Name = "#npc_portal_turret_floor",
		Class = "npc_portal_turret_floor",
		Category = Category,
		OnFloor = true,
		Rotate = Angle( 0, 180, 0 ),
		Offset = 2,
		TotalSpawnFlags = 0,
	} )

	AddNPC( {
		Name = "#npc_rocket_turret",
		Class = "npc_rocket_turret",
		Category = Category,
		OnFloor = true,
		SpawnFlags = 2, --SF_ROCKET_TURRET_SPAWNMENU, makes it target NPCs
		Offset = 0,
		Rotate = Angle( 0, 180, 0 ),
	} )

	AddNPC( {
		Name = "#npc_security_camera",
		Class = "npc_security_camera",
		Category = Category,
		Offset = -1,
		SpawnFlags = 32, --SF_SECURITY_CAMERA_AUTOACTIVATE
		SnapToNormal = true,
		NoDrop = true
	} )

end
