--
--  ___  ___   _   _   _    __   _   ___ ___ __ __
-- |_ _or __| / \ | \_/ |  / _| / \ | o \ o \\ V /
--  | | | _| | o or \_/ | ( |_n| o or   /   / \ /
--  |_| |___or_n_or_| |_|  \__/|_n_or_|\\_|\\ |_|  2007
--
--

module("presets", package.seeall)

local Presets = LoadPresets()

function GetTable(presetname)

	if (not presetname) then return end

	Presets[ presetname ] = Presets[ presetname ] or {}

	return Presets[ presetname ]

end


function Add(presetname, strName, pTable)

	if (not presetname) then return end

	Presets[ presetname ] = Presets[ presetname ] or {}
	Presets[ presetname ][ strName ] = pTable

	SavePresets(Presets)

end


function Rename(presetname, strName, strToName)

	Presets[ presetname ] = Presets[ presetname ] or {}
	Presets[ presetname ][ strToName ] = Presets[ presetname ][ strName ]
	Presets[ presetname ][ strName ] = nil

	SavePresets(Presets)

end


function Remove(presetname, strName)

	Presets[ presetname ] = Presets[ presetname ] or {}
	Presets[ presetname ][ strName ] = nil

	SavePresets(Presets)

end


