
-- Don't try to edit this file if you're trying to add new vehicles
-- Just make a new file and copy the format below.

local function AddVehicle( t, class )
	list.Set( "Vehicles", class, t )
end

local Category = "Half-Life 2"

AddVehicle( {
	-- Required information
	Name = "#HL2_Jeep",
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
	Name = "#HL2_Airboat",
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
	Name = "#HL2_Pod",
	Model = "models/vehicles/prisoner_pod_inner.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe",
	Information = "The Prisoner Pod",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	}
}, "Pod" )

if ( IsMounted( "ep2" ) ) then
	AddVehicle( {
		Name = "#Jalopy",
		Model = "models/vehicle.mdl",
		Class = "prop_vehicle_jeep",
		Category = Category,

		Author = "VALVe",
		Information = "The muscle car from Episode 2",

		KeyValues = {
			vehiclescript = "scripts/vehicles/jalopy.txt"
		}
	}, "Jalopy" )
end

Category = "Chairs"

local function HandleRollercoasterAnimation( vehicle, player )
	return player:SelectWeightedSequence( ACT_GMOD_SIT_ROLLERCOASTER )
end

AddVehicle( {
	Name = "#WoodenChair",
	Model = "models/nova/chair_wood01.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe",
	Information = "A Wooden Chair",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleRollercoasterAnimation,
	}
}, "Chair_Wood" )

AddVehicle( {
	Name = "#Chair",
	Model = "models/nova/chair_plastic01.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe",
	Information = "A Plastic Chair",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleRollercoasterAnimation,
	}
}, "Chair_Plastic" )

AddVehicle( {
	Name = "#JeepSeat",
	Model = "models/nova/jeep_seat.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe",
	Information = "A Seat from VALVe's Jeep",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleRollercoasterAnimation,
	}
}, "Seat_Jeep" )

AddVehicle( {
	Name = "#Seat_Airboat",
	Model = "models/nova/airboat_seat.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe",
	Information = "A Seat from VALVe's Airboat",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleRollercoasterAnimation,
	}
}, "Seat_Airboat" )

AddVehicle( {
	Name = "#Chair_Office1",
	Model = "models/nova/chair_office01.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe",
	Information = "A Small Office Chair",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleRollercoasterAnimation,
	}
}, "Chair_Office1" )

AddVehicle( {
	Name = "#Chair_Office2",
	Model = "models/nova/chair_office02.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe",
	Information = "A Big Office Chair",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleRollercoasterAnimation,
	}
}, "Chair_Office2" )

if ( IsMounted( "ep2" ) ) then
	AddVehicle( {
		Name = "#Seat_Jalopy",
		Model = "models/nova/jalopy_seat.mdl",
		Class = "prop_vehicle_prisoner_pod",
		Category = Category,

		Author = "VALVe",
		Information = "A Seat from VALVe's Jalopy",

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
	Name = "#CarSeat",
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
	Name = "#CarSeat2",
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
	Name = "#CarSeat3",
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

-- Not adding this, because exit animation leaves you stuck in the middle
--[[AddVehicle( {
	Name = "FSD Overrun",
	Model = "models/props_phx/trains/fsd-overrun2.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "PhoeniX-Storms",
	Information = "FSD Overrun Monorail",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandlePHXVehicleAnimation,
	}
}, "phx_train" )]]
