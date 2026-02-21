
include( "contentsidebartoolbox.lua" )

local pnlSearch = vgui.RegisterFile( "contentsearch.lua" )

local PANEL = {}

function PANEL:Init()

	self.Tree = vgui.Create( "DTree", self )
	self.Tree:SetClickOnDragHover( true )
	self.Tree.OnNodeSelected = function( Tree, Node ) hook.Call( "ContentSidebarSelection", GAMEMODE, self:GetParent(), Node ) end
	self.Tree:Dock( FILL )
	self.Tree:SetBackgroundColor( Color( 240, 240, 240, 255 ) )

	self:SetPaintBackground( false )

end

function PANEL:EnableSearch( stype, hookname )
	self.Search = vgui.CreateFromTable( pnlSearch, self )
	self.Search:SetSearchType( stype, hookname or "PopulateContent" )
end

function PANEL:EnableModify()

	self:EnableSearch()
	self:CreateSaveNotification()

	self.Toolbox = vgui.Create( "ContentSidebarToolbox", self )
	self.Toolbox:Dock( BOTTOM )

	hook.Add( "OpenToolbox", "OpenToolbox", function()

		if ( !IsValid( self.Toolbox ) ) then return end

		self.Toolbox:Open()

	end )

end

function PANEL:CreateSaveNotification()

	local SavePanel = vgui.Create( "Panel", self )
	SavePanel:Dock( TOP )
	SavePanel:SetVisible( false )
	SavePanel:DockMargin( 8, 1, 8, 4 )

	local SaveButton = vgui.Create( "DButton", SavePanel )
	SaveButton:Dock( FILL )
	SaveButton:SetIcon( "icon16/disk.png" )
	SaveButton:SetText( "#spawnmenu.savechanges" )
	SaveButton.DoClick = function()

		SavePanel:SlideUp( 0.2 )
		hook.Run( "OnSaveSpawnlist" )

	end

	local RevertButton = vgui.Create( "DButton", SavePanel )
	RevertButton:Dock( RIGHT )
	RevertButton:SetIcon( "icon16/arrow_rotate_clockwise.png" )
	RevertButton:SetText( "" )
	RevertButton:SetTooltip( "#spawnmenu.revert_tooptip" )
	RevertButton:SetWide( 26 )
	RevertButton:DockMargin( 4, 0, 0, 0 )
	RevertButton.DoClick = function()

		SavePanel:SlideUp( 0.2 )
		hook.Run( "OnRevertSpawnlist" )

	end

	hook.Add( "SpawnlistContentChanged", "ShowSaveButton", function()

		if ( SavePanel:IsVisible() ) then return end

		SavePanel:SlideDown( 0.2 )

		GAMEMODE:AddHint( "EditingSpawnlistsSave", 5 )

	end )

end

vgui.Register( "ContentSidebar", PANEL, "DPanel" )
