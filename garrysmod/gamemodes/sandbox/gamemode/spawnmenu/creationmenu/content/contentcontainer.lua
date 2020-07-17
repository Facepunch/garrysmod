
local PANEL = {}

DEFINE_BASECLASS( "DScrollPanel" )

AccessorFunc( PANEL, "m_pControllerPanel",			"ControllerPanel" )
AccessorFunc( PANEL, "m_strCategoryName",			"CategoryName" )
AccessorFunc( PANEL, "m_bTriggerSpawnlistChange",	"TriggerSpawnlistChange" )

--[[---------------------------------------------------------
	Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

	self:SetPaintBackground( false )

	self.IconList = vgui.Create( "DTileLayout", self:GetCanvas() )
	self.IconList:SetBaseSize( 64 )
	self.IconList:MakeDroppable( "SandboxContentPanel", true )
	self.IconList:SetSelectionCanvas( true )
	--self.IconList:SetUseLiveDrag( true )
	self.IconList:Dock( TOP )
	self.IconList.OnModified = function() self:OnModified() end

end

function PANEL:Add( pnl )

	self.IconList:Add( pnl )

	if ( pnl.InstallMenu ) then
		pnl:InstallMenu( self )
	end

	self:Layout()

end

function PANEL:Layout()

	self.IconList:Layout()
	self:InvalidateLayout()

end

function PANEL:PerformLayout( w, h )

	BaseClass.PerformLayout( self, w, h )
	self.IconList:SetMinHeight( self:GetTall() - 16 )

end

--[[---------------------------------------------------------
	Name: RebuildAll
-----------------------------------------------------------]]
function PANEL:RebuildAll( proppanel )

	local items = self.IconList:GetChildren()

	for k, v in pairs( items ) do

		v:RebuildSpawnIcon()

	end

end

--[[---------------------------------------------------------
	Name: GetCount
-----------------------------------------------------------]]
function PANEL:GetCount()

	local items = self.IconList:GetChildren()
	return #items

end

function PANEL:Clear()

	self.IconList:Clear( true )

end

function PANEL:SetTriggerSpawnlistChange( bTrigger )

	self.m_bTriggerSpawnlistChange = bTrigger
	self.IconList:SetReadOnly( !bTrigger )

end

function PANEL:OnModified()

	if ( !self:GetTriggerSpawnlistChange() ) then return end

	hook.Run( "SpawnlistContentChanged" )

end

function PANEL:ContentsToTable( contentpanel )

	local tab = {}

	local items = self.IconList:GetChildren()

	for k, v in pairs( items ) do

		v:ToTable( tab )

	end

	return tab

end

function PANEL:Copy()

	local copy = vgui.Create( "ContentContainer", self:GetParent() )
	copy:CopyBase( self )

	copy.IconList:CopyContents( self.IconList )

	return copy

end

vgui.Register( "ContentContainer", PANEL, "DScrollPanel" )

hook.Add( "SpawnlistOpenGenericMenu", "DragAndDropSelectionMenu", function( canvas )

	if ( canvas:GetReadOnly() ) then return end

	local selected = canvas:GetSelectedChildren()

	local menu = DermaMenu()
	menu:AddOption( language.GetPhrase( "spawnmenu.menu.deletex" ):format( #selected ), function()

		for k, v in pairs( selected ) do
			v:Remove()
		end

		hook.Run( "SpawnlistContentChanged" )

	end ):SetIcon( "icon16/bin_closed.png" )

	-- This is less than ideal
	local spawnicons = 0
	local icon = nil
	for id, pnl in pairs( selected ) do
		if ( pnl.InternalAddResizeMenu ) then
			spawnicons = spawnicons + 1
			icon = pnl
		end
	end

	if ( spawnicons > 0 ) then
		icon:InternalAddResizeMenu( menu, function( w, h )

			for id, pnl in pairs( selected ) do
				if ( !pnl.InternalAddResizeMenu ) then continue end
				pnl:SetSize( w, h )
				pnl:InvalidateLayout( true )
				pnl:GetParent():OnModified()
				pnl:GetParent():Layout()
				pnl:SetModel( pnl:GetModelName(), pnl:GetSkinID(), pnl:GetBodyGroup() )
			end

		end, language.GetPhrase( "spawnmenu.menu.resizex" ):format( spawnicons ) )

		menu:AddOption( language.GetPhrase( "spawnmenu.menu.rerenderx" ):format( spawnicons ), function()
			for id, pnl in pairs( selected ) do
				if ( !pnl.RebuildSpawnIcon ) then continue end
				pnl:RebuildSpawnIcon()
			end
		end ):SetIcon( "icon16/picture.png" )
	end

	menu:Open()

end )
