
local function AddBrowseContent( ViewPanel, node, name, icon, path, pathid, pnlContent )

	local models = node:AddFolder( name, path .. "models", pathid, false );
		models:SetIcon( icon )
		models.BrowseContentType = "models";
		models.BrowseExtension = "*.mdl";
		models.ContentType = "model";
		models.ViewPanel = ViewPanel;

		--
		-- If we click on a subnode of this tree, it gets reported upwards (to us)
		--
		models.OnNodeSelected = function( slf, node )

			-- Already viewing this panel
			if ( ViewPanel && ViewPanel.CurrentNode && ViewPanel.CurrentNode == node ) then return end

			-- Clear the viewpanel in preperation for displaying it
			ViewPanel:Clear( true )
			ViewPanel.CurrentNode = node;
			
			--
			-- Fill the viewpanel with models that are in this node's folder
			--
			local Path			= node:GetFolder()
			local SearchString	= Path .. "/*.mdl";

			local Models = file.Find( SearchString, node:GetPathID() )
			for k, v in pairs( Models ) do
			
				local cp = spawnmenu.GetContentType( "model" );
				if ( cp ) then 
					cp( ViewPanel, { model = Path .. "/" .. v } ) 
				end
		
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
	local MyNode = node:AddNode( "#spawnmenu.category.games", "icon16/folder_database.png" );
	
		local ViewPanel = vgui.Create( "ContentContainer", pnlContent )
		ViewPanel:SetVisible( false );

		AddBrowseContent( ViewPanel, MyNode, "All", "games/16/all.png", "", "GAME", pnlContent );
		AddBrowseContent( ViewPanel, MyNode, "Garry's Mod", "games/16/garrysmod.png", "", "garrysmod", pnlContent );
	
		--
		-- Create a list of mounted games, allowing us to browse them
		--
		local games = engine.GetGames()
		for _, game in SortedPairs( games ) do
		
			if ( !game.mounted ) then continue end

			AddBrowseContent( ViewPanel, MyNode, game.folder, "games/16/" .. game.folder .. ".png", "", game.folder, pnlContent )
		
		end

end )
