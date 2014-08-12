local PANEL = {}

function PANEL:Init()
end

function PANEL:Setup( vars )
	
	self:Clear()
	
	local combo = vgui.Create( "DComboBox", self )
	combo:Dock( FILL )
	combo:SetValue( vars or "Select..." )
	
	self.IsEditing = function( self )
		return combo:IsMenuOpen()
	end
	
	self.SetValue = function( self, id )
		combo:ChooseOptionID( id )
	end
	
	combo.OnSelect = function( _, id, val, data )
		self:ValueChanged( { Index = id, Value = val, Data = data }, true )
	end
	
	combo.Paint = function( combo, w, h )
		
		if self:IsEditing() or self:GetRow():IsHovered() or self:GetRow():IsChildHovered( 6 ) then
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
