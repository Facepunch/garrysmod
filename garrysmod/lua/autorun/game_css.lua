

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
AddPlayerModel( "gasmask",		"models/player/gasmask.mdl" )
AddPlayerModel( "guerilla",		"models/player/guerilla.mdl" )
AddPlayerModel( "leet",			"models/player/leet.mdl" )
AddPlayerModel( "phoenix",		"models/player/phoenix.mdl" )
AddPlayerModel( "riot",			"models/player/riot.mdl" )
AddPlayerModel( "swat",			"models/player/swat.mdl" )
AddPlayerModel( "urban",		"models/player/urban.mdl" )