
hook.Add( "PopulateNPCs", "AddNPCContent", function( pnlContent, tree, node )

	-- Get a list of available NPCs
	local NPCList = list.Get( "NPC" )
		
	-- Categorize them
	local Categories = {}
	for k, v in pairs( NPCList ) do
		
		local Category = v.Category or "Other"
		local Tab = Categories[ Category ] or {}
			
		Tab[ k ] = v
			
		Categories[ Category ] = Tab
		
	end

	-- Create an icon for each one and put them on the panel
	for CategoryName, v in SortedPairs( Categories ) do
		
		-- Add a node to the tree
		local node = tree:AddNode( CategoryName, "icon16/monkey.png" );
		

		-- When we click on the node - populate it using this function
		node.DoPopulate = function( self )
	
			-- If we've already populated it - forget it.
			if ( self.PropPanel ) then return end

			-- Create the container panel
			self.PropPanel = vgui.Create( "ContentContainer", pnlContent )
			self.PropPanel:SetVisible( false )
			self.PropPanel:SetTriggerSpawnlistChange( false )

			for name, ent in SortedPairsByMemberValue( v, "Name" ) do
			
				local weapon = "";
				if ( ent.Weapons ) then
					weapon = ent.Weapons[1];
				end

				spawnmenu.CreateContentIcon( "npc", self.PropPanel, 
				{ 
					nicename	= ent.Name or name,
					spawnname	= name,
					material	= "entities/"..name..".png",
					weapon		= weapon,
					admin		= false
				})
				
			end

		end

		-- If we click on the node populate it and switch to it.
		node.DoClick = function( self )
	
			self:DoPopulate()		
			pnlContent:SwitchPanel( self.PropPanel );
	
		end
			
	end

	-- Select the first node
	local FirstNode = tree:Root():GetChildNode( 0 )
	if ( IsValid( FirstNode ) ) then
		FirstNode:InternalDoClick()
	end

end )


spawnmenu.AddCreationTab( "#spawnmenu.category.npcs", function()

	local ctrl = vgui.Create( "SpawnmenuContentPanel" )
	ctrl:CallPopulateHook( "PopulateNPCs" );
	return ctrl

end, "icon16/monkey.png", 20 )