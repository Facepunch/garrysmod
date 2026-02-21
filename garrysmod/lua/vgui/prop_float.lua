
--
-- prop_generic is the base for all other properties.
-- All the business should be done in :Setup using inline functions.
-- So when you derive from this class - you should ideally only override Setup.
--

local PANEL = {}

function PANEL:Init()
end

function PANEL:GetDecimals()
	return 2
end

function PANEL:Setup( vars )

	self:Clear()

	vars = vars or {}

	local ctrl = self:Add( "DNumSlider" )
	ctrl:Dock( FILL )
	ctrl:SetDark( true )
	ctrl:SetDecimals( self:GetDecimals() )

	-- Apply vars
	ctrl:SetMin( vars.min or 0 )
	ctrl:SetMax( vars.max or 1 )

	-- The label needs mouse input so we can scratch
	self:GetRow().Label:SetMouseInputEnabled( true )
	-- Take the scratch and place it on the Row's label
	ctrl.Scratch:SetParent( self:GetRow().Label )
	-- Hide the numslider's label
	ctrl.Label:SetVisible( false )
	-- Move the text area to the left
	ctrl.TextArea:Dock( LEFT )
	-- Add a margin onto the slider - so it's not right up the side
	ctrl.Slider:DockMargin( 0, 3, 8, 3 )

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
		ctrl:SetValue( val )
	end

	-- Alert row that value changed
	ctrl.OnValueChanged = function( slf, newval )

		self:ValueChanged( newval )

	end

	self.Paint = function()

		-- PERFORMANCE !!!
		ctrl.Slider:SetVisible( self:IsEditing() or self:GetRow():IsChildHovered() )

	end

end

derma.DefineControl( "DProperty_Float", "", PANEL, "DProperty_Generic" )
