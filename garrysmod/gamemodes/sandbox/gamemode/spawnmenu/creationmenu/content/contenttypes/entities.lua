
list.Set( "ContentCategoryIcons", "Half-Life: Source", "games/16/hl1.png" )
list.Set( "ContentCategoryIcons", "Half-Life 2", "games/16/hl2.png" )
list.Set( "ContentCategoryIcons", "Portal", "games/16/portal.png" )

hook.Add( "PopulateEntities", "AddEntityContent", function( pnlContent, tree, browseNode )

	local Categorised = {}

	-- Add this list into the tormoil
	local SpawnableEntities = list.Get( "SpawnableEntities" )
	if ( SpawnableEntities ) then
		-- Category localization support for old addons
		local TranslateNames = {
			["Editors"] = "#spawnmenu.category.editors",
			["Fun + Games"] = "#spawnmenu.category.fun_games",
			["Other"] = "#spawnmenu.category.other"
		}

		for k, v in pairs( SpawnableEntities ) do

			local Category = language.GetPhrase( TranslateNames[v.Category] or v.Category or "#spawnmenu.category.other" )
			if ( !isstring( Category ) ) then Category = tostring( Category ) end
			Categorised[ Category ] = Categorised[ Category ] or {}

			v.SpawnName = k
			table.insert( Categorised[ Category ], v )

		end
	end

	--
	-- Add a tree node for each category
	--
	local CustomIcons = list.Get( "ContentCategoryIcons" )
	for CategoryName, v in SortedPairs( Categorised ) do

		-- Add a node to the tree
		local node = tree:AddNode( CategoryName, CustomIcons[ CategoryName ] or "icon16/bricks.png" )

		-- When we click on the node - populate it using this function
		node.DoPopulate = function( self )

			-- If we've already populated it - forget it.
			if ( self.PropPanel ) then return end

			-- Create the container panel
			self.PropPanel = vgui.Create( "ContentContainer", pnlContent )
			self.PropPanel:SetVisible( false )
			self.PropPanel:SetTriggerSpawnlistChange( false )

			for k, ent in SortedPairsByMemberValue( v, "PrintName" ) do

				spawnmenu.CreateContentIcon( ent.ScriptedEntityType or "entity", self.PropPanel, {
					nicename	= ent.PrintName or ent.ClassName,
					spawnname	= ent.SpawnName,
					material	= ent.IconOverride or ( "entities/" .. ent.SpawnName .. ".png" ),
					admin		= ent.AdminOnly
				} )

			end

		end

		-- If we click on the node populate it and switch to it.
		node.DoClick = function( self )

			self:DoPopulate()
			pnlContent:SwitchPanel( self.PropPanel )

		end

	end

	-- Select the first node
	local FirstNode = tree:Root():GetChildNode( 0 )
	if ( IsValid( FirstNode ) ) then
		FirstNode:InternalDoClick()
	end

end )

spawnmenu.AddCreationTab( "#spawnmenu.category.entities", function()

	local ctrl = vgui.Create( "SpawnmenuContentPanel" )
	ctrl:EnableSearch( "entities", "PopulateEntities" )
	ctrl:CallPopulateHook( "PopulateEntities" )

	return ctrl

end, "icon16/bricks.png", 20 )
