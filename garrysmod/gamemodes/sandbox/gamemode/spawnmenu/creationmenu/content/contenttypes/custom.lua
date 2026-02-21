
local AddCustomizableNode = nil

local function SetupCustomNode( node, pnlContent, needsapp )

	node.CustomSpawnlist = !node.AddonSpawnlist -- Used to determine which nodes ContentSidebarToolBox can edit

	-- This spawnlist needs a certain app mounted before it will show up.
	if ( needsapp && needsapp != "" ) then
		node:SetVisible( IsMounted( needsapp ) )
		node.NeedsApp = needsapp

		if ( !IsMounted( needsapp ) ) then
			-- Make it look different
			node:SetAlpha( 200 )

			-- Give a detailed tooltip explaining why it looks different
			local name = language.GetPhrase( "spawnmenu.mountablegame" )
			for id, t in pairs( engine.GetGames() ) do
				if ( needsapp == t.folder ) then name = t.title break end
			end
			node:SetTooltip( string.format( language.GetPhrase( "spawnmenu.spawnlistnocontent" ), name ) )
		end
	end


	node.SetupCopy = function( self, copy )

		SetupCustomNode( copy, pnlContent, needsapp )

		self:DoPopulate()

		copy.PropPanel = self.PropPanel:Copy()

		copy.PropPanel:SetVisible( false )
		copy.PropPanel:SetTriggerSpawnlistChange( true )

		copy.DoPopulate = function() end

	end

	if ( !node.AddonSpawnlist ) then
		node.OnModified = function()
			hook.Run( "SpawnlistContentChanged" )
		end

		node.DoRightClick = function( self )

			local menu = DermaMenu()
			menu:AddOption( "#spawnmenu.menu.edit", function() self:InternalDoClick() hook.Run( "OpenToolbox" )  end ):SetIcon( "icon16/folder_edit.png" )
			menu:AddOption( "#spawnmenu.menu.add_subcategory", function() AddCustomizableNode( pnlContent, "New Category", "", self ) self:SetExpanded( true ) hook.Run( "SpawnlistContentChanged" ) end ):SetIcon( "icon16/folder_add.png" )
			menu:AddSpacer()
			menu:AddOption( "#spawnmenu.menu.delete", function() node:Remove() hook.Run( "SpawnlistContentChanged" ) end ):SetIcon( "icon16/folder_delete.png" )

			menu:Open()

		end
	end

	node.DoPopulate = function( self )

		if ( IsValid( self.PropPanel ) ) then return end

		self.PropPanel = vgui.Create( "ContentContainer", pnlContent )
		self.PropPanel:SetVisible( false )
		self.PropPanel:SetTriggerSpawnlistChange( true )

	end

	node.DoClick = function( self )

		self:DoPopulate()
		pnlContent:SwitchPanel( self.PropPanel )

	end

end

AddCustomizableNode = function( pnlContent, name, icon, parent, needsapp )

	local node = parent:AddNode( name, icon )
	node.AddonSpawnlist = parent.AddonSpawnlist

	SetupCustomNode( node, pnlContent, needsapp )

	return node

end

local function ReadSpawnlists( node, parentid )

	local tab = {}
	tab.name		= node:GetText()
	tab.icon		= node:GetIcon()
	tab.parentid	= parentid
	tab.id			= SPAWNLIST_ID
	tab.version		= 3
	tab.needsapp	= node.NeedsApp

	node:DoPopulate()

	if ( IsValid( node.PropPanel ) ) then
		tab.contents = node.PropPanel:ContentsToTable()
	end

	if ( SPAWNLIST_ID > 0 ) then
		SPAWNLISTS[ string.format( "%03d", tab.id ) .. "-" .. tab.name ] = util.TableToKeyValues( tab )
	end

	SPAWNLIST_ID = SPAWNLIST_ID + 1

	if ( node.ChildNodes ) then

		for k, v in ipairs( node.ChildNodes:GetChildren() ) do

			ReadSpawnlists( v, tab.id )

		end

	end

end

local function ConstructSpawnlist( node )

	SPAWNLIST_ID = 0
	SPAWNLISTS = {}

	ReadSpawnlists( node, 0 )
	local tab = SPAWNLISTS

	SPAWNLISTS = nil
	SPAWNLIST_ID = nil

	return tab

end

function AddPropsOfParent( pnlContent, node, parentid, customProps )

	local Props = customProps or spawnmenu.GetPropTable()

	for FileName, Info in SortedPairs( Props ) do

		if ( parentid != Info.parentid ) then continue end

		local pnlnode = AddCustomizableNode( pnlContent, Info.name, Info.icon, node, Info.needsapp )
		pnlnode:SetExpanded( true )
		pnlnode.OnRemove = function( self ) if ( IsValid( self.PropPanel ) ) then self.PropPanel:Remove() end end
		pnlnode.DoPopulate = function( self )

			if ( IsValid( self.PropPanel ) ) then return end

			self.PropPanel = vgui.Create( "ContentContainer", pnlContent )
			self.PropPanel:SetVisible( false )
			self.PropPanel:SetTriggerSpawnlistChange( true )
			if ( node.AddonSpawnlist ) then self.PropPanel.IconList:SetReadOnly( true ) end

			for i, object in SortedPairs( Info.contents ) do

				local cp = spawnmenu.GetContentType( object.type )
				if ( cp ) then cp( self.PropPanel, object ) end

			end

		end

		AddPropsOfParent( pnlContent, pnlnode, Info.id, customProps )

	end

end

-- This helps avoid empty spawnlist list when you delete some but the hidden ones remain so the default spawnlists never regenerate
-- TODO: Maybe show spawnlists that need games when any spawnlist was changed? Allow to set needed game from in-game?
local function CheckIfAnyVisible( node )
	local pnlContent = node.SMContentPanel

	if ( node:GetChildNodeCount() < 1 ) then
		spawnmenu.PopulateFromEngineTextFiles()
		AddPropsOfParent( pnlContent, node, 0 )
		node:SetExpanded( true )
		return
	end

	local visible = 0
	for id, pnl in pairs( node:GetChildNodes() ) do
		if ( pnl:IsVisible() ) then visible = visible + 1 end
	end

	if ( visible < 1 ) then
		for id, pnl in pairs( node:GetChildNodes() ) do
			pnl:SetVisible( true )
		end
	end
end

hook.Add( "PopulateContent", "AddCustomContent", function( pnlContent, tree, node )

	local node = AddCustomizableNode( pnlContent, "#spawnmenu.category.your_spawnlists", "", tree )
	node:SetDraggableName( "CustomContent" )
	node:SetExpanded( true )
	node.CustomSpawnlist = nil
	node.SMContentPanel = pnlContent

	node.DoRightClick = function( self )

		local menu = DermaMenu()
		menu:AddOption( "#spawnmenu.menu.new_category", function() AddCustomizableNode( pnlContent, "#spawnmenu.menu.new_category", "", node ) node:SetExpanded( true ) hook.Run( "SpawnlistContentChanged" ) end ):SetIcon( "icon16/folder_add.png" )
		menu:Open()

	end

	-- Save the spawnlist when children drag and dropped
	node.OnModified = function()
		hook.Run( "SpawnlistContentChanged" )
	end

	AddPropsOfParent( pnlContent, node, 0 )

	CheckIfAnyVisible( node )

	node:MoveToBack()

	g_SpawnMenu.CustomizableSpawnlistNode = node

	-- Select the first visible panel
	for id, pnl in pairs( node:GetChildNodes() ) do
		if ( pnl:IsVisible() ) then
			pnl:InternalDoClick()
			pnl:SetExpanded( true )
			break
		end
	end

	-- Custom stuff from addons
	local CustomProps = spawnmenu.GetCustomPropTable()
	if ( !table.IsEmpty( CustomProps ) ) then
		local node = AddCustomizableNode( pnlContent, "#spawnmenu.category.addon_spawnlists", "", tree )
		node:SetExpanded( true )
		--node:SetDraggableName( "CustomContent" )
		node.DoRightClick = function() end
		node.OnModified = function() end
		node.AddonSpawnlist = true
		node.CustomSpawnlist = nil

		AddPropsOfParent( pnlContent, node, 0, CustomProps )
	end

end )

hook.Add( "OnSaveSpawnlist", "DoSaveSpawnlist", function()

	local Spawnlist = ConstructSpawnlist( g_SpawnMenu.CustomizableSpawnlistNode )

	spawnmenu.DoSaveToTextFiles( Spawnlist )

	CheckIfAnyVisible( g_SpawnMenu.CustomizableSpawnlistNode )

end )
 
hook.Add( "OnRevertSpawnlist", "DoRevertSpawnlists", function()

	-- First delete all of the existing spawnlists
	g_SpawnMenu.CustomizableSpawnlistNode:Clear()

	-- Next load all the custom spawnlists again
	spawnmenu.PopulateFromEngineTextFiles()
	AddPropsOfParent( g_SpawnMenu.CustomizableSpawnlistNode.SMContentPanel, g_SpawnMenu.CustomizableSpawnlistNode, 0 )

	-- Select the first visible panel. TODO: why this requires a timer?
	timer.Simple( 0, function()
		CheckIfAnyVisible( g_SpawnMenu.CustomizableSpawnlistNode )

		for id, pnl in pairs( g_SpawnMenu.CustomizableSpawnlistNode:GetChildNodes() ) do
			if ( pnl:IsVisible() ) then
				pnl:InternalDoClick()
				pnl:SetExpanded( true )
				break
			end
		end

		g_SpawnMenu.CustomizableSpawnlistNode:SetExpanded( true )
	end )

end )
