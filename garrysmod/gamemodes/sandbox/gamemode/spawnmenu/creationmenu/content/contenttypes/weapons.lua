
local function BuildWeaponCategories()
	local weapons = list.Get( "Weapon" )
	local Categorised = {}

	-- Build into categories
	for _, weapon in pairs( weapons ) do

		if ( !weapon.Spawnable ) then continue end

		local Category = language.GetPhrase( weapon.Category != "Other" and weapon.Category or "#spawnmenu.category.other" )
		if ( !isstring( Category ) ) then Category = tostring( Category ) end

		Categorised[ Category ] = Categorised[ Category ] or {}
		table.insert( Categorised[ Category ], weapon )

	end

	return Categorised
end

local function AddWeaponToCategory( propPanel, ent )
	return spawnmenu.CreateContentIcon( ent.ScriptedEntityType or "weapon", propPanel, {
		nicename	= ent.PrintName or ent.ClassName,
		spawnname	= ent.ClassName,
		material	= ent.IconOverride or ( "entities/" .. ent.ClassName .. ".png" ),
		admin		= ent.AdminOnly
	} )
end

local function AddCategory( tree, cat )
	local CustomIcons = list.Get( "ContentCategoryIcons" )

	-- Add a node to the tree
	local node = tree:AddNode( cat, CustomIcons[ cat ] or "icon16/gun.png" )
	tree.Categories[ cat ] = node

	-- When we click on the node - populate it using this function
	node.DoPopulate = function( self )

		-- If we've already populated it - forget it.
		if ( IsValid( self.PropPanel ) ) then return end

		-- Create the container panel
		self.PropPanel = vgui.Create( "ContentContainer", tree.pnlContent )
		self.PropPanel:SetVisible( false )
		self.PropPanel:SetTriggerSpawnlistChange( false )

		local weps = BuildWeaponCategories()[ cat ]
		if ( !weps ) then return end -- May no longer have any weapons due to autorefresh

		for _, ent in SortedPairsByMemberValue( weps, "PrintName" ) do
			AddWeaponToCategory( self.PropPanel, ent )
		end

	end

	-- If we click on the node populate it and switch to it.
	node.DoClick = function( self )

		self:DoPopulate()
		tree.pnlContent:SwitchPanel( self.PropPanel )

	end

	node.OnRemove = function( self )

		if ( IsValid( self.PropPanel ) ) then self.PropPanel:Remove() end

	end

	return node
end

hook.Add( "PopulateWeapons", "AddWeaponContent", function( pnlContent, tree, browseNode )

	-- Loop through the weapons and add them to the menu
	local Categorised = BuildWeaponCategories()

	-- Helper
	tree.Categories = {}
	tree.pnlContent = pnlContent

	-- Loop through each category
	for cat, weps in SortedPairs( Categorised ) do
		AddCategory( tree, cat )
	end

	-- Select the first node
	local FirstNode = tree:Root():GetChildNode( 0 )
	if ( IsValid( FirstNode ) ) then FirstNode:InternalDoClick() end

end )

local function AutorefreshWeaponToSpawnmenu( weapon, name )

	local swepTab = g_SpawnMenu.CreateMenu:GetCreationTab( "#spawnmenu.category.weapons" )
	if ( !swepTab || !swepTab.ContentPanel || !IsValid( swepTab.Panel ) ) then return end

	local tree = swepTab.ContentPanel.ContentNavBar.Tree
	if ( !tree.Categories ) then return end

	local newCategory = language.GetPhrase( weapon.Category or "#spawnmenu.category.other" )

	-- Remove from previous category..
	for cat, catPnl in pairs( tree.Categories ) do
		if ( !IsValid( catPnl.PropPanel ) ) then continue end

		for _, icon in pairs( catPnl.PropPanel.IconList:GetChildren() ) do
			if ( icon:GetName() != "ContentIcon" ) then continue end

			if ( icon:GetSpawnName() == name ) then

				local added = false
				if ( cat == newCategory ) then
					-- We already have the new category, just readd the icon here
					local newIcon = AddWeaponToCategory( catPnl.PropPanel, weapon )
					newIcon:MoveToBefore( icon )
					added = true
				end

				icon:Remove()

				if ( added ) then return end
			end
		end

		-- Leave the empty categories, this only applies to devs anyway
	end

	-- Weapon changed category...
	if ( IsValid( tree.Categories[ newCategory ] ) ) then
		-- Only do this if it is already populated.
		-- If not, the weapon will appear automatically when user clicks on the category
		if ( IsValid( tree.Categories[ newCategory ].PropPanel ) ) then
			-- Just append it to the end, heck with the order
			AddWeaponToCategory( tree.Categories[ newCategory ].PropPanel, weapon )
		end
	else
		AddCategory( tree, newCategory )
	end

end

local function OnPreRegisterSWEP( weapon, name )
	if ( !weapon.Spawnable || !g_SpawnMenu ) then return end

	-- Gotta wait for the next frame because this hook is called just before the weapon is registered
	timer.Simple( 0, function() AutorefreshWeaponToSpawnmenu( weapon, name ) end )
end


spawnmenu.AddCreationTab( "#spawnmenu.category.weapons", function()

	local ctrl = vgui.Create( "SpawnmenuContentPanel" )
	ctrl:EnableSearch( "weapons", "PopulateWeapons" )
	ctrl:CallPopulateHook( "PopulateWeapons" )

	hook.Add( "PreRegisterSWEP", "spawnmenu_reload_swep", OnPreRegisterSWEP )

	return ctrl

end, "icon16/gun.png", 10 )
