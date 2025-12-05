local ipairs = ipairs
local pairs = pairs
local table = table
local IsValid = IsValid

module( "cleanup", package.seeall )


local cleanup_types = {}

local function IsType( type )

	for _, typeStored in ipairs( cleanup_types ) do
		if ( typeStored == type ) then return true end
	end

	return false

end

function Register( type )

	if ( type == "all" ) then return end

	for _, typeStored in ipairs( cleanup_types ) do
		if ( typeStored == type ) then return end
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

	local function DieFunction_HandleOutOfCleanupRemoval( ent, pOurCleanupTypeTable )

		for i, entStored in ipairs( pOurCleanupTypeTable ) do

			if ( ent == entStored ) then

				table.remove( pOurCleanupTypeTable, i )
				break

			end

		end

	end

	function Add( pl, type, ent )

		if ( !IsType( type ) ) then return end
		if ( !IsValid( ent ) ) then return end

		local id = pl:UniqueID()

		cleanup_list[id] = cleanup_list[id] or {}
		cleanup_list[id][type] = cleanup_list[id][type] or {}

		if ( !IsValid( ent ) ) then return end

		table.insert( cleanup_list[id][type], ent )

		ent:CallOnRemove( "HandleOutOfCleanupRemoval", DieFunction_HandleOutOfCleanupRemoval, cleanup_list[id][type] )

	end

	function ReplaceEntity( from, to )

		for _, playerCleanupTable in pairs( cleanup_list ) do

			for _, cleanupTypeTable in pairs( playerCleanupTable ) do

				for i, ent in ipairs( cleanupTypeTable ) do

					if ( ent == from ) then

						local valid = IsValid( to )

						if ( valid ) then
							to:CallOnRemove( "HandleOutOfCleanupRemoval", DieFunction_HandleOutOfCleanupRemoval, cleanupTypeTable )
						end

						cleanupTypeTable[i] = valid && to or nil

						return true

					end

				end

			end

		end

		return false

	end

	function CC_Cleanup( pl, command, args )

		if ( !IsValid( pl ) ) then return end

		local id = pl:UniqueID()

		local playerCleanupTable = cleanup_list[id]
		if ( !playerCleanupTable ) then return end

		local cleanupType = args[1]

		--
		-- All
		--
		if ( !cleanupType ) then

			local count = 0

			for _, cleanupTypeTable in pairs( playerCleanupTable ) do

				for i, ent in ipairs( cleanupTypeTable ) do

					if ( IsValid( ent ) ) then ent:Remove() end
					count = count + 1

					cleanupTypeTable[i] = nil

				end

			end

			if ( count > 0 ) then
				-- Send tooltip command to client
				pl:SendLua( "hook.Run('OnCleanup','all')" )
			end

			return

		end

		if ( !IsType( cleanupType ) ) then return end

		local cleanupTypeTable = playerCleanupTable[cleanupType]
		if ( !cleanupTypeTable ) then return end

		for i, ent in ipairs( cleanupTypeTable ) do

			if ( IsValid( ent ) ) then ent:Remove() end
			cleanupTypeTable[i] = nil

		end

		-- Send tooltip command to client
		pl:SendLua( Format( "hook.Run('OnCleanup',%q)", cleanupType ) )

	end

	function CC_AdminCleanup( pl, command, args )

		if ( IsValid( pl ) && !pl:IsAdmin() ) then return end

		local cleanupType = args[1]

		--
		-- All
		--
		if ( !cleanupType ) then

			for _, playerCleanupTable in pairs( cleanup_list ) do

				for _, cleanupTypeTable in pairs( playerCleanupTable ) do

					for i, ent in ipairs( cleanupTypeTable ) do

						if ( IsValid( ent ) ) then ent:Remove() end
						cleanupTypeTable[i] = nil

					end

				end

			end

			game.CleanUpMap( false, nil, function()

				if ( IsValid( pl ) ) then
					-- Send tooltip command to client
					pl:SendLua( "hook.Run('OnCleanup','all')" )
				end

			end )

			return

		end

		if ( !IsType( cleanupType ) ) then return end

		for _, playerCleanupTable in pairs( cleanup_list ) do

			local cleanupTypeTable = playerCleanupTable[cleanupType]

			if ( cleanupTypeTable ) then

				for i, ent in ipairs( cleanupTypeTable ) do

					if ( IsValid( ent ) ) then ent:Remove() end
					cleanupTypeTable[i] = nil

				end

				break

			end

		end

		if ( IsValid( pl ) ) then
			-- Send tooltip command to client
			pl:SendLua( Format( "hook.Run('OnCleanup',%q)", cleanupType ) )
		end

	end

	concommand.Add( "gmod_cleanup", CC_Cleanup, nil, "", { FCVAR_DONTRECORD } )
	concommand.Add( "gmod_admin_cleanup", CC_AdminCleanup, nil, "", { FCVAR_DONTRECORD } )

else

	function UpdateUI()

		local cleanup_types_s = {}

		for _, cleanupType in ipairs( cleanup_types ) do
			cleanup_types_s[language.GetPhrase( "Cleanup_" .. cleanupType )] = cleanupType
		end

		local Panel = controlpanel.Get( "User_Cleanup" )
		if ( IsValid( Panel ) ) then

			Panel:Clear()
			Panel:Help( "#spawnmenu.utilities.cleanup.help" )
			Panel:Button( "#spawnmenu.utilities.cleanup.all", "gmod_cleanup" )

			for phrase, cleanupType in SortedPairs( cleanup_types_s ) do
				Panel:Button( phrase, "gmod_cleanup", cleanupType )
			end

		end

		local AdminPanel = controlpanel.Get( "Admin_Cleanup" )
		if ( IsValid( AdminPanel ) ) then

			AdminPanel:Clear()
			AdminPanel:Help( "#spawnmenu.utilities.cleanup.help" )
			AdminPanel:Button( "#spawnmenu.utilities.cleanup.all", "gmod_admin_cleanup" )

			for phrase, cleanupType in SortedPairs( cleanup_types_s ) do
				AdminPanel:Button( phrase, "gmod_admin_cleanup", cleanupType )
			end

		end

	end

	hook.Add( "PostReloadToolsMenu", "BuildCleanupUI", UpdateUI )

end
