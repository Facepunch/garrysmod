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

function GetTable( )
	return cleanup_types
end


if ( SERVER ) then

	local cleanup_list = {}
	
	function GetList( )
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
	
	function Add( pl, type, ent )
	
		if ( !ent ) then return end
		
		if ( !IsType( type ) ) then return end
		
		local id = pl:UniqueID()
		
		cleanup_list[ id ] = cleanup_list[ id ] or {}
		cleanup_list[ id ][ type ] = cleanup_list[ id ][ type ] or {}
		
		if ( !ent:IsValid() ) then return end
		
		table.insert( cleanup_list[ id ][ type ], ent )
		
	end

	function ReplaceEntity( from, to )
	
		local ActionTaken = false
	
		for _, PlayerTable in pairs(cleanup_list) do
			for _, TypeTable in pairs(PlayerTable) do
				for key, ent in pairs(TypeTable) do
				
						if ( ent == from ) then
							TypeTable[ key ] = to
							ActionTaken = true
						end
											
				end
			end	
		end
		
		return ActionTaken
		
	end


	function CC_Cleanup( pl, command, args )
	
		local id = pl:UniqueID()
		
		if ( !cleanup_list[id] ) then return end
		
		if ( !args[1] ) then
		
			local count = 0
		
			for key, val in pairs( cleanup_list[id] ) do
			
				for key, ent in pairs( val ) do
				
					if ( ent:IsValid() ) then ent:Remove() end
					count = count + 1
					
				end
			
				table.Empty( val )
			
			end
			
			-- Send tooltip command to client
			if ( count > 0 ) then
				pl:SendLua( "GAMEMODE:OnCleanup( 'all' )" )
			end
			
			return
			
		end
		
		if ( !IsType( args[1] ) ) then return end
		if ( !cleanup_list[id][args[1]] ) then return end
		
		for key, ent in pairs( cleanup_list[id][args[1]] ) do
		
			if ( ent:IsValid() ) then ent:Remove() end
			
		end
		
		table.Empty( cleanup_list[id][args[1]] )
		
		-- Send tooltip command to client
		pl:SendLua( "GAMEMODE:OnCleanup( '"..args[1].."' )" )
		
	end
	
	function CC_AdminCleanup( pl, command, args )
	
		if ( pl && pl:IsValid() && !pl:IsAdmin() ) then return end
		
		if ( !args[1] ) then
	
			for key, player in pairs( cleanup_list ) do
			
				for key, type in pairs( player ) do
				
					for key, ent in pairs( type ) do
					
						if ( ent:IsValid() ) then ent:Remove() end
						
					end
					
					table.Empty( type )
					
				end
				
			end
			
			game.CleanUpMap()
			
			-- Send tooltip command to client
			pl:SendLua( "GAMEMODE:OnCleanup( 'all' )" )
			
			return
			
		end
		
		if ( !IsType( args[1] ) ) then return end
		
		for key, player in pairs( cleanup_list ) do
		
			if ( player[args[1]] != nil ) then
			
				for key, ent in pairs( player[args[1]] ) do
				
					if ( ent:IsValid() ) then ent:Remove() end
					
				end
				
				table.Empty( player[args[1]] )
				
			end
			
		end
		
		-- Send tooltip command to client
		pl:SendLua( "GAMEMODE:OnCleanup( '"..args[1].."' )" )
		
	end
	
	concommand.Add( "gmod_cleanup",		CC_Cleanup, nil, "", { FCVAR_DONTRECORD } )
	concommand.Add( "gmod_admin_cleanup",	CC_AdminCleanup, nil, "", { FCVAR_DONTRECORD } )
	
else

	function UpdateUI()
	
		local Panel = controlpanel.Get( "User_Cleanup" )
		if (!Panel) then return end
		
		Panel:ClearControls()
		Panel:AddControl( "Header", { Text = "#CleanUp" }  )
		
		Panel:Button( "#CleanupAll", "gmod_cleanup" )

		table.sort( cleanup_types )
		
		for key, val in pairs( cleanup_types ) do
		
			Panel:Button( "#Cleanup_"..val, "gmod_cleanup", val )
			
		end
		
		local Panel = controlpanel.Get( "Admin_Cleanup" )
		if (!Panel) then return end
		
		Panel:ClearControls()
		Panel:AddControl( "Header", { Text = "#CleanUp" }  )
		Panel:Button( "#CleanupAll", "gmod_admin_cleanup" )
		
		table.sort( cleanup_types )
		
		for key, val in pairs( cleanup_types ) do
		
			Panel:Button( "#Cleanup_"..val, "gmod_admin_cleanup", val )
			
		end
		
	end
	
	hook.Add( "PostReloadToolsMenu", "BuildCleanupUI", UpdateUI )
	
end
