
local PANEL = {}

AccessorFunc( PANEL, "m_iSelectedNumber", "SelectedNumber" )

Derma_Install_Convar_Functions( PANEL )

function PANEL:Init()

	self:SetSelectedNumber( 0 )
	self:SetSize( 60, 30 )

end

function PANEL:UpdateText()

	local str = input.GetKeyName( self:GetSelectedNumber() )
	if ( !str ) then str = "NONE" end

	str = language.GetPhrase( str )

	self:SetText( str )

end

function PANEL:DoClick()

	self:SetText( "PRESS A KEY" )
	input.StartKeyTrapping()
	self.Trapping = true

end

function PANEL:DoRightClick()

	self:SetText( "NONE" )
	self:SetValue( 0 )

end

function PANEL:SetSelectedNumber( iNum )

	self.m_iSelectedNumber = iNum
	self:ConVarChanged( iNum )
	self:UpdateText()
	self:OnChange( iNum )

end

function PANEL:Think()

	if ( input.IsKeyTrapping() && self.Trapping ) then

		local code = input.CheckKeyTrapping()
		if ( code ) then

			if ( code == KEY_ESCAPE ) then

				self:SetValue( self:GetSelectedNumber() )

			else

				self:SetValue( code )

			end

			self.Trapping = false

		end

	end

	self:ConVarNumberThink()

end

function PANEL:SetValue( iNumValue )

	self:SetSelectedNumber( iNumValue )

end

function PANEL:GetValue()

	return self:GetSelectedNumber()

end

function PANEL:OnChange()
end

derma.DefineControl( "DBinder", "", PANEL, "DButton" )
