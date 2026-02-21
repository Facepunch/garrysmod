
local function AddRecursive( pnl, folder, path, wildcard )

	local files, folders = file.Find( folder .. "*", path )
	if ( !files ) then MsgN( "Warning! Not opening '" .. folder .. "' because we cannot search in it!"  ) return false end

	local added = false

	for k, v in ipairs( files ) do

		if ( !string.EndsWith( v, ".mdl" ) ) then continue end

		local cp = spawnmenu.GetContentType( "model" )
		if ( cp ) then
			cp( pnl, { model = folder .. v } )
			added = true
		end

	end

	for k, v in ipairs( folders ) do

		local added_rec = AddRecursive( pnl, folder .. v .. "/", path, wildcard )
		added = added || added_rec

	end

	return added

end

local function recurseAddFilesSpawnlist( folder, pathid, list )

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
		recurseAddFilesSpawnlist( folder .. "/" .. fold, pathid, list )
	end

end


local function GenerateSpawnlistFromAddon( folder, path, name )

	local contents = {}
	recurseAddFilesSpawnlist( folder, path, contents )

	AddPropsOfParent( g_SpawnMenu.CustomizableSpawnlistNode.SMContentPanel, g_SpawnMenu.CustomizableSpawnlistNode, 0, { [ folder ] = {
		icon = "icon16/page.png",
		id = math.random( 0, 999999 ), -- Eeehhhh
		name = name or folder,
		parentid = 0,
		contents = contents
	} } )

	-- We added a new spawnlist, show the save changes button
	hook.Run( "SpawnlistContentChanged" )

end

local function AddonsRightClick( self )

	if ( !IsValid( self ) || !self.wsid || self.wsid == "0" ) then return end

	local menu = DermaMenu()
	menu:AddOption( "#spawnmenu.openaddononworkshop", function()
		steamworks.ViewFile( self.wsid )
	end ):SetIcon( "icon16/link_go.png" )

	menu:AddOption( "#spawnmenu.createautospawnlist", function()

		GenerateSpawnlistFromAddon( "models", self.searchPath, self.searchPath )

	end ):SetIcon( "icon16/page_add.png" )
	menu:Open()

end


local function RefreshAddons( MyNode )

	local ViewPanel = MyNode.ViewPanel

	for _, addon in SortedPairsByMemberValue( engine.GetAddons(), "title" ) do

		if ( !addon.downloaded || !addon.mounted ) then continue end
		if ( addon.models <= 0 ) then continue end

		local models = MyNode:AddNode( addon.title .. " (" .. addon.models .. ")", "icon16/bricks.png" )
		models.DoClick = function()

			ViewPanel:Clear()

			local anyAdded = AddRecursive( ViewPanel, "models/", addon.title, "*.mdl" )
			if ( !anyAdded ) then
				local text = "<font=ContentHeader>" .. language.GetPhrase( "spawnmenu.failedtofindmodels" ) .. "\n\n" ..  tostring( addon.title ) .. " (ID: " .. tostring( addon.wsid ) .. ")" .. "</font>"

				local msg = vgui.Create( "Panel", ViewPanel )
				msg.Paint = function( s, w, h )
					-- Shadow. Ew.
					local parsedShadow = markup.Parse( "<colour=0,0,0,130>" .. text .. "</colour>", s:GetParent():GetWide() )
					parsedShadow:Draw( 2, 2 )

					-- The actual text
					local parsed = markup.Parse( text, s:GetParent():GetWide() )
					parsed:Draw( 0, 0 )

					-- Size to contents. Ew.
					s:SetSize( parsed:GetWidth(), parsed:GetHeight() )
				end
				ViewPanel:Add( msg )
			end

			MyNode.pnlContent:SwitchPanel( ViewPanel )

		end
		models.DoRightClick = AddonsRightClick
		models.wsid = addon.wsid
		models.searchPath = addon.title

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
	myAddonsNode.ViewPanel:Clear()

	RefreshAddons( myAddonsNode )

end )
