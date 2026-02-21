
local PANEL = {}

DEFINE_BASECLASS( "DMenuOption" )

AccessorFunc( PANEL, "m_strConVar", "ConVar" )
AccessorFunc( PANEL, "m_strValueOn", "ValueOn" )
AccessorFunc( PANEL, "m_strValueOff", "ValueOff" )

function PANEL:Init()

	self:SetChecked( false )
	self:SetIsCheckable( true )

	self:SetValueOn( "1" )
	self:SetValueOff( "0" )
	self._NextThink = 0

end

function PANEL:Think()

	if ( !self.m_strConVar ) then return end
	if ( self._NextThink > RealTime() ) then return end

	local strValue = GetConVarString( self.m_strConVar )

	self:SetChecked( strValue == self.m_strValueOn )

end

function PANEL:OnChecked( b )

	if ( !self.m_strConVar ) then return end

	-- Give time for the cvar to update
	self._NextThink = RealTime() + 0.1

	if ( b ) then
		RunConsoleCommand( self.m_strConVar, self.m_strValueOn )
	else
		RunConsoleCommand( self.m_strConVar, self.m_strValueOff )
	end

end

derma.DefineControl( "DMenuOptionCVar", "", PANEL, "DMenuOption" )
