
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

end

function PANEL:SetConVar( strConVar )

	self.m_strConVar = strConVar
	self.m_ConVar = GetConVar( strConVar )

end

local justChecked = false
function PANEL:Think()

	if ( !self.m_strConVar ) then return end
	local strValue = self.m_ConVar:GetString()
	
	local b = strValue == self.m_strValueOn 
	if ( self:GetChecked() == b ) then return end

	if ( justChecked ) then
		justChecked = false
		return
	end

	self:SetChecked( b )

end

function PANEL:OnChecked( b )

	if ( !self.m_strConVar ) then return end

	if ( b ) then
		RunConsoleCommand( self.m_strConVar, self.m_strValueOn )
	else
		RunConsoleCommand( self.m_strConVar, self.m_strValueOff )
	end

	justChecked = true

end

derma.DefineControl( "DMenuOptionCVar", "", PANEL, "DMenuOption" )
