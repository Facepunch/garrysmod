
if ( !IsMounted( "ep2" ) ) then return end

--
-- NPC's
--

local Category = "Humans + Resistance"
list.Set( "NPC", "npc_magnusson",		{ Name = "Dr.Magnusson",		Class = "npc_magnusson",		Category = Category	} )

Category = "Zombies + Enemy Aliens"
list.Set( "NPC", "npc_zombine",			{ Name = "Zombine",				Class = "npc_zombine",			Category = Category	} )
list.Set( "NPC", "npc_antlion_worker",	{ Name = "Antlion Worker",		Class = "npc_antlion_worker",	Category = Category	} )
list.Set( "NPC", "npc_antlion_grub",	{ Name = "Antlion Grub",		Class = "npc_antlion_grub",		Category = Category, NoDrop = true, Offset = 1 } )
list.Set( "NPC", "npc_antlionguardian", { Name = "Antlion Guardian",	Class = "npc_antlionguard",		Category = Category, KeyValues = { cavernbreed = 1, incavern = 1 },	Material = "Models/antlion_guard/antlionGuard2" } )

Category = "Combine"
list.Set( "NPC", "npc_hunter",			{ Name = "Hunter", Class = "npc_hunter", Category = Category } )

--
-- Strider Buster
--

Category = "Half-Life 2"

game.AddParticles( "particles/striderbuster.pcf" )

list.Set( "SpawnableEntities", "weapon_striderbuster", { 	
	-- Required information
	PrintName = "Magnusson", 
	ClassName = "weapon_striderbuster",
	Category = Category,

	-- Optional information
	NormalOffset = 32,
	DropToFloor = true,
	Author = "VALVe",
	Information = "The strider bustin' Magnusson Device from HL2: Episode 2"
} )

--
-- Vehicles
--

list.Set( "Vehicles", "Jalopy", { 	
	-- Required information
	Name = "Jalopy", 
	Class = "prop_vehicle_jeep",
	Category = Category,

	-- Optional information
	Author = "VALVe",
	Information = "The muscle car from Episode 2",
	Model = "models/vehicle.mdl",
									
	KeyValues = {
		vehiclescript = "scripts/vehicles/jalopy.txt"
	}
} )
