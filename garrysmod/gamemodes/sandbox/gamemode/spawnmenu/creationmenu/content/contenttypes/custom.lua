
local AddCustomizableNode = nil

local function SetupCustomNode( node, pnlContent, needsapp )

	--
	-- This spawnlist needs a certain app mounted before it will show up.
	--
	if ( needsapp && needsapp != "" ) then
		node:SetVisible( IsMounted( needsapp ) )
		node.NeedsApp = needsapp;
	end


	node.OnModified = function()
		hook.Run( "SpawnlistContentChanged" )
	end
	
	node.SetupCopy = function( self, copy ) 
	
		SetupCustomNode( copy, pnlContent )
		
		self:DoPopulate()
		
		copy.PropPanel = self.PropPanel:Copy()
		
		copy.PropPanel:SetVisible( false )
		copy.PropPanel:SetTriggerSpawnlistChange( true )
		
		copy.DoPopulate = function() end
			
	end
	
	node.DoRightClick = function( self )
	
		local menu = DermaMenu()
		menu:AddOption( "Edit", function() self:InternalDoClick(); hook.Run( "OpenToolbox" )  end )
		menu:AddOption( "New Category", function() AddCustomizableNode( pnlContent, "New Category", "", self ); self:SetExpanded( true ); hook.Run( "SpawnlistContentChanged" ) end )
		menu:AddOption( "Delete", function() node:Remove(); hook.Run( "SpawnlistContentChanged" ) end )
		
		
		menu:Open()
	
	end
	
	node.DoPopulate = function( self )
	
		if ( !self.PropPanel ) then

			self.PropPanel = vgui.Create( "ContentContainer", pnlContent )
			self.PropPanel:SetVisible( false )
			self.PropPanel:SetTriggerSpawnlistChange( true )
		
		end
	
	end
	
	node.DoClick = function( self )
	
		self:DoPopulate()		
		pnlContent:SwitchPanel( self.PropPanel );
	
	end

end


AddCustomizableNode =  function ( pnlContent, name, icon, parent, needsapp )

	local node = parent:AddNode( name, icon );
	
	SetupCustomNode( node, pnlContent, needsapp )
	
	return node;

end

local function ReadSpawnlists( node, parentid )

	local tab = {}
	tab.name		= node:GetText();
	tab.icon		= node:GetIcon();
	tab.parentid	= parentid;
	tab.id			= SPAWNLIST_ID;
	tab.version		= 3;
	tab.needsapp	= node.NeedsApp;
	
	node:DoPopulate()
		
	if ( IsValid( node.PropPanel ) ) then
		tab.contents = node.PropPanel:ContentsToTable()
	end
	
	if ( SPAWNLIST_ID > 0 ) then
		SPAWNLISTS[ string.format( "%03d", tab.id ) .. "-" .. tab.name ] = util.TableToKeyValues( tab );
	end
	
	SPAWNLIST_ID = SPAWNLIST_ID + 1

	if ( node.ChildNodes ) then
	
		for k, v in pairs( node.ChildNodes:GetChildren() ) do
		
			ReadSpawnlists( v, tab.id )
			
		end
		
	end
	
end

local function ConstructSpawnlist( node )

	SPAWNLIST_ID = 0;
	SPAWNLISTS = {}
	
	ReadSpawnlists( node, 0 )
	local tab = SPAWNLISTS;
	
	SPAWNLISTS = nil
	SPAWNLIST_ID = nil
	
	return tab
	
end

function AddPropsOfParent( pnlContent, node, parentid )

	local Props = spawnmenu.GetPropTable()
	for FileName, Info in SortedPairs( Props ) do
	
		if ( parentid != Info.parentid ) then continue end


		local pnlnode = AddCustomizableNode( pnlContent, Info.name, Info.icon, node, Info.needsapp );
		pnlnode:SetExpanded( true )
		pnlnode.DoPopulate = function( self )
		
			if ( self.PropPanel ) then return end
			
			self.PropPanel = vgui.Create( "ContentContainer", pnlContent )
			self.PropPanel:SetVisible( false )
			
			for i, object in SortedPairs( Info.contents ) do
			
				local cp = spawnmenu.GetContentType( object.type );
				if ( cp ) then cp( self.PropPanel, object ) end
					
			end
			
			self.PropPanel:SetTriggerSpawnlistChange( true )
			
		end
		
		AddPropsOfParent( pnlContent, pnlnode, Info.id )
		
	end	

end

hook.Add( "PopulateContent", "AddCustomContent", function( pnlContent, tree, node )

	local node = AddCustomizableNode( pnlContent, "#spawnmenu.category.your_spawnlists", "", tree )
	node:SetDraggableName( "CustomContent" );
	
	node.DoRightClick = function( self )
	
		local menu = DermaMenu()
		menu:AddOption( "New Category", function() AddCustomizableNode( pnlContent, "New Category", "", node ); node:SetExpanded( true ); hook.Run( "SpawnlistContentChanged" ) end )		
		menu:Open()
	
	end
	
	--
	-- Save the spawnlist when children drag and dropped
	--
	node.OnModified = function()
		hook.Run( "SpawnlistContentChanged" )
	end
	
	AddPropsOfParent( pnlContent, node, 0 )

	node:SetExpanded( true );
	node:MoveToBack();
	
	CustomizableSpawnlistNode = node;
	
	-- Select the first panel
	local FirstNode = node:GetChildNode( 0 )
	if ( IsValid( FirstNode ) ) then
		FirstNode:InternalDoClick()
	end

end )

hook.Add( "OnSaveSpawnlist", "DoSaveSpawnlist", function()

	local Spawnlist = ConstructSpawnlist( CustomizableSpawnlistNode )
	
	spawnmenu.DoSaveToTextFiles( Spawnlist )

end )