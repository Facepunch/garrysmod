
local PANEL = {}

function PANEL:Init()
end

function PANEL:Setup( vars )

	vars = vars or {}

	self:Clear()

	local combo = vgui.Create( "DComboBox", self )
	combo:Dock( FILL )
	combo:DockMargin( 0, 1, 2, 2 )
	combo:SetValue( vars.text or "Select..." )

	local hasIcons, icon = istable( vars.icons )
	for id, thing in pairs( vars.values or {} ) do

		if ( hasIcons ) then
			icon = vars.icons[ id ]
		else
			icon = vars.icons
		end

		combo:AddChoice( id, thing, id == vars.select, icon )
	end

	self.IsEditing = function( slf )
		return combo:IsMenuOpen()
	end

	self.SetValue = function( slf, val )
		for id, data in pairs( combo.Data ) do
			if ( data == val ) then
				combo:ChooseOptionID( id )
			end
		end
	end

	combo.OnSelect = function( _, id, val, data )
		self:ValueChanged( data, true )
	end

	combo.Paint = function( slf, w, h )

		if ( self:IsEditing() or self:GetRow():IsHovered() or self:GetRow():IsChildHovered() ) then
			DComboBox.Paint( slf, w, h )
		end

	end

	self:GetRow().AddChoice = function( slf, value, data, select )
		combo:AddChoice( value, data, select )
	end

	self:GetRow().SetSelected = function( slf, id )
		combo:ChooseOptionID( id )
	end

	-- Enabled/disabled support
	self.IsEnabled = function( slf )
		return combo:IsEnabled()
	end
	self.SetEnabled = function( slf, b )
		combo:SetEnabled( b )
	end

end

derma.DefineControl( "DProperty_Combo", "", PANEL, "DProperty_Generic" )
