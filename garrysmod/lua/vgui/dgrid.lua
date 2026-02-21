
local PANEL = {}

AccessorFunc( PANEL, "m_iCols", "Cols" )
AccessorFunc( PANEL, "m_iColWide", "ColWide" )
AccessorFunc( PANEL, "m_iRowHeight", "RowHeight" )

function PANEL:Init()

	self.Items = {}

	self:SetCols( 4 )
	self:SetColWide( 32 )
	self:SetRowHeight( 32 )

	self:SetMouseInputEnabled( true )

end

function PANEL:GetItems()

	-- Should we return a copy of this to stop
	-- people messing with it?
	return self.Items

end

function PANEL:AddItem( item )

	if ( !IsValid( item ) ) then return end

	item:SetVisible( true )
	item:SetParent( self )

	table.insert( self.Items, item )

	self:InvalidateLayout()

end

function PANEL:RemoveItem( item, bDontDelete )

	for k, panel in pairs( self.Items ) do

		if ( panel == item ) then

			table.remove( self.Items, k )

			if ( !bDontDelete ) then
				panel:Remove()
			end

			self:InvalidateLayout()

		end

	end

end

function PANEL:PerformLayout()

	local i = 0

	self.m_iCols = math.floor( self.m_iCols )
	self.m_iRowHeight = math.floor( self.m_iRowHeight )
	self.m_iColWide = math.floor( self.m_iColWide )

	for k, panel in pairs( self.Items ) do

		if ( !panel:IsVisible() ) then continue end

		local x = ( i % self.m_iCols ) * self.m_iColWide
		local y = math.floor( i / self.m_iCols ) * self.m_iRowHeight

		panel:SetPos( x, y )

		i = i + 1
	end

	self:SetWide( self.m_iColWide * self.m_iCols )
	self:SetTall( math.ceil( i / self.m_iCols ) * self.m_iRowHeight )

end

function PANEL:SortByMember( key, desc )

	if ( desc == nil ) then
		desc = true
	end

	table.sort( self.Items, function( a, b )

		if ( desc ) then

			local ta = a
			local tb = b

			a = tb
			b = ta

		end

		if ( a[ key ] == nil ) then return false end
		if ( b[ key ] == nil ) then return true end

		return a[ key ] > b[ key ]

	end )

end

function PANEL:Clear()

	for k, panel in ipairs( self:GetChildren() ) do
		panel:Remove()
	end
	self.Items = {}

end

derma.DefineControl( "DGrid", "A really simple grid layout panel", PANEL, "Panel" )
