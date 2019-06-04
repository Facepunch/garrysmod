
local PANEL = {}

AccessorFunc( PANEL, "m_bHangOpen", "HangOpen" )

function PANEL:Init()

	--
	-- This makes it so that when you're hovering over this panel
	-- you can `click` on the world. Your viewmodel will aim etc.
	--
	self:SetWorldClicker( true )

	self.Canvas = vgui.Create( "DCategoryList", self )
	self.m_bHangOpen = false

	self:Dock( FILL )

end

function PANEL:Open()

	self:SetHangOpen( false )

	-- If the spawn menu is open, try to close it..
	if ( IsValid( g_SpawnMenu ) && g_SpawnMenu:IsVisible() ) then
		g_SpawnMenu:Close( true )
	end

	if ( self:IsVisible() ) then return end

	CloseDermaMenus()

	self:MakePopup()
	self:SetVisible( true )
	self:SetKeyboardInputEnabled( false )
	self:SetMouseInputEnabled( true )

	RestoreCursorPosition()

	local bShouldShow = true

	-- TODO: Any situation in which we shouldn't show the tool menu on the context menu?

	-- Set up the active panel..
	if ( bShouldShow && IsValid( spawnmenu.ActiveControlPanel() ) ) then

		self.OldParent = spawnmenu.ActiveControlPanel():GetParent()
		self.OldPosX, self.OldPosY = spawnmenu.ActiveControlPanel():GetPos()
		spawnmenu.ActiveControlPanel():SetParent( self )
		self.Canvas:Clear()
		self.Canvas:AddItem( spawnmenu.ActiveControlPanel() )
		self.Canvas:Rebuild()
		self.Canvas:SetVisible( true )

	else

		self.Canvas:SetVisible( false )

	end

	self:InvalidateLayout( true )

end

function PANEL:Close( bSkipAnim )

	if ( self:GetHangOpen() ) then
		self:SetHangOpen( false )
		return
	end

	RememberCursorPosition()

	CloseDermaMenus()

	self:SetKeyboardInputEnabled( false )
	self:SetMouseInputEnabled( false )

	self:SetAlpha( 255 )
	self:SetVisible( false )
	self:RestoreControlPanel()

end

function PANEL:PerformLayout()

	if ( IsValid( spawnmenu.ActiveControlPanel() ) ) then

		spawnmenu.ActiveControlPanel():InvalidateLayout( true )

		local Tall = math.min( spawnmenu.ActiveControlPanel():GetTall() + 10, ScrH() * 0.8 )
		if ( self.Canvas:GetTall() != Tall ) then self.Canvas:SetTall( Tall ) end
		if ( self.Canvas:GetWide() != 320 ) then self.Canvas:SetWide( 320 ) end

		self.Canvas:SetPos( ScrW() - self.Canvas:GetWide() - 50, ScrH() - 50 - Tall )
		self.Canvas:InvalidateLayout( true )

	end

end

function PANEL:StartKeyFocus( pPanel )

	self:SetKeyboardInputEnabled( true )
	self:SetHangOpen( true )

end

function PANEL:EndKeyFocus( pPanel )

	self:SetKeyboardInputEnabled( false )

end

function PANEL:RestoreControlPanel()

	-- Restore the active panel
	if ( !spawnmenu.ActiveControlPanel() ) then return end
	if ( !self.OldParent ) then return end

	spawnmenu.ActiveControlPanel():SetParent( self.OldParent )
	spawnmenu.ActiveControlPanel():SetPos( self.OldPosX, self.OldPosY )

	self.OldParent = nil

end

--
-- Note here: EditablePanel is important! Child panels won't be able to get
-- keyboard input if it's a DPanel or a Panel. You need to either have an EditablePanel
-- or a DFrame (which is derived from EditablePanel) as your first panel attached to the system.
--
vgui.Register( "ContextMenu", PANEL, "EditablePanel" )

function CreateContextMenu()

	if ( !hook.Run( "ContextMenuEnabled" ) ) then return end

	if ( IsValid( g_ContextMenu ) ) then
		g_ContextMenu:Remove()
		g_ContextMenu = nil
	end

	g_ContextMenu = vgui.Create( "ContextMenu" )

	if ( !IsValid( g_ContextMenu ) ) then return end

	g_ContextMenu:SetVisible( false )

	--
	-- We're blocking clicks to the world - but we don't want to
	-- so feed clicks to the proper functions..
	--
	g_ContextMenu.OnMousePressed = function( p, code )
		hook.Run( "GUIMousePressed", code, gui.ScreenToVector( gui.MousePos() ) )
	end
	g_ContextMenu.OnMouseReleased = function( p, code )
		hook.Run( "GUIMouseReleased", code, gui.ScreenToVector( gui.MousePos() ) )
	end

	hook.Run( "ContextMenuCreated", g_ContextMenu )

	local IconLayout = g_ContextMenu:Add( "DIconLayout" )
	IconLayout:SetBorder( 8 )
	IconLayout:SetSpaceX( 8 )
	IconLayout:SetSpaceY( 8 )
	IconLayout:SetLayoutDir( LEFT )
	IconLayout:SetWorldClicker( true )
	IconLayout:SetStretchWidth( true )
	IconLayout:SetStretchHeight( false ) -- No infinite re-layouts
	IconLayout:Dock( LEFT )

	-- This overrides DIconLayout's OnMousePressed (which is inherited from DPanel), but we don't care about that in this case
	IconLayout.OnMousePressed = function( s, ... ) s:GetParent():OnMousePressed( ... ) end

	for k, v in pairs( list.Get( "DesktopWindows" ) ) do

		local icon = IconLayout:Add( "DButton" )
		icon:SetText( "" )
		icon:SetSize( 80, 82 )
		icon.Paint = function() end

		local image = icon:Add( "DImage" )
		image:SetImage( v.icon )
		image:SetSize( 64, 64 )
		image:Dock( TOP )
		image:DockMargin( 8, 0, 8, 0 )

		local label = icon:Add( "DLabel" )
		label:Dock( BOTTOM )
		label:SetText( v.title )
		label:SetContentAlignment( 5 )
		label:SetTextColor( Color( 255, 255, 255, 255 ) )
		label:SetExpensiveShadow( 1, Color( 0, 0, 0, 200 ) )

		icon.DoClick = function()

			--
			-- v might have changed using autorefresh so grab it again
			--
			local newv = list.Get( "DesktopWindows" )[ k ]

			if ( v.onewindow ) then
				if ( IsValid( icon.Window ) ) then icon.Window:Center() return end
			end

			-- Make the window
			icon.Window = g_ContextMenu:Add( "DFrame" )
			icon.Window:SetSize( newv.width, newv.height )
			icon.Window:SetTitle( newv.title )
			icon.Window:Center()

			newv.init( icon, icon.Window )

		end

	end

end

function GM:OnContextMenuOpen()

	-- Let the gamemode decide whether we should open or not..
	if ( !hook.Call( "ContextMenuOpen", self ) ) then return end

	if ( IsValid( g_ContextMenu ) && !g_ContextMenu:IsVisible() ) then
		g_ContextMenu:Open()
		menubar.ParentTo( g_ContextMenu )
	end

	hook.Call( "ContextMenuOpened", self )

end

function GM:OnContextMenuClose()

	if ( IsValid( g_ContextMenu ) ) then g_ContextMenu:Close() end
	hook.Call( "ContextMenuClosed", self )

end
