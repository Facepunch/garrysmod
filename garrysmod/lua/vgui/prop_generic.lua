--[[   _
    ( )
   _| |   __   _ __   ___ ___     _ _
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_)

	DProperty_Generic

--]]

--
-- prop_generic is the base for all other properties.
-- All the business should be done in :Setup using inline functions.
-- So when you derive from this class - you should ideally only override Setup.
--

local PANEL = {}

AccessorFunc( PANEL, "m_pRow", 		"Row" )

--[[---------------------------------------------------------
   Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

end

--[[---------------------------------------------------------
   Name: Think
-----------------------------------------------------------]]
function PANEL:Think()

	--
	-- Periodically update the value
	--
	if ( !self:IsEditing() && isfunction( self.m_pRow.DataUpdate ) ) then

		self.m_pRow:DataUpdate()

	end

end

--[[---------------------------------------------------------
   Name: ValueChanged
   Desc: Called by this control, or a derived control, to
   alert the row of the change
-----------------------------------------------------------]]
function PANEL:ValueChanged( newval, bForce )

	if ( (self:IsEditing() || bForce) && isfunction( self.m_pRow.DataChanged ) ) then

		self.m_pRow:DataChanged( newval )

	end

end

--[[---------------------------------------------------------
   Name: Setup
-----------------------------------------------------------]]
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