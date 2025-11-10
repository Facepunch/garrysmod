
local TranslateNames = {
	["Effects"] = "#effects_pp",
	["Overlay"] = "#overlay_pp",
	["Shaders"] = "#shaders_pp",
	["Texturize"] = "#texturize_pp"
}

hook.Add( "PopulatePostProcess", "AddPostProcess", function( pnlContent, tree, node )

	local PostProcess = list.Get( "PostProcess" )

	--
	-- Create an entry for each category
	--
	local CategorisedList = spawnmenu.GenerateCategoryList( PostProcess, false, true, TranslateNames )
	for CategoryName, Headers in SortedPairs( CategorisedList ) do

		-- Add a node to the tree
		local node = tree:AddNode( CategoryName, "icon16/picture.png" )

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

			for headerName, ppList in SortedPairs( Headers ) do

				if ( headerName != other or createOtherHeader ) then
					local header = vgui.Create( "ContentHeader" )
					header:SetText( headerName )

					self.PropPanel:Add( header )
				end

				for name, pp in SortedPairsByMemberValue( ppList, "PrintName" ) do

					if ( pp.func ) then
						pp.func( self.PropPanel )
					else
						spawnmenu.CreateContentIcon( "postprocess", self.PropPanel, {
							name	= name,
							icon	= pp.icon
						} )
					end

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

spawnmenu.AddCreationTab( "#spawnmenu.category.postprocess", function()

	local ctrl = vgui.Create( "SpawnmenuContentPanel" )
	ctrl:CallPopulateHook( "PopulatePostProcess" )
	return ctrl

end, "icon16/picture.png", 100 )
