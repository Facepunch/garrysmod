--=============================================================================--
--  ___  ___   _   _   _    __   _   ___ ___ __ __
-- |_ _|| __| / \ | \_/ |  / _| / \ | o \ o \\ V /
--  | | | _| | o || \_/ | ( |_n| o ||   /   / \ /
--  |_| |___||_n_||_| |_|  \__/|_n_||_|\\_|\\ |_|  2012
--
--=============================================================================--

--
-- The default font used by everything Derma
--

if ( system.IsOSX() ) then

surface.CreateFont( "DermaDefault",
{
	font		= "Helvetica",
	size		= 13,
	antialias	= false,
	weight		= 500
})

surface.CreateFont( "DermaDefaultBold",
{
	font		= "Helvetica",
	size		= 13,
	antialias	= false,
	weight		= 800
})


else

surface.CreateFont( "DermaDefault",
{
	font		= "Tahoma",
	size		= 13,
	antialias	= true,
	weight		= 500
})

surface.CreateFont( "DermaDefaultBold",
{
	font		= "Tahoma",
	size		= 13,
	antialias	= false,
	weight		= 800
})

end

surface.CreateFont( "DermaLarge",
{
	font		= "Roboto",
	size		= 32,
	antialias	= true,
	weight		= 500
})

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

		if ( !self.m_strConVar ) then return end
		RunConsoleCommand( self.m_strConVar, tostring( strNewValue ) )

	end

	function PANEL:ConVarStringThink()

		if ( !self.m_strConVar ) then return end

		-- Todo: Think only every 0.1 seconds?

		local strValue = GetConVarString( self.m_strConVar )
		if ( self.m_strConVarValue == strValue ) then return end

		self.m_strConVarValue = strValue
		self:SetValue( self.m_strConVarValue )

	end

	function PANEL:ConVarNumberThink()

		if ( !self.m_strConVar ) then return end

		local strValue = GetConVarNumber( self.m_strConVar )
		if ( self.m_strConVarValue == strValue ) then return end

		self.m_strConVarValue = strValue
		self:SetValue( self.m_strConVarValue )

	end

end
