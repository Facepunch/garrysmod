
local function FindInTable( tab, find, parents, depth )

	depth = depth or 0
	parents = parents or ""
	
	if ( !istable( tab ) ) then return end
	if ( depth > 3 ) then return end
	depth = depth + 1
	
	for k, v in pairs ( tab ) do
	
		if ( type(k) == "string" ) then
		
			if ( k && k:lower():find( find:lower() ) ) then

				Msg("\t", parents, k, " - (", type(v), " - ", v, ")\n")
			
			end
			
			-- Recurse
			if ( istable(v) &&
				k != "_R" &&
				k != "_E" &&
				k != "_G" &&
				k != "_M" &&
				k != "_LOADED" &&
				k != "__index" ) then
				
				local NewParents = parents .. k .. ".";
				FindInTable( v, find, NewParents, depth )
			
			end
		
		end
	
	end

end


--[[---------------------------------------------------------
   Name:	Find
-----------------------------------------------------------]]   
local function Find( ply, command, arguments )

	if ( IsValid(ply) && ply:IsPlayer() && !ply:IsAdmin() ) then return end
	if ( !arguments[1] ) then return end
	
	if ( SERVER ) then 	Msg("Finding '", arguments[1], "' SERVERSIDE:\n\n") else
						Msg("Finding '", arguments[1], "' CLIENTSIDE:\n\n") end
	
	FindInTable( _G, arguments[1] )
	FindInTable( debug.getregistry(), arguments[1] )
	
	Msg("\n\n")
	
	if ( SERVER && IsValid(ply) && ply:IsPlayer() && ply:IsListenServerHost() ) then
		RunConsoleCommand( "lua_find_cl", tostring(arguments[1]) );
	end
	
end

if ( SERVER ) then
	concommand.Add( "lua_find", Find, nil, "", { FCVAR_DONTRECORD } )
else
	concommand.Add( "lua_find_cl", Find, nil, "", { FCVAR_DONTRECORD } )
end