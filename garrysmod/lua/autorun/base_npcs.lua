-- Don't try to edit this file if you're trying to add new NPCs.
-- Just make a new file and copy the format below.

local Category = "Humans + Resistance"

local NPC = {
	Name = "Alyx Vance",
	Class = "npc_alyx",
	Category = Category,
	Weapons = { "weapon_alyxgun", "weapon_smg1", "weapon_shotgun" }
}
list.Set( "NPC", NPC.Class, NPC )

local NPC = {
	Name = "Barney Calhoun",
	Class = "npc_barney",
	Category = Category,
	Weapons = { "weapon_smg1", "weapon_shotgun", "weapon_ar2" }
}
list.Set( "NPC", NPC.Class, NPC )

local NPC = {
	Name = "Wallace Breen",
	Class = "npc_breen",
	Category = Category
}
list.Set( "NPC", NPC.Class, NPC )

local NPC = {
	Name = "Dog",
	Class = "npc_dog",
	Category = Category
}
list.Set( "NPC", NPC.Class, NPC )

local NPC = {
	Name = "Eli Vance",
	Class = "npc_eli",
	Category = Category
}
list.Set( "NPC", NPC.Class, NPC )

local NPC = {
	Name = "G-Man",
	Class = "npc_gman",
	Category = Category
}
list.Set( "NPC", NPC.Class, NPC )

-- Did you know that this MAN can shoot annabelle like he's been doing it his whole life?
local NPC = {
	Name = "Dr. Isaac Kleiner",
	Class = "npc_kleiner",
	Category = Category
}
list.Set( "NPC", NPC.Class, NPC )

local NPC = {
	Name = "Dr. Judith Mossman",
	Class = "npc_mossman",
	Category = Category
}
list.Set( "NPC", NPC.Class, NPC )

-- I don't trust these Vorts, but I'll let em stay in this category until they mess up
local NPC = {
	Name = "Vortigaunt",
	Class = "npc_vortigaunt",
	Category = Category
}
list.Set( "NPC", NPC.Class, NPC )

local NPC = {
	Name = "Vortigaunt Slave",
	Class = "npc_vortigaunt",
	Category = Category,
	Model = "models/vortigaunt_slave.mdl"
}
list.Set( "NPC", "VortigauntSlave", NPC )

local NPC = {
	Name = "Rebel",
	Class = "npc_citizen",
	Category = Category,
	SpawnFlags = SF_CITIZEN_RANDOM_HEAD,
	KeyValues = { citizentype = CT_REBEL },
	Weapons = { "weapon_pistol", "weapon_ar2", "weapon_smg1", "weapon_ar2", "weapon_shotgun" }
}
list.Set( "NPC", "Rebel", NPC )

local NPC = {
	Name = "Odessa Cubbage",
	Class = "npc_citizen",
	Category = Category,
	Model = "models/odessa.mdl",
	KeyValues = { citizentype = CT_UNIQUE }
}
list.Set( "NPC", "npc_odessa", NPC )

local NPC = {
	Name = "Medic",
	Class = "npc_citizen",
	Category = Category,
	SpawnFlags = SF_CITIZEN_MEDIC,
	KeyValues = { citizentype = CT_REBEL },
	Weapons = { "weapon_pistol", "weapon_smg1", "weapon_ar2", "weapon_shotgun" }
}
list.Set( "NPC", "Medic", NPC )

local NPC = {
	Name = "Refugee",
	Class = "npc_citizen",
	Category = Category,
	KeyValues = { citizentype = CT_REFUGEE },
	Weapons = { "weapon_pistol", "weapon_smg1" }
}
list.Set( "NPC", "Refugee", NPC )

local NPC = {
	Name = "Citizen",
	Class = "npc_citizen",
	Category = Category,
	KeyValues = { citizentype = CT_DOWNTRODDEN }
}
list.Set( "NPC", NPC.Class, NPC )

if ( IsMounted( "ep2" ) ) then

	local NPC = {
		Name = "Uriah",
		Class = "npc_vortigaunt",
		Category = Category,
		Model = "models/vortigaunt_doctor.mdl"
	}
	list.Set( "NPC", "VortigauntUriah", NPC )

	local NPC = {
		Name = "Dr. Arne Magnusson",
		Class = "npc_magnusson",
		Category = Category
	}
	list.Set( "NPC", NPC.Class, NPC )

end

if ( IsMounted( "lostcoast" ) ) then
	local NPC = {
		Name = "Fisherman",
		Class = "npc_fisherman",
		Category = Category,
		Weapons = { "weapon_oldmanharpoon" }
	}
	list.Set( "NPC", NPC.Class, NPC ) -- Has no death sequence
end


Category = "Zombies + Enemy Aliens"

local NPC = {
	Name = "Zombie",
	Class = "npc_zombie",
	Category = Category
}
list.Set( "NPC", NPC.Class, NPC )

local NPC = {
	Name = "Zombie Torso",
	Class = "npc_zombie_torso",
	Category = Category
}
list.Set( "NPC", NPC.Class, NPC )

local NPC = {
	Name = "Poison Zombie",
	Class = "npc_poisonzombie",
	Category = Category
}
list.Set( "NPC", NPC.Class, NPC )

local NPC = {
	Name = "Antlion",
	Class = "npc_antlion",
	Category = Category
}
list.Set( "NPC", NPC.Class, NPC )

local NPC = {
	Name = "Antlion Guard",
	Class = "npc_antlionguard",
	Category = Category
}
list.Set( "NPC", NPC.Class, NPC )

local NPC = {
	Name = "Barnacle",
	Class = "npc_barnacle",
	Category = Category,
	OnCeiling = true,
	Offset = 2
}
list.Set( "NPC", NPC.Class, NPC )

local NPC = {
	Name = "Fast Zombie",
	Class = "npc_fastzombie",
	Category = Category
}
list.Set( "NPC", NPC.Class, NPC )

local NPC = {
	Name = "Headcrab",
	Class = "npc_headcrab",
	Category = Category
}
list.Set( "NPC", NPC.Class, NPC )

local NPC = {
	Name = "Poison Headcrab",
	Class = "npc_headcrab_black",
	Category = Category
}
list.Set( "NPC", NPC.Class, NPC )

local NPC = {
	Name = "Fast Headcrab",
	Class = "npc_headcrab_fast",
	Category = Category
}
list.Set( "NPC", NPC.Class, NPC )

local NPC = {
	Name = "Fast Zombie Torso",
	Class = "npc_fastzombie_torso",
	Category = Category
}
list.Set( "NPC", NPC.Class, NPC )

if ( IsMounted( "ep2" ) ) then
	local NPC = {
			Name = "Antlion Guardian",
			Class = "npc_antlionguard",
			Category = Category,
			KeyValues = { cavernbreed = 1, incavern = 1 },
			Material = "Models/antlion_guard/antlionGuard2"
	}
	list.Set( "NPC", "npc_antlionguardian", NPC )

	local NPC = {
		Name = "Antlion Grub",
		Class = "npc_antlion_grub",
		Category = Category,
			NoDrop = true,
			Offset = 1
	}
	list.Set( "NPC", NPC.Class, NPC )

	local NPC = {
		Name = "Antlion Worker",
		Class = "npc_antlion_worker",
		Category = Category
	}
	list.Set( "NPC", NPC.Class, NPC )
	game.AddParticles( "particles/antlion_worker.pcf" )
end

if ( IsMounted( "episodic" ) ) then
	local NPC = {
		Name = "Zombine",
		Class = "npc_zombine",
		Category = Category
	}
	list.Set( "NPC", NPC.Class, NPC )
end


Category = "Animals"

local NPC = {
	Name = "Father Grigori",
	Class = "npc_monk",
	Category = Category,
	Weapons = { "weapon_annabelle" }
}
list.Set( "NPC", NPC.Class, NPC )

local NPC = {
	Name = "Crow",
	Class = "npc_crow",
	Category = Category
}
list.Set( "NPC", NPC.Class, NPC )

local NPC = {
	Name = "Pigeon",
	Class = "npc_pigeon",
	Category = Category
}
list.Set( "NPC", NPC.Class, NPC )

local NPC = {
	Name = "Seagull",
	Class = "npc_seagull",
	Category = Category
}
list.Set( "NPC", NPC.Class, NPC )


Category = "Combine"

local NPC = {
	Name = "Metro Police",
	Class = "npc_metropolice",
	Category = Category,
	Weapons = { "weapon_stunstick", "weapon_pistol", "weapon_smg1" },
	SpawnFlags = 8,
	KeyValues = { SquadName = "overwatch" }
}
list.Set( "NPC", NPC.Class, NPC )

local NPC = {
	Name = "Rollermine",
	Class = "npc_rollermine",
	Category = Category,
	Offset = 16,
	KeyValues = { SquadName = "overwatch" }
}
list.Set( "NPC", NPC.Class, NPC )

local NPC = {
	Name = "Turret",
	Class = "npc_turret_floor",
	Category = Category,
	OnFloor = true,
	TotalSpawnFlags = 0,
	Rotate = Angle( 0, 180, 0 ),
	Offset = 2,
	KeyValues = { SquadName = "overwatch" }
}
list.Set( "NPC", NPC.Class, NPC )

local NPC = {
	Name = "Combine Soldier",
	Class = "npc_combine_s",
	Category = Category,
	Model = "models/combine_soldier.mdl",
	Weapons = { "weapon_smg1", "weapon_ar2" },
	KeyValues = { SquadName = "overwatch", Numgrenades = 5 }
}
list.Set( "NPC", NPC.Class, NPC )

local NPC = {
	Name = "Shotgun Soldier",
	Class = "npc_combine_s",
	Category = Category,
	Model = "models/combine_soldier.mdl",
	Skin = 1,
	Weapons = { "weapon_shotgun" },
	KeyValues = { SquadName = "overwatch", Numgrenades = 5 }
}
list.Set( "NPC", "ShotgunSoldier", NPC )

local NPC = {
	Name = "Prison Guard",
	Class = "npc_combine_s",
	Category = Category,
	Model = "models/combine_soldier_prisonguard.mdl",
	Weapons = { "weapon_smg1", "weapon_ar2" },
	KeyValues = { SquadName = "novaprospekt", Numgrenades = 5 }
}
list.Set( "NPC", "CombinePrison", NPC )

local NPC = {
	Name = "Prison Shotgun Guard",
	Class = "npc_combine_s",
	Category = Category,
	Model = "models/combine_soldier_prisonguard.mdl",
	Skin = 1,
	Weapons = { "weapon_shotgun" },
	KeyValues = { SquadName = "novaprospekt", Numgrenades = 5 }
}
list.Set( "NPC", "PrisonShotgunner", NPC )

local NPC = {
	Name = "Combine Elite",
	Class = "npc_combine_s",
	Category = Category,
	Model = "models/combine_super_soldier.mdl",
	Weapons = { "weapon_ar2" },
	KeyValues = { Numgrenades = 10, SquadName = "overwatch" },
	SpawnFlags = 16384
}
list.Set( "NPC", "CombineElite", NPC )

local NPC = {
	Name = "City Scanner",
	Class = "npc_cscanner",
	Category = Category,
	Offset = 20,
	KeyValues = { SquadName = "overwatch" }
}
list.Set( "NPC", NPC.Class, NPC )

local NPC = {
	Name = "Shield Scanner",
	Class = "npc_clawscanner",
	Category = Category,
	Offset = 20,
	KeyValues = { SquadName = "overwatch" }
}
list.Set( "NPC", NPC.Class, NPC )

local NPC = {
	Name = "Combine Gunship",
	Class = "npc_combinegunship",
	Category = Category,
	Offset = 300,
	KeyValues = { SquadName = "overwatch" }
}
list.Set( "NPC", NPC.Class, NPC )

local NPC = {
	Name = "Combine Dropship",
	Class = "npc_combinedropship",
	Category = Category,
	Offset = 300,
	KeyValues = { SquadName = "overwatch" }
}
list.Set( "NPC", NPC.Class, NPC )

local NPC = {
	Name = "Hunter-Chopper",
	Class = "npc_helicopter",
	Category = Category,
	Offset = 300,
	KeyValues = { SquadName = "overwatch" }
}
list.Set( "NPC", NPC.Class, NPC )

local NPC = {
	Name = "Camera",
	Class = "npc_combine_camera",
	Category = Category,
	OnCeiling = true,
	Offset = 2,
	KeyValues = { SquadName = "overwatch" }
}
list.Set( "NPC", NPC.Class, NPC )

local NPC = {
	Name = "Ceiling Turret",
	Class = "npc_turret_ceiling",
	Category = Category,
	SpawnFlags = 32, -- SF_NPC_TURRET_AUTOACTIVATE
	OnCeiling = true,
	Offset = 0,
	KeyValues = { SquadName = "overwatch" }
}
list.Set( "NPC", NPC.Class, NPC )

local NPC = {
	Name = "Strider",
	Class = "npc_strider",
	Category = Category,
	Offset = 100,
	KeyValues = { SquadName = "overwatch" }
}
list.Set( "NPC", NPC.Class, NPC )

local NPC = {
	Name = "Stalker",
	Class = "npc_stalker",
	Category = Category,
	KeyValues = { squadname = "npc_stalker_squad" },
	Offset = 10
}
list.Set( "NPC", NPC.Class, NPC )

local NPC = {
	Name = "Manhack",
	Class = "npc_manhack",
	Category = Category,
	KeyValues = { SquadName = "overwatch" }
}
list.Set( "NPC", NPC.Class, NPC )

if ( IsMounted( "ep2" ) ) then
	local NPC = {
		Name = "Hunter",
		Class = "npc_hunter",
		Category = Category,
		KeyValues = { SquadName = "overwatch" }
	}
	list.Set( "NPC", NPC.Class, NPC )
end

if ( IsMounted( "hl1" ) ) then

	Category = "Half-Life: Source"

	local NPC = { Name = "Alien Grunt", Class = "monster_alien_grunt", Category = Category } list.Set( "NPC", NPC.Class, NPC )
	local NPC = { Name = "Nihilanth", Class = "monster_nihilanth", Category = Category, Offset = 1200 } list.Set( "NPC", NPC.Class, NPC )
	local NPC = { Name = "Tentacle", Class = "monster_tentacle", Category = Category } list.Set( "NPC", NPC.Class, NPC )
	local NPC = { Name = "Alien Slave", Class = "monster_alien_slave", Category = Category } list.Set( "NPC", NPC.Class, NPC )
	local NPC = { Name = "Gonarch", Class = "monster_bigmomma", Category = Category } list.Set( "NPC", NPC.Class, NPC )
	local NPC = { Name = "Bullsquid", Class = "monster_bullchicken", Category = Category	} list.Set( "NPC", NPC.Class, NPC )
	local NPC = { Name = "Gargantua", Class = "monster_gargantua", Category = Category } list.Set( "NPC", NPC.Class, NPC )
	local NPC = { Name = "Assassin", Class = "monster_human_assassin", Category = Category } list.Set( "NPC", NPC.Class, NPC )
	local NPC = { Name = "Baby Crab", Class = "monster_babycrab", Category = Category } list.Set( "NPC", NPC.Class, NPC )
	local NPC = { Name = "Grunt", Class = "monster_human_grunt", Category = Category } list.Set( "NPC", NPC.Class, NPC )
	local NPC = { Name = "Cockroach", Class = "monster_cockroach", Category = Category } list.Set( "NPC", NPC.Class, NPC )
	local NPC = { Name = "Houndeye", Class = "monster_houndeye", Category = Category } list.Set( "NPC", NPC.Class, NPC )
	local NPC = { Name = "Scientist", Class = "monster_scientist", Category = Category } list.Set( "NPC", NPC.Class, NPC )
	local NPC = { Name = "Snark", Class = "monster_snark", Category = Category } list.Set( "NPC", NPC.Class, NPC )
	local NPC = { Name = "Zombie", Class = "monster_zombie", Category = Category } list.Set( "NPC", NPC.Class, NPC )
	local NPC = { Name = "Headcrab", Class = "monster_headcrab", Category = Category } list.Set( "NPC", NPC.Class, NPC )
	local NPC = { Name = "Controller", Class = "monster_alien_controller", Category = Category } list.Set( "NPC", NPC.Class, NPC )
	local NPC = { Name = "Security Officer", Class = "monster_barney", Category = Category } list.Set( "NPC", NPC.Class, NPC )

	--local NPC = { Name = "Turret", Class = "monster_turret", Category = Category } list.Set( "NPC", NPC.Class, NPC )
	--local NPC = { Name = "Mini Turret", Class = "monster_miniturret", Category = Category } list.Set( "NPC", NPC.Class, NPC )
	--local NPC = { Name = "Sentry", Class = "monster_sentry", Category = Category, Offset = -20, OnFloor = true } list.Set( "NPC", NPC.Class, NPC )

end
