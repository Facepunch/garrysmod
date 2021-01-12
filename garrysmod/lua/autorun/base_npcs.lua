
-- Don't try to edit this file if you're trying to add new NPCs.
-- Just make a new file and copy the format below.

local function AddNPC( t, class )
	list.Set( "NPC", class or t.Class, t )
end



local Category = "Humans + Resistance"

AddNPC( {
	Name = "Alyx Vance",
	Class = "npc_alyx",
	Category = Category,
	Weapons = { "weapon_alyxgun", "weapon_smg1", "weapon_shotgun" },
	KeyValues = { SquadName = "resistance" }
} )

AddNPC( {
	Name = "Barney Calhoun",
	Class = "npc_barney",
	Category = Category,
	Weapons = { "weapon_smg1", "weapon_shotgun", "weapon_ar2" },
	KeyValues = { SquadName = "resistance" }
} )

AddNPC( {
	Name = "Wallace Breen",
	Class = "npc_breen",
	Category = Category
} )

AddNPC( {
	Name = "Dog",
	Class = "npc_dog",
	Category = Category
} )

AddNPC( {
	Name = "Eli Vance",
	Class = "npc_eli",
	Category = Category
} )

AddNPC( {
	Name = "G-Man",
	Class = "npc_gman",
	Category = Category
} )

-- Did you know that this MAN can shoot annabelle like he's been doing it his whole life?
AddNPC( {
	Name = "Dr. Isaac Kleiner",
	Class = "npc_kleiner",
	Category = Category
} )

AddNPC( {
	Name = "Dr. Judith Mossman",
	Class = "npc_mossman",
	Category = Category
} )

-- I don't trust these Vorts, but I'll let em stay in this category until they mess up
AddNPC( {
	Name = "Vortigaunt",
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
	Name = "Medic",
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

AddNPC( {
	Name = "Citizen",
	Class = "npc_citizen",
	Category = Category,
	KeyValues = { citizentype = CT_DOWNTRODDEN, SquadName = "resistance" },
	Weapons = { "" } -- Tells the spawnmenu that this NPC can use weapons
} )

if ( IsMounted( "ep2" ) ) then
	AddNPC( {
		Name = "Uriah",
		Class = "npc_vortigaunt",
		Category = Category,
		Model = "models/vortigaunt_doctor.mdl",
		KeyValues = { SquadName = "resistance" }
	}, "VortigauntUriah" )

	AddNPC( {
		Name = "Dr. Arne Magnusson",
		Class = "npc_magnusson",
		Category = Category
	} )
end

if ( IsMounted( "lostcoast" ) ) then
	AddNPC( {
		Name = "Fisherman",
		Class = "npc_fisherman",
		Category = Category,
		Weapons = { "weapon_oldmanharpoon" }
	} ) -- Has no death sequence
end



Category = "Zombies + Enemy Aliens"

AddNPC( {
	Name = "Zombie",
	Class = "npc_zombie",
	Category = Category,
	KeyValues = { SquadName = "zombies" }
} )

AddNPC( {
	Name = "Zombie Torso",
	Class = "npc_zombie_torso",
	Category = Category,
	KeyValues = { SquadName = "zombies" }
} )

AddNPC( {
	Name = "Poison Zombie",
	Class = "npc_poisonzombie",
	Category = Category,
	KeyValues = { SquadName = "poison" }
} )

AddNPC( {
	Name = "Antlion",
	Class = "npc_antlion",
	Category = Category,
	KeyValues = { SquadName = "antlions" }
} )

AddNPC( {
	Name = "Antlion Guard",
	Class = "npc_antlionguard",
	Category = Category,
	KeyValues = { SquadName = "antlions" }
} )

AddNPC( {
	Name = "Barnacle",
	Class = "npc_barnacle",
	Category = Category,
	OnCeiling = true,
	Offset = 2
} )

AddNPC( {
	Name = "Fast Zombie",
	Class = "npc_fastzombie",
	Category = Category,
	KeyValues = { SquadName = "zombies" }
} )

AddNPC( {
	Name = "Headcrab",
	Class = "npc_headcrab",
	Category = Category,
	KeyValues = { SquadName = "zombies" }
} )

AddNPC( {
	Name = "Poison Headcrab",
	Class = "npc_headcrab_black",
	Category = Category,
	KeyValues = { SquadName = "poison" }
} )

AddNPC( {
	Name = "Fast Headcrab",
	Class = "npc_headcrab_fast",
	Category = Category,
	KeyValues = { SquadName = "zombies" }
} )

AddNPC( {
	Name = "Fast Zombie Torso",
	Class = "npc_fastzombie_torso",
	Category = Category,
	KeyValues = { SquadName = "zombies" }
} )

if ( IsMounted( "episodic" ) ) then
	AddNPC( {
		Name = "Zombine",
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
		Name = "Antlion Grub",
		Class = "npc_antlion_grub",
		Category = Category,
			NoDrop = true,
			Offset = 1
	} )

	AddNPC( {
		Name = "Antlion Worker",
		Class = "npc_antlion_worker",
		Category = Category,
		KeyValues = { SquadName = "antlions" }
	} )
end



Category = "Animals"

AddNPC( {
	Name = "Father Grigori",
	Class = "npc_monk",
	Category = Category,
	Weapons = { "weapon_annabelle" }
} )

AddNPC( {
	Name = "Crow",
	Class = "npc_crow",
	Category = Category,
	NoDrop = true
} )

AddNPC( {
	Name = "Pigeon",
	Class = "npc_pigeon",
	Category = Category,
	NoDrop = true
} )

AddNPC( {
	Name = "Seagull",
	Class = "npc_seagull",
	Category = Category,
	NoDrop = true
} )



Category = "Combine"

AddNPC( {
	Name = "Metro Police",
	Class = "npc_metropolice",
	Category = Category,
	Weapons = { "weapon_stunstick", "weapon_pistol", "weapon_smg1" },
	SpawnFlags = SF_NPC_DROP_HEALTHKIT,
	KeyValues = { SquadName = "overwatch" }
} )

AddNPC( {
	Name = "Rollermine",
	Class = "npc_rollermine",
	Category = Category,
	Offset = 20,
	KeyValues = { SquadName = "overwatch" },
	NoDrop = true
} )

AddNPC( {
	Name = "Turret",
	Class = "npc_turret_floor",
	Category = Category,
	OnFloor = true,
	TotalSpawnFlags = 0,
	Rotate = Angle( 0, 180, 0 ),
	Offset = 2,
	KeyValues = { SquadName = "overwatch" }
} )

AddNPC( {
	Name = "Combine Soldier",
	Class = "npc_combine_s",
	Category = Category,
	Model = "models/combine_soldier.mdl",
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
	Weapons = { "weapon_ar2" },
	KeyValues = { Numgrenades = 10, SquadName = "overwatch" },
	SpawnFlags = SF_NPC_NO_PLAYER_PUSHAWAY
}, "CombineElite" )

AddNPC( {
	Name = "City Scanner",
	Class = "npc_cscanner",
	Category = Category,
	Offset = 20,
	KeyValues = { SquadName = "overwatch" },
	NoDrop = true
} )

AddNPC( {
	Name = "Shield Scanner",
	Class = "npc_clawscanner",
	Category = Category,
	Offset = 20,
	KeyValues = { SquadName = "overwatch" },
	NoDrop = true
} )

AddNPC( {
	Name = "Combine Gunship",
	Class = "npc_combinegunship",
	Category = Category,
	Offset = 300,
	KeyValues = { SquadName = "overwatch" },
	NoDrop = true
} )

AddNPC( {
	Name = "Combine Dropship",
	Class = "npc_combinedropship",
	Category = Category,
	Offset = 300,
	KeyValues = { SquadName = "overwatch" },
	NoDrop = true
} )

AddNPC( {
	Name = "Hunter-Chopper",
	Class = "npc_helicopter",
	Category = Category,
	Offset = 300,
	Health = 600,
	KeyValues = { SquadName = "overwatch" },
	NoDrop = true
} )

AddNPC( {
	Name = "Camera",
	Class = "npc_combine_camera",
	Category = Category,
	OnCeiling = true,
	Offset = 2,
	KeyValues = { SquadName = "overwatch" },
	NoDrop = true
} )

AddNPC( {
	Name = "Ceiling Turret",
	Class = "npc_turret_ceiling",
	Category = Category,
	SpawnFlags = 32, -- SF_NPC_TURRET_AUTOACTIVATE
	OnCeiling = true,
	Offset = 0,
	KeyValues = { SquadName = "overwatch" }
} )

AddNPC( {
	Name = "Strider",
	Class = "npc_strider",
	Category = Category,
	Offset = 100,
	KeyValues = { SquadName = "overwatch" }
} )

AddNPC( {
	Name = "Stalker",
	Class = "npc_stalker",
	Category = Category,
	KeyValues = { squadname = "npc_stalker_squad" },
	Offset = 10
} )

AddNPC( {
	Name = "Manhack",
	Class = "npc_manhack",
	Category = Category,
	KeyValues = { SquadName = "overwatch" },
	NoDrop = true
} )

if ( IsMounted( "ep2" ) ) then
	AddNPC( {
		Name = "Hunter",
		Class = "npc_hunter",
		Category = Category,
		KeyValues = { SquadName = "overwatch" }
	} )
end


if ( IsMounted( "hl1" ) || IsMounted( "hl1mp" ) ) then

	Category = "Half-Life: Source"

	AddNPC( { Name = "Alien Grunt", Class = "monster_alien_grunt", Category = Category } )
	AddNPC( { Name = "Nihilanth", Class = "monster_nihilanth", Category = Category, Offset = 1200, SpawnFlags = 262144, NoDrop = true } )
	AddNPC( { Name = "Tentacle", Class = "monster_tentacle", Category = Category } )
	AddNPC( { Name = "Alien Slave", Class = "monster_alien_slave", Category = Category } )
	AddNPC( { Name = "Gonarch", Class = "monster_bigmomma", Category = Category } )
	AddNPC( { Name = "Bullsquid", Class = "monster_bullchicken", Category = Category } )
	AddNPC( { Name = "Gargantua", Class = "monster_gargantua", Category = Category } )
	AddNPC( { Name = "Assassin", Class = "monster_human_assassin", Category = Category } )
	AddNPC( { Name = "Baby Crab", Class = "monster_babycrab", Category = Category } )
	AddNPC( { Name = "Grunt", Class = "monster_human_grunt", Category = Category } )
	AddNPC( { Name = "Cockroach", Class = "monster_cockroach", Category = Category } )
	AddNPC( { Name = "Houndeye", Class = "monster_houndeye", Category = Category } )
	AddNPC( { Name = "Scientist", Class = "monster_scientist", Category = Category, KeyValues = { body = "-1" } } )
	AddNPC( { Name = "Snark", Class = "monster_snark", Category = Category, Offset = 6, NoDrop = true } )
	AddNPC( { Name = "Zombie", Class = "monster_zombie", Category = Category } )
	AddNPC( { Name = "Headcrab", Class = "monster_headcrab", Category = Category } )
	AddNPC( { Name = "Controller", Class = "monster_alien_controller", Category = Category, NoDrop = true } )
	AddNPC( { Name = "Security Officer", Class = "monster_barney", Category = Category } )

	AddNPC( { Name = "Heavy Turret", Class = "monster_turret", Category = Category, Offset = 0, KeyValues = { orientation = 1 }, OnCeiling = true, SpawnFlags = 32 } )
	AddNPC( { Name = "Mini Turret", Class = "monster_miniturret", Category = Category, Offset = 0, KeyValues = { orientation = 1 }, OnCeiling = true, SpawnFlags = 32 } )
	AddNPC( { Name = "Sentry", Class = "monster_sentry", Category = Category, Offset = 0, OnFloor = true, SpawnFlags = 32 } )

end
