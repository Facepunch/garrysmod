
local ErrorNoHaltWithStack = ErrorNoHaltWithStack
local error = error
local baseclass = baseclass
local setmetatable = setmetatable
local SERVER = SERVER
local string = string
local table = table
local util = util
local pairs = pairs
local isstring = isstring
local type = type

module( "player_manager" )

-- Stores a table of valid player models
local ModelList = {}
local ModelNameDict = {}
local HandNames = {}

--[[---------------------------------------------------------
	Utility to add models to the acceptable model list
-----------------------------------------------------------]]
function AddValidModel( name, model, title, category )

	-- Badly made existing addons
	if ( name != nil && !isstring( name ) ) then ErrorNoHaltWithStack( "player_manager.AddValidModel - bad argument #3 (string expected, got " .. type( name ) .. ")" ) title = nil end
	if ( category != nil && !isstring( category ) ) then ErrorNoHaltWithStack( "player_manager.AddValidModel - bad argument #4 (string expected, got " .. type( category ) .. ")" ) category = nil end

	ModelList[ name ] = { model = model, title = title or name, category = category or "#spawnmenu.category.other" }
	ModelNameDict[ string.lower( model ) ] = name

end

--
-- Valid hands
--
function AddValidHands( name, model, skin, body, matchBodySkin )

	HandNames[ name ] = { model = model, skin = skin or 0, body = body or "0000000", matchBodySkin = matchBodySkin or false }

end

--[[---------------------------------------------------------
	Return list of all valid player models
-----------------------------------------------------------]]
function AllValidModels()

	local list = {}
	for name, data in pairs( ModelList ) do
		list[ name ] = data.model
	end
	return list

end

function GetAllPlayerModels()

	return table.Copy( ModelList )

end

--[[---------------------------------------------------------
	Remove a player model
-----------------------------------------------------------]]
function RemoveValidModel( name )

	if ( !isstring( name ) ) then error( "bad argument #1 to 'RemoveValidModel' (string expected, got " .. type( name ) .. ")", 2 ) end
	if ( !ModelList[ name ] ) then return end

	local modelPath = string.lower( ModelList[ name ].model )
	ModelList[ name ] = nil
	HandNames[ name ] = nil
	ModelNameDict[ modelPath ] = nil

end

--[[---------------------------------------------------------
	Translate the simple name of a model
	into the full model name
-----------------------------------------------------------]]
function TranslatePlayerModel( name )

	if ( ModelList[ name ] != nil ) then
		return ModelList[ name ].model
	end

	return "models/player/kleiner.mdl"

end

-- Translate from the full model name to simple model name
function TranslateToPlayerModelName( model )

	model = string.lower( model )

	if ( ModelNameDict[ model ] != nil ) then
		return ModelNameDict[ model ]
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
	Compile a list of default valid player models
-----------------------------------------------------------]]

local Category = "Half-Life 2"
local HandsCitizen = "models/weapons/c_arms_citizen.mdl"
local HandsRefugee = "models/weapons/c_arms_refugee.mdl"
local HandsCombine = "models/weapons/c_arms_combine.mdl"

local function AddPlayerModel( name, title, model, handsModel, handsSkin, handsBody )
	AddValidModel( name, model, title, Category )
	if ( handsModel ) then AddValidHands( name, handsModel, handsSkin, handsBody ) end
end

-- Main cast
AddPlayerModel( "alyx",		"#npc_alyx",		"models/player/alyx.mdl",		HandsCitizen, 0, "0000000" )
AddPlayerModel( "breen",	"#npc_breen",		"models/player/breen.mdl",		HandsCitizen, 0, "0000000" )
AddPlayerModel( "eli",		"#npc_eli",			"models/player/eli.mdl",		HandsCitizen, 1, "0000000" ) -- Black skin
AddPlayerModel( "gman",		"#npc_gman",		"models/player/gman_high.mdl",	HandsCitizen, 0, "0000000" )
AddPlayerModel( "kleiner",	"#npc_kleiner",		"models/player/kleiner.mdl",	HandsCitizen, 0, "0000000" )
AddPlayerModel( "monk",		"#npc_monk",		"models/player/monk.mdl",		HandsCitizen, 0, "0000000" )
AddPlayerModel( "odessa",	"#npc_odessa",		"models/player/odessa.mdl",		HandsCitizen, 0, "0000000" )
AddPlayerModel( "barney",	"#npc_barney",		"models/player/barney.mdl",		HandsCombine, 0, "0000000" )
AddPlayerModel( "magnusson",		"#npc_magnusson",		"models/player/magnusson.mdl",		HandsCitizen, 0, "0000000" )
AddPlayerModel( "mossman",			"#npc_mossman",			"models/player/mossman.mdl",		HandsCitizen, 0, "0000000" )
AddPlayerModel( "mossmanarctic",	"#npc_mossman_arctic",	"models/player/mossman_arctic.mdl",	HandsCitizen, 0, "0100000" ) -- Gloves bodygroup

-- Baddies
AddPlayerModel( "combine",			"#npc_combine_s",			"models/player/combine_soldier.mdl",				HandsCombine, 0, "0000000" )
AddPlayerModel( "combineprison",	"#npc_combine_s_prison",	"models/player/combine_soldier_prisonguard.mdl",	HandsCombine, 0, "0000000" )
AddPlayerModel( "combineelite",		"#npc_combine_s_elite",		"models/player/combine_super_soldier.mdl",			HandsCombine, 0, "0000000" )
AddPlayerModel( "police",		"#npc_metropolice",			"models/player/police.mdl",				HandsCombine, 0, "0000000" )
AddPlayerModel( "policefem",	"#npc_metropolice_female",	"models/player/police_fem.mdl",			HandsCombine, 0, "0000000" )
AddPlayerModel( "stripped",		"#npc_combine_s_stripped",	"models/player/soldier_stripped.mdl",	HandsCitizen, 0, "0000000" )

Category = "Half-Life 2 - Zombies"
-- Zombies
AddPlayerModel( "charple",		"#plrmdl.charple",	"models/player/charple.mdl",		HandsCitizen, 2, "0000000" ) -- Bloody hands
AddPlayerModel( "corpse",		"#plrmdl.corpse",	"models/player/corpse1.mdl",		HandsCitizen, 2, "0000000" )
AddPlayerModel( "skeleton",		"#plrmdl.skeleton",	"models/player/skeleton.mdl",		HandsCitizen, 2, "0000000" )
AddPlayerModel( "zombie",		"#npc_zombie",		"models/player/zombie_classic.mdl",	HandsCitizen, 2, "0000000" )
AddPlayerModel( "zombiefast",	"#npc_fastzombie",	"models/player/zombie_fast.mdl",	HandsCitizen, 2, "0000000" )
AddPlayerModel( "zombine",		"#npc_zombine",		"models/player/zombie_soldier.mdl",	HandsCombine, 0, "0000000" )

Category = "Half-Life 2 - Citizens"
-- Citizens
AddPlayerModel( "female01", "#plrmdl.citizen_female_1", "models/player/Group01/female_01.mdl", HandsCitizen, 0, "0000000" )
AddPlayerModel( "female02", "#plrmdl.citizen_female_2", "models/player/Group01/female_02.mdl", HandsCitizen, 0, "0000000" )
AddPlayerModel( "female03", "#plrmdl.citizen_female_3", "models/player/Group01/female_03.mdl", HandsCitizen, 1, "0000000" )
AddPlayerModel( "female04", "#plrmdl.citizen_female_4", "models/player/Group01/female_04.mdl", HandsCitizen, 0, "0000000" )
AddPlayerModel( "female05", "#plrmdl.citizen_female_5", "models/player/Group01/female_05.mdl", HandsCitizen, 1, "0000000" )
AddPlayerModel( "female06", "#plrmdl.citizen_female_6", "models/player/Group01/female_06.mdl", HandsCitizen, 0, "0000000" )

AddPlayerModel( "female07", "#plrmdl.rebel_female_1", "models/player/Group03/female_01.mdl", HandsRefugee, 0, "0100000" )
AddPlayerModel( "female08", "#plrmdl.rebel_female_2", "models/player/Group03/female_02.mdl", HandsRefugee, 0, "0100000" )
AddPlayerModel( "female09", "#plrmdl.rebel_female_3", "models/player/Group03/female_03.mdl", HandsRefugee, 1, "0100000" )
AddPlayerModel( "female10", "#plrmdl.rebel_female_4", "models/player/Group03/female_04.mdl", HandsRefugee, 0, "0100000" )
AddPlayerModel( "female11", "#plrmdl.rebel_female_5", "models/player/Group03/female_05.mdl", HandsRefugee, 1, "0100000" )
AddPlayerModel( "female12", "#plrmdl.rebel_female_6", "models/player/Group03/female_06.mdl", HandsRefugee, 0, "0100000" )

AddPlayerModel( "male01", "#plrmdl.citizen_male_1", "models/player/Group01/male_01.mdl", HandsCitizen, 1, "0000000" )
AddPlayerModel( "male02", "#plrmdl.citizen_male_2", "models/player/Group01/male_02.mdl", HandsCitizen, 0, "0000000" )
AddPlayerModel( "male03", "#plrmdl.citizen_male_3", "models/player/Group01/male_03.mdl", HandsCitizen, 1, "0000000" )
AddPlayerModel( "male04", "#plrmdl.citizen_male_4", "models/player/Group01/male_04.mdl", HandsCitizen, 0, "0000000" )
AddPlayerModel( "male05", "#plrmdl.citizen_male_5", "models/player/Group01/male_05.mdl", HandsCitizen, 0, "0000000" )
AddPlayerModel( "male06", "#plrmdl.citizen_male_6", "models/player/Group01/male_06.mdl", HandsCitizen, 0, "0000000" )
AddPlayerModel( "male07", "#plrmdl.citizen_male_7", "models/player/Group01/male_07.mdl", HandsCitizen, 0, "0000000" )
AddPlayerModel( "male08", "#plrmdl.citizen_male_8", "models/player/Group01/male_08.mdl", HandsCitizen, 0, "0000000" )
AddPlayerModel( "male09", "#plrmdl.citizen_male_9", "models/player/Group01/male_09.mdl", HandsCitizen, 0, "0000000" )

AddPlayerModel( "male10", "#plrmdl.rebel_male_1", "models/player/Group03/male_01.mdl", HandsRefugee, 1, "0100000" )
AddPlayerModel( "male11", "#plrmdl.rebel_male_2", "models/player/Group03/male_02.mdl", HandsRefugee, 0, "0000000" )
AddPlayerModel( "male12", "#plrmdl.rebel_male_3", "models/player/Group03/male_03.mdl", HandsRefugee, 1, "0000000" )
AddPlayerModel( "male13", "#plrmdl.rebel_male_4", "models/player/Group03/male_04.mdl", HandsRefugee, 0, "0100000" )
AddPlayerModel( "male14", "#plrmdl.rebel_male_5", "models/player/Group03/male_05.mdl", HandsRefugee, 0, "0100000" )
AddPlayerModel( "male15", "#plrmdl.rebel_male_6", "models/player/Group03/male_06.mdl", HandsRefugee, 0, "0100000" )
AddPlayerModel( "male16", "#plrmdl.rebel_male_7", "models/player/Group03/male_07.mdl", HandsRefugee, 0, "0100000" )
AddPlayerModel( "male17", "#plrmdl.rebel_male_8", "models/player/Group03/male_08.mdl", HandsRefugee, 0, "0000000" )
AddPlayerModel( "male18", "#plrmdl.rebel_male_9", "models/player/Group03/male_09.mdl", HandsRefugee, 0, "0100000" )

AddPlayerModel( "medic01", "#plrmdl.medic_male_1", "models/player/Group03m/male_01.mdl", HandsRefugee, 1, "0100000" )
AddPlayerModel( "medic02", "#plrmdl.medic_male_2", "models/player/Group03m/male_02.mdl", HandsRefugee, 0, "0000000" )
AddPlayerModel( "medic03", "#plrmdl.medic_male_3", "models/player/Group03m/male_03.mdl", HandsRefugee, 1, "0100000" )
AddPlayerModel( "medic04", "#plrmdl.medic_male_4", "models/player/Group03m/male_04.mdl", HandsRefugee, 0, "0000000" )
AddPlayerModel( "medic05", "#plrmdl.medic_male_5", "models/player/Group03m/male_05.mdl", HandsRefugee, 0, "0100000" )
AddPlayerModel( "medic06", "#plrmdl.medic_male_6", "models/player/Group03m/male_06.mdl", HandsRefugee, 0, "0000000" )
AddPlayerModel( "medic07", "#plrmdl.medic_male_7", "models/player/Group03m/male_07.mdl", HandsRefugee, 0, "0000000" )
AddPlayerModel( "medic08", "#plrmdl.medic_male_8", "models/player/Group03m/male_08.mdl", HandsRefugee, 0, "0000000" )
AddPlayerModel( "medic09", "#plrmdl.medic_male_9", "models/player/Group03m/male_09.mdl", HandsRefugee, 0, "0000000" )
AddPlayerModel( "medic10", "#plrmdl.medic_female_1", "models/player/Group03m/female_01.mdl", HandsRefugee, 0, "0100000" )
AddPlayerModel( "medic11", "#plrmdl.medic_female_2", "models/player/Group03m/female_02.mdl", HandsRefugee, 0, "0000000" )
AddPlayerModel( "medic12", "#plrmdl.medic_female_3", "models/player/Group03m/female_03.mdl", HandsRefugee, 1, "0000000" )
AddPlayerModel( "medic13", "#plrmdl.medic_female_4", "models/player/Group03m/female_04.mdl", HandsRefugee, 0, "0100000" )
AddPlayerModel( "medic14", "#plrmdl.medic_female_5", "models/player/Group03m/female_05.mdl", HandsRefugee, 0, "0100000" )
AddPlayerModel( "medic15", "#plrmdl.medic_female_6", "models/player/Group03m/female_06.mdl", HandsRefugee, 1, "0100000" )

AddPlayerModel( "refugee01", "#plrmdl.refugee_male_1", "models/player/Group02/male_02.mdl", HandsCitizen, 0, "0000000" )
AddPlayerModel( "refugee02", "#plrmdl.refugee_male_2", "models/player/Group02/male_04.mdl", HandsCitizen, 0, "0000000" )
AddPlayerModel( "refugee03", "#plrmdl.refugee_male_3", "models/player/Group02/male_06.mdl", HandsCitizen, 0, "0000000" )
AddPlayerModel( "refugee04", "#plrmdl.refugee_male_4", "models/player/Group02/male_08.mdl", HandsCitizen, 0, "0000000" )

--
-- Game specific player models! (EP2, CSS, DOD)
-- Moving them to here since we're now shipping all required files / fallbacks
--

Category = "Counter-Strike"
local HandsCSS = "models/weapons/c_arms_cstrike.mdl"
AddPlayerModel( "hostage01",	"#plrmdl.css_hostage1",	"models/player/hostage/hostage_01.mdl" )
AddPlayerModel( "hostage02",	"#plrmdl.css_hostage2",	"models/player/hostage/hostage_02.mdl" )
AddPlayerModel( "hostage03",	"#plrmdl.css_hostage3",	"models/player/hostage/hostage_03.mdl" )
AddPlayerModel( "hostage04",	"#plrmdl.css_hostage4",	"models/player/hostage/hostage_04.mdl" )

AddPlayerModel( "css_arctic",	"#plrmdl.css_arctic",	"models/player/arctic.mdl",		HandsCSS, 0, "0000000" )
AddPlayerModel( "css_gasmask",	"#plrmdl.css_gasmask",	"models/player/gasmask.mdl",	HandsCSS, 0, "0000000" )
AddPlayerModel( "css_guerilla",	"#plrmdl.css_guerilla",	"models/player/guerilla.mdl",	HandsCSS, 0, "0000000" )
AddPlayerModel( "css_leet",		"#plrmdl.css_leet",		"models/player/leet.mdl",		HandsCSS, 0, "0000000" )
AddPlayerModel( "css_phoenix",	"#plrmdl.css_phoenix",	"models/player/phoenix.mdl",	HandsCSS, 0, "0000000" )
AddPlayerModel( "css_riot",		"#plrmdl.css_riot",		"models/player/riot.mdl",		HandsCSS, 0, "0000000" )
AddPlayerModel( "css_swat",		"#plrmdl.css_swat",		"models/player/swat.mdl",		HandsCSS, 0, "0000000" )
AddPlayerModel( "css_urban",	"#plrmdl.css_urban",	"models/player/urban.mdl",		HandsCSS, 0, "0000000" )

Category = nil
--Category = "Portal"
AddPlayerModel( "chell", "#plrmdl.chell", "models/player/p2_chell.mdl", "models/weapons/c_arms_chell.mdl", 0, "0000000" )

--Category = "Day of Defeat: Source"
AddPlayerModel( "dod_german",	"#plrmdl.dod_german",	"models/player/dod_german.mdl",		"models/weapons/c_arms_dod.mdl", 0, "0000000" )
AddPlayerModel( "dod_american",	"#plrmdl.dod_american",	"models/player/dod_american.mdl",	"models/weapons/c_arms_dod.mdl", 1, "0000000" )


--
-- Player Class Stuff
--

local Type = {}

function GetPlayerClasses()

	return table.Copy( Type )

end

function GetStoredPlayerClass( name )

	return Type[ name ]

end

local function LookupPlayerClass( ply )

	local id = ply:GetClassID()
	if ( id == 0 ) then return end

	--
	-- Check the cache
	--
	local plyClass = ply.m_CurrentPlayerClass
	if ( plyClass && plyClass.Player == ply ) then
		if ( plyClass.ClassID == id && plyClass.Func ) then return plyClass end -- current class is still good, behave normally
		if ( plyClass.ClassChanged ) then plyClass:ClassChanged() end -- the class id changed, remove the old class
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

	local newClass = {
		Player = ply,
		ClassID = id,
		Func = function() end
	}

	setmetatable( newClass, { __index = t } )

	ply.m_CurrentPlayerClass = newClass

	-- TODO: We probably want to reset previous DTVar stuff on the player
	newClass.Player:InstallDataTable()
	newClass:SetupDataTables()
	newClass:Init()
	return newClass

end

function RegisterClass( name, tab, base )

	Type[ name ] = tab

	--
	-- If we have a base method then hook
	-- it up in the meta table
	--
	if ( base ) then

		if ( !Type[ name ] ) then ErrorNoHaltWithStack( "RegisterClass - deriving " .. name .. " from unknown class " .. base .. "!" ) end
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

	if ( !Type[ classname ] ) then ErrorNoHaltWithStack( "SetPlayerClass - attempt to use unknown player class " .. classname .. "!" ) end

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

function GetPlayerClassTable( ply )

	local id = ply:GetClassID()
	if ( id == 0 ) then return end

	local ct = Type[ util.NetworkIDToString( id ) ]
	if ( !ct ) then return end

	return table.Copy( ct )

end

function ClearPlayerClass( ply )

	ply:SetClassID( 0 )

end

function RunClass( ply, funcname, ... )

	local class = LookupPlayerClass( ply )
	if ( !class ) then return end

	local func = class[ funcname ]
	if ( !func ) then ErrorNoHaltWithStack( "Function " .. funcname .. " not found on player class!" ) return end

	return func( class, ... )

end

--
-- Should be called on spawn automatically to set the variables below
-- This is called in the base gamemode :PlayerSpawn function
--
function OnPlayerSpawn( ply, transiton )

	local class = LookupPlayerClass( ply )
	if ( !class ) then return end

	ply:SetSlowWalkSpeed( class.SlowWalkSpeed )
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
		ply:SetMaxArmor( class.MaxArmor )
		ply:SetHealth( class.StartHealth )
		ply:SetArmor( class.StartArmor )
	end

end
