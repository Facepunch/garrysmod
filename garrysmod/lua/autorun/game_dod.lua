

if ( !IsMounted( "dod" ) ) then return end

---Americans
list.Set( "PlayerOptionsModel", "american_assault", "models/player/dod_american.mdl" )
player_manager.AddValidModel( "american_assault", "models/player/dod_american.mdl" )
player_manager.AddValidHands( "american_assault",			"models/weapons/c_arms_dod.mdl",		0,		"10000000" )

---German
list.Set( "PlayerOptionsModel", "german_assault", "models/player/dod_german.mdl" )
player_manager.AddValidModel( "german_assault", "models/player/dod_german.mdl" )
player_manager.AddValidHands( "german_assault",			"models/weapons/c_arms_dod.mdl",		1,		"10000000" )
