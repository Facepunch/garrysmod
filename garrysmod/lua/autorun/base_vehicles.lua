
-- Don't try to edit this file if you're trying to add new vehicles
-- Just make a new file and copy the format below.

local function AddVehicle( t, class )
	list.Set( "Vehicles", class, t )
end

local Category = "Half-Life 2"

AddVehicle( {
	-- Required information
	Name = "#spawnmenu.vehicle.jeep",
	Model = "models/buggy.mdl",
	Class = "prop_vehicle_jeep_old",
	Category = Category,

	-- Optional information
	Author = "VALVe",
	Information = "The regular old jeep",

	KeyValues = {
		vehiclescript = "scripts/vehicles/jeep_test.txt"
	}
}, "Jeep" )

AddVehicle( {
	Name = "#spawnmenu.vehicle.airboat",
	Model = "models/airboat.mdl",
	Class = "prop_vehicle_airboat",
	Category = Category,

	Author = "VALVe",
	Information = "Airboat from Half-Life 2",

	KeyValues = {
		vehiclescript = "scripts/vehicles/airboat.txt"
	}
}, "Airboat" )

AddVehicle( {
	Name = "#spawnmenu.vehicle.prisoner_pod",
	Model = "models/vehicles/prisoner_pod_inner.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe",
	Information = "The prisoner pod",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	}
}, "Pod" )

AddVehicle( {
	Name = "#spawnmenu.vehicle.jalopy",
	Model = "models/vehicle.mdl",
	Class = "prop_vehicle_jeep",
	Category = Category,

	Author = "VALVe",
	Information = "The muscle car from Episode 2",

	KeyValues = {
		vehiclescript = "scripts/vehicles/jalopy.txt"
	}
}, "Jalopy" )

Category = "#spawnmenu.category.chairs"

local function HandleRollercoasterAnimation( vehicle, player )
	return player:SelectWeightedSequence( ACT_GMOD_SIT_ROLLERCOASTER )
end

AddVehicle( {
	Name = "#spawnmenu.chair.wooden",
	Model = "models/nova/chair_wood01.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe",
	Information = "A wooden chair",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleRollercoasterAnimation,
	}
}, "Chair_Wood" )

AddVehicle( {
	Name = "#spawnmenu.chair.plastic",
	Model = "models/nova/chair_plastic01.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe",
	Information = "A plastic chair",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleRollercoasterAnimation,
	}
}, "Chair_Plastic" )

AddVehicle( {
	Name = "#spawnmenu.chair.office",
	Model = "models/nova/chair_office01.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe",
	Information = "A small office chair",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleRollercoasterAnimation,
	}
}, "Chair_Office1" )

AddVehicle( {
	Name = "#spawnmenu.chair.office_big",
	Model = "models/nova/chair_office02.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe",
	Information = "A big office chair",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleRollercoasterAnimation,
	}
}, "Chair_Office2" )

AddVehicle( {
	Name = "#spawnmenu.seat.jeep",
	Model = "models/nova/jeep_seat.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe",
	Information = "A seat from VALVe's Jeep",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleRollercoasterAnimation,
	}
}, "Seat_Jeep" )

AddVehicle( {
	Name = "#spawnmenu.seat.airboat",
	Model = "models/nova/airboat_seat.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe",
	Information = "A seat from VALVe's Airboat",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleRollercoasterAnimation,
	}
}, "Seat_Airboat" )

if ( IsMounted( "ep2" ) ) then
	AddVehicle( {
		Name = "#spawnmenu.seat.jalopy",
		Model = "models/nova/jalopy_seat.mdl",
		Class = "prop_vehicle_prisoner_pod",
		Category = Category,

		Author = "VALVe",
		Information = "A seat from VALVe's Jalopy",

		KeyValues = {
			vehiclescript = "scripts/vehicles/prisoner_pod.txt",
			limitview = "0"
		},
		Members = {
			HandleAnimation = HandleRollercoasterAnimation,
		}
	}, "Seat_Jalopy" )
end

-- PhoeniX-Storms Vehicles

local function HandlePHXSeatAnimation( vehicle, player )
	return player:SelectWeightedSequence( ACT_HL2MP_SIT )
end
local function HandlePHXVehicleAnimation( vehicle, ply )
	return ply:SelectWeightedSequence( ACT_DRIVE_JEEP )
end
local function HandlePHXAirboatAnimation( vehicle, ply )
	return ply:SelectWeightedSequence( ACT_DRIVE_AIRBOAT )
end

AddVehicle( {
	Name = "#spawnmenu.seat.simple_sit",
	Model = "models/props_phx/carseat2.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "PhoeniX-Storms",
	Information = "PHX Airboat Seat with Sitting Animation",
	Offset = 16,

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandlePHXSeatAnimation,
	}
}, "phx_seat" )

AddVehicle( {
	Name = "#spawnmenu.seat.simple_jeep",
	Model = "models/props_phx/carseat3.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "PhoeniX-Storms",
	Information = "PHX Airboat Seat with Jeep animations",
	Offset = 16,

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandlePHXVehicleAnimation,
	}
}, "phx_seat2" )

AddVehicle( {
	Name = "#spawnmenu.seat.simple_airboat",
	Model = "models/props_phx/carseat2.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "PhoeniX-Storms",
	Information = "PHX Airboat Seat with Airboat animations",
	Offset = 16,

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandlePHXAirboatAnimation,
	}
}, "phx_seat3" )
