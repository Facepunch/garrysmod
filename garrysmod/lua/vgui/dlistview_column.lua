
local PANEL = {}

Derma_Hook( PANEL, "Paint", "Paint", "ListViewHeaderLabel" )
Derma_Hook( PANEL, "ApplySchemeSettings", "Scheme", "ListViewHeaderLabel" )
Derma_Hook( PANEL, "PerformLayout", "Layout", "ListViewHeaderLabel" )

function PANEL:Init()
end

-- No example for this control. Why do we have this control?
function PANEL:GenerateExample( class, tabs, w, h )
end

derma.DefineControl( "DListViewHeaderLabel", "", PANEL, "DLabel" )

--[[---------------------------------------------------------
	DListView_DraggerBar
-----------------------------------------------------------]]

local PANEL = {}

function PANEL:Init()

	self:SetCursor( "sizewe" )

end

function PANEL:Paint()

	return true

end

function PANEL:OnCursorMoved()

	if ( self.Depressed ) then

		local x, y = self:GetParent():CursorPos()

		self:GetParent():ResizeColumn( x )
	end

end

-- No example for this control
function PANEL:GenerateExample( class, tabs, w, h )
end

derma.DefineControl( "DListView_DraggerBar", "", PANEL, "DButton" )

--[[---------------------------------------------------------
	DListView_Column
-----------------------------------------------------------]]

local PANEL = {}

AccessorFunc( PANEL, "m_iMinWidth", "MinWidth" )
AccessorFunc( PANEL, "m_iMaxWidth", "MaxWidth" )

AccessorFunc( PANEL, "m_iTextAlign", "TextAlign" )

AccessorFunc( PANEL, "m_bFixedWidth", "FixedWidth" )
AccessorFunc( PANEL, "m_bDesc", "Descending" )
AccessorFunc( PANEL, "m_iColumnID", "ColumnID" )

Derma_Hook( PANEL, "Paint", "Paint", "ListViewColumn" )
Derma_Hook( PANEL, "ApplySchemeSettings", "Scheme", "ListViewColumn" )
Derma_Hook( PANEL, "PerformLayout", "Layout", "ListViewColumn" )

function PANEL:Init()

	self.Header = vgui.Create( "DButton", self )
	self.Header.DoClick = function() self:DoClick() end
	self.Header.DoRightClick = function() self:DoRightClick() end

	self.DraggerBar = vgui.Create( "DListView_DraggerBar", self )

	self:SetMinWidth( 10 )
	self:SetMaxWidth( 1920 * 10 )

end

function PANEL:SetFixedWidth( i )

	self:SetMinWidth( i )
	self:SetMaxWidth( i )

end

function PANEL:DoClick()

	self:GetParent():SortByColumn( self:GetColumnID(), self:GetDescending() )
	self:SetDescending( !self:GetDescending() )

end

function PANEL:DoRightClick()

end

function PANEL:SetName( strName )

	self.Header:SetText( strName )

end

function PANEL:Paint()
	return true
end

function PANEL:PerformLayout()

	if ( self.m_iTextAlign ) then
		self.Header:SetContentAlignment( self.m_iTextAlign )
	end

	self.Header:SetPos( 0, 0 )
	self.Header:SetSize( self:GetWide(), self:GetParent():GetHeaderHeight() )

	self.DraggerBar:SetWide( 4 )
	self.DraggerBar:StretchToParent( nil, 0, nil, 0 )
	self.DraggerBar:AlignRight()

end

function PANEL:ResizeColumn( iSize )

	self:GetParent():OnRequestResize( self, iSize )

end

function PANEL:SetWidth( iSize )

	iSize = math.Clamp( iSize, self.m_iMinWidth, self.m_iMaxWidth )

	-- If the column changes size we need to lay the data out too
	if ( math.floor( iSize ) != self:GetWide() ) then
		self:GetParent():SetDirty( true )
	end

	self:SetWide( iSize )
	return iSize

end

derma.DefineControl( "DListView_Column", "", table.Copy( PANEL ), "Panel" )

--[[---------------------------------------------------------
	DListView_ColumnPlain
-----------------------------------------------------------]]

function PANEL:Init()

	self.Header = vgui.Create( "DListViewHeaderLabel", self )

	self.DraggerBar = vgui.Create( "DListView_DraggerBar", self )

	self:SetMinWidth( 10 )
	self:SetMaxWidth( 1920 * 10 )

end

derma.DefineControl( "DListView_ColumnPlain", "", PANEL, "Panel" )
