
--
-- The default font used by everything Derma
--

if ( system.IsLinux() ) then

	surface.CreateFont( "DermaDefault", {
		font		= "DejaVu Sans",
		size		= 14,
		weight		= 500,
		extended	= true
	} )

	surface.CreateFont( "DermaDefaultBold", {
		font		= "DejaVu Sans",
		size		= 14,
		weight		= 800,
		extended	= true
	} )

else

	surface.CreateFont( "DermaDefault", {
		font		= "Tahoma",
		size		= 13,
		weight		= 500,
		extended	= true
	} )

	surface.CreateFont( "DermaDefaultBold", {
		font		= "Tahoma",
		size		= 13,
		weight		= 800,
		extended	= true
	} )

end

surface.CreateFont( "DermaLarge", {
	font		= "Roboto",
	size		= 32,
	weight		= 500,
	extended	= true
} )

include( "derma.lua" )
include( "derma_example.lua" )
include( "derma_menus.lua" )
include( "derma_animation.lua" )
include( "derma_utils.lua" )
include( "derma_gwen.lua" )

function Derma_Hook( panel, functionname, hookname, typename )

	panel[ functionname ] = function ( self, a, b, c, d )
		return derma.SkinHook( hookname, typename, self, a, b, c, d )
	end

end

--[[

	ConVar Functions

	To associate controls with convars. The controls automatically
	update from the value of the control, and automatically update
	the value of the convar from the control.

	Controls must:

	Call ConVarStringThink or ConVarNumberThink from the
	Think function to get any changes from the ConVars.

	Have SetValue( value ) implemented, to receive the
	value.

--]]

function Derma_Install_Convar_Functions( PANEL )

	function PANEL:SetConVar( strConVar )
		self.m_strConVar = strConVar
	end

	function PANEL:ConVarChanged( strNewValue )

		if ( !self.m_strConVar || #self.m_strConVar < 2 ) then return end
		RunConsoleCommand( self.m_strConVar, tostring( strNewValue ) )

	end

	-- Todo: Think only every 0.1 seconds?
	function PANEL:ConVarStringThink()

		if ( !self.m_strConVar || #self.m_strConVar < 2 ) then return end

		local strValue = GetConVarString( self.m_strConVar )
		if ( self.m_strConVarValue == strValue ) then return end

		self.m_strConVarValue = strValue
		self:SetValue( self.m_strConVarValue )

	end

	function PANEL:ConVarNumberThink()

		if ( !self.m_strConVar || #self.m_strConVar < 2 ) then return end

		local numValue = GetConVarNumber( self.m_strConVar )

		-- In case the convar is a "nan"
		if ( numValue != numValue ) then return end
		if ( self.m_strConVarValue == numValue ) then return end

		self.m_strConVarValue = numValue
		self:SetValue( self.m_strConVarValue )

	end

end
