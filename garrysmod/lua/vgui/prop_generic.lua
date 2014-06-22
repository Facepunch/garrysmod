
--
-- prop_generic is the base for all other properties. 
-- All the business should be done in :Setup using inline functions.
-- So when you derive from this class - you should ideally only override Setup.
--

local PANEL = {}

AccessorFunc( PANEL, "m_pRow", 		"Row" )

function PANEL:Init()


end

function PANEL:Think()

	--
	-- Periodically update the value
	--
	if ( !self:IsEditing() && isfunction( self.m_pRow.DataUpdate ) ) then

		self.m_pRow:DataUpdate()

	end

end

--
-- Called by this control, or a derived control, to alert the row of the change
--
function PANEL:ValueChanged( newval, bForce )

	if ( (self:IsEditing() || bForce) && isfunction( self.m_pRow.DataChanged ) ) then
	
		self.m_pRow:DataChanged( newval )

	end

end

function PANEL:Setup( vars )

	self:Clear()

	local text = self:Add( "DTextEntry" )
	text:SetUpdateOnType( true )
	text:SetDrawBackground( false )
	text:Dock( FILL )

	-- Return true if we're editing
	self.IsEditing = function( self )
		return text:IsEditing()
	end

	-- Set the value
	self.SetValue = function( self, val )
		text:SetText( util.TypeToString( val ) ) 
	end

	-- Alert row that value changed
	text.OnValueChange = function( text, newval )
			
		self:ValueChanged( newval )

	end

end

derma.DefineControl( "DProperty_Generic", "", PANEL, "Panel" )