
local gmod			= gmod
local Msg			= Msg
local hook			= hook
local table			= table
local baseclass		= baseclass

--[[---------------------------------------------------------
	Name: gamemode
	Desc: A module to manage gamemodes
-----------------------------------------------------------]]
module( "gamemode" )

local GameList = {}

--[[---------------------------------------------------------
	Name: RegisterGamemode( table, string )
	Desc: Used to register your gamemode with the engine
-----------------------------------------------------------]]
function Register( t, name, derived )

	local CurrentGM = gmod.GetGamemode()

	if ( CurrentGM ) then

		if ( CurrentGM.FolderName == name ) then
			table.Merge( CurrentGM, t )
			Call( "OnReloaded" );
		end

		if ( CurrentGM.BaseClass && CurrentGM.BaseClass.FolderName == name ) then
			table.Merge( CurrentGM.BaseClass, t )
			Call( "OnReloaded" );
		end

	end

	-- This gives the illusion of inheritence
	if ( name != "base" ) then

		local basetable = Get( derived )
		if ( basetable ) then
			t = table.Inherit( t, basetable )
		else
			Msg( "Warning: Couldn't find derived gamemode (", derived, ")\n" )
		end

	end

	GameList[ name ] = t

	--
	-- Using baseclass for gamemodes kind of sucks, because
	-- the base gamemode is called "base" - and they have to all be unique.
	-- so here we prefix the gamemode name with "gamemode_" - and when using
	-- DEFINE_BASECLASS you're expected to do the same.
	--
	baseclass.Set( "gamemode_" .. name, t )

end

--[[---------------------------------------------------------
	Name: Get( string )
	Desc: Get a gamemode by name.
-----------------------------------------------------------]]
function Get( name )
	return GameList[ name ]
end

--[[---------------------------------------------------------
	Name: Call( name, args )
	Desc: Calls a gamemode function
-----------------------------------------------------------]]
function Call( name, ... )

	local CurrentGM = gmod.GetGamemode()

	-- If the gamemode function doesn't exist just return false
	if ( CurrentGM && CurrentGM[name] == nil ) then return false end

	return hook.Call( name, CurrentGM, ... )

end
