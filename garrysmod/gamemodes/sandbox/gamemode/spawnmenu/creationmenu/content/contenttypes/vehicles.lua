
hook.Add( "PopulateVehicles", "AddEntityContent", function( pnlContent, tree, browseNode )

	-- Add this list into the tormoil
	local Vehicles = list.Get( "Vehicles" )
	local Categorised = {}

	if ( Vehicles ) then

		for k, v in pairs( Vehicles ) do

			local Category = v.Category or "Other"
			Category = tostring( Category )
	
			local SubCategory = v.SubCategory or "Other"
			SubCategory = tostring( SubCategory )

			v.ClassName = k
			v.PrintName = v.Name
			v.ScriptedEntityType = "vehicle"

			Categorised[ Category ] = Categorised[ Category ] or {}
			Categorised[ Category ][ SubCategory ] = Categorised[ Category ][ SubCategory ] or {}

			table.insert( Categorised[ Category ][ SubCategory ], v )

		end

	end

	--
	-- Add a tree node for each category
	--
	local CustomIcons = list.Get( "ContentCategoryIcons" )

	for CategoryName, subCategories in SortedPairs( Categorised ) do

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

			local createOtherHeader = false

			for subCategoryName, tab in SortedPairs( subCategories ) do

				if ( subCategoryName == "Other" ) then continue end

				local label = vgui.Create( "ContentHeader" )

				label:SetText( subCategoryName )

				self.PropPanel:Add( label )

				for k, ent in SortedPairsByMemberValue( tab, "PrintName" ) do

					spawnmenu.CreateContentIcon( ent.ScriptedEntityType or "entity", self.PropPanel, {
						nicename	= ent.PrintName or ent.ClassName,
						spawnname	= ent.ClassName,
						material	= ent.IconOverride or "entities/" .. ent.ClassName .. ".png",
						admin		= ent.AdminOnly
					} )
	
				end

				createOtherHeader = true

			end

			if ( subCategories.Other ) then

				if ( createOtherHeader ) then

					local label = vgui.Create( "ContentHeader" )

					label:SetText( "Other" )

					self.PropPanel:Add( label )

				end

				for k, ent in SortedPairsByMemberValue( subCategories.Other, "PrintName" ) do

					spawnmenu.CreateContentIcon( ent.ScriptedEntityType or "entity", self.PropPanel, {
						nicename	= ent.PrintName or ent.ClassName,
						spawnname	= ent.ClassName,
						material	= ent.IconOverride or "entities/" .. ent.ClassName .. ".png",
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

spawnmenu.AddCreationTab( "#spawnmenu.category.vehicles", function()

	local ctrl = vgui.Create( "SpawnmenuContentPanel" )
	ctrl:EnableSearch( "vehicles", "PopulateVehicles" )
	ctrl:CallPopulateHook( "PopulateVehicles" )
	return ctrl

end, "icon16/car.png", 50 )
