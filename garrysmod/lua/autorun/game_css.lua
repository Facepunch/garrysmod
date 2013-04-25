

if ( !IsMounted( "cstrike" ) ) then return end

local function AddPlayerModel( name, model )

	list.Set( "PlayerOptionsModel", name, model )
	player_manager.AddValidModel( name, model )
	
end


AddPlayerModel( "s_hostage_01", "models/player/hostage/hostage_01.mdl" )
AddPlayerModel( "s_hostage_02", "models/player/hostage/hostage_02.mdl" )
AddPlayerModel( "s_hostage_03", "models/player/hostage/hostage_03.mdl" )
AddPlayerModel( "s_hostage_04", "models/player/hostage/hostage_04.mdl" )

AddPlayerModel( "arctic",		"models/player/arctic.mdl" )
player_manager.AddValidHands( "arctic",			"models/weapons/c_arms_cstrike.mdl",		0,		"10000000" )

AddPlayerModel( "gasmask",		"models/player/gasmask.mdl" )
player_manager.AddValidHands( "gasmask",		"models/weapons/c_arms_cstrike.mdl",		1,		"10000000" )

AddPlayerModel( "guerilla",		"models/player/guerilla.mdl" )
player_manager.AddValidHands( "guerilla",		"models/weapons/c_arms_cstrike.mdl",		2,		"10000000" )

AddPlayerModel( "leet",			"models/player/leet.mdl" )
player_manager.AddValidHands( "leet",			"models/weapons/c_arms_cstrike.mdl",		3,		"10000000" )

AddPlayerModel( "phoenix",		"models/player/phoenix.mdl" )
player_manager.AddValidHands( "phoenix",		"models/weapons/c_arms_cstrike.mdl",		4,		"10000000" )

AddPlayerModel( "riot",			"models/player/riot.mdl" )
player_manager.AddValidHands( "riot",			"models/weapons/c_arms_cstrike.mdl",		5,		"10000000" )

AddPlayerModel( "swat",			"models/player/swat.mdl" )
player_manager.AddValidHands( "swat",			"models/weapons/c_arms_cstrike.mdl",		6,		"10000000" )

AddPlayerModel( "urban",		"models/player/urban.mdl" )
player_manager.AddValidHands( "urban",			"models/weapons/c_arms_cstrike.mdl",		7,		"10000000" )