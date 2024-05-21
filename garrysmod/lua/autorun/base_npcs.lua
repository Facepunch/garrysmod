
-- Don't try to edit this file if you're trying to add new NPCs.
-- Just make a new file and copy the format below.

local function AddNPC( t, class )
	if ( !t.Name ) then t.Name = "#" .. ( class or t.Class ) end

	list.Set( "NPC", class or t.Class, t )
end



local Category = "Humans + Resistance"

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
	Category = Category
} )

AddNPC( {
	Class = "npc_dog",
	Category = Category
} )

AddNPC( {
	Class = "npc_eli",
	Category = Category
} )

AddNPC( {
	Class = "npc_gman",
	Category = Category
} )

-- Did you know that this MAN can shoot annabelle like he's been doing it his whole life?
AddNPC( {
	Class = "npc_kleiner",
	Category = Category
} )

AddNPC( {
	Class = "npc_mossman",
	Category = Category
} )

-- I don't trust these Vorts, but I'll let em stay in this category until they mess up
AddNPC( {
	Class = "npc_vortigaunt",
	Category = Category,
	KeyValues = { SquadName = "resistance" }
} )

AddNPC( {
	Name = "Vortigaunt Slave",
	Class = "npc_vortigaunt",
	Category = Category,
	Model = "models/vortigaunt_slave.mdl"
}, "VortigauntSlave" )

AddNPC( {
	Class = "npc_citizen",
	Category = Category,
	KeyValues = { citizentype = CT_DOWNTRODDEN, SquadName = "resistance" },
	Weapons = { "" } -- Tells the spawnmenu that this NPC can use weapons
} )

AddNPC( {
	Name = "Rebel",
	Class = "npc_citizen",
	Category = Category,
	SpawnFlags = SF_CITIZEN_RANDOM_HEAD,
	KeyValues = { citizentype = CT_REBEL, SquadName = "resistance" },
	Weapons = { "weapon_pistol", "weapon_ar2", "weapon_smg1", "weapon_ar2", "weapon_shotgun" }
}, "Rebel" )

AddNPC( {
	Name = "Odessa Cubbage",
	Class = "npc_citizen",
	Category = Category,
	Model = "models/odessa.mdl",
	KeyValues = { citizentype = CT_UNIQUE, SquadName = "resistance" },
	Weapons = { "" }
}, "npc_odessa" )

AddNPC( {
	Name = "Rebel Medic",
	Class = "npc_citizen",
	Category = Category,
	SpawnFlags = SERVER and bit.bor( SF_NPC_DROP_HEALTHKIT, SF_CITIZEN_MEDIC ) or nil,
	KeyValues = { citizentype = CT_REBEL, SquadName = "resistance" },
	Weapons = { "weapon_pistol", "weapon_smg1", "weapon_ar2", "weapon_shotgun" }
}, "Medic" )

AddNPC( {
	Name = "Refugee",
	Class = "npc_citizen",
	Category = Category,
	KeyValues = { citizentype = CT_REFUGEE, SquadName = "resistance" },
	Weapons = { "weapon_pistol", "weapon_smg1" }
}, "Refugee" )

if ( IsMounted( "ep2" ) ) then
	AddNPC( {
		Name = "Uriah",
		Class = "npc_vortigaunt",
		Category = Category,
		Model = "models/vortigaunt_doctor.mdl",
		KeyValues = { SquadName = "resistance" }
	}, "VortigauntUriah" )

	AddNPC( {
		Class = "npc_magnusson",
		Category = Category
	} )
end

if ( IsMounted( "lostcoast" ) ) then
	AddNPC( {
		Class = "npc_fisherman",
		Category = Category,
		Weapons = { "weapon_oldmanharpoon" }
	} ) -- Has no death sequence
end



Category = "Zombies + Enemy Aliens"

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

if ( IsMounted( "episodic" ) or IsMounted( "ep2" ) ) then
	AddNPC( {
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
		Name = "Antlion Guardian",
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
end



Category = "Animals"

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



Category = "Combine"

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
	Name = "Shotgun Soldier",
	Class = "npc_combine_s",
	Category = Category,
	Model = "models/combine_soldier.mdl",
	Skin = 1,
	Weapons = { "weapon_shotgun" },
	KeyValues = { SquadName = "overwatch", Numgrenades = 5 }
}, "ShotgunSoldier" )

AddNPC( {
	Name = "Prison Guard",
	Class = "npc_combine_s",
	Category = Category,
	Model = "models/combine_soldier_prisonguard.mdl",
	Skin = 0,
	Weapons = { "weapon_smg1", "weapon_ar2" },
	KeyValues = { SquadName = "novaprospekt", Numgrenades = 5 }
}, "CombinePrison" )

AddNPC( {
	Name = "Prison Shotgun Guard",
	Class = "npc_combine_s",
	Category = Category,
	Model = "models/combine_soldier_prisonguard.mdl",
	Skin = 1,
	Weapons = { "weapon_shotgun" },
	KeyValues = { SquadName = "novaprospekt", Numgrenades = 5 }
}, "PrisonShotgunner" )

AddNPC( {
	Name = "Combine Elite",
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
	KeyValues = { SquadName = "overwatch" },
	NoDrop = true
} )

AddNPC( {
	Class = "npc_clawscanner",
	Category = Category,
	Offset = 20,
	KeyValues = { SquadName = "overwatch" },
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
	KeyValues = { squadname = "npc_stalker_squad" },
	Offset = 10
} )

AddNPC( {
	Class = "npc_manhack",
	Category = Category,
	KeyValues = { SquadName = "overwatch" },
	NoDrop = true
} )

if ( IsMounted( "ep2" ) ) then
	AddNPC( {
		Class = "npc_hunter",
		Category = Category,
		KeyValues = { SquadName = "overwatch" }
	} )
end


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
