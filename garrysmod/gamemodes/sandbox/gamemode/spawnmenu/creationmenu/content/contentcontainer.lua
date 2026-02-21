
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
	self.IconList.OnMousePressed = function( s, btn )

		-- A bit of a hack
		s:EndBoxSelection()
		if ( btn != MOUSE_RIGHT ) then DPanel.OnMousePressed( s, btn ) end

	end
	self.IconList.OnMouseReleased = function( s, btn )

		DPanel.OnMouseReleased( s, btn )

		if ( btn != MOUSE_RIGHT || s:GetReadOnly() ) then return end

		local menu = DermaMenu()
		menu:AddOption( "#spawnmenu.newlabel", function()

			local label = vgui.Create( "ContentHeader" )
			self:Add( label )

			-- Move the label to player's cursor, but make sure it's per line, not per icon
			local x, y = self.IconList:ScreenToLocal( input.GetCursorPos() )
			label:MoveToAfter( self.IconList:GetClosestChild( self:GetCanvas():GetWide(), y ) )

			self:OnModified()

			-- Scroll to the newly added item
			--[[timer.Simple( 0, function()
				local x, y = label:GetPos()
				self.VBar:AnimateTo( y - self:GetTall() / 2 + label:GetTall() / 2, 0.5, 0, 0.5 )
			end )]]

		end ):SetIcon( "icon16/text_heading_1.png" )
		menu:Open()

	end

	self.IconList.ContentContainer = self

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

	for k, v in ipairs( self.IconList:GetChildren() ) do

		v:RebuildSpawnIcon()

	end

end

--[[---------------------------------------------------------
	Name: GetCount
-----------------------------------------------------------]]
function PANEL:GetCount()

	return #self.IconList:GetChildren()

end

function PANEL:Clear()

	self.IconList:Clear()

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

	for k, v in ipairs( self.IconList:GetChildren() ) do

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

	menu:AddSpacer()

	menu:AddOption( language.GetPhrase( "spawnmenu.menu.deletex" ):format( #selected ), function()

		for k, v in pairs( selected ) do
			v:Remove()
		end

		hook.Run( "SpawnlistContentChanged" )

	end ):SetIcon( "icon16/bin_closed.png" )

	menu:Open()

end )
