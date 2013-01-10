include( 'controlpanel.lua' )

local PANEL = {}


AccessorFunc( PANEL, "m_TabID", 			"TabID" )

--[[---------------------------------------------------------
   Name: Paint
-----------------------------------------------------------]]
function PANEL:Init()

	self.List = vgui.Create( "DCategoryList", self )
	self.List:Dock( LEFT )
	self.List:SetWidth( 130 )
	
	self.Content = vgui.Create( "DCategoryList", self )
	self.Content:Dock( FILL )
	self.Content:DockMargin( 6, 0, 0, 0 )
	
	self:SetWide( 390 )

	if ( ScrW() > 1280 ) then
		self:SetWide( 460 )
	end
	
end


--[[---------------------------------------------------------
   Name: LoadToolsFromTable
-----------------------------------------------------------]]
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

--[[---------------------------------------------------------
   Name: AddCategory
-----------------------------------------------------------]]
function PANEL:AddCategory( Name, Label, tItems )

	local Category = self.List:Add( Label )

	Category:SetCookieName( "ToolMenu."..tostring(Name) )
	
	local bAlt = true
	
	for k, v in pairs( tItems ) do
	
		local item = Category:Add( v.Text )
		
		item.DoClick = function( button ) 
		
			local cp = controlpanel.Get( button.Name )
			if ( !cp:GetInitialized() ) then
				cp:FillViaTable( button )
			end
			
			spawnmenu.ActivateToolPanel( self:GetTabID(), cp )
			
			if ( button.Command ) then
				LocalPlayer():ConCommand( button.Command )
			end
		
		end
		
		item.ControlPanelBuildFunction		= v.CPanelFunction
		item.Command						= v.Command
		item.Name							= v.ItemName
		item.Controls						= v.Controls
		item.Text							= v.Text
	
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