--[[   _
	( )
   _| |   __   _ __   ___ ___     _ _
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_)

	DBinder - Select and press a key

--]]
local PANEL = {}

AccessorFunc( PANEL, "m_iSelectedNumber", 		"SelectedNumber" )

Derma_Install_Convar_Functions( PANEL )

--[[---------------------------------------------------------
   Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

	self:SetSelected( 0 )
	self:SetSize( 60, 30 )

end

--[[---------------------------------------------------------
   Name: UpdateText
-----------------------------------------------------------]]
function PANEL:UpdateText()

	local str = input.GetKeyName( self.m_iSelectedNumber )
	if ( !str ) then str = "NONE" end

	str = language.GetPhrase( str )

	self:SetText( str )

end

--[[---------------------------------------------------------
   Name: DoClick
-----------------------------------------------------------]]
function PANEL:DoClick()

	self:SetText( "PRESS A KEY" )
	input.StartKeyTrapping()
	self.Trapping = true

end

--[[---------------------------------------------------------
   Name: DoRightClick
-----------------------------------------------------------]]
function PANEL:DoRightClick()

	self:SetText( "NONE" )
	self:SetValue( 0 )

end

--[[---------------------------------------------------------
   Name: SetSelected
-----------------------------------------------------------]]
function PANEL:SetSelected( iNum )

	self:SetSelectedNumber( iNum )
	self:ConVarChanged( iNum )
	self:UpdateText()

end

--[[---------------------------------------------------------
   Name: Think
-----------------------------------------------------------]]
function PANEL:Think()

	if ( input.IsKeyTrapping() && self.Trapping ) then

		local code = input.CheckKeyTrapping()
		if ( code ) then

			if ( code == KEY_ESCAPE ) then

				self:SetValue( self.m_iSelectedNumber )

			else

				self:SetValue( code )

			end


			self.Trapping = false
		end

	end

	self:ConVarNumberThink()

end

--[[---------------------------------------------------------
   Name: SetValue
-----------------------------------------------------------]]
function PANEL:SetValue( iNumValue )

	self:SetSelected( iNumValue )

end

--[[---------------------------------------------------------
   Name: GetValue
-----------------------------------------------------------]]
function PANEL:GetValue()

	return self:GetSelectedNumber()

end

derma.DefineControl( "DBinder", "", PANEL, "DButton" )
