

local function GetAllFiles( tab, folder, extension, path )

	local files, folders = file.Find( folder .. "/*", path )

	for k, v in pairs( files ) do

		if ( v:EndsWith( extension ) ) then
			table.insert( tab, (folder .. v):lower() )
		end

	end

	for k, v in pairs( folders ) do
		timer.Simple( k * 0.1, function()
			GetAllFiles( tab, folder .. v .. "/", extension, path )
		end )
	end

	if ( folder == "models/" ) then
		hook.Run( "SearchUpdate" )
	end

end


local model_list = {}

GetAllFiles( model_list, "models/", ".mdl", "GAME" )	-- start finding files as soon as possible

--
-- Model Search
--
search.AddProvider( function( str )

	str = str:PatternSafe()

	local list = {}

	for k, v in pairs( model_list ) do

		if ( v:find( str ) ) then

			if ( IsUselessModel( v ) ) then continue end

			local entry = 
			{
				text = v:GetFileFromFilename(),
				func = function() RunConsoleCommand( "gm_spawn", v ) end,
				icon = spawnmenu.CreateContentIcon( "model", g_SpawnMenu.SearchPropPanel, { model = v } ),
				words = { v }
			}
			
			table.insert( list, entry )			

		end

		if ( #list >= 128 ) then break end

	end

	return list

end );

--
-- Entity, vehicles
--
search.AddProvider( function( str )

	str = str:PatternSafe()

	local results = {}

	local ents = {}
	--table.Add( ents, scripted_ents.GetSpawnable() );
	table.Add( ents, list.Get( "SpawnableEntities" ) );

	for k, v in pairs( list.Get( "Vehicles" ) ) do
			
		v.ClassName = k
		v.PrintName = v.Name
		v.ScriptedEntityType = 'vehicle'
		table.insert( ents, v )
			
	end
	
	for k, v in pairs( list.Get( "NPC" ) ) do
			
		v.ClassName = k
		v.PrintName = v.Name
		v.ScriptedEntityType = 'npc'
		table.insert( ents, v )
			
	end

	for k, v in pairs( list.Get( "Weapon" ) ) do
			
		v.ClassName = k
		v.PrintName = v.PrintName
		v.ScriptedEntityType = 'weapon'
		table.insert( ents, v )
			
	end

	for k, v in pairs( ents ) do

		local name = v.ClassName or v.PrintName
		if ( !name ) then continue end

		if ( name:lower():find( str ) ) then

			local entry = 
			{
				text = v.PrintName or v.ClassName,
				icon = spawnmenu.CreateContentIcon( v.ScriptedEntityType or "entity", nil, 
					{ 
						nicename	= v.PrintName or v.ClassName,
						spawnname	= v.ClassName,
						material	= "entities/"..v.ClassName..".png",
						admin		= v.AdminOnly
					}),
				words = { v }
			}
			
			table.insert( results, entry )			

		end

		if ( #results >= 128 ) then break end

	end

	return results

end );
