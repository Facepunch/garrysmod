
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

	hook.Add( "OpenToolbox", "OpenToolbox", function()

		if ( !IsValid( self.Toolbox ) ) then return end

		self.Toolbox:Open()

	end )

end

function PANEL:CreateSaveNotification()

	local SavePanel = vgui.Create( "DButton", self )
	SavePanel:Dock( TOP )
	SavePanel:DockMargin( 16, 1, 16, 4 )
	SavePanel:SetIcon( "icon16/disk.png" )
	SavePanel:SetText( "#spawnmenu.savechanges" )
	SavePanel:SetVisible( false )

	SavePanel.DoClick = function()

		SavePanel:SlideUp( 0.2 )
		hook.Run( "OnSaveSpawnlist" )

	end

	hook.Add( "SpawnlistContentChanged", "ShowSaveButton", function()

		if ( SavePanel:IsVisible() ) then return end

		SavePanel:SlideDown( 0.2 )

		GAMEMODE:AddHint( "EditingSpawnlistsSave", 5 )

	end )

end

vgui.Register( "ContentSidebar", PANEL, "DPanel" )
