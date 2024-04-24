
local function FindInTable( tab, find, parents, depth )

	depth = depth or 0
	parents = parents or ""

	if ( !istable( tab ) ) then return end
	if ( depth > 3 ) then return end
	depth = depth + 1

	for k, v in pairs ( tab ) do

		if ( isstring( k ) ) then

			if ( k and k:lower():find( find:lower() ) ) then

				Msg( "\t", parents, k, " - (", type( v ), " - ", v, ")\n" )

			end

			-- Recurse
			if ( istable( v ) and
				k != "_R" and
				k != "_E" and
				k != "_G" and
				k != "_M" and
				k != "_LOADED" and
				k != "__index" ) then

				local NewParents = parents .. k .. "."
				FindInTable( v, find, NewParents, depth )

			end

		end

	end

end

local function FindInHooks( base, name )

	for b, t in pairs( hook.GetTable() ) do

		local head = true

		if ( istable( t ) and b:lower():find( base:lower() ) ) then

			for n, f in pairs( t ) do

				if ( !name or tostring( n ):lower():find( tostring( name ):lower() ) ) then

					if ( head ) then Msg( "\n\t", b, " hooks:\n" ) head = false end

					Msg( "\t\t", tostring( n ), " - (", tostring( f ), ")\n" )

				end

			end

		end

	end

end

local function UTIL_IsCommandIssuedByServerAdmin( ply )
	if ( game.SinglePlayer() ) then return true end -- Singleplayer
	if ( !IsValid( ply ) ) then return SERVER end -- Dedicated server console

	return ply:IsListenServerHost() -- Only if we are a listen server host
end

--[[---------------------------------------------------------
	Name: Find
-----------------------------------------------------------]]
local function Find( ply, command, arguments )

	if ( !UTIL_IsCommandIssuedByServerAdmin( ply ) ) then return end

	if ( !arguments[1] ) then

		if ( command:StartsWith( "lua_findhooks" ) ) then
			MsgN( "Usage: lua_findhooks <event name> [hook identifier]" )
			return
		end

		MsgN( "Usage: lua_find <text>" )
		return
	end

	if ( command:StartsWith( "lua_findhooks" ) ) then

		Msg( "Finding '", arguments[1], "' hooks ",
			( arguments[2] and "with name '" .. arguments[2] .. "' " or "" ),
			( SERVER and "SERVERSIDE" or "CLIENTSIDE" ), ":\n\n"
		)
		FindInHooks( arguments[1], arguments[2] )

	else

		Msg( "Finding '", arguments[1], "' ", ( SERVER and "SERVERSIDE" or "CLIENTSIDE" ), ":\n\n" )
		FindInTable( _G, arguments[1] )
		--FindInTable( debug.getregistry(), arguments[1] )

	end

	Msg( "\n\n" )

	if ( SERVER and IsValid( ply ) and ply:IsPlayer() and ply:IsListenServerHost() ) then
		RunConsoleCommand( command .. "_cl", arguments[1], arguments[2] )
	end

end

if ( SERVER ) then
	concommand.Add( "lua_find", Find, nil, "Find any variable by name on the server.", FCVAR_DONTRECORD )
	concommand.Add( "lua_findhooks", Find, nil, "Find hooks by event name and hook identifier on the server.", FCVAR_DONTRECORD )
else
	concommand.Add( "lua_find_cl", Find, nil, "Find any variable by name on the client.", FCVAR_DONTRECORD )
	concommand.Add( "lua_findhooks_cl", Find, nil, "Find hooks by event name and hook identifier on the client.", FCVAR_DONTRECORD )
end

if ( SERVER ) then

--[[---------------------------------------------------------
	What am I looking at?
-----------------------------------------------------------]]
concommand.Add( "trace", function( ply )
	if ( !IsValid( ply ) || ( !game.SinglePlayer() && !ply:IsListenServerHost() ) ) then return end

	local tr = util.TraceLine( {
		start = ply:EyePos(),
		endpos = ply:EyePos() + ply:GetAimVector() * 30000,
		filter = ply,
		//mask = MASK_OPAQUE_AND_NPCS,
	} )

	PrintTable( tr )
	print( "Dist: ", ( tr.HitPos - tr.StartPos ):Length() )
	if ( IsValid( tr.Entity ) ) then print( "Model: " .. tr.Entity:GetModel() ) end

	-- Print out the clientside class name
	ply:SendLua( [[print(Entity(]] .. ply:EntIndex() .. [[):GetEyeTrace().Entity)]] )
end )

end