
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

	for id, thing in pairs( vars.values or {} ) do
		combo:AddChoice( id, thing )
	end
	
	self.IsEditing = function( self )
		return combo:IsMenuOpen()
	end
	
	self.SetValue = function( self, val )
		for id, data in pairs( combo.Data ) do
			if ( data == val ) then
				combo:ChooseOptionID( id )
			end
		end
	end
	
	combo.OnSelect = function( _, id, val, data )
		self:ValueChanged( data, true )
	end
	
	combo.Paint = function( combo, w, h )
		
		if self:IsEditing() or self:GetRow():IsHovered() or self:GetRow():IsChildHovered() then
			DComboBox.Paint( combo, w, h )
		end
		
	end

	self:GetRow().AddChoice = function( self, value, data, select )
		combo:AddChoice( value, data, select )
	end
	
	self:GetRow().SetSelected = function( self, id )
		combo:ChooseOptionID( id )
	end

end

derma.DefineControl( "DProperty_Combo", "", PANEL, "DProperty_Generic" )
