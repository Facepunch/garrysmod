
local ErrorNoHalt = ErrorNoHalt
local baseclass = baseclass
local setmetatable = setmetatable
local SERVER = SERVER
local string = string
local table = table
local util = util

module( "player_manager" )

-- Stores a table of valid player models
local ModelList = {}
local ModelListRev = {}
local HandNames = {}

--[[---------------------------------------------------------
	Utility to add models to the acceptable model list
-----------------------------------------------------------]]
function AddValidModel( name, model )

	ModelList[ name ] = model
	ModelListRev[ string.lower( model ) ] = name

end

--
-- Valid hands
--
function AddValidHands( name, model, skin, body )

	HandNames[ name ] = { model = model, skin = skin, body = body }

end

--[[---------------------------------------------------------
	Return list of all valid player models
-----------------------------------------------------------]]
function AllValidModels( )
	return ModelList
end


--[[---------------------------------------------------------
	Translate the simple name of a model
	into the full model name
-----------------------------------------------------------]]
function TranslatePlayerModel( name )

	if ( ModelList[ name ] != nil ) then
		return ModelList[ name ]
	end

	return "models/player/kleiner.mdl"
end

-- Translate from the full model name to simple model name
function TranslateToPlayerModelName( model )

	model = string.lower( model )

	if ( ModelListRev[ model ] != nil ) then
		return ModelListRev[ model ]
	end

	return "kleiner"
end

--
-- Translate hands based on model
--
function TranslatePlayerHands( name )

	if ( HandNames[ name ] != nil ) then
		return HandNames[ name ]
	end

	return { model = "models/weapons/c_arms_citizen.mdl", skin = 0, body = "100000000" }
end

--[[---------------------------------------------------------
	Compile a list of valid player models
-----------------------------------------------------------]]

AddValidModel( "alyx",			"models/player/alyx.mdl" )
AddValidHands( "alyx",			"models/weapons/c_arms_citizen.mdl",		0, "0000000" )

AddValidModel( "barney",		"models/player/barney.mdl" )
AddValidHands( "barney",		"models/weapons/c_arms_combine.mdl",		0, "0000000" )

AddValidModel( "breen",			"models/player/breen.mdl" )
AddValidHands( "breen",			"models/weapons/c_arms_citizen.mdl",		0, "0000000" )

AddValidModel( "charple",		"models/player/charple.mdl" )
AddValidHands( "charple",		"models/weapons/c_arms_citizen.mdl",		2, "0000000" )

AddValidModel( "chell",			"models/player/p2_chell.mdl" )
AddValidHands( "chell",			"models/weapons/c_arms_chell.mdl",			0, "0000000" )

AddValidModel( "corpse",		"models/player/corpse1.mdl" )
AddValidHands( "corpse",		"models/weapons/c_arms_citizen.mdl",		2, "0000000" )

AddValidModel( "combine",		"models/player/combine_soldier.mdl" )
AddValidHands( "combine",		"models/weapons/c_arms_combine.mdl",		0, "0000000" )

AddValidModel( "combineprison",	"models/player/combine_soldier_prisonguard.mdl" )
AddValidHands( "combineprison",	"models/weapons/c_arms_combine.mdl",		0, "0000000" )

AddValidModel( "combineelite",	"models/player/combine_super_soldier.mdl" )
AddValidHands( "combineelite",	"models/weapons/c_arms_combine.mdl",		0, "0000000" )

AddValidModel( "eli",			"models/player/eli.mdl" )
AddValidHands( "eli",			"models/weapons/c_arms_citizen.mdl",		1, "0000000" )

AddValidModel( "gman",			"models/player/gman_high.mdl" )
AddValidHands( "gman",			"models/weapons/c_arms_citizen.mdl",		0, "0000000" )

AddValidModel( "kleiner",		"models/player/kleiner.mdl" )
AddValidHands( "kleiner",		"models/weapons/c_arms_citizen.mdl",		0, "0000000" )

AddValidModel( "monk",			"models/player/monk.mdl" )
AddValidHands( "monk",		"models/weapons/c_arms_citizen.mdl",			0, "0000000" )

AddValidModel( "mossman",		"models/player/mossman.mdl" )
AddValidHands( "mossman",		"models/weapons/c_arms_citizen.mdl",		0, "0000000" )

AddValidModel( "mossmanarctic",	"models/player/mossman_arctic.mdl" )
AddValidHands( "mossmanarctic",	"models/weapons/c_arms_citizen.mdl",		0, "0000000" )

AddValidModel( "odessa",		"models/player/odessa.mdl" )
AddValidHands( "odessa",		"models/weapons/c_arms_citizen.mdl",		0, "0000000" )

AddValidModel( "police",		"models/player/police.mdl" )
AddValidHands( "police",		"models/weapons/c_arms_combine.mdl",		0, "0000000" )

AddValidModel( "policefem",		"models/player/police_fem.mdl" )
AddValidHands( "policefem",		"models/weapons/c_arms_combine.mdl",		0, "0000000" )

AddValidModel( "magnusson",		"models/player/magnusson.mdl" )
AddValidHands( "magnusson",		"models/weapons/c_arms_citizen.mdl",		0, "0000000" )

AddValidModel( "stripped",		"models/player/soldier_stripped.mdl" )
AddValidHands( "stripped",		"models/weapons/c_arms_hev.mdl",			2, "0000000" )

AddValidModel( "zombie",		"models/player/zombie_classic.mdl" )
AddValidHands( "zombie",		"models/weapons/c_arms_citizen.mdl",		2, "0000000" )

AddValidModel( "zombiefast",	"models/player/zombie_fast.mdl" )
AddValidHands( "zombiefast",	"models/weapons/c_arms_citizen.mdl",		2, "0000000" )

AddValidModel( "female01",		"models/player/Group01/female_01.mdl" )
AddValidHands( "female01",		"models/weapons/c_arms_citizen.mdl",		0, "0000000" )
AddValidModel( "female02",		"models/player/Group01/female_02.mdl" )
AddValidHands( "female02",		"models/weapons/c_arms_citizen.mdl",		0, "0000000" )
AddValidModel( "female03",		"models/player/Group01/female_03.mdl" )
AddValidHands( "female03",		"models/weapons/c_arms_citizen.mdl",		1, "0000000" )
AddValidModel( "female04",		"models/player/Group01/female_04.mdl" )
AddValidHands( "female04",		"models/weapons/c_arms_citizen.mdl",		0, "0000000" )
AddValidModel( "female05",		"models/player/Group01/female_05.mdl" )
AddValidHands( "female05",		"models/weapons/c_arms_citizen.mdl",		1, "0000000" )
AddValidModel( "female06",		"models/player/Group01/female_06.mdl" )
AddValidHands( "female06",		"models/weapons/c_arms_citizen.mdl",		0, "0000000" )

AddValidModel( "female07",		"models/player/Group03/female_01.mdl" )
AddValidHands( "female07",		"models/weapons/c_arms_refugee.mdl",		0, "0100000" )
AddValidModel( "female08",		"models/player/Group03/female_02.mdl" )
AddValidHands( "female08",		"models/weapons/c_arms_refugee.mdl",		0, "0100000" )
AddValidModel( "female09",		"models/player/Group03/female_03.mdl" )
AddValidHands( "female09",		"models/weapons/c_arms_refugee.mdl",		1, "0100000" )
AddValidModel( "female10",		"models/player/Group03/female_04.mdl" )
AddValidHands( "female10",		"models/weapons/c_arms_refugee.mdl",		0, "0100000" )
AddValidModel( "female11",		"models/player/Group03/female_05.mdl" )
AddValidHands( "female11",		"models/weapons/c_arms_refugee.mdl",		1, "0100000" )
AddValidModel( "female12",		"models/player/Group03/female_06.mdl" )
AddValidHands( "female12",		"models/weapons/c_arms_refugee.mdl",		0, "0100000" )

AddValidModel( "male01",		"models/player/Group01/male_01.mdl" )
AddValidHands( "male01",		"models/weapons/c_arms_citizen.mdl",		1, "0000000" )
AddValidModel( "male02",		"models/player/Group01/male_02.mdl" )
AddValidHands( "male02",		"models/weapons/c_arms_citizen.mdl",		0, "0000000" )
AddValidModel( "male03",		"models/player/Group01/male_03.mdl" )
AddValidHands( "male03",		"models/weapons/c_arms_citizen.mdl",		1, "0000000" )
AddValidModel( "male04",		"models/player/Group01/male_04.mdl" )
AddValidHands( "male04",		"models/weapons/c_arms_citizen.mdl",		0, "0000000" )
AddValidModel( "male05",		"models/player/Group01/male_05.mdl" )
AddValidHands( "male05",		"models/weapons/c_arms_citizen.mdl",		0, "0000000" )
AddValidModel( "male06",		"models/player/Group01/male_06.mdl" )
AddValidHands( "male06",		"models/weapons/c_arms_citizen.mdl",		0, "0000000" )
AddValidModel( "male07",		"models/player/Group01/male_07.mdl" )
AddValidHands( "male07",		"models/weapons/c_arms_citizen.mdl",		0, "0000000" )
AddValidModel( "male08",		"models/player/Group01/male_08.mdl" )
AddValidHands( "male08",		"models/weapons/c_arms_citizen.mdl",		0, "0000000" )
AddValidModel( "male09",		"models/player/Group01/male_09.mdl" )
AddValidHands( "male09",		"models/weapons/c_arms_citizen.mdl",		0, "0000000" )

AddValidModel( "male10",		"models/player/Group03/male_01.mdl" )
AddValidHands( "male10",		"models/weapons/c_arms_refugee.mdl",		1, "0100000" )
AddValidModel( "male11",		"models/player/Group03/male_02.mdl" )
AddValidHands( "male11",		"models/weapons/c_arms_refugee.mdl",		0, "0100000" )
AddValidModel( "male12",		"models/player/Group03/male_03.mdl" )
AddValidHands( "male12",		"models/weapons/c_arms_refugee.mdl",		1, "0100000" )
AddValidModel( "male13",		"models/player/Group03/male_04.mdl" )
AddValidHands( "male13",		"models/weapons/c_arms_refugee.mdl",		0, "0100000" )
AddValidModel( "male14",		"models/player/Group03/male_05.mdl" )
AddValidHands( "male14",		"models/weapons/c_arms_refugee.mdl",		0, "0100000" )
AddValidModel( "male15",		"models/player/Group03/male_06.mdl" )
AddValidHands( "male15",		"models/weapons/c_arms_refugee.mdl",		0, "0100000" )
AddValidModel( "male16",		"models/player/Group03/male_07.mdl" )
AddValidHands( "male16",		"models/weapons/c_arms_refugee.mdl",		0, "0100000" )
AddValidModel( "male17",		"models/player/Group03/male_08.mdl" )
AddValidHands( "male17",		"models/weapons/c_arms_refugee.mdl",		0, "0100000" )
AddValidModel( "male18",		"models/player/Group03/male_09.mdl" )
AddValidHands( "male18",		"models/weapons/c_arms_refugee.mdl",		0, "0100000" )

AddValidModel( "medic01",		"models/player/Group03m/male_01.mdl" )
AddValidHands( "medic01",		"models/weapons/c_arms_refugee.mdl",		1, "0100000" )
AddValidModel( "medic02",		"models/player/Group03m/male_02.mdl" )
AddValidHands( "medic02",		"models/weapons/c_arms_refugee.mdl",		0, "0000000" )
AddValidModel( "medic03",		"models/player/Group03m/male_03.mdl" )
AddValidHands( "medic03",		"models/weapons/c_arms_refugee.mdl",		1, "0100000" )
AddValidModel( "medic04",		"models/player/Group03m/male_04.mdl" )
AddValidHands( "medic04",		"models/weapons/c_arms_refugee.mdl",		0, "0000000" )
AddValidModel( "medic05",		"models/player/Group03m/male_05.mdl" )
AddValidHands( "medic05",		"models/weapons/c_arms_refugee.mdl",		0, "0100000" )
AddValidModel( "medic06",		"models/player/Group03m/male_06.mdl" )
AddValidHands( "medic06",		"models/weapons/c_arms_refugee.mdl",		0, "0000000" )
AddValidModel( "medic07",		"models/player/Group03m/male_07.mdl" )
AddValidHands( "medic07",		"models/weapons/c_arms_refugee.mdl",		0, "0000000" )
AddValidModel( "medic08",		"models/player/Group03m/male_08.mdl" )
AddValidHands( "medic08",		"models/weapons/c_arms_refugee.mdl",		0, "0000000" )
AddValidModel( "medic09",		"models/player/Group03m/male_09.mdl" )
AddValidHands( "medic09",		"models/weapons/c_arms_refugee.mdl",		0, "0000000" )
AddValidModel( "medic10",		"models/player/Group03m/female_01.mdl" )
AddValidHands( "medic10",		"models/weapons/c_arms_refugee.mdl",		0, "0100000" )
AddValidModel( "medic11",		"models/player/Group03m/female_02.mdl" )
AddValidHands( "medic11",		"models/weapons/c_arms_refugee.mdl",		0, "0000000" )
AddValidModel( "medic12",		"models/player/Group03m/female_03.mdl" )
AddValidHands( "medic12",		"models/weapons/c_arms_refugee.mdl",		1, "0000000" )
AddValidModel( "medic13",		"models/player/Group03m/female_04.mdl" )
AddValidHands( "medic13",		"models/weapons/c_arms_refugee.mdl",		0, "0100000" )
AddValidModel( "medic14",		"models/player/Group03m/female_05.mdl" )
AddValidHands( "medic14",		"models/weapons/c_arms_refugee.mdl",		0, "0100000" )
AddValidModel( "medic15",		"models/player/Group03m/female_06.mdl" )
AddValidHands( "medic15",		"models/weapons/c_arms_refugee.mdl",		1, "0100000" )

AddValidModel( "refugee01",		"models/player/Group02/male_02.mdl" )
AddValidHands( "refugee01",		"models/weapons/c_arms_citizen.mdl",		0, "0000000" )
AddValidModel( "refugee02",		"models/player/Group02/male_04.mdl" )
AddValidHands( "refugee02",		"models/weapons/c_arms_citizen.mdl",		0, "0000000" )
AddValidModel( "refugee03",		"models/player/Group02/male_06.mdl" )
AddValidHands( "refugee03",		"models/weapons/c_arms_citizen.mdl",		0, "0000000" )
AddValidModel( "refugee04",		"models/player/Group02/male_08.mdl" )
AddValidHands( "refugee04",		"models/weapons/c_arms_citizen.mdl",		0, "0000000" )

--
-- Game specific player models! (EP2, CSS, DOD)
-- Moving them to here since we're now shipping all required files / fallbacks

AddValidModel( "magnusson", "models/player/magnusson.mdl" )
AddValidHands( "magnusson","models/weapons/c_arms_citizen.mdl", 0, "0000000" )
AddValidModel( "skeleton",	"models/player/skeleton.mdl" )
AddValidHands( "skeleton",	"models/weapons/c_arms_citizen.mdl", 2, "0000000" )
AddValidModel( "zombine",	"models/player/zombie_soldier.mdl" )
AddValidHands( "zombine",	"models/weapons/c_arms_combine.mdl", 0, "0000000" )

AddValidModel( "hostage01", "models/player/hostage/hostage_01.mdl" )
AddValidModel( "hostage02", "models/player/hostage/hostage_02.mdl" )
AddValidModel( "hostage03", "models/player/hostage/hostage_03.mdl" )
AddValidModel( "hostage04", "models/player/hostage/hostage_04.mdl" )

AddValidModel( "css_arctic",	"models/player/arctic.mdl" )
AddValidHands( "css_arctic",	"models/weapons/c_arms_cstrike.mdl", 0, "10000000" )
AddValidModel( "css_gasmask",	"models/player/gasmask.mdl" )
AddValidHands( "css_gasmask",	"models/weapons/c_arms_cstrike.mdl", 0, "10000000" )
AddValidModel( "css_guerilla",	"models/player/guerilla.mdl" )
AddValidHands( "css_guerilla",	"models/weapons/c_arms_cstrike.mdl", 0, "10000000" )
AddValidModel( "css_leet",		"models/player/leet.mdl" )
AddValidHands( "css_leet",		"models/weapons/c_arms_cstrike.mdl", 0, "10000000" )
AddValidModel( "css_phoenix",	"models/player/phoenix.mdl" )
AddValidHands( "css_phoenix",	"models/weapons/c_arms_cstrike.mdl", 0, "10000000" )
AddValidModel( "css_riot",		"models/player/riot.mdl" )
AddValidHands( "css_riot",		"models/weapons/c_arms_cstrike.mdl", 0, "10000000" )
AddValidModel( "css_swat",		"models/player/swat.mdl" )
AddValidHands( "css_swat",		"models/weapons/c_arms_cstrike.mdl", 0, "10000000" )
AddValidModel( "css_urban",		"models/player/urban.mdl" )
AddValidHands( "css_urban",		"models/weapons/c_arms_cstrike.mdl", 7, "10000000" )

AddValidModel( "dod_german", "models/player/dod_german.mdl" )
AddValidHands( "dod_german", "models/weapons/c_arms_dod.mdl", 0, "10000000" )
AddValidModel( "dod_american", "models/player/dod_american.mdl" )
AddValidHands( "dod_american", "models/weapons/c_arms_dod.mdl", 1, "10000000" )


--
-- Player Class Stuff
--

local Type = {}

function GetPlayerClasses()

	return table.Copy( Type )

end

local function LookupPlayerClass( ply )

	local id = ply:GetClassID()
	if ( id == 0 ) then return end

	--
	-- Check the cache
	--
	local method = ply.m_CurrentPlayerClass
	if ( method && method.Player == ply ) then
		if ( method.ClassID == id && method.Func ) then return method end -- current class is still good, behave normally
		if ( method.ClassChanged ) then method:ClassChanged() end -- the class id changed, remove the old class
	end

	--
	-- No class, lets create one
	--
	local classname = util.NetworkIDToString( id )
	if ( !classname ) then return end

	--
	-- Get that type. Fail if we don't have the type.
	--
	local t = Type[ classname ]
	if ( !t ) then return end

	local method = {}
	method.Player	= ply
	method.ClassID	= id
	method.Func		= function() end

	setmetatable( method, { __index = t } )

	ply.m_CurrentPlayerClass = method

	-- TODO: We probably want to reset previous DTVar stuff on the player
	method.Player:InstallDataTable()
	method:SetupDataTables()
	method:Init()
	return method

end

function RegisterClass( name, table, base )

	Type[ name ] = table

	--
	-- If we have a base method then hook
	-- it up in the meta table
	--
	if ( base ) then

		if ( !Type[ name ] ) then ErrorNoHalt( "RegisterClass - deriving " .. name .. " from unknown class " .. base .. "!\n" ) end
		setmetatable( Type[ name ], { __index = Type[ base ] } )

	end

	if ( SERVER ) then
		util.AddNetworkString( name )
	end

	--
	-- drive methods cooperate with the baseclass system
	-- /lua/includes/modules/baseclass.lua
	--
	baseclass.Set( name, Type[ name ] )

end

function SetPlayerClass( ply, classname )

	local t = Type[ classname ]
	if ( !Type[ classname ] ) then ErrorNoHalt( "SetPlayerClass - attempt to use unknown player class " .. classname .. "!\n" ) end

	local id = util.NetworkStringToID( classname )
	ply:SetClassID( id )

	-- Initialize the player class so the datatable and everything is set up
	-- This probably could be done better
	LookupPlayerClass( ply )

end

function GetPlayerClass( ply )

	local id = ply:GetClassID()
	if ( id == 0 ) then return end

	return util.NetworkIDToString( id )

end

function ClearPlayerClass( ply )

	ply:SetClassID( 0 )

end

function RunClass( ply, funcname, ... )

	local class = LookupPlayerClass( ply )
	if ( !class ) then return end

	local func = class[ funcname ]
	if ( !func ) then ErrorNoHalt( "Function " .. funcname .. " not found on player class!\n" ) return end

	return func( class, ... )

end

--
-- Should be called on spawn automatically to set the variables below
-- This is called in the base gamemode :PlayerSpawn function
--
function OnPlayerSpawn( ply, transiton )

	local class = LookupPlayerClass( ply )
	if ( !class ) then return end

	ply:SetWalkSpeed( class.WalkSpeed )
	ply:SetRunSpeed( class.RunSpeed )
	ply:SetCrouchedWalkSpeed( class.CrouchedWalkSpeed )
	ply:SetDuckSpeed( class.DuckSpeed )
	ply:SetUnDuckSpeed( class.UnDuckSpeed )
	ply:SetJumpPower( class.JumpPower )
	ply:AllowFlashlight( class.CanUseFlashlight )
	ply:ShouldDropWeapon( class.DropWeaponOnDie )
	ply:SetNoCollideWithTeammates( class.TeammateNoCollide )
	ply:SetAvoidPlayers( class.AvoidPlayers )

	if ( !transiton ) then 
		ply:SetMaxHealth( class.MaxHealth )
		ply:SetHealth( class.StartHealth )
		ply:SetArmor( class.StartArmor )
	end

end
