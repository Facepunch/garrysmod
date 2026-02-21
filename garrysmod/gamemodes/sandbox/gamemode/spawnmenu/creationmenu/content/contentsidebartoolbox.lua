
include( "contentheader.lua" )

local PANEL = {}

Derma_Hook( PANEL, "Paint", "Paint", "Tree" )
PANEL.m_bBackground = true -- Hack for above

function PANEL:Init()

	self:SetOpenSize( 200 )
	self:DockPadding( 5, 5, 5, 5 )

	local label = vgui.Create( "DTextEntry", self )
	label:Dock( TOP )
	label:SetZPos( 1 )
	label:DockMargin( 0, 0, 0, 2 )
	label:SetTooltip( "#spawnmenu.listname_tooltip" )

	local panel = vgui.Create( "DPanel", self )
	panel:Dock( TOP )
	panel:SetZPos( 2 )
	panel:SetSize( 24, 24 )
	panel:DockPadding( 2, 2, 2, 2 )

	local Button = vgui.Create( "DImageButton", panel )
	Button:SetImage( "icon16/text_heading_1.png" )
	Button:Dock( LEFT )
	Button:SetStretchToFit( false )
	Button:SetSize( 20, 20 )
	Button:SetCursor( "sizeall" )
	Button:SetTooltip( "#spawnmenu.header_tooltip" )
	Button:Droppable( "SandboxContentPanel" )

	Button.OnDrop = function( s, target )

		local label = vgui.Create( "ContentHeader", target )
		return label

	end

	local panel = vgui.Create( "Panel", self )
	panel:Dock( FILL )
	panel:SetZPos( 3 )

	local icon_filter = vgui.Create( "DTextEntry", panel )
	icon_filter:Dock( TOP )
	icon_filter:SetUpdateOnType( true )
	icon_filter:SetPlaceholderText( "#spawnmenu.quick_filter" )
	icon_filter:DockMargin( 0, 2, 0, 1 )

	local icons = vgui.Create( "DIconBrowser", panel )
	icons:Dock( FILL )

	icon_filter.OnValueChange = function( s, str )
		icons:FilterByText( str )
	end

	local overlay = vgui.Create( "DPanel", self )
	overlay:SetZPos( 9999 )
	overlay.Paint = function( s, w, h )
		draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0, 200 ) )
	end
	self.Overlay = overlay

	--
	-- If we select a node from the sidebar, update the text/icon/actions in the toolbox (at the bottom)
	--
	hook.Add( "ContentSidebarSelection", "SidebarToolboxSelection", function( pnlContent, node )

		if ( !IsValid( node ) || !IsValid( label ) || !IsValid( icons ) ) then return end

		if ( node.CustomSpawnlist ) then
			label:SetText( node:GetText() )
			icons:SelectIcon( node:GetIcon() )
			icons:ScrollToSelected()
			overlay:SetVisible( false )
		else
			label:SetText( "" )
			overlay:SetVisible( true )
		end

		label.OnChange = function()
			if ( !node.CustomSpawnlist ) then return end
			node:SetText( label:GetText() )
			hook.Run( "SpawnlistContentChanged" )
		end

		icons.OnChange = function()
			if ( !node.CustomSpawnlist ) then return end
			node:SetIcon( icons:GetSelectedIcon() )
			hook.Run( "SpawnlistContentChanged" )
		end

	end )

end

function PANEL:PerformLayout()
	-- Not using docking because it will mess up other elements using docking!
	self.Overlay:SetSize( self:GetSize() )
end

vgui.Register( "ContentSidebarToolbox", PANEL, "DDrawer" )
