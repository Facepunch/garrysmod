
include( "controlpanel.lua" )

local PANEL = {}

AccessorFunc( PANEL, "m_TabID", "TabID" )

function PANEL:Init()

	self.HorizontalDivider = vgui.Create( "DHorizontalDivider", self )
	self.HorizontalDivider:Dock( FILL )
	self.HorizontalDivider:SetLeftWidth( 130 )
	self.HorizontalDivider:SetLeftMin( 130 )
	self.HorizontalDivider:SetRightMin( 256 )
	self.HorizontalDivider:SetDividerWidth( 6 )
	--self.HorizontalDivider:SetCookieName( "SpawnMenuToolMenuDiv" )

	self.List = vgui.Create( "DCategoryList", self.HorizontalDivider )
	self.List:SetWidth( 130 )
	self.HorizontalDivider:SetLeft( self.List )

	self.Content = vgui.Create( "DCategoryList", self.HorizontalDivider )
	self.HorizontalDivider:SetRight( self.Content )

end

function PANEL:LoadToolsFromTable( inTable )

	local inTable = table.Copy( inTable )

	for k, v in pairs( inTable ) do

		if ( istable( v ) ) then

			-- Remove these from the table so we can
			-- send the rest of the table to the other
			-- function

			local Name = v.ItemName
			local Label = v.Text
			v.ItemName = nil
			v.Text = nil

			self:AddCategory( Name, Label, v )

		end

	end

end

function PANEL:AddCategory( Name, Label, tItems )

	local Category = self.List:Add( Label )

	Category:SetCookieName( "ToolMenu." .. tostring( self:GetTabID() ) .. "." .. tostring( Name ) )

	local bAlt = true

	local tools = {}
	for k, v in pairs( tItems ) do
		local str = v.Text
		if ( str:StartWith( "#" ) ) then str = str:sub( 2 ) end
		tools[ language.GetPhrase( str ) ] = v
	end

	for k, v in SortedPairs( tools ) do

		local item = Category:Add( v.Text )

		item.DoClick = function( button )

			spawnmenu.ActivateTool( button.Name )

		end

		item.ControlPanelBuildFunction	= v.CPanelFunction
		item.Command					= v.Command
		item.Name						= v.ItemName
		item.Controls					= v.Controls
		item.Text						= v.Text

	end

	self:InvalidateLayout()

end

function PANEL:SetActive( cp )

	local kids = self.Content:GetCanvas():GetChildren()
	for k, v in pairs( kids ) do
		v:SetVisible( false )
	end

	self.Content:AddItem( cp )
	cp:SetVisible( true )
	cp:Dock( TOP )

end

vgui.Register( "ToolPanel", PANEL, "Panel" )
