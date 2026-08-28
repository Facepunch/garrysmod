
local PANEL = {}

AccessorFunc( PANEL, "m_iSelectedNumber", "SelectedNumber" )
AccessorFunc( PANEL, "m_iDefaultNumber", "DefaultNumber" )

Derma_Install_Convar_Functions( PANEL )

function PANEL:Init()

	self:SetSelectedNumber( 0 )
	self:SetDefaultNumber( 0 )
	self:SetSize( 60, 30 )

	self:SetTooltip( "#dbinder.help" )

end

function PANEL:UpdateText()

	local str = input.GetKeyName( self:GetSelectedNumber() )
	if ( !str ) then str = "#dbinder.none" end

	str = language.GetPhrase( str )

	self:SetText( str )

end

function PANEL:DoClick()

	self:SetText( "#dbinder.press_a_key" )
	input.StartKeyTrapping()
	self.Trapping = true

end

function PANEL:ResetToDefaultValue()

	local def = self:GetDefaultNumber()
	if ( def != 0 ) then self:SetValue( def ) end

end

function PANEL:DoMiddleClick()

	self:ResetToDefaultValue()

end

function PANEL:DoRightClick()

	
	local m = DermaMenu()
	if ( self:GetDefaultNumber() != 0 ) then m:AddOption( "#tool.reset_to_default", function() self:ResetToDefaultValue() end ):SetIcon( "icon16/arrow_rotate_clockwise.png" ) end
	m:AddOption( "#tool.clear", function() self:SetValue( 0 ) end ):SetIcon( "icon16/stop_cross.png" )
	m:Open()

end

function PANEL:SetSelectedNumber( iNum )

	self.m_iSelectedNumber = iNum
	self:ConVarChanged( iNum )
	self:UpdateText()
	self:OnChange( iNum )

end

function PANEL:SetConVar( strConVar )
	self.m_strConVar = strConVar

	if ( strConVar ) then
		local cvar = GetConVar( strConVar )
		if ( cvar ) then self:SetDefaultNumber( cvar:GetDefault() ) end
	end
end

function PANEL:Think()

	if ( input.IsKeyTrapping() and self.Trapping ) then

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

function PANEL:OnChange( iNum )
end

derma.DefineControl( "DBinder", "", PANEL, "DButton" )
