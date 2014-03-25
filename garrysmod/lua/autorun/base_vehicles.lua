
-- Don't try to edit this file if you're trying to add new vehicles
-- Just make a new file and copy the format below.

local Category = "Half-Life 2"

local function HandleRollercoasterAnimation( vehicle, player )
	return player:SelectWeightedSequence( ACT_GMOD_SIT_ROLLERCOASTER ) 
end

local V = { 	
	-- Required information
	Name = "Jeep", 
	Class = "prop_vehicle_jeep_old",
	Category = Category,

	-- Optional information
	Author = "VALVe",
	Information = "The regular old jeep",
	Model = "models/buggy.mdl",

	KeyValues = {
		vehiclescript = "scripts/vehicles/jeep_test.txt"
	}
}
list.Set( "Vehicles", "Jeep", V )

local V = { 	
	-- Required information
	Name = "Airboat", 
	Class = "prop_vehicle_airboat",
	Category = Category,

	-- Optional information
	Author = "VALVe",
	Information = "Airboat from Half-Life 2",
	Model = "models/airboat.mdl",

	KeyValues = {
		vehiclescript = "scripts/vehicles/airboat.txt"
	}
}
list.Set( "Vehicles", "Airboat", V )

local V = { 	
	-- Required information
	Name = "Pod", 
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	-- Optional information
	Author = "VALVe",
	Information = "The Prisoner Pod",
	Model = "models/vehicles/prisoner_pod_inner.mdl",

	KeyValues = {
		vehiclescript	= "scripts/vehicles/prisoner_pod.txt",
		limitview		= "0"
	}
}
list.Set( "Vehicles", "Pod", V )

local V = { 	
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
}
if ( IsMounted( "ep2" ) ) then list.Set ( "Vehicles", "Jalopy", V ) end


local Category = "Chairs"

local V = { 	
	-- Required information
	Name = "Wooden Chair", 
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	-- Optional information
	Author = "VALVe",
	Information = "A Wooden Chair",
	Model = "models/nova/chair_wood01.mdl",
	KeyValues = {
		vehiclescript	= "scripts/vehicles/prisoner_pod.txt",
		limitview		= "0"
	},
	Members = {
		HandleAnimation = HandleRollercoasterAnimation,
	}
}
list.Set( "Vehicles", "Chair_Wood", V )

local V = { 	
	-- Required information
	Name = "Chair", 
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	-- Optional information
	Author = "VALVe",
	Information = "A Plastic Chair",
	Model = "models/nova/chair_plastic01.mdl",
	KeyValues = {
		vehiclescript	= "scripts/vehicles/prisoner_pod.txt",
		limitview		= "0"
	},
	Members = {
		HandleAnimation = HandleRollercoasterAnimation,
	}
}
list.Set( "Vehicles", "Chair_Plastic", V )

local V = { 	
	-- Required information
	Name = "Jeep Seat", 
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	-- Optional information
	Author = "VALVe",
	Information = "A Seat from VALVe's Jeep",
	Model = "models/nova/jeep_seat.mdl",
	KeyValues = {
		vehiclescript	= "scripts/vehicles/prisoner_pod.txt",
		limitview		= "0"
	},
	Members = {
		HandleAnimation = HandleRollercoasterAnimation,
	}
}
list.Set( "Vehicles", "Seat_Jeep", V )

local V = { 	
	-- Required information
	Name = "Airboat Seat", 
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	-- Optional information
	Author = "VALVe",
	Information = "A Seat from VALVe's Airboat",
	Model = "models/nova/airboat_seat.mdl",
	KeyValues = {
		vehiclescript	= "scripts/vehicles/prisoner_pod.txt",
		limitview		= "0"
	},
	Members = {
		HandleAnimation = HandleRollercoasterAnimation,
	}
}
list.Set( "Vehicles", "Seat_Airboat", V )

local V = { 	
	-- Required information
	Name = "Office Chair", 
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	-- Optional information
	Author = "VALVe",
	Information = "A Small Office Chair",
	Model = "models/nova/chair_office01.mdl",
	KeyValues = {
		vehiclescript	= "scripts/vehicles/prisoner_pod.txt",
		limitview		= "0"
	},
	Members = {
		HandleAnimation = HandleRollercoasterAnimation,
	}
}
list.Set( "Vehicles", "Chair_Office1", V )

local V = { 	
	-- Required information
	Name = "Big Office Chair", 
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	-- Optional information
	Author = "VALVe",
	Information = "A Big Office Chair",
	Model = "models/nova/chair_office02.mdl",
	KeyValues = {
		vehiclescript	= "scripts/vehicles/prisoner_pod.txt",
		limitview		= "0"
	},
	Members = {
		HandleAnimation = HandleRollercoasterAnimation,
	}
}
list.Set( "Vehicles", "Chair_Office2", V )

local V = { 	
	-- Required information
	Name = "Jalopy Seat", 
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	-- Optional information
	Author = "VALVe",
	Information = "A Seat from VALVe's Jalopy",
	Model = "models/nova/jalopy_seat.mdl",
	KeyValues = {
		vehiclescript	= "scripts/vehicles/prisoner_pod.txt",
		limitview		= "0"
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

local function HandlePHXVehicleAnimation( vehicle, player )
	return player:SelectWeightedSequence( ACT_DRIVE_JEEP ) 
end

local V = { 	
	Name = "Car Seat", 
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "PhoeniX-Storms",
	Information = "PHX Airboat Seat Sitting Animation",
	Model = "models/props_phx/carseat2.mdl",
	KeyValues = {
		vehiclescript	= "scripts/vehicles/prisoner_pod.txt",
		limitview		= "0"
	},
	Members = {
		HandleAnimation = HandlePHXSeatAnimation,
	}
}
list.Set( "Vehicles", "phx_seat", V )

local V = { 	
	Name = "Car Seat 2", 
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "PhoeniX-Storms",
	Information = "PHX Airboat Seat Driving Animation",
	Model = "models/props_phx/carseat3.mdl",
	KeyValues = {
		vehiclescript	= "scripts/vehicles/prisoner_pod.txt",
		limitview		= "0"
	},
	Members = {
		HandleAnimation = HandlePHXVehicleAnimation,
	}
}
list.Set( "Vehicles", "phx_seat2", V )

local V = { 	
	Name = "FSD Overrun", 
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "PhoeniX-Storms",
	Information = "FSD Overrun Monorail",
	Model = "models/props_phx/trains/fsd-overrun2.mdl",
	KeyValues = {
		vehiclescript	=	"scripts/vehicles/prisoner_pod.txt",
		limitview		=	"0"
	},
	Members = {
		HandleAnimation = HandlePHXVehicleAnimation,
	}
}

-- Not adding this, because exit animation leaves you stuck in the middle
-- list.Set( "Vehicles", "phx_train", V )
