
local function FindInTable(tab, find, parents, depth)

	depth = depth or 0
	parents = parents or ""

	if (not istable( tab)) then return end
	if (depth > 3) then return end
	depth = depth + 1

	for k, v in pairs (tab) do

		if (isstring(k)) then

			if (k and k:lower():find( find:lower())) then

				Msg("\t", parents, k, " - (", type(v), " - ", v, ")\n")

			end

			-- Recurse
			if ( istable(v) and
				k ~= "_R" and
				k ~= "_E" and
				k ~= "_G" and
				k ~= "_M" and
				k ~= "_LOADED" and
				k ~= "__index" ) then

				local NewParents = parents .. k .. "."
				FindInTable(v, find, NewParents, depth)

			end

		end

	end

end

local function FindInHooks(base, name)

	for b, t in pairs(hook.GetTable()) do

		local head = true

		if (istable( t) and b:lower():find( base:lower())) then

			for n, f in pairs(t) do

				if (not name or tostring( n):lower():find( tostring( name):lower())) then

					if (head) then Msg( "\n\t", b, " hooks:\n") head = false end

					Msg("\t\t", tostring( n), " - (", tostring( f), ")\n")

				end

			end

		end

	end

end


--[[---------------------------------------------------------
   Name:	Find
-----------------------------------------------------------]]
local function Find(ply, command, arguments)

	if (not game.SinglePlayer() and IsValid(ply) and ply:IsPlayer() and not ply:IsAdmin()) then return end
	if (not arguments[1]) then return end

	if (command:StartWith( "lua_findhooks")) then

		Msg( "Finding '", arguments[1], "' hooks ",
			(arguments[2] and "with name '" .. arguments[2] .. "' " or ""),
			(SERVER and "SERVERSIDE" or "CLIENTSIDE"), ":\n\n"
		)
		FindInHooks(arguments[1], arguments[2])

	else

		Msg("Finding '", arguments[1], "' ", ( SERVER and "SERVERSIDE" or "CLIENTSIDE"), ":\n\n")
		FindInTable(_G, arguments[1])
		FindInTable(debug.getregistry(), arguments[1])

	end

	Msg("\n\n")

	if (SERVER and IsValid(ply) and ply:IsPlayer() and ply:IsListenServerHost()) then
		RunConsoleCommand(command .. "_cl", arguments[1], arguments[2])
	end

end

if (SERVER) then
	concommand.Add("lua_find", Find, _, "", { FCVAR_DONTRECORD })
	concommand.Add("lua_findhooks", Find, _, "", { FCVAR_DONTRECORD })
else
	concommand.Add("lua_find_cl", Find, _, "", { FCVAR_DONTRECORD })
	concommand.Add("lua_findhooks_cl", Find, _, "", { FCVAR_DONTRECORD })
end
