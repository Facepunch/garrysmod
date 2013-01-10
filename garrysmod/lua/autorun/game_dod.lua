

if ( !IsMounted( "dods" ) ) then return end

---Americans
list.Set( "PlayerOptionsModel", "american_assault", "models/player/dod_american.mdl" )
player_manager.AddValidModel( "american_assault", "models/player/dod_american.mdl" )

---German
list.Set( "PlayerOptionsModel", "german_assault", "models/player/dod_german.mdl" )
player_manager.AddValidModel( "german_assault", "models/player/dod_german.mdl" )
