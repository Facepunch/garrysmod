
local function AddRecursive( pnl, folder, path, wildcard )

	local files, folders = file.Find( folder .. "*", path )

	for k, v in pairs( files ) do
		
		if ( !string.EndsWith( v, ".mdl" ) ) then continue end

		local cp = spawnmenu.GetContentType( "model" );
		if ( cp ) then 
			cp( pnl, { model = folder .. v } ) 
		end

	end

	for k, v in pairs( folders ) do

		AddRecursive( pnl, folder .. v .. "/", path, wildcard )

	end

end


hook.Add( "PopulateContent", "AddonProps", function( pnlContent, tree, node )

	local ViewPanel = vgui.Create( "ContentContainer", pnlContent )
	ViewPanel:SetVisible( false );

	local MyNode = node:AddNode( "#spawnmenu.category.addons", "icon16/folder_database.png" );

		local addons = engine.GetAddons()
		for _, addon in SortedPairs( addons ) do
		
			if ( !addon.downloaded ) then continue end
			if ( !addon.mounted ) then continue end

			if ( addon.models <= 0 ) then continue end

			local models = MyNode:AddNode( addon.title .. " ("..addon.models..")", "icon16/bricks.png" );
			models.DoClick = function()

				ViewPanel:Clear( true )
				AddRecursive( ViewPanel, "models/", addon.title, "*.mdl" )
				pnlContent:SwitchPanel( ViewPanel )

			end
		
		end

end )
