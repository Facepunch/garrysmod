
--
-- prop_generic is the base for all other properties.
-- All the business should be done in :Setup using inline functions.
-- So when you derive from this class - you should ideally only override Setup.
--

local PANEL = {}

function PANEL:Init()
end

function PANEL:Setup( vars )

	self:Clear()

	local ctrl = self:Add( "DCheckBox" )
	ctrl:SetPos( 0, 2 )

	-- Return true if we're editing
	self.IsEditing = function( slf )
		return ctrl:IsEditing()
	end

	-- Enabled/disabled support
	self.IsEnabled = function( slf )
		return ctrl:IsEnabled()
	end
	self.SetEnabled = function( slf, b )
		ctrl:SetEnabled( b )
	end

	-- Set the value
	self.SetValue = function( slf, val )
		ctrl:SetChecked( tobool( val ) )
	end

	-- Alert row that value changed
	ctrl.OnChange = function( slf, newval )

		if ( newval ) then newval = 1 else newval = 0 end

		self:ValueChanged( newval )

	end

end

derma.DefineControl( "DProperty_Boolean", "", PANEL, "DProperty_Generic" )
