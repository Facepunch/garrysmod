--
--  ___  ___   _   _   _    __   _   ___ ___ __ __
-- |_ _|| __| / \ | \_/ |  / _| / \ | o \ o \\ V /
--  | | | _| | o || \_/ | ( |_n| o ||   /   / \ / 
--  |_| |___||_n_||_| |_|  \__/|_n_||_|\\_|\\ |_|  2007
--										 
--

module( "presets", package.seeall )

local Presets = LoadPresets()

function GetTable( presetname )

	if ( !presetname ) then return end
	
	Presets[ presetname ] = Presets[ presetname ] or {}
	
	return Presets[ presetname ]

end


function Add( presetname, strName, pTable )

	if ( !presetname ) then return end

	Presets[ presetname ] = Presets[ presetname ] or {}
	Presets[ presetname ][ strName ] = pTable
	
	SavePresets( Presets )

end


function Rename( presetname, strName, strToName )

	Presets[ presetname ] = Presets[ presetname ] or {}
	Presets[ presetname ][ strToName ] = Presets[ presetname ][ strName ]
	Presets[ presetname ][ strName ] = nil
	
	SavePresets( Presets )

end


function Remove( presetname, strName )

	Presets[ presetname ] = Presets[ presetname ] or {}
	Presets[ presetname ][ strName ] = nil
	
	SavePresets( Presets )

end


