

if ( SERVER ) then 

local PersistPage = GetConVarString( "sbox_persist" )

hook.Add( "ShutDown", "SavePersistenceOnShutdown", function() hook.Run( "PersistenceSave" ) end )


hook.Add( "PersistenceSave", "PersistenceSave", function() 

	if ( PersistPage == "0" ) then return end

	local Ents = ents.GetAll()

	for k, v in pairs( Ents ) do

		if ( !v:GetPersistent() ) then
			Ents[ k ] = nil
		end

	end

	local tab = duplicator.CopyEnts( Ents )
	if ( !tab ) then return end

	local out = util.TableToJSON( tab )

	file.CreateDir( "persist" )
	file.Write( "persist/"..game.GetMap().."_"..PersistPage..".txt", out )
	
end )

hook.Add( "PersistenceLoad", "PersistenceLoad", function( name ) 

	local file = file.Read( "persist/"..game.GetMap().."_"..name..".txt", out )
	if ( !file ) then return end

	local tab = util.JSONToTable( file )
	if ( !tab ) then return end
	if ( !tab.Entities ) then return end
	if ( !tab.Constraints ) then return end

	game.CleanUpMap()

	local Ents, Constraints = duplicator.Paste( nil, tab.Entities, tab.Constraints )

	for k, v in pairs( Ents ) do
		v:SetPersistent( true )
	end

end )

hook.Add( "InitPostEntity", "PersistenceInit", function() 

	if ( PersistPage == "0" ) then return end

	hook.Run( "PersistenceLoad", PersistPage );
	
end )



end
