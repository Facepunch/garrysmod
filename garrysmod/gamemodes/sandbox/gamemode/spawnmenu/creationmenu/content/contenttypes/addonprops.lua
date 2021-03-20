
local function AddRecursive( pnl, folder, path, wildcard )

	local files, folders = file.Find( folder .. "*", path )
	if ( !files ) then MsgN( "Warning! Not opening '" .. folder .. "' because we cannot search in it!"  ) return false end

	local added = false

	for k, v in pairs( files ) do

		if ( !string.EndsWith( v, ".mdl" ) ) then continue end

		local cp = spawnmenu.GetContentType( "model" )
		if ( cp ) then
			cp( pnl, { model = folder .. v } )
			added = true
		end

	end

	for k, v in pairs( folders ) do

		local added_rec = AddRecursive( pnl, folder .. v .. "/", path, wildcard )
		added = added or added_rec

	end

	return added

end

local function AddonsRightClick( self )

	if ( !IsValid( self ) || !self.wsid || self.wsid == "0" ) then return end

	local menu = DermaMenu()
	menu:AddOption( "#spawnmenu.openaddononworkshop", function()
		steamworks.ViewFile( self.wsid )
	end ):SetIcon( "icon16/link_go.png" )

	menu:Open()

end

local function RefreshAddons( MyNode )

	local ViewPanel = MyNode.ViewPanel

	for _, addon in SortedPairsByMemberValue( engine.GetAddons(), "title" ) do

		if ( !addon.downloaded || !addon.mounted ) then continue end
		if ( addon.models <= 0 ) then continue end

		local models = MyNode:AddNode( addon.title .. " (" .. addon.models .. ")", "icon16/bricks.png" )
		models.DoClick = function()

			ViewPanel:Clear( true )

			local anyAdded = AddRecursive( ViewPanel, "models/", addon.title, "*.mdl" )
			if ( !anyAdded ) then
				local cp = spawnmenu.GetContentType( "header" )
				if ( cp ) then cp( ViewPanel, { text = "#spawnmenu.failedtofindmodels" } ) end

				-- For debugging
				local cp = spawnmenu.GetContentType( "header" )
				if ( cp ) then cp( ViewPanel, { text = tostring( addon.title ) .. " (ID: " .. tostring( addon.wsid ) .. ")" } ) end
			end

			MyNode.pnlContent:SwitchPanel( ViewPanel )

		end
		models.DoRightClick = AddonsRightClick
		models.wsid = addon.wsid

	end

end

local myAddonsNode
hook.Add( "PopulateContent", "AddonProps", function( pnlContent, tree, node )

	local myViewPanel = vgui.Create( "ContentContainer", pnlContent )
	myViewPanel:SetVisible( false )
	myViewPanel.IconList:SetReadOnly( true )

	myAddonsNode = node:AddNode( "#spawnmenu.category.addons", "icon16/folder_database.png" )
	myAddonsNode.ViewPanel = myViewPanel
	myAddonsNode.pnlContent = pnlContent

	RefreshAddons( myAddonsNode )

end )

hook.Add( "GameContentChanged", "RefreshSpawnmenuAddons", function()

	if ( !IsValid( myAddonsNode ) ) then return end

	-- TODO: Maybe be more advaced and do not delete => recreate all the nodes, only delete nodes for addons that were removed, add only the new ones?
	myAddonsNode:Clear()
	myAddonsNode.ViewPanel:Clear( true )

	RefreshAddons( myAddonsNode )

end )
