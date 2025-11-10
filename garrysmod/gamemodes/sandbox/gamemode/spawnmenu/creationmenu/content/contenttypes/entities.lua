
list.Set( "ContentCategoryIcons", "Half-Life: Source", "games/16/hl1.png" )
list.Set( "ContentCategoryIcons", "Half-Life 2", "games/16/hl2.png" )
list.Set( "ContentCategoryIcons", "Portal", "games/16/portal.png" )

local TranslateNames = {
	["Editors"] = "#spawnmenu.category.editors",
	["Fun + Games"] = "#spawnmenu.category.fun_games",
	["Other"] = "#spawnmenu.category.other"
}

hook.Add( "PopulateEntities", "AddEntityContent", function( pnlContent, tree, browseNode )

	local SpawnableEntities = list.Get( "SpawnableEntities" )
	local CustomIcons = list.GetForEdit( "ContentCategoryIcons" )

	--
	-- Add a tree node for each category
	--
	local CategorisedList = spawnmenu.GenerateCategoryList( SpawnableEntities, false, false, TranslateNames )
	for CategoryName, Headers in SortedPairs( CategorisedList ) do

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

			-- Don't create the "Other" header if it's the only header
			local other = language.GetPhrase( "#spawnmenu.category.other" )
			local createOtherHeader = Headers[ other ] and table.Count( Headers ) > 1

			for headerName, entList in SortedPairs( Headers ) do

				if ( headerName != other or createOtherHeader ) then
					local header = vgui.Create( "ContentHeader" )
					header:SetText( headerName )

					self.PropPanel:Add( header )
				end

				for spawnName, ent in SortedPairsByMemberValue( entList, "PrintName" ) do

					spawnmenu.CreateContentIcon( ent.ScriptedEntityType or "entity", self.PropPanel, {
						nicename	= ent.PrintName or ent.ClassName,
						spawnname	= spawnName,
						material	= ent.IconOverride or ( "entities/" .. spawnName .. ".png" ),
						admin		= ent.AdminOnly
					} )

				end

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
