
local hook = hook
local player = player
local pairs = pairs
local Msg = Msg
local ErrorNoHalt = ErrorNoHalt
local baseclass = baseclass
local setmetatable = setmetatable
local SERVER = SERVER
local util = util

module( "player_manager" )


-- If a player doesn't have a valid model set they will use this one by default
local DefaultPlayerModel = "models/player/kleiner.mdl"

-- Stores a table of valid player models
local ModelList = {}

--[[---------------------------------------------------------
   Utility to add models to the acceptable model list
-----------------------------------------------------------]]
function AddValidModel( name, model )
	ModelList[ name ] = model
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
	
	return DefaultPlayerModel
end


--[[---------------------------------------------------------
   Compile a list of valid player models
-----------------------------------------------------------]]

AddValidModel( "alyx",		"models/player/alyx.mdl" )
AddValidModel( "barney",	"models/player/barney.mdl" )	
AddValidModel( "breen",		"models/player/breen.mdl" )	
AddValidModel( "charple",	"models/player/charple.mdl" )	
AddValidModel( "corpse",	"models/player/corpse1.mdl" )	
AddValidModel( "combine",	"models/player/combine_soldier.mdl" )				
AddValidModel( "combineprison",	"models/player/combine_soldier_prisonguard.mdl" )
AddValidModel( "combineelite",	"models/player/combine_super_soldier.mdl" )				
AddValidModel( "eli",		"models/player/eli.mdl" )			
AddValidModel( "gman",		"models/player/gman_high.mdl" )		
AddValidModel( "kleiner",	"models/player/kleiner.mdl" )
AddValidModel( "scientist",	"models/player/kleiner.mdl" )
AddValidModel( "monk",		"models/player/monk.mdl" )
AddValidModel( "mossman",	"models/player/mossman.mdl" )	
AddValidModel( "mossmanarctic",	"models/player/mossman_arctic.mdl" )	
AddValidModel( "gina",		"models/player/mossman.mdl" )
AddValidModel( "odessa",	"models/player/odessa.mdl" )		
AddValidModel( "police",	"models/player/police.mdl" )		
AddValidModel( "magnusson",	"models/player/magnusson.mdl" )
AddValidModel( "stripped",	"models/player/soldier_stripped.mdl" )
AddValidModel( "zombie",	"models/player/zombie_classic.mdl" )
AddValidModel( "zombiefast", "models/player/zombie_fast.mdl" )
AddValidModel( "zombine",	"models/player/zombie_soldier.mdl" )

AddValidModel( "female01",		"models/player/Group01/female_01.mdl" )
AddValidModel( "female02",		"models/player/Group01/female_02.mdl" )
AddValidModel( "female03",		"models/player/Group01/female_03.mdl" )
AddValidModel( "female04",		"models/player/Group01/female_04.mdl" )
AddValidModel( "female05",		"models/player/Group01/female_05.mdl" )
AddValidModel( "female06",		"models/player/Group01/female_06.mdl" )
AddValidModel( "female07",		"models/player/Group03/female_01.mdl" )
AddValidModel( "female08",		"models/player/Group03/female_02.mdl" )
AddValidModel( "female09",		"models/player/Group03/female_03.mdl" )
AddValidModel( "female10",		"models/player/Group03/female_04.mdl" )
AddValidModel( "female11",		"models/player/Group03/female_05.mdl" )
AddValidModel( "female12",		"models/player/Group03/female_06.mdl" )

AddValidModel( "male01",		"models/player/Group01/male_01.mdl" )
AddValidModel( "male02",		"models/player/Group01/male_02.mdl" )
AddValidModel( "male03",		"models/player/Group01/male_03.mdl" )
AddValidModel( "male04",		"models/player/Group01/male_04.mdl" )
AddValidModel( "male05",		"models/player/Group01/male_05.mdl" )
AddValidModel( "male06",		"models/player/Group01/male_06.mdl" )
AddValidModel( "male07",		"models/player/Group01/male_07.mdl" )
AddValidModel( "male08",		"models/player/Group01/male_08.mdl" )
AddValidModel( "male09",		"models/player/Group01/male_09.mdl" )

AddValidModel( "male10",		"models/player/Group03/male_01.mdl" )
AddValidModel( "male11",		"models/player/Group03/male_02.mdl" )
AddValidModel( "male12",		"models/player/Group03/male_03.mdl" )
AddValidModel( "male13",		"models/player/Group03/male_04.mdl" )
AddValidModel( "male14",		"models/player/Group03/male_05.mdl" )
AddValidModel( "male15",		"models/player/Group03/male_06.mdl" )
AddValidModel( "male16",		"models/player/Group03/male_07.mdl" )
AddValidModel( "male17",		"models/player/Group03/male_08.mdl" )
AddValidModel( "male18",		"models/player/Group03/male_09.mdl" )

AddValidModel( "refugee01",		"models/player/Group02/male_02.mdl" )
AddValidModel( "refugee02",		"models/player/Group02/male_04.mdl" )
AddValidModel( "refugee03",		"models/player/Group02/male_06.mdl" )
AddValidModel( "refugee04",		"models/player/Group02/male_08.mdl" )

--
-- Player Class Stuff
--

local Type = {}

function RegisterClass( name, table, base )

	Type[ name ] = table;

	--
	-- If we have a base method then hook 
	-- it up in the meta table
	--
	if ( base ) then

		if ( !Type[ name ] ) then ErrorNoHalt( "RegisterClass - deriving "..name.." from unknown class "..base.."!" ) end
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
	if ( !Type[ classname ] ) then ErrorNoHalt( "SetPlayerClass - attempt to use unknown player class "..classname ) end

	local id = util.NetworkStringToID( classname )
	ply:SetClassID( id )

end

function ClearPlayerClass( ply )

	ply:SetClassID( 0 )

end

local function LookupPlayerClass( ply )

	local id = ply:GetClassID()
	if ( id == 0 ) then return end

	--
	-- Check the cache
	--
	local method = ply.m_CurrentPlayerClass;
	if ( method && method.Player == ply && method.ClassID == id && method.Func ) then return method end

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

	ply.m_CurrentPlayerClass	= method

	method.Player:InstallDataTable();
	method:SetupDataTables()
	method:Init()
	return method

end

function RunClass( ply, funcname, ... )

	local class = LookupPlayerClass( ply )
	if ( !class ) then return end

	local func = class[funcname]
	if ( !func ) then ErrorNoHalt( "Function "..funcname.." not found on player class! " ) return end

	return func( class, ... )

end

--
-- Should be called on spawn automatically to set the variables below
-- This is called in the base gamemode :PlayerSpawn function
--
function OnPlayerSpawn( ply )

	local class = LookupPlayerClass( ply )
	if ( !class ) then return end

	ply:SetWalkSpeed( class.WalkSpeed )
	ply:SetRunSpeed( class.RunSpeed )
	ply:SetCrouchedWalkSpeed( class.CrouchedWalkSpeed )
	ply:SetDuckSpeed( class.DuckSpeed )
	ply:SetUnDuckSpeed( class.UnDuckSpeed )
	ply:SetJumpPower( class.JumpPower )
	ply:AllowFlashlight( class.CanUseFlashlight )
	ply:SetMaxHealth( class.MaxHealth )
	ply:SetHealth( class.StartHealth )
	ply:SetArmor( class.StartArmor )
	ply:ShouldDropWeapon( class.DropWeaponOnDie )
	ply:SetNoCollideWithTeammates( class.TeammateNoCollide )
	ply:SetAvoidPlayers( class.AvoidPlayers )

end