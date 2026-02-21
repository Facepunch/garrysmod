
local function recurseAddFiles( folder, pathid, list )

	local addedLabel = false

	local files, folders = file.Find( folder .. "/*", pathid )
	for id, file in pairs( files or {} ) do
		if ( file:EndsWith( ".mdl" ) ) then
			if ( !addedLabel ) then
				table.insert( list, { type = "header", text = folder } )
				addedLabel = true
			end

			table.insert( list, { type = "model", model = folder .. "/" .. file } )
		end
	end

	for id, fold in pairs( folders or {} ) do
		recurseAddFiles( folder .. "/" .. fold, pathid, list )
	end

end

local function GenerateSpawnlistFromPath( folder, path, name, icon, appid )

	local contents = {}
	recurseAddFiles( folder, path, contents )

	AddPropsOfParent( g_SpawnMenu.CustomizableSpawnlistNode.SMContentPanel, g_SpawnMenu.CustomizableSpawnlistNode, 0, { [ folder ] = {
		icon = icon or "icon16/page.png",
		id = math.random( 0, 999999 ), -- Eeehhhh
		name = name or folder,
		parentid = 0,
		needsapp = appid,
		contents = contents
	} } )

	-- We added a new spawnlist, show the save changes button
	hook.Run( "SpawnlistContentChanged" )

end

local function GamePropsRightClick( self )

	local menu = DermaMenu()
	menu:AddOption( "#spawnmenu.createautospawnlist", function()

		-- Find the "root" node for this game
		local parent = self
		local icon = parent:GetIcon()
		while ( !icon:StartsWith( "games" ) ) do
			parent = parent:GetParentNode()
			if ( !IsValid( parent ) ) then break end
			icon = parent:GetIcon()
		end

		local name = parent:GetText()
		if ( self:GetFolder() != "models" ) then
			name = name .. " - " .. self:GetFolder():sub( 8 )
		end

		GenerateSpawnlistFromPath( self:GetFolder(), self:GetPathID(), name, icon, parent.GamePathID )

	end ):SetIcon( "icon16/page_add.png" )

	menu:Open()

end

local function InstallNodeRightclick( self, newNode )
	newNode.DoRightClick = GamePropsRightClick
	newNode.OnNodeAdded = InstallNodeRightclick
end

local function AddBrowseContent( ViewPanel, node, name, icon, path, pathid, pnlContent )

	local models = node:AddFolder( name, path .. "models", pathid, false )
	models:SetIcon( icon )
	models.BrowseContentType = "models"
	models.BrowseExtension = "*.mdl"
	models.ContentType = "model"
	models.ViewPanel = ViewPanel
	models.GamePathID = pathid

	-- If we click on a subnode of this tree, it gets reported upwards (to us)
	models.OnNodeSelected = function( slf, node )

		-- Already viewing this panel
		if ( ViewPanel && ViewPanel.CurrentNode && ViewPanel.CurrentNode == node ) then
			if ( pnlContent.SelectedPanel != ViewPanel ) then pnlContent:SwitchPanel( ViewPanel ) end
			return
		end

		-- Clear the viewpanel in preperation for displaying it
		ViewPanel:Clear()
		ViewPanel.CurrentNode = node

		-- Fill the viewpanel with models that are in this node's folder
		local node_path = node:GetFolder()
		local SearchString = node_path .. "/*.mdl"

		local mdls = file.Find( SearchString, node:GetPathID() )
		if ( mdls ) then
			for k, v in ipairs( mdls ) do
				local cp = spawnmenu.GetContentType( "model" )
				if ( cp ) then
					cp( ViewPanel, { model = node_path .. "/" .. v } )
				end
			end
		else
			MsgN( "Warning! Not opening '" .. node_path .. "' because we cannot search in it!"  )
		end

		-- Switch to it
		pnlContent:SwitchPanel( ViewPanel )
		ViewPanel.CurrentNode = node

	end

	InstallNodeRightclick( node, models )

end

local function RefreshGames( MyNode )

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

	-- Create a list of mounted games, allowing us to browse them
	for _, game in SortedPairsByMemberValue( games, "title" ) do

		if ( !game.mounted ) then continue end

		AddBrowseContent( MyNode.ViewPanel, MyNode, game.title, "games/16/" .. ( game.icon or game.folder ) .. ".png", "", game.folder, MyNode.pnlContent )

	end

end

-- Called when setting up the sidebar on the spawnmenu - to populate the tree
local myGamesNode
hook.Add( "PopulateContent", "GameProps", function( pnlContent, tree, node )

	-- Create a node in the `other` category on the tree
	myGamesNode = node:AddNode( "#spawnmenu.category.games", "icon16/folder_database.png" )
	myGamesNode.pnlContent = pnlContent

	local ViewPanel = vgui.Create( "ContentContainer", pnlContent )
	ViewPanel:SetVisible( false )
	ViewPanel.IconList:SetReadOnly( true )
	myGamesNode.ViewPanel = ViewPanel

	RefreshGames( myGamesNode )

end )


hook.Add( "GameContentChanged", "RefreshSpawnmenuGames", function()

	if ( !IsValid( myGamesNode ) ) then return end

	-- TODO: Maybe be more advaced and do not delete => recreate all the nodes, only delete nodes for addons that were removed, add only the new ones?
	myGamesNode:Clear()
	myGamesNode.ViewPanel:Clear()

	RefreshGames( myGamesNode )

end )
