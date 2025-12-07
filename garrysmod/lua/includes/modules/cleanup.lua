
module( "cleanup", package.seeall )

local cleanup_types = {}

local function IsType( type )

	for key, val in pairs( cleanup_types ) do

		if ( val == type ) then return true end

	end

	return false

end

function Register( type )

	if ( type == "all" ) then return end

	for key, val in pairs( cleanup_types ) do

		if val == type then return end

	end

	table.insert( cleanup_types, type )

end

function GetTable()
	return cleanup_types
end


if ( SERVER ) then

	local cleanup_list = {}

	function GetList()
		return cleanup_list
	end

	local function Save( save )

		saverestore.WriteTable( cleanup_list, save )

	end

	local function Restore( restore )

		cleanup_list = saverestore.ReadTable( restore )

	end

	saverestore.AddSaveHook( "CleanupTable", Save )
	saverestore.AddRestoreHook( "CleanupTable", Restore )

	local g_bPerformingCleanup = false
	local g_Cleanupables = {}
	local g_iOutOfCleanupRemovals = 0

	local function CleanupLists_CollectGarbage()

		timer.Pause( "CleanupLists_CollectGarbage" )
		g_iOutOfCleanupRemovals = 0

		for _, playerCleanupTable in pairs( cleanup_list ) do

			for _, cleanupTypeTable in pairs( playerCleanupTable ) do

				local i = 1
				local ent = cleanupTypeTable[ i ]

				while ( ent ) do

					if ( !IsValid( ent ) or ent:IsMarkedForDeletion() ) then

						table.remove( cleanupTypeTable, i )
						g_Cleanupables[ ent ] = nil
						ent = cleanupTypeTable[ i ] -- Indexes got shifted, checking this position once more

					else

						i = i + 1
						ent = cleanupTypeTable[ i ]

					end

				end

			end

		end

	end

	timer.Create( "CleanupLists_CollectGarbage", 3, 0, CleanupLists_CollectGarbage )
	timer.Pause( "CleanupLists_CollectGarbage" )

	hook.Add( "EntityRemoved", "CleanupListsGarbageWatcher", function( ent )

		if ( g_bPerformingCleanup ) then
			g_Cleanupables[ ent ] = nil
			return
		end

		if ( g_Cleanupables[ ent ] ) then
			g_iOutOfCleanupRemovals = g_iOutOfCleanupRemovals + 1
		end

		if ( g_iOutOfCleanupRemovals >= 30 ) then
			timer.UnPause( "CleanupLists_CollectGarbage" )
		end

	end )

	function Add( pl, type, ent )

		if ( !ent ) then return end

		if ( !IsType( type ) ) then return end

		local id = pl:UniqueID()

		cleanup_list[ id ] = cleanup_list[ id ] or {}
		cleanup_list[ id ][ type ] = cleanup_list[ id ][ type ] or {}

		if ( !IsValid( ent ) ) then return end

		table.insert( cleanup_list[ id ][ type ], ent )
		g_Cleanupables[ ent ] = true

	end

	function ReplaceEntity( from, to )

		local ActionTaken = false

		for _, PlayerTable in pairs( cleanup_list ) do
			for _, TypeTable in pairs( PlayerTable ) do
				for key, ent in pairs( TypeTable ) do

					if ( ent == from ) then
						if ( IsValid( to ) ) then g_Cleanupables[ to ] = true end
						g_Cleanupables[ from ] = nil
						TypeTable[ key ] = to
						ActionTaken = true
					end

				end
			end
		end

		return ActionTaken

	end


	function CC_Cleanup( pl, command, args )

		if ( !IsValid( pl ) ) then return end

		local id = pl:UniqueID()

		if ( !cleanup_list[ id ] ) then return end

		if ( !args[ 1 ] ) then

			local count = 0

			g_bPerformingCleanup = true

			for key, val in pairs( cleanup_list[ id ] ) do

				for _, ent in pairs( val ) do

					if ( IsValid( ent ) ) then ent:Remove() end
					count = count + 1

				end

				table.Empty( val )

			end

			g_bPerformingCleanup = false

			-- Send tooltip command to client
			if ( count > 0 ) then
				pl:SendLua( "hook.Run('OnCleanup','all')" )
			end

			return

		end

		if ( !IsType( args[1] ) ) then return end
		if ( !cleanup_list[id][ args[1] ] ) then return end

		g_bPerformingCleanup = true

		for key, ent in pairs( cleanup_list[id][ args[1] ] ) do

			if ( IsValid( ent ) ) then ent:Remove() end

		end

		g_bPerformingCleanup = false

		table.Empty( cleanup_list[id][ args[1] ] )

		-- Send tooltip command to client
		pl:SendLua( string.format( "hook.Run('OnCleanup',%q)", args[1] ) )

	end

	function CC_AdminCleanup( pl, command, args )

		if ( IsValid( pl ) && !pl:IsAdmin() ) then return end

		if ( !args[ 1 ] ) then

			g_bPerformingCleanup = true

			for key, ply in pairs( cleanup_list ) do

				for _, type in pairs( ply ) do

					for __, ent in pairs( type ) do

						if ( IsValid( ent ) ) then ent:Remove() end

					end

					table.Empty( type )

				end

			end

			g_bPerformingCleanup = false

			game.CleanUpMap( false, nil, function()
				-- Send tooltip command to client
				if ( IsValid( pl ) ) then pl:SendLua( "hook.Run('OnCleanup','all')" ) end
			end )

			return

		end

		if ( !IsType( args[ 1 ] ) ) then return end

		g_bPerformingCleanup = true

		for key, ply in pairs( cleanup_list ) do

			if ( ply[ args[ 1 ] ] != nil ) then

				for id, ent in pairs( ply[ args[ 1 ] ] ) do

					if ( IsValid( ent ) ) then ent:Remove() end

				end

				table.Empty( ply[ args[ 1 ] ] )

			end

		end

		g_bPerformingCleanup = false

		-- Send tooltip command to client
		if ( IsValid( pl ) ) then pl:SendLua( string.format( "hook.Run('OnCleanup',%q)", args[1] ) ) end

	end

	concommand.Add( "gmod_cleanup", CC_Cleanup, nil, "", { FCVAR_DONTRECORD } )
	concommand.Add( "gmod_admin_cleanup", CC_AdminCleanup, nil, "", { FCVAR_DONTRECORD } )

else

	function UpdateUI()

		local cleanup_types_s = {}
		for id, val in pairs( cleanup_types ) do
			cleanup_types_s[ language.GetPhrase( "Cleanup_" .. val ) ] = val
		end

		local Panel = controlpanel.Get( "User_Cleanup" )
		if ( IsValid( Panel ) ) then
			Panel:Clear()
			Panel:Help( "#spawnmenu.utilities.cleanup.help" )
			Panel:Button( "#spawnmenu.utilities.cleanup.all", "gmod_cleanup" )

			for key, val in SortedPairs( cleanup_types_s ) do
				Panel:Button( key, "gmod_cleanup", val )
			end
		end

		local AdminPanel = controlpanel.Get( "Admin_Cleanup" )
		if ( IsValid( AdminPanel ) ) then
			AdminPanel:Clear()
			AdminPanel:Help( "#spawnmenu.utilities.cleanup.help" )
			AdminPanel:Button( "#spawnmenu.utilities.cleanup.all", "gmod_admin_cleanup" )

			for key, val in SortedPairs( cleanup_types_s ) do
				AdminPanel:Button( key, "gmod_admin_cleanup", val )
			end
		end

	end

	hook.Add( "PostReloadToolsMenu", "BuildCleanupUI", UpdateUI )

end
