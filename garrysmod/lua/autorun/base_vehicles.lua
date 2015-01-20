
-- Don't try to edit this file if you're trying to add new vehicles
-- Just make a new file and copy the format below.

local Category = "Half-Life 2"

local V = {
	-- Required information
	Name = "Jeep",
	Model = "models/buggy.mdl",
	Class = "prop_vehicle_jeep_old",
	Category = Category,

	-- Optional information
	Author = "VALVe",
	Information = "The regular old jeep",

	KeyValues = {
		vehiclescript = "scripts/vehicles/jeep_test.txt"
	}
}
list.Set( "Vehicles", "Jeep", V )

local V = {
	Name = "Airboat",
	Model = "models/airboat.mdl",
	Class = "prop_vehicle_airboat",
	Category = Category,

	Author = "VALVe",
	Information = "Airboat from Half-Life 2",

	KeyValues = {
		vehiclescript = "scripts/vehicles/airboat.txt"
	}
}
list.Set( "Vehicles", "Airboat", V )

local V = {
	Name = "Pod",
	Model = "models/vehicles/prisoner_pod_inner.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe",
	Information = "The Prisoner Pod",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	}
}
list.Set( "Vehicles", "Pod", V )

local V = {
	Name = "Jalopy",
	Model = "models/vehicle.mdl",
	Class = "prop_vehicle_jeep",
	Category = Category,

	Author = "VALVe",
	Information = "The muscle car from Episode 2",

	KeyValues = {
		vehiclescript = "scripts/vehicles/jalopy.txt"
	}
}
if ( IsMounted( "ep2" ) ) then list.Set( "Vehicles", "Jalopy", V ) end

local Category = "Chairs"

local function HandleRollercoasterAnimation( vehicle, player )
	return player:SelectWeightedSequence( ACT_GMOD_SIT_ROLLERCOASTER ) 
end

local V = {
	Name = "Wooden Chair",
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
}
list.Set( "Vehicles", "Chair_Wood", V )

local V = {
	Name = "Chair",
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
}
list.Set( "Vehicles", "Chair_Plastic", V )

local V = {
	Name = "Jeep Seat",
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
}
list.Set( "Vehicles", "Seat_Jeep", V )

local V = {
	Name = "Airboat Seat",
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
}
list.Set( "Vehicles", "Seat_Airboat", V )

local V = {
	Name = "Office Chair",
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
}
list.Set( "Vehicles", "Chair_Office1", V )

local V = {
	Name = "Big Office Chair",
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
}
list.Set( "Vehicles", "Chair_Office2", V )

local V = {
	Name = "Jalopy Seat",
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
}
if ( IsMounted( "ep2" ) ) then list.Set( "Vehicles", "Seat_Jalopy", V ) end

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

local V = {
	Name = "Car Seat",
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
}
list.Set( "Vehicles", "phx_seat", V )

local V = {
	Name = "Car Seat 2",
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
}
list.Set( "Vehicles", "phx_seat2", V )

local V = {
	Name = "Car Seat 3",
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
}
list.Set( "Vehicles", "phx_seat3", V )

-- Not adding this, because exit animation leaves you stuck in the middle
--[[local V = {
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
}
list.Set( "Vehicles", "phx_train", V )]]
