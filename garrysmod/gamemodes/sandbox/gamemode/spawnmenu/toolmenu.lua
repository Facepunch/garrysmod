
include( "toolpanel.lua" )

local PANEL = {}

--[[---------------------------------------------------------
	Name: Paint
-----------------------------------------------------------]]
function PANEL:Init()

	self.ToolPanels = {}

	self:LoadTools()

	self:SetFadeTime( 0 )

end

--[[---------------------------------------------------------
	LoadTools
-----------------------------------------------------------]]
function PANEL:LoadTools()

	local tools = spawnmenu.GetTools()

	for strName, pTable in pairs( tools ) do

		self:AddToolPanel( strName, pTable )

	end

end

--[[---------------------------------------------------------
	AddToolPanel
-----------------------------------------------------------]]
function PANEL:AddToolPanel( Name, ToolTable )

	-- I hate relying on a table's internal structure
	-- but this isn't really that avoidable.

	local Panel = vgui.Create( "ToolPanel" )
	Panel:SetTabID( Name )
	Panel:LoadToolsFromTable( ToolTable.Items )
	Panel.PropertySheet = self
	Panel.PropertySheetTab = self:AddSheet( ToolTable.Label, Panel, ToolTable.Icon ).Tab

	self.ToolPanels[ Name ] = Panel

end

--[[---------------------------------------------------------
	Name: Paint
-----------------------------------------------------------]]
function PANEL:Paint( w, h )

	DPropertySheet.Paint( self, w, h )

end

--[[---------------------------------------------------------
	Name: GetToolPanel
-----------------------------------------------------------]]
function PANEL:GetToolPanel( id )

	return self.ToolPanels[ id ]

end

vgui.Register( "ToolMenu", PANEL, "DPropertySheet" )
