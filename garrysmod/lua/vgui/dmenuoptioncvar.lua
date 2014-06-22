--[[   _
    ( )
   _| |   __   _ __   ___ ___     _ _
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_)

	DMenuOptionCVar

--]]

PANEL = {}

DEFINE_BASECLASS( "DMenuOption" )

AccessorFunc( PANEL, "m_strConVar", "ConVar" )
AccessorFunc( PANEL, "m_strValueOn", "ValueOn" )
AccessorFunc( PANEL, "m_strValueOff", "ValueOff" )

--[[---------------------------------------------------------
   Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

	self:SetChecked( false )
	self:SetIsCheckable( true )

	self:SetValueOn( "1" )
	self:SetValueOff( "0" )

end

--[[---------------------------------------------------------
   Name: Think
-----------------------------------------------------------]]
function PANEL:Think()

	if ( !self.m_strConVar ) then return end
	local strValue = GetConVarString( self.m_strConVar )

	self:SetChecked( strValue == self.m_strValueOn )

end

--[[---------------------------------------------------------
   Name: OnChecked
-----------------------------------------------------------]]
function PANEL:OnChecked( b )

	if ( !self.m_strConVar ) then return end

	if ( b ) then
		RunConsoleCommand( self.m_strConVar, self.m_strValueOn )
	else
		RunConsoleCommand( self.m_strConVar, self.m_strValueOff )
	end

end

derma.DefineControl( "DMenuOptionCVar", "", PANEL, "DMenuOption" )