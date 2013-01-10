

if ( !IsMounted( "ep2" ) ) then return end

--
-- Strider Buster
--

local Category = "Half-Life 2"


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
															AdminOnly = false,
															Information = "The strider bustin' Magnusson Device from HL2: Episode 2"
														} )

--
-- NPC's
--

Category = "Humans + Resistance"
	list.Set( "NPC", "npc_magnusson",		{ Name = "Dr.Magnusson",		Class = "npc_magnusson",			Category = Category	} )

Category = "Zombies + Enemy Aliens"
	list.Set( "NPC",  "npc_zombine",		{ Name = "Zombine",				Class = "npc_zombine",				Category = Category	} )
	list.Set( "NPC", "npc_antlion_worker",	{ Name = "Antlion Worker",		Class = "npc_antlion_worker",		Category = Category	} )
	list.Set( "NPC", "npc_antlion_grub",	{ Name = "Antlion Grub",		Class = "npc_antlion_grub",			Category = Category,	NoDrop = true, Offset = 1 } )

Category = "Combine"
	list.Set( "NPC", "npc_hunter",			{ Name = "Hunter", Class = "npc_hunter", Category = Category } )
								
								
--
-- Player Models
--

list.Set( "PlayerOptionsModel", "magnusson", "models/player/magnusson.mdl" )
player_manager.AddValidModel( "magnusson", "models/player/magnusson.mdl" )

list.Set( "zombine", "models/player/zombie_soldier.mdl" )
player_manager.AddValidModel( "zombine",	"models/player/zombie_soldier.mdl" )
--
-- Vehicles
--

list.Set( "Vehicles", "Jalopy", { 	
									-- Required information
									Name = "Jalopy", 
									Class = "prop_vehicle_jeep",
									Category = "Half-Life 2",

									-- Optional information
									Author = "VALVe",
									Information = "The muscle car from Episode 2",
									Model = "models/vehicle.mdl",
									
									KeyValues = {
													vehiclescript	=	"scripts/vehicles/jalopy.txt"
												}
								} )