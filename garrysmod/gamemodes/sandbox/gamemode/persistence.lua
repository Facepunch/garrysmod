
if ( CLIENT ) then return end

local CurrentlyActivePersistencePage = ""

hook.Add( "InitPostEntity", "PersistenceInit", function()

	local PersistPage = GetConVarString( "sbox_persist" ):Trim()
	if ( PersistPage == "" ) then return end

	hook.Run( "PersistenceLoad", PersistPage )

end )

hook.Add( "ShutDown", "SavePersistenceOnShutdown", function() hook.Run( "PersistenceSave" ) end )

hook.Add( "PersistenceSave", "PersistenceSave", function( name )

	local PersistPage = ( name or GetConVarString( "sbox_persist" ) ):Trim()
	if ( PersistPage == "" ) then return end

	local Ents = ents.GetAll()

	for k, v in ipairs( Ents ) do

		if ( !v:GetPersistent() ) then
			Ents[ k ] = nil
		end

	end

	local tab = duplicator.CopyEnts( Ents )
	if ( !tab ) then return end

	local out = util.TableToJSON( tab )

	file.CreateDir( "persist" )
	file.Write( "persist/" .. game.GetMap() .. "_" .. PersistPage .. ".txt", out )

end )

hook.Add( "PersistenceLoad", "PersistenceLoad", function( name )

	CurrentlyActivePersistencePage = name

	local data = file.Read( "persist/" .. game.GetMap() .. "_" .. name .. ".txt" )
	if ( !data ) then return end

	local tab = util.JSONToTable( data )
	if ( !tab ) then return end
	if ( !tab.Entities ) then return end
	if ( !tab.Constraints ) then return end

	local entities = duplicator.Paste( nil, tab.Entities, tab.Constraints )

	for k, v in pairs( entities ) do
		v:SetPersistent( true )
	end

end )

cvars.AddChangeCallback( "sbox_persist", function( name, old, new )

	-- A timer in case someone tries to rapidly change the convar, such as addons with "live typing" or whatever
	timer.Create( "sbox_persist_change_timer", 2, 1, function()

		local newPage = new:Trim()

		if ( CurrentlyActivePersistencePage == newPage ) then return end

		-- old:Trim() would be incorrect for more than 1 convar change within the 2 second timer window
		hook.Run( "PersistenceSave", CurrentlyActivePersistencePage )

		CurrentlyActivePersistencePage = ""

		if ( newPage == "" ) then return end

		-- Addons are forcing us to use this hook
		hook.Add( "PostCleanupMap", "GMod_Sandbox_PersistanceLoad", function()
			hook.Remove( "PostCleanupMap", "GMod_Sandbox_PersistanceLoad" )

			hook.Run( "PersistenceLoad", newPage )
		end )

		-- Maybe this game.CleanUpMap call should be moved to PersistenceLoad?
		game.CleanUpMap( false, nil, function() end )

	end )

end, "sbox_persist_load" )
