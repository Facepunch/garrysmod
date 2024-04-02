
--
-- prop_generic is the base for all other properties.
-- All the business should be done in :Setup using inline functions.
-- So when you derive from this class - you should ideally only override Setup.
--

local PANEL = {}

AccessorFunc( PANEL, "m_pRow", "Row" )

function PANEL:Init()
end

function PANEL:Think()

	--
	-- Periodically update the value
	--
	if ( !self:IsEditing() and isfunction( self.m_pRow.DataUpdate ) ) then

		self.m_pRow:DataUpdate()

	end

end

--
-- Called by this control, or a derived control, to alert the row of the change
--
function PANEL:ValueChanged( newval, bForce )

	if ( ( self:IsEditing() or bForce ) and isfunction( self.m_pRow.DataChanged ) ) then

		self.m_pRow:DataChanged( newval )

	end

end

function PANEL:Setup( vars )

	self:Clear()

	local text = self:Add( "DTextEntry" )
	if ( !vars or !vars.waitforenter ) then text:SetUpdateOnType( true ) end
	text:SetPaintBackground( false )
	text:Dock( FILL )

	-- Return true if we're editing
	self.IsEditing = function( slf )
		return text:IsEditing()
	end

	-- Enabled/disabled support
	self.IsEnabled = function( slf )
		return text:IsEnabled()
	end
	self.SetEnabled = function( slf, b )
		text:SetEnabled( b )
	end

	-- Set the value
	self.SetValue = function( slf, val )
		text:SetText( util.TypeToString( val ) )
	end

	-- Alert row that value changed
	text.OnValueChange = function( slf, newval )

		self:ValueChanged( newval )

	end

end

derma.DefineControl( "DProperty_Generic", "", PANEL, "Panel" )
