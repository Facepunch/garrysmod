
local function AddBrowseContent( ViewPanel, node, name, icon, path, pathid, pnlContent )

	local models = node:AddFolder( name, path .. "models", pathid, false )
	models:SetIcon( icon )
	models.BrowseContentType = "models"
	models.BrowseExtension = "*.mdl"
	models.ContentType = "model"
	models.ViewPanel = ViewPanel

	--
	-- If we click on a subnode of this tree, it gets reported upwards (to us)
	--
	models.OnNodeSelected = function( slf, node )

		-- Already viewing this panel
		if ( ViewPanel && ViewPanel.CurrentNode && ViewPanel.CurrentNode == node ) then
			if ( pnlContent.SelectedPanel != ViewPanel ) then pnlContent:SwitchPanel( ViewPanel ) end
			return
		end

		-- Clear the viewpanel in preperation for displaying it
		ViewPanel:Clear( true )
		ViewPanel.CurrentNode = node

		--
		-- Fill the viewpanel with models that are in this node's folder
		--
		local node_path = node:GetFolder()
		local SearchString = node_path .. "/*.mdl"

		local mdls = file.Find( SearchString, node:GetPathID() )
		if ( mdls ) then
			for k, v in pairs( mdls ) do
				local cp = spawnmenu.GetContentType( "model" )
				if ( cp ) then
					cp( ViewPanel, { model = node_path .. "/" .. v } )
				end
			end
		else
			MsgN( "Warning! Not opening '" .. node_path .. "' because we cannot search in it!"  )
		end

		--
		-- Switch to it
		--
		pnlContent:SwitchPanel( ViewPanel )
		ViewPanel.CurrentNode = node

	end

end

--
-- Called when setting up the sidebar on the spawnmenu - to populate the tree
--
hook.Add( "PopulateContent", "GameProps", function( pnlContent, tree, node )

	--
	-- Create a node in the `other` category on the tree
	--
	local MyNode = node:AddNode( "#spawnmenu.category.games", "icon16/folder_database.png" )

	local ViewPanel = vgui.Create( "ContentContainer", pnlContent )
	ViewPanel:SetVisible( false )
	ViewPanel.IconList:SetReadOnly( true )

	local games = engine.GetGames()
	table.insert( games, {
		title = "All",
		folder = "GAME",
		icon = "all",
		mounted = true
	} )
	table.insert( games, {
		title = "Garry's Mod",
		folder = "garrysmod",
		mounted = true
	} )

	--
	-- Create a list of mounted games, allowing us to browse them
	--
	for _, game in SortedPairsByMemberValue( games, "title" ) do

		if ( !game.mounted ) then continue end

		AddBrowseContent( ViewPanel, MyNode, game.title, "games/16/" .. ( game.icon or game.folder ) .. ".png", "", game.folder, pnlContent )

	end

end )
