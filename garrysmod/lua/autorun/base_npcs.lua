
--
-- Don't try to edit this file if you're trying to add new NPCs.
-- Just make a new file and copy the format below.
--

local Category = "Humans + Resistance"

local NPC = { 	Name = "Alyx Vance", 
				Class = "npc_alyx",
				Weapons = { "weapon_alyxgun", "weapon_smg1" },
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )


local NPC = { 	Name = "Barney", 
				Class = "npc_barney",
				Weapons = { "weapon_pistol", "weapon_smg1" },
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )


local NPC = { 	Name = "Wallace Breen", 
				Class = "npc_breen",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )

local NPC = { 	Name = "Dog", 
				Class = "npc_dog",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )

local NPC = { 	Name = "Eli Vance", 
				Class = "npc_eli",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )

local NPC = { 	Name = "G-Man", 
				Class = "npc_gman",
				Weapons = { "weapon_pistol", "weapon_smg1" },
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )

local NPC = { 	Name = "Dr. Kleiner", 
				Class = "npc_kleiner",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )

local NPC = { 	Name = "Metro Police", 
				Class = "npc_metropolice",
				Weapons = { "weapon_stunstick", "weapon_pistol" },
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )

local NPC = { 	Name = "Mossman", 
				Class = "npc_mossman",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )

-- I don't trust these Vorts, but I'll let em stay in this category until they mess up
local NPC = { 	Name = "Vortigaunt", 
				Class = "npc_vortigaunt",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )

local NPC = { 	Name = "Rebel", 
				Class = "npc_citizen",
				SpawnFlags = SF_CITIZEN_RANDOM_HEAD,
				KeyValues = { citizentype = CT_REBEL },
				Weapons = { "weapon_pistol", "weapon_smg1" },
				Category = Category	}

list.Set( "NPC", "Rebel", NPC )

list.Set("NPC", "npc_odessa", 
{
	Name = "Odessa",
	Class = "npc_citizen",
	Category = Category,
	Model = "models/odessa.mdl",
	KeyValues = {citizentype = CT_UNIQUE}
})

local NPC = { 	Name = "Medic", 
				Class = "npc_citizen",
				SpawnFlags = SF_CITIZEN_MEDIC,
				KeyValues = { citizentype = CT_REBEL },
				Weapons = { "weapon_pistol", "weapon_smg1" },
				Category = Category	}

list.Set( "NPC", "Medic", NPC )

local NPC = { 	Name = "Refugee", 
				Class = "npc_citizen",
				KeyValues = { citizentype = CT_REFUGEE },
				Weapons = { "weapon_pistol", "weapon_smg1" },
				Category = Category	}

list.Set( "NPC", "Refugee", NPC )

local NPC = { 	Name = "Citizen", 
				Class = "npc_citizen",
				KeyValues = { citizentype = CT_DOWNTRODDEN },
				Weapons = { "weapon_pistol", "weapon_smg1" },
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )

-- Lost Coast
list.Set("NPC", "npc_fisherman", 
{
	Name = "Fisherman",
	Class = "npc_fisherman",
	Weapons = {"weapon_oldmanharpoon"},
	Category = Category
})

Category = "Zombies + Enemy Aliens"

local NPC = { 	Name = "Zombie", 
				Class = "npc_zombie",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )


local NPC = { 	Name = "Zombie Torso", 
				Class = "npc_zombie_torso",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )


local NPC = { 	Name = "Poison Zombie", 
				Class = "npc_poisonzombie",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )


local NPC = { 	Name = "Antlion", 
				Class = "npc_antlion",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )

local NPC = { 	Name = "Antlion Guard", 
				Class = "npc_antlionguard",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )


local NPC = { 	Name = "Barnacle", 
				Class = "npc_barnacle",
				OnCeiling = true,
				Offset = 2,
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )


local NPC = { 	Name = "Fast Zombie", 
				Class = "npc_fastzombie",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )

local NPC = { 	Name = "Fast Zomb Torso", 
				Class = "npc_fastzombie_torso",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )


local NPC = { 	Name = "Headcrab", 
				Class = "npc_headcrab",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )


local NPC = { 	Name = "Headcrab Black", 
				Class = "npc_headcrab_black",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )


local NPC = { 	Name = "Headcrab Fast", 
				Class = "npc_headcrab_fast",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )





Category = "Animals"

local NPC = { 	Name = "Crow", 
				Class = "npc_crow",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )


local NPC = { 	Name = "Pigeon", 
				Class = "npc_pigeon",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )


local NPC = { 	Name = "Seagull", 
				Class = "npc_seagull",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )


-- Countdown to "This is in the wrong category" emails, prompted by this hilarious joke

local NPC = { 	Name = "Father Grigori", 
				Class = "npc_monk",
				Weapons = { "weapon_annabelle", "weapon_pistol", "weapon_smg1" },
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )



Category = "Combine"

local NPC = { 	Name = "Rollermine", 
				Class = "npc_rollermine",
				Offset = 16,
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )

local NPC = { 	Name = "Turret", 
				Class = "npc_turret_floor",
				OnFloor = true,
				TotalSpawnFlags = 0,
				Rotate = Angle( 0, 180, 0 ),
				Offset = 2,
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )

local NPC = { 	Name = "Combine Soldier", 
				Class = "npc_combine_s",
				Model = "models/combine_soldier.mdl",
				Weapons = { "weapon_smg1" },
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )



local NPC = { 	Name = "Prison Guard", 
				Class = "npc_combine_s",
				Model = "models/combine_soldier_prisonguard.mdl",
				Weapons = { "weapon_shotgun" },
				Category = Category	}

list.Set( "NPC", "CombinePrison", NPC )



local NPC = { 	Name = "Combine Elite", 
				Class = "npc_combine_s",
				Model = "models/combine_super_soldier.mdl",
				Weapons = { "weapon_ar2" },
				Category = Category	}

list.Set( "NPC", "CombineElite", NPC )



local NPC = { 	Name = "City Scanner", 
				Class = "npc_cscanner",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )

list.Set( "NPC", "npc_combinegunship", 
{	
	Name = "Combine Gunship", 
	Class = "npc_combinegunship",
	Category = Category,
	Offset = 300,
})

/*
list.Set( "NPC", "npc_sniper", 
{	
	Name = "Sniper", 
	Class = "npc_sniper",
	Category = Category,
	Offset = 10,
})
*/

list.Set( "NPC", "npc_combine_camera", 
{	
	Name = "Camera", 
	Class = "npc_combine_camera",
	Category = Category,
	OnCeiling = true,
	Offset = 2,
})

list.Set( "NPC", "NPC_turret_ceiling", 
{	
	Name = "Ceiling Turret", 
	Class = "npc_turret_ceiling",
	Category = Category,
	SpawnFlags = 32, // SF_NPC_TURRET_AUTOACTIVATE
	OnCeiling = true,
	Offset = 0,
})

list.Set( "NPC", "npc_clawscanner", 
{	
	Name = "Claw Scanner", 
	Class = "npc_clawscanner",
	Category = Category,
	Offset = 20,
})

list.Set( "NPC", "npc_combinedropship", 
{	
	Name = "Dropship", 
	Class = "npc_combinedropship",
	Category = Category,
	Offset = 300,
})

list.Set( "NPC", "npc_helicopter", 
{	
	Name = "Helicopter", 
	Class = "npc_helicopter",
	Category = Category,
	Offset = 300,
})

list.Set( "NPC", "npc_stalker", 
{	
	Name = "Stalker", 
	Class = "npc_stalker",
	Category = Category,
	Offset = 10,
})

list.Set( "NPC", "npc_strider", 
{	
	Name = "Strider", 
	Class = "npc_strider",
	Category = Category,
	Offset = 100,
})






local NPC = { 	Name = "Manhack", 
				Class = "npc_manhack",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )


if ( IsMounted( "hl1" ) ) then

	Category = "Half-Life: Source"

	local NPC = { Name = "Alien Grunt", Class = "monster_alien_grunt", Category = Category	}; list.Set( "NPC", NPC.Class, NPC )
	local NPC = { Name = "Nihilanth", Class = "monster_nihilanth", Category = Category, Offset = 1200 }; list.Set( "NPC", NPC.Class, NPC )
	local NPC = { Name = "Tentacle", Class = "monster_tentacle", Category = Category }; list.Set( "NPC", NPC.Class, NPC )
	local NPC = { Name = "Alien Slave", Class = "monster_alien_slave", Category = Category }; list.Set( "NPC", NPC.Class, NPC )
	local NPC = { Name = "Big Momma", Class = "monster_bigmomma", Category = Category	}; list.Set( "NPC", NPC.Class, NPC )
	local NPC = { Name = "Bull Chicken", Class = "monster_bullchicken", Category = Category	}; list.Set( "NPC", NPC.Class, NPC )
	local NPC = { Name = "Gargantua", Class = "monster_gargantua", Category = Category	}; list.Set( "NPC", NPC.Class, NPC )
	local NPC = { Name = "Assassin", Class = "monster_human_assassin", Category = Category	}; list.Set( "NPC", NPC.Class, NPC )
	local NPC = { Name = "Baby Crab", Class = "monster_babycrab", Category = Category	}; list.Set( "NPC", NPC.Class, NPC )
	local NPC = { Name = "Grunt", Class = "monster_human_grunt", Category = Category	}; list.Set( "NPC", NPC.Class, NPC )
	local NPC = { Name = "Cockroach", Class = "monster_cockroach", Category = Category	}; list.Set( "NPC", NPC.Class, NPC )
	local NPC = { Name = "Houndeye", Class = "monster_houndeye", Category = Category	}; list.Set( "NPC", NPC.Class, NPC )
	local NPC = { Name = "Scientist", Class = "monster_scientist", Category = Category	}; list.Set( "NPC", NPC.Class, NPC )
	local NPC = { Name = "Snark", Class = "monster_snark", Category = Category	}; list.Set( "NPC", NPC.Class, NPC )
	local NPC = { Name = "Zombie", Class = "monster_zombie", Category = Category	}; list.Set( "NPC", NPC.Class, NPC )
	local NPC = { Name = "Headcrab", Class = "monster_headcrab", Category = Category	}; list.Set( "NPC", NPC.Class, NPC )
	local NPC = { Name = "Controller", Class = "monster_alien_controller", Category = Category	}; list.Set( "NPC", NPC.Class, NPC )
	local NPC = { Name = "Barney", Class = "monster_barney", Category = Category	}; list.Set( "NPC", NPC.Class, NPC )
	
	--local NPC = { Name = "Turret", Class = "monster_turret", Category = Category	}; list.Set( "NPC", NPC.Class, NPC )
	--local NPC = { Name = "Mini Turret", Class = "monster_miniturret", Category = Category	}; list.Set( "NPC", NPC.Class, NPC )
	--local NPC = { Name = "Sentry", Class = "monster_sentry", Category = Category, Offset = -20, OnFloor = true	}; list.Set( "NPC", NPC.Class, NPC )

end