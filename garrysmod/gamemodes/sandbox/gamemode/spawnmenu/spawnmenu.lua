
local spawnmenu_border = CreateConVar( "spawnmenu_border", "0.1", { FCVAR_ARCHIVE } )

include( "toolmenu.lua" )
include( "contextmenu.lua" )
include( "creationmenu.lua" )

local PANEL = {}

function PANEL:Init()

	self:Dock( FILL )

	self.HorizontalDivider = vgui.Create( "DHorizontalDivider", self )
	self.HorizontalDivider:Dock( FILL )
	self.HorizontalDivider:SetLeftWidth( ScrW() ) -- It will be automatically resized by DHorizontalDivider to account for GetRightMin/GetLeftMin
	self.HorizontalDivider:SetDividerWidth( 6 )
	self.HorizontalDivider:SetCookieName( "SpawnMenuDiv" )
	self.HorizontalDivider:SetRightMin( 300 )
	if ( ScrW() >= 1024 ) then self.HorizontalDivider:SetRightMin( 460 ) end

	self.ToolMenu = vgui.Create( "ToolMenu", self.HorizontalDivider )
	self.HorizontalDivider:SetRight( self.ToolMenu )

	self.CreateMenu = vgui.Create( "CreationMenu", self.HorizontalDivider )
	self.HorizontalDivider:SetLeft( self.CreateMenu )

	self.m_bHangOpen = false

	self:SetMouseInputEnabled( true )

	self.ToolToggle = vgui.Create( "DImageButton", self )
	self.ToolToggle:SetMaterial( "gui/spawnmenu_toggle" )
	self.ToolToggle:SetSize( 16, 16 )
	self.ToolToggle.DoClick = function()

		self.ToolMenu:SetVisible( !self.ToolMenu:IsVisible() )
		self:InvalidateLayout()

		if ( self.ToolMenu:IsVisible() ) then
			self.ToolToggle:SetMaterial( "gui/spawnmenu_toggle" )
			self.CreateMenu:Dock( NODOCK ) -- What an ugly hack
			self.HorizontalDivider:SetRight( self.ToolMenu )
			self.HorizontalDivider:SetLeft( self.CreateMenu )
		else
			self.ToolToggle:SetMaterial( "gui/spawnmenu_toggle_back" )
			self.HorizontalDivider:SetRight( nil ) -- What an ugly hack
			self.HorizontalDivider:SetLeft( nil )
			self.CreateMenu:SetParent( self.HorizontalDivider )
			self.CreateMenu:Dock( FILL )
		end

	end

end

function PANEL:OpenCreationMenuTab( name )

	self.CreateMenu:SwitchToName( name )

end

function PANEL:GetToolMenu()
	return self.ToolMenu
end

--[[---------------------------------------------------------
	Name: OnClick
-----------------------------------------------------------]]
function PANEL:OnMousePressed()

	self:Close()

end

--[[---------------------------------------------------------
	Name: HangOpen
-----------------------------------------------------------]]
function PANEL:HangOpen( bHang )
	self.m_bHangOpen = bHang
end

--[[---------------------------------------------------------
	Name: HangingOpen
-----------------------------------------------------------]]
function PANEL:HangingOpen()
	return self.m_bHangOpen
end

--[[---------------------------------------------------------
	Name: Paint
-----------------------------------------------------------]]
function PANEL:Open()

	RestoreCursorPosition()

	self.m_bHangOpen = false

	-- If the context menu is open, try to close it..
	if ( IsValid( g_ContextMenu ) && g_ContextMenu:IsVisible() ) then
		g_ContextMenu:Close( true )
	end

	if ( self:IsVisible() ) then return end

	CloseDermaMenus()

	self:MakePopup()
	self:SetVisible( true )
	self:SetKeyboardInputEnabled( false )
	self:SetMouseInputEnabled( true )
	self:SetAlpha( 255 )

	achievements.SpawnMenuOpen()

	if ( IsValid( self.StartupTool ) && self.StartupTool.Name ) then
		self.StartupTool:SetSelected( true )
		spawnmenu.ActivateTool( self.StartupTool.Name, true )
		self.StartupTool = nil
	end

end

--[[---------------------------------------------------------
	Name: Paint
-----------------------------------------------------------]]
function PANEL:Close( bSkipAnim )

	if ( self.m_bHangOpen ) then
		self.m_bHangOpen = false
		return
	end

	RememberCursorPosition()

	CloseDermaMenus()

	self:SetKeyboardInputEnabled( false )
	self:SetMouseInputEnabled( false )
	self:SetVisible( false )

end

function PANEL:PerformLayout()

	local MarginX = math.Clamp( ( ScrW() - 1024 ) * spawnmenu_border:GetFloat(), 25, 256 )
	local MarginY = math.Clamp( ( ScrH() - 768 ) * spawnmenu_border:GetFloat(), 25, 256 )

	-- At this size we can't spare any space for emptiness
	if ( ScrW() < 1024 || ScrH() < 768 ) then
		MarginX = 0
		MarginY = 0
	end

	self:DockPadding( 0, 0, 0, 0 )
	self.HorizontalDivider:DockMargin( MarginX, MarginY, MarginX, MarginY )
	self.HorizontalDivider:SetLeftMin( self.HorizontalDivider:GetWide() / 3 )

	self.ToolToggle:AlignRight( 6 )
	self.ToolToggle:AlignTop( 6 )

end

function PANEL:StartKeyFocus( pPanel )

	self.m_pKeyFocus = pPanel
	self:SetKeyboardInputEnabled( true )
	self:HangOpen( true )

end

function PANEL:EndKeyFocus( pPanel )

	if ( self.m_pKeyFocus != pPanel ) then return end
	self:SetKeyboardInputEnabled( false )

end

function PANEL:OnSizeChanged( newW, newH )
	local divW = self.HorizontalDivider:GetWide()
	local divL = self.HorizontalDivider:GetLeftWidth()
	self:InvalidateLayout( true )
	local divWnew = self.HorizontalDivider:GetWide()

	if ( divW > divL && divW < divWnew ) then
		local ratio = divL / divW
		self.HorizontalDivider:SetLeftWidth( ratio * divWnew )
	end
end

vgui.Register( "SpawnMenu", PANEL, "EditablePanel" )

--[[---------------------------------------------------------
	Called to create the spawn menu..
-----------------------------------------------------------]]
local function CreateSpawnMenu()

	if ( !hook.Run( "SpawnMenuEnabled" ) ) then return end

	-- If we have an old spawn menu remove it.
	if ( IsValid( g_SpawnMenu ) ) then
		g_SpawnMenu:Remove()
		g_SpawnMenu = nil
	end

	hook.Run( "PreReloadToolsMenu" )

	-- Start Fresh
	spawnmenu.ClearToolMenus()

	-- Add defaults for the gamemode. In sandbox these defaults
	-- are the Main/Postprocessing/Options tabs.
	-- They're added first in sandbox so they're always first
	hook.Run( "AddGamemodeToolMenuTabs" )

	-- Use this hook to add your custom tools
	-- This ensures that the default tabs are always
	-- first.
	hook.Run( "AddToolMenuTabs" )

	-- Use this hook to add your custom tools
	-- We add the gamemode tool menu categories first
	-- to ensure they're always at the top.
	hook.Run( "AddGamemodeToolMenuCategories" )
	hook.Run( "AddToolMenuCategories" )

	-- Add the tabs to the tool menu before trying
	-- to populate them with tools.
	hook.Run( "PopulateToolMenu" )

	g_SpawnMenu = vgui.Create( "SpawnMenu" )

	if ( IsValid( g_SpawnMenu ) ) then
		g_SpawnMenu:SetVisible( false )
		hook.Run( "SpawnMenuCreated", g_SpawnMenu )
	end

	CreateContextMenu()

	hook.Run( "PostReloadToolsMenu" )

end
-- Hook to create the spawnmenu at the appropriate time (when all sents and sweps are loaded)
hook.Add( "OnGamemodeLoaded", "CreateSpawnMenu", CreateSpawnMenu )
concommand.Add( "spawnmenu_reload", CreateSpawnMenu )

function GM:OnSpawnMenuOpen()

	-- Let the gamemode decide whether we should open or not..
	if ( !hook.Call( "SpawnMenuOpen", self ) ) then return end

	if ( IsValid( g_SpawnMenu ) ) then
		g_SpawnMenu:Open()
		menubar.ParentTo( g_SpawnMenu )
	end

	hook.Call( "SpawnMenuOpened", self )

end

function GM:OnSpawnMenuClose()

	if ( IsValid( g_SpawnMenu ) ) then g_SpawnMenu:Close() end
	hook.Call( "SpawnMenuClosed", self )

end

--[[---------------------------------------------------------
	Name: HOOK SpawnMenuKeyboardFocusOn
		Called when text entry needs keyboard focus
-----------------------------------------------------------]]
local function SpawnMenuKeyboardFocusOn( pnl )

	if ( IsValid( g_SpawnMenu ) && IsValid( pnl ) && pnl:HasParent( g_SpawnMenu ) ) then
		g_SpawnMenu:StartKeyFocus( pnl )
	end
	if ( IsValid( g_ContextMenu ) && IsValid( pnl ) && pnl:HasParent( g_ContextMenu ) ) then
		g_ContextMenu:StartKeyFocus( pnl )
	end

end
hook.Add( "OnTextEntryGetFocus", "SpawnMenuKeyboardFocusOn", SpawnMenuKeyboardFocusOn )

--[[---------------------------------------------------------
	Name: HOOK SpawnMenuKeyboardFocusOff
		Called when text entry stops needing keyboard focus
-----------------------------------------------------------]]
local function SpawnMenuKeyboardFocusOff( pnl )

	if ( IsValid( g_SpawnMenu ) && IsValid( pnl ) && pnl:HasParent( g_SpawnMenu ) ) then
		g_SpawnMenu:EndKeyFocus( pnl )
	end

	if ( IsValid( g_ContextMenu ) && IsValid( pnl ) && pnl:HasParent( g_ContextMenu ) ) then
		g_ContextMenu:EndKeyFocus( pnl )
	end

end
hook.Add( "OnTextEntryLoseFocus", "SpawnMenuKeyboardFocusOff", SpawnMenuKeyboardFocusOff )

--[[---------------------------------------------------------
	Name: HOOK SpawnMenuOpenGUIMousePressed
		Don't do context screen clicking if spawnmenu is open
-----------------------------------------------------------]]
local function SpawnMenuOpenGUIMousePressed()

	if ( !IsValid( g_SpawnMenu ) ) then return end
	if ( !g_SpawnMenu:IsVisible() ) then return end

	return true

end
hook.Add( "GUIMousePressed", "SpawnMenuOpenGUIMousePressed", SpawnMenuOpenGUIMousePressed )

--[[---------------------------------------------------------
	Name: HOOK SpawnMenuOpenGUIMousePressed
		Close spawnmenu if it's open
-----------------------------------------------------------]]
local function SpawnMenuOpenGUIMouseReleased()

	if ( !IsValid( g_SpawnMenu ) ) then return end
	if ( !g_SpawnMenu:IsVisible() ) then return end

	g_SpawnMenu:Close()

	return true

end

hook.Add( "GUIMouseReleased", "SpawnMenuOpenGUIMouseReleased", SpawnMenuOpenGUIMouseReleased )

--[[---------------------------------------------------------
	Handle spawn menu language switching

	- The spawn menu needs to be recreated ("refreshed") after a language switch

	- We SHOULDN'T refresh it if the user has unsaved changes to their spawn list (these would be lost!)
	- We SHOULDN'T refresh it if the user has the spawn menu open (that would be bad user experience)
	- But, we SHOULD refresh it if the user saves or reverts any changes and closes the spawn menu

	- What if the user switches BACK to the original language they were using? Surely, a refresh is not needed now?
		- No, in this case we should still refresh the spawn menu because some text and labels do actually update during use of the spawn menu and might be left "dirty"
-----------------------------------------------------------]]
local function SpawnMenuLanguageChanged()
	if ( !IsValid( g_SpawnMenu ) ) then return end

	if ( g_SpawnMenu.m_UnsavedModifications || g_SpawnMenu:IsVisible() ) then
		-- If there are unsaved modifications, or the spawn menu is somehow open, mark the spawn menu for recreation when the opportunity arises
		g_SpawnMenu.m_NeedsLanguageRefresh = true
	else
		-- If there are no unsaved modifications, and the spawn menu isn't open, we can go ahead and safely refresh the spawn menu
		CreateSpawnMenu()
	end
end
-- When gmod_language changes, call SpawnMenuLanguageChanged
cvars.AddChangeCallback( "gmod_language", SpawnMenuLanguageChanged, "spawnmenu_reload" )

local function ProtectSpawnMenuChanges()
	if ( !IsValid( g_SpawnMenu ) ) then return end

	-- Mark the spawn menu as having unsaved modifications
	g_SpawnMenu.m_UnsavedModifications = true
end
hook.Add( "SpawnlistContentChanged", "ProtectSpawnMenuChanges", ProtectSpawnMenuChanges )

local function SpawnMenuChangesFinished()
	if ( !IsValid( g_SpawnMenu ) ) then return end

	-- Mark the spawn menu as no longer having unsaved modifications
	g_SpawnMenu.m_UnsavedModifications = nil
end
hook.Add( "OnRevertSpawnlist", "SpawnMenuChangesFinished", SpawnMenuChangesFinished )
hook.Add( "OnSaveSpawnlist", "SpawnMenuChangesFinished", SpawnMenuChangesFinished )

local function SpawnMenuLanguageRefresh()
	if ( !IsValid( g_SpawnMenu ) ) then return end

	-- When the spawn menu is closed, check if it needs a language refresh. If it has no unsaved modifications, refresh it!
	if ( !g_SpawnMenu.m_UnsavedModifications && g_SpawnMenu.m_NeedsLanguageRefresh ) then
		g_SpawnMenu.m_NeedsLanguageRefresh = nil
		CreateSpawnMenu()
	end
end
hook.Add( "OnSpawnMenuClose", "SpawnMenuLanguageRefresh", SpawnMenuLanguageRefresh )
