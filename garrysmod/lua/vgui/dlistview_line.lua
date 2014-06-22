--[[   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

--]]

local PANEL = {}

--[[---------------------------------------------------------
   Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

	self:SetTextInset( 5, 0 )

end

function PANEL:UpdateColours( skin )

	if ( self:GetParent():IsLineSelected() )	then return self:SetTextStyleColor( skin.Colours.Label.Bright ) end
	
	return self:SetTextStyleColor( skin.Colours.Label.Dark )

end

function PANEL:GenerateExample()

	// Do nothing!

end

derma.DefineControl( "DListViewLabel", "", PANEL, "DLabel" )

local PANEL = {}

Derma_Hook( PANEL, "Paint", "Paint", "ListViewLine" )
Derma_Hook( PANEL, "ApplySchemeSettings", "Scheme", "ListViewLine" )
Derma_Hook( PANEL, "PerformLayout", "Layout", "ListViewLine" )

AccessorFunc( PANEL, "m_iID", 				"ID" )
AccessorFunc( PANEL, "m_pListView", 		"ListView" )
AccessorFunc( PANEL, "m_bAlt", 				"AltLine" )

--[[---------------------------------------------------------
   Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

	self:SetSelectable( true )
	self:SetMouseInputEnabled( true )
	
	self.Columns = {}

end

--[[---------------------------------------------------------
   Name: OnSelect
-----------------------------------------------------------]]
function PANEL:OnSelect()

	-- For override
	
end

--[[---------------------------------------------------------
   Name: OnRightClick
-----------------------------------------------------------]]
function PANEL:OnRightClick()

	-- For override
	
end

--[[---------------------------------------------------------
   Name: OnMousePressed
-----------------------------------------------------------]]
function PANEL:OnMousePressed( mcode )

	if ( mcode == MOUSE_RIGHT ) then
	
		-- This is probably the expected behaviour..
		if ( !self:IsLineSelected() ) then
		
			self:GetListView():OnClickLine( self, true )
			self:OnSelect()

		end
		
		self:GetListView():OnRowRightClick( self:GetID(), self )
		self:OnRightClick()
		
		return
		
	end

	self:GetListView():OnClickLine( self, true )
	self:OnSelect()
	
end

--[[---------------------------------------------------------
   Name: OnMousePressed
-----------------------------------------------------------]]
function PANEL:OnCursorMoved()

	if ( input.IsMouseDown( MOUSE_LEFT ) ) then
		self:GetListView():OnClickLine( self )
	end
	
end

--[[---------------------------------------------------------
   Name: IsLineSelected
-----------------------------------------------------------]]
function PANEL:IsLineSelected()

	return self.m_bSelected

end

--[[---------------------------------------------------------
   Name: SetColumnText
-----------------------------------------------------------]]
function PANEL:SetColumnText( i, strText )

	if ( type( strText ) == "Panel" ) then
	
		if ( IsValid( self.Columns[ i ] ) ) then self.Columns[ i ]:Remove() end
	
		strText:SetParent( self )
		self.Columns[ i ] = strText
		self.Columns[ i ].Value = strText
		return
		
	end

	if ( !IsValid( self.Columns[ i ] ) ) then
	
		self.Columns[ i ] = vgui.Create( "DListViewLabel", self )
		self.Columns[ i ]:SetMouseInputEnabled( false )
		
	end
	
	self.Columns[ i ]:SetText( tostring( strText ) )
	self.Columns[ i ].Value = strText
	return self.Columns[ i ]

end

PANEL.SetValue = PANEL.SetColumnText


--[[---------------------------------------------------------
   Name: SetColumnText
-----------------------------------------------------------]]
function PANEL:GetColumnText( i )

	if ( !self.Columns[ i ] ) then return "" end
	
	return self.Columns[ i ].Value

end

PANEL.GetValue = PANEL.GetColumnText

--[[---------------------------------------------------------
   Name: SetColumnText
-----------------------------------------------------------]]
function PANEL:DataLayout( ListView )

	self:ApplySchemeSettings()

	local height = self:GetTall()
	
	local x = 0
	for k, Column in pairs( self.Columns ) do
	
		local w = ListView:ColumnWidth( k )
		Column:SetPos( x, 0 )
		Column:SetSize( w, height )
		x = x + w
	
	end	

end

derma.DefineControl( "DListViewLine", "A line from the List View", PANEL, "Panel" )
derma.DefineControl( "DListView_Line", "A line from the List View", PANEL, "Panel" )
