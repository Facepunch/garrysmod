
MsgN( "Running Server In Test Mode" )

RunConsoleCommand( "bot_flipout", "1" );
RunConsoleCommand( "sbox_godmode", "0" );
RunConsoleCommand( "hostname", "DEDICATED SERVER TEST" );

--
-- Spawn Bots
--
for i=1, 24 do
	
	timer.Simple( math.Rand( 1, 50 ), function() RunConsoleCommand( "bot" ) end );
		
end

--
-- Spawn Props
--
for i=1, 500 do

	timer.Simple( math.Rand( 5, 50 ), function() 

		local ply = table.Random( player.GetAll() )
		if ( ply ) then
			GMODSpawnProp( ply, "models/props_junk/watermelon01.mdl", 0, "" )
		end
	
	end );

end

--
-- Randomly drop weapons (has the effect of swapping weapons
--
for i=1, 200 do

	timer.Simple( math.Rand( 5, 50 ), function() 

		local ply = table.Random( player.GetAll() )
		if ( IsValid(ply) && IsValid( ply:GetActiveWeapon() ) ) then
			ply:DropWeapon( ply:GetActiveWeapon() )
		end
	
	end );

end

timer.Simple( 60, function() engine.CloseServer(); end );