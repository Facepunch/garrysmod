
local function AddRecursive( pnl, folder, path, wildcard )

	local files, folders = file.Find( folder .. "*", path )
	if ( !files ) then MsgN( "Warning! Not opening '" .. folder .. "' because we cannot search in it!"  ) return end

	for k, v in ipairs( files ) do

		if ( !string.EndsWith( v, ".mdl" ) ) then continue end

		local cp = spawnmenu.GetContentType( "model" )
		if ( cp ) then
			cp( pnl, { model = folder .. v } )
		end

	end

	for k, v in ipairs( folders ) do

		AddRecursive( pnl, folder .. v .. "/", path, wildcard )

	end

end

hook.Add( "PopulateContent", "AddonProps", function( pnlContent, tree, node )

	local ViewPanel = vgui.Create( "ContentContainer", pnlContent )
	ViewPanel:SetVisible( false )
	ViewPanel.IconList:SetReadOnly( true )

	local MyNode = node:AddNode( "#spawnmenu.category.addons", "icon16/folder_database.png" )

	for _, addon in SortedPairsByMemberValue( engine.GetAddons(), "title" ) do

		if ( !addon.downloaded || !addon.mounted ) then continue end
		if ( addon.models <= 0 ) then continue end

		local models = MyNode:AddNode( addon.title .. " (" .. addon.models .. ")", "icon16/bricks.png" )
		models.DoClick = function()

			ViewPanel:Clear( true )
			AddRecursive( ViewPanel, "models/", addon.title, "*.mdl" )
			pnlContent:SwitchPanel( ViewPanel )

		end

	end

end )
