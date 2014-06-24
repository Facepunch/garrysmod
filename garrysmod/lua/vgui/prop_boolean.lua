--[[   _
    ( )
   _| |   __   _ __   ___ ___     _ _
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_)

	DProperty_Boolean

--]]

--
-- prop_generic is the base for all other properties.
-- All the business should be done in :Setup using inline functions.
-- So when you derive from this class - you should ideally only override Setup.
--

local PANEL = {}

--[[---------------------------------------------------------
   Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

end

--[[---------------------------------------------------------
   Name: Setup
-----------------------------------------------------------]]
function PANEL:Setup( vars )

	self:Clear()

	local ctrl = self:Add( "DCheckBox" )
	ctrl:SetPos( 0, 2 )

	-- Return true if we're editing
	self.IsEditing = function( self )
		return ctrl:IsEditing()
	end

	-- Set the value
	self.SetValue = function( self, val )
		ctrl:SetChecked( util.tobool( val ) )
	end

	-- Alert row that value changed
	ctrl.OnChange = function( ctrl, newval )

		if ( newval ) then newval = 1 else newval = 0 end

		self:ValueChanged( newval )

	end

end

derma.DefineControl( "DProperty_Boolean", "", PANEL, "DProperty_Generic" )