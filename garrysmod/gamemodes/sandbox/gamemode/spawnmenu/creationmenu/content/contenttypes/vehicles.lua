
local TranslateNames = {
	["Chairs"] = "#spawnmenu.category.chairs",
	["Other"] = "#spawnmenu.category.other"
}

hook.Add( "PopulateVehicles", "AddEntityContent", function( pnlContent, tree, browseNode )

	local Vehicles = list.Get( "Vehicles" )
	local CustomIcons = list.GetForEdit( "ContentCategoryIcons" )

	--
	-- Add a tree node for each category
	--
	local CategorisedList = spawnmenu.GenerateCategoryList( Vehicles, false, false, TranslateNames )
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

			for headerName, vehList in SortedPairs( Headers ) do

				if ( headerName != other or createOtherHeader ) then
					local header = vgui.Create( "ContentHeader" )
					header:SetText( headerName )

					self.PropPanel:Add( header )
				end

				for spawnName, veh in SortedPairsByMemberValue( vehList, "Name" ) do

					spawnmenu.CreateContentIcon( "vehicle", self.PropPanel, {
						nicename	= veh.PrintName or spawnName,
						spawnname	= spawnName,
						material	= veh.IconOverride or "entities/" .. spawnName .. ".png",
						admin		= veh.AdminOnly
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
